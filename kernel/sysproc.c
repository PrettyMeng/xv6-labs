#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "date.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

extern pte_t *walk(pagetable_t, uint64, int);

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


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
  uint64 first_va;
  if (argaddr(0, &first_va) < 0) {
    return -1;
  }
  int num_page;
  if (argint(1, &num_page) < 0) {
    return -1;
  }
  if (num_page > 64) {
    num_page = 64;
  }
  uint64 result_mask;
  if (argaddr(2, &result_mask) < 0) {
    return -1;
  }
  uint64 kernel_result_mask = 0L;
  pagetable_t pagetable = myproc()->pagetable;
  for (int i = 0; i < num_page; i++) {
    pte_t *pte;
    pte = walk(pagetable, first_va + i * PGSIZE, 0);
    if ((*pte & PTE_V ) && (*pte & PTE_A)) {
      kernel_result_mask = kernel_result_mask | (0x1 << i);
      *pte = (*pte) & (~PTE_A);
    }
    // reset the access bit
  }
  if (copyout(pagetable, result_mask, (char *)&kernel_result_mask, sizeof(kernel_result_mask)) < 0) {
    printf("copyout fail");
    return -1;
  }
  return 0;
}
#endif

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
