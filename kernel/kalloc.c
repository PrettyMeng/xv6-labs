// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.
                
struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
  int reference_count[PHYSTOP / PGSIZE];
} kmem;

void 
change_reference_count(uint64 pa, int delta)
{
  acquire(&kmem.lock);
  kmem.reference_count[pa / PGSIZE] += delta;
  release(&kmem.lock);
}

void 
init_reference_count(uint64 pa)
{
  kmem.reference_count[pa / PGSIZE] = 1;
}

void
kinit()
{
  // initialize the reference count
  memset(kmem.reference_count, 0, sizeof(kmem.reference_count) / sizeof(int));
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  

  acquire(&kmem.lock);
  // Fill with junk to catch dangling refs.
  if (--(kmem.reference_count[(uint64)pa / PGSIZE]) <= 0) {
    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
      panic("kfree");
    memset(pa, 1, PGSIZE);

    r = (struct run*)pa;

    r->next = kmem.freelist;
    kmem.freelist = r;
  }

  release(&kmem.lock);

    
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
    kmem.reference_count[(uint64)r / PGSIZE] = 1;
  }
  
  release(&kmem.lock);


  return (void*)r;
}
