#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "fcntl.h"



uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_mmap(void)
{
  int length;
  if(argint(1, &length) < 0)
    return -1;
  int prot;
  if(argint(2, &prot) < 0)
    return -1;
  int flags;
  if(argint(3, &flags) < 0)
    return -1;
  int fd;
  if(argint(4, &fd) < 0)
    return -1;
  // offset is assumed to be 0.
  // if(argint(5, &offset) < 0)
  //   return -1;

  struct proc *p = myproc();

  struct file *file = p->ofile[fd];

  if (!file->readable && (prot & PROT_READ)) {
    return -1;
  }

  if (!file->writable && (prot & PROT_WRITE) && !(flags & MAP_PRIVATE)) {
    return -1;
  }
  
  for (int i = 0; i < VMA_SIZE; i++) {
    if (!p->VMAs[i].valid) {
      p->VMAs[i].valid = 1;
      p->VMAs[i].file = file;
      p->VMAs[i].size = length;
      p->VMAs[i].addr = PGROUNDDOWN(p->VMA_top - length);
      p->VMAs[i].permissions = prot;
      p->VMAs[i].flags = flags;
      p->VMA_top = p->VMAs[i].addr;
      // increment the reference count
      filedup(p->ofile[fd]);
      return p->VMAs[i].addr;
    }
  }

  panic("mmap: no free VMA");

  return -1;
  

}

uint64
sys_munmap(void)
{
  uint64 addr;
  if(argaddr(0, &addr) < 0)
    return -1;
  int length;
  if(argint(1, &length) < 0)
    return -1;

  struct proc *p = myproc();

  struct VMA *vma = 0;
  int found = 0;
  for (int i = 0; i < VMA_SIZE; i++) {
    if (p->VMAs[i].valid && addr >= p->VMAs[i].addr && addr <= p->VMAs[i].addr + p->VMAs[i].size) {
      vma = &p->VMAs[i];
      found = 1;
      break;
    }
  }
  if (!found) {
    panic("VMA not found?");
    return -1;
  }

  // printf("addr: %p", addr);

  if (vma->flags & MAP_SHARED) {
    filewrite(vma->file, addr, length);
  }

  uvmunmap(p->pagetable, addr, length / PGSIZE, 1);
  // in this lab, addr is only at start/end
  if (addr == vma->addr) {
    vma->addr += length;
    // printf("new addr: %p\n", vma->addr);

  }
  vma->size -= length;


  if (vma->size <= 0) {
    fileclose(vma->file);
    vma->valid = 0;
  }

  

  return 0;
}