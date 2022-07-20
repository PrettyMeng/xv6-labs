// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define HASH_SIZE 13
#define BUCKET_SIZE 10



struct bucket {
  struct spinlock lock;
  struct buf buf[BUCKET_SIZE];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.

  // for a hash table, the linked list data structure is not necessary any more.
  // struct buf head;
};

struct bucket bcache_table[HASH_SIZE];

// a simple hash function
uint
hash(int blockno)
{
  return blockno % HASH_SIZE;
}

void
binit(void)
{
  struct buf *b;

  for (int i = 0; i < HASH_SIZE; i++) {
    initlock(&bcache_table[i].lock, "bcache bucket");
    for(b = bcache_table[i].buf; b < bcache_table[i].buf+BUCKET_SIZE; b++){
      // Initialize the sleep lock and the timestamp
      initsleeplock(&b->lock, "buffer");
      b->timestamp = 0;

      // b->next = bcache.head.next;
      // b->prev = &bcache.head;
      // bcache.head.next->prev = b;
      // bcache.head.next = b;
    }
  }

  // Create linked list of buffers
  // bcache.head.prev = &bcache.head;
  // bcache.head.next = &bcache.head;
    
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  uint bucket_idx = hash(blockno);

  acquire(&bcache_table[bucket_idx].lock);

  // Is the block already cached?
  // A linear scan in the hash bucket
  for (b = bcache_table[bucket_idx].buf; b < bcache_table[bucket_idx].buf+BUCKET_SIZE; b++){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache_table[bucket_idx].lock);
      acquiresleep(&b->lock);
      return b;
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.

  uint lru_time = ~0x0;
  int lru_idx = -1;

  for (int i = 0; i < BUCKET_SIZE; i++) {
    b = &bcache_table[bucket_idx].buf[i];
    if (b->refcnt == 0 && b->timestamp < lru_time) {
      lru_time = b->timestamp;
      lru_idx = i;
    }
  }

  // If find an empty slot
  if (lru_idx != -1) {
    b = &bcache_table[bucket_idx].buf[lru_idx];
    b->dev = dev;
    b->blockno = blockno;
    b->valid = 0;
    b->refcnt = 1;
    release(&bcache_table[bucket_idx].lock);
    acquiresleep(&b->lock);
    return b;
  }

  release(&bcache_table[bucket_idx].lock);
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  b->refcnt--;
  // update the timestamp before release
  if (b->refcnt == 0) {
    b->timestamp = ticks;
  }
  
}

void
bpin(struct buf *b) {
  uint bucket_idx = hash(b->blockno);
  acquire(&bcache_table[bucket_idx].lock);
  b->refcnt++;
  release(&bcache_table[bucket_idx].lock);
}

void
bunpin(struct buf *b) {
  uint bucket_idx = hash(b->blockno);
  acquire(&bcache_table[bucket_idx].lock);
  b->refcnt--;
  release(&bcache_table[bucket_idx].lock);
}


