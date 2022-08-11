
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00028117          	auipc	sp,0x28
    80000004:	14010113          	addi	sp,sp,320 # 80028140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	28d050ef          	jal	ra,80005aa2 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00030797          	auipc	a5,0x30
    80000034:	21078793          	addi	a5,a5,528 # 80030240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	42e080e7          	jalr	1070(ra) # 80006488 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	4ce080e7          	jalr	1230(ra) # 8000653c <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	ec6080e7          	jalr	-314(ra) # 80005f50 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	302080e7          	jalr	770(ra) # 800063f8 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00030517          	auipc	a0,0x30
    80000106:	13e50513          	addi	a0,a0,318 # 80030240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	35a080e7          	jalr	858(ra) # 80006488 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	3f6080e7          	jalr	1014(ra) # 8000653c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	3cc080e7          	jalr	972(ra) # 8000653c <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffcedc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	b18080e7          	jalr	-1256(ra) # 80000e40 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00009717          	auipc	a4,0x9
    80000334:	cd070713          	addi	a4,a4,-816 # 80009000 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	afc080e7          	jalr	-1284(ra) # 80000e40 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	c44080e7          	jalr	-956(ra) # 80005f9a <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	7e0080e7          	jalr	2016(ra) # 80001b46 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	112080e7          	jalr	274(ra) # 80005480 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	052080e7          	jalr	82(ra) # 800013c8 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	ae2080e7          	jalr	-1310(ra) # 80005e60 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	df4080e7          	jalr	-524(ra) # 8000617a <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	c04080e7          	jalr	-1020(ra) # 80005f9a <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	bf4080e7          	jalr	-1036(ra) # 80005f9a <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	be4080e7          	jalr	-1052(ra) # 80005f9a <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	322080e7          	jalr	802(ra) # 800006e8 <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	984080e7          	jalr	-1660(ra) # 80000d5a <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	740080e7          	jalr	1856(ra) # 80001b1e <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	760080e7          	jalr	1888(ra) # 80001b46 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	07c080e7          	jalr	124(ra) # 8000546a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	08a080e7          	jalr	138(ra) # 80005480 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	24e080e7          	jalr	590(ra) # 8000264c <binit>
    iinit();         // inode table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	8dc080e7          	jalr	-1828(ra) # 80002ce2 <iinit>
    fileinit();      // file table
    8000040e:	00004097          	auipc	ra,0x4
    80000412:	88e080e7          	jalr	-1906(ra) # 80003c9c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	18a080e7          	jalr	394(ra) # 800055a0 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	d26080e7          	jalr	-730(ra) # 80001144 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043c:	00009797          	auipc	a5,0x9
    80000440:	bcc7b783          	ld	a5,-1076(a5) # 80009008 <kernel_pagetable>
    80000444:	83b1                	srli	a5,a5,0xc
    80000446:	577d                	li	a4,-1
    80000448:	177e                	slli	a4,a4,0x3f
    8000044a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000450:	12000073          	sfence.vma
  sfence_vma();
}
    80000454:	6422                	ld	s0,8(sp)
    80000456:	0141                	addi	sp,sp,16
    80000458:	8082                	ret

000000008000045a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045a:	7139                	addi	sp,sp,-64
    8000045c:	fc06                	sd	ra,56(sp)
    8000045e:	f822                	sd	s0,48(sp)
    80000460:	f426                	sd	s1,40(sp)
    80000462:	f04a                	sd	s2,32(sp)
    80000464:	ec4e                	sd	s3,24(sp)
    80000466:	e852                	sd	s4,16(sp)
    80000468:	e456                	sd	s5,8(sp)
    8000046a:	e05a                	sd	s6,0(sp)
    8000046c:	0080                	addi	s0,sp,64
    8000046e:	84aa                	mv	s1,a0
    80000470:	89ae                	mv	s3,a1
    80000472:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	ac8080e7          	jalr	-1336(ra) # 80005f50 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000490:	060a8663          	beqz	s5,800004fc <walk+0xa2>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000049c:	84aa                	mv	s1,a0
    8000049e:	c529                	beqz	a0,800004e8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a0:	6605                	lui	a2,0x1
    800004a2:	4581                	li	a1,0
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	cd6080e7          	jalr	-810(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ac:	00c4d793          	srli	a5,s1,0xc
    800004b0:	07aa                	slli	a5,a5,0xa
    800004b2:	0017e793          	ori	a5,a5,1
    800004b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffcedb7>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004cc:	00093483          	ld	s1,0(s2)
    800004d0:	0014f793          	andi	a5,s1,1
    800004d4:	dfd5                	beqz	a5,80000490 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d6:	80a9                	srli	s1,s1,0xa
    800004d8:	04b2                	slli	s1,s1,0xc
    800004da:	b7c5                	j	800004ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004dc:	00c9d513          	srli	a0,s3,0xc
    800004e0:	1ff57513          	andi	a0,a0,511
    800004e4:	050e                	slli	a0,a0,0x3
    800004e6:	9526                	add	a0,a0,s1
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	74a2                	ld	s1,40(sp)
    800004ee:	7902                	ld	s2,32(sp)
    800004f0:	69e2                	ld	s3,24(sp)
    800004f2:	6a42                	ld	s4,16(sp)
    800004f4:	6aa2                	ld	s5,8(sp)
    800004f6:	6b02                	ld	s6,0(sp)
    800004f8:	6121                	addi	sp,sp,64
    800004fa:	8082                	ret
        return 0;
    800004fc:	4501                	li	a0,0
    800004fe:	b7ed                	j	800004e8 <walk+0x8e>

0000000080000500 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050a:	8082                	ret
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000514:	4601                	li	a2,0
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	f44080e7          	jalr	-188(ra) # 8000045a <walk>
  if(pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052a:	00e68663          	beq	a3,a4,80000536 <walkaddr+0x36>
}
    8000052e:	60a2                	ld	ra,8(sp)
    80000530:	6402                	ld	s0,0(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  pa = PTE2PA(*pte);
    80000536:	83a9                	srli	a5,a5,0xa
    80000538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053c:	bfcd                	j	8000052e <walkaddr+0x2e>
    return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7fd                	j	8000052e <walkaddr+0x2e>

0000000080000542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000542:	715d                	addi	sp,sp,-80
    80000544:	e486                	sd	ra,72(sp)
    80000546:	e0a2                	sd	s0,64(sp)
    80000548:	fc26                	sd	s1,56(sp)
    8000054a:	f84a                	sd	s2,48(sp)
    8000054c:	f44e                	sd	s3,40(sp)
    8000054e:	f052                	sd	s4,32(sp)
    80000550:	ec56                	sd	s5,24(sp)
    80000552:	e85a                	sd	s6,16(sp)
    80000554:	e45e                	sd	s7,8(sp)
    80000556:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000558:	c639                	beqz	a2,800005a6 <mappages+0x64>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055e:	777d                	lui	a4,0xfffff
    80000560:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000564:	fff58993          	addi	s3,a1,-1
    80000568:	99b2                	add	s3,s3,a2
    8000056a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000056e:	893e                	mv	s2,a5
    80000570:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	9a2080e7          	jalr	-1630(ra) # 80005f50 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	992080e7          	jalr	-1646(ra) # 80005f50 <panic>
      return -1;
    800005c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c8:	60a6                	ld	ra,72(sp)
    800005ca:	6406                	ld	s0,64(sp)
    800005cc:	74e2                	ld	s1,56(sp)
    800005ce:	7942                	ld	s2,48(sp)
    800005d0:	79a2                	ld	s3,40(sp)
    800005d2:	7a02                	ld	s4,32(sp)
    800005d4:	6ae2                	ld	s5,24(sp)
    800005d6:	6b42                	ld	s6,16(sp)
    800005d8:	6ba2                	ld	s7,8(sp)
    800005da:	6161                	addi	sp,sp,80
    800005dc:	8082                	ret
  return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7e5                	j	800005c8 <mappages+0x86>

00000000800005e2 <kvmmap>:
{
    800005e2:	1141                	addi	sp,sp,-16
    800005e4:	e406                	sd	ra,8(sp)
    800005e6:	e022                	sd	s0,0(sp)
    800005e8:	0800                	addi	s0,sp,16
    800005ea:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ec:	86b2                	mv	a3,a2
    800005ee:	863e                	mv	a2,a5
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f52080e7          	jalr	-174(ra) # 80000542 <mappages>
    800005f8:	e509                	bnez	a0,80000602 <kvmmap+0x20>
}
    800005fa:	60a2                	ld	ra,8(sp)
    800005fc:	6402                	ld	s0,0(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret
    panic("kvmmap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a7650513          	addi	a0,a0,-1418 # 80008078 <etext+0x78>
    8000060a:	00006097          	auipc	ra,0x6
    8000060e:	946080e7          	jalr	-1722(ra) # 80005f50 <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	afc080e7          	jalr	-1284(ra) # 8000011a <kalloc>
    80000626:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000628:	6605                	lui	a2,0x1
    8000062a:	4581                	li	a1,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	b4e080e7          	jalr	-1202(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	6685                	lui	a3,0x1
    80000638:	10000637          	lui	a2,0x10000
    8000063c:	100005b7          	lui	a1,0x10000
    80000640:	8526                	mv	a0,s1
    80000642:	00000097          	auipc	ra,0x0
    80000646:	fa0080e7          	jalr	-96(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10001637          	lui	a2,0x10001
    80000652:	100015b7          	lui	a1,0x10001
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f8a080e7          	jalr	-118(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	004006b7          	lui	a3,0x400
    80000666:	0c000637          	lui	a2,0xc000
    8000066a:	0c0005b7          	lui	a1,0xc000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f72080e7          	jalr	-142(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000678:	00008917          	auipc	s2,0x8
    8000067c:	98890913          	addi	s2,s2,-1656 # 80008000 <etext>
    80000680:	4729                	li	a4,10
    80000682:	80008697          	auipc	a3,0x80008
    80000686:	97e68693          	addi	a3,a3,-1666 # 8000 <_entry-0x7fff8000>
    8000068a:	4605                	li	a2,1
    8000068c:	067e                	slli	a2,a2,0x1f
    8000068e:	85b2                	mv	a1,a2
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f50080e7          	jalr	-176(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	46c5                	li	a3,17
    8000069e:	06ee                	slli	a3,a3,0x1b
    800006a0:	412686b3          	sub	a3,a3,s2
    800006a4:	864a                	mv	a2,s2
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f38080e7          	jalr	-200(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b2:	4729                	li	a4,10
    800006b4:	6685                	lui	a3,0x1
    800006b6:	00007617          	auipc	a2,0x7
    800006ba:	94a60613          	addi	a2,a2,-1718 # 80007000 <_trampoline>
    800006be:	040005b7          	lui	a1,0x4000
    800006c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c4:	05b2                	slli	a1,a1,0xc
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f1a080e7          	jalr	-230(ra) # 800005e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	5f2080e7          	jalr	1522(ra) # 80000cc4 <proc_mapstacks>
}
    800006da:	8526                	mv	a0,s1
    800006dc:	60e2                	ld	ra,24(sp)
    800006de:	6442                	ld	s0,16(sp)
    800006e0:	64a2                	ld	s1,8(sp)
    800006e2:	6902                	ld	s2,0(sp)
    800006e4:	6105                	addi	sp,sp,32
    800006e6:	8082                	ret

00000000800006e8 <kvminit>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f22080e7          	jalr	-222(ra) # 80000612 <kvmmake>
    800006f8:	00009797          	auipc	a5,0x9
    800006fc:	90a7b823          	sd	a0,-1776(a5) # 80009008 <kernel_pagetable>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret

0000000080000708 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000708:	715d                	addi	sp,sp,-80
    8000070a:	e486                	sd	ra,72(sp)
    8000070c:	e0a2                	sd	s0,64(sp)
    8000070e:	fc26                	sd	s1,56(sp)
    80000710:	f84a                	sd	s2,48(sp)
    80000712:	f44e                	sd	s3,40(sp)
    80000714:	f052                	sd	s4,32(sp)
    80000716:	ec56                	sd	s5,24(sp)
    80000718:	e85a                	sd	s6,16(sp)
    8000071a:	e45e                	sd	s7,8(sp)
    8000071c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071e:	03459793          	slli	a5,a1,0x34
    80000722:	e795                	bnez	a5,8000074e <uvmunmap+0x46>
    80000724:	8a2a                	mv	s4,a0
    80000726:	892e                	mv	s2,a1
    80000728:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      // not mapped region for sys_munmap
      // panic("uvmunmap: not mapped");
      return;
    if(PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000732:	6b05                	lui	s6,0x1
    80000734:	0535ea63          	bltu	a1,s3,80000788 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000738:	60a6                	ld	ra,72(sp)
    8000073a:	6406                	ld	s0,64(sp)
    8000073c:	74e2                	ld	s1,56(sp)
    8000073e:	7942                	ld	s2,48(sp)
    80000740:	79a2                	ld	s3,40(sp)
    80000742:	7a02                	ld	s4,32(sp)
    80000744:	6ae2                	ld	s5,24(sp)
    80000746:	6b42                	ld	s6,16(sp)
    80000748:	6ba2                	ld	s7,8(sp)
    8000074a:	6161                	addi	sp,sp,80
    8000074c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074e:	00008517          	auipc	a0,0x8
    80000752:	93250513          	addi	a0,a0,-1742 # 80008080 <etext+0x80>
    80000756:	00005097          	auipc	ra,0x5
    8000075a:	7fa080e7          	jalr	2042(ra) # 80005f50 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	7ea080e7          	jalr	2026(ra) # 80005f50 <panic>
      panic("uvmunmap: not a leaf");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	7da080e7          	jalr	2010(ra) # 80005f50 <panic>
    *pte = 0;
    8000077e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	995a                	add	s2,s2,s6
    80000784:	fb397ae3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000788:	4601                	li	a2,0
    8000078a:	85ca                	mv	a1,s2
    8000078c:	8552                	mv	a0,s4
    8000078e:	00000097          	auipc	ra,0x0
    80000792:	ccc080e7          	jalr	-820(ra) # 8000045a <walk>
    80000796:	84aa                	mv	s1,a0
    80000798:	d179                	beqz	a0,8000075e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000079a:	611c                	ld	a5,0(a0)
    8000079c:	0017f713          	andi	a4,a5,1
    800007a0:	df41                	beqz	a4,80000738 <uvmunmap+0x30>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a2:	3ff7f713          	andi	a4,a5,1023
    800007a6:	fd7704e3          	beq	a4,s7,8000076e <uvmunmap+0x66>
    if(do_free){
    800007aa:	fc0a8ae3          	beqz	s5,8000077e <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    800007ae:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800007b0:	00c79513          	slli	a0,a5,0xc
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	868080e7          	jalr	-1944(ra) # 8000001c <kfree>
    800007bc:	b7c9                	j	8000077e <uvmunmap+0x76>

00000000800007be <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007be:	1101                	addi	sp,sp,-32
    800007c0:	ec06                	sd	ra,24(sp)
    800007c2:	e822                	sd	s0,16(sp)
    800007c4:	e426                	sd	s1,8(sp)
    800007c6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007c8:	00000097          	auipc	ra,0x0
    800007cc:	952080e7          	jalr	-1710(ra) # 8000011a <kalloc>
    800007d0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007d2:	c519                	beqz	a0,800007e0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007d4:	6605                	lui	a2,0x1
    800007d6:	4581                	li	a1,0
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	9a2080e7          	jalr	-1630(ra) # 8000017a <memset>
  return pagetable;
}
    800007e0:	8526                	mv	a0,s1
    800007e2:	60e2                	ld	ra,24(sp)
    800007e4:	6442                	ld	s0,16(sp)
    800007e6:	64a2                	ld	s1,8(sp)
    800007e8:	6105                	addi	sp,sp,32
    800007ea:	8082                	ret

00000000800007ec <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007ec:	7179                	addi	sp,sp,-48
    800007ee:	f406                	sd	ra,40(sp)
    800007f0:	f022                	sd	s0,32(sp)
    800007f2:	ec26                	sd	s1,24(sp)
    800007f4:	e84a                	sd	s2,16(sp)
    800007f6:	e44e                	sd	s3,8(sp)
    800007f8:	e052                	sd	s4,0(sp)
    800007fa:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800007fc:	6785                	lui	a5,0x1
    800007fe:	04f67863          	bgeu	a2,a5,8000084e <uvminit+0x62>
    80000802:	8a2a                	mv	s4,a0
    80000804:	89ae                	mv	s3,a1
    80000806:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000808:	00000097          	auipc	ra,0x0
    8000080c:	912080e7          	jalr	-1774(ra) # 8000011a <kalloc>
    80000810:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	964080e7          	jalr	-1692(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000081e:	4779                	li	a4,30
    80000820:	86ca                	mv	a3,s2
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	8552                	mv	a0,s4
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	d1a080e7          	jalr	-742(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    80000830:	8626                	mv	a2,s1
    80000832:	85ce                	mv	a1,s3
    80000834:	854a                	mv	a0,s2
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	9a0080e7          	jalr	-1632(ra) # 800001d6 <memmove>
}
    8000083e:	70a2                	ld	ra,40(sp)
    80000840:	7402                	ld	s0,32(sp)
    80000842:	64e2                	ld	s1,24(sp)
    80000844:	6942                	ld	s2,16(sp)
    80000846:	69a2                	ld	s3,8(sp)
    80000848:	6a02                	ld	s4,0(sp)
    8000084a:	6145                	addi	sp,sp,48
    8000084c:	8082                	ret
    panic("inituvm: more than a page");
    8000084e:	00008517          	auipc	a0,0x8
    80000852:	87250513          	addi	a0,a0,-1934 # 800080c0 <etext+0xc0>
    80000856:	00005097          	auipc	ra,0x5
    8000085a:	6fa080e7          	jalr	1786(ra) # 80005f50 <panic>

000000008000085e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000085e:	1101                	addi	sp,sp,-32
    80000860:	ec06                	sd	ra,24(sp)
    80000862:	e822                	sd	s0,16(sp)
    80000864:	e426                	sd	s1,8(sp)
    80000866:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000868:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000086a:	00b67d63          	bgeu	a2,a1,80000884 <uvmdealloc+0x26>
    8000086e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000870:	6785                	lui	a5,0x1
    80000872:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000874:	00f60733          	add	a4,a2,a5
    80000878:	76fd                	lui	a3,0xfffff
    8000087a:	8f75                	and	a4,a4,a3
    8000087c:	97ae                	add	a5,a5,a1
    8000087e:	8ff5                	and	a5,a5,a3
    80000880:	00f76863          	bltu	a4,a5,80000890 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000884:	8526                	mv	a0,s1
    80000886:	60e2                	ld	ra,24(sp)
    80000888:	6442                	ld	s0,16(sp)
    8000088a:	64a2                	ld	s1,8(sp)
    8000088c:	6105                	addi	sp,sp,32
    8000088e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000890:	8f99                	sub	a5,a5,a4
    80000892:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000894:	4685                	li	a3,1
    80000896:	0007861b          	sext.w	a2,a5
    8000089a:	85ba                	mv	a1,a4
    8000089c:	00000097          	auipc	ra,0x0
    800008a0:	e6c080e7          	jalr	-404(ra) # 80000708 <uvmunmap>
    800008a4:	b7c5                	j	80000884 <uvmdealloc+0x26>

00000000800008a6 <uvmalloc>:
  if(newsz < oldsz)
    800008a6:	0ab66163          	bltu	a2,a1,80000948 <uvmalloc+0xa2>
{
    800008aa:	7139                	addi	sp,sp,-64
    800008ac:	fc06                	sd	ra,56(sp)
    800008ae:	f822                	sd	s0,48(sp)
    800008b0:	f426                	sd	s1,40(sp)
    800008b2:	f04a                	sd	s2,32(sp)
    800008b4:	ec4e                	sd	s3,24(sp)
    800008b6:	e852                	sd	s4,16(sp)
    800008b8:	e456                	sd	s5,8(sp)
    800008ba:	0080                	addi	s0,sp,64
    800008bc:	8aaa                	mv	s5,a0
    800008be:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008c0:	6785                	lui	a5,0x1
    800008c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008c4:	95be                	add	a1,a1,a5
    800008c6:	77fd                	lui	a5,0xfffff
    800008c8:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008cc:	08c9f063          	bgeu	s3,a2,8000094c <uvmalloc+0xa6>
    800008d0:	894e                	mv	s2,s3
    mem = kalloc();
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	848080e7          	jalr	-1976(ra) # 8000011a <kalloc>
    800008da:	84aa                	mv	s1,a0
    if(mem == 0){
    800008dc:	c51d                	beqz	a0,8000090a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008de:	6605                	lui	a2,0x1
    800008e0:	4581                	li	a1,0
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	898080e7          	jalr	-1896(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008ea:	4779                	li	a4,30
    800008ec:	86a6                	mv	a3,s1
    800008ee:	6605                	lui	a2,0x1
    800008f0:	85ca                	mv	a1,s2
    800008f2:	8556                	mv	a0,s5
    800008f4:	00000097          	auipc	ra,0x0
    800008f8:	c4e080e7          	jalr	-946(ra) # 80000542 <mappages>
    800008fc:	e905                	bnez	a0,8000092c <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008fe:	6785                	lui	a5,0x1
    80000900:	993e                	add	s2,s2,a5
    80000902:	fd4968e3          	bltu	s2,s4,800008d2 <uvmalloc+0x2c>
  return newsz;
    80000906:	8552                	mv	a0,s4
    80000908:	a809                	j	8000091a <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000090a:	864e                	mv	a2,s3
    8000090c:	85ca                	mv	a1,s2
    8000090e:	8556                	mv	a0,s5
    80000910:	00000097          	auipc	ra,0x0
    80000914:	f4e080e7          	jalr	-178(ra) # 8000085e <uvmdealloc>
      return 0;
    80000918:	4501                	li	a0,0
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6121                	addi	sp,sp,64
    8000092a:	8082                	ret
      kfree(mem);
    8000092c:	8526                	mv	a0,s1
    8000092e:	fffff097          	auipc	ra,0xfffff
    80000932:	6ee080e7          	jalr	1774(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000936:	864e                	mv	a2,s3
    80000938:	85ca                	mv	a1,s2
    8000093a:	8556                	mv	a0,s5
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	f22080e7          	jalr	-222(ra) # 8000085e <uvmdealloc>
      return 0;
    80000944:	4501                	li	a0,0
    80000946:	bfd1                	j	8000091a <uvmalloc+0x74>
    return oldsz;
    80000948:	852e                	mv	a0,a1
}
    8000094a:	8082                	ret
  return newsz;
    8000094c:	8532                	mv	a0,a2
    8000094e:	b7f1                	j	8000091a <uvmalloc+0x74>

0000000080000950 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000950:	7179                	addi	sp,sp,-48
    80000952:	f406                	sd	ra,40(sp)
    80000954:	f022                	sd	s0,32(sp)
    80000956:	ec26                	sd	s1,24(sp)
    80000958:	e84a                	sd	s2,16(sp)
    8000095a:	e44e                	sd	s3,8(sp)
    8000095c:	e052                	sd	s4,0(sp)
    8000095e:	1800                	addi	s0,sp,48
    80000960:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000962:	84aa                	mv	s1,a0
    80000964:	6905                	lui	s2,0x1
    80000966:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000968:	4985                	li	s3,1
    8000096a:	a829                	j	80000984 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000096c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000096e:	00c79513          	slli	a0,a5,0xc
    80000972:	00000097          	auipc	ra,0x0
    80000976:	fde080e7          	jalr	-34(ra) # 80000950 <freewalk>
      pagetable[i] = 0;
    8000097a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000097e:	04a1                	addi	s1,s1,8
    80000980:	03248163          	beq	s1,s2,800009a2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000984:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000986:	00f7f713          	andi	a4,a5,15
    8000098a:	ff3701e3          	beq	a4,s3,8000096c <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000098e:	8b85                	andi	a5,a5,1
    80000990:	d7fd                	beqz	a5,8000097e <freewalk+0x2e>
      panic("freewalk: leaf");
    80000992:	00007517          	auipc	a0,0x7
    80000996:	74e50513          	addi	a0,a0,1870 # 800080e0 <etext+0xe0>
    8000099a:	00005097          	auipc	ra,0x5
    8000099e:	5b6080e7          	jalr	1462(ra) # 80005f50 <panic>
    }
  }
  kfree((void*)pagetable);
    800009a2:	8552                	mv	a0,s4
    800009a4:	fffff097          	auipc	ra,0xfffff
    800009a8:	678080e7          	jalr	1656(ra) # 8000001c <kfree>
}
    800009ac:	70a2                	ld	ra,40(sp)
    800009ae:	7402                	ld	s0,32(sp)
    800009b0:	64e2                	ld	s1,24(sp)
    800009b2:	6942                	ld	s2,16(sp)
    800009b4:	69a2                	ld	s3,8(sp)
    800009b6:	6a02                	ld	s4,0(sp)
    800009b8:	6145                	addi	sp,sp,48
    800009ba:	8082                	ret

00000000800009bc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009bc:	1101                	addi	sp,sp,-32
    800009be:	ec06                	sd	ra,24(sp)
    800009c0:	e822                	sd	s0,16(sp)
    800009c2:	e426                	sd	s1,8(sp)
    800009c4:	1000                	addi	s0,sp,32
    800009c6:	84aa                	mv	s1,a0
  if(sz > 0)
    800009c8:	e999                	bnez	a1,800009de <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009ca:	8526                	mv	a0,s1
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	f84080e7          	jalr	-124(ra) # 80000950 <freewalk>
}
    800009d4:	60e2                	ld	ra,24(sp)
    800009d6:	6442                	ld	s0,16(sp)
    800009d8:	64a2                	ld	s1,8(sp)
    800009da:	6105                	addi	sp,sp,32
    800009dc:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009de:	6785                	lui	a5,0x1
    800009e0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009e2:	95be                	add	a1,a1,a5
    800009e4:	4685                	li	a3,1
    800009e6:	00c5d613          	srli	a2,a1,0xc
    800009ea:	4581                	li	a1,0
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	d1c080e7          	jalr	-740(ra) # 80000708 <uvmunmap>
    800009f4:	bfd9                	j	800009ca <uvmfree+0xe>

00000000800009f6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009f6:	c679                	beqz	a2,80000ac4 <uvmcopy+0xce>
{
    800009f8:	715d                	addi	sp,sp,-80
    800009fa:	e486                	sd	ra,72(sp)
    800009fc:	e0a2                	sd	s0,64(sp)
    800009fe:	fc26                	sd	s1,56(sp)
    80000a00:	f84a                	sd	s2,48(sp)
    80000a02:	f44e                	sd	s3,40(sp)
    80000a04:	f052                	sd	s4,32(sp)
    80000a06:	ec56                	sd	s5,24(sp)
    80000a08:	e85a                	sd	s6,16(sp)
    80000a0a:	e45e                	sd	s7,8(sp)
    80000a0c:	0880                	addi	s0,sp,80
    80000a0e:	8b2a                	mv	s6,a0
    80000a10:	8aae                	mv	s5,a1
    80000a12:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a14:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a16:	4601                	li	a2,0
    80000a18:	85ce                	mv	a1,s3
    80000a1a:	855a                	mv	a0,s6
    80000a1c:	00000097          	auipc	ra,0x0
    80000a20:	a3e080e7          	jalr	-1474(ra) # 8000045a <walk>
    80000a24:	c531                	beqz	a0,80000a70 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a26:	6118                	ld	a4,0(a0)
    80000a28:	00177793          	andi	a5,a4,1
    80000a2c:	cbb1                	beqz	a5,80000a80 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a2e:	00a75593          	srli	a1,a4,0xa
    80000a32:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a36:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a3a:	fffff097          	auipc	ra,0xfffff
    80000a3e:	6e0080e7          	jalr	1760(ra) # 8000011a <kalloc>
    80000a42:	892a                	mv	s2,a0
    80000a44:	c939                	beqz	a0,80000a9a <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a46:	6605                	lui	a2,0x1
    80000a48:	85de                	mv	a1,s7
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	78c080e7          	jalr	1932(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a52:	8726                	mv	a4,s1
    80000a54:	86ca                	mv	a3,s2
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85ce                	mv	a1,s3
    80000a5a:	8556                	mv	a0,s5
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	ae6080e7          	jalr	-1306(ra) # 80000542 <mappages>
    80000a64:	e515                	bnez	a0,80000a90 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a66:	6785                	lui	a5,0x1
    80000a68:	99be                	add	s3,s3,a5
    80000a6a:	fb49e6e3          	bltu	s3,s4,80000a16 <uvmcopy+0x20>
    80000a6e:	a081                	j	80000aae <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a70:	00007517          	auipc	a0,0x7
    80000a74:	68050513          	addi	a0,a0,1664 # 800080f0 <etext+0xf0>
    80000a78:	00005097          	auipc	ra,0x5
    80000a7c:	4d8080e7          	jalr	1240(ra) # 80005f50 <panic>
      panic("uvmcopy: page not present");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	69050513          	addi	a0,a0,1680 # 80008110 <etext+0x110>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	4c8080e7          	jalr	1224(ra) # 80005f50 <panic>
      kfree(mem);
    80000a90:	854a                	mv	a0,s2
    80000a92:	fffff097          	auipc	ra,0xfffff
    80000a96:	58a080e7          	jalr	1418(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a9a:	4685                	li	a3,1
    80000a9c:	00c9d613          	srli	a2,s3,0xc
    80000aa0:	4581                	li	a1,0
    80000aa2:	8556                	mv	a0,s5
    80000aa4:	00000097          	auipc	ra,0x0
    80000aa8:	c64080e7          	jalr	-924(ra) # 80000708 <uvmunmap>
  return -1;
    80000aac:	557d                	li	a0,-1
}
    80000aae:	60a6                	ld	ra,72(sp)
    80000ab0:	6406                	ld	s0,64(sp)
    80000ab2:	74e2                	ld	s1,56(sp)
    80000ab4:	7942                	ld	s2,48(sp)
    80000ab6:	79a2                	ld	s3,40(sp)
    80000ab8:	7a02                	ld	s4,32(sp)
    80000aba:	6ae2                	ld	s5,24(sp)
    80000abc:	6b42                	ld	s6,16(sp)
    80000abe:	6ba2                	ld	s7,8(sp)
    80000ac0:	6161                	addi	sp,sp,80
    80000ac2:	8082                	ret
  return 0;
    80000ac4:	4501                	li	a0,0
}
    80000ac6:	8082                	ret

0000000080000ac8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ac8:	1141                	addi	sp,sp,-16
    80000aca:	e406                	sd	ra,8(sp)
    80000acc:	e022                	sd	s0,0(sp)
    80000ace:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ad0:	4601                	li	a2,0
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	988080e7          	jalr	-1656(ra) # 8000045a <walk>
  if(pte == 0)
    80000ada:	c901                	beqz	a0,80000aea <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000adc:	611c                	ld	a5,0(a0)
    80000ade:	9bbd                	andi	a5,a5,-17
    80000ae0:	e11c                	sd	a5,0(a0)
}
    80000ae2:	60a2                	ld	ra,8(sp)
    80000ae4:	6402                	ld	s0,0(sp)
    80000ae6:	0141                	addi	sp,sp,16
    80000ae8:	8082                	ret
    panic("uvmclear");
    80000aea:	00007517          	auipc	a0,0x7
    80000aee:	64650513          	addi	a0,a0,1606 # 80008130 <etext+0x130>
    80000af2:	00005097          	auipc	ra,0x5
    80000af6:	45e080e7          	jalr	1118(ra) # 80005f50 <panic>

0000000080000afa <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000afa:	c6bd                	beqz	a3,80000b68 <copyout+0x6e>
{
    80000afc:	715d                	addi	sp,sp,-80
    80000afe:	e486                	sd	ra,72(sp)
    80000b00:	e0a2                	sd	s0,64(sp)
    80000b02:	fc26                	sd	s1,56(sp)
    80000b04:	f84a                	sd	s2,48(sp)
    80000b06:	f44e                	sd	s3,40(sp)
    80000b08:	f052                	sd	s4,32(sp)
    80000b0a:	ec56                	sd	s5,24(sp)
    80000b0c:	e85a                	sd	s6,16(sp)
    80000b0e:	e45e                	sd	s7,8(sp)
    80000b10:	e062                	sd	s8,0(sp)
    80000b12:	0880                	addi	s0,sp,80
    80000b14:	8b2a                	mv	s6,a0
    80000b16:	8c2e                	mv	s8,a1
    80000b18:	8a32                	mv	s4,a2
    80000b1a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b1c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b1e:	6a85                	lui	s5,0x1
    80000b20:	a015                	j	80000b44 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b22:	9562                	add	a0,a0,s8
    80000b24:	0004861b          	sext.w	a2,s1
    80000b28:	85d2                	mv	a1,s4
    80000b2a:	41250533          	sub	a0,a0,s2
    80000b2e:	fffff097          	auipc	ra,0xfffff
    80000b32:	6a8080e7          	jalr	1704(ra) # 800001d6 <memmove>

    len -= n;
    80000b36:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b3a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b3c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b40:	02098263          	beqz	s3,80000b64 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b44:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b48:	85ca                	mv	a1,s2
    80000b4a:	855a                	mv	a0,s6
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	9b4080e7          	jalr	-1612(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b54:	cd01                	beqz	a0,80000b6c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b56:	418904b3          	sub	s1,s2,s8
    80000b5a:	94d6                	add	s1,s1,s5
    80000b5c:	fc99f3e3          	bgeu	s3,s1,80000b22 <copyout+0x28>
    80000b60:	84ce                	mv	s1,s3
    80000b62:	b7c1                	j	80000b22 <copyout+0x28>
  }
  return 0;
    80000b64:	4501                	li	a0,0
    80000b66:	a021                	j	80000b6e <copyout+0x74>
    80000b68:	4501                	li	a0,0
}
    80000b6a:	8082                	ret
      return -1;
    80000b6c:	557d                	li	a0,-1
}
    80000b6e:	60a6                	ld	ra,72(sp)
    80000b70:	6406                	ld	s0,64(sp)
    80000b72:	74e2                	ld	s1,56(sp)
    80000b74:	7942                	ld	s2,48(sp)
    80000b76:	79a2                	ld	s3,40(sp)
    80000b78:	7a02                	ld	s4,32(sp)
    80000b7a:	6ae2                	ld	s5,24(sp)
    80000b7c:	6b42                	ld	s6,16(sp)
    80000b7e:	6ba2                	ld	s7,8(sp)
    80000b80:	6c02                	ld	s8,0(sp)
    80000b82:	6161                	addi	sp,sp,80
    80000b84:	8082                	ret

0000000080000b86 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b86:	caa5                	beqz	a3,80000bf6 <copyin+0x70>
{
    80000b88:	715d                	addi	sp,sp,-80
    80000b8a:	e486                	sd	ra,72(sp)
    80000b8c:	e0a2                	sd	s0,64(sp)
    80000b8e:	fc26                	sd	s1,56(sp)
    80000b90:	f84a                	sd	s2,48(sp)
    80000b92:	f44e                	sd	s3,40(sp)
    80000b94:	f052                	sd	s4,32(sp)
    80000b96:	ec56                	sd	s5,24(sp)
    80000b98:	e85a                	sd	s6,16(sp)
    80000b9a:	e45e                	sd	s7,8(sp)
    80000b9c:	e062                	sd	s8,0(sp)
    80000b9e:	0880                	addi	s0,sp,80
    80000ba0:	8b2a                	mv	s6,a0
    80000ba2:	8a2e                	mv	s4,a1
    80000ba4:	8c32                	mv	s8,a2
    80000ba6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ba8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000baa:	6a85                	lui	s5,0x1
    80000bac:	a01d                	j	80000bd2 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bae:	018505b3          	add	a1,a0,s8
    80000bb2:	0004861b          	sext.w	a2,s1
    80000bb6:	412585b3          	sub	a1,a1,s2
    80000bba:	8552                	mv	a0,s4
    80000bbc:	fffff097          	auipc	ra,0xfffff
    80000bc0:	61a080e7          	jalr	1562(ra) # 800001d6 <memmove>

    len -= n;
    80000bc4:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bc8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bca:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bce:	02098263          	beqz	s3,80000bf2 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bd2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bd6:	85ca                	mv	a1,s2
    80000bd8:	855a                	mv	a0,s6
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	926080e7          	jalr	-1754(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000be2:	cd01                	beqz	a0,80000bfa <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000be4:	418904b3          	sub	s1,s2,s8
    80000be8:	94d6                	add	s1,s1,s5
    80000bea:	fc99f2e3          	bgeu	s3,s1,80000bae <copyin+0x28>
    80000bee:	84ce                	mv	s1,s3
    80000bf0:	bf7d                	j	80000bae <copyin+0x28>
  }
  return 0;
    80000bf2:	4501                	li	a0,0
    80000bf4:	a021                	j	80000bfc <copyin+0x76>
    80000bf6:	4501                	li	a0,0
}
    80000bf8:	8082                	ret
      return -1;
    80000bfa:	557d                	li	a0,-1
}
    80000bfc:	60a6                	ld	ra,72(sp)
    80000bfe:	6406                	ld	s0,64(sp)
    80000c00:	74e2                	ld	s1,56(sp)
    80000c02:	7942                	ld	s2,48(sp)
    80000c04:	79a2                	ld	s3,40(sp)
    80000c06:	7a02                	ld	s4,32(sp)
    80000c08:	6ae2                	ld	s5,24(sp)
    80000c0a:	6b42                	ld	s6,16(sp)
    80000c0c:	6ba2                	ld	s7,8(sp)
    80000c0e:	6c02                	ld	s8,0(sp)
    80000c10:	6161                	addi	sp,sp,80
    80000c12:	8082                	ret

0000000080000c14 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c14:	c2dd                	beqz	a3,80000cba <copyinstr+0xa6>
{
    80000c16:	715d                	addi	sp,sp,-80
    80000c18:	e486                	sd	ra,72(sp)
    80000c1a:	e0a2                	sd	s0,64(sp)
    80000c1c:	fc26                	sd	s1,56(sp)
    80000c1e:	f84a                	sd	s2,48(sp)
    80000c20:	f44e                	sd	s3,40(sp)
    80000c22:	f052                	sd	s4,32(sp)
    80000c24:	ec56                	sd	s5,24(sp)
    80000c26:	e85a                	sd	s6,16(sp)
    80000c28:	e45e                	sd	s7,8(sp)
    80000c2a:	0880                	addi	s0,sp,80
    80000c2c:	8a2a                	mv	s4,a0
    80000c2e:	8b2e                	mv	s6,a1
    80000c30:	8bb2                	mv	s7,a2
    80000c32:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c34:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c36:	6985                	lui	s3,0x1
    80000c38:	a02d                	j	80000c62 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c3a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c3e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c40:	37fd                	addiw	a5,a5,-1
    80000c42:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c46:	60a6                	ld	ra,72(sp)
    80000c48:	6406                	ld	s0,64(sp)
    80000c4a:	74e2                	ld	s1,56(sp)
    80000c4c:	7942                	ld	s2,48(sp)
    80000c4e:	79a2                	ld	s3,40(sp)
    80000c50:	7a02                	ld	s4,32(sp)
    80000c52:	6ae2                	ld	s5,24(sp)
    80000c54:	6b42                	ld	s6,16(sp)
    80000c56:	6ba2                	ld	s7,8(sp)
    80000c58:	6161                	addi	sp,sp,80
    80000c5a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c5c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c60:	c8a9                	beqz	s1,80000cb2 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c62:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c66:	85ca                	mv	a1,s2
    80000c68:	8552                	mv	a0,s4
    80000c6a:	00000097          	auipc	ra,0x0
    80000c6e:	896080e7          	jalr	-1898(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c72:	c131                	beqz	a0,80000cb6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c74:	417906b3          	sub	a3,s2,s7
    80000c78:	96ce                	add	a3,a3,s3
    80000c7a:	00d4f363          	bgeu	s1,a3,80000c80 <copyinstr+0x6c>
    80000c7e:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c80:	955e                	add	a0,a0,s7
    80000c82:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c86:	daf9                	beqz	a3,80000c5c <copyinstr+0x48>
    80000c88:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c8a:	41650633          	sub	a2,a0,s6
    80000c8e:	fff48593          	addi	a1,s1,-1
    80000c92:	95da                	add	a1,a1,s6
    while(n > 0){
    80000c94:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000c96:	00f60733          	add	a4,a2,a5
    80000c9a:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffcedc0>
    80000c9e:	df51                	beqz	a4,80000c3a <copyinstr+0x26>
        *dst = *p;
    80000ca0:	00e78023          	sb	a4,0(a5)
      --max;
    80000ca4:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000ca8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000caa:	fed796e3          	bne	a5,a3,80000c96 <copyinstr+0x82>
      dst++;
    80000cae:	8b3e                	mv	s6,a5
    80000cb0:	b775                	j	80000c5c <copyinstr+0x48>
    80000cb2:	4781                	li	a5,0
    80000cb4:	b771                	j	80000c40 <copyinstr+0x2c>
      return -1;
    80000cb6:	557d                	li	a0,-1
    80000cb8:	b779                	j	80000c46 <copyinstr+0x32>
  int got_null = 0;
    80000cba:	4781                	li	a5,0
  if(got_null){
    80000cbc:	37fd                	addiw	a5,a5,-1
    80000cbe:	0007851b          	sext.w	a0,a5
}
    80000cc2:	8082                	ret

0000000080000cc4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cc4:	7139                	addi	sp,sp,-64
    80000cc6:	fc06                	sd	ra,56(sp)
    80000cc8:	f822                	sd	s0,48(sp)
    80000cca:	f426                	sd	s1,40(sp)
    80000ccc:	f04a                	sd	s2,32(sp)
    80000cce:	ec4e                	sd	s3,24(sp)
    80000cd0:	e852                	sd	s4,16(sp)
    80000cd2:	e456                	sd	s5,8(sp)
    80000cd4:	e05a                	sd	s6,0(sp)
    80000cd6:	0080                	addi	s0,sp,64
    80000cd8:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cda:	00008497          	auipc	s1,0x8
    80000cde:	7a648493          	addi	s1,s1,1958 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ce2:	8b26                	mv	s6,s1
    80000ce4:	00007a97          	auipc	s5,0x7
    80000ce8:	31ca8a93          	addi	s5,s5,796 # 80008000 <etext>
    80000cec:	04000937          	lui	s2,0x4000
    80000cf0:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000cf2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	00018a17          	auipc	s4,0x18
    80000cf8:	38ca0a13          	addi	s4,s4,908 # 80019080 <tickslock>
    char *pa = kalloc();
    80000cfc:	fffff097          	auipc	ra,0xfffff
    80000d00:	41e080e7          	jalr	1054(ra) # 8000011a <kalloc>
    80000d04:	862a                	mv	a2,a0
    if(pa == 0)
    80000d06:	c131                	beqz	a0,80000d4a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d08:	416485b3          	sub	a1,s1,s6
    80000d0c:	8591                	srai	a1,a1,0x4
    80000d0e:	000ab783          	ld	a5,0(s5)
    80000d12:	02f585b3          	mul	a1,a1,a5
    80000d16:	2585                	addiw	a1,a1,1
    80000d18:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d1c:	4719                	li	a4,6
    80000d1e:	6685                	lui	a3,0x1
    80000d20:	40b905b3          	sub	a1,s2,a1
    80000d24:	854e                	mv	a0,s3
    80000d26:	00000097          	auipc	ra,0x0
    80000d2a:	8bc080e7          	jalr	-1860(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2e:	3f048493          	addi	s1,s1,1008
    80000d32:	fd4495e3          	bne	s1,s4,80000cfc <proc_mapstacks+0x38>
  }
}
    80000d36:	70e2                	ld	ra,56(sp)
    80000d38:	7442                	ld	s0,48(sp)
    80000d3a:	74a2                	ld	s1,40(sp)
    80000d3c:	7902                	ld	s2,32(sp)
    80000d3e:	69e2                	ld	s3,24(sp)
    80000d40:	6a42                	ld	s4,16(sp)
    80000d42:	6aa2                	ld	s5,8(sp)
    80000d44:	6b02                	ld	s6,0(sp)
    80000d46:	6121                	addi	sp,sp,64
    80000d48:	8082                	ret
      panic("kalloc");
    80000d4a:	00007517          	auipc	a0,0x7
    80000d4e:	3f650513          	addi	a0,a0,1014 # 80008140 <etext+0x140>
    80000d52:	00005097          	auipc	ra,0x5
    80000d56:	1fe080e7          	jalr	510(ra) # 80005f50 <panic>

0000000080000d5a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d5a:	715d                	addi	sp,sp,-80
    80000d5c:	e486                	sd	ra,72(sp)
    80000d5e:	e0a2                	sd	s0,64(sp)
    80000d60:	fc26                	sd	s1,56(sp)
    80000d62:	f84a                	sd	s2,48(sp)
    80000d64:	f44e                	sd	s3,40(sp)
    80000d66:	f052                	sd	s4,32(sp)
    80000d68:	ec56                	sd	s5,24(sp)
    80000d6a:	e85a                	sd	s6,16(sp)
    80000d6c:	e45e                	sd	s7,8(sp)
    80000d6e:	e062                	sd	s8,0(sp)
    80000d70:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d72:	00007597          	auipc	a1,0x7
    80000d76:	3d658593          	addi	a1,a1,982 # 80008148 <etext+0x148>
    80000d7a:	00008517          	auipc	a0,0x8
    80000d7e:	2d650513          	addi	a0,a0,726 # 80009050 <pid_lock>
    80000d82:	00005097          	auipc	ra,0x5
    80000d86:	676080e7          	jalr	1654(ra) # 800063f8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d8a:	00007597          	auipc	a1,0x7
    80000d8e:	3c658593          	addi	a1,a1,966 # 80008150 <etext+0x150>
    80000d92:	00008517          	auipc	a0,0x8
    80000d96:	2d650513          	addi	a0,a0,726 # 80009068 <wait_lock>
    80000d9a:	00005097          	auipc	ra,0x5
    80000d9e:	65e080e7          	jalr	1630(ra) # 800063f8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000da2:	00009497          	auipc	s1,0x9
    80000da6:	ace48493          	addi	s1,s1,-1330 # 80009870 <proc+0x3f0>
    80000daa:	00008917          	auipc	s2,0x8
    80000dae:	6d690913          	addi	s2,s2,1750 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db2:	00007c17          	auipc	s8,0x7
    80000db6:	3aec0c13          	addi	s8,s8,942 # 80008160 <etext+0x160>
      p->kstack = KSTACK((int) (p - proc));
    80000dba:	8bca                	mv	s7,s2
    80000dbc:	00007b17          	auipc	s6,0x7
    80000dc0:	244b0b13          	addi	s6,s6,580 # 80008000 <etext>
    80000dc4:	04000a37          	lui	s4,0x4000
    80000dc8:	1a7d                	addi	s4,s4,-1 # 3ffffff <_entry-0x7c000001>
    80000dca:	0a32                	slli	s4,s4,0xc
      p->VMA_top = TRAPFRAME;
    80000dcc:	020009b7          	lui	s3,0x2000
    80000dd0:	19fd                	addi	s3,s3,-1 # 1ffffff <_entry-0x7e000001>
    80000dd2:	09b6                	slli	s3,s3,0xd
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd4:	00018a97          	auipc	s5,0x18
    80000dd8:	2aca8a93          	addi	s5,s5,684 # 80019080 <tickslock>
    80000ddc:	a039                	j	80000dea <procinit+0x90>
    80000dde:	3f090913          	addi	s2,s2,1008
    80000de2:	3f048493          	addi	s1,s1,1008
    80000de6:	05590163          	beq	s2,s5,80000e28 <procinit+0xce>
      initlock(&p->lock, "proc");
    80000dea:	85e2                	mv	a1,s8
    80000dec:	854a                	mv	a0,s2
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	60a080e7          	jalr	1546(ra) # 800063f8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000df6:	417907b3          	sub	a5,s2,s7
    80000dfa:	8791                	srai	a5,a5,0x4
    80000dfc:	000b3703          	ld	a4,0(s6)
    80000e00:	02e787b3          	mul	a5,a5,a4
    80000e04:	2785                	addiw	a5,a5,1
    80000e06:	00d7979b          	slliw	a5,a5,0xd
    80000e0a:	40fa07b3          	sub	a5,s4,a5
    80000e0e:	04f93023          	sd	a5,64(s2)
      p->VMA_top = TRAPFRAME;
    80000e12:	17393423          	sd	s3,360(s2)
      for (int i = 0; i < VMA_SIZE; i++) {
    80000e16:	17090793          	addi	a5,s2,368
        p->VMAs[i].valid = 0;
    80000e1a:	0007a023          	sw	zero,0(a5)
      for (int i = 0; i < VMA_SIZE; i++) {
    80000e1e:	02878793          	addi	a5,a5,40
    80000e22:	fe979ce3          	bne	a5,s1,80000e1a <procinit+0xc0>
    80000e26:	bf65                	j	80000dde <procinit+0x84>
      }
  }
}
    80000e28:	60a6                	ld	ra,72(sp)
    80000e2a:	6406                	ld	s0,64(sp)
    80000e2c:	74e2                	ld	s1,56(sp)
    80000e2e:	7942                	ld	s2,48(sp)
    80000e30:	79a2                	ld	s3,40(sp)
    80000e32:	7a02                	ld	s4,32(sp)
    80000e34:	6ae2                	ld	s5,24(sp)
    80000e36:	6b42                	ld	s6,16(sp)
    80000e38:	6ba2                	ld	s7,8(sp)
    80000e3a:	6c02                	ld	s8,0(sp)
    80000e3c:	6161                	addi	sp,sp,80
    80000e3e:	8082                	ret

0000000080000e40 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e40:	1141                	addi	sp,sp,-16
    80000e42:	e422                	sd	s0,8(sp)
    80000e44:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e46:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e48:	2501                	sext.w	a0,a0
    80000e4a:	6422                	ld	s0,8(sp)
    80000e4c:	0141                	addi	sp,sp,16
    80000e4e:	8082                	ret

0000000080000e50 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
    80000e56:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e58:	2781                	sext.w	a5,a5
    80000e5a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e5c:	00008517          	auipc	a0,0x8
    80000e60:	22450513          	addi	a0,a0,548 # 80009080 <cpus>
    80000e64:	953e                	add	a0,a0,a5
    80000e66:	6422                	ld	s0,8(sp)
    80000e68:	0141                	addi	sp,sp,16
    80000e6a:	8082                	ret

0000000080000e6c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e6c:	1101                	addi	sp,sp,-32
    80000e6e:	ec06                	sd	ra,24(sp)
    80000e70:	e822                	sd	s0,16(sp)
    80000e72:	e426                	sd	s1,8(sp)
    80000e74:	1000                	addi	s0,sp,32
  push_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	5c6080e7          	jalr	1478(ra) # 8000643c <push_off>
    80000e7e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e80:	2781                	sext.w	a5,a5
    80000e82:	079e                	slli	a5,a5,0x7
    80000e84:	00008717          	auipc	a4,0x8
    80000e88:	1cc70713          	addi	a4,a4,460 # 80009050 <pid_lock>
    80000e8c:	97ba                	add	a5,a5,a4
    80000e8e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	64c080e7          	jalr	1612(ra) # 800064dc <pop_off>
  return p;
}
    80000e98:	8526                	mv	a0,s1
    80000e9a:	60e2                	ld	ra,24(sp)
    80000e9c:	6442                	ld	s0,16(sp)
    80000e9e:	64a2                	ld	s1,8(sp)
    80000ea0:	6105                	addi	sp,sp,32
    80000ea2:	8082                	ret

0000000080000ea4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ea4:	1141                	addi	sp,sp,-16
    80000ea6:	e406                	sd	ra,8(sp)
    80000ea8:	e022                	sd	s0,0(sp)
    80000eaa:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eac:	00000097          	auipc	ra,0x0
    80000eb0:	fc0080e7          	jalr	-64(ra) # 80000e6c <myproc>
    80000eb4:	00005097          	auipc	ra,0x5
    80000eb8:	688080e7          	jalr	1672(ra) # 8000653c <release>

  if (first) {
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	9747a783          	lw	a5,-1676(a5) # 80008830 <first.1>
    80000ec4:	eb89                	bnez	a5,80000ed6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ec6:	00001097          	auipc	ra,0x1
    80000eca:	c98080e7          	jalr	-872(ra) # 80001b5e <usertrapret>
}
    80000ece:	60a2                	ld	ra,8(sp)
    80000ed0:	6402                	ld	s0,0(sp)
    80000ed2:	0141                	addi	sp,sp,16
    80000ed4:	8082                	ret
    first = 0;
    80000ed6:	00008797          	auipc	a5,0x8
    80000eda:	9407ad23          	sw	zero,-1702(a5) # 80008830 <first.1>
    fsinit(ROOTDEV);
    80000ede:	4505                	li	a0,1
    80000ee0:	00002097          	auipc	ra,0x2
    80000ee4:	d82080e7          	jalr	-638(ra) # 80002c62 <fsinit>
    80000ee8:	bff9                	j	80000ec6 <forkret+0x22>

0000000080000eea <allocpid>:
allocpid() {
    80000eea:	1101                	addi	sp,sp,-32
    80000eec:	ec06                	sd	ra,24(sp)
    80000eee:	e822                	sd	s0,16(sp)
    80000ef0:	e426                	sd	s1,8(sp)
    80000ef2:	e04a                	sd	s2,0(sp)
    80000ef4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ef6:	00008917          	auipc	s2,0x8
    80000efa:	15a90913          	addi	s2,s2,346 # 80009050 <pid_lock>
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	588080e7          	jalr	1416(ra) # 80006488 <acquire>
  pid = nextpid;
    80000f08:	00008797          	auipc	a5,0x8
    80000f0c:	92c78793          	addi	a5,a5,-1748 # 80008834 <nextpid>
    80000f10:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f12:	0014871b          	addiw	a4,s1,1
    80000f16:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f18:	854a                	mv	a0,s2
    80000f1a:	00005097          	auipc	ra,0x5
    80000f1e:	622080e7          	jalr	1570(ra) # 8000653c <release>
}
    80000f22:	8526                	mv	a0,s1
    80000f24:	60e2                	ld	ra,24(sp)
    80000f26:	6442                	ld	s0,16(sp)
    80000f28:	64a2                	ld	s1,8(sp)
    80000f2a:	6902                	ld	s2,0(sp)
    80000f2c:	6105                	addi	sp,sp,32
    80000f2e:	8082                	ret

0000000080000f30 <proc_pagetable>:
{
    80000f30:	1101                	addi	sp,sp,-32
    80000f32:	ec06                	sd	ra,24(sp)
    80000f34:	e822                	sd	s0,16(sp)
    80000f36:	e426                	sd	s1,8(sp)
    80000f38:	e04a                	sd	s2,0(sp)
    80000f3a:	1000                	addi	s0,sp,32
    80000f3c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f3e:	00000097          	auipc	ra,0x0
    80000f42:	880080e7          	jalr	-1920(ra) # 800007be <uvmcreate>
    80000f46:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f48:	c121                	beqz	a0,80000f88 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f4a:	4729                	li	a4,10
    80000f4c:	00006697          	auipc	a3,0x6
    80000f50:	0b468693          	addi	a3,a3,180 # 80007000 <_trampoline>
    80000f54:	6605                	lui	a2,0x1
    80000f56:	040005b7          	lui	a1,0x4000
    80000f5a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f5c:	05b2                	slli	a1,a1,0xc
    80000f5e:	fffff097          	auipc	ra,0xfffff
    80000f62:	5e4080e7          	jalr	1508(ra) # 80000542 <mappages>
    80000f66:	02054863          	bltz	a0,80000f96 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f6a:	4719                	li	a4,6
    80000f6c:	05893683          	ld	a3,88(s2)
    80000f70:	6605                	lui	a2,0x1
    80000f72:	020005b7          	lui	a1,0x2000
    80000f76:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f78:	05b6                	slli	a1,a1,0xd
    80000f7a:	8526                	mv	a0,s1
    80000f7c:	fffff097          	auipc	ra,0xfffff
    80000f80:	5c6080e7          	jalr	1478(ra) # 80000542 <mappages>
    80000f84:	02054163          	bltz	a0,80000fa6 <proc_pagetable+0x76>
}
    80000f88:	8526                	mv	a0,s1
    80000f8a:	60e2                	ld	ra,24(sp)
    80000f8c:	6442                	ld	s0,16(sp)
    80000f8e:	64a2                	ld	s1,8(sp)
    80000f90:	6902                	ld	s2,0(sp)
    80000f92:	6105                	addi	sp,sp,32
    80000f94:	8082                	ret
    uvmfree(pagetable, 0);
    80000f96:	4581                	li	a1,0
    80000f98:	8526                	mv	a0,s1
    80000f9a:	00000097          	auipc	ra,0x0
    80000f9e:	a22080e7          	jalr	-1502(ra) # 800009bc <uvmfree>
    return 0;
    80000fa2:	4481                	li	s1,0
    80000fa4:	b7d5                	j	80000f88 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa6:	4681                	li	a3,0
    80000fa8:	4605                	li	a2,1
    80000faa:	040005b7          	lui	a1,0x4000
    80000fae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb0:	05b2                	slli	a1,a1,0xc
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	754080e7          	jalr	1876(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	9fc080e7          	jalr	-1540(ra) # 800009bc <uvmfree>
    return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	bf7d                	j	80000f88 <proc_pagetable+0x58>

0000000080000fcc <proc_freepagetable>:
{
    80000fcc:	1101                	addi	sp,sp,-32
    80000fce:	ec06                	sd	ra,24(sp)
    80000fd0:	e822                	sd	s0,16(sp)
    80000fd2:	e426                	sd	s1,8(sp)
    80000fd4:	e04a                	sd	s2,0(sp)
    80000fd6:	1000                	addi	s0,sp,32
    80000fd8:	84aa                	mv	s1,a0
    80000fda:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fdc:	4681                	li	a3,0
    80000fde:	4605                	li	a2,1
    80000fe0:	040005b7          	lui	a1,0x4000
    80000fe4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fe6:	05b2                	slli	a1,a1,0xc
    80000fe8:	fffff097          	auipc	ra,0xfffff
    80000fec:	720080e7          	jalr	1824(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ff0:	4681                	li	a3,0
    80000ff2:	4605                	li	a2,1
    80000ff4:	020005b7          	lui	a1,0x2000
    80000ff8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ffa:	05b6                	slli	a1,a1,0xd
    80000ffc:	8526                	mv	a0,s1
    80000ffe:	fffff097          	auipc	ra,0xfffff
    80001002:	70a080e7          	jalr	1802(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80001006:	85ca                	mv	a1,s2
    80001008:	8526                	mv	a0,s1
    8000100a:	00000097          	auipc	ra,0x0
    8000100e:	9b2080e7          	jalr	-1614(ra) # 800009bc <uvmfree>
}
    80001012:	60e2                	ld	ra,24(sp)
    80001014:	6442                	ld	s0,16(sp)
    80001016:	64a2                	ld	s1,8(sp)
    80001018:	6902                	ld	s2,0(sp)
    8000101a:	6105                	addi	sp,sp,32
    8000101c:	8082                	ret

000000008000101e <freeproc>:
{
    8000101e:	1101                	addi	sp,sp,-32
    80001020:	ec06                	sd	ra,24(sp)
    80001022:	e822                	sd	s0,16(sp)
    80001024:	e426                	sd	s1,8(sp)
    80001026:	1000                	addi	s0,sp,32
    80001028:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000102a:	6d28                	ld	a0,88(a0)
    8000102c:	c509                	beqz	a0,80001036 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000102e:	fffff097          	auipc	ra,0xfffff
    80001032:	fee080e7          	jalr	-18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001036:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000103a:	68a8                	ld	a0,80(s1)
    8000103c:	c511                	beqz	a0,80001048 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000103e:	64ac                	ld	a1,72(s1)
    80001040:	00000097          	auipc	ra,0x0
    80001044:	f8c080e7          	jalr	-116(ra) # 80000fcc <proc_freepagetable>
  p->pagetable = 0;
    80001048:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000104c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001050:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001054:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001058:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000105c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001060:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001064:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001068:	0004ac23          	sw	zero,24(s1)
}
    8000106c:	60e2                	ld	ra,24(sp)
    8000106e:	6442                	ld	s0,16(sp)
    80001070:	64a2                	ld	s1,8(sp)
    80001072:	6105                	addi	sp,sp,32
    80001074:	8082                	ret

0000000080001076 <allocproc>:
{
    80001076:	1101                	addi	sp,sp,-32
    80001078:	ec06                	sd	ra,24(sp)
    8000107a:	e822                	sd	s0,16(sp)
    8000107c:	e426                	sd	s1,8(sp)
    8000107e:	e04a                	sd	s2,0(sp)
    80001080:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001082:	00008497          	auipc	s1,0x8
    80001086:	3fe48493          	addi	s1,s1,1022 # 80009480 <proc>
    8000108a:	00018917          	auipc	s2,0x18
    8000108e:	ff690913          	addi	s2,s2,-10 # 80019080 <tickslock>
    acquire(&p->lock);
    80001092:	8526                	mv	a0,s1
    80001094:	00005097          	auipc	ra,0x5
    80001098:	3f4080e7          	jalr	1012(ra) # 80006488 <acquire>
    if(p->state == UNUSED) {
    8000109c:	4c9c                	lw	a5,24(s1)
    8000109e:	cf81                	beqz	a5,800010b6 <allocproc+0x40>
      release(&p->lock);
    800010a0:	8526                	mv	a0,s1
    800010a2:	00005097          	auipc	ra,0x5
    800010a6:	49a080e7          	jalr	1178(ra) # 8000653c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010aa:	3f048493          	addi	s1,s1,1008
    800010ae:	ff2492e3          	bne	s1,s2,80001092 <allocproc+0x1c>
  return 0;
    800010b2:	4481                	li	s1,0
    800010b4:	a889                	j	80001106 <allocproc+0x90>
  p->pid = allocpid();
    800010b6:	00000097          	auipc	ra,0x0
    800010ba:	e34080e7          	jalr	-460(ra) # 80000eea <allocpid>
    800010be:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010c0:	4785                	li	a5,1
    800010c2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	056080e7          	jalr	86(ra) # 8000011a <kalloc>
    800010cc:	892a                	mv	s2,a0
    800010ce:	eca8                	sd	a0,88(s1)
    800010d0:	c131                	beqz	a0,80001114 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010d2:	8526                	mv	a0,s1
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	e5c080e7          	jalr	-420(ra) # 80000f30 <proc_pagetable>
    800010dc:	892a                	mv	s2,a0
    800010de:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010e0:	c531                	beqz	a0,8000112c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010e2:	07000613          	li	a2,112
    800010e6:	4581                	li	a1,0
    800010e8:	06048513          	addi	a0,s1,96
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	08e080e7          	jalr	142(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010f4:	00000797          	auipc	a5,0x0
    800010f8:	db078793          	addi	a5,a5,-592 # 80000ea4 <forkret>
    800010fc:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010fe:	60bc                	ld	a5,64(s1)
    80001100:	6705                	lui	a4,0x1
    80001102:	97ba                	add	a5,a5,a4
    80001104:	f4bc                	sd	a5,104(s1)
}
    80001106:	8526                	mv	a0,s1
    80001108:	60e2                	ld	ra,24(sp)
    8000110a:	6442                	ld	s0,16(sp)
    8000110c:	64a2                	ld	s1,8(sp)
    8000110e:	6902                	ld	s2,0(sp)
    80001110:	6105                	addi	sp,sp,32
    80001112:	8082                	ret
    freeproc(p);
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	f08080e7          	jalr	-248(ra) # 8000101e <freeproc>
    release(&p->lock);
    8000111e:	8526                	mv	a0,s1
    80001120:	00005097          	auipc	ra,0x5
    80001124:	41c080e7          	jalr	1052(ra) # 8000653c <release>
    return 0;
    80001128:	84ca                	mv	s1,s2
    8000112a:	bff1                	j	80001106 <allocproc+0x90>
    freeproc(p);
    8000112c:	8526                	mv	a0,s1
    8000112e:	00000097          	auipc	ra,0x0
    80001132:	ef0080e7          	jalr	-272(ra) # 8000101e <freeproc>
    release(&p->lock);
    80001136:	8526                	mv	a0,s1
    80001138:	00005097          	auipc	ra,0x5
    8000113c:	404080e7          	jalr	1028(ra) # 8000653c <release>
    return 0;
    80001140:	84ca                	mv	s1,s2
    80001142:	b7d1                	j	80001106 <allocproc+0x90>

0000000080001144 <userinit>:
{
    80001144:	1101                	addi	sp,sp,-32
    80001146:	ec06                	sd	ra,24(sp)
    80001148:	e822                	sd	s0,16(sp)
    8000114a:	e426                	sd	s1,8(sp)
    8000114c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000114e:	00000097          	auipc	ra,0x0
    80001152:	f28080e7          	jalr	-216(ra) # 80001076 <allocproc>
    80001156:	84aa                	mv	s1,a0
  initproc = p;
    80001158:	00008797          	auipc	a5,0x8
    8000115c:	eaa7bc23          	sd	a0,-328(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001160:	03400613          	li	a2,52
    80001164:	00007597          	auipc	a1,0x7
    80001168:	6dc58593          	addi	a1,a1,1756 # 80008840 <initcode>
    8000116c:	6928                	ld	a0,80(a0)
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	67e080e7          	jalr	1662(ra) # 800007ec <uvminit>
  p->sz = PGSIZE;
    80001176:	6785                	lui	a5,0x1
    80001178:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000117a:	6cb8                	ld	a4,88(s1)
    8000117c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001180:	6cb8                	ld	a4,88(s1)
    80001182:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001184:	4641                	li	a2,16
    80001186:	00007597          	auipc	a1,0x7
    8000118a:	fe258593          	addi	a1,a1,-30 # 80008168 <etext+0x168>
    8000118e:	15848513          	addi	a0,s1,344
    80001192:	fffff097          	auipc	ra,0xfffff
    80001196:	132080e7          	jalr	306(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    8000119a:	00007517          	auipc	a0,0x7
    8000119e:	fde50513          	addi	a0,a0,-34 # 80008178 <etext+0x178>
    800011a2:	00002097          	auipc	ra,0x2
    800011a6:	4f6080e7          	jalr	1270(ra) # 80003698 <namei>
    800011aa:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011ae:	478d                	li	a5,3
    800011b0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011b2:	8526                	mv	a0,s1
    800011b4:	00005097          	auipc	ra,0x5
    800011b8:	388080e7          	jalr	904(ra) # 8000653c <release>
}
    800011bc:	60e2                	ld	ra,24(sp)
    800011be:	6442                	ld	s0,16(sp)
    800011c0:	64a2                	ld	s1,8(sp)
    800011c2:	6105                	addi	sp,sp,32
    800011c4:	8082                	ret

00000000800011c6 <growproc>:
{
    800011c6:	1101                	addi	sp,sp,-32
    800011c8:	ec06                	sd	ra,24(sp)
    800011ca:	e822                	sd	s0,16(sp)
    800011cc:	e426                	sd	s1,8(sp)
    800011ce:	e04a                	sd	s2,0(sp)
    800011d0:	1000                	addi	s0,sp,32
    800011d2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	c98080e7          	jalr	-872(ra) # 80000e6c <myproc>
    800011dc:	892a                	mv	s2,a0
  sz = p->sz;
    800011de:	652c                	ld	a1,72(a0)
    800011e0:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011e4:	00904f63          	bgtz	s1,80001202 <growproc+0x3c>
  } else if(n < 0){
    800011e8:	0204cd63          	bltz	s1,80001222 <growproc+0x5c>
  p->sz = sz;
    800011ec:	1782                	slli	a5,a5,0x20
    800011ee:	9381                	srli	a5,a5,0x20
    800011f0:	04f93423          	sd	a5,72(s2)
  return 0;
    800011f4:	4501                	li	a0,0
}
    800011f6:	60e2                	ld	ra,24(sp)
    800011f8:	6442                	ld	s0,16(sp)
    800011fa:	64a2                	ld	s1,8(sp)
    800011fc:	6902                	ld	s2,0(sp)
    800011fe:	6105                	addi	sp,sp,32
    80001200:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001202:	00f4863b          	addw	a2,s1,a5
    80001206:	1602                	slli	a2,a2,0x20
    80001208:	9201                	srli	a2,a2,0x20
    8000120a:	1582                	slli	a1,a1,0x20
    8000120c:	9181                	srli	a1,a1,0x20
    8000120e:	6928                	ld	a0,80(a0)
    80001210:	fffff097          	auipc	ra,0xfffff
    80001214:	696080e7          	jalr	1686(ra) # 800008a6 <uvmalloc>
    80001218:	0005079b          	sext.w	a5,a0
    8000121c:	fbe1                	bnez	a5,800011ec <growproc+0x26>
      return -1;
    8000121e:	557d                	li	a0,-1
    80001220:	bfd9                	j	800011f6 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001222:	00f4863b          	addw	a2,s1,a5
    80001226:	1602                	slli	a2,a2,0x20
    80001228:	9201                	srli	a2,a2,0x20
    8000122a:	1582                	slli	a1,a1,0x20
    8000122c:	9181                	srli	a1,a1,0x20
    8000122e:	6928                	ld	a0,80(a0)
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	62e080e7          	jalr	1582(ra) # 8000085e <uvmdealloc>
    80001238:	0005079b          	sext.w	a5,a0
    8000123c:	bf45                	j	800011ec <growproc+0x26>

000000008000123e <fork>:
{
    8000123e:	7139                	addi	sp,sp,-64
    80001240:	fc06                	sd	ra,56(sp)
    80001242:	f822                	sd	s0,48(sp)
    80001244:	f426                	sd	s1,40(sp)
    80001246:	f04a                	sd	s2,32(sp)
    80001248:	ec4e                	sd	s3,24(sp)
    8000124a:	e852                	sd	s4,16(sp)
    8000124c:	e456                	sd	s5,8(sp)
    8000124e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001250:	00000097          	auipc	ra,0x0
    80001254:	c1c080e7          	jalr	-996(ra) # 80000e6c <myproc>
    80001258:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	e1c080e7          	jalr	-484(ra) # 80001076 <allocproc>
    80001262:	16050163          	beqz	a0,800013c4 <fork+0x186>
    80001266:	89aa                	mv	s3,a0
    80001268:	170a0493          	addi	s1,s4,368
    8000126c:	17050913          	addi	s2,a0,368
    80001270:	3f0a0a93          	addi	s5,s4,1008
    80001274:	a039                	j	80001282 <fork+0x44>
  for (int i = 0; i < VMA_SIZE; i++) {
    80001276:	02848493          	addi	s1,s1,40
    8000127a:	02890913          	addi	s2,s2,40
    8000127e:	03548963          	beq	s1,s5,800012b0 <fork+0x72>
    if (p->VMAs[i].valid) {
    80001282:	409c                	lw	a5,0(s1)
    80001284:	dbed                	beqz	a5,80001276 <fork+0x38>
      np->VMAs[i] = p->VMAs[i];
    80001286:	608c                	ld	a1,0(s1)
    80001288:	6490                	ld	a2,8(s1)
    8000128a:	6894                	ld	a3,16(s1)
    8000128c:	6c98                	ld	a4,24(s1)
    8000128e:	709c                	ld	a5,32(s1)
    80001290:	00b93023          	sd	a1,0(s2)
    80001294:	00c93423          	sd	a2,8(s2)
    80001298:	00d93823          	sd	a3,16(s2)
    8000129c:	00e93c23          	sd	a4,24(s2)
    800012a0:	02f93023          	sd	a5,32(s2)
      filedup(p->VMAs[i].file);
    800012a4:	7088                	ld	a0,32(s1)
    800012a6:	00003097          	auipc	ra,0x3
    800012aa:	a88080e7          	jalr	-1400(ra) # 80003d2e <filedup>
    800012ae:	b7e1                	j	80001276 <fork+0x38>
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012b0:	048a3603          	ld	a2,72(s4)
    800012b4:	0509b583          	ld	a1,80(s3)
    800012b8:	050a3503          	ld	a0,80(s4)
    800012bc:	fffff097          	auipc	ra,0xfffff
    800012c0:	73a080e7          	jalr	1850(ra) # 800009f6 <uvmcopy>
    800012c4:	04054863          	bltz	a0,80001314 <fork+0xd6>
  np->sz = p->sz;
    800012c8:	048a3783          	ld	a5,72(s4)
    800012cc:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012d0:	058a3683          	ld	a3,88(s4)
    800012d4:	87b6                	mv	a5,a3
    800012d6:	0589b703          	ld	a4,88(s3)
    800012da:	12068693          	addi	a3,a3,288
    800012de:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012e2:	6788                	ld	a0,8(a5)
    800012e4:	6b8c                	ld	a1,16(a5)
    800012e6:	6f90                	ld	a2,24(a5)
    800012e8:	01073023          	sd	a6,0(a4)
    800012ec:	e708                	sd	a0,8(a4)
    800012ee:	eb0c                	sd	a1,16(a4)
    800012f0:	ef10                	sd	a2,24(a4)
    800012f2:	02078793          	addi	a5,a5,32
    800012f6:	02070713          	addi	a4,a4,32
    800012fa:	fed792e3          	bne	a5,a3,800012de <fork+0xa0>
  np->trapframe->a0 = 0;
    800012fe:	0589b783          	ld	a5,88(s3)
    80001302:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001306:	0d0a0493          	addi	s1,s4,208
    8000130a:	0d098913          	addi	s2,s3,208
    8000130e:	150a0a93          	addi	s5,s4,336
    80001312:	a03d                	j	80001340 <fork+0x102>
    freeproc(np);
    80001314:	854e                	mv	a0,s3
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	d08080e7          	jalr	-760(ra) # 8000101e <freeproc>
    release(&np->lock);
    8000131e:	854e                	mv	a0,s3
    80001320:	00005097          	auipc	ra,0x5
    80001324:	21c080e7          	jalr	540(ra) # 8000653c <release>
    return -1;
    80001328:	597d                	li	s2,-1
    8000132a:	a059                	j	800013b0 <fork+0x172>
      np->ofile[i] = filedup(p->ofile[i]);
    8000132c:	00003097          	auipc	ra,0x3
    80001330:	a02080e7          	jalr	-1534(ra) # 80003d2e <filedup>
    80001334:	00a93023          	sd	a0,0(s2)
  for(i = 0; i < NOFILE; i++)
    80001338:	04a1                	addi	s1,s1,8
    8000133a:	0921                	addi	s2,s2,8
    8000133c:	01548563          	beq	s1,s5,80001346 <fork+0x108>
    if(p->ofile[i])
    80001340:	6088                	ld	a0,0(s1)
    80001342:	f56d                	bnez	a0,8000132c <fork+0xee>
    80001344:	bfd5                	j	80001338 <fork+0xfa>
  np->cwd = idup(p->cwd);
    80001346:	150a3503          	ld	a0,336(s4)
    8000134a:	00002097          	auipc	ra,0x2
    8000134e:	b54080e7          	jalr	-1196(ra) # 80002e9e <idup>
    80001352:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001356:	4641                	li	a2,16
    80001358:	158a0593          	addi	a1,s4,344
    8000135c:	15898513          	addi	a0,s3,344
    80001360:	fffff097          	auipc	ra,0xfffff
    80001364:	f64080e7          	jalr	-156(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    80001368:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000136c:	854e                	mv	a0,s3
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	1ce080e7          	jalr	462(ra) # 8000653c <release>
  acquire(&wait_lock);
    80001376:	00008497          	auipc	s1,0x8
    8000137a:	cf248493          	addi	s1,s1,-782 # 80009068 <wait_lock>
    8000137e:	8526                	mv	a0,s1
    80001380:	00005097          	auipc	ra,0x5
    80001384:	108080e7          	jalr	264(ra) # 80006488 <acquire>
  np->parent = p;
    80001388:	0349bc23          	sd	s4,56(s3)
  release(&wait_lock);
    8000138c:	8526                	mv	a0,s1
    8000138e:	00005097          	auipc	ra,0x5
    80001392:	1ae080e7          	jalr	430(ra) # 8000653c <release>
  acquire(&np->lock);
    80001396:	854e                	mv	a0,s3
    80001398:	00005097          	auipc	ra,0x5
    8000139c:	0f0080e7          	jalr	240(ra) # 80006488 <acquire>
  np->state = RUNNABLE;
    800013a0:	478d                	li	a5,3
    800013a2:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800013a6:	854e                	mv	a0,s3
    800013a8:	00005097          	auipc	ra,0x5
    800013ac:	194080e7          	jalr	404(ra) # 8000653c <release>
}
    800013b0:	854a                	mv	a0,s2
    800013b2:	70e2                	ld	ra,56(sp)
    800013b4:	7442                	ld	s0,48(sp)
    800013b6:	74a2                	ld	s1,40(sp)
    800013b8:	7902                	ld	s2,32(sp)
    800013ba:	69e2                	ld	s3,24(sp)
    800013bc:	6a42                	ld	s4,16(sp)
    800013be:	6aa2                	ld	s5,8(sp)
    800013c0:	6121                	addi	sp,sp,64
    800013c2:	8082                	ret
    return -1;
    800013c4:	597d                	li	s2,-1
    800013c6:	b7ed                	j	800013b0 <fork+0x172>

00000000800013c8 <scheduler>:
{
    800013c8:	7139                	addi	sp,sp,-64
    800013ca:	fc06                	sd	ra,56(sp)
    800013cc:	f822                	sd	s0,48(sp)
    800013ce:	f426                	sd	s1,40(sp)
    800013d0:	f04a                	sd	s2,32(sp)
    800013d2:	ec4e                	sd	s3,24(sp)
    800013d4:	e852                	sd	s4,16(sp)
    800013d6:	e456                	sd	s5,8(sp)
    800013d8:	e05a                	sd	s6,0(sp)
    800013da:	0080                	addi	s0,sp,64
    800013dc:	8792                	mv	a5,tp
  int id = r_tp();
    800013de:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013e0:	00779a93          	slli	s5,a5,0x7
    800013e4:	00008717          	auipc	a4,0x8
    800013e8:	c6c70713          	addi	a4,a4,-916 # 80009050 <pid_lock>
    800013ec:	9756                	add	a4,a4,s5
    800013ee:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013f2:	00008717          	auipc	a4,0x8
    800013f6:	c9670713          	addi	a4,a4,-874 # 80009088 <cpus+0x8>
    800013fa:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013fc:	498d                	li	s3,3
        p->state = RUNNING;
    800013fe:	4b11                	li	s6,4
        c->proc = p;
    80001400:	079e                	slli	a5,a5,0x7
    80001402:	00008a17          	auipc	s4,0x8
    80001406:	c4ea0a13          	addi	s4,s4,-946 # 80009050 <pid_lock>
    8000140a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000140c:	00018917          	auipc	s2,0x18
    80001410:	c7490913          	addi	s2,s2,-908 # 80019080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001414:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001418:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000141c:	10079073          	csrw	sstatus,a5
    80001420:	00008497          	auipc	s1,0x8
    80001424:	06048493          	addi	s1,s1,96 # 80009480 <proc>
    80001428:	a811                	j	8000143c <scheduler+0x74>
      release(&p->lock);
    8000142a:	8526                	mv	a0,s1
    8000142c:	00005097          	auipc	ra,0x5
    80001430:	110080e7          	jalr	272(ra) # 8000653c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001434:	3f048493          	addi	s1,s1,1008
    80001438:	fd248ee3          	beq	s1,s2,80001414 <scheduler+0x4c>
      acquire(&p->lock);
    8000143c:	8526                	mv	a0,s1
    8000143e:	00005097          	auipc	ra,0x5
    80001442:	04a080e7          	jalr	74(ra) # 80006488 <acquire>
      if(p->state == RUNNABLE) {
    80001446:	4c9c                	lw	a5,24(s1)
    80001448:	ff3791e3          	bne	a5,s3,8000142a <scheduler+0x62>
        p->state = RUNNING;
    8000144c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001450:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001454:	06048593          	addi	a1,s1,96
    80001458:	8556                	mv	a0,s5
    8000145a:	00000097          	auipc	ra,0x0
    8000145e:	65a080e7          	jalr	1626(ra) # 80001ab4 <swtch>
        c->proc = 0;
    80001462:	020a3823          	sd	zero,48(s4)
    80001466:	b7d1                	j	8000142a <scheduler+0x62>

0000000080001468 <sched>:
{
    80001468:	7179                	addi	sp,sp,-48
    8000146a:	f406                	sd	ra,40(sp)
    8000146c:	f022                	sd	s0,32(sp)
    8000146e:	ec26                	sd	s1,24(sp)
    80001470:	e84a                	sd	s2,16(sp)
    80001472:	e44e                	sd	s3,8(sp)
    80001474:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001476:	00000097          	auipc	ra,0x0
    8000147a:	9f6080e7          	jalr	-1546(ra) # 80000e6c <myproc>
    8000147e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001480:	00005097          	auipc	ra,0x5
    80001484:	f8e080e7          	jalr	-114(ra) # 8000640e <holding>
    80001488:	c93d                	beqz	a0,800014fe <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000148a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000148c:	2781                	sext.w	a5,a5
    8000148e:	079e                	slli	a5,a5,0x7
    80001490:	00008717          	auipc	a4,0x8
    80001494:	bc070713          	addi	a4,a4,-1088 # 80009050 <pid_lock>
    80001498:	97ba                	add	a5,a5,a4
    8000149a:	0a87a703          	lw	a4,168(a5)
    8000149e:	4785                	li	a5,1
    800014a0:	06f71763          	bne	a4,a5,8000150e <sched+0xa6>
  if(p->state == RUNNING)
    800014a4:	4c98                	lw	a4,24(s1)
    800014a6:	4791                	li	a5,4
    800014a8:	06f70b63          	beq	a4,a5,8000151e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014b0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014b2:	efb5                	bnez	a5,8000152e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014b4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014b6:	00008917          	auipc	s2,0x8
    800014ba:	b9a90913          	addi	s2,s2,-1126 # 80009050 <pid_lock>
    800014be:	2781                	sext.w	a5,a5
    800014c0:	079e                	slli	a5,a5,0x7
    800014c2:	97ca                	add	a5,a5,s2
    800014c4:	0ac7a983          	lw	s3,172(a5)
    800014c8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014ca:	2781                	sext.w	a5,a5
    800014cc:	079e                	slli	a5,a5,0x7
    800014ce:	00008597          	auipc	a1,0x8
    800014d2:	bba58593          	addi	a1,a1,-1094 # 80009088 <cpus+0x8>
    800014d6:	95be                	add	a1,a1,a5
    800014d8:	06048513          	addi	a0,s1,96
    800014dc:	00000097          	auipc	ra,0x0
    800014e0:	5d8080e7          	jalr	1496(ra) # 80001ab4 <swtch>
    800014e4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014e6:	2781                	sext.w	a5,a5
    800014e8:	079e                	slli	a5,a5,0x7
    800014ea:	993e                	add	s2,s2,a5
    800014ec:	0b392623          	sw	s3,172(s2)
}
    800014f0:	70a2                	ld	ra,40(sp)
    800014f2:	7402                	ld	s0,32(sp)
    800014f4:	64e2                	ld	s1,24(sp)
    800014f6:	6942                	ld	s2,16(sp)
    800014f8:	69a2                	ld	s3,8(sp)
    800014fa:	6145                	addi	sp,sp,48
    800014fc:	8082                	ret
    panic("sched p->lock");
    800014fe:	00007517          	auipc	a0,0x7
    80001502:	c8250513          	addi	a0,a0,-894 # 80008180 <etext+0x180>
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	a4a080e7          	jalr	-1462(ra) # 80005f50 <panic>
    panic("sched locks");
    8000150e:	00007517          	auipc	a0,0x7
    80001512:	c8250513          	addi	a0,a0,-894 # 80008190 <etext+0x190>
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	a3a080e7          	jalr	-1478(ra) # 80005f50 <panic>
    panic("sched running");
    8000151e:	00007517          	auipc	a0,0x7
    80001522:	c8250513          	addi	a0,a0,-894 # 800081a0 <etext+0x1a0>
    80001526:	00005097          	auipc	ra,0x5
    8000152a:	a2a080e7          	jalr	-1494(ra) # 80005f50 <panic>
    panic("sched interruptible");
    8000152e:	00007517          	auipc	a0,0x7
    80001532:	c8250513          	addi	a0,a0,-894 # 800081b0 <etext+0x1b0>
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	a1a080e7          	jalr	-1510(ra) # 80005f50 <panic>

000000008000153e <yield>:
{
    8000153e:	1101                	addi	sp,sp,-32
    80001540:	ec06                	sd	ra,24(sp)
    80001542:	e822                	sd	s0,16(sp)
    80001544:	e426                	sd	s1,8(sp)
    80001546:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	924080e7          	jalr	-1756(ra) # 80000e6c <myproc>
    80001550:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001552:	00005097          	auipc	ra,0x5
    80001556:	f36080e7          	jalr	-202(ra) # 80006488 <acquire>
  p->state = RUNNABLE;
    8000155a:	478d                	li	a5,3
    8000155c:	cc9c                	sw	a5,24(s1)
  sched();
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	f0a080e7          	jalr	-246(ra) # 80001468 <sched>
  release(&p->lock);
    80001566:	8526                	mv	a0,s1
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	fd4080e7          	jalr	-44(ra) # 8000653c <release>
}
    80001570:	60e2                	ld	ra,24(sp)
    80001572:	6442                	ld	s0,16(sp)
    80001574:	64a2                	ld	s1,8(sp)
    80001576:	6105                	addi	sp,sp,32
    80001578:	8082                	ret

000000008000157a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000157a:	7179                	addi	sp,sp,-48
    8000157c:	f406                	sd	ra,40(sp)
    8000157e:	f022                	sd	s0,32(sp)
    80001580:	ec26                	sd	s1,24(sp)
    80001582:	e84a                	sd	s2,16(sp)
    80001584:	e44e                	sd	s3,8(sp)
    80001586:	1800                	addi	s0,sp,48
    80001588:	89aa                	mv	s3,a0
    8000158a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	8e0080e7          	jalr	-1824(ra) # 80000e6c <myproc>
    80001594:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001596:	00005097          	auipc	ra,0x5
    8000159a:	ef2080e7          	jalr	-270(ra) # 80006488 <acquire>
  release(lk);
    8000159e:	854a                	mv	a0,s2
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	f9c080e7          	jalr	-100(ra) # 8000653c <release>

  // Go to sleep.
  p->chan = chan;
    800015a8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015ac:	4789                	li	a5,2
    800015ae:	cc9c                	sw	a5,24(s1)

  sched();
    800015b0:	00000097          	auipc	ra,0x0
    800015b4:	eb8080e7          	jalr	-328(ra) # 80001468 <sched>

  // Tidy up.
  p->chan = 0;
    800015b8:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015bc:	8526                	mv	a0,s1
    800015be:	00005097          	auipc	ra,0x5
    800015c2:	f7e080e7          	jalr	-130(ra) # 8000653c <release>
  acquire(lk);
    800015c6:	854a                	mv	a0,s2
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	ec0080e7          	jalr	-320(ra) # 80006488 <acquire>
}
    800015d0:	70a2                	ld	ra,40(sp)
    800015d2:	7402                	ld	s0,32(sp)
    800015d4:	64e2                	ld	s1,24(sp)
    800015d6:	6942                	ld	s2,16(sp)
    800015d8:	69a2                	ld	s3,8(sp)
    800015da:	6145                	addi	sp,sp,48
    800015dc:	8082                	ret

00000000800015de <wait>:
{
    800015de:	715d                	addi	sp,sp,-80
    800015e0:	e486                	sd	ra,72(sp)
    800015e2:	e0a2                	sd	s0,64(sp)
    800015e4:	fc26                	sd	s1,56(sp)
    800015e6:	f84a                	sd	s2,48(sp)
    800015e8:	f44e                	sd	s3,40(sp)
    800015ea:	f052                	sd	s4,32(sp)
    800015ec:	ec56                	sd	s5,24(sp)
    800015ee:	e85a                	sd	s6,16(sp)
    800015f0:	e45e                	sd	s7,8(sp)
    800015f2:	e062                	sd	s8,0(sp)
    800015f4:	0880                	addi	s0,sp,80
    800015f6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015f8:	00000097          	auipc	ra,0x0
    800015fc:	874080e7          	jalr	-1932(ra) # 80000e6c <myproc>
    80001600:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001602:	00008517          	auipc	a0,0x8
    80001606:	a6650513          	addi	a0,a0,-1434 # 80009068 <wait_lock>
    8000160a:	00005097          	auipc	ra,0x5
    8000160e:	e7e080e7          	jalr	-386(ra) # 80006488 <acquire>
    havekids = 0;
    80001612:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001614:	4a15                	li	s4,5
        havekids = 1;
    80001616:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001618:	00018997          	auipc	s3,0x18
    8000161c:	a6898993          	addi	s3,s3,-1432 # 80019080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001620:	00008c17          	auipc	s8,0x8
    80001624:	a48c0c13          	addi	s8,s8,-1464 # 80009068 <wait_lock>
    havekids = 0;
    80001628:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000162a:	00008497          	auipc	s1,0x8
    8000162e:	e5648493          	addi	s1,s1,-426 # 80009480 <proc>
    80001632:	a0bd                	j	800016a0 <wait+0xc2>
          pid = np->pid;
    80001634:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001638:	000b0e63          	beqz	s6,80001654 <wait+0x76>
    8000163c:	4691                	li	a3,4
    8000163e:	02c48613          	addi	a2,s1,44
    80001642:	85da                	mv	a1,s6
    80001644:	05093503          	ld	a0,80(s2)
    80001648:	fffff097          	auipc	ra,0xfffff
    8000164c:	4b2080e7          	jalr	1202(ra) # 80000afa <copyout>
    80001650:	02054563          	bltz	a0,8000167a <wait+0x9c>
          freeproc(np);
    80001654:	8526                	mv	a0,s1
    80001656:	00000097          	auipc	ra,0x0
    8000165a:	9c8080e7          	jalr	-1592(ra) # 8000101e <freeproc>
          release(&np->lock);
    8000165e:	8526                	mv	a0,s1
    80001660:	00005097          	auipc	ra,0x5
    80001664:	edc080e7          	jalr	-292(ra) # 8000653c <release>
          release(&wait_lock);
    80001668:	00008517          	auipc	a0,0x8
    8000166c:	a0050513          	addi	a0,a0,-1536 # 80009068 <wait_lock>
    80001670:	00005097          	auipc	ra,0x5
    80001674:	ecc080e7          	jalr	-308(ra) # 8000653c <release>
          return pid;
    80001678:	a09d                	j	800016de <wait+0x100>
            release(&np->lock);
    8000167a:	8526                	mv	a0,s1
    8000167c:	00005097          	auipc	ra,0x5
    80001680:	ec0080e7          	jalr	-320(ra) # 8000653c <release>
            release(&wait_lock);
    80001684:	00008517          	auipc	a0,0x8
    80001688:	9e450513          	addi	a0,a0,-1564 # 80009068 <wait_lock>
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	eb0080e7          	jalr	-336(ra) # 8000653c <release>
            return -1;
    80001694:	59fd                	li	s3,-1
    80001696:	a0a1                	j	800016de <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001698:	3f048493          	addi	s1,s1,1008
    8000169c:	03348463          	beq	s1,s3,800016c4 <wait+0xe6>
      if(np->parent == p){
    800016a0:	7c9c                	ld	a5,56(s1)
    800016a2:	ff279be3          	bne	a5,s2,80001698 <wait+0xba>
        acquire(&np->lock);
    800016a6:	8526                	mv	a0,s1
    800016a8:	00005097          	auipc	ra,0x5
    800016ac:	de0080e7          	jalr	-544(ra) # 80006488 <acquire>
        if(np->state == ZOMBIE){
    800016b0:	4c9c                	lw	a5,24(s1)
    800016b2:	f94781e3          	beq	a5,s4,80001634 <wait+0x56>
        release(&np->lock);
    800016b6:	8526                	mv	a0,s1
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	e84080e7          	jalr	-380(ra) # 8000653c <release>
        havekids = 1;
    800016c0:	8756                	mv	a4,s5
    800016c2:	bfd9                	j	80001698 <wait+0xba>
    if(!havekids || p->killed){
    800016c4:	c701                	beqz	a4,800016cc <wait+0xee>
    800016c6:	02892783          	lw	a5,40(s2)
    800016ca:	c79d                	beqz	a5,800016f8 <wait+0x11a>
      release(&wait_lock);
    800016cc:	00008517          	auipc	a0,0x8
    800016d0:	99c50513          	addi	a0,a0,-1636 # 80009068 <wait_lock>
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	e68080e7          	jalr	-408(ra) # 8000653c <release>
      return -1;
    800016dc:	59fd                	li	s3,-1
}
    800016de:	854e                	mv	a0,s3
    800016e0:	60a6                	ld	ra,72(sp)
    800016e2:	6406                	ld	s0,64(sp)
    800016e4:	74e2                	ld	s1,56(sp)
    800016e6:	7942                	ld	s2,48(sp)
    800016e8:	79a2                	ld	s3,40(sp)
    800016ea:	7a02                	ld	s4,32(sp)
    800016ec:	6ae2                	ld	s5,24(sp)
    800016ee:	6b42                	ld	s6,16(sp)
    800016f0:	6ba2                	ld	s7,8(sp)
    800016f2:	6c02                	ld	s8,0(sp)
    800016f4:	6161                	addi	sp,sp,80
    800016f6:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016f8:	85e2                	mv	a1,s8
    800016fa:	854a                	mv	a0,s2
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	e7e080e7          	jalr	-386(ra) # 8000157a <sleep>
    havekids = 0;
    80001704:	b715                	j	80001628 <wait+0x4a>

0000000080001706 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001706:	7139                	addi	sp,sp,-64
    80001708:	fc06                	sd	ra,56(sp)
    8000170a:	f822                	sd	s0,48(sp)
    8000170c:	f426                	sd	s1,40(sp)
    8000170e:	f04a                	sd	s2,32(sp)
    80001710:	ec4e                	sd	s3,24(sp)
    80001712:	e852                	sd	s4,16(sp)
    80001714:	e456                	sd	s5,8(sp)
    80001716:	0080                	addi	s0,sp,64
    80001718:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000171a:	00008497          	auipc	s1,0x8
    8000171e:	d6648493          	addi	s1,s1,-666 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001722:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001724:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001726:	00018917          	auipc	s2,0x18
    8000172a:	95a90913          	addi	s2,s2,-1702 # 80019080 <tickslock>
    8000172e:	a811                	j	80001742 <wakeup+0x3c>
      }
      release(&p->lock);
    80001730:	8526                	mv	a0,s1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	e0a080e7          	jalr	-502(ra) # 8000653c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000173a:	3f048493          	addi	s1,s1,1008
    8000173e:	03248663          	beq	s1,s2,8000176a <wakeup+0x64>
    if(p != myproc()){
    80001742:	fffff097          	auipc	ra,0xfffff
    80001746:	72a080e7          	jalr	1834(ra) # 80000e6c <myproc>
    8000174a:	fea488e3          	beq	s1,a0,8000173a <wakeup+0x34>
      acquire(&p->lock);
    8000174e:	8526                	mv	a0,s1
    80001750:	00005097          	auipc	ra,0x5
    80001754:	d38080e7          	jalr	-712(ra) # 80006488 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001758:	4c9c                	lw	a5,24(s1)
    8000175a:	fd379be3          	bne	a5,s3,80001730 <wakeup+0x2a>
    8000175e:	709c                	ld	a5,32(s1)
    80001760:	fd4798e3          	bne	a5,s4,80001730 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001764:	0154ac23          	sw	s5,24(s1)
    80001768:	b7e1                	j	80001730 <wakeup+0x2a>
    }
  }
}
    8000176a:	70e2                	ld	ra,56(sp)
    8000176c:	7442                	ld	s0,48(sp)
    8000176e:	74a2                	ld	s1,40(sp)
    80001770:	7902                	ld	s2,32(sp)
    80001772:	69e2                	ld	s3,24(sp)
    80001774:	6a42                	ld	s4,16(sp)
    80001776:	6aa2                	ld	s5,8(sp)
    80001778:	6121                	addi	sp,sp,64
    8000177a:	8082                	ret

000000008000177c <reparent>:
{
    8000177c:	7179                	addi	sp,sp,-48
    8000177e:	f406                	sd	ra,40(sp)
    80001780:	f022                	sd	s0,32(sp)
    80001782:	ec26                	sd	s1,24(sp)
    80001784:	e84a                	sd	s2,16(sp)
    80001786:	e44e                	sd	s3,8(sp)
    80001788:	e052                	sd	s4,0(sp)
    8000178a:	1800                	addi	s0,sp,48
    8000178c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000178e:	00008497          	auipc	s1,0x8
    80001792:	cf248493          	addi	s1,s1,-782 # 80009480 <proc>
      pp->parent = initproc;
    80001796:	00008a17          	auipc	s4,0x8
    8000179a:	87aa0a13          	addi	s4,s4,-1926 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000179e:	00018997          	auipc	s3,0x18
    800017a2:	8e298993          	addi	s3,s3,-1822 # 80019080 <tickslock>
    800017a6:	a029                	j	800017b0 <reparent+0x34>
    800017a8:	3f048493          	addi	s1,s1,1008
    800017ac:	01348d63          	beq	s1,s3,800017c6 <reparent+0x4a>
    if(pp->parent == p){
    800017b0:	7c9c                	ld	a5,56(s1)
    800017b2:	ff279be3          	bne	a5,s2,800017a8 <reparent+0x2c>
      pp->parent = initproc;
    800017b6:	000a3503          	ld	a0,0(s4)
    800017ba:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017bc:	00000097          	auipc	ra,0x0
    800017c0:	f4a080e7          	jalr	-182(ra) # 80001706 <wakeup>
    800017c4:	b7d5                	j	800017a8 <reparent+0x2c>
}
    800017c6:	70a2                	ld	ra,40(sp)
    800017c8:	7402                	ld	s0,32(sp)
    800017ca:	64e2                	ld	s1,24(sp)
    800017cc:	6942                	ld	s2,16(sp)
    800017ce:	69a2                	ld	s3,8(sp)
    800017d0:	6a02                	ld	s4,0(sp)
    800017d2:	6145                	addi	sp,sp,48
    800017d4:	8082                	ret

00000000800017d6 <exit>:
{
    800017d6:	7179                	addi	sp,sp,-48
    800017d8:	f406                	sd	ra,40(sp)
    800017da:	f022                	sd	s0,32(sp)
    800017dc:	ec26                	sd	s1,24(sp)
    800017de:	e84a                	sd	s2,16(sp)
    800017e0:	e44e                	sd	s3,8(sp)
    800017e2:	e052                	sd	s4,0(sp)
    800017e4:	1800                	addi	s0,sp,48
    800017e6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017e8:	fffff097          	auipc	ra,0xfffff
    800017ec:	684080e7          	jalr	1668(ra) # 80000e6c <myproc>
    800017f0:	892a                	mv	s2,a0
  for (int i = 0; i < VMA_SIZE; i++) {
    800017f2:	17050493          	addi	s1,a0,368
    800017f6:	3f050993          	addi	s3,a0,1008
    800017fa:	a029                	j	80001804 <exit+0x2e>
    800017fc:	02848493          	addi	s1,s1,40
    80001800:	03348663          	beq	s1,s3,8000182c <exit+0x56>
    if (p->VMAs[i].valid) {
    80001804:	409c                	lw	a5,0(s1)
    80001806:	dbfd                	beqz	a5,800017fc <exit+0x26>
      uvmunmap(p->pagetable, p->VMAs[i].addr, p->VMAs[i].size, 1);
    80001808:	4685                	li	a3,1
    8000180a:	6890                	ld	a2,16(s1)
    8000180c:	648c                	ld	a1,8(s1)
    8000180e:	05093503          	ld	a0,80(s2)
    80001812:	fffff097          	auipc	ra,0xfffff
    80001816:	ef6080e7          	jalr	-266(ra) # 80000708 <uvmunmap>
      memset(&p->VMAs[i], 0, sizeof(struct VMA)); 
    8000181a:	02800613          	li	a2,40
    8000181e:	4581                	li	a1,0
    80001820:	8526                	mv	a0,s1
    80001822:	fffff097          	auipc	ra,0xfffff
    80001826:	958080e7          	jalr	-1704(ra) # 8000017a <memset>
    8000182a:	bfc9                	j	800017fc <exit+0x26>
  if(p == initproc)
    8000182c:	00007797          	auipc	a5,0x7
    80001830:	7e47b783          	ld	a5,2020(a5) # 80009010 <initproc>
    80001834:	0d090493          	addi	s1,s2,208
    80001838:	15090993          	addi	s3,s2,336
    8000183c:	01279d63          	bne	a5,s2,80001856 <exit+0x80>
    panic("init exiting");
    80001840:	00007517          	auipc	a0,0x7
    80001844:	98850513          	addi	a0,a0,-1656 # 800081c8 <etext+0x1c8>
    80001848:	00004097          	auipc	ra,0x4
    8000184c:	708080e7          	jalr	1800(ra) # 80005f50 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001850:	04a1                	addi	s1,s1,8
    80001852:	01348b63          	beq	s1,s3,80001868 <exit+0x92>
    if(p->ofile[fd]){
    80001856:	6088                	ld	a0,0(s1)
    80001858:	dd65                	beqz	a0,80001850 <exit+0x7a>
      fileclose(f);
    8000185a:	00002097          	auipc	ra,0x2
    8000185e:	526080e7          	jalr	1318(ra) # 80003d80 <fileclose>
      p->ofile[fd] = 0;
    80001862:	0004b023          	sd	zero,0(s1)
    80001866:	b7ed                	j	80001850 <exit+0x7a>
  begin_op();
    80001868:	00002097          	auipc	ra,0x2
    8000186c:	050080e7          	jalr	80(ra) # 800038b8 <begin_op>
  iput(p->cwd);
    80001870:	15093503          	ld	a0,336(s2)
    80001874:	00002097          	auipc	ra,0x2
    80001878:	822080e7          	jalr	-2014(ra) # 80003096 <iput>
  end_op();
    8000187c:	00002097          	auipc	ra,0x2
    80001880:	0ba080e7          	jalr	186(ra) # 80003936 <end_op>
  p->cwd = 0;
    80001884:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    80001888:	00007497          	auipc	s1,0x7
    8000188c:	7e048493          	addi	s1,s1,2016 # 80009068 <wait_lock>
    80001890:	8526                	mv	a0,s1
    80001892:	00005097          	auipc	ra,0x5
    80001896:	bf6080e7          	jalr	-1034(ra) # 80006488 <acquire>
  reparent(p);
    8000189a:	854a                	mv	a0,s2
    8000189c:	00000097          	auipc	ra,0x0
    800018a0:	ee0080e7          	jalr	-288(ra) # 8000177c <reparent>
  wakeup(p->parent);
    800018a4:	03893503          	ld	a0,56(s2)
    800018a8:	00000097          	auipc	ra,0x0
    800018ac:	e5e080e7          	jalr	-418(ra) # 80001706 <wakeup>
  acquire(&p->lock);
    800018b0:	854a                	mv	a0,s2
    800018b2:	00005097          	auipc	ra,0x5
    800018b6:	bd6080e7          	jalr	-1066(ra) # 80006488 <acquire>
  p->xstate = status;
    800018ba:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    800018be:	4795                	li	a5,5
    800018c0:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    800018c4:	8526                	mv	a0,s1
    800018c6:	00005097          	auipc	ra,0x5
    800018ca:	c76080e7          	jalr	-906(ra) # 8000653c <release>
  sched();
    800018ce:	00000097          	auipc	ra,0x0
    800018d2:	b9a080e7          	jalr	-1126(ra) # 80001468 <sched>
  panic("zombie exit");
    800018d6:	00007517          	auipc	a0,0x7
    800018da:	90250513          	addi	a0,a0,-1790 # 800081d8 <etext+0x1d8>
    800018de:	00004097          	auipc	ra,0x4
    800018e2:	672080e7          	jalr	1650(ra) # 80005f50 <panic>

00000000800018e6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018e6:	7179                	addi	sp,sp,-48
    800018e8:	f406                	sd	ra,40(sp)
    800018ea:	f022                	sd	s0,32(sp)
    800018ec:	ec26                	sd	s1,24(sp)
    800018ee:	e84a                	sd	s2,16(sp)
    800018f0:	e44e                	sd	s3,8(sp)
    800018f2:	1800                	addi	s0,sp,48
    800018f4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018f6:	00008497          	auipc	s1,0x8
    800018fa:	b8a48493          	addi	s1,s1,-1142 # 80009480 <proc>
    800018fe:	00017997          	auipc	s3,0x17
    80001902:	78298993          	addi	s3,s3,1922 # 80019080 <tickslock>
    acquire(&p->lock);
    80001906:	8526                	mv	a0,s1
    80001908:	00005097          	auipc	ra,0x5
    8000190c:	b80080e7          	jalr	-1152(ra) # 80006488 <acquire>
    if(p->pid == pid){
    80001910:	589c                	lw	a5,48(s1)
    80001912:	01278d63          	beq	a5,s2,8000192c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001916:	8526                	mv	a0,s1
    80001918:	00005097          	auipc	ra,0x5
    8000191c:	c24080e7          	jalr	-988(ra) # 8000653c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001920:	3f048493          	addi	s1,s1,1008
    80001924:	ff3491e3          	bne	s1,s3,80001906 <kill+0x20>
  }
  return -1;
    80001928:	557d                	li	a0,-1
    8000192a:	a829                	j	80001944 <kill+0x5e>
      p->killed = 1;
    8000192c:	4785                	li	a5,1
    8000192e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001930:	4c98                	lw	a4,24(s1)
    80001932:	4789                	li	a5,2
    80001934:	00f70f63          	beq	a4,a5,80001952 <kill+0x6c>
      release(&p->lock);
    80001938:	8526                	mv	a0,s1
    8000193a:	00005097          	auipc	ra,0x5
    8000193e:	c02080e7          	jalr	-1022(ra) # 8000653c <release>
      return 0;
    80001942:	4501                	li	a0,0
}
    80001944:	70a2                	ld	ra,40(sp)
    80001946:	7402                	ld	s0,32(sp)
    80001948:	64e2                	ld	s1,24(sp)
    8000194a:	6942                	ld	s2,16(sp)
    8000194c:	69a2                	ld	s3,8(sp)
    8000194e:	6145                	addi	sp,sp,48
    80001950:	8082                	ret
        p->state = RUNNABLE;
    80001952:	478d                	li	a5,3
    80001954:	cc9c                	sw	a5,24(s1)
    80001956:	b7cd                	j	80001938 <kill+0x52>

0000000080001958 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001958:	7179                	addi	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	e84a                	sd	s2,16(sp)
    80001962:	e44e                	sd	s3,8(sp)
    80001964:	e052                	sd	s4,0(sp)
    80001966:	1800                	addi	s0,sp,48
    80001968:	84aa                	mv	s1,a0
    8000196a:	892e                	mv	s2,a1
    8000196c:	89b2                	mv	s3,a2
    8000196e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	4fc080e7          	jalr	1276(ra) # 80000e6c <myproc>
  if(user_dst){
    80001978:	c08d                	beqz	s1,8000199a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000197a:	86d2                	mv	a3,s4
    8000197c:	864e                	mv	a2,s3
    8000197e:	85ca                	mv	a1,s2
    80001980:	6928                	ld	a0,80(a0)
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	178080e7          	jalr	376(ra) # 80000afa <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000198a:	70a2                	ld	ra,40(sp)
    8000198c:	7402                	ld	s0,32(sp)
    8000198e:	64e2                	ld	s1,24(sp)
    80001990:	6942                	ld	s2,16(sp)
    80001992:	69a2                	ld	s3,8(sp)
    80001994:	6a02                	ld	s4,0(sp)
    80001996:	6145                	addi	sp,sp,48
    80001998:	8082                	ret
    memmove((char *)dst, src, len);
    8000199a:	000a061b          	sext.w	a2,s4
    8000199e:	85ce                	mv	a1,s3
    800019a0:	854a                	mv	a0,s2
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	834080e7          	jalr	-1996(ra) # 800001d6 <memmove>
    return 0;
    800019aa:	8526                	mv	a0,s1
    800019ac:	bff9                	j	8000198a <either_copyout+0x32>

00000000800019ae <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019ae:	7179                	addi	sp,sp,-48
    800019b0:	f406                	sd	ra,40(sp)
    800019b2:	f022                	sd	s0,32(sp)
    800019b4:	ec26                	sd	s1,24(sp)
    800019b6:	e84a                	sd	s2,16(sp)
    800019b8:	e44e                	sd	s3,8(sp)
    800019ba:	e052                	sd	s4,0(sp)
    800019bc:	1800                	addi	s0,sp,48
    800019be:	892a                	mv	s2,a0
    800019c0:	84ae                	mv	s1,a1
    800019c2:	89b2                	mv	s3,a2
    800019c4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019c6:	fffff097          	auipc	ra,0xfffff
    800019ca:	4a6080e7          	jalr	1190(ra) # 80000e6c <myproc>
  if(user_src){
    800019ce:	c08d                	beqz	s1,800019f0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019d0:	86d2                	mv	a3,s4
    800019d2:	864e                	mv	a2,s3
    800019d4:	85ca                	mv	a1,s2
    800019d6:	6928                	ld	a0,80(a0)
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	1ae080e7          	jalr	430(ra) # 80000b86 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019e0:	70a2                	ld	ra,40(sp)
    800019e2:	7402                	ld	s0,32(sp)
    800019e4:	64e2                	ld	s1,24(sp)
    800019e6:	6942                	ld	s2,16(sp)
    800019e8:	69a2                	ld	s3,8(sp)
    800019ea:	6a02                	ld	s4,0(sp)
    800019ec:	6145                	addi	sp,sp,48
    800019ee:	8082                	ret
    memmove(dst, (char*)src, len);
    800019f0:	000a061b          	sext.w	a2,s4
    800019f4:	85ce                	mv	a1,s3
    800019f6:	854a                	mv	a0,s2
    800019f8:	ffffe097          	auipc	ra,0xffffe
    800019fc:	7de080e7          	jalr	2014(ra) # 800001d6 <memmove>
    return 0;
    80001a00:	8526                	mv	a0,s1
    80001a02:	bff9                	j	800019e0 <either_copyin+0x32>

0000000080001a04 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a04:	715d                	addi	sp,sp,-80
    80001a06:	e486                	sd	ra,72(sp)
    80001a08:	e0a2                	sd	s0,64(sp)
    80001a0a:	fc26                	sd	s1,56(sp)
    80001a0c:	f84a                	sd	s2,48(sp)
    80001a0e:	f44e                	sd	s3,40(sp)
    80001a10:	f052                	sd	s4,32(sp)
    80001a12:	ec56                	sd	s5,24(sp)
    80001a14:	e85a                	sd	s6,16(sp)
    80001a16:	e45e                	sd	s7,8(sp)
    80001a18:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a1a:	00006517          	auipc	a0,0x6
    80001a1e:	62e50513          	addi	a0,a0,1582 # 80008048 <etext+0x48>
    80001a22:	00004097          	auipc	ra,0x4
    80001a26:	578080e7          	jalr	1400(ra) # 80005f9a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2a:	00008497          	auipc	s1,0x8
    80001a2e:	bae48493          	addi	s1,s1,-1106 # 800095d8 <proc+0x158>
    80001a32:	00017917          	auipc	s2,0x17
    80001a36:	7a690913          	addi	s2,s2,1958 # 800191d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a3c:	00006997          	auipc	s3,0x6
    80001a40:	7ac98993          	addi	s3,s3,1964 # 800081e8 <etext+0x1e8>
    printf("%d %s %s", p->pid, state, p->name);
    80001a44:	00006a97          	auipc	s5,0x6
    80001a48:	7aca8a93          	addi	s5,s5,1964 # 800081f0 <etext+0x1f0>
    printf("\n");
    80001a4c:	00006a17          	auipc	s4,0x6
    80001a50:	5fca0a13          	addi	s4,s4,1532 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a54:	00006b97          	auipc	s7,0x6
    80001a58:	7d4b8b93          	addi	s7,s7,2004 # 80008228 <states.0>
    80001a5c:	a00d                	j	80001a7e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a5e:	ed86a583          	lw	a1,-296(a3)
    80001a62:	8556                	mv	a0,s5
    80001a64:	00004097          	auipc	ra,0x4
    80001a68:	536080e7          	jalr	1334(ra) # 80005f9a <printf>
    printf("\n");
    80001a6c:	8552                	mv	a0,s4
    80001a6e:	00004097          	auipc	ra,0x4
    80001a72:	52c080e7          	jalr	1324(ra) # 80005f9a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a76:	3f048493          	addi	s1,s1,1008
    80001a7a:	03248263          	beq	s1,s2,80001a9e <procdump+0x9a>
    if(p->state == UNUSED)
    80001a7e:	86a6                	mv	a3,s1
    80001a80:	ec04a783          	lw	a5,-320(s1)
    80001a84:	dbed                	beqz	a5,80001a76 <procdump+0x72>
      state = "???";
    80001a86:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a88:	fcfb6be3          	bltu	s6,a5,80001a5e <procdump+0x5a>
    80001a8c:	02079713          	slli	a4,a5,0x20
    80001a90:	01d75793          	srli	a5,a4,0x1d
    80001a94:	97de                	add	a5,a5,s7
    80001a96:	6390                	ld	a2,0(a5)
    80001a98:	f279                	bnez	a2,80001a5e <procdump+0x5a>
      state = "???";
    80001a9a:	864e                	mv	a2,s3
    80001a9c:	b7c9                	j	80001a5e <procdump+0x5a>
  }
}
    80001a9e:	60a6                	ld	ra,72(sp)
    80001aa0:	6406                	ld	s0,64(sp)
    80001aa2:	74e2                	ld	s1,56(sp)
    80001aa4:	7942                	ld	s2,48(sp)
    80001aa6:	79a2                	ld	s3,40(sp)
    80001aa8:	7a02                	ld	s4,32(sp)
    80001aaa:	6ae2                	ld	s5,24(sp)
    80001aac:	6b42                	ld	s6,16(sp)
    80001aae:	6ba2                	ld	s7,8(sp)
    80001ab0:	6161                	addi	sp,sp,80
    80001ab2:	8082                	ret

0000000080001ab4 <swtch>:
    80001ab4:	00153023          	sd	ra,0(a0)
    80001ab8:	00253423          	sd	sp,8(a0)
    80001abc:	e900                	sd	s0,16(a0)
    80001abe:	ed04                	sd	s1,24(a0)
    80001ac0:	03253023          	sd	s2,32(a0)
    80001ac4:	03353423          	sd	s3,40(a0)
    80001ac8:	03453823          	sd	s4,48(a0)
    80001acc:	03553c23          	sd	s5,56(a0)
    80001ad0:	05653023          	sd	s6,64(a0)
    80001ad4:	05753423          	sd	s7,72(a0)
    80001ad8:	05853823          	sd	s8,80(a0)
    80001adc:	05953c23          	sd	s9,88(a0)
    80001ae0:	07a53023          	sd	s10,96(a0)
    80001ae4:	07b53423          	sd	s11,104(a0)
    80001ae8:	0005b083          	ld	ra,0(a1)
    80001aec:	0085b103          	ld	sp,8(a1)
    80001af0:	6980                	ld	s0,16(a1)
    80001af2:	6d84                	ld	s1,24(a1)
    80001af4:	0205b903          	ld	s2,32(a1)
    80001af8:	0285b983          	ld	s3,40(a1)
    80001afc:	0305ba03          	ld	s4,48(a1)
    80001b00:	0385ba83          	ld	s5,56(a1)
    80001b04:	0405bb03          	ld	s6,64(a1)
    80001b08:	0485bb83          	ld	s7,72(a1)
    80001b0c:	0505bc03          	ld	s8,80(a1)
    80001b10:	0585bc83          	ld	s9,88(a1)
    80001b14:	0605bd03          	ld	s10,96(a1)
    80001b18:	0685bd83          	ld	s11,104(a1)
    80001b1c:	8082                	ret

0000000080001b1e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b1e:	1141                	addi	sp,sp,-16
    80001b20:	e406                	sd	ra,8(sp)
    80001b22:	e022                	sd	s0,0(sp)
    80001b24:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b26:	00006597          	auipc	a1,0x6
    80001b2a:	73258593          	addi	a1,a1,1842 # 80008258 <states.0+0x30>
    80001b2e:	00017517          	auipc	a0,0x17
    80001b32:	55250513          	addi	a0,a0,1362 # 80019080 <tickslock>
    80001b36:	00005097          	auipc	ra,0x5
    80001b3a:	8c2080e7          	jalr	-1854(ra) # 800063f8 <initlock>
}
    80001b3e:	60a2                	ld	ra,8(sp)
    80001b40:	6402                	ld	s0,0(sp)
    80001b42:	0141                	addi	sp,sp,16
    80001b44:	8082                	ret

0000000080001b46 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b46:	1141                	addi	sp,sp,-16
    80001b48:	e422                	sd	s0,8(sp)
    80001b4a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b4c:	00004797          	auipc	a5,0x4
    80001b50:	86478793          	addi	a5,a5,-1948 # 800053b0 <kernelvec>
    80001b54:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b58:	6422                	ld	s0,8(sp)
    80001b5a:	0141                	addi	sp,sp,16
    80001b5c:	8082                	ret

0000000080001b5e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b5e:	1141                	addi	sp,sp,-16
    80001b60:	e406                	sd	ra,8(sp)
    80001b62:	e022                	sd	s0,0(sp)
    80001b64:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b66:	fffff097          	auipc	ra,0xfffff
    80001b6a:	306080e7          	jalr	774(ra) # 80000e6c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b72:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b74:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b78:	00005697          	auipc	a3,0x5
    80001b7c:	48868693          	addi	a3,a3,1160 # 80007000 <_trampoline>
    80001b80:	00005717          	auipc	a4,0x5
    80001b84:	48070713          	addi	a4,a4,1152 # 80007000 <_trampoline>
    80001b88:	8f15                	sub	a4,a4,a3
    80001b8a:	040007b7          	lui	a5,0x4000
    80001b8e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b90:	07b2                	slli	a5,a5,0xc
    80001b92:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b94:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b98:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b9a:	18002673          	csrr	a2,satp
    80001b9e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba0:	6d30                	ld	a2,88(a0)
    80001ba2:	6138                	ld	a4,64(a0)
    80001ba4:	6585                	lui	a1,0x1
    80001ba6:	972e                	add	a4,a4,a1
    80001ba8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001baa:	6d38                	ld	a4,88(a0)
    80001bac:	00000617          	auipc	a2,0x0
    80001bb0:	13860613          	addi	a2,a2,312 # 80001ce4 <usertrap>
    80001bb4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bb6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bb8:	8612                	mv	a2,tp
    80001bba:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bbc:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bc4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bcc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bce:	6f18                	ld	a4,24(a4)
    80001bd0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bd4:	692c                	ld	a1,80(a0)
    80001bd6:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bd8:	00005717          	auipc	a4,0x5
    80001bdc:	4b870713          	addi	a4,a4,1208 # 80007090 <userret>
    80001be0:	8f15                	sub	a4,a4,a3
    80001be2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001be4:	577d                	li	a4,-1
    80001be6:	177e                	slli	a4,a4,0x3f
    80001be8:	8dd9                	or	a1,a1,a4
    80001bea:	02000537          	lui	a0,0x2000
    80001bee:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bf0:	0536                	slli	a0,a0,0xd
    80001bf2:	9782                	jalr	a5
}
    80001bf4:	60a2                	ld	ra,8(sp)
    80001bf6:	6402                	ld	s0,0(sp)
    80001bf8:	0141                	addi	sp,sp,16
    80001bfa:	8082                	ret

0000000080001bfc <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bfc:	1101                	addi	sp,sp,-32
    80001bfe:	ec06                	sd	ra,24(sp)
    80001c00:	e822                	sd	s0,16(sp)
    80001c02:	e426                	sd	s1,8(sp)
    80001c04:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c06:	00017497          	auipc	s1,0x17
    80001c0a:	47a48493          	addi	s1,s1,1146 # 80019080 <tickslock>
    80001c0e:	8526                	mv	a0,s1
    80001c10:	00005097          	auipc	ra,0x5
    80001c14:	878080e7          	jalr	-1928(ra) # 80006488 <acquire>
  ticks++;
    80001c18:	00007517          	auipc	a0,0x7
    80001c1c:	40050513          	addi	a0,a0,1024 # 80009018 <ticks>
    80001c20:	411c                	lw	a5,0(a0)
    80001c22:	2785                	addiw	a5,a5,1
    80001c24:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c26:	00000097          	auipc	ra,0x0
    80001c2a:	ae0080e7          	jalr	-1312(ra) # 80001706 <wakeup>
  release(&tickslock);
    80001c2e:	8526                	mv	a0,s1
    80001c30:	00005097          	auipc	ra,0x5
    80001c34:	90c080e7          	jalr	-1780(ra) # 8000653c <release>
}
    80001c38:	60e2                	ld	ra,24(sp)
    80001c3a:	6442                	ld	s0,16(sp)
    80001c3c:	64a2                	ld	s1,8(sp)
    80001c3e:	6105                	addi	sp,sp,32
    80001c40:	8082                	ret

0000000080001c42 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c42:	1101                	addi	sp,sp,-32
    80001c44:	ec06                	sd	ra,24(sp)
    80001c46:	e822                	sd	s0,16(sp)
    80001c48:	e426                	sd	s1,8(sp)
    80001c4a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c4c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c50:	00074d63          	bltz	a4,80001c6a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c54:	57fd                	li	a5,-1
    80001c56:	17fe                	slli	a5,a5,0x3f
    80001c58:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c5a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c5c:	06f70363          	beq	a4,a5,80001cc2 <devintr+0x80>
  }
}
    80001c60:	60e2                	ld	ra,24(sp)
    80001c62:	6442                	ld	s0,16(sp)
    80001c64:	64a2                	ld	s1,8(sp)
    80001c66:	6105                	addi	sp,sp,32
    80001c68:	8082                	ret
     (scause & 0xff) == 9){
    80001c6a:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c6e:	46a5                	li	a3,9
    80001c70:	fed792e3          	bne	a5,a3,80001c54 <devintr+0x12>
    int irq = plic_claim();
    80001c74:	00004097          	auipc	ra,0x4
    80001c78:	844080e7          	jalr	-1980(ra) # 800054b8 <plic_claim>
    80001c7c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7e:	47a9                	li	a5,10
    80001c80:	02f50763          	beq	a0,a5,80001cae <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c84:	4785                	li	a5,1
    80001c86:	02f50963          	beq	a0,a5,80001cb8 <devintr+0x76>
    return 1;
    80001c8a:	4505                	li	a0,1
    } else if(irq){
    80001c8c:	d8f1                	beqz	s1,80001c60 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8e:	85a6                	mv	a1,s1
    80001c90:	00006517          	auipc	a0,0x6
    80001c94:	5d050513          	addi	a0,a0,1488 # 80008260 <states.0+0x38>
    80001c98:	00004097          	auipc	ra,0x4
    80001c9c:	302080e7          	jalr	770(ra) # 80005f9a <printf>
      plic_complete(irq);
    80001ca0:	8526                	mv	a0,s1
    80001ca2:	00004097          	auipc	ra,0x4
    80001ca6:	83a080e7          	jalr	-1990(ra) # 800054dc <plic_complete>
    return 1;
    80001caa:	4505                	li	a0,1
    80001cac:	bf55                	j	80001c60 <devintr+0x1e>
      uartintr();
    80001cae:	00004097          	auipc	ra,0x4
    80001cb2:	6fa080e7          	jalr	1786(ra) # 800063a8 <uartintr>
    80001cb6:	b7ed                	j	80001ca0 <devintr+0x5e>
      virtio_disk_intr();
    80001cb8:	00004097          	auipc	ra,0x4
    80001cbc:	cb0080e7          	jalr	-848(ra) # 80005968 <virtio_disk_intr>
    80001cc0:	b7c5                	j	80001ca0 <devintr+0x5e>
    if(cpuid() == 0){
    80001cc2:	fffff097          	auipc	ra,0xfffff
    80001cc6:	17e080e7          	jalr	382(ra) # 80000e40 <cpuid>
    80001cca:	c901                	beqz	a0,80001cda <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ccc:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cd0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cd2:	14479073          	csrw	sip,a5
    return 2;
    80001cd6:	4509                	li	a0,2
    80001cd8:	b761                	j	80001c60 <devintr+0x1e>
      clockintr();
    80001cda:	00000097          	auipc	ra,0x0
    80001cde:	f22080e7          	jalr	-222(ra) # 80001bfc <clockintr>
    80001ce2:	b7ed                	j	80001ccc <devintr+0x8a>

0000000080001ce4 <usertrap>:
{
    80001ce4:	7179                	addi	sp,sp,-48
    80001ce6:	f406                	sd	ra,40(sp)
    80001ce8:	f022                	sd	s0,32(sp)
    80001cea:	ec26                	sd	s1,24(sp)
    80001cec:	e84a                	sd	s2,16(sp)
    80001cee:	e44e                	sd	s3,8(sp)
    80001cf0:	e052                	sd	s4,0(sp)
    80001cf2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf8:	1007f793          	andi	a5,a5,256
    80001cfc:	e7b5                	bnez	a5,80001d68 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cfe:	00003797          	auipc	a5,0x3
    80001d02:	6b278793          	addi	a5,a5,1714 # 800053b0 <kernelvec>
    80001d06:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d0a:	fffff097          	auipc	ra,0xfffff
    80001d0e:	162080e7          	jalr	354(ra) # 80000e6c <myproc>
    80001d12:	892a                	mv	s2,a0
  p->trapframe->epc = r_sepc();
    80001d14:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d16:	14102773          	csrr	a4,sepc
    80001d1a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d1c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d20:	47a1                	li	a5,8
    80001d22:	06f71163          	bne	a4,a5,80001d84 <usertrap+0xa0>
    if(p->killed)
    80001d26:	551c                	lw	a5,40(a0)
    80001d28:	eba1                	bnez	a5,80001d78 <usertrap+0x94>
    p->trapframe->epc += 4;
    80001d2a:	05893703          	ld	a4,88(s2)
    80001d2e:	6f1c                	ld	a5,24(a4)
    80001d30:	0791                	addi	a5,a5,4
    80001d32:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d34:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d38:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d3c:	10079073          	csrw	sstatus,a5
    syscall();
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	41a080e7          	jalr	1050(ra) # 8000215a <syscall>
  if(p->killed)
    80001d48:	02892783          	lw	a5,40(s2)
    80001d4c:	1a079863          	bnez	a5,80001efc <usertrap+0x218>
  usertrapret();
    80001d50:	00000097          	auipc	ra,0x0
    80001d54:	e0e080e7          	jalr	-498(ra) # 80001b5e <usertrapret>
}
    80001d58:	70a2                	ld	ra,40(sp)
    80001d5a:	7402                	ld	s0,32(sp)
    80001d5c:	64e2                	ld	s1,24(sp)
    80001d5e:	6942                	ld	s2,16(sp)
    80001d60:	69a2                	ld	s3,8(sp)
    80001d62:	6a02                	ld	s4,0(sp)
    80001d64:	6145                	addi	sp,sp,48
    80001d66:	8082                	ret
    panic("usertrap: not from user mode");
    80001d68:	00006517          	auipc	a0,0x6
    80001d6c:	51850513          	addi	a0,a0,1304 # 80008280 <states.0+0x58>
    80001d70:	00004097          	auipc	ra,0x4
    80001d74:	1e0080e7          	jalr	480(ra) # 80005f50 <panic>
      exit(-1);
    80001d78:	557d                	li	a0,-1
    80001d7a:	00000097          	auipc	ra,0x0
    80001d7e:	a5c080e7          	jalr	-1444(ra) # 800017d6 <exit>
    80001d82:	b765                	j	80001d2a <usertrap+0x46>
  } else if((which_dev = devintr()) != 0){
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	ebe080e7          	jalr	-322(ra) # 80001c42 <devintr>
    80001d8c:	84aa                	mv	s1,a0
    80001d8e:	16051363          	bnez	a0,80001ef4 <usertrap+0x210>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d92:	14202773          	csrr	a4,scause
  } else if (r_scause() == 12 || r_scause() == 13 || r_scause() == 15) {
    80001d96:	47b1                	li	a5,12
    80001d98:	00f70c63          	beq	a4,a5,80001db0 <usertrap+0xcc>
    80001d9c:	14202773          	csrr	a4,scause
    80001da0:	47b5                	li	a5,13
    80001da2:	00f70763          	beq	a4,a5,80001db0 <usertrap+0xcc>
    80001da6:	14202773          	csrr	a4,scause
    80001daa:	47bd                	li	a5,15
    80001dac:	10f71863          	bne	a4,a5,80001ebc <usertrap+0x1d8>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001db0:	143029f3          	csrr	s3,stval
    if (fault_va >= MAXVA)
    80001db4:	57fd                	li	a5,-1
    80001db6:	83e9                	srli	a5,a5,0x1a
    80001db8:	0137eb63          	bltu	a5,s3,80001dce <usertrap+0xea>
    if (fault_va < p->trapframe->sp)
    80001dbc:	05893783          	ld	a5,88(s2)
    80001dc0:	7b9c                	ld	a5,48(a5)
    80001dc2:	00f9ec63          	bltu	s3,a5,80001dda <usertrap+0xf6>
    for (int i = 0; i < VMA_SIZE; i++) {
    80001dc6:	17090793          	addi	a5,s2,368
    80001dca:	4641                	li	a2,16
    80001dcc:	a015                	j	80001df0 <usertrap+0x10c>
      exit(-1);
    80001dce:	557d                	li	a0,-1
    80001dd0:	00000097          	auipc	ra,0x0
    80001dd4:	a06080e7          	jalr	-1530(ra) # 800017d6 <exit>
    80001dd8:	b7d5                	j	80001dbc <usertrap+0xd8>
      exit(-1);
    80001dda:	557d                	li	a0,-1
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	9fa080e7          	jalr	-1542(ra) # 800017d6 <exit>
    80001de4:	b7cd                	j	80001dc6 <usertrap+0xe2>
    for (int i = 0; i < VMA_SIZE; i++) {
    80001de6:	2485                	addiw	s1,s1,1
    80001de8:	02878793          	addi	a5,a5,40
    80001dec:	02c48363          	beq	s1,a2,80001e12 <usertrap+0x12e>
      if (p->VMAs[i].valid && fault_va >= p->VMAs[i].addr && fault_va <= p->VMAs[i].addr + p->VMAs[i].size) {
    80001df0:	4398                	lw	a4,0(a5)
    80001df2:	db75                	beqz	a4,80001de6 <usertrap+0x102>
    80001df4:	6798                	ld	a4,8(a5)
    80001df6:	fee9e8e3          	bltu	s3,a4,80001de6 <usertrap+0x102>
    80001dfa:	6b94                	ld	a3,16(a5)
    80001dfc:	9736                	add	a4,a4,a3
    80001dfe:	ff3764e3          	bltu	a4,s3,80001de6 <usertrap+0x102>
        vma = &p->VMAs[i];
    80001e02:	00249793          	slli	a5,s1,0x2
    80001e06:	94be                	add	s1,s1,a5
    80001e08:	048e                	slli	s1,s1,0x3
    80001e0a:	17048493          	addi	s1,s1,368
    80001e0e:	94ca                	add	s1,s1,s2
    if (!found) {
    80001e10:	a039                	j	80001e1e <usertrap+0x13a>
      exit(-1);
    80001e12:	557d                	li	a0,-1
    80001e14:	00000097          	auipc	ra,0x0
    80001e18:	9c2080e7          	jalr	-1598(ra) # 800017d6 <exit>
    struct VMA *vma = 0;
    80001e1c:	4481                	li	s1,0
    char *new_pa = kalloc();
    80001e1e:	ffffe097          	auipc	ra,0xffffe
    80001e22:	2fc080e7          	jalr	764(ra) # 8000011a <kalloc>
    80001e26:	8a2a                	mv	s4,a0
    if (new_pa == 0) {
    80001e28:	c92d                	beqz	a0,80001e9a <usertrap+0x1b6>
    memset(new_pa, 0, PGSIZE);
    80001e2a:	6605                	lui	a2,0x1
    80001e2c:	4581                	li	a1,0
    80001e2e:	8552                	mv	a0,s4
    80001e30:	ffffe097          	auipc	ra,0xffffe
    80001e34:	34a080e7          	jalr	842(ra) # 8000017a <memset>
    if (vma->permissions & PROT_READ) {
    80001e38:	4c9c                	lw	a5,24(s1)
    80001e3a:	0017f693          	andi	a3,a5,1
    uint perm = PTE_U;
    80001e3e:	4741                	li	a4,16
    if (vma->permissions & PROT_READ) {
    80001e40:	c291                	beqz	a3,80001e44 <usertrap+0x160>
      perm |= PTE_R;
    80001e42:	4749                	li	a4,18
    if (vma->permissions & PROT_WRITE) {
    80001e44:	8b89                	andi	a5,a5,2
    80001e46:	c399                	beqz	a5,80001e4c <usertrap+0x168>
      perm |= PTE_W;
    80001e48:	00476713          	ori	a4,a4,4
    if (mappages(p->pagetable, fault_va, PGSIZE, (uint64)new_pa, perm) < 0) {
    80001e4c:	86d2                	mv	a3,s4
    80001e4e:	6605                	lui	a2,0x1
    80001e50:	85ce                	mv	a1,s3
    80001e52:	05093503          	ld	a0,80(s2)
    80001e56:	ffffe097          	auipc	ra,0xffffe
    80001e5a:	6ec080e7          	jalr	1772(ra) # 80000542 <mappages>
    80001e5e:	04054463          	bltz	a0,80001ea6 <usertrap+0x1c2>
    ilock(vma->file->ip);
    80001e62:	709c                	ld	a5,32(s1)
    80001e64:	6f88                	ld	a0,24(a5)
    80001e66:	00001097          	auipc	ra,0x1
    80001e6a:	076080e7          	jalr	118(ra) # 80002edc <ilock>
    readi(vma->file->ip, 1, fault_va, PGROUNDDOWN(fault_va - vma->addr), PGSIZE);
    80001e6e:	6494                	ld	a3,8(s1)
    80001e70:	40d986bb          	subw	a3,s3,a3
    80001e74:	77fd                	lui	a5,0xfffff
    80001e76:	8efd                	and	a3,a3,a5
    80001e78:	709c                	ld	a5,32(s1)
    80001e7a:	6705                	lui	a4,0x1
    80001e7c:	2681                	sext.w	a3,a3
    80001e7e:	864e                	mv	a2,s3
    80001e80:	4585                	li	a1,1
    80001e82:	6f88                	ld	a0,24(a5)
    80001e84:	00001097          	auipc	ra,0x1
    80001e88:	30c080e7          	jalr	780(ra) # 80003190 <readi>
    iunlock(vma->file->ip);
    80001e8c:	709c                	ld	a5,32(s1)
    80001e8e:	6f88                	ld	a0,24(a5)
    80001e90:	00001097          	auipc	ra,0x1
    80001e94:	10e080e7          	jalr	270(ra) # 80002f9e <iunlock>
  } else if (r_scause() == 12 || r_scause() == 13 || r_scause() == 15) {
    80001e98:	bd45                	j	80001d48 <usertrap+0x64>
      exit(-1);
    80001e9a:	557d                	li	a0,-1
    80001e9c:	00000097          	auipc	ra,0x0
    80001ea0:	93a080e7          	jalr	-1734(ra) # 800017d6 <exit>
    80001ea4:	b759                	j	80001e2a <usertrap+0x146>
      kfree(new_pa);
    80001ea6:	8552                	mv	a0,s4
    80001ea8:	ffffe097          	auipc	ra,0xffffe
    80001eac:	174080e7          	jalr	372(ra) # 8000001c <kfree>
      exit(-1);
    80001eb0:	557d                	li	a0,-1
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	924080e7          	jalr	-1756(ra) # 800017d6 <exit>
    80001eba:	b765                	j	80001e62 <usertrap+0x17e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ebc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ec0:	03092603          	lw	a2,48(s2)
    80001ec4:	00006517          	auipc	a0,0x6
    80001ec8:	3dc50513          	addi	a0,a0,988 # 800082a0 <states.0+0x78>
    80001ecc:	00004097          	auipc	ra,0x4
    80001ed0:	0ce080e7          	jalr	206(ra) # 80005f9a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001edc:	00006517          	auipc	a0,0x6
    80001ee0:	3f450513          	addi	a0,a0,1012 # 800082d0 <states.0+0xa8>
    80001ee4:	00004097          	auipc	ra,0x4
    80001ee8:	0b6080e7          	jalr	182(ra) # 80005f9a <printf>
    p->killed = 1;
    80001eec:	4785                	li	a5,1
    80001eee:	02f92423          	sw	a5,40(s2)
  if(p->killed)
    80001ef2:	a031                	j	80001efe <usertrap+0x21a>
    80001ef4:	02892783          	lw	a5,40(s2)
    80001ef8:	cb81                	beqz	a5,80001f08 <usertrap+0x224>
    80001efa:	a011                	j	80001efe <usertrap+0x21a>
    80001efc:	4481                	li	s1,0
    exit(-1);
    80001efe:	557d                	li	a0,-1
    80001f00:	00000097          	auipc	ra,0x0
    80001f04:	8d6080e7          	jalr	-1834(ra) # 800017d6 <exit>
  if(which_dev == 2)
    80001f08:	4789                	li	a5,2
    80001f0a:	e4f493e3          	bne	s1,a5,80001d50 <usertrap+0x6c>
    yield();
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	630080e7          	jalr	1584(ra) # 8000153e <yield>
    80001f16:	bd2d                	j	80001d50 <usertrap+0x6c>

0000000080001f18 <kerneltrap>:
{
    80001f18:	7179                	addi	sp,sp,-48
    80001f1a:	f406                	sd	ra,40(sp)
    80001f1c:	f022                	sd	s0,32(sp)
    80001f1e:	ec26                	sd	s1,24(sp)
    80001f20:	e84a                	sd	s2,16(sp)
    80001f22:	e44e                	sd	s3,8(sp)
    80001f24:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f26:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f2a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f2e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f32:	1004f793          	andi	a5,s1,256
    80001f36:	cb85                	beqz	a5,80001f66 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f38:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f3c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f3e:	ef85                	bnez	a5,80001f76 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f40:	00000097          	auipc	ra,0x0
    80001f44:	d02080e7          	jalr	-766(ra) # 80001c42 <devintr>
    80001f48:	cd1d                	beqz	a0,80001f86 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f4a:	4789                	li	a5,2
    80001f4c:	06f50a63          	beq	a0,a5,80001fc0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f50:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f54:	10049073          	csrw	sstatus,s1
}
    80001f58:	70a2                	ld	ra,40(sp)
    80001f5a:	7402                	ld	s0,32(sp)
    80001f5c:	64e2                	ld	s1,24(sp)
    80001f5e:	6942                	ld	s2,16(sp)
    80001f60:	69a2                	ld	s3,8(sp)
    80001f62:	6145                	addi	sp,sp,48
    80001f64:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f66:	00006517          	auipc	a0,0x6
    80001f6a:	38a50513          	addi	a0,a0,906 # 800082f0 <states.0+0xc8>
    80001f6e:	00004097          	auipc	ra,0x4
    80001f72:	fe2080e7          	jalr	-30(ra) # 80005f50 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f76:	00006517          	auipc	a0,0x6
    80001f7a:	3a250513          	addi	a0,a0,930 # 80008318 <states.0+0xf0>
    80001f7e:	00004097          	auipc	ra,0x4
    80001f82:	fd2080e7          	jalr	-46(ra) # 80005f50 <panic>
    printf("scause %p\n", scause);
    80001f86:	85ce                	mv	a1,s3
    80001f88:	00006517          	auipc	a0,0x6
    80001f8c:	3b050513          	addi	a0,a0,944 # 80008338 <states.0+0x110>
    80001f90:	00004097          	auipc	ra,0x4
    80001f94:	00a080e7          	jalr	10(ra) # 80005f9a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f98:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f9c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fa0:	00006517          	auipc	a0,0x6
    80001fa4:	3a850513          	addi	a0,a0,936 # 80008348 <states.0+0x120>
    80001fa8:	00004097          	auipc	ra,0x4
    80001fac:	ff2080e7          	jalr	-14(ra) # 80005f9a <printf>
    panic("kerneltrap");
    80001fb0:	00006517          	auipc	a0,0x6
    80001fb4:	3b050513          	addi	a0,a0,944 # 80008360 <states.0+0x138>
    80001fb8:	00004097          	auipc	ra,0x4
    80001fbc:	f98080e7          	jalr	-104(ra) # 80005f50 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fc0:	fffff097          	auipc	ra,0xfffff
    80001fc4:	eac080e7          	jalr	-340(ra) # 80000e6c <myproc>
    80001fc8:	d541                	beqz	a0,80001f50 <kerneltrap+0x38>
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	ea2080e7          	jalr	-350(ra) # 80000e6c <myproc>
    80001fd2:	4d18                	lw	a4,24(a0)
    80001fd4:	4791                	li	a5,4
    80001fd6:	f6f71de3          	bne	a4,a5,80001f50 <kerneltrap+0x38>
    yield();
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	564080e7          	jalr	1380(ra) # 8000153e <yield>
    80001fe2:	b7bd                	j	80001f50 <kerneltrap+0x38>

0000000080001fe4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fe4:	1101                	addi	sp,sp,-32
    80001fe6:	ec06                	sd	ra,24(sp)
    80001fe8:	e822                	sd	s0,16(sp)
    80001fea:	e426                	sd	s1,8(sp)
    80001fec:	1000                	addi	s0,sp,32
    80001fee:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	e7c080e7          	jalr	-388(ra) # 80000e6c <myproc>
  switch (n) {
    80001ff8:	4795                	li	a5,5
    80001ffa:	0497e163          	bltu	a5,s1,8000203c <argraw+0x58>
    80001ffe:	048a                	slli	s1,s1,0x2
    80002000:	00006717          	auipc	a4,0x6
    80002004:	39870713          	addi	a4,a4,920 # 80008398 <states.0+0x170>
    80002008:	94ba                	add	s1,s1,a4
    8000200a:	409c                	lw	a5,0(s1)
    8000200c:	97ba                	add	a5,a5,a4
    8000200e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002010:	6d3c                	ld	a5,88(a0)
    80002012:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002014:	60e2                	ld	ra,24(sp)
    80002016:	6442                	ld	s0,16(sp)
    80002018:	64a2                	ld	s1,8(sp)
    8000201a:	6105                	addi	sp,sp,32
    8000201c:	8082                	ret
    return p->trapframe->a1;
    8000201e:	6d3c                	ld	a5,88(a0)
    80002020:	7fa8                	ld	a0,120(a5)
    80002022:	bfcd                	j	80002014 <argraw+0x30>
    return p->trapframe->a2;
    80002024:	6d3c                	ld	a5,88(a0)
    80002026:	63c8                	ld	a0,128(a5)
    80002028:	b7f5                	j	80002014 <argraw+0x30>
    return p->trapframe->a3;
    8000202a:	6d3c                	ld	a5,88(a0)
    8000202c:	67c8                	ld	a0,136(a5)
    8000202e:	b7dd                	j	80002014 <argraw+0x30>
    return p->trapframe->a4;
    80002030:	6d3c                	ld	a5,88(a0)
    80002032:	6bc8                	ld	a0,144(a5)
    80002034:	b7c5                	j	80002014 <argraw+0x30>
    return p->trapframe->a5;
    80002036:	6d3c                	ld	a5,88(a0)
    80002038:	6fc8                	ld	a0,152(a5)
    8000203a:	bfe9                	j	80002014 <argraw+0x30>
  panic("argraw");
    8000203c:	00006517          	auipc	a0,0x6
    80002040:	33450513          	addi	a0,a0,820 # 80008370 <states.0+0x148>
    80002044:	00004097          	auipc	ra,0x4
    80002048:	f0c080e7          	jalr	-244(ra) # 80005f50 <panic>

000000008000204c <fetchaddr>:
{
    8000204c:	1101                	addi	sp,sp,-32
    8000204e:	ec06                	sd	ra,24(sp)
    80002050:	e822                	sd	s0,16(sp)
    80002052:	e426                	sd	s1,8(sp)
    80002054:	e04a                	sd	s2,0(sp)
    80002056:	1000                	addi	s0,sp,32
    80002058:	84aa                	mv	s1,a0
    8000205a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	e10080e7          	jalr	-496(ra) # 80000e6c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002064:	653c                	ld	a5,72(a0)
    80002066:	02f4f863          	bgeu	s1,a5,80002096 <fetchaddr+0x4a>
    8000206a:	00848713          	addi	a4,s1,8
    8000206e:	02e7e663          	bltu	a5,a4,8000209a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002072:	46a1                	li	a3,8
    80002074:	8626                	mv	a2,s1
    80002076:	85ca                	mv	a1,s2
    80002078:	6928                	ld	a0,80(a0)
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	b0c080e7          	jalr	-1268(ra) # 80000b86 <copyin>
    80002082:	00a03533          	snez	a0,a0
    80002086:	40a00533          	neg	a0,a0
}
    8000208a:	60e2                	ld	ra,24(sp)
    8000208c:	6442                	ld	s0,16(sp)
    8000208e:	64a2                	ld	s1,8(sp)
    80002090:	6902                	ld	s2,0(sp)
    80002092:	6105                	addi	sp,sp,32
    80002094:	8082                	ret
    return -1;
    80002096:	557d                	li	a0,-1
    80002098:	bfcd                	j	8000208a <fetchaddr+0x3e>
    8000209a:	557d                	li	a0,-1
    8000209c:	b7fd                	j	8000208a <fetchaddr+0x3e>

000000008000209e <fetchstr>:
{
    8000209e:	7179                	addi	sp,sp,-48
    800020a0:	f406                	sd	ra,40(sp)
    800020a2:	f022                	sd	s0,32(sp)
    800020a4:	ec26                	sd	s1,24(sp)
    800020a6:	e84a                	sd	s2,16(sp)
    800020a8:	e44e                	sd	s3,8(sp)
    800020aa:	1800                	addi	s0,sp,48
    800020ac:	892a                	mv	s2,a0
    800020ae:	84ae                	mv	s1,a1
    800020b0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	dba080e7          	jalr	-582(ra) # 80000e6c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020ba:	86ce                	mv	a3,s3
    800020bc:	864a                	mv	a2,s2
    800020be:	85a6                	mv	a1,s1
    800020c0:	6928                	ld	a0,80(a0)
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	b52080e7          	jalr	-1198(ra) # 80000c14 <copyinstr>
  if(err < 0)
    800020ca:	00054763          	bltz	a0,800020d8 <fetchstr+0x3a>
  return strlen(buf);
    800020ce:	8526                	mv	a0,s1
    800020d0:	ffffe097          	auipc	ra,0xffffe
    800020d4:	226080e7          	jalr	550(ra) # 800002f6 <strlen>
}
    800020d8:	70a2                	ld	ra,40(sp)
    800020da:	7402                	ld	s0,32(sp)
    800020dc:	64e2                	ld	s1,24(sp)
    800020de:	6942                	ld	s2,16(sp)
    800020e0:	69a2                	ld	s3,8(sp)
    800020e2:	6145                	addi	sp,sp,48
    800020e4:	8082                	ret

00000000800020e6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020e6:	1101                	addi	sp,sp,-32
    800020e8:	ec06                	sd	ra,24(sp)
    800020ea:	e822                	sd	s0,16(sp)
    800020ec:	e426                	sd	s1,8(sp)
    800020ee:	1000                	addi	s0,sp,32
    800020f0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020f2:	00000097          	auipc	ra,0x0
    800020f6:	ef2080e7          	jalr	-270(ra) # 80001fe4 <argraw>
    800020fa:	c088                	sw	a0,0(s1)
  return 0;
}
    800020fc:	4501                	li	a0,0
    800020fe:	60e2                	ld	ra,24(sp)
    80002100:	6442                	ld	s0,16(sp)
    80002102:	64a2                	ld	s1,8(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret

0000000080002108 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002108:	1101                	addi	sp,sp,-32
    8000210a:	ec06                	sd	ra,24(sp)
    8000210c:	e822                	sd	s0,16(sp)
    8000210e:	e426                	sd	s1,8(sp)
    80002110:	1000                	addi	s0,sp,32
    80002112:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002114:	00000097          	auipc	ra,0x0
    80002118:	ed0080e7          	jalr	-304(ra) # 80001fe4 <argraw>
    8000211c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000211e:	4501                	li	a0,0
    80002120:	60e2                	ld	ra,24(sp)
    80002122:	6442                	ld	s0,16(sp)
    80002124:	64a2                	ld	s1,8(sp)
    80002126:	6105                	addi	sp,sp,32
    80002128:	8082                	ret

000000008000212a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000212a:	1101                	addi	sp,sp,-32
    8000212c:	ec06                	sd	ra,24(sp)
    8000212e:	e822                	sd	s0,16(sp)
    80002130:	e426                	sd	s1,8(sp)
    80002132:	e04a                	sd	s2,0(sp)
    80002134:	1000                	addi	s0,sp,32
    80002136:	84ae                	mv	s1,a1
    80002138:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	eaa080e7          	jalr	-342(ra) # 80001fe4 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002142:	864a                	mv	a2,s2
    80002144:	85a6                	mv	a1,s1
    80002146:	00000097          	auipc	ra,0x0
    8000214a:	f58080e7          	jalr	-168(ra) # 8000209e <fetchstr>
}
    8000214e:	60e2                	ld	ra,24(sp)
    80002150:	6442                	ld	s0,16(sp)
    80002152:	64a2                	ld	s1,8(sp)
    80002154:	6902                	ld	s2,0(sp)
    80002156:	6105                	addi	sp,sp,32
    80002158:	8082                	ret

000000008000215a <syscall>:

};

void
syscall(void)
{
    8000215a:	1101                	addi	sp,sp,-32
    8000215c:	ec06                	sd	ra,24(sp)
    8000215e:	e822                	sd	s0,16(sp)
    80002160:	e426                	sd	s1,8(sp)
    80002162:	e04a                	sd	s2,0(sp)
    80002164:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	d06080e7          	jalr	-762(ra) # 80000e6c <myproc>
    8000216e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002170:	05853903          	ld	s2,88(a0)
    80002174:	0a893783          	ld	a5,168(s2)
    80002178:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000217c:	37fd                	addiw	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffcedbf>
    8000217e:	4759                	li	a4,22
    80002180:	00f76f63          	bltu	a4,a5,8000219e <syscall+0x44>
    80002184:	00369713          	slli	a4,a3,0x3
    80002188:	00006797          	auipc	a5,0x6
    8000218c:	22878793          	addi	a5,a5,552 # 800083b0 <syscalls>
    80002190:	97ba                	add	a5,a5,a4
    80002192:	639c                	ld	a5,0(a5)
    80002194:	c789                	beqz	a5,8000219e <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002196:	9782                	jalr	a5
    80002198:	06a93823          	sd	a0,112(s2)
    8000219c:	a839                	j	800021ba <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000219e:	15848613          	addi	a2,s1,344
    800021a2:	588c                	lw	a1,48(s1)
    800021a4:	00006517          	auipc	a0,0x6
    800021a8:	1d450513          	addi	a0,a0,468 # 80008378 <states.0+0x150>
    800021ac:	00004097          	auipc	ra,0x4
    800021b0:	dee080e7          	jalr	-530(ra) # 80005f9a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021b4:	6cbc                	ld	a5,88(s1)
    800021b6:	577d                	li	a4,-1
    800021b8:	fbb8                	sd	a4,112(a5)
  }
}
    800021ba:	60e2                	ld	ra,24(sp)
    800021bc:	6442                	ld	s0,16(sp)
    800021be:	64a2                	ld	s1,8(sp)
    800021c0:	6902                	ld	s2,0(sp)
    800021c2:	6105                	addi	sp,sp,32
    800021c4:	8082                	ret

00000000800021c6 <sys_exit>:



uint64
sys_exit(void)
{
    800021c6:	1101                	addi	sp,sp,-32
    800021c8:	ec06                	sd	ra,24(sp)
    800021ca:	e822                	sd	s0,16(sp)
    800021cc:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021ce:	fec40593          	addi	a1,s0,-20
    800021d2:	4501                	li	a0,0
    800021d4:	00000097          	auipc	ra,0x0
    800021d8:	f12080e7          	jalr	-238(ra) # 800020e6 <argint>
    return -1;
    800021dc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021de:	00054963          	bltz	a0,800021f0 <sys_exit+0x2a>
  exit(n);
    800021e2:	fec42503          	lw	a0,-20(s0)
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	5f0080e7          	jalr	1520(ra) # 800017d6 <exit>
  return 0;  // not reached
    800021ee:	4781                	li	a5,0
}
    800021f0:	853e                	mv	a0,a5
    800021f2:	60e2                	ld	ra,24(sp)
    800021f4:	6442                	ld	s0,16(sp)
    800021f6:	6105                	addi	sp,sp,32
    800021f8:	8082                	ret

00000000800021fa <sys_getpid>:

uint64
sys_getpid(void)
{
    800021fa:	1141                	addi	sp,sp,-16
    800021fc:	e406                	sd	ra,8(sp)
    800021fe:	e022                	sd	s0,0(sp)
    80002200:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	c6a080e7          	jalr	-918(ra) # 80000e6c <myproc>
}
    8000220a:	5908                	lw	a0,48(a0)
    8000220c:	60a2                	ld	ra,8(sp)
    8000220e:	6402                	ld	s0,0(sp)
    80002210:	0141                	addi	sp,sp,16
    80002212:	8082                	ret

0000000080002214 <sys_fork>:

uint64
sys_fork(void)
{
    80002214:	1141                	addi	sp,sp,-16
    80002216:	e406                	sd	ra,8(sp)
    80002218:	e022                	sd	s0,0(sp)
    8000221a:	0800                	addi	s0,sp,16
  return fork();
    8000221c:	fffff097          	auipc	ra,0xfffff
    80002220:	022080e7          	jalr	34(ra) # 8000123e <fork>
}
    80002224:	60a2                	ld	ra,8(sp)
    80002226:	6402                	ld	s0,0(sp)
    80002228:	0141                	addi	sp,sp,16
    8000222a:	8082                	ret

000000008000222c <sys_wait>:

uint64
sys_wait(void)
{
    8000222c:	1101                	addi	sp,sp,-32
    8000222e:	ec06                	sd	ra,24(sp)
    80002230:	e822                	sd	s0,16(sp)
    80002232:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002234:	fe840593          	addi	a1,s0,-24
    80002238:	4501                	li	a0,0
    8000223a:	00000097          	auipc	ra,0x0
    8000223e:	ece080e7          	jalr	-306(ra) # 80002108 <argaddr>
    80002242:	87aa                	mv	a5,a0
    return -1;
    80002244:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002246:	0007c863          	bltz	a5,80002256 <sys_wait+0x2a>
  return wait(p);
    8000224a:	fe843503          	ld	a0,-24(s0)
    8000224e:	fffff097          	auipc	ra,0xfffff
    80002252:	390080e7          	jalr	912(ra) # 800015de <wait>
}
    80002256:	60e2                	ld	ra,24(sp)
    80002258:	6442                	ld	s0,16(sp)
    8000225a:	6105                	addi	sp,sp,32
    8000225c:	8082                	ret

000000008000225e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000225e:	7179                	addi	sp,sp,-48
    80002260:	f406                	sd	ra,40(sp)
    80002262:	f022                	sd	s0,32(sp)
    80002264:	ec26                	sd	s1,24(sp)
    80002266:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002268:	fdc40593          	addi	a1,s0,-36
    8000226c:	4501                	li	a0,0
    8000226e:	00000097          	auipc	ra,0x0
    80002272:	e78080e7          	jalr	-392(ra) # 800020e6 <argint>
    80002276:	87aa                	mv	a5,a0
    return -1;
    80002278:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000227a:	0207c063          	bltz	a5,8000229a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	bee080e7          	jalr	-1042(ra) # 80000e6c <myproc>
    80002286:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002288:	fdc42503          	lw	a0,-36(s0)
    8000228c:	fffff097          	auipc	ra,0xfffff
    80002290:	f3a080e7          	jalr	-198(ra) # 800011c6 <growproc>
    80002294:	00054863          	bltz	a0,800022a4 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002298:	8526                	mv	a0,s1
}
    8000229a:	70a2                	ld	ra,40(sp)
    8000229c:	7402                	ld	s0,32(sp)
    8000229e:	64e2                	ld	s1,24(sp)
    800022a0:	6145                	addi	sp,sp,48
    800022a2:	8082                	ret
    return -1;
    800022a4:	557d                	li	a0,-1
    800022a6:	bfd5                	j	8000229a <sys_sbrk+0x3c>

00000000800022a8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022a8:	7139                	addi	sp,sp,-64
    800022aa:	fc06                	sd	ra,56(sp)
    800022ac:	f822                	sd	s0,48(sp)
    800022ae:	f426                	sd	s1,40(sp)
    800022b0:	f04a                	sd	s2,32(sp)
    800022b2:	ec4e                	sd	s3,24(sp)
    800022b4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800022b6:	fcc40593          	addi	a1,s0,-52
    800022ba:	4501                	li	a0,0
    800022bc:	00000097          	auipc	ra,0x0
    800022c0:	e2a080e7          	jalr	-470(ra) # 800020e6 <argint>
    return -1;
    800022c4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022c6:	06054563          	bltz	a0,80002330 <sys_sleep+0x88>
  acquire(&tickslock);
    800022ca:	00017517          	auipc	a0,0x17
    800022ce:	db650513          	addi	a0,a0,-586 # 80019080 <tickslock>
    800022d2:	00004097          	auipc	ra,0x4
    800022d6:	1b6080e7          	jalr	438(ra) # 80006488 <acquire>
  ticks0 = ticks;
    800022da:	00007917          	auipc	s2,0x7
    800022de:	d3e92903          	lw	s2,-706(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022e2:	fcc42783          	lw	a5,-52(s0)
    800022e6:	cf85                	beqz	a5,8000231e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022e8:	00017997          	auipc	s3,0x17
    800022ec:	d9898993          	addi	s3,s3,-616 # 80019080 <tickslock>
    800022f0:	00007497          	auipc	s1,0x7
    800022f4:	d2848493          	addi	s1,s1,-728 # 80009018 <ticks>
    if(myproc()->killed){
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	b74080e7          	jalr	-1164(ra) # 80000e6c <myproc>
    80002300:	551c                	lw	a5,40(a0)
    80002302:	ef9d                	bnez	a5,80002340 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002304:	85ce                	mv	a1,s3
    80002306:	8526                	mv	a0,s1
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	272080e7          	jalr	626(ra) # 8000157a <sleep>
  while(ticks - ticks0 < n){
    80002310:	409c                	lw	a5,0(s1)
    80002312:	412787bb          	subw	a5,a5,s2
    80002316:	fcc42703          	lw	a4,-52(s0)
    8000231a:	fce7efe3          	bltu	a5,a4,800022f8 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000231e:	00017517          	auipc	a0,0x17
    80002322:	d6250513          	addi	a0,a0,-670 # 80019080 <tickslock>
    80002326:	00004097          	auipc	ra,0x4
    8000232a:	216080e7          	jalr	534(ra) # 8000653c <release>
  return 0;
    8000232e:	4781                	li	a5,0
}
    80002330:	853e                	mv	a0,a5
    80002332:	70e2                	ld	ra,56(sp)
    80002334:	7442                	ld	s0,48(sp)
    80002336:	74a2                	ld	s1,40(sp)
    80002338:	7902                	ld	s2,32(sp)
    8000233a:	69e2                	ld	s3,24(sp)
    8000233c:	6121                	addi	sp,sp,64
    8000233e:	8082                	ret
      release(&tickslock);
    80002340:	00017517          	auipc	a0,0x17
    80002344:	d4050513          	addi	a0,a0,-704 # 80019080 <tickslock>
    80002348:	00004097          	auipc	ra,0x4
    8000234c:	1f4080e7          	jalr	500(ra) # 8000653c <release>
      return -1;
    80002350:	57fd                	li	a5,-1
    80002352:	bff9                	j	80002330 <sys_sleep+0x88>

0000000080002354 <sys_kill>:

uint64
sys_kill(void)
{
    80002354:	1101                	addi	sp,sp,-32
    80002356:	ec06                	sd	ra,24(sp)
    80002358:	e822                	sd	s0,16(sp)
    8000235a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000235c:	fec40593          	addi	a1,s0,-20
    80002360:	4501                	li	a0,0
    80002362:	00000097          	auipc	ra,0x0
    80002366:	d84080e7          	jalr	-636(ra) # 800020e6 <argint>
    8000236a:	87aa                	mv	a5,a0
    return -1;
    8000236c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000236e:	0007c863          	bltz	a5,8000237e <sys_kill+0x2a>
  return kill(pid);
    80002372:	fec42503          	lw	a0,-20(s0)
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	570080e7          	jalr	1392(ra) # 800018e6 <kill>
}
    8000237e:	60e2                	ld	ra,24(sp)
    80002380:	6442                	ld	s0,16(sp)
    80002382:	6105                	addi	sp,sp,32
    80002384:	8082                	ret

0000000080002386 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002386:	1101                	addi	sp,sp,-32
    80002388:	ec06                	sd	ra,24(sp)
    8000238a:	e822                	sd	s0,16(sp)
    8000238c:	e426                	sd	s1,8(sp)
    8000238e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002390:	00017517          	auipc	a0,0x17
    80002394:	cf050513          	addi	a0,a0,-784 # 80019080 <tickslock>
    80002398:	00004097          	auipc	ra,0x4
    8000239c:	0f0080e7          	jalr	240(ra) # 80006488 <acquire>
  xticks = ticks;
    800023a0:	00007497          	auipc	s1,0x7
    800023a4:	c784a483          	lw	s1,-904(s1) # 80009018 <ticks>
  release(&tickslock);
    800023a8:	00017517          	auipc	a0,0x17
    800023ac:	cd850513          	addi	a0,a0,-808 # 80019080 <tickslock>
    800023b0:	00004097          	auipc	ra,0x4
    800023b4:	18c080e7          	jalr	396(ra) # 8000653c <release>
  return xticks;
}
    800023b8:	02049513          	slli	a0,s1,0x20
    800023bc:	9101                	srli	a0,a0,0x20
    800023be:	60e2                	ld	ra,24(sp)
    800023c0:	6442                	ld	s0,16(sp)
    800023c2:	64a2                	ld	s1,8(sp)
    800023c4:	6105                	addi	sp,sp,32
    800023c6:	8082                	ret

00000000800023c8 <sys_mmap>:

uint64
sys_mmap(void)
{
    800023c8:	7139                	addi	sp,sp,-64
    800023ca:	fc06                	sd	ra,56(sp)
    800023cc:	f822                	sd	s0,48(sp)
    800023ce:	f426                	sd	s1,40(sp)
    800023d0:	f04a                	sd	s2,32(sp)
    800023d2:	ec4e                	sd	s3,24(sp)
    800023d4:	0080                	addi	s0,sp,64
  int length;
  if(argint(1, &length) < 0)
    800023d6:	fcc40593          	addi	a1,s0,-52
    800023da:	4505                	li	a0,1
    800023dc:	00000097          	auipc	ra,0x0
    800023e0:	d0a080e7          	jalr	-758(ra) # 800020e6 <argint>
    800023e4:	0e054963          	bltz	a0,800024d6 <sys_mmap+0x10e>
    return -1;
  int prot;
  if(argint(2, &prot) < 0)
    800023e8:	fc840593          	addi	a1,s0,-56
    800023ec:	4509                	li	a0,2
    800023ee:	00000097          	auipc	ra,0x0
    800023f2:	cf8080e7          	jalr	-776(ra) # 800020e6 <argint>
    800023f6:	0e054863          	bltz	a0,800024e6 <sys_mmap+0x11e>
    return -1;
  int flags;
  if(argint(3, &flags) < 0)
    800023fa:	fc440593          	addi	a1,s0,-60
    800023fe:	450d                	li	a0,3
    80002400:	00000097          	auipc	ra,0x0
    80002404:	ce6080e7          	jalr	-794(ra) # 800020e6 <argint>
    80002408:	0e054163          	bltz	a0,800024ea <sys_mmap+0x122>
    return -1;
  int fd;
  if(argint(4, &fd) < 0)
    8000240c:	fc040593          	addi	a1,s0,-64
    80002410:	4511                	li	a0,4
    80002412:	00000097          	auipc	ra,0x0
    80002416:	cd4080e7          	jalr	-812(ra) # 800020e6 <argint>
    8000241a:	0c054a63          	bltz	a0,800024ee <sys_mmap+0x126>
    return -1;
  // offset is assumed to be 0.
  // if(argint(5, &offset) < 0)
  //   return -1;

  struct proc *p = myproc();
    8000241e:	fffff097          	auipc	ra,0xfffff
    80002422:	a4e080e7          	jalr	-1458(ra) # 80000e6c <myproc>
    80002426:	892a                	mv	s2,a0

  struct file *file = p->ofile[fd];
    80002428:	fc042783          	lw	a5,-64(s0)
    8000242c:	07e9                	addi	a5,a5,26
    8000242e:	078e                	slli	a5,a5,0x3
    80002430:	97aa                	add	a5,a5,a0
    80002432:	6388                	ld	a0,0(a5)

  if (!file->readable && (prot & PROT_READ)) {
    80002434:	00854783          	lbu	a5,8(a0)
    80002438:	e789                	bnez	a5,80002442 <sys_mmap+0x7a>
    8000243a:	fc842783          	lw	a5,-56(s0)
    8000243e:	8b85                	andi	a5,a5,1
    80002440:	ebcd                	bnez	a5,800024f2 <sys_mmap+0x12a>
    return -1;
  }

  if (!file->writable && (prot & PROT_WRITE) && !(flags & MAP_PRIVATE)) {
    80002442:	00954783          	lbu	a5,9(a0)
    80002446:	e789                	bnez	a5,80002450 <sys_mmap+0x88>
    80002448:	fc842783          	lw	a5,-56(s0)
    8000244c:	8b89                	andi	a5,a5,2
    8000244e:	e785                	bnez	a5,80002476 <sys_mmap+0xae>
    return -1;
  }
  
  for (int i = 0; i < VMA_SIZE; i++) {
    80002450:	17090793          	addi	a5,s2,368
{
    80002454:	4481                	li	s1,0
  for (int i = 0; i < VMA_SIZE; i++) {
    80002456:	46c1                	li	a3,16
    if (!p->VMAs[i].valid) {
    80002458:	4398                	lw	a4,0(a5)
    8000245a:	c705                	beqz	a4,80002482 <sys_mmap+0xba>
  for (int i = 0; i < VMA_SIZE; i++) {
    8000245c:	2485                	addiw	s1,s1,1
    8000245e:	02878793          	addi	a5,a5,40
    80002462:	fed49be3          	bne	s1,a3,80002458 <sys_mmap+0x90>
      filedup(p->ofile[fd]);
      return p->VMAs[i].addr;
    }
  }

  panic("mmap: no free VMA");
    80002466:	00006517          	auipc	a0,0x6
    8000246a:	00a50513          	addi	a0,a0,10 # 80008470 <syscalls+0xc0>
    8000246e:	00004097          	auipc	ra,0x4
    80002472:	ae2080e7          	jalr	-1310(ra) # 80005f50 <panic>
  if (!file->writable && (prot & PROT_WRITE) && !(flags & MAP_PRIVATE)) {
    80002476:	fc442783          	lw	a5,-60(s0)
    8000247a:	8b89                	andi	a5,a5,2
    8000247c:	fbf1                	bnez	a5,80002450 <sys_mmap+0x88>
    return -1;
    8000247e:	557d                	li	a0,-1
    80002480:	a8a1                	j	800024d8 <sys_mmap+0x110>
      p->VMAs[i].valid = 1;
    80002482:	00249993          	slli	s3,s1,0x2
    80002486:	009987b3          	add	a5,s3,s1
    8000248a:	078e                	slli	a5,a5,0x3
    8000248c:	97ca                	add	a5,a5,s2
    8000248e:	4705                	li	a4,1
    80002490:	16e7a823          	sw	a4,368(a5)
      p->VMAs[i].file = file;
    80002494:	18a7b823          	sd	a0,400(a5)
      p->VMAs[i].size = length;
    80002498:	fcc42683          	lw	a3,-52(s0)
    8000249c:	18d7b023          	sd	a3,384(a5)
      p->VMAs[i].addr = PGROUNDDOWN(p->VMA_top - length);
    800024a0:	16893703          	ld	a4,360(s2)
    800024a4:	8f15                	sub	a4,a4,a3
    800024a6:	76fd                	lui	a3,0xfffff
    800024a8:	8f75                	and	a4,a4,a3
    800024aa:	16e7bc23          	sd	a4,376(a5)
      p->VMAs[i].permissions = prot;
    800024ae:	fc842683          	lw	a3,-56(s0)
    800024b2:	18d7a423          	sw	a3,392(a5)
      p->VMAs[i].flags = flags;
    800024b6:	fc442683          	lw	a3,-60(s0)
    800024ba:	18d7a623          	sw	a3,396(a5)
      p->VMA_top = p->VMAs[i].addr;
    800024be:	16e93423          	sd	a4,360(s2)
      filedup(p->ofile[fd]);
    800024c2:	00002097          	auipc	ra,0x2
    800024c6:	86c080e7          	jalr	-1940(ra) # 80003d2e <filedup>
      return p->VMAs[i].addr;
    800024ca:	99a6                	add	s3,s3,s1
    800024cc:	098e                	slli	s3,s3,0x3
    800024ce:	994e                	add	s2,s2,s3
    800024d0:	17893503          	ld	a0,376(s2)
    800024d4:	a011                	j	800024d8 <sys_mmap+0x110>
    return -1;
    800024d6:	557d                	li	a0,-1

  return -1;
  

}
    800024d8:	70e2                	ld	ra,56(sp)
    800024da:	7442                	ld	s0,48(sp)
    800024dc:	74a2                	ld	s1,40(sp)
    800024de:	7902                	ld	s2,32(sp)
    800024e0:	69e2                	ld	s3,24(sp)
    800024e2:	6121                	addi	sp,sp,64
    800024e4:	8082                	ret
    return -1;
    800024e6:	557d                	li	a0,-1
    800024e8:	bfc5                	j	800024d8 <sys_mmap+0x110>
    return -1;
    800024ea:	557d                	li	a0,-1
    800024ec:	b7f5                	j	800024d8 <sys_mmap+0x110>
    return -1;
    800024ee:	557d                	li	a0,-1
    800024f0:	b7e5                	j	800024d8 <sys_mmap+0x110>
    return -1;
    800024f2:	557d                	li	a0,-1
    800024f4:	b7d5                	j	800024d8 <sys_mmap+0x110>

00000000800024f6 <sys_munmap>:

uint64
sys_munmap(void)
{
    800024f6:	7139                	addi	sp,sp,-64
    800024f8:	fc06                	sd	ra,56(sp)
    800024fa:	f822                	sd	s0,48(sp)
    800024fc:	f426                	sd	s1,40(sp)
    800024fe:	f04a                	sd	s2,32(sp)
    80002500:	ec4e                	sd	s3,24(sp)
    80002502:	e852                	sd	s4,16(sp)
    80002504:	0080                	addi	s0,sp,64
  uint64 addr;
  if(argaddr(0, &addr) < 0)
    80002506:	fc840593          	addi	a1,s0,-56
    8000250a:	4501                	li	a0,0
    8000250c:	00000097          	auipc	ra,0x0
    80002510:	bfc080e7          	jalr	-1028(ra) # 80002108 <argaddr>
    80002514:	12054063          	bltz	a0,80002634 <sys_munmap+0x13e>
    return -1;
  int length;
  if(argint(1, &length) < 0)
    80002518:	fc440593          	addi	a1,s0,-60
    8000251c:	4505                	li	a0,1
    8000251e:	00000097          	auipc	ra,0x0
    80002522:	bc8080e7          	jalr	-1080(ra) # 800020e6 <argint>
    80002526:	12054163          	bltz	a0,80002648 <sys_munmap+0x152>
    return -1;

  struct proc *p = myproc();
    8000252a:	fffff097          	auipc	ra,0xfffff
    8000252e:	942080e7          	jalr	-1726(ra) # 80000e6c <myproc>
    80002532:	892a                	mv	s2,a0

  struct VMA *vma = 0;
  int found = 0;
  for (int i = 0; i < VMA_SIZE; i++) {
    if (p->VMAs[i].valid && addr >= p->VMAs[i].addr && addr <= p->VMAs[i].addr + p->VMAs[i].size) {
    80002534:	fc843583          	ld	a1,-56(s0)
    80002538:	17050793          	addi	a5,a0,368
  for (int i = 0; i < VMA_SIZE; i++) {
    8000253c:	4481                	li	s1,0
    8000253e:	4641                	li	a2,16
    80002540:	a031                	j	8000254c <sys_munmap+0x56>
    80002542:	2485                	addiw	s1,s1,1
    80002544:	02878793          	addi	a5,a5,40
    80002548:	08c48263          	beq	s1,a2,800025cc <sys_munmap+0xd6>
    if (p->VMAs[i].valid && addr >= p->VMAs[i].addr && addr <= p->VMAs[i].addr + p->VMAs[i].size) {
    8000254c:	4398                	lw	a4,0(a5)
    8000254e:	db75                	beqz	a4,80002542 <sys_munmap+0x4c>
    80002550:	6798                	ld	a4,8(a5)
    80002552:	fee5e8e3          	bltu	a1,a4,80002542 <sys_munmap+0x4c>
    80002556:	6b94                	ld	a3,16(a5)
    80002558:	9736                	add	a4,a4,a3
    8000255a:	feb764e3          	bltu	a4,a1,80002542 <sys_munmap+0x4c>
    return -1;
  }

  // printf("addr: %p", addr);

  if (vma->flags & MAP_SHARED) {
    8000255e:	00249793          	slli	a5,s1,0x2
    80002562:	97a6                	add	a5,a5,s1
    80002564:	078e                	slli	a5,a5,0x3
    80002566:	97ca                	add	a5,a5,s2
    80002568:	18c7a783          	lw	a5,396(a5)
    8000256c:	8b85                	andi	a5,a5,1
    8000256e:	e7bd                	bnez	a5,800025dc <sys_munmap+0xe6>
    filewrite(vma->file, addr, length);
  }

  uvmunmap(p->pagetable, addr, length / PGSIZE, 1);
    80002570:	fc442783          	lw	a5,-60(s0)
    80002574:	41f7d61b          	sraiw	a2,a5,0x1f
    80002578:	0146561b          	srliw	a2,a2,0x14
    8000257c:	9e3d                	addw	a2,a2,a5
    8000257e:	4685                	li	a3,1
    80002580:	40c6561b          	sraiw	a2,a2,0xc
    80002584:	fc843583          	ld	a1,-56(s0)
    80002588:	05093503          	ld	a0,80(s2)
    8000258c:	ffffe097          	auipc	ra,0xffffe
    80002590:	17c080e7          	jalr	380(ra) # 80000708 <uvmunmap>
  // in this lab, addr is only at start/end
  if (addr == vma->addr) {
    80002594:	00249793          	slli	a5,s1,0x2
    80002598:	97a6                	add	a5,a5,s1
    8000259a:	078e                	slli	a5,a5,0x3
    8000259c:	97ca                	add	a5,a5,s2
    8000259e:	1787b703          	ld	a4,376(a5)
    800025a2:	fc843783          	ld	a5,-56(s0)
    800025a6:	04f70963          	beq	a4,a5,800025f8 <sys_munmap+0x102>
    vma->addr += length;
    // printf("new addr: %p\n", vma->addr);

  }
  vma->size -= length;
    800025aa:	00249793          	slli	a5,s1,0x2
    800025ae:	97a6                	add	a5,a5,s1
    800025b0:	078e                	slli	a5,a5,0x3
    800025b2:	97ca                	add	a5,a5,s2
    800025b4:	fc442703          	lw	a4,-60(s0)
    800025b8:	1807b983          	ld	s3,384(a5)
    800025bc:	40e989b3          	sub	s3,s3,a4
    800025c0:	1937b023          	sd	s3,384(a5)


  if (vma->size <= 0) {
    800025c4:	04098563          	beqz	s3,8000260e <sys_munmap+0x118>
    vma->valid = 0;
  }

  

  return 0;
    800025c8:	4981                	li	s3,0
    800025ca:	a0b5                	j	80002636 <sys_munmap+0x140>
    panic("VMA not found?");
    800025cc:	00006517          	auipc	a0,0x6
    800025d0:	ebc50513          	addi	a0,a0,-324 # 80008488 <syscalls+0xd8>
    800025d4:	00004097          	auipc	ra,0x4
    800025d8:	97c080e7          	jalr	-1668(ra) # 80005f50 <panic>
    filewrite(vma->file, addr, length);
    800025dc:	00249793          	slli	a5,s1,0x2
    800025e0:	97a6                	add	a5,a5,s1
    800025e2:	078e                	slli	a5,a5,0x3
    800025e4:	97ca                	add	a5,a5,s2
    800025e6:	fc442603          	lw	a2,-60(s0)
    800025ea:	1907b503          	ld	a0,400(a5)
    800025ee:	00002097          	auipc	ra,0x2
    800025f2:	98e080e7          	jalr	-1650(ra) # 80003f7c <filewrite>
    800025f6:	bfad                	j	80002570 <sys_munmap+0x7a>
    vma->addr += length;
    800025f8:	00249793          	slli	a5,s1,0x2
    800025fc:	97a6                	add	a5,a5,s1
    800025fe:	078e                	slli	a5,a5,0x3
    80002600:	97ca                	add	a5,a5,s2
    80002602:	fc442683          	lw	a3,-60(s0)
    80002606:	9736                	add	a4,a4,a3
    80002608:	16e7bc23          	sd	a4,376(a5)
    8000260c:	bf79                	j	800025aa <sys_munmap+0xb4>
    fileclose(vma->file);
    8000260e:	00249a13          	slli	s4,s1,0x2
    80002612:	009a07b3          	add	a5,s4,s1
    80002616:	078e                	slli	a5,a5,0x3
    80002618:	97ca                	add	a5,a5,s2
    8000261a:	1907b503          	ld	a0,400(a5)
    8000261e:	00001097          	auipc	ra,0x1
    80002622:	762080e7          	jalr	1890(ra) # 80003d80 <fileclose>
    vma->valid = 0;
    80002626:	009a07b3          	add	a5,s4,s1
    8000262a:	078e                	slli	a5,a5,0x3
    8000262c:	993e                	add	s2,s2,a5
    8000262e:	16092823          	sw	zero,368(s2)
    80002632:	a011                	j	80002636 <sys_munmap+0x140>
    return -1;
    80002634:	59fd                	li	s3,-1
    80002636:	854e                	mv	a0,s3
    80002638:	70e2                	ld	ra,56(sp)
    8000263a:	7442                	ld	s0,48(sp)
    8000263c:	74a2                	ld	s1,40(sp)
    8000263e:	7902                	ld	s2,32(sp)
    80002640:	69e2                	ld	s3,24(sp)
    80002642:	6a42                	ld	s4,16(sp)
    80002644:	6121                	addi	sp,sp,64
    80002646:	8082                	ret
    return -1;
    80002648:	59fd                	li	s3,-1
    8000264a:	b7f5                	j	80002636 <sys_munmap+0x140>

000000008000264c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000264c:	7179                	addi	sp,sp,-48
    8000264e:	f406                	sd	ra,40(sp)
    80002650:	f022                	sd	s0,32(sp)
    80002652:	ec26                	sd	s1,24(sp)
    80002654:	e84a                	sd	s2,16(sp)
    80002656:	e44e                	sd	s3,8(sp)
    80002658:	e052                	sd	s4,0(sp)
    8000265a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000265c:	00006597          	auipc	a1,0x6
    80002660:	e3c58593          	addi	a1,a1,-452 # 80008498 <syscalls+0xe8>
    80002664:	00017517          	auipc	a0,0x17
    80002668:	a3450513          	addi	a0,a0,-1484 # 80019098 <bcache>
    8000266c:	00004097          	auipc	ra,0x4
    80002670:	d8c080e7          	jalr	-628(ra) # 800063f8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002674:	0001f797          	auipc	a5,0x1f
    80002678:	a2478793          	addi	a5,a5,-1500 # 80021098 <bcache+0x8000>
    8000267c:	0001f717          	auipc	a4,0x1f
    80002680:	c8470713          	addi	a4,a4,-892 # 80021300 <bcache+0x8268>
    80002684:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002688:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000268c:	00017497          	auipc	s1,0x17
    80002690:	a2448493          	addi	s1,s1,-1500 # 800190b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002694:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002696:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002698:	00006a17          	auipc	s4,0x6
    8000269c:	e08a0a13          	addi	s4,s4,-504 # 800084a0 <syscalls+0xf0>
    b->next = bcache.head.next;
    800026a0:	2b893783          	ld	a5,696(s2)
    800026a4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800026a6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800026aa:	85d2                	mv	a1,s4
    800026ac:	01048513          	addi	a0,s1,16
    800026b0:	00001097          	auipc	ra,0x1
    800026b4:	4c2080e7          	jalr	1218(ra) # 80003b72 <initsleeplock>
    bcache.head.next->prev = b;
    800026b8:	2b893783          	ld	a5,696(s2)
    800026bc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800026be:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800026c2:	45848493          	addi	s1,s1,1112
    800026c6:	fd349de3          	bne	s1,s3,800026a0 <binit+0x54>
  }
}
    800026ca:	70a2                	ld	ra,40(sp)
    800026cc:	7402                	ld	s0,32(sp)
    800026ce:	64e2                	ld	s1,24(sp)
    800026d0:	6942                	ld	s2,16(sp)
    800026d2:	69a2                	ld	s3,8(sp)
    800026d4:	6a02                	ld	s4,0(sp)
    800026d6:	6145                	addi	sp,sp,48
    800026d8:	8082                	ret

00000000800026da <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800026da:	7179                	addi	sp,sp,-48
    800026dc:	f406                	sd	ra,40(sp)
    800026de:	f022                	sd	s0,32(sp)
    800026e0:	ec26                	sd	s1,24(sp)
    800026e2:	e84a                	sd	s2,16(sp)
    800026e4:	e44e                	sd	s3,8(sp)
    800026e6:	1800                	addi	s0,sp,48
    800026e8:	892a                	mv	s2,a0
    800026ea:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800026ec:	00017517          	auipc	a0,0x17
    800026f0:	9ac50513          	addi	a0,a0,-1620 # 80019098 <bcache>
    800026f4:	00004097          	auipc	ra,0x4
    800026f8:	d94080e7          	jalr	-620(ra) # 80006488 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800026fc:	0001f497          	auipc	s1,0x1f
    80002700:	c544b483          	ld	s1,-940(s1) # 80021350 <bcache+0x82b8>
    80002704:	0001f797          	auipc	a5,0x1f
    80002708:	bfc78793          	addi	a5,a5,-1028 # 80021300 <bcache+0x8268>
    8000270c:	02f48f63          	beq	s1,a5,8000274a <bread+0x70>
    80002710:	873e                	mv	a4,a5
    80002712:	a021                	j	8000271a <bread+0x40>
    80002714:	68a4                	ld	s1,80(s1)
    80002716:	02e48a63          	beq	s1,a4,8000274a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000271a:	449c                	lw	a5,8(s1)
    8000271c:	ff279ce3          	bne	a5,s2,80002714 <bread+0x3a>
    80002720:	44dc                	lw	a5,12(s1)
    80002722:	ff3799e3          	bne	a5,s3,80002714 <bread+0x3a>
      b->refcnt++;
    80002726:	40bc                	lw	a5,64(s1)
    80002728:	2785                	addiw	a5,a5,1
    8000272a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000272c:	00017517          	auipc	a0,0x17
    80002730:	96c50513          	addi	a0,a0,-1684 # 80019098 <bcache>
    80002734:	00004097          	auipc	ra,0x4
    80002738:	e08080e7          	jalr	-504(ra) # 8000653c <release>
      acquiresleep(&b->lock);
    8000273c:	01048513          	addi	a0,s1,16
    80002740:	00001097          	auipc	ra,0x1
    80002744:	46c080e7          	jalr	1132(ra) # 80003bac <acquiresleep>
      return b;
    80002748:	a8b9                	j	800027a6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000274a:	0001f497          	auipc	s1,0x1f
    8000274e:	bfe4b483          	ld	s1,-1026(s1) # 80021348 <bcache+0x82b0>
    80002752:	0001f797          	auipc	a5,0x1f
    80002756:	bae78793          	addi	a5,a5,-1106 # 80021300 <bcache+0x8268>
    8000275a:	00f48863          	beq	s1,a5,8000276a <bread+0x90>
    8000275e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002760:	40bc                	lw	a5,64(s1)
    80002762:	cf81                	beqz	a5,8000277a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002764:	64a4                	ld	s1,72(s1)
    80002766:	fee49de3          	bne	s1,a4,80002760 <bread+0x86>
  panic("bget: no buffers");
    8000276a:	00006517          	auipc	a0,0x6
    8000276e:	d3e50513          	addi	a0,a0,-706 # 800084a8 <syscalls+0xf8>
    80002772:	00003097          	auipc	ra,0x3
    80002776:	7de080e7          	jalr	2014(ra) # 80005f50 <panic>
      b->dev = dev;
    8000277a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000277e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002782:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002786:	4785                	li	a5,1
    80002788:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000278a:	00017517          	auipc	a0,0x17
    8000278e:	90e50513          	addi	a0,a0,-1778 # 80019098 <bcache>
    80002792:	00004097          	auipc	ra,0x4
    80002796:	daa080e7          	jalr	-598(ra) # 8000653c <release>
      acquiresleep(&b->lock);
    8000279a:	01048513          	addi	a0,s1,16
    8000279e:	00001097          	auipc	ra,0x1
    800027a2:	40e080e7          	jalr	1038(ra) # 80003bac <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800027a6:	409c                	lw	a5,0(s1)
    800027a8:	cb89                	beqz	a5,800027ba <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800027aa:	8526                	mv	a0,s1
    800027ac:	70a2                	ld	ra,40(sp)
    800027ae:	7402                	ld	s0,32(sp)
    800027b0:	64e2                	ld	s1,24(sp)
    800027b2:	6942                	ld	s2,16(sp)
    800027b4:	69a2                	ld	s3,8(sp)
    800027b6:	6145                	addi	sp,sp,48
    800027b8:	8082                	ret
    virtio_disk_rw(b, 0);
    800027ba:	4581                	li	a1,0
    800027bc:	8526                	mv	a0,s1
    800027be:	00003097          	auipc	ra,0x3
    800027c2:	f24080e7          	jalr	-220(ra) # 800056e2 <virtio_disk_rw>
    b->valid = 1;
    800027c6:	4785                	li	a5,1
    800027c8:	c09c                	sw	a5,0(s1)
  return b;
    800027ca:	b7c5                	j	800027aa <bread+0xd0>

00000000800027cc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800027cc:	1101                	addi	sp,sp,-32
    800027ce:	ec06                	sd	ra,24(sp)
    800027d0:	e822                	sd	s0,16(sp)
    800027d2:	e426                	sd	s1,8(sp)
    800027d4:	1000                	addi	s0,sp,32
    800027d6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800027d8:	0541                	addi	a0,a0,16
    800027da:	00001097          	auipc	ra,0x1
    800027de:	46c080e7          	jalr	1132(ra) # 80003c46 <holdingsleep>
    800027e2:	cd01                	beqz	a0,800027fa <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800027e4:	4585                	li	a1,1
    800027e6:	8526                	mv	a0,s1
    800027e8:	00003097          	auipc	ra,0x3
    800027ec:	efa080e7          	jalr	-262(ra) # 800056e2 <virtio_disk_rw>
}
    800027f0:	60e2                	ld	ra,24(sp)
    800027f2:	6442                	ld	s0,16(sp)
    800027f4:	64a2                	ld	s1,8(sp)
    800027f6:	6105                	addi	sp,sp,32
    800027f8:	8082                	ret
    panic("bwrite");
    800027fa:	00006517          	auipc	a0,0x6
    800027fe:	cc650513          	addi	a0,a0,-826 # 800084c0 <syscalls+0x110>
    80002802:	00003097          	auipc	ra,0x3
    80002806:	74e080e7          	jalr	1870(ra) # 80005f50 <panic>

000000008000280a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000280a:	1101                	addi	sp,sp,-32
    8000280c:	ec06                	sd	ra,24(sp)
    8000280e:	e822                	sd	s0,16(sp)
    80002810:	e426                	sd	s1,8(sp)
    80002812:	e04a                	sd	s2,0(sp)
    80002814:	1000                	addi	s0,sp,32
    80002816:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002818:	01050913          	addi	s2,a0,16
    8000281c:	854a                	mv	a0,s2
    8000281e:	00001097          	auipc	ra,0x1
    80002822:	428080e7          	jalr	1064(ra) # 80003c46 <holdingsleep>
    80002826:	c92d                	beqz	a0,80002898 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002828:	854a                	mv	a0,s2
    8000282a:	00001097          	auipc	ra,0x1
    8000282e:	3d8080e7          	jalr	984(ra) # 80003c02 <releasesleep>

  acquire(&bcache.lock);
    80002832:	00017517          	auipc	a0,0x17
    80002836:	86650513          	addi	a0,a0,-1946 # 80019098 <bcache>
    8000283a:	00004097          	auipc	ra,0x4
    8000283e:	c4e080e7          	jalr	-946(ra) # 80006488 <acquire>
  b->refcnt--;
    80002842:	40bc                	lw	a5,64(s1)
    80002844:	37fd                	addiw	a5,a5,-1
    80002846:	0007871b          	sext.w	a4,a5
    8000284a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000284c:	eb05                	bnez	a4,8000287c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000284e:	68bc                	ld	a5,80(s1)
    80002850:	64b8                	ld	a4,72(s1)
    80002852:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002854:	64bc                	ld	a5,72(s1)
    80002856:	68b8                	ld	a4,80(s1)
    80002858:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000285a:	0001f797          	auipc	a5,0x1f
    8000285e:	83e78793          	addi	a5,a5,-1986 # 80021098 <bcache+0x8000>
    80002862:	2b87b703          	ld	a4,696(a5)
    80002866:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002868:	0001f717          	auipc	a4,0x1f
    8000286c:	a9870713          	addi	a4,a4,-1384 # 80021300 <bcache+0x8268>
    80002870:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002872:	2b87b703          	ld	a4,696(a5)
    80002876:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002878:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000287c:	00017517          	auipc	a0,0x17
    80002880:	81c50513          	addi	a0,a0,-2020 # 80019098 <bcache>
    80002884:	00004097          	auipc	ra,0x4
    80002888:	cb8080e7          	jalr	-840(ra) # 8000653c <release>
}
    8000288c:	60e2                	ld	ra,24(sp)
    8000288e:	6442                	ld	s0,16(sp)
    80002890:	64a2                	ld	s1,8(sp)
    80002892:	6902                	ld	s2,0(sp)
    80002894:	6105                	addi	sp,sp,32
    80002896:	8082                	ret
    panic("brelse");
    80002898:	00006517          	auipc	a0,0x6
    8000289c:	c3050513          	addi	a0,a0,-976 # 800084c8 <syscalls+0x118>
    800028a0:	00003097          	auipc	ra,0x3
    800028a4:	6b0080e7          	jalr	1712(ra) # 80005f50 <panic>

00000000800028a8 <bpin>:

void
bpin(struct buf *b) {
    800028a8:	1101                	addi	sp,sp,-32
    800028aa:	ec06                	sd	ra,24(sp)
    800028ac:	e822                	sd	s0,16(sp)
    800028ae:	e426                	sd	s1,8(sp)
    800028b0:	1000                	addi	s0,sp,32
    800028b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800028b4:	00016517          	auipc	a0,0x16
    800028b8:	7e450513          	addi	a0,a0,2020 # 80019098 <bcache>
    800028bc:	00004097          	auipc	ra,0x4
    800028c0:	bcc080e7          	jalr	-1076(ra) # 80006488 <acquire>
  b->refcnt++;
    800028c4:	40bc                	lw	a5,64(s1)
    800028c6:	2785                	addiw	a5,a5,1
    800028c8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800028ca:	00016517          	auipc	a0,0x16
    800028ce:	7ce50513          	addi	a0,a0,1998 # 80019098 <bcache>
    800028d2:	00004097          	auipc	ra,0x4
    800028d6:	c6a080e7          	jalr	-918(ra) # 8000653c <release>
}
    800028da:	60e2                	ld	ra,24(sp)
    800028dc:	6442                	ld	s0,16(sp)
    800028de:	64a2                	ld	s1,8(sp)
    800028e0:	6105                	addi	sp,sp,32
    800028e2:	8082                	ret

00000000800028e4 <bunpin>:

void
bunpin(struct buf *b) {
    800028e4:	1101                	addi	sp,sp,-32
    800028e6:	ec06                	sd	ra,24(sp)
    800028e8:	e822                	sd	s0,16(sp)
    800028ea:	e426                	sd	s1,8(sp)
    800028ec:	1000                	addi	s0,sp,32
    800028ee:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800028f0:	00016517          	auipc	a0,0x16
    800028f4:	7a850513          	addi	a0,a0,1960 # 80019098 <bcache>
    800028f8:	00004097          	auipc	ra,0x4
    800028fc:	b90080e7          	jalr	-1136(ra) # 80006488 <acquire>
  b->refcnt--;
    80002900:	40bc                	lw	a5,64(s1)
    80002902:	37fd                	addiw	a5,a5,-1
    80002904:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002906:	00016517          	auipc	a0,0x16
    8000290a:	79250513          	addi	a0,a0,1938 # 80019098 <bcache>
    8000290e:	00004097          	auipc	ra,0x4
    80002912:	c2e080e7          	jalr	-978(ra) # 8000653c <release>
}
    80002916:	60e2                	ld	ra,24(sp)
    80002918:	6442                	ld	s0,16(sp)
    8000291a:	64a2                	ld	s1,8(sp)
    8000291c:	6105                	addi	sp,sp,32
    8000291e:	8082                	ret

0000000080002920 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002920:	1101                	addi	sp,sp,-32
    80002922:	ec06                	sd	ra,24(sp)
    80002924:	e822                	sd	s0,16(sp)
    80002926:	e426                	sd	s1,8(sp)
    80002928:	e04a                	sd	s2,0(sp)
    8000292a:	1000                	addi	s0,sp,32
    8000292c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000292e:	00d5d59b          	srliw	a1,a1,0xd
    80002932:	0001f797          	auipc	a5,0x1f
    80002936:	e427a783          	lw	a5,-446(a5) # 80021774 <sb+0x1c>
    8000293a:	9dbd                	addw	a1,a1,a5
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	d9e080e7          	jalr	-610(ra) # 800026da <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002944:	0074f713          	andi	a4,s1,7
    80002948:	4785                	li	a5,1
    8000294a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000294e:	14ce                	slli	s1,s1,0x33
    80002950:	90d9                	srli	s1,s1,0x36
    80002952:	00950733          	add	a4,a0,s1
    80002956:	05874703          	lbu	a4,88(a4)
    8000295a:	00e7f6b3          	and	a3,a5,a4
    8000295e:	c69d                	beqz	a3,8000298c <bfree+0x6c>
    80002960:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002962:	94aa                	add	s1,s1,a0
    80002964:	fff7c793          	not	a5,a5
    80002968:	8f7d                	and	a4,a4,a5
    8000296a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000296e:	00001097          	auipc	ra,0x1
    80002972:	120080e7          	jalr	288(ra) # 80003a8e <log_write>
  brelse(bp);
    80002976:	854a                	mv	a0,s2
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	e92080e7          	jalr	-366(ra) # 8000280a <brelse>
}
    80002980:	60e2                	ld	ra,24(sp)
    80002982:	6442                	ld	s0,16(sp)
    80002984:	64a2                	ld	s1,8(sp)
    80002986:	6902                	ld	s2,0(sp)
    80002988:	6105                	addi	sp,sp,32
    8000298a:	8082                	ret
    panic("freeing free block");
    8000298c:	00006517          	auipc	a0,0x6
    80002990:	b4450513          	addi	a0,a0,-1212 # 800084d0 <syscalls+0x120>
    80002994:	00003097          	auipc	ra,0x3
    80002998:	5bc080e7          	jalr	1468(ra) # 80005f50 <panic>

000000008000299c <balloc>:
{
    8000299c:	711d                	addi	sp,sp,-96
    8000299e:	ec86                	sd	ra,88(sp)
    800029a0:	e8a2                	sd	s0,80(sp)
    800029a2:	e4a6                	sd	s1,72(sp)
    800029a4:	e0ca                	sd	s2,64(sp)
    800029a6:	fc4e                	sd	s3,56(sp)
    800029a8:	f852                	sd	s4,48(sp)
    800029aa:	f456                	sd	s5,40(sp)
    800029ac:	f05a                	sd	s6,32(sp)
    800029ae:	ec5e                	sd	s7,24(sp)
    800029b0:	e862                	sd	s8,16(sp)
    800029b2:	e466                	sd	s9,8(sp)
    800029b4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800029b6:	0001f797          	auipc	a5,0x1f
    800029ba:	da67a783          	lw	a5,-602(a5) # 8002175c <sb+0x4>
    800029be:	cbc1                	beqz	a5,80002a4e <balloc+0xb2>
    800029c0:	8baa                	mv	s7,a0
    800029c2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800029c4:	0001fb17          	auipc	s6,0x1f
    800029c8:	d94b0b13          	addi	s6,s6,-620 # 80021758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029cc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800029ce:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029d0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800029d2:	6c89                	lui	s9,0x2
    800029d4:	a831                	j	800029f0 <balloc+0x54>
    brelse(bp);
    800029d6:	854a                	mv	a0,s2
    800029d8:	00000097          	auipc	ra,0x0
    800029dc:	e32080e7          	jalr	-462(ra) # 8000280a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800029e0:	015c87bb          	addw	a5,s9,s5
    800029e4:	00078a9b          	sext.w	s5,a5
    800029e8:	004b2703          	lw	a4,4(s6)
    800029ec:	06eaf163          	bgeu	s5,a4,80002a4e <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800029f0:	41fad79b          	sraiw	a5,s5,0x1f
    800029f4:	0137d79b          	srliw	a5,a5,0x13
    800029f8:	015787bb          	addw	a5,a5,s5
    800029fc:	40d7d79b          	sraiw	a5,a5,0xd
    80002a00:	01cb2583          	lw	a1,28(s6)
    80002a04:	9dbd                	addw	a1,a1,a5
    80002a06:	855e                	mv	a0,s7
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	cd2080e7          	jalr	-814(ra) # 800026da <bread>
    80002a10:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a12:	004b2503          	lw	a0,4(s6)
    80002a16:	000a849b          	sext.w	s1,s5
    80002a1a:	8762                	mv	a4,s8
    80002a1c:	faa4fde3          	bgeu	s1,a0,800029d6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002a20:	00777693          	andi	a3,a4,7
    80002a24:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002a28:	41f7579b          	sraiw	a5,a4,0x1f
    80002a2c:	01d7d79b          	srliw	a5,a5,0x1d
    80002a30:	9fb9                	addw	a5,a5,a4
    80002a32:	4037d79b          	sraiw	a5,a5,0x3
    80002a36:	00f90633          	add	a2,s2,a5
    80002a3a:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80002a3e:	00c6f5b3          	and	a1,a3,a2
    80002a42:	cd91                	beqz	a1,80002a5e <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a44:	2705                	addiw	a4,a4,1
    80002a46:	2485                	addiw	s1,s1,1
    80002a48:	fd471ae3          	bne	a4,s4,80002a1c <balloc+0x80>
    80002a4c:	b769                	j	800029d6 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002a4e:	00006517          	auipc	a0,0x6
    80002a52:	a9a50513          	addi	a0,a0,-1382 # 800084e8 <syscalls+0x138>
    80002a56:	00003097          	auipc	ra,0x3
    80002a5a:	4fa080e7          	jalr	1274(ra) # 80005f50 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002a5e:	97ca                	add	a5,a5,s2
    80002a60:	8e55                	or	a2,a2,a3
    80002a62:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002a66:	854a                	mv	a0,s2
    80002a68:	00001097          	auipc	ra,0x1
    80002a6c:	026080e7          	jalr	38(ra) # 80003a8e <log_write>
        brelse(bp);
    80002a70:	854a                	mv	a0,s2
    80002a72:	00000097          	auipc	ra,0x0
    80002a76:	d98080e7          	jalr	-616(ra) # 8000280a <brelse>
  bp = bread(dev, bno);
    80002a7a:	85a6                	mv	a1,s1
    80002a7c:	855e                	mv	a0,s7
    80002a7e:	00000097          	auipc	ra,0x0
    80002a82:	c5c080e7          	jalr	-932(ra) # 800026da <bread>
    80002a86:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002a88:	40000613          	li	a2,1024
    80002a8c:	4581                	li	a1,0
    80002a8e:	05850513          	addi	a0,a0,88
    80002a92:	ffffd097          	auipc	ra,0xffffd
    80002a96:	6e8080e7          	jalr	1768(ra) # 8000017a <memset>
  log_write(bp);
    80002a9a:	854a                	mv	a0,s2
    80002a9c:	00001097          	auipc	ra,0x1
    80002aa0:	ff2080e7          	jalr	-14(ra) # 80003a8e <log_write>
  brelse(bp);
    80002aa4:	854a                	mv	a0,s2
    80002aa6:	00000097          	auipc	ra,0x0
    80002aaa:	d64080e7          	jalr	-668(ra) # 8000280a <brelse>
}
    80002aae:	8526                	mv	a0,s1
    80002ab0:	60e6                	ld	ra,88(sp)
    80002ab2:	6446                	ld	s0,80(sp)
    80002ab4:	64a6                	ld	s1,72(sp)
    80002ab6:	6906                	ld	s2,64(sp)
    80002ab8:	79e2                	ld	s3,56(sp)
    80002aba:	7a42                	ld	s4,48(sp)
    80002abc:	7aa2                	ld	s5,40(sp)
    80002abe:	7b02                	ld	s6,32(sp)
    80002ac0:	6be2                	ld	s7,24(sp)
    80002ac2:	6c42                	ld	s8,16(sp)
    80002ac4:	6ca2                	ld	s9,8(sp)
    80002ac6:	6125                	addi	sp,sp,96
    80002ac8:	8082                	ret

0000000080002aca <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002aca:	7179                	addi	sp,sp,-48
    80002acc:	f406                	sd	ra,40(sp)
    80002ace:	f022                	sd	s0,32(sp)
    80002ad0:	ec26                	sd	s1,24(sp)
    80002ad2:	e84a                	sd	s2,16(sp)
    80002ad4:	e44e                	sd	s3,8(sp)
    80002ad6:	e052                	sd	s4,0(sp)
    80002ad8:	1800                	addi	s0,sp,48
    80002ada:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002adc:	47ad                	li	a5,11
    80002ade:	04b7fe63          	bgeu	a5,a1,80002b3a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002ae2:	ff45849b          	addiw	s1,a1,-12
    80002ae6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002aea:	0ff00793          	li	a5,255
    80002aee:	0ae7e463          	bltu	a5,a4,80002b96 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002af2:	08052583          	lw	a1,128(a0)
    80002af6:	c5b5                	beqz	a1,80002b62 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002af8:	00092503          	lw	a0,0(s2)
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	bde080e7          	jalr	-1058(ra) # 800026da <bread>
    80002b04:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002b06:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002b0a:	02049713          	slli	a4,s1,0x20
    80002b0e:	01e75593          	srli	a1,a4,0x1e
    80002b12:	00b784b3          	add	s1,a5,a1
    80002b16:	0004a983          	lw	s3,0(s1)
    80002b1a:	04098e63          	beqz	s3,80002b76 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002b1e:	8552                	mv	a0,s4
    80002b20:	00000097          	auipc	ra,0x0
    80002b24:	cea080e7          	jalr	-790(ra) # 8000280a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002b28:	854e                	mv	a0,s3
    80002b2a:	70a2                	ld	ra,40(sp)
    80002b2c:	7402                	ld	s0,32(sp)
    80002b2e:	64e2                	ld	s1,24(sp)
    80002b30:	6942                	ld	s2,16(sp)
    80002b32:	69a2                	ld	s3,8(sp)
    80002b34:	6a02                	ld	s4,0(sp)
    80002b36:	6145                	addi	sp,sp,48
    80002b38:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002b3a:	02059793          	slli	a5,a1,0x20
    80002b3e:	01e7d593          	srli	a1,a5,0x1e
    80002b42:	00b504b3          	add	s1,a0,a1
    80002b46:	0504a983          	lw	s3,80(s1)
    80002b4a:	fc099fe3          	bnez	s3,80002b28 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002b4e:	4108                	lw	a0,0(a0)
    80002b50:	00000097          	auipc	ra,0x0
    80002b54:	e4c080e7          	jalr	-436(ra) # 8000299c <balloc>
    80002b58:	0005099b          	sext.w	s3,a0
    80002b5c:	0534a823          	sw	s3,80(s1)
    80002b60:	b7e1                	j	80002b28 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002b62:	4108                	lw	a0,0(a0)
    80002b64:	00000097          	auipc	ra,0x0
    80002b68:	e38080e7          	jalr	-456(ra) # 8000299c <balloc>
    80002b6c:	0005059b          	sext.w	a1,a0
    80002b70:	08b92023          	sw	a1,128(s2)
    80002b74:	b751                	j	80002af8 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002b76:	00092503          	lw	a0,0(s2)
    80002b7a:	00000097          	auipc	ra,0x0
    80002b7e:	e22080e7          	jalr	-478(ra) # 8000299c <balloc>
    80002b82:	0005099b          	sext.w	s3,a0
    80002b86:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002b8a:	8552                	mv	a0,s4
    80002b8c:	00001097          	auipc	ra,0x1
    80002b90:	f02080e7          	jalr	-254(ra) # 80003a8e <log_write>
    80002b94:	b769                	j	80002b1e <bmap+0x54>
  panic("bmap: out of range");
    80002b96:	00006517          	auipc	a0,0x6
    80002b9a:	96a50513          	addi	a0,a0,-1686 # 80008500 <syscalls+0x150>
    80002b9e:	00003097          	auipc	ra,0x3
    80002ba2:	3b2080e7          	jalr	946(ra) # 80005f50 <panic>

0000000080002ba6 <iget>:
{
    80002ba6:	7179                	addi	sp,sp,-48
    80002ba8:	f406                	sd	ra,40(sp)
    80002baa:	f022                	sd	s0,32(sp)
    80002bac:	ec26                	sd	s1,24(sp)
    80002bae:	e84a                	sd	s2,16(sp)
    80002bb0:	e44e                	sd	s3,8(sp)
    80002bb2:	e052                	sd	s4,0(sp)
    80002bb4:	1800                	addi	s0,sp,48
    80002bb6:	89aa                	mv	s3,a0
    80002bb8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002bba:	0001f517          	auipc	a0,0x1f
    80002bbe:	bbe50513          	addi	a0,a0,-1090 # 80021778 <itable>
    80002bc2:	00004097          	auipc	ra,0x4
    80002bc6:	8c6080e7          	jalr	-1850(ra) # 80006488 <acquire>
  empty = 0;
    80002bca:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002bcc:	0001f497          	auipc	s1,0x1f
    80002bd0:	bc448493          	addi	s1,s1,-1084 # 80021790 <itable+0x18>
    80002bd4:	00020697          	auipc	a3,0x20
    80002bd8:	64c68693          	addi	a3,a3,1612 # 80023220 <log>
    80002bdc:	a039                	j	80002bea <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002bde:	02090b63          	beqz	s2,80002c14 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002be2:	08848493          	addi	s1,s1,136
    80002be6:	02d48a63          	beq	s1,a3,80002c1a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002bea:	449c                	lw	a5,8(s1)
    80002bec:	fef059e3          	blez	a5,80002bde <iget+0x38>
    80002bf0:	4098                	lw	a4,0(s1)
    80002bf2:	ff3716e3          	bne	a4,s3,80002bde <iget+0x38>
    80002bf6:	40d8                	lw	a4,4(s1)
    80002bf8:	ff4713e3          	bne	a4,s4,80002bde <iget+0x38>
      ip->ref++;
    80002bfc:	2785                	addiw	a5,a5,1
    80002bfe:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002c00:	0001f517          	auipc	a0,0x1f
    80002c04:	b7850513          	addi	a0,a0,-1160 # 80021778 <itable>
    80002c08:	00004097          	auipc	ra,0x4
    80002c0c:	934080e7          	jalr	-1740(ra) # 8000653c <release>
      return ip;
    80002c10:	8926                	mv	s2,s1
    80002c12:	a03d                	j	80002c40 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002c14:	f7f9                	bnez	a5,80002be2 <iget+0x3c>
    80002c16:	8926                	mv	s2,s1
    80002c18:	b7e9                	j	80002be2 <iget+0x3c>
  if(empty == 0)
    80002c1a:	02090c63          	beqz	s2,80002c52 <iget+0xac>
  ip->dev = dev;
    80002c1e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002c22:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002c26:	4785                	li	a5,1
    80002c28:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002c2c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002c30:	0001f517          	auipc	a0,0x1f
    80002c34:	b4850513          	addi	a0,a0,-1208 # 80021778 <itable>
    80002c38:	00004097          	auipc	ra,0x4
    80002c3c:	904080e7          	jalr	-1788(ra) # 8000653c <release>
}
    80002c40:	854a                	mv	a0,s2
    80002c42:	70a2                	ld	ra,40(sp)
    80002c44:	7402                	ld	s0,32(sp)
    80002c46:	64e2                	ld	s1,24(sp)
    80002c48:	6942                	ld	s2,16(sp)
    80002c4a:	69a2                	ld	s3,8(sp)
    80002c4c:	6a02                	ld	s4,0(sp)
    80002c4e:	6145                	addi	sp,sp,48
    80002c50:	8082                	ret
    panic("iget: no inodes");
    80002c52:	00006517          	auipc	a0,0x6
    80002c56:	8c650513          	addi	a0,a0,-1850 # 80008518 <syscalls+0x168>
    80002c5a:	00003097          	auipc	ra,0x3
    80002c5e:	2f6080e7          	jalr	758(ra) # 80005f50 <panic>

0000000080002c62 <fsinit>:
fsinit(int dev) {
    80002c62:	7179                	addi	sp,sp,-48
    80002c64:	f406                	sd	ra,40(sp)
    80002c66:	f022                	sd	s0,32(sp)
    80002c68:	ec26                	sd	s1,24(sp)
    80002c6a:	e84a                	sd	s2,16(sp)
    80002c6c:	e44e                	sd	s3,8(sp)
    80002c6e:	1800                	addi	s0,sp,48
    80002c70:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002c72:	4585                	li	a1,1
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	a66080e7          	jalr	-1434(ra) # 800026da <bread>
    80002c7c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002c7e:	0001f997          	auipc	s3,0x1f
    80002c82:	ada98993          	addi	s3,s3,-1318 # 80021758 <sb>
    80002c86:	02000613          	li	a2,32
    80002c8a:	05850593          	addi	a1,a0,88
    80002c8e:	854e                	mv	a0,s3
    80002c90:	ffffd097          	auipc	ra,0xffffd
    80002c94:	546080e7          	jalr	1350(ra) # 800001d6 <memmove>
  brelse(bp);
    80002c98:	8526                	mv	a0,s1
    80002c9a:	00000097          	auipc	ra,0x0
    80002c9e:	b70080e7          	jalr	-1168(ra) # 8000280a <brelse>
  if(sb.magic != FSMAGIC)
    80002ca2:	0009a703          	lw	a4,0(s3)
    80002ca6:	102037b7          	lui	a5,0x10203
    80002caa:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002cae:	02f71263          	bne	a4,a5,80002cd2 <fsinit+0x70>
  initlog(dev, &sb);
    80002cb2:	0001f597          	auipc	a1,0x1f
    80002cb6:	aa658593          	addi	a1,a1,-1370 # 80021758 <sb>
    80002cba:	854a                	mv	a0,s2
    80002cbc:	00001097          	auipc	ra,0x1
    80002cc0:	b56080e7          	jalr	-1194(ra) # 80003812 <initlog>
}
    80002cc4:	70a2                	ld	ra,40(sp)
    80002cc6:	7402                	ld	s0,32(sp)
    80002cc8:	64e2                	ld	s1,24(sp)
    80002cca:	6942                	ld	s2,16(sp)
    80002ccc:	69a2                	ld	s3,8(sp)
    80002cce:	6145                	addi	sp,sp,48
    80002cd0:	8082                	ret
    panic("invalid file system");
    80002cd2:	00006517          	auipc	a0,0x6
    80002cd6:	85650513          	addi	a0,a0,-1962 # 80008528 <syscalls+0x178>
    80002cda:	00003097          	auipc	ra,0x3
    80002cde:	276080e7          	jalr	630(ra) # 80005f50 <panic>

0000000080002ce2 <iinit>:
{
    80002ce2:	7179                	addi	sp,sp,-48
    80002ce4:	f406                	sd	ra,40(sp)
    80002ce6:	f022                	sd	s0,32(sp)
    80002ce8:	ec26                	sd	s1,24(sp)
    80002cea:	e84a                	sd	s2,16(sp)
    80002cec:	e44e                	sd	s3,8(sp)
    80002cee:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002cf0:	00006597          	auipc	a1,0x6
    80002cf4:	85058593          	addi	a1,a1,-1968 # 80008540 <syscalls+0x190>
    80002cf8:	0001f517          	auipc	a0,0x1f
    80002cfc:	a8050513          	addi	a0,a0,-1408 # 80021778 <itable>
    80002d00:	00003097          	auipc	ra,0x3
    80002d04:	6f8080e7          	jalr	1784(ra) # 800063f8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002d08:	0001f497          	auipc	s1,0x1f
    80002d0c:	a9848493          	addi	s1,s1,-1384 # 800217a0 <itable+0x28>
    80002d10:	00020997          	auipc	s3,0x20
    80002d14:	52098993          	addi	s3,s3,1312 # 80023230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002d18:	00006917          	auipc	s2,0x6
    80002d1c:	83090913          	addi	s2,s2,-2000 # 80008548 <syscalls+0x198>
    80002d20:	85ca                	mv	a1,s2
    80002d22:	8526                	mv	a0,s1
    80002d24:	00001097          	auipc	ra,0x1
    80002d28:	e4e080e7          	jalr	-434(ra) # 80003b72 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002d2c:	08848493          	addi	s1,s1,136
    80002d30:	ff3498e3          	bne	s1,s3,80002d20 <iinit+0x3e>
}
    80002d34:	70a2                	ld	ra,40(sp)
    80002d36:	7402                	ld	s0,32(sp)
    80002d38:	64e2                	ld	s1,24(sp)
    80002d3a:	6942                	ld	s2,16(sp)
    80002d3c:	69a2                	ld	s3,8(sp)
    80002d3e:	6145                	addi	sp,sp,48
    80002d40:	8082                	ret

0000000080002d42 <ialloc>:
{
    80002d42:	715d                	addi	sp,sp,-80
    80002d44:	e486                	sd	ra,72(sp)
    80002d46:	e0a2                	sd	s0,64(sp)
    80002d48:	fc26                	sd	s1,56(sp)
    80002d4a:	f84a                	sd	s2,48(sp)
    80002d4c:	f44e                	sd	s3,40(sp)
    80002d4e:	f052                	sd	s4,32(sp)
    80002d50:	ec56                	sd	s5,24(sp)
    80002d52:	e85a                	sd	s6,16(sp)
    80002d54:	e45e                	sd	s7,8(sp)
    80002d56:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d58:	0001f717          	auipc	a4,0x1f
    80002d5c:	a0c72703          	lw	a4,-1524(a4) # 80021764 <sb+0xc>
    80002d60:	4785                	li	a5,1
    80002d62:	04e7fa63          	bgeu	a5,a4,80002db6 <ialloc+0x74>
    80002d66:	8aaa                	mv	s5,a0
    80002d68:	8bae                	mv	s7,a1
    80002d6a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002d6c:	0001fa17          	auipc	s4,0x1f
    80002d70:	9eca0a13          	addi	s4,s4,-1556 # 80021758 <sb>
    80002d74:	00048b1b          	sext.w	s6,s1
    80002d78:	0044d593          	srli	a1,s1,0x4
    80002d7c:	018a2783          	lw	a5,24(s4)
    80002d80:	9dbd                	addw	a1,a1,a5
    80002d82:	8556                	mv	a0,s5
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	956080e7          	jalr	-1706(ra) # 800026da <bread>
    80002d8c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002d8e:	05850993          	addi	s3,a0,88
    80002d92:	00f4f793          	andi	a5,s1,15
    80002d96:	079a                	slli	a5,a5,0x6
    80002d98:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002d9a:	00099783          	lh	a5,0(s3)
    80002d9e:	c785                	beqz	a5,80002dc6 <ialloc+0x84>
    brelse(bp);
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	a6a080e7          	jalr	-1430(ra) # 8000280a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002da8:	0485                	addi	s1,s1,1
    80002daa:	00ca2703          	lw	a4,12(s4)
    80002dae:	0004879b          	sext.w	a5,s1
    80002db2:	fce7e1e3          	bltu	a5,a4,80002d74 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002db6:	00005517          	auipc	a0,0x5
    80002dba:	79a50513          	addi	a0,a0,1946 # 80008550 <syscalls+0x1a0>
    80002dbe:	00003097          	auipc	ra,0x3
    80002dc2:	192080e7          	jalr	402(ra) # 80005f50 <panic>
      memset(dip, 0, sizeof(*dip));
    80002dc6:	04000613          	li	a2,64
    80002dca:	4581                	li	a1,0
    80002dcc:	854e                	mv	a0,s3
    80002dce:	ffffd097          	auipc	ra,0xffffd
    80002dd2:	3ac080e7          	jalr	940(ra) # 8000017a <memset>
      dip->type = type;
    80002dd6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002dda:	854a                	mv	a0,s2
    80002ddc:	00001097          	auipc	ra,0x1
    80002de0:	cb2080e7          	jalr	-846(ra) # 80003a8e <log_write>
      brelse(bp);
    80002de4:	854a                	mv	a0,s2
    80002de6:	00000097          	auipc	ra,0x0
    80002dea:	a24080e7          	jalr	-1500(ra) # 8000280a <brelse>
      return iget(dev, inum);
    80002dee:	85da                	mv	a1,s6
    80002df0:	8556                	mv	a0,s5
    80002df2:	00000097          	auipc	ra,0x0
    80002df6:	db4080e7          	jalr	-588(ra) # 80002ba6 <iget>
}
    80002dfa:	60a6                	ld	ra,72(sp)
    80002dfc:	6406                	ld	s0,64(sp)
    80002dfe:	74e2                	ld	s1,56(sp)
    80002e00:	7942                	ld	s2,48(sp)
    80002e02:	79a2                	ld	s3,40(sp)
    80002e04:	7a02                	ld	s4,32(sp)
    80002e06:	6ae2                	ld	s5,24(sp)
    80002e08:	6b42                	ld	s6,16(sp)
    80002e0a:	6ba2                	ld	s7,8(sp)
    80002e0c:	6161                	addi	sp,sp,80
    80002e0e:	8082                	ret

0000000080002e10 <iupdate>:
{
    80002e10:	1101                	addi	sp,sp,-32
    80002e12:	ec06                	sd	ra,24(sp)
    80002e14:	e822                	sd	s0,16(sp)
    80002e16:	e426                	sd	s1,8(sp)
    80002e18:	e04a                	sd	s2,0(sp)
    80002e1a:	1000                	addi	s0,sp,32
    80002e1c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e1e:	415c                	lw	a5,4(a0)
    80002e20:	0047d79b          	srliw	a5,a5,0x4
    80002e24:	0001f597          	auipc	a1,0x1f
    80002e28:	94c5a583          	lw	a1,-1716(a1) # 80021770 <sb+0x18>
    80002e2c:	9dbd                	addw	a1,a1,a5
    80002e2e:	4108                	lw	a0,0(a0)
    80002e30:	00000097          	auipc	ra,0x0
    80002e34:	8aa080e7          	jalr	-1878(ra) # 800026da <bread>
    80002e38:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e3a:	05850793          	addi	a5,a0,88
    80002e3e:	40d8                	lw	a4,4(s1)
    80002e40:	8b3d                	andi	a4,a4,15
    80002e42:	071a                	slli	a4,a4,0x6
    80002e44:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002e46:	04449703          	lh	a4,68(s1)
    80002e4a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002e4e:	04649703          	lh	a4,70(s1)
    80002e52:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002e56:	04849703          	lh	a4,72(s1)
    80002e5a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002e5e:	04a49703          	lh	a4,74(s1)
    80002e62:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002e66:	44f8                	lw	a4,76(s1)
    80002e68:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002e6a:	03400613          	li	a2,52
    80002e6e:	05048593          	addi	a1,s1,80
    80002e72:	00c78513          	addi	a0,a5,12
    80002e76:	ffffd097          	auipc	ra,0xffffd
    80002e7a:	360080e7          	jalr	864(ra) # 800001d6 <memmove>
  log_write(bp);
    80002e7e:	854a                	mv	a0,s2
    80002e80:	00001097          	auipc	ra,0x1
    80002e84:	c0e080e7          	jalr	-1010(ra) # 80003a8e <log_write>
  brelse(bp);
    80002e88:	854a                	mv	a0,s2
    80002e8a:	00000097          	auipc	ra,0x0
    80002e8e:	980080e7          	jalr	-1664(ra) # 8000280a <brelse>
}
    80002e92:	60e2                	ld	ra,24(sp)
    80002e94:	6442                	ld	s0,16(sp)
    80002e96:	64a2                	ld	s1,8(sp)
    80002e98:	6902                	ld	s2,0(sp)
    80002e9a:	6105                	addi	sp,sp,32
    80002e9c:	8082                	ret

0000000080002e9e <idup>:
{
    80002e9e:	1101                	addi	sp,sp,-32
    80002ea0:	ec06                	sd	ra,24(sp)
    80002ea2:	e822                	sd	s0,16(sp)
    80002ea4:	e426                	sd	s1,8(sp)
    80002ea6:	1000                	addi	s0,sp,32
    80002ea8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002eaa:	0001f517          	auipc	a0,0x1f
    80002eae:	8ce50513          	addi	a0,a0,-1842 # 80021778 <itable>
    80002eb2:	00003097          	auipc	ra,0x3
    80002eb6:	5d6080e7          	jalr	1494(ra) # 80006488 <acquire>
  ip->ref++;
    80002eba:	449c                	lw	a5,8(s1)
    80002ebc:	2785                	addiw	a5,a5,1
    80002ebe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ec0:	0001f517          	auipc	a0,0x1f
    80002ec4:	8b850513          	addi	a0,a0,-1864 # 80021778 <itable>
    80002ec8:	00003097          	auipc	ra,0x3
    80002ecc:	674080e7          	jalr	1652(ra) # 8000653c <release>
}
    80002ed0:	8526                	mv	a0,s1
    80002ed2:	60e2                	ld	ra,24(sp)
    80002ed4:	6442                	ld	s0,16(sp)
    80002ed6:	64a2                	ld	s1,8(sp)
    80002ed8:	6105                	addi	sp,sp,32
    80002eda:	8082                	ret

0000000080002edc <ilock>:
{
    80002edc:	1101                	addi	sp,sp,-32
    80002ede:	ec06                	sd	ra,24(sp)
    80002ee0:	e822                	sd	s0,16(sp)
    80002ee2:	e426                	sd	s1,8(sp)
    80002ee4:	e04a                	sd	s2,0(sp)
    80002ee6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ee8:	c115                	beqz	a0,80002f0c <ilock+0x30>
    80002eea:	84aa                	mv	s1,a0
    80002eec:	451c                	lw	a5,8(a0)
    80002eee:	00f05f63          	blez	a5,80002f0c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002ef2:	0541                	addi	a0,a0,16
    80002ef4:	00001097          	auipc	ra,0x1
    80002ef8:	cb8080e7          	jalr	-840(ra) # 80003bac <acquiresleep>
  if(ip->valid == 0){
    80002efc:	40bc                	lw	a5,64(s1)
    80002efe:	cf99                	beqz	a5,80002f1c <ilock+0x40>
}
    80002f00:	60e2                	ld	ra,24(sp)
    80002f02:	6442                	ld	s0,16(sp)
    80002f04:	64a2                	ld	s1,8(sp)
    80002f06:	6902                	ld	s2,0(sp)
    80002f08:	6105                	addi	sp,sp,32
    80002f0a:	8082                	ret
    panic("ilock");
    80002f0c:	00005517          	auipc	a0,0x5
    80002f10:	65c50513          	addi	a0,a0,1628 # 80008568 <syscalls+0x1b8>
    80002f14:	00003097          	auipc	ra,0x3
    80002f18:	03c080e7          	jalr	60(ra) # 80005f50 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002f1c:	40dc                	lw	a5,4(s1)
    80002f1e:	0047d79b          	srliw	a5,a5,0x4
    80002f22:	0001f597          	auipc	a1,0x1f
    80002f26:	84e5a583          	lw	a1,-1970(a1) # 80021770 <sb+0x18>
    80002f2a:	9dbd                	addw	a1,a1,a5
    80002f2c:	4088                	lw	a0,0(s1)
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	7ac080e7          	jalr	1964(ra) # 800026da <bread>
    80002f36:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002f38:	05850593          	addi	a1,a0,88
    80002f3c:	40dc                	lw	a5,4(s1)
    80002f3e:	8bbd                	andi	a5,a5,15
    80002f40:	079a                	slli	a5,a5,0x6
    80002f42:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002f44:	00059783          	lh	a5,0(a1)
    80002f48:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002f4c:	00259783          	lh	a5,2(a1)
    80002f50:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002f54:	00459783          	lh	a5,4(a1)
    80002f58:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002f5c:	00659783          	lh	a5,6(a1)
    80002f60:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002f64:	459c                	lw	a5,8(a1)
    80002f66:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002f68:	03400613          	li	a2,52
    80002f6c:	05b1                	addi	a1,a1,12
    80002f6e:	05048513          	addi	a0,s1,80
    80002f72:	ffffd097          	auipc	ra,0xffffd
    80002f76:	264080e7          	jalr	612(ra) # 800001d6 <memmove>
    brelse(bp);
    80002f7a:	854a                	mv	a0,s2
    80002f7c:	00000097          	auipc	ra,0x0
    80002f80:	88e080e7          	jalr	-1906(ra) # 8000280a <brelse>
    ip->valid = 1;
    80002f84:	4785                	li	a5,1
    80002f86:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002f88:	04449783          	lh	a5,68(s1)
    80002f8c:	fbb5                	bnez	a5,80002f00 <ilock+0x24>
      panic("ilock: no type");
    80002f8e:	00005517          	auipc	a0,0x5
    80002f92:	5e250513          	addi	a0,a0,1506 # 80008570 <syscalls+0x1c0>
    80002f96:	00003097          	auipc	ra,0x3
    80002f9a:	fba080e7          	jalr	-70(ra) # 80005f50 <panic>

0000000080002f9e <iunlock>:
{
    80002f9e:	1101                	addi	sp,sp,-32
    80002fa0:	ec06                	sd	ra,24(sp)
    80002fa2:	e822                	sd	s0,16(sp)
    80002fa4:	e426                	sd	s1,8(sp)
    80002fa6:	e04a                	sd	s2,0(sp)
    80002fa8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002faa:	c905                	beqz	a0,80002fda <iunlock+0x3c>
    80002fac:	84aa                	mv	s1,a0
    80002fae:	01050913          	addi	s2,a0,16
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	00001097          	auipc	ra,0x1
    80002fb8:	c92080e7          	jalr	-878(ra) # 80003c46 <holdingsleep>
    80002fbc:	cd19                	beqz	a0,80002fda <iunlock+0x3c>
    80002fbe:	449c                	lw	a5,8(s1)
    80002fc0:	00f05d63          	blez	a5,80002fda <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002fc4:	854a                	mv	a0,s2
    80002fc6:	00001097          	auipc	ra,0x1
    80002fca:	c3c080e7          	jalr	-964(ra) # 80003c02 <releasesleep>
}
    80002fce:	60e2                	ld	ra,24(sp)
    80002fd0:	6442                	ld	s0,16(sp)
    80002fd2:	64a2                	ld	s1,8(sp)
    80002fd4:	6902                	ld	s2,0(sp)
    80002fd6:	6105                	addi	sp,sp,32
    80002fd8:	8082                	ret
    panic("iunlock");
    80002fda:	00005517          	auipc	a0,0x5
    80002fde:	5a650513          	addi	a0,a0,1446 # 80008580 <syscalls+0x1d0>
    80002fe2:	00003097          	auipc	ra,0x3
    80002fe6:	f6e080e7          	jalr	-146(ra) # 80005f50 <panic>

0000000080002fea <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002fea:	7179                	addi	sp,sp,-48
    80002fec:	f406                	sd	ra,40(sp)
    80002fee:	f022                	sd	s0,32(sp)
    80002ff0:	ec26                	sd	s1,24(sp)
    80002ff2:	e84a                	sd	s2,16(sp)
    80002ff4:	e44e                	sd	s3,8(sp)
    80002ff6:	e052                	sd	s4,0(sp)
    80002ff8:	1800                	addi	s0,sp,48
    80002ffa:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ffc:	05050493          	addi	s1,a0,80
    80003000:	08050913          	addi	s2,a0,128
    80003004:	a021                	j	8000300c <itrunc+0x22>
    80003006:	0491                	addi	s1,s1,4
    80003008:	01248d63          	beq	s1,s2,80003022 <itrunc+0x38>
    if(ip->addrs[i]){
    8000300c:	408c                	lw	a1,0(s1)
    8000300e:	dde5                	beqz	a1,80003006 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003010:	0009a503          	lw	a0,0(s3)
    80003014:	00000097          	auipc	ra,0x0
    80003018:	90c080e7          	jalr	-1780(ra) # 80002920 <bfree>
      ip->addrs[i] = 0;
    8000301c:	0004a023          	sw	zero,0(s1)
    80003020:	b7dd                	j	80003006 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003022:	0809a583          	lw	a1,128(s3)
    80003026:	e185                	bnez	a1,80003046 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003028:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000302c:	854e                	mv	a0,s3
    8000302e:	00000097          	auipc	ra,0x0
    80003032:	de2080e7          	jalr	-542(ra) # 80002e10 <iupdate>
}
    80003036:	70a2                	ld	ra,40(sp)
    80003038:	7402                	ld	s0,32(sp)
    8000303a:	64e2                	ld	s1,24(sp)
    8000303c:	6942                	ld	s2,16(sp)
    8000303e:	69a2                	ld	s3,8(sp)
    80003040:	6a02                	ld	s4,0(sp)
    80003042:	6145                	addi	sp,sp,48
    80003044:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003046:	0009a503          	lw	a0,0(s3)
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	690080e7          	jalr	1680(ra) # 800026da <bread>
    80003052:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003054:	05850493          	addi	s1,a0,88
    80003058:	45850913          	addi	s2,a0,1112
    8000305c:	a021                	j	80003064 <itrunc+0x7a>
    8000305e:	0491                	addi	s1,s1,4
    80003060:	01248b63          	beq	s1,s2,80003076 <itrunc+0x8c>
      if(a[j])
    80003064:	408c                	lw	a1,0(s1)
    80003066:	dde5                	beqz	a1,8000305e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003068:	0009a503          	lw	a0,0(s3)
    8000306c:	00000097          	auipc	ra,0x0
    80003070:	8b4080e7          	jalr	-1868(ra) # 80002920 <bfree>
    80003074:	b7ed                	j	8000305e <itrunc+0x74>
    brelse(bp);
    80003076:	8552                	mv	a0,s4
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	792080e7          	jalr	1938(ra) # 8000280a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003080:	0809a583          	lw	a1,128(s3)
    80003084:	0009a503          	lw	a0,0(s3)
    80003088:	00000097          	auipc	ra,0x0
    8000308c:	898080e7          	jalr	-1896(ra) # 80002920 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003090:	0809a023          	sw	zero,128(s3)
    80003094:	bf51                	j	80003028 <itrunc+0x3e>

0000000080003096 <iput>:
{
    80003096:	1101                	addi	sp,sp,-32
    80003098:	ec06                	sd	ra,24(sp)
    8000309a:	e822                	sd	s0,16(sp)
    8000309c:	e426                	sd	s1,8(sp)
    8000309e:	e04a                	sd	s2,0(sp)
    800030a0:	1000                	addi	s0,sp,32
    800030a2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800030a4:	0001e517          	auipc	a0,0x1e
    800030a8:	6d450513          	addi	a0,a0,1748 # 80021778 <itable>
    800030ac:	00003097          	auipc	ra,0x3
    800030b0:	3dc080e7          	jalr	988(ra) # 80006488 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800030b4:	4498                	lw	a4,8(s1)
    800030b6:	4785                	li	a5,1
    800030b8:	02f70363          	beq	a4,a5,800030de <iput+0x48>
  ip->ref--;
    800030bc:	449c                	lw	a5,8(s1)
    800030be:	37fd                	addiw	a5,a5,-1
    800030c0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800030c2:	0001e517          	auipc	a0,0x1e
    800030c6:	6b650513          	addi	a0,a0,1718 # 80021778 <itable>
    800030ca:	00003097          	auipc	ra,0x3
    800030ce:	472080e7          	jalr	1138(ra) # 8000653c <release>
}
    800030d2:	60e2                	ld	ra,24(sp)
    800030d4:	6442                	ld	s0,16(sp)
    800030d6:	64a2                	ld	s1,8(sp)
    800030d8:	6902                	ld	s2,0(sp)
    800030da:	6105                	addi	sp,sp,32
    800030dc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800030de:	40bc                	lw	a5,64(s1)
    800030e0:	dff1                	beqz	a5,800030bc <iput+0x26>
    800030e2:	04a49783          	lh	a5,74(s1)
    800030e6:	fbf9                	bnez	a5,800030bc <iput+0x26>
    acquiresleep(&ip->lock);
    800030e8:	01048913          	addi	s2,s1,16
    800030ec:	854a                	mv	a0,s2
    800030ee:	00001097          	auipc	ra,0x1
    800030f2:	abe080e7          	jalr	-1346(ra) # 80003bac <acquiresleep>
    release(&itable.lock);
    800030f6:	0001e517          	auipc	a0,0x1e
    800030fa:	68250513          	addi	a0,a0,1666 # 80021778 <itable>
    800030fe:	00003097          	auipc	ra,0x3
    80003102:	43e080e7          	jalr	1086(ra) # 8000653c <release>
    itrunc(ip);
    80003106:	8526                	mv	a0,s1
    80003108:	00000097          	auipc	ra,0x0
    8000310c:	ee2080e7          	jalr	-286(ra) # 80002fea <itrunc>
    ip->type = 0;
    80003110:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003114:	8526                	mv	a0,s1
    80003116:	00000097          	auipc	ra,0x0
    8000311a:	cfa080e7          	jalr	-774(ra) # 80002e10 <iupdate>
    ip->valid = 0;
    8000311e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003122:	854a                	mv	a0,s2
    80003124:	00001097          	auipc	ra,0x1
    80003128:	ade080e7          	jalr	-1314(ra) # 80003c02 <releasesleep>
    acquire(&itable.lock);
    8000312c:	0001e517          	auipc	a0,0x1e
    80003130:	64c50513          	addi	a0,a0,1612 # 80021778 <itable>
    80003134:	00003097          	auipc	ra,0x3
    80003138:	354080e7          	jalr	852(ra) # 80006488 <acquire>
    8000313c:	b741                	j	800030bc <iput+0x26>

000000008000313e <iunlockput>:
{
    8000313e:	1101                	addi	sp,sp,-32
    80003140:	ec06                	sd	ra,24(sp)
    80003142:	e822                	sd	s0,16(sp)
    80003144:	e426                	sd	s1,8(sp)
    80003146:	1000                	addi	s0,sp,32
    80003148:	84aa                	mv	s1,a0
  iunlock(ip);
    8000314a:	00000097          	auipc	ra,0x0
    8000314e:	e54080e7          	jalr	-428(ra) # 80002f9e <iunlock>
  iput(ip);
    80003152:	8526                	mv	a0,s1
    80003154:	00000097          	auipc	ra,0x0
    80003158:	f42080e7          	jalr	-190(ra) # 80003096 <iput>
}
    8000315c:	60e2                	ld	ra,24(sp)
    8000315e:	6442                	ld	s0,16(sp)
    80003160:	64a2                	ld	s1,8(sp)
    80003162:	6105                	addi	sp,sp,32
    80003164:	8082                	ret

0000000080003166 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003166:	1141                	addi	sp,sp,-16
    80003168:	e422                	sd	s0,8(sp)
    8000316a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000316c:	411c                	lw	a5,0(a0)
    8000316e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003170:	415c                	lw	a5,4(a0)
    80003172:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003174:	04451783          	lh	a5,68(a0)
    80003178:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000317c:	04a51783          	lh	a5,74(a0)
    80003180:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003184:	04c56783          	lwu	a5,76(a0)
    80003188:	e99c                	sd	a5,16(a1)
}
    8000318a:	6422                	ld	s0,8(sp)
    8000318c:	0141                	addi	sp,sp,16
    8000318e:	8082                	ret

0000000080003190 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003190:	457c                	lw	a5,76(a0)
    80003192:	0ed7e963          	bltu	a5,a3,80003284 <readi+0xf4>
{
    80003196:	7159                	addi	sp,sp,-112
    80003198:	f486                	sd	ra,104(sp)
    8000319a:	f0a2                	sd	s0,96(sp)
    8000319c:	eca6                	sd	s1,88(sp)
    8000319e:	e8ca                	sd	s2,80(sp)
    800031a0:	e4ce                	sd	s3,72(sp)
    800031a2:	e0d2                	sd	s4,64(sp)
    800031a4:	fc56                	sd	s5,56(sp)
    800031a6:	f85a                	sd	s6,48(sp)
    800031a8:	f45e                	sd	s7,40(sp)
    800031aa:	f062                	sd	s8,32(sp)
    800031ac:	ec66                	sd	s9,24(sp)
    800031ae:	e86a                	sd	s10,16(sp)
    800031b0:	e46e                	sd	s11,8(sp)
    800031b2:	1880                	addi	s0,sp,112
    800031b4:	8baa                	mv	s7,a0
    800031b6:	8c2e                	mv	s8,a1
    800031b8:	8ab2                	mv	s5,a2
    800031ba:	84b6                	mv	s1,a3
    800031bc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800031be:	9f35                	addw	a4,a4,a3
    return 0;
    800031c0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800031c2:	0ad76063          	bltu	a4,a3,80003262 <readi+0xd2>
  if(off + n > ip->size)
    800031c6:	00e7f463          	bgeu	a5,a4,800031ce <readi+0x3e>
    n = ip->size - off;
    800031ca:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031ce:	0a0b0963          	beqz	s6,80003280 <readi+0xf0>
    800031d2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800031d4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800031d8:	5cfd                	li	s9,-1
    800031da:	a82d                	j	80003214 <readi+0x84>
    800031dc:	020a1d93          	slli	s11,s4,0x20
    800031e0:	020ddd93          	srli	s11,s11,0x20
    800031e4:	05890613          	addi	a2,s2,88
    800031e8:	86ee                	mv	a3,s11
    800031ea:	963a                	add	a2,a2,a4
    800031ec:	85d6                	mv	a1,s5
    800031ee:	8562                	mv	a0,s8
    800031f0:	ffffe097          	auipc	ra,0xffffe
    800031f4:	768080e7          	jalr	1896(ra) # 80001958 <either_copyout>
    800031f8:	05950d63          	beq	a0,s9,80003252 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800031fc:	854a                	mv	a0,s2
    800031fe:	fffff097          	auipc	ra,0xfffff
    80003202:	60c080e7          	jalr	1548(ra) # 8000280a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003206:	013a09bb          	addw	s3,s4,s3
    8000320a:	009a04bb          	addw	s1,s4,s1
    8000320e:	9aee                	add	s5,s5,s11
    80003210:	0569f763          	bgeu	s3,s6,8000325e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003214:	000ba903          	lw	s2,0(s7)
    80003218:	00a4d59b          	srliw	a1,s1,0xa
    8000321c:	855e                	mv	a0,s7
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	8ac080e7          	jalr	-1876(ra) # 80002aca <bmap>
    80003226:	0005059b          	sext.w	a1,a0
    8000322a:	854a                	mv	a0,s2
    8000322c:	fffff097          	auipc	ra,0xfffff
    80003230:	4ae080e7          	jalr	1198(ra) # 800026da <bread>
    80003234:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003236:	3ff4f713          	andi	a4,s1,1023
    8000323a:	40ed07bb          	subw	a5,s10,a4
    8000323e:	413b06bb          	subw	a3,s6,s3
    80003242:	8a3e                	mv	s4,a5
    80003244:	2781                	sext.w	a5,a5
    80003246:	0006861b          	sext.w	a2,a3
    8000324a:	f8f679e3          	bgeu	a2,a5,800031dc <readi+0x4c>
    8000324e:	8a36                	mv	s4,a3
    80003250:	b771                	j	800031dc <readi+0x4c>
      brelse(bp);
    80003252:	854a                	mv	a0,s2
    80003254:	fffff097          	auipc	ra,0xfffff
    80003258:	5b6080e7          	jalr	1462(ra) # 8000280a <brelse>
      tot = -1;
    8000325c:	59fd                	li	s3,-1
  }
  return tot;
    8000325e:	0009851b          	sext.w	a0,s3
}
    80003262:	70a6                	ld	ra,104(sp)
    80003264:	7406                	ld	s0,96(sp)
    80003266:	64e6                	ld	s1,88(sp)
    80003268:	6946                	ld	s2,80(sp)
    8000326a:	69a6                	ld	s3,72(sp)
    8000326c:	6a06                	ld	s4,64(sp)
    8000326e:	7ae2                	ld	s5,56(sp)
    80003270:	7b42                	ld	s6,48(sp)
    80003272:	7ba2                	ld	s7,40(sp)
    80003274:	7c02                	ld	s8,32(sp)
    80003276:	6ce2                	ld	s9,24(sp)
    80003278:	6d42                	ld	s10,16(sp)
    8000327a:	6da2                	ld	s11,8(sp)
    8000327c:	6165                	addi	sp,sp,112
    8000327e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003280:	89da                	mv	s3,s6
    80003282:	bff1                	j	8000325e <readi+0xce>
    return 0;
    80003284:	4501                	li	a0,0
}
    80003286:	8082                	ret

0000000080003288 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003288:	457c                	lw	a5,76(a0)
    8000328a:	10d7e863          	bltu	a5,a3,8000339a <writei+0x112>
{
    8000328e:	7159                	addi	sp,sp,-112
    80003290:	f486                	sd	ra,104(sp)
    80003292:	f0a2                	sd	s0,96(sp)
    80003294:	eca6                	sd	s1,88(sp)
    80003296:	e8ca                	sd	s2,80(sp)
    80003298:	e4ce                	sd	s3,72(sp)
    8000329a:	e0d2                	sd	s4,64(sp)
    8000329c:	fc56                	sd	s5,56(sp)
    8000329e:	f85a                	sd	s6,48(sp)
    800032a0:	f45e                	sd	s7,40(sp)
    800032a2:	f062                	sd	s8,32(sp)
    800032a4:	ec66                	sd	s9,24(sp)
    800032a6:	e86a                	sd	s10,16(sp)
    800032a8:	e46e                	sd	s11,8(sp)
    800032aa:	1880                	addi	s0,sp,112
    800032ac:	8b2a                	mv	s6,a0
    800032ae:	8c2e                	mv	s8,a1
    800032b0:	8ab2                	mv	s5,a2
    800032b2:	8936                	mv	s2,a3
    800032b4:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800032b6:	00e687bb          	addw	a5,a3,a4
    800032ba:	0ed7e263          	bltu	a5,a3,8000339e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800032be:	00043737          	lui	a4,0x43
    800032c2:	0ef76063          	bltu	a4,a5,800033a2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032c6:	0c0b8863          	beqz	s7,80003396 <writei+0x10e>
    800032ca:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800032cc:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800032d0:	5cfd                	li	s9,-1
    800032d2:	a091                	j	80003316 <writei+0x8e>
    800032d4:	02099d93          	slli	s11,s3,0x20
    800032d8:	020ddd93          	srli	s11,s11,0x20
    800032dc:	05848513          	addi	a0,s1,88
    800032e0:	86ee                	mv	a3,s11
    800032e2:	8656                	mv	a2,s5
    800032e4:	85e2                	mv	a1,s8
    800032e6:	953a                	add	a0,a0,a4
    800032e8:	ffffe097          	auipc	ra,0xffffe
    800032ec:	6c6080e7          	jalr	1734(ra) # 800019ae <either_copyin>
    800032f0:	07950263          	beq	a0,s9,80003354 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800032f4:	8526                	mv	a0,s1
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	798080e7          	jalr	1944(ra) # 80003a8e <log_write>
    brelse(bp);
    800032fe:	8526                	mv	a0,s1
    80003300:	fffff097          	auipc	ra,0xfffff
    80003304:	50a080e7          	jalr	1290(ra) # 8000280a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003308:	01498a3b          	addw	s4,s3,s4
    8000330c:	0129893b          	addw	s2,s3,s2
    80003310:	9aee                	add	s5,s5,s11
    80003312:	057a7663          	bgeu	s4,s7,8000335e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003316:	000b2483          	lw	s1,0(s6)
    8000331a:	00a9559b          	srliw	a1,s2,0xa
    8000331e:	855a                	mv	a0,s6
    80003320:	fffff097          	auipc	ra,0xfffff
    80003324:	7aa080e7          	jalr	1962(ra) # 80002aca <bmap>
    80003328:	0005059b          	sext.w	a1,a0
    8000332c:	8526                	mv	a0,s1
    8000332e:	fffff097          	auipc	ra,0xfffff
    80003332:	3ac080e7          	jalr	940(ra) # 800026da <bread>
    80003336:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003338:	3ff97713          	andi	a4,s2,1023
    8000333c:	40ed07bb          	subw	a5,s10,a4
    80003340:	414b86bb          	subw	a3,s7,s4
    80003344:	89be                	mv	s3,a5
    80003346:	2781                	sext.w	a5,a5
    80003348:	0006861b          	sext.w	a2,a3
    8000334c:	f8f674e3          	bgeu	a2,a5,800032d4 <writei+0x4c>
    80003350:	89b6                	mv	s3,a3
    80003352:	b749                	j	800032d4 <writei+0x4c>
      brelse(bp);
    80003354:	8526                	mv	a0,s1
    80003356:	fffff097          	auipc	ra,0xfffff
    8000335a:	4b4080e7          	jalr	1204(ra) # 8000280a <brelse>
  }

  if(off > ip->size)
    8000335e:	04cb2783          	lw	a5,76(s6)
    80003362:	0127f463          	bgeu	a5,s2,8000336a <writei+0xe2>
    ip->size = off;
    80003366:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000336a:	855a                	mv	a0,s6
    8000336c:	00000097          	auipc	ra,0x0
    80003370:	aa4080e7          	jalr	-1372(ra) # 80002e10 <iupdate>

  return tot;
    80003374:	000a051b          	sext.w	a0,s4
}
    80003378:	70a6                	ld	ra,104(sp)
    8000337a:	7406                	ld	s0,96(sp)
    8000337c:	64e6                	ld	s1,88(sp)
    8000337e:	6946                	ld	s2,80(sp)
    80003380:	69a6                	ld	s3,72(sp)
    80003382:	6a06                	ld	s4,64(sp)
    80003384:	7ae2                	ld	s5,56(sp)
    80003386:	7b42                	ld	s6,48(sp)
    80003388:	7ba2                	ld	s7,40(sp)
    8000338a:	7c02                	ld	s8,32(sp)
    8000338c:	6ce2                	ld	s9,24(sp)
    8000338e:	6d42                	ld	s10,16(sp)
    80003390:	6da2                	ld	s11,8(sp)
    80003392:	6165                	addi	sp,sp,112
    80003394:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003396:	8a5e                	mv	s4,s7
    80003398:	bfc9                	j	8000336a <writei+0xe2>
    return -1;
    8000339a:	557d                	li	a0,-1
}
    8000339c:	8082                	ret
    return -1;
    8000339e:	557d                	li	a0,-1
    800033a0:	bfe1                	j	80003378 <writei+0xf0>
    return -1;
    800033a2:	557d                	li	a0,-1
    800033a4:	bfd1                	j	80003378 <writei+0xf0>

00000000800033a6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800033a6:	1141                	addi	sp,sp,-16
    800033a8:	e406                	sd	ra,8(sp)
    800033aa:	e022                	sd	s0,0(sp)
    800033ac:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800033ae:	4639                	li	a2,14
    800033b0:	ffffd097          	auipc	ra,0xffffd
    800033b4:	e9a080e7          	jalr	-358(ra) # 8000024a <strncmp>
}
    800033b8:	60a2                	ld	ra,8(sp)
    800033ba:	6402                	ld	s0,0(sp)
    800033bc:	0141                	addi	sp,sp,16
    800033be:	8082                	ret

00000000800033c0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800033c0:	7139                	addi	sp,sp,-64
    800033c2:	fc06                	sd	ra,56(sp)
    800033c4:	f822                	sd	s0,48(sp)
    800033c6:	f426                	sd	s1,40(sp)
    800033c8:	f04a                	sd	s2,32(sp)
    800033ca:	ec4e                	sd	s3,24(sp)
    800033cc:	e852                	sd	s4,16(sp)
    800033ce:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800033d0:	04451703          	lh	a4,68(a0)
    800033d4:	4785                	li	a5,1
    800033d6:	00f71a63          	bne	a4,a5,800033ea <dirlookup+0x2a>
    800033da:	892a                	mv	s2,a0
    800033dc:	89ae                	mv	s3,a1
    800033de:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800033e0:	457c                	lw	a5,76(a0)
    800033e2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800033e4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033e6:	e79d                	bnez	a5,80003414 <dirlookup+0x54>
    800033e8:	a8a5                	j	80003460 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800033ea:	00005517          	auipc	a0,0x5
    800033ee:	19e50513          	addi	a0,a0,414 # 80008588 <syscalls+0x1d8>
    800033f2:	00003097          	auipc	ra,0x3
    800033f6:	b5e080e7          	jalr	-1186(ra) # 80005f50 <panic>
      panic("dirlookup read");
    800033fa:	00005517          	auipc	a0,0x5
    800033fe:	1a650513          	addi	a0,a0,422 # 800085a0 <syscalls+0x1f0>
    80003402:	00003097          	auipc	ra,0x3
    80003406:	b4e080e7          	jalr	-1202(ra) # 80005f50 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000340a:	24c1                	addiw	s1,s1,16
    8000340c:	04c92783          	lw	a5,76(s2)
    80003410:	04f4f763          	bgeu	s1,a5,8000345e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003414:	4741                	li	a4,16
    80003416:	86a6                	mv	a3,s1
    80003418:	fc040613          	addi	a2,s0,-64
    8000341c:	4581                	li	a1,0
    8000341e:	854a                	mv	a0,s2
    80003420:	00000097          	auipc	ra,0x0
    80003424:	d70080e7          	jalr	-656(ra) # 80003190 <readi>
    80003428:	47c1                	li	a5,16
    8000342a:	fcf518e3          	bne	a0,a5,800033fa <dirlookup+0x3a>
    if(de.inum == 0)
    8000342e:	fc045783          	lhu	a5,-64(s0)
    80003432:	dfe1                	beqz	a5,8000340a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003434:	fc240593          	addi	a1,s0,-62
    80003438:	854e                	mv	a0,s3
    8000343a:	00000097          	auipc	ra,0x0
    8000343e:	f6c080e7          	jalr	-148(ra) # 800033a6 <namecmp>
    80003442:	f561                	bnez	a0,8000340a <dirlookup+0x4a>
      if(poff)
    80003444:	000a0463          	beqz	s4,8000344c <dirlookup+0x8c>
        *poff = off;
    80003448:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000344c:	fc045583          	lhu	a1,-64(s0)
    80003450:	00092503          	lw	a0,0(s2)
    80003454:	fffff097          	auipc	ra,0xfffff
    80003458:	752080e7          	jalr	1874(ra) # 80002ba6 <iget>
    8000345c:	a011                	j	80003460 <dirlookup+0xa0>
  return 0;
    8000345e:	4501                	li	a0,0
}
    80003460:	70e2                	ld	ra,56(sp)
    80003462:	7442                	ld	s0,48(sp)
    80003464:	74a2                	ld	s1,40(sp)
    80003466:	7902                	ld	s2,32(sp)
    80003468:	69e2                	ld	s3,24(sp)
    8000346a:	6a42                	ld	s4,16(sp)
    8000346c:	6121                	addi	sp,sp,64
    8000346e:	8082                	ret

0000000080003470 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003470:	711d                	addi	sp,sp,-96
    80003472:	ec86                	sd	ra,88(sp)
    80003474:	e8a2                	sd	s0,80(sp)
    80003476:	e4a6                	sd	s1,72(sp)
    80003478:	e0ca                	sd	s2,64(sp)
    8000347a:	fc4e                	sd	s3,56(sp)
    8000347c:	f852                	sd	s4,48(sp)
    8000347e:	f456                	sd	s5,40(sp)
    80003480:	f05a                	sd	s6,32(sp)
    80003482:	ec5e                	sd	s7,24(sp)
    80003484:	e862                	sd	s8,16(sp)
    80003486:	e466                	sd	s9,8(sp)
    80003488:	e06a                	sd	s10,0(sp)
    8000348a:	1080                	addi	s0,sp,96
    8000348c:	84aa                	mv	s1,a0
    8000348e:	8b2e                	mv	s6,a1
    80003490:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003492:	00054703          	lbu	a4,0(a0)
    80003496:	02f00793          	li	a5,47
    8000349a:	02f70363          	beq	a4,a5,800034c0 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000349e:	ffffe097          	auipc	ra,0xffffe
    800034a2:	9ce080e7          	jalr	-1586(ra) # 80000e6c <myproc>
    800034a6:	15053503          	ld	a0,336(a0)
    800034aa:	00000097          	auipc	ra,0x0
    800034ae:	9f4080e7          	jalr	-1548(ra) # 80002e9e <idup>
    800034b2:	8a2a                	mv	s4,a0
  while(*path == '/')
    800034b4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800034b8:	4cb5                	li	s9,13
  len = path - s;
    800034ba:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800034bc:	4c05                	li	s8,1
    800034be:	a87d                	j	8000357c <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800034c0:	4585                	li	a1,1
    800034c2:	4505                	li	a0,1
    800034c4:	fffff097          	auipc	ra,0xfffff
    800034c8:	6e2080e7          	jalr	1762(ra) # 80002ba6 <iget>
    800034cc:	8a2a                	mv	s4,a0
    800034ce:	b7dd                	j	800034b4 <namex+0x44>
      iunlockput(ip);
    800034d0:	8552                	mv	a0,s4
    800034d2:	00000097          	auipc	ra,0x0
    800034d6:	c6c080e7          	jalr	-916(ra) # 8000313e <iunlockput>
      return 0;
    800034da:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800034dc:	8552                	mv	a0,s4
    800034de:	60e6                	ld	ra,88(sp)
    800034e0:	6446                	ld	s0,80(sp)
    800034e2:	64a6                	ld	s1,72(sp)
    800034e4:	6906                	ld	s2,64(sp)
    800034e6:	79e2                	ld	s3,56(sp)
    800034e8:	7a42                	ld	s4,48(sp)
    800034ea:	7aa2                	ld	s5,40(sp)
    800034ec:	7b02                	ld	s6,32(sp)
    800034ee:	6be2                	ld	s7,24(sp)
    800034f0:	6c42                	ld	s8,16(sp)
    800034f2:	6ca2                	ld	s9,8(sp)
    800034f4:	6d02                	ld	s10,0(sp)
    800034f6:	6125                	addi	sp,sp,96
    800034f8:	8082                	ret
      iunlock(ip);
    800034fa:	8552                	mv	a0,s4
    800034fc:	00000097          	auipc	ra,0x0
    80003500:	aa2080e7          	jalr	-1374(ra) # 80002f9e <iunlock>
      return ip;
    80003504:	bfe1                	j	800034dc <namex+0x6c>
      iunlockput(ip);
    80003506:	8552                	mv	a0,s4
    80003508:	00000097          	auipc	ra,0x0
    8000350c:	c36080e7          	jalr	-970(ra) # 8000313e <iunlockput>
      return 0;
    80003510:	8a4e                	mv	s4,s3
    80003512:	b7e9                	j	800034dc <namex+0x6c>
  len = path - s;
    80003514:	40998633          	sub	a2,s3,s1
    80003518:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000351c:	09acd863          	bge	s9,s10,800035ac <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003520:	4639                	li	a2,14
    80003522:	85a6                	mv	a1,s1
    80003524:	8556                	mv	a0,s5
    80003526:	ffffd097          	auipc	ra,0xffffd
    8000352a:	cb0080e7          	jalr	-848(ra) # 800001d6 <memmove>
    8000352e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003530:	0004c783          	lbu	a5,0(s1)
    80003534:	01279763          	bne	a5,s2,80003542 <namex+0xd2>
    path++;
    80003538:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000353a:	0004c783          	lbu	a5,0(s1)
    8000353e:	ff278de3          	beq	a5,s2,80003538 <namex+0xc8>
    ilock(ip);
    80003542:	8552                	mv	a0,s4
    80003544:	00000097          	auipc	ra,0x0
    80003548:	998080e7          	jalr	-1640(ra) # 80002edc <ilock>
    if(ip->type != T_DIR){
    8000354c:	044a1783          	lh	a5,68(s4)
    80003550:	f98790e3          	bne	a5,s8,800034d0 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003554:	000b0563          	beqz	s6,8000355e <namex+0xee>
    80003558:	0004c783          	lbu	a5,0(s1)
    8000355c:	dfd9                	beqz	a5,800034fa <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000355e:	865e                	mv	a2,s7
    80003560:	85d6                	mv	a1,s5
    80003562:	8552                	mv	a0,s4
    80003564:	00000097          	auipc	ra,0x0
    80003568:	e5c080e7          	jalr	-420(ra) # 800033c0 <dirlookup>
    8000356c:	89aa                	mv	s3,a0
    8000356e:	dd41                	beqz	a0,80003506 <namex+0x96>
    iunlockput(ip);
    80003570:	8552                	mv	a0,s4
    80003572:	00000097          	auipc	ra,0x0
    80003576:	bcc080e7          	jalr	-1076(ra) # 8000313e <iunlockput>
    ip = next;
    8000357a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000357c:	0004c783          	lbu	a5,0(s1)
    80003580:	01279763          	bne	a5,s2,8000358e <namex+0x11e>
    path++;
    80003584:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003586:	0004c783          	lbu	a5,0(s1)
    8000358a:	ff278de3          	beq	a5,s2,80003584 <namex+0x114>
  if(*path == 0)
    8000358e:	cb9d                	beqz	a5,800035c4 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003590:	0004c783          	lbu	a5,0(s1)
    80003594:	89a6                	mv	s3,s1
  len = path - s;
    80003596:	8d5e                	mv	s10,s7
    80003598:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000359a:	01278963          	beq	a5,s2,800035ac <namex+0x13c>
    8000359e:	dbbd                	beqz	a5,80003514 <namex+0xa4>
    path++;
    800035a0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800035a2:	0009c783          	lbu	a5,0(s3)
    800035a6:	ff279ce3          	bne	a5,s2,8000359e <namex+0x12e>
    800035aa:	b7ad                	j	80003514 <namex+0xa4>
    memmove(name, s, len);
    800035ac:	2601                	sext.w	a2,a2
    800035ae:	85a6                	mv	a1,s1
    800035b0:	8556                	mv	a0,s5
    800035b2:	ffffd097          	auipc	ra,0xffffd
    800035b6:	c24080e7          	jalr	-988(ra) # 800001d6 <memmove>
    name[len] = 0;
    800035ba:	9d56                	add	s10,s10,s5
    800035bc:	000d0023          	sb	zero,0(s10)
    800035c0:	84ce                	mv	s1,s3
    800035c2:	b7bd                	j	80003530 <namex+0xc0>
  if(nameiparent){
    800035c4:	f00b0ce3          	beqz	s6,800034dc <namex+0x6c>
    iput(ip);
    800035c8:	8552                	mv	a0,s4
    800035ca:	00000097          	auipc	ra,0x0
    800035ce:	acc080e7          	jalr	-1332(ra) # 80003096 <iput>
    return 0;
    800035d2:	4a01                	li	s4,0
    800035d4:	b721                	j	800034dc <namex+0x6c>

00000000800035d6 <dirlink>:
{
    800035d6:	7139                	addi	sp,sp,-64
    800035d8:	fc06                	sd	ra,56(sp)
    800035da:	f822                	sd	s0,48(sp)
    800035dc:	f426                	sd	s1,40(sp)
    800035de:	f04a                	sd	s2,32(sp)
    800035e0:	ec4e                	sd	s3,24(sp)
    800035e2:	e852                	sd	s4,16(sp)
    800035e4:	0080                	addi	s0,sp,64
    800035e6:	892a                	mv	s2,a0
    800035e8:	8a2e                	mv	s4,a1
    800035ea:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800035ec:	4601                	li	a2,0
    800035ee:	00000097          	auipc	ra,0x0
    800035f2:	dd2080e7          	jalr	-558(ra) # 800033c0 <dirlookup>
    800035f6:	e93d                	bnez	a0,8000366c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035f8:	04c92483          	lw	s1,76(s2)
    800035fc:	c49d                	beqz	s1,8000362a <dirlink+0x54>
    800035fe:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003600:	4741                	li	a4,16
    80003602:	86a6                	mv	a3,s1
    80003604:	fc040613          	addi	a2,s0,-64
    80003608:	4581                	li	a1,0
    8000360a:	854a                	mv	a0,s2
    8000360c:	00000097          	auipc	ra,0x0
    80003610:	b84080e7          	jalr	-1148(ra) # 80003190 <readi>
    80003614:	47c1                	li	a5,16
    80003616:	06f51163          	bne	a0,a5,80003678 <dirlink+0xa2>
    if(de.inum == 0)
    8000361a:	fc045783          	lhu	a5,-64(s0)
    8000361e:	c791                	beqz	a5,8000362a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003620:	24c1                	addiw	s1,s1,16
    80003622:	04c92783          	lw	a5,76(s2)
    80003626:	fcf4ede3          	bltu	s1,a5,80003600 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000362a:	4639                	li	a2,14
    8000362c:	85d2                	mv	a1,s4
    8000362e:	fc240513          	addi	a0,s0,-62
    80003632:	ffffd097          	auipc	ra,0xffffd
    80003636:	c54080e7          	jalr	-940(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000363a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000363e:	4741                	li	a4,16
    80003640:	86a6                	mv	a3,s1
    80003642:	fc040613          	addi	a2,s0,-64
    80003646:	4581                	li	a1,0
    80003648:	854a                	mv	a0,s2
    8000364a:	00000097          	auipc	ra,0x0
    8000364e:	c3e080e7          	jalr	-962(ra) # 80003288 <writei>
    80003652:	872a                	mv	a4,a0
    80003654:	47c1                	li	a5,16
  return 0;
    80003656:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003658:	02f71863          	bne	a4,a5,80003688 <dirlink+0xb2>
}
    8000365c:	70e2                	ld	ra,56(sp)
    8000365e:	7442                	ld	s0,48(sp)
    80003660:	74a2                	ld	s1,40(sp)
    80003662:	7902                	ld	s2,32(sp)
    80003664:	69e2                	ld	s3,24(sp)
    80003666:	6a42                	ld	s4,16(sp)
    80003668:	6121                	addi	sp,sp,64
    8000366a:	8082                	ret
    iput(ip);
    8000366c:	00000097          	auipc	ra,0x0
    80003670:	a2a080e7          	jalr	-1494(ra) # 80003096 <iput>
    return -1;
    80003674:	557d                	li	a0,-1
    80003676:	b7dd                	j	8000365c <dirlink+0x86>
      panic("dirlink read");
    80003678:	00005517          	auipc	a0,0x5
    8000367c:	f3850513          	addi	a0,a0,-200 # 800085b0 <syscalls+0x200>
    80003680:	00003097          	auipc	ra,0x3
    80003684:	8d0080e7          	jalr	-1840(ra) # 80005f50 <panic>
    panic("dirlink");
    80003688:	00005517          	auipc	a0,0x5
    8000368c:	03850513          	addi	a0,a0,56 # 800086c0 <syscalls+0x310>
    80003690:	00003097          	auipc	ra,0x3
    80003694:	8c0080e7          	jalr	-1856(ra) # 80005f50 <panic>

0000000080003698 <namei>:

struct inode*
namei(char *path)
{
    80003698:	1101                	addi	sp,sp,-32
    8000369a:	ec06                	sd	ra,24(sp)
    8000369c:	e822                	sd	s0,16(sp)
    8000369e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800036a0:	fe040613          	addi	a2,s0,-32
    800036a4:	4581                	li	a1,0
    800036a6:	00000097          	auipc	ra,0x0
    800036aa:	dca080e7          	jalr	-566(ra) # 80003470 <namex>
}
    800036ae:	60e2                	ld	ra,24(sp)
    800036b0:	6442                	ld	s0,16(sp)
    800036b2:	6105                	addi	sp,sp,32
    800036b4:	8082                	ret

00000000800036b6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800036b6:	1141                	addi	sp,sp,-16
    800036b8:	e406                	sd	ra,8(sp)
    800036ba:	e022                	sd	s0,0(sp)
    800036bc:	0800                	addi	s0,sp,16
    800036be:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800036c0:	4585                	li	a1,1
    800036c2:	00000097          	auipc	ra,0x0
    800036c6:	dae080e7          	jalr	-594(ra) # 80003470 <namex>
}
    800036ca:	60a2                	ld	ra,8(sp)
    800036cc:	6402                	ld	s0,0(sp)
    800036ce:	0141                	addi	sp,sp,16
    800036d0:	8082                	ret

00000000800036d2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800036d2:	1101                	addi	sp,sp,-32
    800036d4:	ec06                	sd	ra,24(sp)
    800036d6:	e822                	sd	s0,16(sp)
    800036d8:	e426                	sd	s1,8(sp)
    800036da:	e04a                	sd	s2,0(sp)
    800036dc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800036de:	00020917          	auipc	s2,0x20
    800036e2:	b4290913          	addi	s2,s2,-1214 # 80023220 <log>
    800036e6:	01892583          	lw	a1,24(s2)
    800036ea:	02892503          	lw	a0,40(s2)
    800036ee:	fffff097          	auipc	ra,0xfffff
    800036f2:	fec080e7          	jalr	-20(ra) # 800026da <bread>
    800036f6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800036f8:	02c92683          	lw	a3,44(s2)
    800036fc:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800036fe:	02d05863          	blez	a3,8000372e <write_head+0x5c>
    80003702:	00020797          	auipc	a5,0x20
    80003706:	b4e78793          	addi	a5,a5,-1202 # 80023250 <log+0x30>
    8000370a:	05c50713          	addi	a4,a0,92
    8000370e:	36fd                	addiw	a3,a3,-1
    80003710:	02069613          	slli	a2,a3,0x20
    80003714:	01e65693          	srli	a3,a2,0x1e
    80003718:	00020617          	auipc	a2,0x20
    8000371c:	b3c60613          	addi	a2,a2,-1220 # 80023254 <log+0x34>
    80003720:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003722:	4390                	lw	a2,0(a5)
    80003724:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003726:	0791                	addi	a5,a5,4
    80003728:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000372a:	fed79ce3          	bne	a5,a3,80003722 <write_head+0x50>
  }
  bwrite(buf);
    8000372e:	8526                	mv	a0,s1
    80003730:	fffff097          	auipc	ra,0xfffff
    80003734:	09c080e7          	jalr	156(ra) # 800027cc <bwrite>
  brelse(buf);
    80003738:	8526                	mv	a0,s1
    8000373a:	fffff097          	auipc	ra,0xfffff
    8000373e:	0d0080e7          	jalr	208(ra) # 8000280a <brelse>
}
    80003742:	60e2                	ld	ra,24(sp)
    80003744:	6442                	ld	s0,16(sp)
    80003746:	64a2                	ld	s1,8(sp)
    80003748:	6902                	ld	s2,0(sp)
    8000374a:	6105                	addi	sp,sp,32
    8000374c:	8082                	ret

000000008000374e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000374e:	00020797          	auipc	a5,0x20
    80003752:	afe7a783          	lw	a5,-1282(a5) # 8002324c <log+0x2c>
    80003756:	0af05d63          	blez	a5,80003810 <install_trans+0xc2>
{
    8000375a:	7139                	addi	sp,sp,-64
    8000375c:	fc06                	sd	ra,56(sp)
    8000375e:	f822                	sd	s0,48(sp)
    80003760:	f426                	sd	s1,40(sp)
    80003762:	f04a                	sd	s2,32(sp)
    80003764:	ec4e                	sd	s3,24(sp)
    80003766:	e852                	sd	s4,16(sp)
    80003768:	e456                	sd	s5,8(sp)
    8000376a:	e05a                	sd	s6,0(sp)
    8000376c:	0080                	addi	s0,sp,64
    8000376e:	8b2a                	mv	s6,a0
    80003770:	00020a97          	auipc	s5,0x20
    80003774:	ae0a8a93          	addi	s5,s5,-1312 # 80023250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003778:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000377a:	00020997          	auipc	s3,0x20
    8000377e:	aa698993          	addi	s3,s3,-1370 # 80023220 <log>
    80003782:	a00d                	j	800037a4 <install_trans+0x56>
    brelse(lbuf);
    80003784:	854a                	mv	a0,s2
    80003786:	fffff097          	auipc	ra,0xfffff
    8000378a:	084080e7          	jalr	132(ra) # 8000280a <brelse>
    brelse(dbuf);
    8000378e:	8526                	mv	a0,s1
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	07a080e7          	jalr	122(ra) # 8000280a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003798:	2a05                	addiw	s4,s4,1
    8000379a:	0a91                	addi	s5,s5,4
    8000379c:	02c9a783          	lw	a5,44(s3)
    800037a0:	04fa5e63          	bge	s4,a5,800037fc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800037a4:	0189a583          	lw	a1,24(s3)
    800037a8:	014585bb          	addw	a1,a1,s4
    800037ac:	2585                	addiw	a1,a1,1
    800037ae:	0289a503          	lw	a0,40(s3)
    800037b2:	fffff097          	auipc	ra,0xfffff
    800037b6:	f28080e7          	jalr	-216(ra) # 800026da <bread>
    800037ba:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800037bc:	000aa583          	lw	a1,0(s5)
    800037c0:	0289a503          	lw	a0,40(s3)
    800037c4:	fffff097          	auipc	ra,0xfffff
    800037c8:	f16080e7          	jalr	-234(ra) # 800026da <bread>
    800037cc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800037ce:	40000613          	li	a2,1024
    800037d2:	05890593          	addi	a1,s2,88
    800037d6:	05850513          	addi	a0,a0,88
    800037da:	ffffd097          	auipc	ra,0xffffd
    800037de:	9fc080e7          	jalr	-1540(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800037e2:	8526                	mv	a0,s1
    800037e4:	fffff097          	auipc	ra,0xfffff
    800037e8:	fe8080e7          	jalr	-24(ra) # 800027cc <bwrite>
    if(recovering == 0)
    800037ec:	f80b1ce3          	bnez	s6,80003784 <install_trans+0x36>
      bunpin(dbuf);
    800037f0:	8526                	mv	a0,s1
    800037f2:	fffff097          	auipc	ra,0xfffff
    800037f6:	0f2080e7          	jalr	242(ra) # 800028e4 <bunpin>
    800037fa:	b769                	j	80003784 <install_trans+0x36>
}
    800037fc:	70e2                	ld	ra,56(sp)
    800037fe:	7442                	ld	s0,48(sp)
    80003800:	74a2                	ld	s1,40(sp)
    80003802:	7902                	ld	s2,32(sp)
    80003804:	69e2                	ld	s3,24(sp)
    80003806:	6a42                	ld	s4,16(sp)
    80003808:	6aa2                	ld	s5,8(sp)
    8000380a:	6b02                	ld	s6,0(sp)
    8000380c:	6121                	addi	sp,sp,64
    8000380e:	8082                	ret
    80003810:	8082                	ret

0000000080003812 <initlog>:
{
    80003812:	7179                	addi	sp,sp,-48
    80003814:	f406                	sd	ra,40(sp)
    80003816:	f022                	sd	s0,32(sp)
    80003818:	ec26                	sd	s1,24(sp)
    8000381a:	e84a                	sd	s2,16(sp)
    8000381c:	e44e                	sd	s3,8(sp)
    8000381e:	1800                	addi	s0,sp,48
    80003820:	892a                	mv	s2,a0
    80003822:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003824:	00020497          	auipc	s1,0x20
    80003828:	9fc48493          	addi	s1,s1,-1540 # 80023220 <log>
    8000382c:	00005597          	auipc	a1,0x5
    80003830:	d9458593          	addi	a1,a1,-620 # 800085c0 <syscalls+0x210>
    80003834:	8526                	mv	a0,s1
    80003836:	00003097          	auipc	ra,0x3
    8000383a:	bc2080e7          	jalr	-1086(ra) # 800063f8 <initlock>
  log.start = sb->logstart;
    8000383e:	0149a583          	lw	a1,20(s3)
    80003842:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003844:	0109a783          	lw	a5,16(s3)
    80003848:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000384a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000384e:	854a                	mv	a0,s2
    80003850:	fffff097          	auipc	ra,0xfffff
    80003854:	e8a080e7          	jalr	-374(ra) # 800026da <bread>
  log.lh.n = lh->n;
    80003858:	4d34                	lw	a3,88(a0)
    8000385a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000385c:	02d05663          	blez	a3,80003888 <initlog+0x76>
    80003860:	05c50793          	addi	a5,a0,92
    80003864:	00020717          	auipc	a4,0x20
    80003868:	9ec70713          	addi	a4,a4,-1556 # 80023250 <log+0x30>
    8000386c:	36fd                	addiw	a3,a3,-1
    8000386e:	02069613          	slli	a2,a3,0x20
    80003872:	01e65693          	srli	a3,a2,0x1e
    80003876:	06050613          	addi	a2,a0,96
    8000387a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000387c:	4390                	lw	a2,0(a5)
    8000387e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003880:	0791                	addi	a5,a5,4
    80003882:	0711                	addi	a4,a4,4
    80003884:	fed79ce3          	bne	a5,a3,8000387c <initlog+0x6a>
  brelse(buf);
    80003888:	fffff097          	auipc	ra,0xfffff
    8000388c:	f82080e7          	jalr	-126(ra) # 8000280a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003890:	4505                	li	a0,1
    80003892:	00000097          	auipc	ra,0x0
    80003896:	ebc080e7          	jalr	-324(ra) # 8000374e <install_trans>
  log.lh.n = 0;
    8000389a:	00020797          	auipc	a5,0x20
    8000389e:	9a07a923          	sw	zero,-1614(a5) # 8002324c <log+0x2c>
  write_head(); // clear the log
    800038a2:	00000097          	auipc	ra,0x0
    800038a6:	e30080e7          	jalr	-464(ra) # 800036d2 <write_head>
}
    800038aa:	70a2                	ld	ra,40(sp)
    800038ac:	7402                	ld	s0,32(sp)
    800038ae:	64e2                	ld	s1,24(sp)
    800038b0:	6942                	ld	s2,16(sp)
    800038b2:	69a2                	ld	s3,8(sp)
    800038b4:	6145                	addi	sp,sp,48
    800038b6:	8082                	ret

00000000800038b8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800038b8:	1101                	addi	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	e426                	sd	s1,8(sp)
    800038c0:	e04a                	sd	s2,0(sp)
    800038c2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800038c4:	00020517          	auipc	a0,0x20
    800038c8:	95c50513          	addi	a0,a0,-1700 # 80023220 <log>
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	bbc080e7          	jalr	-1092(ra) # 80006488 <acquire>
  while(1){
    if(log.committing){
    800038d4:	00020497          	auipc	s1,0x20
    800038d8:	94c48493          	addi	s1,s1,-1716 # 80023220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800038dc:	4979                	li	s2,30
    800038de:	a039                	j	800038ec <begin_op+0x34>
      sleep(&log, &log.lock);
    800038e0:	85a6                	mv	a1,s1
    800038e2:	8526                	mv	a0,s1
    800038e4:	ffffe097          	auipc	ra,0xffffe
    800038e8:	c96080e7          	jalr	-874(ra) # 8000157a <sleep>
    if(log.committing){
    800038ec:	50dc                	lw	a5,36(s1)
    800038ee:	fbed                	bnez	a5,800038e0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800038f0:	5098                	lw	a4,32(s1)
    800038f2:	2705                	addiw	a4,a4,1
    800038f4:	0007069b          	sext.w	a3,a4
    800038f8:	0027179b          	slliw	a5,a4,0x2
    800038fc:	9fb9                	addw	a5,a5,a4
    800038fe:	0017979b          	slliw	a5,a5,0x1
    80003902:	54d8                	lw	a4,44(s1)
    80003904:	9fb9                	addw	a5,a5,a4
    80003906:	00f95963          	bge	s2,a5,80003918 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000390a:	85a6                	mv	a1,s1
    8000390c:	8526                	mv	a0,s1
    8000390e:	ffffe097          	auipc	ra,0xffffe
    80003912:	c6c080e7          	jalr	-916(ra) # 8000157a <sleep>
    80003916:	bfd9                	j	800038ec <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003918:	00020517          	auipc	a0,0x20
    8000391c:	90850513          	addi	a0,a0,-1784 # 80023220 <log>
    80003920:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003922:	00003097          	auipc	ra,0x3
    80003926:	c1a080e7          	jalr	-998(ra) # 8000653c <release>
      break;
    }
  }
}
    8000392a:	60e2                	ld	ra,24(sp)
    8000392c:	6442                	ld	s0,16(sp)
    8000392e:	64a2                	ld	s1,8(sp)
    80003930:	6902                	ld	s2,0(sp)
    80003932:	6105                	addi	sp,sp,32
    80003934:	8082                	ret

0000000080003936 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003936:	7139                	addi	sp,sp,-64
    80003938:	fc06                	sd	ra,56(sp)
    8000393a:	f822                	sd	s0,48(sp)
    8000393c:	f426                	sd	s1,40(sp)
    8000393e:	f04a                	sd	s2,32(sp)
    80003940:	ec4e                	sd	s3,24(sp)
    80003942:	e852                	sd	s4,16(sp)
    80003944:	e456                	sd	s5,8(sp)
    80003946:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003948:	00020497          	auipc	s1,0x20
    8000394c:	8d848493          	addi	s1,s1,-1832 # 80023220 <log>
    80003950:	8526                	mv	a0,s1
    80003952:	00003097          	auipc	ra,0x3
    80003956:	b36080e7          	jalr	-1226(ra) # 80006488 <acquire>
  log.outstanding -= 1;
    8000395a:	509c                	lw	a5,32(s1)
    8000395c:	37fd                	addiw	a5,a5,-1
    8000395e:	0007891b          	sext.w	s2,a5
    80003962:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003964:	50dc                	lw	a5,36(s1)
    80003966:	e7b9                	bnez	a5,800039b4 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003968:	04091e63          	bnez	s2,800039c4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000396c:	00020497          	auipc	s1,0x20
    80003970:	8b448493          	addi	s1,s1,-1868 # 80023220 <log>
    80003974:	4785                	li	a5,1
    80003976:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003978:	8526                	mv	a0,s1
    8000397a:	00003097          	auipc	ra,0x3
    8000397e:	bc2080e7          	jalr	-1086(ra) # 8000653c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003982:	54dc                	lw	a5,44(s1)
    80003984:	06f04763          	bgtz	a5,800039f2 <end_op+0xbc>
    acquire(&log.lock);
    80003988:	00020497          	auipc	s1,0x20
    8000398c:	89848493          	addi	s1,s1,-1896 # 80023220 <log>
    80003990:	8526                	mv	a0,s1
    80003992:	00003097          	auipc	ra,0x3
    80003996:	af6080e7          	jalr	-1290(ra) # 80006488 <acquire>
    log.committing = 0;
    8000399a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000399e:	8526                	mv	a0,s1
    800039a0:	ffffe097          	auipc	ra,0xffffe
    800039a4:	d66080e7          	jalr	-666(ra) # 80001706 <wakeup>
    release(&log.lock);
    800039a8:	8526                	mv	a0,s1
    800039aa:	00003097          	auipc	ra,0x3
    800039ae:	b92080e7          	jalr	-1134(ra) # 8000653c <release>
}
    800039b2:	a03d                	j	800039e0 <end_op+0xaa>
    panic("log.committing");
    800039b4:	00005517          	auipc	a0,0x5
    800039b8:	c1450513          	addi	a0,a0,-1004 # 800085c8 <syscalls+0x218>
    800039bc:	00002097          	auipc	ra,0x2
    800039c0:	594080e7          	jalr	1428(ra) # 80005f50 <panic>
    wakeup(&log);
    800039c4:	00020497          	auipc	s1,0x20
    800039c8:	85c48493          	addi	s1,s1,-1956 # 80023220 <log>
    800039cc:	8526                	mv	a0,s1
    800039ce:	ffffe097          	auipc	ra,0xffffe
    800039d2:	d38080e7          	jalr	-712(ra) # 80001706 <wakeup>
  release(&log.lock);
    800039d6:	8526                	mv	a0,s1
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	b64080e7          	jalr	-1180(ra) # 8000653c <release>
}
    800039e0:	70e2                	ld	ra,56(sp)
    800039e2:	7442                	ld	s0,48(sp)
    800039e4:	74a2                	ld	s1,40(sp)
    800039e6:	7902                	ld	s2,32(sp)
    800039e8:	69e2                	ld	s3,24(sp)
    800039ea:	6a42                	ld	s4,16(sp)
    800039ec:	6aa2                	ld	s5,8(sp)
    800039ee:	6121                	addi	sp,sp,64
    800039f0:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800039f2:	00020a97          	auipc	s5,0x20
    800039f6:	85ea8a93          	addi	s5,s5,-1954 # 80023250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800039fa:	00020a17          	auipc	s4,0x20
    800039fe:	826a0a13          	addi	s4,s4,-2010 # 80023220 <log>
    80003a02:	018a2583          	lw	a1,24(s4)
    80003a06:	012585bb          	addw	a1,a1,s2
    80003a0a:	2585                	addiw	a1,a1,1
    80003a0c:	028a2503          	lw	a0,40(s4)
    80003a10:	fffff097          	auipc	ra,0xfffff
    80003a14:	cca080e7          	jalr	-822(ra) # 800026da <bread>
    80003a18:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003a1a:	000aa583          	lw	a1,0(s5)
    80003a1e:	028a2503          	lw	a0,40(s4)
    80003a22:	fffff097          	auipc	ra,0xfffff
    80003a26:	cb8080e7          	jalr	-840(ra) # 800026da <bread>
    80003a2a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003a2c:	40000613          	li	a2,1024
    80003a30:	05850593          	addi	a1,a0,88
    80003a34:	05848513          	addi	a0,s1,88
    80003a38:	ffffc097          	auipc	ra,0xffffc
    80003a3c:	79e080e7          	jalr	1950(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003a40:	8526                	mv	a0,s1
    80003a42:	fffff097          	auipc	ra,0xfffff
    80003a46:	d8a080e7          	jalr	-630(ra) # 800027cc <bwrite>
    brelse(from);
    80003a4a:	854e                	mv	a0,s3
    80003a4c:	fffff097          	auipc	ra,0xfffff
    80003a50:	dbe080e7          	jalr	-578(ra) # 8000280a <brelse>
    brelse(to);
    80003a54:	8526                	mv	a0,s1
    80003a56:	fffff097          	auipc	ra,0xfffff
    80003a5a:	db4080e7          	jalr	-588(ra) # 8000280a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a5e:	2905                	addiw	s2,s2,1
    80003a60:	0a91                	addi	s5,s5,4
    80003a62:	02ca2783          	lw	a5,44(s4)
    80003a66:	f8f94ee3          	blt	s2,a5,80003a02 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003a6a:	00000097          	auipc	ra,0x0
    80003a6e:	c68080e7          	jalr	-920(ra) # 800036d2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003a72:	4501                	li	a0,0
    80003a74:	00000097          	auipc	ra,0x0
    80003a78:	cda080e7          	jalr	-806(ra) # 8000374e <install_trans>
    log.lh.n = 0;
    80003a7c:	0001f797          	auipc	a5,0x1f
    80003a80:	7c07a823          	sw	zero,2000(a5) # 8002324c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	c4e080e7          	jalr	-946(ra) # 800036d2 <write_head>
    80003a8c:	bdf5                	j	80003988 <end_op+0x52>

0000000080003a8e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003a8e:	1101                	addi	sp,sp,-32
    80003a90:	ec06                	sd	ra,24(sp)
    80003a92:	e822                	sd	s0,16(sp)
    80003a94:	e426                	sd	s1,8(sp)
    80003a96:	e04a                	sd	s2,0(sp)
    80003a98:	1000                	addi	s0,sp,32
    80003a9a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003a9c:	0001f917          	auipc	s2,0x1f
    80003aa0:	78490913          	addi	s2,s2,1924 # 80023220 <log>
    80003aa4:	854a                	mv	a0,s2
    80003aa6:	00003097          	auipc	ra,0x3
    80003aaa:	9e2080e7          	jalr	-1566(ra) # 80006488 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003aae:	02c92603          	lw	a2,44(s2)
    80003ab2:	47f5                	li	a5,29
    80003ab4:	06c7c563          	blt	a5,a2,80003b1e <log_write+0x90>
    80003ab8:	0001f797          	auipc	a5,0x1f
    80003abc:	7847a783          	lw	a5,1924(a5) # 8002323c <log+0x1c>
    80003ac0:	37fd                	addiw	a5,a5,-1
    80003ac2:	04f65e63          	bge	a2,a5,80003b1e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003ac6:	0001f797          	auipc	a5,0x1f
    80003aca:	77a7a783          	lw	a5,1914(a5) # 80023240 <log+0x20>
    80003ace:	06f05063          	blez	a5,80003b2e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003ad2:	4781                	li	a5,0
    80003ad4:	06c05563          	blez	a2,80003b3e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ad8:	44cc                	lw	a1,12(s1)
    80003ada:	0001f717          	auipc	a4,0x1f
    80003ade:	77670713          	addi	a4,a4,1910 # 80023250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003ae2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ae4:	4314                	lw	a3,0(a4)
    80003ae6:	04b68c63          	beq	a3,a1,80003b3e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003aea:	2785                	addiw	a5,a5,1
    80003aec:	0711                	addi	a4,a4,4
    80003aee:	fef61be3          	bne	a2,a5,80003ae4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003af2:	0621                	addi	a2,a2,8
    80003af4:	060a                	slli	a2,a2,0x2
    80003af6:	0001f797          	auipc	a5,0x1f
    80003afa:	72a78793          	addi	a5,a5,1834 # 80023220 <log>
    80003afe:	97b2                	add	a5,a5,a2
    80003b00:	44d8                	lw	a4,12(s1)
    80003b02:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003b04:	8526                	mv	a0,s1
    80003b06:	fffff097          	auipc	ra,0xfffff
    80003b0a:	da2080e7          	jalr	-606(ra) # 800028a8 <bpin>
    log.lh.n++;
    80003b0e:	0001f717          	auipc	a4,0x1f
    80003b12:	71270713          	addi	a4,a4,1810 # 80023220 <log>
    80003b16:	575c                	lw	a5,44(a4)
    80003b18:	2785                	addiw	a5,a5,1
    80003b1a:	d75c                	sw	a5,44(a4)
    80003b1c:	a82d                	j	80003b56 <log_write+0xc8>
    panic("too big a transaction");
    80003b1e:	00005517          	auipc	a0,0x5
    80003b22:	aba50513          	addi	a0,a0,-1350 # 800085d8 <syscalls+0x228>
    80003b26:	00002097          	auipc	ra,0x2
    80003b2a:	42a080e7          	jalr	1066(ra) # 80005f50 <panic>
    panic("log_write outside of trans");
    80003b2e:	00005517          	auipc	a0,0x5
    80003b32:	ac250513          	addi	a0,a0,-1342 # 800085f0 <syscalls+0x240>
    80003b36:	00002097          	auipc	ra,0x2
    80003b3a:	41a080e7          	jalr	1050(ra) # 80005f50 <panic>
  log.lh.block[i] = b->blockno;
    80003b3e:	00878693          	addi	a3,a5,8
    80003b42:	068a                	slli	a3,a3,0x2
    80003b44:	0001f717          	auipc	a4,0x1f
    80003b48:	6dc70713          	addi	a4,a4,1756 # 80023220 <log>
    80003b4c:	9736                	add	a4,a4,a3
    80003b4e:	44d4                	lw	a3,12(s1)
    80003b50:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003b52:	faf609e3          	beq	a2,a5,80003b04 <log_write+0x76>
  }
  release(&log.lock);
    80003b56:	0001f517          	auipc	a0,0x1f
    80003b5a:	6ca50513          	addi	a0,a0,1738 # 80023220 <log>
    80003b5e:	00003097          	auipc	ra,0x3
    80003b62:	9de080e7          	jalr	-1570(ra) # 8000653c <release>
}
    80003b66:	60e2                	ld	ra,24(sp)
    80003b68:	6442                	ld	s0,16(sp)
    80003b6a:	64a2                	ld	s1,8(sp)
    80003b6c:	6902                	ld	s2,0(sp)
    80003b6e:	6105                	addi	sp,sp,32
    80003b70:	8082                	ret

0000000080003b72 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003b72:	1101                	addi	sp,sp,-32
    80003b74:	ec06                	sd	ra,24(sp)
    80003b76:	e822                	sd	s0,16(sp)
    80003b78:	e426                	sd	s1,8(sp)
    80003b7a:	e04a                	sd	s2,0(sp)
    80003b7c:	1000                	addi	s0,sp,32
    80003b7e:	84aa                	mv	s1,a0
    80003b80:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003b82:	00005597          	auipc	a1,0x5
    80003b86:	a8e58593          	addi	a1,a1,-1394 # 80008610 <syscalls+0x260>
    80003b8a:	0521                	addi	a0,a0,8
    80003b8c:	00003097          	auipc	ra,0x3
    80003b90:	86c080e7          	jalr	-1940(ra) # 800063f8 <initlock>
  lk->name = name;
    80003b94:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003b98:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b9c:	0204a423          	sw	zero,40(s1)
}
    80003ba0:	60e2                	ld	ra,24(sp)
    80003ba2:	6442                	ld	s0,16(sp)
    80003ba4:	64a2                	ld	s1,8(sp)
    80003ba6:	6902                	ld	s2,0(sp)
    80003ba8:	6105                	addi	sp,sp,32
    80003baa:	8082                	ret

0000000080003bac <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003bac:	1101                	addi	sp,sp,-32
    80003bae:	ec06                	sd	ra,24(sp)
    80003bb0:	e822                	sd	s0,16(sp)
    80003bb2:	e426                	sd	s1,8(sp)
    80003bb4:	e04a                	sd	s2,0(sp)
    80003bb6:	1000                	addi	s0,sp,32
    80003bb8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003bba:	00850913          	addi	s2,a0,8
    80003bbe:	854a                	mv	a0,s2
    80003bc0:	00003097          	auipc	ra,0x3
    80003bc4:	8c8080e7          	jalr	-1848(ra) # 80006488 <acquire>
  while (lk->locked) {
    80003bc8:	409c                	lw	a5,0(s1)
    80003bca:	cb89                	beqz	a5,80003bdc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003bcc:	85ca                	mv	a1,s2
    80003bce:	8526                	mv	a0,s1
    80003bd0:	ffffe097          	auipc	ra,0xffffe
    80003bd4:	9aa080e7          	jalr	-1622(ra) # 8000157a <sleep>
  while (lk->locked) {
    80003bd8:	409c                	lw	a5,0(s1)
    80003bda:	fbed                	bnez	a5,80003bcc <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003bdc:	4785                	li	a5,1
    80003bde:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003be0:	ffffd097          	auipc	ra,0xffffd
    80003be4:	28c080e7          	jalr	652(ra) # 80000e6c <myproc>
    80003be8:	591c                	lw	a5,48(a0)
    80003bea:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003bec:	854a                	mv	a0,s2
    80003bee:	00003097          	auipc	ra,0x3
    80003bf2:	94e080e7          	jalr	-1714(ra) # 8000653c <release>
}
    80003bf6:	60e2                	ld	ra,24(sp)
    80003bf8:	6442                	ld	s0,16(sp)
    80003bfa:	64a2                	ld	s1,8(sp)
    80003bfc:	6902                	ld	s2,0(sp)
    80003bfe:	6105                	addi	sp,sp,32
    80003c00:	8082                	ret

0000000080003c02 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003c02:	1101                	addi	sp,sp,-32
    80003c04:	ec06                	sd	ra,24(sp)
    80003c06:	e822                	sd	s0,16(sp)
    80003c08:	e426                	sd	s1,8(sp)
    80003c0a:	e04a                	sd	s2,0(sp)
    80003c0c:	1000                	addi	s0,sp,32
    80003c0e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c10:	00850913          	addi	s2,a0,8
    80003c14:	854a                	mv	a0,s2
    80003c16:	00003097          	auipc	ra,0x3
    80003c1a:	872080e7          	jalr	-1934(ra) # 80006488 <acquire>
  lk->locked = 0;
    80003c1e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c22:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003c26:	8526                	mv	a0,s1
    80003c28:	ffffe097          	auipc	ra,0xffffe
    80003c2c:	ade080e7          	jalr	-1314(ra) # 80001706 <wakeup>
  release(&lk->lk);
    80003c30:	854a                	mv	a0,s2
    80003c32:	00003097          	auipc	ra,0x3
    80003c36:	90a080e7          	jalr	-1782(ra) # 8000653c <release>
}
    80003c3a:	60e2                	ld	ra,24(sp)
    80003c3c:	6442                	ld	s0,16(sp)
    80003c3e:	64a2                	ld	s1,8(sp)
    80003c40:	6902                	ld	s2,0(sp)
    80003c42:	6105                	addi	sp,sp,32
    80003c44:	8082                	ret

0000000080003c46 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003c46:	7179                	addi	sp,sp,-48
    80003c48:	f406                	sd	ra,40(sp)
    80003c4a:	f022                	sd	s0,32(sp)
    80003c4c:	ec26                	sd	s1,24(sp)
    80003c4e:	e84a                	sd	s2,16(sp)
    80003c50:	e44e                	sd	s3,8(sp)
    80003c52:	1800                	addi	s0,sp,48
    80003c54:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003c56:	00850913          	addi	s2,a0,8
    80003c5a:	854a                	mv	a0,s2
    80003c5c:	00003097          	auipc	ra,0x3
    80003c60:	82c080e7          	jalr	-2004(ra) # 80006488 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c64:	409c                	lw	a5,0(s1)
    80003c66:	ef99                	bnez	a5,80003c84 <holdingsleep+0x3e>
    80003c68:	4481                	li	s1,0
  release(&lk->lk);
    80003c6a:	854a                	mv	a0,s2
    80003c6c:	00003097          	auipc	ra,0x3
    80003c70:	8d0080e7          	jalr	-1840(ra) # 8000653c <release>
  return r;
}
    80003c74:	8526                	mv	a0,s1
    80003c76:	70a2                	ld	ra,40(sp)
    80003c78:	7402                	ld	s0,32(sp)
    80003c7a:	64e2                	ld	s1,24(sp)
    80003c7c:	6942                	ld	s2,16(sp)
    80003c7e:	69a2                	ld	s3,8(sp)
    80003c80:	6145                	addi	sp,sp,48
    80003c82:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c84:	0284a983          	lw	s3,40(s1)
    80003c88:	ffffd097          	auipc	ra,0xffffd
    80003c8c:	1e4080e7          	jalr	484(ra) # 80000e6c <myproc>
    80003c90:	5904                	lw	s1,48(a0)
    80003c92:	413484b3          	sub	s1,s1,s3
    80003c96:	0014b493          	seqz	s1,s1
    80003c9a:	bfc1                	j	80003c6a <holdingsleep+0x24>

0000000080003c9c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003c9c:	1141                	addi	sp,sp,-16
    80003c9e:	e406                	sd	ra,8(sp)
    80003ca0:	e022                	sd	s0,0(sp)
    80003ca2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ca4:	00005597          	auipc	a1,0x5
    80003ca8:	97c58593          	addi	a1,a1,-1668 # 80008620 <syscalls+0x270>
    80003cac:	0001f517          	auipc	a0,0x1f
    80003cb0:	6bc50513          	addi	a0,a0,1724 # 80023368 <ftable>
    80003cb4:	00002097          	auipc	ra,0x2
    80003cb8:	744080e7          	jalr	1860(ra) # 800063f8 <initlock>
}
    80003cbc:	60a2                	ld	ra,8(sp)
    80003cbe:	6402                	ld	s0,0(sp)
    80003cc0:	0141                	addi	sp,sp,16
    80003cc2:	8082                	ret

0000000080003cc4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003cc4:	1101                	addi	sp,sp,-32
    80003cc6:	ec06                	sd	ra,24(sp)
    80003cc8:	e822                	sd	s0,16(sp)
    80003cca:	e426                	sd	s1,8(sp)
    80003ccc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003cce:	0001f517          	auipc	a0,0x1f
    80003cd2:	69a50513          	addi	a0,a0,1690 # 80023368 <ftable>
    80003cd6:	00002097          	auipc	ra,0x2
    80003cda:	7b2080e7          	jalr	1970(ra) # 80006488 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003cde:	0001f497          	auipc	s1,0x1f
    80003ce2:	6a248493          	addi	s1,s1,1698 # 80023380 <ftable+0x18>
    80003ce6:	00020717          	auipc	a4,0x20
    80003cea:	63a70713          	addi	a4,a4,1594 # 80024320 <ftable+0xfb8>
    if(f->ref == 0){
    80003cee:	40dc                	lw	a5,4(s1)
    80003cf0:	cf99                	beqz	a5,80003d0e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003cf2:	02848493          	addi	s1,s1,40
    80003cf6:	fee49ce3          	bne	s1,a4,80003cee <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003cfa:	0001f517          	auipc	a0,0x1f
    80003cfe:	66e50513          	addi	a0,a0,1646 # 80023368 <ftable>
    80003d02:	00003097          	auipc	ra,0x3
    80003d06:	83a080e7          	jalr	-1990(ra) # 8000653c <release>
  return 0;
    80003d0a:	4481                	li	s1,0
    80003d0c:	a819                	j	80003d22 <filealloc+0x5e>
      f->ref = 1;
    80003d0e:	4785                	li	a5,1
    80003d10:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003d12:	0001f517          	auipc	a0,0x1f
    80003d16:	65650513          	addi	a0,a0,1622 # 80023368 <ftable>
    80003d1a:	00003097          	auipc	ra,0x3
    80003d1e:	822080e7          	jalr	-2014(ra) # 8000653c <release>
}
    80003d22:	8526                	mv	a0,s1
    80003d24:	60e2                	ld	ra,24(sp)
    80003d26:	6442                	ld	s0,16(sp)
    80003d28:	64a2                	ld	s1,8(sp)
    80003d2a:	6105                	addi	sp,sp,32
    80003d2c:	8082                	ret

0000000080003d2e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003d2e:	1101                	addi	sp,sp,-32
    80003d30:	ec06                	sd	ra,24(sp)
    80003d32:	e822                	sd	s0,16(sp)
    80003d34:	e426                	sd	s1,8(sp)
    80003d36:	1000                	addi	s0,sp,32
    80003d38:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003d3a:	0001f517          	auipc	a0,0x1f
    80003d3e:	62e50513          	addi	a0,a0,1582 # 80023368 <ftable>
    80003d42:	00002097          	auipc	ra,0x2
    80003d46:	746080e7          	jalr	1862(ra) # 80006488 <acquire>
  if(f->ref < 1)
    80003d4a:	40dc                	lw	a5,4(s1)
    80003d4c:	02f05263          	blez	a5,80003d70 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003d50:	2785                	addiw	a5,a5,1
    80003d52:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003d54:	0001f517          	auipc	a0,0x1f
    80003d58:	61450513          	addi	a0,a0,1556 # 80023368 <ftable>
    80003d5c:	00002097          	auipc	ra,0x2
    80003d60:	7e0080e7          	jalr	2016(ra) # 8000653c <release>
  return f;
}
    80003d64:	8526                	mv	a0,s1
    80003d66:	60e2                	ld	ra,24(sp)
    80003d68:	6442                	ld	s0,16(sp)
    80003d6a:	64a2                	ld	s1,8(sp)
    80003d6c:	6105                	addi	sp,sp,32
    80003d6e:	8082                	ret
    panic("filedup");
    80003d70:	00005517          	auipc	a0,0x5
    80003d74:	8b850513          	addi	a0,a0,-1864 # 80008628 <syscalls+0x278>
    80003d78:	00002097          	auipc	ra,0x2
    80003d7c:	1d8080e7          	jalr	472(ra) # 80005f50 <panic>

0000000080003d80 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003d80:	7139                	addi	sp,sp,-64
    80003d82:	fc06                	sd	ra,56(sp)
    80003d84:	f822                	sd	s0,48(sp)
    80003d86:	f426                	sd	s1,40(sp)
    80003d88:	f04a                	sd	s2,32(sp)
    80003d8a:	ec4e                	sd	s3,24(sp)
    80003d8c:	e852                	sd	s4,16(sp)
    80003d8e:	e456                	sd	s5,8(sp)
    80003d90:	0080                	addi	s0,sp,64
    80003d92:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003d94:	0001f517          	auipc	a0,0x1f
    80003d98:	5d450513          	addi	a0,a0,1492 # 80023368 <ftable>
    80003d9c:	00002097          	auipc	ra,0x2
    80003da0:	6ec080e7          	jalr	1772(ra) # 80006488 <acquire>
  if(f->ref < 1)
    80003da4:	40dc                	lw	a5,4(s1)
    80003da6:	06f05163          	blez	a5,80003e08 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003daa:	37fd                	addiw	a5,a5,-1
    80003dac:	0007871b          	sext.w	a4,a5
    80003db0:	c0dc                	sw	a5,4(s1)
    80003db2:	06e04363          	bgtz	a4,80003e18 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003db6:	0004a903          	lw	s2,0(s1)
    80003dba:	0094ca83          	lbu	s5,9(s1)
    80003dbe:	0104ba03          	ld	s4,16(s1)
    80003dc2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003dc6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003dca:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003dce:	0001f517          	auipc	a0,0x1f
    80003dd2:	59a50513          	addi	a0,a0,1434 # 80023368 <ftable>
    80003dd6:	00002097          	auipc	ra,0x2
    80003dda:	766080e7          	jalr	1894(ra) # 8000653c <release>

  if(ff.type == FD_PIPE){
    80003dde:	4785                	li	a5,1
    80003de0:	04f90d63          	beq	s2,a5,80003e3a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003de4:	3979                	addiw	s2,s2,-2
    80003de6:	4785                	li	a5,1
    80003de8:	0527e063          	bltu	a5,s2,80003e28 <fileclose+0xa8>
    begin_op();
    80003dec:	00000097          	auipc	ra,0x0
    80003df0:	acc080e7          	jalr	-1332(ra) # 800038b8 <begin_op>
    iput(ff.ip);
    80003df4:	854e                	mv	a0,s3
    80003df6:	fffff097          	auipc	ra,0xfffff
    80003dfa:	2a0080e7          	jalr	672(ra) # 80003096 <iput>
    end_op();
    80003dfe:	00000097          	auipc	ra,0x0
    80003e02:	b38080e7          	jalr	-1224(ra) # 80003936 <end_op>
    80003e06:	a00d                	j	80003e28 <fileclose+0xa8>
    panic("fileclose");
    80003e08:	00005517          	auipc	a0,0x5
    80003e0c:	82850513          	addi	a0,a0,-2008 # 80008630 <syscalls+0x280>
    80003e10:	00002097          	auipc	ra,0x2
    80003e14:	140080e7          	jalr	320(ra) # 80005f50 <panic>
    release(&ftable.lock);
    80003e18:	0001f517          	auipc	a0,0x1f
    80003e1c:	55050513          	addi	a0,a0,1360 # 80023368 <ftable>
    80003e20:	00002097          	auipc	ra,0x2
    80003e24:	71c080e7          	jalr	1820(ra) # 8000653c <release>
  }
}
    80003e28:	70e2                	ld	ra,56(sp)
    80003e2a:	7442                	ld	s0,48(sp)
    80003e2c:	74a2                	ld	s1,40(sp)
    80003e2e:	7902                	ld	s2,32(sp)
    80003e30:	69e2                	ld	s3,24(sp)
    80003e32:	6a42                	ld	s4,16(sp)
    80003e34:	6aa2                	ld	s5,8(sp)
    80003e36:	6121                	addi	sp,sp,64
    80003e38:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003e3a:	85d6                	mv	a1,s5
    80003e3c:	8552                	mv	a0,s4
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	34c080e7          	jalr	844(ra) # 8000418a <pipeclose>
    80003e46:	b7cd                	j	80003e28 <fileclose+0xa8>

0000000080003e48 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003e48:	715d                	addi	sp,sp,-80
    80003e4a:	e486                	sd	ra,72(sp)
    80003e4c:	e0a2                	sd	s0,64(sp)
    80003e4e:	fc26                	sd	s1,56(sp)
    80003e50:	f84a                	sd	s2,48(sp)
    80003e52:	f44e                	sd	s3,40(sp)
    80003e54:	0880                	addi	s0,sp,80
    80003e56:	84aa                	mv	s1,a0
    80003e58:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003e5a:	ffffd097          	auipc	ra,0xffffd
    80003e5e:	012080e7          	jalr	18(ra) # 80000e6c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003e62:	409c                	lw	a5,0(s1)
    80003e64:	37f9                	addiw	a5,a5,-2
    80003e66:	4705                	li	a4,1
    80003e68:	04f76763          	bltu	a4,a5,80003eb6 <filestat+0x6e>
    80003e6c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e6e:	6c88                	ld	a0,24(s1)
    80003e70:	fffff097          	auipc	ra,0xfffff
    80003e74:	06c080e7          	jalr	108(ra) # 80002edc <ilock>
    stati(f->ip, &st);
    80003e78:	fb840593          	addi	a1,s0,-72
    80003e7c:	6c88                	ld	a0,24(s1)
    80003e7e:	fffff097          	auipc	ra,0xfffff
    80003e82:	2e8080e7          	jalr	744(ra) # 80003166 <stati>
    iunlock(f->ip);
    80003e86:	6c88                	ld	a0,24(s1)
    80003e88:	fffff097          	auipc	ra,0xfffff
    80003e8c:	116080e7          	jalr	278(ra) # 80002f9e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e90:	46e1                	li	a3,24
    80003e92:	fb840613          	addi	a2,s0,-72
    80003e96:	85ce                	mv	a1,s3
    80003e98:	05093503          	ld	a0,80(s2)
    80003e9c:	ffffd097          	auipc	ra,0xffffd
    80003ea0:	c5e080e7          	jalr	-930(ra) # 80000afa <copyout>
    80003ea4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003ea8:	60a6                	ld	ra,72(sp)
    80003eaa:	6406                	ld	s0,64(sp)
    80003eac:	74e2                	ld	s1,56(sp)
    80003eae:	7942                	ld	s2,48(sp)
    80003eb0:	79a2                	ld	s3,40(sp)
    80003eb2:	6161                	addi	sp,sp,80
    80003eb4:	8082                	ret
  return -1;
    80003eb6:	557d                	li	a0,-1
    80003eb8:	bfc5                	j	80003ea8 <filestat+0x60>

0000000080003eba <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003eba:	7179                	addi	sp,sp,-48
    80003ebc:	f406                	sd	ra,40(sp)
    80003ebe:	f022                	sd	s0,32(sp)
    80003ec0:	ec26                	sd	s1,24(sp)
    80003ec2:	e84a                	sd	s2,16(sp)
    80003ec4:	e44e                	sd	s3,8(sp)
    80003ec6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ec8:	00854783          	lbu	a5,8(a0)
    80003ecc:	c3d5                	beqz	a5,80003f70 <fileread+0xb6>
    80003ece:	84aa                	mv	s1,a0
    80003ed0:	89ae                	mv	s3,a1
    80003ed2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ed4:	411c                	lw	a5,0(a0)
    80003ed6:	4705                	li	a4,1
    80003ed8:	04e78963          	beq	a5,a4,80003f2a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003edc:	470d                	li	a4,3
    80003ede:	04e78d63          	beq	a5,a4,80003f38 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ee2:	4709                	li	a4,2
    80003ee4:	06e79e63          	bne	a5,a4,80003f60 <fileread+0xa6>
    ilock(f->ip);
    80003ee8:	6d08                	ld	a0,24(a0)
    80003eea:	fffff097          	auipc	ra,0xfffff
    80003eee:	ff2080e7          	jalr	-14(ra) # 80002edc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ef2:	874a                	mv	a4,s2
    80003ef4:	5094                	lw	a3,32(s1)
    80003ef6:	864e                	mv	a2,s3
    80003ef8:	4585                	li	a1,1
    80003efa:	6c88                	ld	a0,24(s1)
    80003efc:	fffff097          	auipc	ra,0xfffff
    80003f00:	294080e7          	jalr	660(ra) # 80003190 <readi>
    80003f04:	892a                	mv	s2,a0
    80003f06:	00a05563          	blez	a0,80003f10 <fileread+0x56>
      f->off += r;
    80003f0a:	509c                	lw	a5,32(s1)
    80003f0c:	9fa9                	addw	a5,a5,a0
    80003f0e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003f10:	6c88                	ld	a0,24(s1)
    80003f12:	fffff097          	auipc	ra,0xfffff
    80003f16:	08c080e7          	jalr	140(ra) # 80002f9e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003f1a:	854a                	mv	a0,s2
    80003f1c:	70a2                	ld	ra,40(sp)
    80003f1e:	7402                	ld	s0,32(sp)
    80003f20:	64e2                	ld	s1,24(sp)
    80003f22:	6942                	ld	s2,16(sp)
    80003f24:	69a2                	ld	s3,8(sp)
    80003f26:	6145                	addi	sp,sp,48
    80003f28:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003f2a:	6908                	ld	a0,16(a0)
    80003f2c:	00000097          	auipc	ra,0x0
    80003f30:	3c0080e7          	jalr	960(ra) # 800042ec <piperead>
    80003f34:	892a                	mv	s2,a0
    80003f36:	b7d5                	j	80003f1a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003f38:	02451783          	lh	a5,36(a0)
    80003f3c:	03079693          	slli	a3,a5,0x30
    80003f40:	92c1                	srli	a3,a3,0x30
    80003f42:	4725                	li	a4,9
    80003f44:	02d76863          	bltu	a4,a3,80003f74 <fileread+0xba>
    80003f48:	0792                	slli	a5,a5,0x4
    80003f4a:	0001f717          	auipc	a4,0x1f
    80003f4e:	37e70713          	addi	a4,a4,894 # 800232c8 <devsw>
    80003f52:	97ba                	add	a5,a5,a4
    80003f54:	639c                	ld	a5,0(a5)
    80003f56:	c38d                	beqz	a5,80003f78 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003f58:	4505                	li	a0,1
    80003f5a:	9782                	jalr	a5
    80003f5c:	892a                	mv	s2,a0
    80003f5e:	bf75                	j	80003f1a <fileread+0x60>
    panic("fileread");
    80003f60:	00004517          	auipc	a0,0x4
    80003f64:	6e050513          	addi	a0,a0,1760 # 80008640 <syscalls+0x290>
    80003f68:	00002097          	auipc	ra,0x2
    80003f6c:	fe8080e7          	jalr	-24(ra) # 80005f50 <panic>
    return -1;
    80003f70:	597d                	li	s2,-1
    80003f72:	b765                	j	80003f1a <fileread+0x60>
      return -1;
    80003f74:	597d                	li	s2,-1
    80003f76:	b755                	j	80003f1a <fileread+0x60>
    80003f78:	597d                	li	s2,-1
    80003f7a:	b745                	j	80003f1a <fileread+0x60>

0000000080003f7c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003f7c:	715d                	addi	sp,sp,-80
    80003f7e:	e486                	sd	ra,72(sp)
    80003f80:	e0a2                	sd	s0,64(sp)
    80003f82:	fc26                	sd	s1,56(sp)
    80003f84:	f84a                	sd	s2,48(sp)
    80003f86:	f44e                	sd	s3,40(sp)
    80003f88:	f052                	sd	s4,32(sp)
    80003f8a:	ec56                	sd	s5,24(sp)
    80003f8c:	e85a                	sd	s6,16(sp)
    80003f8e:	e45e                	sd	s7,8(sp)
    80003f90:	e062                	sd	s8,0(sp)
    80003f92:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003f94:	00954783          	lbu	a5,9(a0)
    80003f98:	10078663          	beqz	a5,800040a4 <filewrite+0x128>
    80003f9c:	892a                	mv	s2,a0
    80003f9e:	8b2e                	mv	s6,a1
    80003fa0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003fa2:	411c                	lw	a5,0(a0)
    80003fa4:	4705                	li	a4,1
    80003fa6:	02e78263          	beq	a5,a4,80003fca <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003faa:	470d                	li	a4,3
    80003fac:	02e78663          	beq	a5,a4,80003fd8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003fb0:	4709                	li	a4,2
    80003fb2:	0ee79163          	bne	a5,a4,80004094 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003fb6:	0ac05d63          	blez	a2,80004070 <filewrite+0xf4>
    int i = 0;
    80003fba:	4981                	li	s3,0
    80003fbc:	6b85                	lui	s7,0x1
    80003fbe:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003fc2:	6c05                	lui	s8,0x1
    80003fc4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003fc8:	a861                	j	80004060 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003fca:	6908                	ld	a0,16(a0)
    80003fcc:	00000097          	auipc	ra,0x0
    80003fd0:	22e080e7          	jalr	558(ra) # 800041fa <pipewrite>
    80003fd4:	8a2a                	mv	s4,a0
    80003fd6:	a045                	j	80004076 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003fd8:	02451783          	lh	a5,36(a0)
    80003fdc:	03079693          	slli	a3,a5,0x30
    80003fe0:	92c1                	srli	a3,a3,0x30
    80003fe2:	4725                	li	a4,9
    80003fe4:	0cd76263          	bltu	a4,a3,800040a8 <filewrite+0x12c>
    80003fe8:	0792                	slli	a5,a5,0x4
    80003fea:	0001f717          	auipc	a4,0x1f
    80003fee:	2de70713          	addi	a4,a4,734 # 800232c8 <devsw>
    80003ff2:	97ba                	add	a5,a5,a4
    80003ff4:	679c                	ld	a5,8(a5)
    80003ff6:	cbdd                	beqz	a5,800040ac <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ff8:	4505                	li	a0,1
    80003ffa:	9782                	jalr	a5
    80003ffc:	8a2a                	mv	s4,a0
    80003ffe:	a8a5                	j	80004076 <filewrite+0xfa>
    80004000:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004004:	00000097          	auipc	ra,0x0
    80004008:	8b4080e7          	jalr	-1868(ra) # 800038b8 <begin_op>
      ilock(f->ip);
    8000400c:	01893503          	ld	a0,24(s2)
    80004010:	fffff097          	auipc	ra,0xfffff
    80004014:	ecc080e7          	jalr	-308(ra) # 80002edc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004018:	8756                	mv	a4,s5
    8000401a:	02092683          	lw	a3,32(s2)
    8000401e:	01698633          	add	a2,s3,s6
    80004022:	4585                	li	a1,1
    80004024:	01893503          	ld	a0,24(s2)
    80004028:	fffff097          	auipc	ra,0xfffff
    8000402c:	260080e7          	jalr	608(ra) # 80003288 <writei>
    80004030:	84aa                	mv	s1,a0
    80004032:	00a05763          	blez	a0,80004040 <filewrite+0xc4>
        f->off += r;
    80004036:	02092783          	lw	a5,32(s2)
    8000403a:	9fa9                	addw	a5,a5,a0
    8000403c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004040:	01893503          	ld	a0,24(s2)
    80004044:	fffff097          	auipc	ra,0xfffff
    80004048:	f5a080e7          	jalr	-166(ra) # 80002f9e <iunlock>
      end_op();
    8000404c:	00000097          	auipc	ra,0x0
    80004050:	8ea080e7          	jalr	-1814(ra) # 80003936 <end_op>

      if(r != n1){
    80004054:	009a9f63          	bne	s5,s1,80004072 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004058:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000405c:	0149db63          	bge	s3,s4,80004072 <filewrite+0xf6>
      int n1 = n - i;
    80004060:	413a04bb          	subw	s1,s4,s3
    80004064:	0004879b          	sext.w	a5,s1
    80004068:	f8fbdce3          	bge	s7,a5,80004000 <filewrite+0x84>
    8000406c:	84e2                	mv	s1,s8
    8000406e:	bf49                	j	80004000 <filewrite+0x84>
    int i = 0;
    80004070:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004072:	013a1f63          	bne	s4,s3,80004090 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004076:	8552                	mv	a0,s4
    80004078:	60a6                	ld	ra,72(sp)
    8000407a:	6406                	ld	s0,64(sp)
    8000407c:	74e2                	ld	s1,56(sp)
    8000407e:	7942                	ld	s2,48(sp)
    80004080:	79a2                	ld	s3,40(sp)
    80004082:	7a02                	ld	s4,32(sp)
    80004084:	6ae2                	ld	s5,24(sp)
    80004086:	6b42                	ld	s6,16(sp)
    80004088:	6ba2                	ld	s7,8(sp)
    8000408a:	6c02                	ld	s8,0(sp)
    8000408c:	6161                	addi	sp,sp,80
    8000408e:	8082                	ret
    ret = (i == n ? n : -1);
    80004090:	5a7d                	li	s4,-1
    80004092:	b7d5                	j	80004076 <filewrite+0xfa>
    panic("filewrite");
    80004094:	00004517          	auipc	a0,0x4
    80004098:	5bc50513          	addi	a0,a0,1468 # 80008650 <syscalls+0x2a0>
    8000409c:	00002097          	auipc	ra,0x2
    800040a0:	eb4080e7          	jalr	-332(ra) # 80005f50 <panic>
    return -1;
    800040a4:	5a7d                	li	s4,-1
    800040a6:	bfc1                	j	80004076 <filewrite+0xfa>
      return -1;
    800040a8:	5a7d                	li	s4,-1
    800040aa:	b7f1                	j	80004076 <filewrite+0xfa>
    800040ac:	5a7d                	li	s4,-1
    800040ae:	b7e1                	j	80004076 <filewrite+0xfa>

00000000800040b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800040b0:	7179                	addi	sp,sp,-48
    800040b2:	f406                	sd	ra,40(sp)
    800040b4:	f022                	sd	s0,32(sp)
    800040b6:	ec26                	sd	s1,24(sp)
    800040b8:	e84a                	sd	s2,16(sp)
    800040ba:	e44e                	sd	s3,8(sp)
    800040bc:	e052                	sd	s4,0(sp)
    800040be:	1800                	addi	s0,sp,48
    800040c0:	84aa                	mv	s1,a0
    800040c2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800040c4:	0005b023          	sd	zero,0(a1)
    800040c8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800040cc:	00000097          	auipc	ra,0x0
    800040d0:	bf8080e7          	jalr	-1032(ra) # 80003cc4 <filealloc>
    800040d4:	e088                	sd	a0,0(s1)
    800040d6:	c551                	beqz	a0,80004162 <pipealloc+0xb2>
    800040d8:	00000097          	auipc	ra,0x0
    800040dc:	bec080e7          	jalr	-1044(ra) # 80003cc4 <filealloc>
    800040e0:	00aa3023          	sd	a0,0(s4)
    800040e4:	c92d                	beqz	a0,80004156 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800040e6:	ffffc097          	auipc	ra,0xffffc
    800040ea:	034080e7          	jalr	52(ra) # 8000011a <kalloc>
    800040ee:	892a                	mv	s2,a0
    800040f0:	c125                	beqz	a0,80004150 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800040f2:	4985                	li	s3,1
    800040f4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800040f8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800040fc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004100:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004104:	00004597          	auipc	a1,0x4
    80004108:	55c58593          	addi	a1,a1,1372 # 80008660 <syscalls+0x2b0>
    8000410c:	00002097          	auipc	ra,0x2
    80004110:	2ec080e7          	jalr	748(ra) # 800063f8 <initlock>
  (*f0)->type = FD_PIPE;
    80004114:	609c                	ld	a5,0(s1)
    80004116:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000411a:	609c                	ld	a5,0(s1)
    8000411c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004120:	609c                	ld	a5,0(s1)
    80004122:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004126:	609c                	ld	a5,0(s1)
    80004128:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000412c:	000a3783          	ld	a5,0(s4)
    80004130:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004134:	000a3783          	ld	a5,0(s4)
    80004138:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000413c:	000a3783          	ld	a5,0(s4)
    80004140:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004144:	000a3783          	ld	a5,0(s4)
    80004148:	0127b823          	sd	s2,16(a5)
  return 0;
    8000414c:	4501                	li	a0,0
    8000414e:	a025                	j	80004176 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004150:	6088                	ld	a0,0(s1)
    80004152:	e501                	bnez	a0,8000415a <pipealloc+0xaa>
    80004154:	a039                	j	80004162 <pipealloc+0xb2>
    80004156:	6088                	ld	a0,0(s1)
    80004158:	c51d                	beqz	a0,80004186 <pipealloc+0xd6>
    fileclose(*f0);
    8000415a:	00000097          	auipc	ra,0x0
    8000415e:	c26080e7          	jalr	-986(ra) # 80003d80 <fileclose>
  if(*f1)
    80004162:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004166:	557d                	li	a0,-1
  if(*f1)
    80004168:	c799                	beqz	a5,80004176 <pipealloc+0xc6>
    fileclose(*f1);
    8000416a:	853e                	mv	a0,a5
    8000416c:	00000097          	auipc	ra,0x0
    80004170:	c14080e7          	jalr	-1004(ra) # 80003d80 <fileclose>
  return -1;
    80004174:	557d                	li	a0,-1
}
    80004176:	70a2                	ld	ra,40(sp)
    80004178:	7402                	ld	s0,32(sp)
    8000417a:	64e2                	ld	s1,24(sp)
    8000417c:	6942                	ld	s2,16(sp)
    8000417e:	69a2                	ld	s3,8(sp)
    80004180:	6a02                	ld	s4,0(sp)
    80004182:	6145                	addi	sp,sp,48
    80004184:	8082                	ret
  return -1;
    80004186:	557d                	li	a0,-1
    80004188:	b7fd                	j	80004176 <pipealloc+0xc6>

000000008000418a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000418a:	1101                	addi	sp,sp,-32
    8000418c:	ec06                	sd	ra,24(sp)
    8000418e:	e822                	sd	s0,16(sp)
    80004190:	e426                	sd	s1,8(sp)
    80004192:	e04a                	sd	s2,0(sp)
    80004194:	1000                	addi	s0,sp,32
    80004196:	84aa                	mv	s1,a0
    80004198:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000419a:	00002097          	auipc	ra,0x2
    8000419e:	2ee080e7          	jalr	750(ra) # 80006488 <acquire>
  if(writable){
    800041a2:	02090d63          	beqz	s2,800041dc <pipeclose+0x52>
    pi->writeopen = 0;
    800041a6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800041aa:	21848513          	addi	a0,s1,536
    800041ae:	ffffd097          	auipc	ra,0xffffd
    800041b2:	558080e7          	jalr	1368(ra) # 80001706 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800041b6:	2204b783          	ld	a5,544(s1)
    800041ba:	eb95                	bnez	a5,800041ee <pipeclose+0x64>
    release(&pi->lock);
    800041bc:	8526                	mv	a0,s1
    800041be:	00002097          	auipc	ra,0x2
    800041c2:	37e080e7          	jalr	894(ra) # 8000653c <release>
    kfree((char*)pi);
    800041c6:	8526                	mv	a0,s1
    800041c8:	ffffc097          	auipc	ra,0xffffc
    800041cc:	e54080e7          	jalr	-428(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800041d0:	60e2                	ld	ra,24(sp)
    800041d2:	6442                	ld	s0,16(sp)
    800041d4:	64a2                	ld	s1,8(sp)
    800041d6:	6902                	ld	s2,0(sp)
    800041d8:	6105                	addi	sp,sp,32
    800041da:	8082                	ret
    pi->readopen = 0;
    800041dc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800041e0:	21c48513          	addi	a0,s1,540
    800041e4:	ffffd097          	auipc	ra,0xffffd
    800041e8:	522080e7          	jalr	1314(ra) # 80001706 <wakeup>
    800041ec:	b7e9                	j	800041b6 <pipeclose+0x2c>
    release(&pi->lock);
    800041ee:	8526                	mv	a0,s1
    800041f0:	00002097          	auipc	ra,0x2
    800041f4:	34c080e7          	jalr	844(ra) # 8000653c <release>
}
    800041f8:	bfe1                	j	800041d0 <pipeclose+0x46>

00000000800041fa <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800041fa:	711d                	addi	sp,sp,-96
    800041fc:	ec86                	sd	ra,88(sp)
    800041fe:	e8a2                	sd	s0,80(sp)
    80004200:	e4a6                	sd	s1,72(sp)
    80004202:	e0ca                	sd	s2,64(sp)
    80004204:	fc4e                	sd	s3,56(sp)
    80004206:	f852                	sd	s4,48(sp)
    80004208:	f456                	sd	s5,40(sp)
    8000420a:	f05a                	sd	s6,32(sp)
    8000420c:	ec5e                	sd	s7,24(sp)
    8000420e:	e862                	sd	s8,16(sp)
    80004210:	1080                	addi	s0,sp,96
    80004212:	84aa                	mv	s1,a0
    80004214:	8aae                	mv	s5,a1
    80004216:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	c54080e7          	jalr	-940(ra) # 80000e6c <myproc>
    80004220:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004222:	8526                	mv	a0,s1
    80004224:	00002097          	auipc	ra,0x2
    80004228:	264080e7          	jalr	612(ra) # 80006488 <acquire>
  while(i < n){
    8000422c:	0b405363          	blez	s4,800042d2 <pipewrite+0xd8>
  int i = 0;
    80004230:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004232:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004234:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004238:	21c48b93          	addi	s7,s1,540
    8000423c:	a089                	j	8000427e <pipewrite+0x84>
      release(&pi->lock);
    8000423e:	8526                	mv	a0,s1
    80004240:	00002097          	auipc	ra,0x2
    80004244:	2fc080e7          	jalr	764(ra) # 8000653c <release>
      return -1;
    80004248:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000424a:	854a                	mv	a0,s2
    8000424c:	60e6                	ld	ra,88(sp)
    8000424e:	6446                	ld	s0,80(sp)
    80004250:	64a6                	ld	s1,72(sp)
    80004252:	6906                	ld	s2,64(sp)
    80004254:	79e2                	ld	s3,56(sp)
    80004256:	7a42                	ld	s4,48(sp)
    80004258:	7aa2                	ld	s5,40(sp)
    8000425a:	7b02                	ld	s6,32(sp)
    8000425c:	6be2                	ld	s7,24(sp)
    8000425e:	6c42                	ld	s8,16(sp)
    80004260:	6125                	addi	sp,sp,96
    80004262:	8082                	ret
      wakeup(&pi->nread);
    80004264:	8562                	mv	a0,s8
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	4a0080e7          	jalr	1184(ra) # 80001706 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000426e:	85a6                	mv	a1,s1
    80004270:	855e                	mv	a0,s7
    80004272:	ffffd097          	auipc	ra,0xffffd
    80004276:	308080e7          	jalr	776(ra) # 8000157a <sleep>
  while(i < n){
    8000427a:	05495d63          	bge	s2,s4,800042d4 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    8000427e:	2204a783          	lw	a5,544(s1)
    80004282:	dfd5                	beqz	a5,8000423e <pipewrite+0x44>
    80004284:	0289a783          	lw	a5,40(s3)
    80004288:	fbdd                	bnez	a5,8000423e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000428a:	2184a783          	lw	a5,536(s1)
    8000428e:	21c4a703          	lw	a4,540(s1)
    80004292:	2007879b          	addiw	a5,a5,512
    80004296:	fcf707e3          	beq	a4,a5,80004264 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000429a:	4685                	li	a3,1
    8000429c:	01590633          	add	a2,s2,s5
    800042a0:	faf40593          	addi	a1,s0,-81
    800042a4:	0509b503          	ld	a0,80(s3)
    800042a8:	ffffd097          	auipc	ra,0xffffd
    800042ac:	8de080e7          	jalr	-1826(ra) # 80000b86 <copyin>
    800042b0:	03650263          	beq	a0,s6,800042d4 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800042b4:	21c4a783          	lw	a5,540(s1)
    800042b8:	0017871b          	addiw	a4,a5,1
    800042bc:	20e4ae23          	sw	a4,540(s1)
    800042c0:	1ff7f793          	andi	a5,a5,511
    800042c4:	97a6                	add	a5,a5,s1
    800042c6:	faf44703          	lbu	a4,-81(s0)
    800042ca:	00e78c23          	sb	a4,24(a5)
      i++;
    800042ce:	2905                	addiw	s2,s2,1
    800042d0:	b76d                	j	8000427a <pipewrite+0x80>
  int i = 0;
    800042d2:	4901                	li	s2,0
  wakeup(&pi->nread);
    800042d4:	21848513          	addi	a0,s1,536
    800042d8:	ffffd097          	auipc	ra,0xffffd
    800042dc:	42e080e7          	jalr	1070(ra) # 80001706 <wakeup>
  release(&pi->lock);
    800042e0:	8526                	mv	a0,s1
    800042e2:	00002097          	auipc	ra,0x2
    800042e6:	25a080e7          	jalr	602(ra) # 8000653c <release>
  return i;
    800042ea:	b785                	j	8000424a <pipewrite+0x50>

00000000800042ec <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800042ec:	715d                	addi	sp,sp,-80
    800042ee:	e486                	sd	ra,72(sp)
    800042f0:	e0a2                	sd	s0,64(sp)
    800042f2:	fc26                	sd	s1,56(sp)
    800042f4:	f84a                	sd	s2,48(sp)
    800042f6:	f44e                	sd	s3,40(sp)
    800042f8:	f052                	sd	s4,32(sp)
    800042fa:	ec56                	sd	s5,24(sp)
    800042fc:	e85a                	sd	s6,16(sp)
    800042fe:	0880                	addi	s0,sp,80
    80004300:	84aa                	mv	s1,a0
    80004302:	892e                	mv	s2,a1
    80004304:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	b66080e7          	jalr	-1178(ra) # 80000e6c <myproc>
    8000430e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004310:	8526                	mv	a0,s1
    80004312:	00002097          	auipc	ra,0x2
    80004316:	176080e7          	jalr	374(ra) # 80006488 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000431a:	2184a703          	lw	a4,536(s1)
    8000431e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004322:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004326:	02f71463          	bne	a4,a5,8000434e <piperead+0x62>
    8000432a:	2244a783          	lw	a5,548(s1)
    8000432e:	c385                	beqz	a5,8000434e <piperead+0x62>
    if(pr->killed){
    80004330:	028a2783          	lw	a5,40(s4)
    80004334:	ebc9                	bnez	a5,800043c6 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004336:	85a6                	mv	a1,s1
    80004338:	854e                	mv	a0,s3
    8000433a:	ffffd097          	auipc	ra,0xffffd
    8000433e:	240080e7          	jalr	576(ra) # 8000157a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004342:	2184a703          	lw	a4,536(s1)
    80004346:	21c4a783          	lw	a5,540(s1)
    8000434a:	fef700e3          	beq	a4,a5,8000432a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000434e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004350:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004352:	05505463          	blez	s5,8000439a <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004356:	2184a783          	lw	a5,536(s1)
    8000435a:	21c4a703          	lw	a4,540(s1)
    8000435e:	02f70e63          	beq	a4,a5,8000439a <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004362:	0017871b          	addiw	a4,a5,1
    80004366:	20e4ac23          	sw	a4,536(s1)
    8000436a:	1ff7f793          	andi	a5,a5,511
    8000436e:	97a6                	add	a5,a5,s1
    80004370:	0187c783          	lbu	a5,24(a5)
    80004374:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004378:	4685                	li	a3,1
    8000437a:	fbf40613          	addi	a2,s0,-65
    8000437e:	85ca                	mv	a1,s2
    80004380:	050a3503          	ld	a0,80(s4)
    80004384:	ffffc097          	auipc	ra,0xffffc
    80004388:	776080e7          	jalr	1910(ra) # 80000afa <copyout>
    8000438c:	01650763          	beq	a0,s6,8000439a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004390:	2985                	addiw	s3,s3,1
    80004392:	0905                	addi	s2,s2,1
    80004394:	fd3a91e3          	bne	s5,s3,80004356 <piperead+0x6a>
    80004398:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000439a:	21c48513          	addi	a0,s1,540
    8000439e:	ffffd097          	auipc	ra,0xffffd
    800043a2:	368080e7          	jalr	872(ra) # 80001706 <wakeup>
  release(&pi->lock);
    800043a6:	8526                	mv	a0,s1
    800043a8:	00002097          	auipc	ra,0x2
    800043ac:	194080e7          	jalr	404(ra) # 8000653c <release>
  return i;
}
    800043b0:	854e                	mv	a0,s3
    800043b2:	60a6                	ld	ra,72(sp)
    800043b4:	6406                	ld	s0,64(sp)
    800043b6:	74e2                	ld	s1,56(sp)
    800043b8:	7942                	ld	s2,48(sp)
    800043ba:	79a2                	ld	s3,40(sp)
    800043bc:	7a02                	ld	s4,32(sp)
    800043be:	6ae2                	ld	s5,24(sp)
    800043c0:	6b42                	ld	s6,16(sp)
    800043c2:	6161                	addi	sp,sp,80
    800043c4:	8082                	ret
      release(&pi->lock);
    800043c6:	8526                	mv	a0,s1
    800043c8:	00002097          	auipc	ra,0x2
    800043cc:	174080e7          	jalr	372(ra) # 8000653c <release>
      return -1;
    800043d0:	59fd                	li	s3,-1
    800043d2:	bff9                	j	800043b0 <piperead+0xc4>

00000000800043d4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800043d4:	de010113          	addi	sp,sp,-544
    800043d8:	20113c23          	sd	ra,536(sp)
    800043dc:	20813823          	sd	s0,528(sp)
    800043e0:	20913423          	sd	s1,520(sp)
    800043e4:	21213023          	sd	s2,512(sp)
    800043e8:	ffce                	sd	s3,504(sp)
    800043ea:	fbd2                	sd	s4,496(sp)
    800043ec:	f7d6                	sd	s5,488(sp)
    800043ee:	f3da                	sd	s6,480(sp)
    800043f0:	efde                	sd	s7,472(sp)
    800043f2:	ebe2                	sd	s8,464(sp)
    800043f4:	e7e6                	sd	s9,456(sp)
    800043f6:	e3ea                	sd	s10,448(sp)
    800043f8:	ff6e                	sd	s11,440(sp)
    800043fa:	1400                	addi	s0,sp,544
    800043fc:	892a                	mv	s2,a0
    800043fe:	dea43423          	sd	a0,-536(s0)
    80004402:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004406:	ffffd097          	auipc	ra,0xffffd
    8000440a:	a66080e7          	jalr	-1434(ra) # 80000e6c <myproc>
    8000440e:	84aa                	mv	s1,a0

  begin_op();
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	4a8080e7          	jalr	1192(ra) # 800038b8 <begin_op>

  if((ip = namei(path)) == 0){
    80004418:	854a                	mv	a0,s2
    8000441a:	fffff097          	auipc	ra,0xfffff
    8000441e:	27e080e7          	jalr	638(ra) # 80003698 <namei>
    80004422:	c93d                	beqz	a0,80004498 <exec+0xc4>
    80004424:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004426:	fffff097          	auipc	ra,0xfffff
    8000442a:	ab6080e7          	jalr	-1354(ra) # 80002edc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000442e:	04000713          	li	a4,64
    80004432:	4681                	li	a3,0
    80004434:	e5040613          	addi	a2,s0,-432
    80004438:	4581                	li	a1,0
    8000443a:	8556                	mv	a0,s5
    8000443c:	fffff097          	auipc	ra,0xfffff
    80004440:	d54080e7          	jalr	-684(ra) # 80003190 <readi>
    80004444:	04000793          	li	a5,64
    80004448:	00f51a63          	bne	a0,a5,8000445c <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000444c:	e5042703          	lw	a4,-432(s0)
    80004450:	464c47b7          	lui	a5,0x464c4
    80004454:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004458:	04f70663          	beq	a4,a5,800044a4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000445c:	8556                	mv	a0,s5
    8000445e:	fffff097          	auipc	ra,0xfffff
    80004462:	ce0080e7          	jalr	-800(ra) # 8000313e <iunlockput>
    end_op();
    80004466:	fffff097          	auipc	ra,0xfffff
    8000446a:	4d0080e7          	jalr	1232(ra) # 80003936 <end_op>
  }
  return -1;
    8000446e:	557d                	li	a0,-1
}
    80004470:	21813083          	ld	ra,536(sp)
    80004474:	21013403          	ld	s0,528(sp)
    80004478:	20813483          	ld	s1,520(sp)
    8000447c:	20013903          	ld	s2,512(sp)
    80004480:	79fe                	ld	s3,504(sp)
    80004482:	7a5e                	ld	s4,496(sp)
    80004484:	7abe                	ld	s5,488(sp)
    80004486:	7b1e                	ld	s6,480(sp)
    80004488:	6bfe                	ld	s7,472(sp)
    8000448a:	6c5e                	ld	s8,464(sp)
    8000448c:	6cbe                	ld	s9,456(sp)
    8000448e:	6d1e                	ld	s10,448(sp)
    80004490:	7dfa                	ld	s11,440(sp)
    80004492:	22010113          	addi	sp,sp,544
    80004496:	8082                	ret
    end_op();
    80004498:	fffff097          	auipc	ra,0xfffff
    8000449c:	49e080e7          	jalr	1182(ra) # 80003936 <end_op>
    return -1;
    800044a0:	557d                	li	a0,-1
    800044a2:	b7f9                	j	80004470 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800044a4:	8526                	mv	a0,s1
    800044a6:	ffffd097          	auipc	ra,0xffffd
    800044aa:	a8a080e7          	jalr	-1398(ra) # 80000f30 <proc_pagetable>
    800044ae:	8b2a                	mv	s6,a0
    800044b0:	d555                	beqz	a0,8000445c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044b2:	e7042783          	lw	a5,-400(s0)
    800044b6:	e8845703          	lhu	a4,-376(s0)
    800044ba:	c735                	beqz	a4,80004526 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044bc:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044be:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800044c2:	6a05                	lui	s4,0x1
    800044c4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800044c8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800044cc:	6d85                	lui	s11,0x1
    800044ce:	7d7d                	lui	s10,0xfffff
    800044d0:	ac1d                	j	80004706 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800044d2:	00004517          	auipc	a0,0x4
    800044d6:	19650513          	addi	a0,a0,406 # 80008668 <syscalls+0x2b8>
    800044da:	00002097          	auipc	ra,0x2
    800044de:	a76080e7          	jalr	-1418(ra) # 80005f50 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800044e2:	874a                	mv	a4,s2
    800044e4:	009c86bb          	addw	a3,s9,s1
    800044e8:	4581                	li	a1,0
    800044ea:	8556                	mv	a0,s5
    800044ec:	fffff097          	auipc	ra,0xfffff
    800044f0:	ca4080e7          	jalr	-860(ra) # 80003190 <readi>
    800044f4:	2501                	sext.w	a0,a0
    800044f6:	1aa91863          	bne	s2,a0,800046a6 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800044fa:	009d84bb          	addw	s1,s11,s1
    800044fe:	013d09bb          	addw	s3,s10,s3
    80004502:	1f74f263          	bgeu	s1,s7,800046e6 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004506:	02049593          	slli	a1,s1,0x20
    8000450a:	9181                	srli	a1,a1,0x20
    8000450c:	95e2                	add	a1,a1,s8
    8000450e:	855a                	mv	a0,s6
    80004510:	ffffc097          	auipc	ra,0xffffc
    80004514:	ff0080e7          	jalr	-16(ra) # 80000500 <walkaddr>
    80004518:	862a                	mv	a2,a0
    if(pa == 0)
    8000451a:	dd45                	beqz	a0,800044d2 <exec+0xfe>
      n = PGSIZE;
    8000451c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000451e:	fd49f2e3          	bgeu	s3,s4,800044e2 <exec+0x10e>
      n = sz - i;
    80004522:	894e                	mv	s2,s3
    80004524:	bf7d                	j	800044e2 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004526:	4481                	li	s1,0
  iunlockput(ip);
    80004528:	8556                	mv	a0,s5
    8000452a:	fffff097          	auipc	ra,0xfffff
    8000452e:	c14080e7          	jalr	-1004(ra) # 8000313e <iunlockput>
  end_op();
    80004532:	fffff097          	auipc	ra,0xfffff
    80004536:	404080e7          	jalr	1028(ra) # 80003936 <end_op>
  p = myproc();
    8000453a:	ffffd097          	auipc	ra,0xffffd
    8000453e:	932080e7          	jalr	-1742(ra) # 80000e6c <myproc>
    80004542:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004544:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004548:	6785                	lui	a5,0x1
    8000454a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000454c:	97a6                	add	a5,a5,s1
    8000454e:	777d                	lui	a4,0xfffff
    80004550:	8ff9                	and	a5,a5,a4
    80004552:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004556:	6609                	lui	a2,0x2
    80004558:	963e                	add	a2,a2,a5
    8000455a:	85be                	mv	a1,a5
    8000455c:	855a                	mv	a0,s6
    8000455e:	ffffc097          	auipc	ra,0xffffc
    80004562:	348080e7          	jalr	840(ra) # 800008a6 <uvmalloc>
    80004566:	8c2a                	mv	s8,a0
  ip = 0;
    80004568:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000456a:	12050e63          	beqz	a0,800046a6 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000456e:	75f9                	lui	a1,0xffffe
    80004570:	95aa                	add	a1,a1,a0
    80004572:	855a                	mv	a0,s6
    80004574:	ffffc097          	auipc	ra,0xffffc
    80004578:	554080e7          	jalr	1364(ra) # 80000ac8 <uvmclear>
  stackbase = sp - PGSIZE;
    8000457c:	7afd                	lui	s5,0xfffff
    8000457e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004580:	df043783          	ld	a5,-528(s0)
    80004584:	6388                	ld	a0,0(a5)
    80004586:	c925                	beqz	a0,800045f6 <exec+0x222>
    80004588:	e9040993          	addi	s3,s0,-368
    8000458c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004590:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004592:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004594:	ffffc097          	auipc	ra,0xffffc
    80004598:	d62080e7          	jalr	-670(ra) # 800002f6 <strlen>
    8000459c:	0015079b          	addiw	a5,a0,1
    800045a0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800045a4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800045a8:	13596363          	bltu	s2,s5,800046ce <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800045ac:	df043d83          	ld	s11,-528(s0)
    800045b0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800045b4:	8552                	mv	a0,s4
    800045b6:	ffffc097          	auipc	ra,0xffffc
    800045ba:	d40080e7          	jalr	-704(ra) # 800002f6 <strlen>
    800045be:	0015069b          	addiw	a3,a0,1
    800045c2:	8652                	mv	a2,s4
    800045c4:	85ca                	mv	a1,s2
    800045c6:	855a                	mv	a0,s6
    800045c8:	ffffc097          	auipc	ra,0xffffc
    800045cc:	532080e7          	jalr	1330(ra) # 80000afa <copyout>
    800045d0:	10054363          	bltz	a0,800046d6 <exec+0x302>
    ustack[argc] = sp;
    800045d4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800045d8:	0485                	addi	s1,s1,1
    800045da:	008d8793          	addi	a5,s11,8
    800045de:	def43823          	sd	a5,-528(s0)
    800045e2:	008db503          	ld	a0,8(s11)
    800045e6:	c911                	beqz	a0,800045fa <exec+0x226>
    if(argc >= MAXARG)
    800045e8:	09a1                	addi	s3,s3,8
    800045ea:	fb3c95e3          	bne	s9,s3,80004594 <exec+0x1c0>
  sz = sz1;
    800045ee:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045f2:	4a81                	li	s5,0
    800045f4:	a84d                	j	800046a6 <exec+0x2d2>
  sp = sz;
    800045f6:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800045f8:	4481                	li	s1,0
  ustack[argc] = 0;
    800045fa:	00349793          	slli	a5,s1,0x3
    800045fe:	f9078793          	addi	a5,a5,-112
    80004602:	97a2                	add	a5,a5,s0
    80004604:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004608:	00148693          	addi	a3,s1,1
    8000460c:	068e                	slli	a3,a3,0x3
    8000460e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004612:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004616:	01597663          	bgeu	s2,s5,80004622 <exec+0x24e>
  sz = sz1;
    8000461a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000461e:	4a81                	li	s5,0
    80004620:	a059                	j	800046a6 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004622:	e9040613          	addi	a2,s0,-368
    80004626:	85ca                	mv	a1,s2
    80004628:	855a                	mv	a0,s6
    8000462a:	ffffc097          	auipc	ra,0xffffc
    8000462e:	4d0080e7          	jalr	1232(ra) # 80000afa <copyout>
    80004632:	0a054663          	bltz	a0,800046de <exec+0x30a>
  p->trapframe->a1 = sp;
    80004636:	058bb783          	ld	a5,88(s7)
    8000463a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000463e:	de843783          	ld	a5,-536(s0)
    80004642:	0007c703          	lbu	a4,0(a5)
    80004646:	cf11                	beqz	a4,80004662 <exec+0x28e>
    80004648:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000464a:	02f00693          	li	a3,47
    8000464e:	a039                	j	8000465c <exec+0x288>
      last = s+1;
    80004650:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004654:	0785                	addi	a5,a5,1
    80004656:	fff7c703          	lbu	a4,-1(a5)
    8000465a:	c701                	beqz	a4,80004662 <exec+0x28e>
    if(*s == '/')
    8000465c:	fed71ce3          	bne	a4,a3,80004654 <exec+0x280>
    80004660:	bfc5                	j	80004650 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004662:	4641                	li	a2,16
    80004664:	de843583          	ld	a1,-536(s0)
    80004668:	158b8513          	addi	a0,s7,344
    8000466c:	ffffc097          	auipc	ra,0xffffc
    80004670:	c58080e7          	jalr	-936(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004674:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004678:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000467c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004680:	058bb783          	ld	a5,88(s7)
    80004684:	e6843703          	ld	a4,-408(s0)
    80004688:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000468a:	058bb783          	ld	a5,88(s7)
    8000468e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004692:	85ea                	mv	a1,s10
    80004694:	ffffd097          	auipc	ra,0xffffd
    80004698:	938080e7          	jalr	-1736(ra) # 80000fcc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000469c:	0004851b          	sext.w	a0,s1
    800046a0:	bbc1                	j	80004470 <exec+0x9c>
    800046a2:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800046a6:	df843583          	ld	a1,-520(s0)
    800046aa:	855a                	mv	a0,s6
    800046ac:	ffffd097          	auipc	ra,0xffffd
    800046b0:	920080e7          	jalr	-1760(ra) # 80000fcc <proc_freepagetable>
  if(ip){
    800046b4:	da0a94e3          	bnez	s5,8000445c <exec+0x88>
  return -1;
    800046b8:	557d                	li	a0,-1
    800046ba:	bb5d                	j	80004470 <exec+0x9c>
    800046bc:	de943c23          	sd	s1,-520(s0)
    800046c0:	b7dd                	j	800046a6 <exec+0x2d2>
    800046c2:	de943c23          	sd	s1,-520(s0)
    800046c6:	b7c5                	j	800046a6 <exec+0x2d2>
    800046c8:	de943c23          	sd	s1,-520(s0)
    800046cc:	bfe9                	j	800046a6 <exec+0x2d2>
  sz = sz1;
    800046ce:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800046d2:	4a81                	li	s5,0
    800046d4:	bfc9                	j	800046a6 <exec+0x2d2>
  sz = sz1;
    800046d6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800046da:	4a81                	li	s5,0
    800046dc:	b7e9                	j	800046a6 <exec+0x2d2>
  sz = sz1;
    800046de:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800046e2:	4a81                	li	s5,0
    800046e4:	b7c9                	j	800046a6 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800046e6:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800046ea:	e0843783          	ld	a5,-504(s0)
    800046ee:	0017869b          	addiw	a3,a5,1
    800046f2:	e0d43423          	sd	a3,-504(s0)
    800046f6:	e0043783          	ld	a5,-512(s0)
    800046fa:	0387879b          	addiw	a5,a5,56
    800046fe:	e8845703          	lhu	a4,-376(s0)
    80004702:	e2e6d3e3          	bge	a3,a4,80004528 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004706:	2781                	sext.w	a5,a5
    80004708:	e0f43023          	sd	a5,-512(s0)
    8000470c:	03800713          	li	a4,56
    80004710:	86be                	mv	a3,a5
    80004712:	e1840613          	addi	a2,s0,-488
    80004716:	4581                	li	a1,0
    80004718:	8556                	mv	a0,s5
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	a76080e7          	jalr	-1418(ra) # 80003190 <readi>
    80004722:	03800793          	li	a5,56
    80004726:	f6f51ee3          	bne	a0,a5,800046a2 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000472a:	e1842783          	lw	a5,-488(s0)
    8000472e:	4705                	li	a4,1
    80004730:	fae79de3          	bne	a5,a4,800046ea <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004734:	e4043603          	ld	a2,-448(s0)
    80004738:	e3843783          	ld	a5,-456(s0)
    8000473c:	f8f660e3          	bltu	a2,a5,800046bc <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004740:	e2843783          	ld	a5,-472(s0)
    80004744:	963e                	add	a2,a2,a5
    80004746:	f6f66ee3          	bltu	a2,a5,800046c2 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000474a:	85a6                	mv	a1,s1
    8000474c:	855a                	mv	a0,s6
    8000474e:	ffffc097          	auipc	ra,0xffffc
    80004752:	158080e7          	jalr	344(ra) # 800008a6 <uvmalloc>
    80004756:	dea43c23          	sd	a0,-520(s0)
    8000475a:	d53d                	beqz	a0,800046c8 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000475c:	e2843c03          	ld	s8,-472(s0)
    80004760:	de043783          	ld	a5,-544(s0)
    80004764:	00fc77b3          	and	a5,s8,a5
    80004768:	ff9d                	bnez	a5,800046a6 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000476a:	e2042c83          	lw	s9,-480(s0)
    8000476e:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004772:	f60b8ae3          	beqz	s7,800046e6 <exec+0x312>
    80004776:	89de                	mv	s3,s7
    80004778:	4481                	li	s1,0
    8000477a:	b371                	j	80004506 <exec+0x132>

000000008000477c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000477c:	7179                	addi	sp,sp,-48
    8000477e:	f406                	sd	ra,40(sp)
    80004780:	f022                	sd	s0,32(sp)
    80004782:	ec26                	sd	s1,24(sp)
    80004784:	e84a                	sd	s2,16(sp)
    80004786:	1800                	addi	s0,sp,48
    80004788:	892e                	mv	s2,a1
    8000478a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000478c:	fdc40593          	addi	a1,s0,-36
    80004790:	ffffe097          	auipc	ra,0xffffe
    80004794:	956080e7          	jalr	-1706(ra) # 800020e6 <argint>
    80004798:	04054063          	bltz	a0,800047d8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000479c:	fdc42703          	lw	a4,-36(s0)
    800047a0:	47bd                	li	a5,15
    800047a2:	02e7ed63          	bltu	a5,a4,800047dc <argfd+0x60>
    800047a6:	ffffc097          	auipc	ra,0xffffc
    800047aa:	6c6080e7          	jalr	1734(ra) # 80000e6c <myproc>
    800047ae:	fdc42703          	lw	a4,-36(s0)
    800047b2:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffcedda>
    800047b6:	078e                	slli	a5,a5,0x3
    800047b8:	953e                	add	a0,a0,a5
    800047ba:	611c                	ld	a5,0(a0)
    800047bc:	c395                	beqz	a5,800047e0 <argfd+0x64>
    return -1;
  if(pfd)
    800047be:	00090463          	beqz	s2,800047c6 <argfd+0x4a>
    *pfd = fd;
    800047c2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047c6:	4501                	li	a0,0
  if(pf)
    800047c8:	c091                	beqz	s1,800047cc <argfd+0x50>
    *pf = f;
    800047ca:	e09c                	sd	a5,0(s1)
}
    800047cc:	70a2                	ld	ra,40(sp)
    800047ce:	7402                	ld	s0,32(sp)
    800047d0:	64e2                	ld	s1,24(sp)
    800047d2:	6942                	ld	s2,16(sp)
    800047d4:	6145                	addi	sp,sp,48
    800047d6:	8082                	ret
    return -1;
    800047d8:	557d                	li	a0,-1
    800047da:	bfcd                	j	800047cc <argfd+0x50>
    return -1;
    800047dc:	557d                	li	a0,-1
    800047de:	b7fd                	j	800047cc <argfd+0x50>
    800047e0:	557d                	li	a0,-1
    800047e2:	b7ed                	j	800047cc <argfd+0x50>

00000000800047e4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800047e4:	1101                	addi	sp,sp,-32
    800047e6:	ec06                	sd	ra,24(sp)
    800047e8:	e822                	sd	s0,16(sp)
    800047ea:	e426                	sd	s1,8(sp)
    800047ec:	1000                	addi	s0,sp,32
    800047ee:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800047f0:	ffffc097          	auipc	ra,0xffffc
    800047f4:	67c080e7          	jalr	1660(ra) # 80000e6c <myproc>
    800047f8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800047fa:	0d050793          	addi	a5,a0,208
    800047fe:	4501                	li	a0,0
    80004800:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004802:	6398                	ld	a4,0(a5)
    80004804:	cb19                	beqz	a4,8000481a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004806:	2505                	addiw	a0,a0,1
    80004808:	07a1                	addi	a5,a5,8
    8000480a:	fed51ce3          	bne	a0,a3,80004802 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000480e:	557d                	li	a0,-1
}
    80004810:	60e2                	ld	ra,24(sp)
    80004812:	6442                	ld	s0,16(sp)
    80004814:	64a2                	ld	s1,8(sp)
    80004816:	6105                	addi	sp,sp,32
    80004818:	8082                	ret
      p->ofile[fd] = f;
    8000481a:	01a50793          	addi	a5,a0,26
    8000481e:	078e                	slli	a5,a5,0x3
    80004820:	963e                	add	a2,a2,a5
    80004822:	e204                	sd	s1,0(a2)
      return fd;
    80004824:	b7f5                	j	80004810 <fdalloc+0x2c>

0000000080004826 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004826:	715d                	addi	sp,sp,-80
    80004828:	e486                	sd	ra,72(sp)
    8000482a:	e0a2                	sd	s0,64(sp)
    8000482c:	fc26                	sd	s1,56(sp)
    8000482e:	f84a                	sd	s2,48(sp)
    80004830:	f44e                	sd	s3,40(sp)
    80004832:	f052                	sd	s4,32(sp)
    80004834:	ec56                	sd	s5,24(sp)
    80004836:	0880                	addi	s0,sp,80
    80004838:	89ae                	mv	s3,a1
    8000483a:	8ab2                	mv	s5,a2
    8000483c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000483e:	fb040593          	addi	a1,s0,-80
    80004842:	fffff097          	auipc	ra,0xfffff
    80004846:	e74080e7          	jalr	-396(ra) # 800036b6 <nameiparent>
    8000484a:	892a                	mv	s2,a0
    8000484c:	12050e63          	beqz	a0,80004988 <create+0x162>
    return 0;

  ilock(dp);
    80004850:	ffffe097          	auipc	ra,0xffffe
    80004854:	68c080e7          	jalr	1676(ra) # 80002edc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004858:	4601                	li	a2,0
    8000485a:	fb040593          	addi	a1,s0,-80
    8000485e:	854a                	mv	a0,s2
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	b60080e7          	jalr	-1184(ra) # 800033c0 <dirlookup>
    80004868:	84aa                	mv	s1,a0
    8000486a:	c921                	beqz	a0,800048ba <create+0x94>
    iunlockput(dp);
    8000486c:	854a                	mv	a0,s2
    8000486e:	fffff097          	auipc	ra,0xfffff
    80004872:	8d0080e7          	jalr	-1840(ra) # 8000313e <iunlockput>
    ilock(ip);
    80004876:	8526                	mv	a0,s1
    80004878:	ffffe097          	auipc	ra,0xffffe
    8000487c:	664080e7          	jalr	1636(ra) # 80002edc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004880:	2981                	sext.w	s3,s3
    80004882:	4789                	li	a5,2
    80004884:	02f99463          	bne	s3,a5,800048ac <create+0x86>
    80004888:	0444d783          	lhu	a5,68(s1)
    8000488c:	37f9                	addiw	a5,a5,-2
    8000488e:	17c2                	slli	a5,a5,0x30
    80004890:	93c1                	srli	a5,a5,0x30
    80004892:	4705                	li	a4,1
    80004894:	00f76c63          	bltu	a4,a5,800048ac <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004898:	8526                	mv	a0,s1
    8000489a:	60a6                	ld	ra,72(sp)
    8000489c:	6406                	ld	s0,64(sp)
    8000489e:	74e2                	ld	s1,56(sp)
    800048a0:	7942                	ld	s2,48(sp)
    800048a2:	79a2                	ld	s3,40(sp)
    800048a4:	7a02                	ld	s4,32(sp)
    800048a6:	6ae2                	ld	s5,24(sp)
    800048a8:	6161                	addi	sp,sp,80
    800048aa:	8082                	ret
    iunlockput(ip);
    800048ac:	8526                	mv	a0,s1
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	890080e7          	jalr	-1904(ra) # 8000313e <iunlockput>
    return 0;
    800048b6:	4481                	li	s1,0
    800048b8:	b7c5                	j	80004898 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800048ba:	85ce                	mv	a1,s3
    800048bc:	00092503          	lw	a0,0(s2)
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	482080e7          	jalr	1154(ra) # 80002d42 <ialloc>
    800048c8:	84aa                	mv	s1,a0
    800048ca:	c521                	beqz	a0,80004912 <create+0xec>
  ilock(ip);
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	610080e7          	jalr	1552(ra) # 80002edc <ilock>
  ip->major = major;
    800048d4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800048d8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800048dc:	4a05                	li	s4,1
    800048de:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800048e2:	8526                	mv	a0,s1
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	52c080e7          	jalr	1324(ra) # 80002e10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800048ec:	2981                	sext.w	s3,s3
    800048ee:	03498a63          	beq	s3,s4,80004922 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800048f2:	40d0                	lw	a2,4(s1)
    800048f4:	fb040593          	addi	a1,s0,-80
    800048f8:	854a                	mv	a0,s2
    800048fa:	fffff097          	auipc	ra,0xfffff
    800048fe:	cdc080e7          	jalr	-804(ra) # 800035d6 <dirlink>
    80004902:	06054b63          	bltz	a0,80004978 <create+0x152>
  iunlockput(dp);
    80004906:	854a                	mv	a0,s2
    80004908:	fffff097          	auipc	ra,0xfffff
    8000490c:	836080e7          	jalr	-1994(ra) # 8000313e <iunlockput>
  return ip;
    80004910:	b761                	j	80004898 <create+0x72>
    panic("create: ialloc");
    80004912:	00004517          	auipc	a0,0x4
    80004916:	d7650513          	addi	a0,a0,-650 # 80008688 <syscalls+0x2d8>
    8000491a:	00001097          	auipc	ra,0x1
    8000491e:	636080e7          	jalr	1590(ra) # 80005f50 <panic>
    dp->nlink++;  // for ".."
    80004922:	04a95783          	lhu	a5,74(s2)
    80004926:	2785                	addiw	a5,a5,1
    80004928:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000492c:	854a                	mv	a0,s2
    8000492e:	ffffe097          	auipc	ra,0xffffe
    80004932:	4e2080e7          	jalr	1250(ra) # 80002e10 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004936:	40d0                	lw	a2,4(s1)
    80004938:	00004597          	auipc	a1,0x4
    8000493c:	d6058593          	addi	a1,a1,-672 # 80008698 <syscalls+0x2e8>
    80004940:	8526                	mv	a0,s1
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	c94080e7          	jalr	-876(ra) # 800035d6 <dirlink>
    8000494a:	00054f63          	bltz	a0,80004968 <create+0x142>
    8000494e:	00492603          	lw	a2,4(s2)
    80004952:	00004597          	auipc	a1,0x4
    80004956:	d4e58593          	addi	a1,a1,-690 # 800086a0 <syscalls+0x2f0>
    8000495a:	8526                	mv	a0,s1
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	c7a080e7          	jalr	-902(ra) # 800035d6 <dirlink>
    80004964:	f80557e3          	bgez	a0,800048f2 <create+0xcc>
      panic("create dots");
    80004968:	00004517          	auipc	a0,0x4
    8000496c:	d4050513          	addi	a0,a0,-704 # 800086a8 <syscalls+0x2f8>
    80004970:	00001097          	auipc	ra,0x1
    80004974:	5e0080e7          	jalr	1504(ra) # 80005f50 <panic>
    panic("create: dirlink");
    80004978:	00004517          	auipc	a0,0x4
    8000497c:	d4050513          	addi	a0,a0,-704 # 800086b8 <syscalls+0x308>
    80004980:	00001097          	auipc	ra,0x1
    80004984:	5d0080e7          	jalr	1488(ra) # 80005f50 <panic>
    return 0;
    80004988:	84aa                	mv	s1,a0
    8000498a:	b739                	j	80004898 <create+0x72>

000000008000498c <sys_dup>:
{
    8000498c:	7179                	addi	sp,sp,-48
    8000498e:	f406                	sd	ra,40(sp)
    80004990:	f022                	sd	s0,32(sp)
    80004992:	ec26                	sd	s1,24(sp)
    80004994:	e84a                	sd	s2,16(sp)
    80004996:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004998:	fd840613          	addi	a2,s0,-40
    8000499c:	4581                	li	a1,0
    8000499e:	4501                	li	a0,0
    800049a0:	00000097          	auipc	ra,0x0
    800049a4:	ddc080e7          	jalr	-548(ra) # 8000477c <argfd>
    return -1;
    800049a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049aa:	02054363          	bltz	a0,800049d0 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800049ae:	fd843903          	ld	s2,-40(s0)
    800049b2:	854a                	mv	a0,s2
    800049b4:	00000097          	auipc	ra,0x0
    800049b8:	e30080e7          	jalr	-464(ra) # 800047e4 <fdalloc>
    800049bc:	84aa                	mv	s1,a0
    return -1;
    800049be:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800049c0:	00054863          	bltz	a0,800049d0 <sys_dup+0x44>
  filedup(f);
    800049c4:	854a                	mv	a0,s2
    800049c6:	fffff097          	auipc	ra,0xfffff
    800049ca:	368080e7          	jalr	872(ra) # 80003d2e <filedup>
  return fd;
    800049ce:	87a6                	mv	a5,s1
}
    800049d0:	853e                	mv	a0,a5
    800049d2:	70a2                	ld	ra,40(sp)
    800049d4:	7402                	ld	s0,32(sp)
    800049d6:	64e2                	ld	s1,24(sp)
    800049d8:	6942                	ld	s2,16(sp)
    800049da:	6145                	addi	sp,sp,48
    800049dc:	8082                	ret

00000000800049de <sys_read>:
{
    800049de:	7179                	addi	sp,sp,-48
    800049e0:	f406                	sd	ra,40(sp)
    800049e2:	f022                	sd	s0,32(sp)
    800049e4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049e6:	fe840613          	addi	a2,s0,-24
    800049ea:	4581                	li	a1,0
    800049ec:	4501                	li	a0,0
    800049ee:	00000097          	auipc	ra,0x0
    800049f2:	d8e080e7          	jalr	-626(ra) # 8000477c <argfd>
    return -1;
    800049f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049f8:	04054163          	bltz	a0,80004a3a <sys_read+0x5c>
    800049fc:	fe440593          	addi	a1,s0,-28
    80004a00:	4509                	li	a0,2
    80004a02:	ffffd097          	auipc	ra,0xffffd
    80004a06:	6e4080e7          	jalr	1764(ra) # 800020e6 <argint>
    return -1;
    80004a0a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a0c:	02054763          	bltz	a0,80004a3a <sys_read+0x5c>
    80004a10:	fd840593          	addi	a1,s0,-40
    80004a14:	4505                	li	a0,1
    80004a16:	ffffd097          	auipc	ra,0xffffd
    80004a1a:	6f2080e7          	jalr	1778(ra) # 80002108 <argaddr>
    return -1;
    80004a1e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a20:	00054d63          	bltz	a0,80004a3a <sys_read+0x5c>
  return fileread(f, p, n);
    80004a24:	fe442603          	lw	a2,-28(s0)
    80004a28:	fd843583          	ld	a1,-40(s0)
    80004a2c:	fe843503          	ld	a0,-24(s0)
    80004a30:	fffff097          	auipc	ra,0xfffff
    80004a34:	48a080e7          	jalr	1162(ra) # 80003eba <fileread>
    80004a38:	87aa                	mv	a5,a0
}
    80004a3a:	853e                	mv	a0,a5
    80004a3c:	70a2                	ld	ra,40(sp)
    80004a3e:	7402                	ld	s0,32(sp)
    80004a40:	6145                	addi	sp,sp,48
    80004a42:	8082                	ret

0000000080004a44 <sys_write>:
{
    80004a44:	7179                	addi	sp,sp,-48
    80004a46:	f406                	sd	ra,40(sp)
    80004a48:	f022                	sd	s0,32(sp)
    80004a4a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a4c:	fe840613          	addi	a2,s0,-24
    80004a50:	4581                	li	a1,0
    80004a52:	4501                	li	a0,0
    80004a54:	00000097          	auipc	ra,0x0
    80004a58:	d28080e7          	jalr	-728(ra) # 8000477c <argfd>
    return -1;
    80004a5c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a5e:	04054163          	bltz	a0,80004aa0 <sys_write+0x5c>
    80004a62:	fe440593          	addi	a1,s0,-28
    80004a66:	4509                	li	a0,2
    80004a68:	ffffd097          	auipc	ra,0xffffd
    80004a6c:	67e080e7          	jalr	1662(ra) # 800020e6 <argint>
    return -1;
    80004a70:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a72:	02054763          	bltz	a0,80004aa0 <sys_write+0x5c>
    80004a76:	fd840593          	addi	a1,s0,-40
    80004a7a:	4505                	li	a0,1
    80004a7c:	ffffd097          	auipc	ra,0xffffd
    80004a80:	68c080e7          	jalr	1676(ra) # 80002108 <argaddr>
    return -1;
    80004a84:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a86:	00054d63          	bltz	a0,80004aa0 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004a8a:	fe442603          	lw	a2,-28(s0)
    80004a8e:	fd843583          	ld	a1,-40(s0)
    80004a92:	fe843503          	ld	a0,-24(s0)
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	4e6080e7          	jalr	1254(ra) # 80003f7c <filewrite>
    80004a9e:	87aa                	mv	a5,a0
}
    80004aa0:	853e                	mv	a0,a5
    80004aa2:	70a2                	ld	ra,40(sp)
    80004aa4:	7402                	ld	s0,32(sp)
    80004aa6:	6145                	addi	sp,sp,48
    80004aa8:	8082                	ret

0000000080004aaa <sys_close>:
{
    80004aaa:	1101                	addi	sp,sp,-32
    80004aac:	ec06                	sd	ra,24(sp)
    80004aae:	e822                	sd	s0,16(sp)
    80004ab0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004ab2:	fe040613          	addi	a2,s0,-32
    80004ab6:	fec40593          	addi	a1,s0,-20
    80004aba:	4501                	li	a0,0
    80004abc:	00000097          	auipc	ra,0x0
    80004ac0:	cc0080e7          	jalr	-832(ra) # 8000477c <argfd>
    return -1;
    80004ac4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ac6:	02054463          	bltz	a0,80004aee <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004aca:	ffffc097          	auipc	ra,0xffffc
    80004ace:	3a2080e7          	jalr	930(ra) # 80000e6c <myproc>
    80004ad2:	fec42783          	lw	a5,-20(s0)
    80004ad6:	07e9                	addi	a5,a5,26
    80004ad8:	078e                	slli	a5,a5,0x3
    80004ada:	953e                	add	a0,a0,a5
    80004adc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004ae0:	fe043503          	ld	a0,-32(s0)
    80004ae4:	fffff097          	auipc	ra,0xfffff
    80004ae8:	29c080e7          	jalr	668(ra) # 80003d80 <fileclose>
  return 0;
    80004aec:	4781                	li	a5,0
}
    80004aee:	853e                	mv	a0,a5
    80004af0:	60e2                	ld	ra,24(sp)
    80004af2:	6442                	ld	s0,16(sp)
    80004af4:	6105                	addi	sp,sp,32
    80004af6:	8082                	ret

0000000080004af8 <sys_fstat>:
{
    80004af8:	1101                	addi	sp,sp,-32
    80004afa:	ec06                	sd	ra,24(sp)
    80004afc:	e822                	sd	s0,16(sp)
    80004afe:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b00:	fe840613          	addi	a2,s0,-24
    80004b04:	4581                	li	a1,0
    80004b06:	4501                	li	a0,0
    80004b08:	00000097          	auipc	ra,0x0
    80004b0c:	c74080e7          	jalr	-908(ra) # 8000477c <argfd>
    return -1;
    80004b10:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b12:	02054563          	bltz	a0,80004b3c <sys_fstat+0x44>
    80004b16:	fe040593          	addi	a1,s0,-32
    80004b1a:	4505                	li	a0,1
    80004b1c:	ffffd097          	auipc	ra,0xffffd
    80004b20:	5ec080e7          	jalr	1516(ra) # 80002108 <argaddr>
    return -1;
    80004b24:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b26:	00054b63          	bltz	a0,80004b3c <sys_fstat+0x44>
  return filestat(f, st);
    80004b2a:	fe043583          	ld	a1,-32(s0)
    80004b2e:	fe843503          	ld	a0,-24(s0)
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	316080e7          	jalr	790(ra) # 80003e48 <filestat>
    80004b3a:	87aa                	mv	a5,a0
}
    80004b3c:	853e                	mv	a0,a5
    80004b3e:	60e2                	ld	ra,24(sp)
    80004b40:	6442                	ld	s0,16(sp)
    80004b42:	6105                	addi	sp,sp,32
    80004b44:	8082                	ret

0000000080004b46 <sys_link>:
{
    80004b46:	7169                	addi	sp,sp,-304
    80004b48:	f606                	sd	ra,296(sp)
    80004b4a:	f222                	sd	s0,288(sp)
    80004b4c:	ee26                	sd	s1,280(sp)
    80004b4e:	ea4a                	sd	s2,272(sp)
    80004b50:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b52:	08000613          	li	a2,128
    80004b56:	ed040593          	addi	a1,s0,-304
    80004b5a:	4501                	li	a0,0
    80004b5c:	ffffd097          	auipc	ra,0xffffd
    80004b60:	5ce080e7          	jalr	1486(ra) # 8000212a <argstr>
    return -1;
    80004b64:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b66:	10054e63          	bltz	a0,80004c82 <sys_link+0x13c>
    80004b6a:	08000613          	li	a2,128
    80004b6e:	f5040593          	addi	a1,s0,-176
    80004b72:	4505                	li	a0,1
    80004b74:	ffffd097          	auipc	ra,0xffffd
    80004b78:	5b6080e7          	jalr	1462(ra) # 8000212a <argstr>
    return -1;
    80004b7c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b7e:	10054263          	bltz	a0,80004c82 <sys_link+0x13c>
  begin_op();
    80004b82:	fffff097          	auipc	ra,0xfffff
    80004b86:	d36080e7          	jalr	-714(ra) # 800038b8 <begin_op>
  if((ip = namei(old)) == 0){
    80004b8a:	ed040513          	addi	a0,s0,-304
    80004b8e:	fffff097          	auipc	ra,0xfffff
    80004b92:	b0a080e7          	jalr	-1270(ra) # 80003698 <namei>
    80004b96:	84aa                	mv	s1,a0
    80004b98:	c551                	beqz	a0,80004c24 <sys_link+0xde>
  ilock(ip);
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	342080e7          	jalr	834(ra) # 80002edc <ilock>
  if(ip->type == T_DIR){
    80004ba2:	04449703          	lh	a4,68(s1)
    80004ba6:	4785                	li	a5,1
    80004ba8:	08f70463          	beq	a4,a5,80004c30 <sys_link+0xea>
  ip->nlink++;
    80004bac:	04a4d783          	lhu	a5,74(s1)
    80004bb0:	2785                	addiw	a5,a5,1
    80004bb2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bb6:	8526                	mv	a0,s1
    80004bb8:	ffffe097          	auipc	ra,0xffffe
    80004bbc:	258080e7          	jalr	600(ra) # 80002e10 <iupdate>
  iunlock(ip);
    80004bc0:	8526                	mv	a0,s1
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	3dc080e7          	jalr	988(ra) # 80002f9e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004bca:	fd040593          	addi	a1,s0,-48
    80004bce:	f5040513          	addi	a0,s0,-176
    80004bd2:	fffff097          	auipc	ra,0xfffff
    80004bd6:	ae4080e7          	jalr	-1308(ra) # 800036b6 <nameiparent>
    80004bda:	892a                	mv	s2,a0
    80004bdc:	c935                	beqz	a0,80004c50 <sys_link+0x10a>
  ilock(dp);
    80004bde:	ffffe097          	auipc	ra,0xffffe
    80004be2:	2fe080e7          	jalr	766(ra) # 80002edc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004be6:	00092703          	lw	a4,0(s2)
    80004bea:	409c                	lw	a5,0(s1)
    80004bec:	04f71d63          	bne	a4,a5,80004c46 <sys_link+0x100>
    80004bf0:	40d0                	lw	a2,4(s1)
    80004bf2:	fd040593          	addi	a1,s0,-48
    80004bf6:	854a                	mv	a0,s2
    80004bf8:	fffff097          	auipc	ra,0xfffff
    80004bfc:	9de080e7          	jalr	-1570(ra) # 800035d6 <dirlink>
    80004c00:	04054363          	bltz	a0,80004c46 <sys_link+0x100>
  iunlockput(dp);
    80004c04:	854a                	mv	a0,s2
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	538080e7          	jalr	1336(ra) # 8000313e <iunlockput>
  iput(ip);
    80004c0e:	8526                	mv	a0,s1
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	486080e7          	jalr	1158(ra) # 80003096 <iput>
  end_op();
    80004c18:	fffff097          	auipc	ra,0xfffff
    80004c1c:	d1e080e7          	jalr	-738(ra) # 80003936 <end_op>
  return 0;
    80004c20:	4781                	li	a5,0
    80004c22:	a085                	j	80004c82 <sys_link+0x13c>
    end_op();
    80004c24:	fffff097          	auipc	ra,0xfffff
    80004c28:	d12080e7          	jalr	-750(ra) # 80003936 <end_op>
    return -1;
    80004c2c:	57fd                	li	a5,-1
    80004c2e:	a891                	j	80004c82 <sys_link+0x13c>
    iunlockput(ip);
    80004c30:	8526                	mv	a0,s1
    80004c32:	ffffe097          	auipc	ra,0xffffe
    80004c36:	50c080e7          	jalr	1292(ra) # 8000313e <iunlockput>
    end_op();
    80004c3a:	fffff097          	auipc	ra,0xfffff
    80004c3e:	cfc080e7          	jalr	-772(ra) # 80003936 <end_op>
    return -1;
    80004c42:	57fd                	li	a5,-1
    80004c44:	a83d                	j	80004c82 <sys_link+0x13c>
    iunlockput(dp);
    80004c46:	854a                	mv	a0,s2
    80004c48:	ffffe097          	auipc	ra,0xffffe
    80004c4c:	4f6080e7          	jalr	1270(ra) # 8000313e <iunlockput>
  ilock(ip);
    80004c50:	8526                	mv	a0,s1
    80004c52:	ffffe097          	auipc	ra,0xffffe
    80004c56:	28a080e7          	jalr	650(ra) # 80002edc <ilock>
  ip->nlink--;
    80004c5a:	04a4d783          	lhu	a5,74(s1)
    80004c5e:	37fd                	addiw	a5,a5,-1
    80004c60:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c64:	8526                	mv	a0,s1
    80004c66:	ffffe097          	auipc	ra,0xffffe
    80004c6a:	1aa080e7          	jalr	426(ra) # 80002e10 <iupdate>
  iunlockput(ip);
    80004c6e:	8526                	mv	a0,s1
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	4ce080e7          	jalr	1230(ra) # 8000313e <iunlockput>
  end_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	cbe080e7          	jalr	-834(ra) # 80003936 <end_op>
  return -1;
    80004c80:	57fd                	li	a5,-1
}
    80004c82:	853e                	mv	a0,a5
    80004c84:	70b2                	ld	ra,296(sp)
    80004c86:	7412                	ld	s0,288(sp)
    80004c88:	64f2                	ld	s1,280(sp)
    80004c8a:	6952                	ld	s2,272(sp)
    80004c8c:	6155                	addi	sp,sp,304
    80004c8e:	8082                	ret

0000000080004c90 <sys_unlink>:
{
    80004c90:	7151                	addi	sp,sp,-240
    80004c92:	f586                	sd	ra,232(sp)
    80004c94:	f1a2                	sd	s0,224(sp)
    80004c96:	eda6                	sd	s1,216(sp)
    80004c98:	e9ca                	sd	s2,208(sp)
    80004c9a:	e5ce                	sd	s3,200(sp)
    80004c9c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c9e:	08000613          	li	a2,128
    80004ca2:	f3040593          	addi	a1,s0,-208
    80004ca6:	4501                	li	a0,0
    80004ca8:	ffffd097          	auipc	ra,0xffffd
    80004cac:	482080e7          	jalr	1154(ra) # 8000212a <argstr>
    80004cb0:	18054163          	bltz	a0,80004e32 <sys_unlink+0x1a2>
  begin_op();
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	c04080e7          	jalr	-1020(ra) # 800038b8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004cbc:	fb040593          	addi	a1,s0,-80
    80004cc0:	f3040513          	addi	a0,s0,-208
    80004cc4:	fffff097          	auipc	ra,0xfffff
    80004cc8:	9f2080e7          	jalr	-1550(ra) # 800036b6 <nameiparent>
    80004ccc:	84aa                	mv	s1,a0
    80004cce:	c979                	beqz	a0,80004da4 <sys_unlink+0x114>
  ilock(dp);
    80004cd0:	ffffe097          	auipc	ra,0xffffe
    80004cd4:	20c080e7          	jalr	524(ra) # 80002edc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004cd8:	00004597          	auipc	a1,0x4
    80004cdc:	9c058593          	addi	a1,a1,-1600 # 80008698 <syscalls+0x2e8>
    80004ce0:	fb040513          	addi	a0,s0,-80
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	6c2080e7          	jalr	1730(ra) # 800033a6 <namecmp>
    80004cec:	14050a63          	beqz	a0,80004e40 <sys_unlink+0x1b0>
    80004cf0:	00004597          	auipc	a1,0x4
    80004cf4:	9b058593          	addi	a1,a1,-1616 # 800086a0 <syscalls+0x2f0>
    80004cf8:	fb040513          	addi	a0,s0,-80
    80004cfc:	ffffe097          	auipc	ra,0xffffe
    80004d00:	6aa080e7          	jalr	1706(ra) # 800033a6 <namecmp>
    80004d04:	12050e63          	beqz	a0,80004e40 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004d08:	f2c40613          	addi	a2,s0,-212
    80004d0c:	fb040593          	addi	a1,s0,-80
    80004d10:	8526                	mv	a0,s1
    80004d12:	ffffe097          	auipc	ra,0xffffe
    80004d16:	6ae080e7          	jalr	1710(ra) # 800033c0 <dirlookup>
    80004d1a:	892a                	mv	s2,a0
    80004d1c:	12050263          	beqz	a0,80004e40 <sys_unlink+0x1b0>
  ilock(ip);
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	1bc080e7          	jalr	444(ra) # 80002edc <ilock>
  if(ip->nlink < 1)
    80004d28:	04a91783          	lh	a5,74(s2)
    80004d2c:	08f05263          	blez	a5,80004db0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d30:	04491703          	lh	a4,68(s2)
    80004d34:	4785                	li	a5,1
    80004d36:	08f70563          	beq	a4,a5,80004dc0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004d3a:	4641                	li	a2,16
    80004d3c:	4581                	li	a1,0
    80004d3e:	fc040513          	addi	a0,s0,-64
    80004d42:	ffffb097          	auipc	ra,0xffffb
    80004d46:	438080e7          	jalr	1080(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d4a:	4741                	li	a4,16
    80004d4c:	f2c42683          	lw	a3,-212(s0)
    80004d50:	fc040613          	addi	a2,s0,-64
    80004d54:	4581                	li	a1,0
    80004d56:	8526                	mv	a0,s1
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	530080e7          	jalr	1328(ra) # 80003288 <writei>
    80004d60:	47c1                	li	a5,16
    80004d62:	0af51563          	bne	a0,a5,80004e0c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004d66:	04491703          	lh	a4,68(s2)
    80004d6a:	4785                	li	a5,1
    80004d6c:	0af70863          	beq	a4,a5,80004e1c <sys_unlink+0x18c>
  iunlockput(dp);
    80004d70:	8526                	mv	a0,s1
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	3cc080e7          	jalr	972(ra) # 8000313e <iunlockput>
  ip->nlink--;
    80004d7a:	04a95783          	lhu	a5,74(s2)
    80004d7e:	37fd                	addiw	a5,a5,-1
    80004d80:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d84:	854a                	mv	a0,s2
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	08a080e7          	jalr	138(ra) # 80002e10 <iupdate>
  iunlockput(ip);
    80004d8e:	854a                	mv	a0,s2
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	3ae080e7          	jalr	942(ra) # 8000313e <iunlockput>
  end_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	b9e080e7          	jalr	-1122(ra) # 80003936 <end_op>
  return 0;
    80004da0:	4501                	li	a0,0
    80004da2:	a84d                	j	80004e54 <sys_unlink+0x1c4>
    end_op();
    80004da4:	fffff097          	auipc	ra,0xfffff
    80004da8:	b92080e7          	jalr	-1134(ra) # 80003936 <end_op>
    return -1;
    80004dac:	557d                	li	a0,-1
    80004dae:	a05d                	j	80004e54 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004db0:	00004517          	auipc	a0,0x4
    80004db4:	91850513          	addi	a0,a0,-1768 # 800086c8 <syscalls+0x318>
    80004db8:	00001097          	auipc	ra,0x1
    80004dbc:	198080e7          	jalr	408(ra) # 80005f50 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dc0:	04c92703          	lw	a4,76(s2)
    80004dc4:	02000793          	li	a5,32
    80004dc8:	f6e7f9e3          	bgeu	a5,a4,80004d3a <sys_unlink+0xaa>
    80004dcc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dd0:	4741                	li	a4,16
    80004dd2:	86ce                	mv	a3,s3
    80004dd4:	f1840613          	addi	a2,s0,-232
    80004dd8:	4581                	li	a1,0
    80004dda:	854a                	mv	a0,s2
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	3b4080e7          	jalr	948(ra) # 80003190 <readi>
    80004de4:	47c1                	li	a5,16
    80004de6:	00f51b63          	bne	a0,a5,80004dfc <sys_unlink+0x16c>
    if(de.inum != 0)
    80004dea:	f1845783          	lhu	a5,-232(s0)
    80004dee:	e7a1                	bnez	a5,80004e36 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004df0:	29c1                	addiw	s3,s3,16
    80004df2:	04c92783          	lw	a5,76(s2)
    80004df6:	fcf9ede3          	bltu	s3,a5,80004dd0 <sys_unlink+0x140>
    80004dfa:	b781                	j	80004d3a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004dfc:	00004517          	auipc	a0,0x4
    80004e00:	8e450513          	addi	a0,a0,-1820 # 800086e0 <syscalls+0x330>
    80004e04:	00001097          	auipc	ra,0x1
    80004e08:	14c080e7          	jalr	332(ra) # 80005f50 <panic>
    panic("unlink: writei");
    80004e0c:	00004517          	auipc	a0,0x4
    80004e10:	8ec50513          	addi	a0,a0,-1812 # 800086f8 <syscalls+0x348>
    80004e14:	00001097          	auipc	ra,0x1
    80004e18:	13c080e7          	jalr	316(ra) # 80005f50 <panic>
    dp->nlink--;
    80004e1c:	04a4d783          	lhu	a5,74(s1)
    80004e20:	37fd                	addiw	a5,a5,-1
    80004e22:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e26:	8526                	mv	a0,s1
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	fe8080e7          	jalr	-24(ra) # 80002e10 <iupdate>
    80004e30:	b781                	j	80004d70 <sys_unlink+0xe0>
    return -1;
    80004e32:	557d                	li	a0,-1
    80004e34:	a005                	j	80004e54 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004e36:	854a                	mv	a0,s2
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	306080e7          	jalr	774(ra) # 8000313e <iunlockput>
  iunlockput(dp);
    80004e40:	8526                	mv	a0,s1
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	2fc080e7          	jalr	764(ra) # 8000313e <iunlockput>
  end_op();
    80004e4a:	fffff097          	auipc	ra,0xfffff
    80004e4e:	aec080e7          	jalr	-1300(ra) # 80003936 <end_op>
  return -1;
    80004e52:	557d                	li	a0,-1
}
    80004e54:	70ae                	ld	ra,232(sp)
    80004e56:	740e                	ld	s0,224(sp)
    80004e58:	64ee                	ld	s1,216(sp)
    80004e5a:	694e                	ld	s2,208(sp)
    80004e5c:	69ae                	ld	s3,200(sp)
    80004e5e:	616d                	addi	sp,sp,240
    80004e60:	8082                	ret

0000000080004e62 <sys_open>:

uint64
sys_open(void)
{
    80004e62:	7131                	addi	sp,sp,-192
    80004e64:	fd06                	sd	ra,184(sp)
    80004e66:	f922                	sd	s0,176(sp)
    80004e68:	f526                	sd	s1,168(sp)
    80004e6a:	f14a                	sd	s2,160(sp)
    80004e6c:	ed4e                	sd	s3,152(sp)
    80004e6e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e70:	08000613          	li	a2,128
    80004e74:	f5040593          	addi	a1,s0,-176
    80004e78:	4501                	li	a0,0
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	2b0080e7          	jalr	688(ra) # 8000212a <argstr>
    return -1;
    80004e82:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e84:	0c054163          	bltz	a0,80004f46 <sys_open+0xe4>
    80004e88:	f4c40593          	addi	a1,s0,-180
    80004e8c:	4505                	li	a0,1
    80004e8e:	ffffd097          	auipc	ra,0xffffd
    80004e92:	258080e7          	jalr	600(ra) # 800020e6 <argint>
    80004e96:	0a054863          	bltz	a0,80004f46 <sys_open+0xe4>

  begin_op();
    80004e9a:	fffff097          	auipc	ra,0xfffff
    80004e9e:	a1e080e7          	jalr	-1506(ra) # 800038b8 <begin_op>

  if(omode & O_CREATE){
    80004ea2:	f4c42783          	lw	a5,-180(s0)
    80004ea6:	2007f793          	andi	a5,a5,512
    80004eaa:	cbdd                	beqz	a5,80004f60 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004eac:	4681                	li	a3,0
    80004eae:	4601                	li	a2,0
    80004eb0:	4589                	li	a1,2
    80004eb2:	f5040513          	addi	a0,s0,-176
    80004eb6:	00000097          	auipc	ra,0x0
    80004eba:	970080e7          	jalr	-1680(ra) # 80004826 <create>
    80004ebe:	892a                	mv	s2,a0
    if(ip == 0){
    80004ec0:	c959                	beqz	a0,80004f56 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ec2:	04491703          	lh	a4,68(s2)
    80004ec6:	478d                	li	a5,3
    80004ec8:	00f71763          	bne	a4,a5,80004ed6 <sys_open+0x74>
    80004ecc:	04695703          	lhu	a4,70(s2)
    80004ed0:	47a5                	li	a5,9
    80004ed2:	0ce7ec63          	bltu	a5,a4,80004faa <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ed6:	fffff097          	auipc	ra,0xfffff
    80004eda:	dee080e7          	jalr	-530(ra) # 80003cc4 <filealloc>
    80004ede:	89aa                	mv	s3,a0
    80004ee0:	10050263          	beqz	a0,80004fe4 <sys_open+0x182>
    80004ee4:	00000097          	auipc	ra,0x0
    80004ee8:	900080e7          	jalr	-1792(ra) # 800047e4 <fdalloc>
    80004eec:	84aa                	mv	s1,a0
    80004eee:	0e054663          	bltz	a0,80004fda <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ef2:	04491703          	lh	a4,68(s2)
    80004ef6:	478d                	li	a5,3
    80004ef8:	0cf70463          	beq	a4,a5,80004fc0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004efc:	4789                	li	a5,2
    80004efe:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f02:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f06:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f0a:	f4c42783          	lw	a5,-180(s0)
    80004f0e:	0017c713          	xori	a4,a5,1
    80004f12:	8b05                	andi	a4,a4,1
    80004f14:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f18:	0037f713          	andi	a4,a5,3
    80004f1c:	00e03733          	snez	a4,a4
    80004f20:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f24:	4007f793          	andi	a5,a5,1024
    80004f28:	c791                	beqz	a5,80004f34 <sys_open+0xd2>
    80004f2a:	04491703          	lh	a4,68(s2)
    80004f2e:	4789                	li	a5,2
    80004f30:	08f70f63          	beq	a4,a5,80004fce <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004f34:	854a                	mv	a0,s2
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	068080e7          	jalr	104(ra) # 80002f9e <iunlock>
  end_op();
    80004f3e:	fffff097          	auipc	ra,0xfffff
    80004f42:	9f8080e7          	jalr	-1544(ra) # 80003936 <end_op>

  return fd;
}
    80004f46:	8526                	mv	a0,s1
    80004f48:	70ea                	ld	ra,184(sp)
    80004f4a:	744a                	ld	s0,176(sp)
    80004f4c:	74aa                	ld	s1,168(sp)
    80004f4e:	790a                	ld	s2,160(sp)
    80004f50:	69ea                	ld	s3,152(sp)
    80004f52:	6129                	addi	sp,sp,192
    80004f54:	8082                	ret
      end_op();
    80004f56:	fffff097          	auipc	ra,0xfffff
    80004f5a:	9e0080e7          	jalr	-1568(ra) # 80003936 <end_op>
      return -1;
    80004f5e:	b7e5                	j	80004f46 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004f60:	f5040513          	addi	a0,s0,-176
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	734080e7          	jalr	1844(ra) # 80003698 <namei>
    80004f6c:	892a                	mv	s2,a0
    80004f6e:	c905                	beqz	a0,80004f9e <sys_open+0x13c>
    ilock(ip);
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	f6c080e7          	jalr	-148(ra) # 80002edc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f78:	04491703          	lh	a4,68(s2)
    80004f7c:	4785                	li	a5,1
    80004f7e:	f4f712e3          	bne	a4,a5,80004ec2 <sys_open+0x60>
    80004f82:	f4c42783          	lw	a5,-180(s0)
    80004f86:	dba1                	beqz	a5,80004ed6 <sys_open+0x74>
      iunlockput(ip);
    80004f88:	854a                	mv	a0,s2
    80004f8a:	ffffe097          	auipc	ra,0xffffe
    80004f8e:	1b4080e7          	jalr	436(ra) # 8000313e <iunlockput>
      end_op();
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	9a4080e7          	jalr	-1628(ra) # 80003936 <end_op>
      return -1;
    80004f9a:	54fd                	li	s1,-1
    80004f9c:	b76d                	j	80004f46 <sys_open+0xe4>
      end_op();
    80004f9e:	fffff097          	auipc	ra,0xfffff
    80004fa2:	998080e7          	jalr	-1640(ra) # 80003936 <end_op>
      return -1;
    80004fa6:	54fd                	li	s1,-1
    80004fa8:	bf79                	j	80004f46 <sys_open+0xe4>
    iunlockput(ip);
    80004faa:	854a                	mv	a0,s2
    80004fac:	ffffe097          	auipc	ra,0xffffe
    80004fb0:	192080e7          	jalr	402(ra) # 8000313e <iunlockput>
    end_op();
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	982080e7          	jalr	-1662(ra) # 80003936 <end_op>
    return -1;
    80004fbc:	54fd                	li	s1,-1
    80004fbe:	b761                	j	80004f46 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004fc0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004fc4:	04691783          	lh	a5,70(s2)
    80004fc8:	02f99223          	sh	a5,36(s3)
    80004fcc:	bf2d                	j	80004f06 <sys_open+0xa4>
    itrunc(ip);
    80004fce:	854a                	mv	a0,s2
    80004fd0:	ffffe097          	auipc	ra,0xffffe
    80004fd4:	01a080e7          	jalr	26(ra) # 80002fea <itrunc>
    80004fd8:	bfb1                	j	80004f34 <sys_open+0xd2>
      fileclose(f);
    80004fda:	854e                	mv	a0,s3
    80004fdc:	fffff097          	auipc	ra,0xfffff
    80004fe0:	da4080e7          	jalr	-604(ra) # 80003d80 <fileclose>
    iunlockput(ip);
    80004fe4:	854a                	mv	a0,s2
    80004fe6:	ffffe097          	auipc	ra,0xffffe
    80004fea:	158080e7          	jalr	344(ra) # 8000313e <iunlockput>
    end_op();
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	948080e7          	jalr	-1720(ra) # 80003936 <end_op>
    return -1;
    80004ff6:	54fd                	li	s1,-1
    80004ff8:	b7b9                	j	80004f46 <sys_open+0xe4>

0000000080004ffa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ffa:	7175                	addi	sp,sp,-144
    80004ffc:	e506                	sd	ra,136(sp)
    80004ffe:	e122                	sd	s0,128(sp)
    80005000:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	8b6080e7          	jalr	-1866(ra) # 800038b8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000500a:	08000613          	li	a2,128
    8000500e:	f7040593          	addi	a1,s0,-144
    80005012:	4501                	li	a0,0
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	116080e7          	jalr	278(ra) # 8000212a <argstr>
    8000501c:	02054963          	bltz	a0,8000504e <sys_mkdir+0x54>
    80005020:	4681                	li	a3,0
    80005022:	4601                	li	a2,0
    80005024:	4585                	li	a1,1
    80005026:	f7040513          	addi	a0,s0,-144
    8000502a:	fffff097          	auipc	ra,0xfffff
    8000502e:	7fc080e7          	jalr	2044(ra) # 80004826 <create>
    80005032:	cd11                	beqz	a0,8000504e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005034:	ffffe097          	auipc	ra,0xffffe
    80005038:	10a080e7          	jalr	266(ra) # 8000313e <iunlockput>
  end_op();
    8000503c:	fffff097          	auipc	ra,0xfffff
    80005040:	8fa080e7          	jalr	-1798(ra) # 80003936 <end_op>
  return 0;
    80005044:	4501                	li	a0,0
}
    80005046:	60aa                	ld	ra,136(sp)
    80005048:	640a                	ld	s0,128(sp)
    8000504a:	6149                	addi	sp,sp,144
    8000504c:	8082                	ret
    end_op();
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	8e8080e7          	jalr	-1816(ra) # 80003936 <end_op>
    return -1;
    80005056:	557d                	li	a0,-1
    80005058:	b7fd                	j	80005046 <sys_mkdir+0x4c>

000000008000505a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000505a:	7135                	addi	sp,sp,-160
    8000505c:	ed06                	sd	ra,152(sp)
    8000505e:	e922                	sd	s0,144(sp)
    80005060:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005062:	fffff097          	auipc	ra,0xfffff
    80005066:	856080e7          	jalr	-1962(ra) # 800038b8 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000506a:	08000613          	li	a2,128
    8000506e:	f7040593          	addi	a1,s0,-144
    80005072:	4501                	li	a0,0
    80005074:	ffffd097          	auipc	ra,0xffffd
    80005078:	0b6080e7          	jalr	182(ra) # 8000212a <argstr>
    8000507c:	04054a63          	bltz	a0,800050d0 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005080:	f6c40593          	addi	a1,s0,-148
    80005084:	4505                	li	a0,1
    80005086:	ffffd097          	auipc	ra,0xffffd
    8000508a:	060080e7          	jalr	96(ra) # 800020e6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000508e:	04054163          	bltz	a0,800050d0 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005092:	f6840593          	addi	a1,s0,-152
    80005096:	4509                	li	a0,2
    80005098:	ffffd097          	auipc	ra,0xffffd
    8000509c:	04e080e7          	jalr	78(ra) # 800020e6 <argint>
     argint(1, &major) < 0 ||
    800050a0:	02054863          	bltz	a0,800050d0 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050a4:	f6841683          	lh	a3,-152(s0)
    800050a8:	f6c41603          	lh	a2,-148(s0)
    800050ac:	458d                	li	a1,3
    800050ae:	f7040513          	addi	a0,s0,-144
    800050b2:	fffff097          	auipc	ra,0xfffff
    800050b6:	774080e7          	jalr	1908(ra) # 80004826 <create>
     argint(2, &minor) < 0 ||
    800050ba:	c919                	beqz	a0,800050d0 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050bc:	ffffe097          	auipc	ra,0xffffe
    800050c0:	082080e7          	jalr	130(ra) # 8000313e <iunlockput>
  end_op();
    800050c4:	fffff097          	auipc	ra,0xfffff
    800050c8:	872080e7          	jalr	-1934(ra) # 80003936 <end_op>
  return 0;
    800050cc:	4501                	li	a0,0
    800050ce:	a031                	j	800050da <sys_mknod+0x80>
    end_op();
    800050d0:	fffff097          	auipc	ra,0xfffff
    800050d4:	866080e7          	jalr	-1946(ra) # 80003936 <end_op>
    return -1;
    800050d8:	557d                	li	a0,-1
}
    800050da:	60ea                	ld	ra,152(sp)
    800050dc:	644a                	ld	s0,144(sp)
    800050de:	610d                	addi	sp,sp,160
    800050e0:	8082                	ret

00000000800050e2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800050e2:	7135                	addi	sp,sp,-160
    800050e4:	ed06                	sd	ra,152(sp)
    800050e6:	e922                	sd	s0,144(sp)
    800050e8:	e526                	sd	s1,136(sp)
    800050ea:	e14a                	sd	s2,128(sp)
    800050ec:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050ee:	ffffc097          	auipc	ra,0xffffc
    800050f2:	d7e080e7          	jalr	-642(ra) # 80000e6c <myproc>
    800050f6:	892a                	mv	s2,a0
  
  begin_op();
    800050f8:	ffffe097          	auipc	ra,0xffffe
    800050fc:	7c0080e7          	jalr	1984(ra) # 800038b8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005100:	08000613          	li	a2,128
    80005104:	f6040593          	addi	a1,s0,-160
    80005108:	4501                	li	a0,0
    8000510a:	ffffd097          	auipc	ra,0xffffd
    8000510e:	020080e7          	jalr	32(ra) # 8000212a <argstr>
    80005112:	04054b63          	bltz	a0,80005168 <sys_chdir+0x86>
    80005116:	f6040513          	addi	a0,s0,-160
    8000511a:	ffffe097          	auipc	ra,0xffffe
    8000511e:	57e080e7          	jalr	1406(ra) # 80003698 <namei>
    80005122:	84aa                	mv	s1,a0
    80005124:	c131                	beqz	a0,80005168 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005126:	ffffe097          	auipc	ra,0xffffe
    8000512a:	db6080e7          	jalr	-586(ra) # 80002edc <ilock>
  if(ip->type != T_DIR){
    8000512e:	04449703          	lh	a4,68(s1)
    80005132:	4785                	li	a5,1
    80005134:	04f71063          	bne	a4,a5,80005174 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005138:	8526                	mv	a0,s1
    8000513a:	ffffe097          	auipc	ra,0xffffe
    8000513e:	e64080e7          	jalr	-412(ra) # 80002f9e <iunlock>
  iput(p->cwd);
    80005142:	15093503          	ld	a0,336(s2)
    80005146:	ffffe097          	auipc	ra,0xffffe
    8000514a:	f50080e7          	jalr	-176(ra) # 80003096 <iput>
  end_op();
    8000514e:	ffffe097          	auipc	ra,0xffffe
    80005152:	7e8080e7          	jalr	2024(ra) # 80003936 <end_op>
  p->cwd = ip;
    80005156:	14993823          	sd	s1,336(s2)
  return 0;
    8000515a:	4501                	li	a0,0
}
    8000515c:	60ea                	ld	ra,152(sp)
    8000515e:	644a                	ld	s0,144(sp)
    80005160:	64aa                	ld	s1,136(sp)
    80005162:	690a                	ld	s2,128(sp)
    80005164:	610d                	addi	sp,sp,160
    80005166:	8082                	ret
    end_op();
    80005168:	ffffe097          	auipc	ra,0xffffe
    8000516c:	7ce080e7          	jalr	1998(ra) # 80003936 <end_op>
    return -1;
    80005170:	557d                	li	a0,-1
    80005172:	b7ed                	j	8000515c <sys_chdir+0x7a>
    iunlockput(ip);
    80005174:	8526                	mv	a0,s1
    80005176:	ffffe097          	auipc	ra,0xffffe
    8000517a:	fc8080e7          	jalr	-56(ra) # 8000313e <iunlockput>
    end_op();
    8000517e:	ffffe097          	auipc	ra,0xffffe
    80005182:	7b8080e7          	jalr	1976(ra) # 80003936 <end_op>
    return -1;
    80005186:	557d                	li	a0,-1
    80005188:	bfd1                	j	8000515c <sys_chdir+0x7a>

000000008000518a <sys_exec>:

uint64
sys_exec(void)
{
    8000518a:	7145                	addi	sp,sp,-464
    8000518c:	e786                	sd	ra,456(sp)
    8000518e:	e3a2                	sd	s0,448(sp)
    80005190:	ff26                	sd	s1,440(sp)
    80005192:	fb4a                	sd	s2,432(sp)
    80005194:	f74e                	sd	s3,424(sp)
    80005196:	f352                	sd	s4,416(sp)
    80005198:	ef56                	sd	s5,408(sp)
    8000519a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000519c:	08000613          	li	a2,128
    800051a0:	f4040593          	addi	a1,s0,-192
    800051a4:	4501                	li	a0,0
    800051a6:	ffffd097          	auipc	ra,0xffffd
    800051aa:	f84080e7          	jalr	-124(ra) # 8000212a <argstr>
    return -1;
    800051ae:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800051b0:	0c054b63          	bltz	a0,80005286 <sys_exec+0xfc>
    800051b4:	e3840593          	addi	a1,s0,-456
    800051b8:	4505                	li	a0,1
    800051ba:	ffffd097          	auipc	ra,0xffffd
    800051be:	f4e080e7          	jalr	-178(ra) # 80002108 <argaddr>
    800051c2:	0c054263          	bltz	a0,80005286 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    800051c6:	10000613          	li	a2,256
    800051ca:	4581                	li	a1,0
    800051cc:	e4040513          	addi	a0,s0,-448
    800051d0:	ffffb097          	auipc	ra,0xffffb
    800051d4:	faa080e7          	jalr	-86(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051d8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800051dc:	89a6                	mv	s3,s1
    800051de:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051e0:	02000a13          	li	s4,32
    800051e4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051e8:	00391513          	slli	a0,s2,0x3
    800051ec:	e3040593          	addi	a1,s0,-464
    800051f0:	e3843783          	ld	a5,-456(s0)
    800051f4:	953e                	add	a0,a0,a5
    800051f6:	ffffd097          	auipc	ra,0xffffd
    800051fa:	e56080e7          	jalr	-426(ra) # 8000204c <fetchaddr>
    800051fe:	02054a63          	bltz	a0,80005232 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005202:	e3043783          	ld	a5,-464(s0)
    80005206:	c3b9                	beqz	a5,8000524c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005208:	ffffb097          	auipc	ra,0xffffb
    8000520c:	f12080e7          	jalr	-238(ra) # 8000011a <kalloc>
    80005210:	85aa                	mv	a1,a0
    80005212:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005216:	cd11                	beqz	a0,80005232 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005218:	6605                	lui	a2,0x1
    8000521a:	e3043503          	ld	a0,-464(s0)
    8000521e:	ffffd097          	auipc	ra,0xffffd
    80005222:	e80080e7          	jalr	-384(ra) # 8000209e <fetchstr>
    80005226:	00054663          	bltz	a0,80005232 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000522a:	0905                	addi	s2,s2,1
    8000522c:	09a1                	addi	s3,s3,8
    8000522e:	fb491be3          	bne	s2,s4,800051e4 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005232:	f4040913          	addi	s2,s0,-192
    80005236:	6088                	ld	a0,0(s1)
    80005238:	c531                	beqz	a0,80005284 <sys_exec+0xfa>
    kfree(argv[i]);
    8000523a:	ffffb097          	auipc	ra,0xffffb
    8000523e:	de2080e7          	jalr	-542(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005242:	04a1                	addi	s1,s1,8
    80005244:	ff2499e3          	bne	s1,s2,80005236 <sys_exec+0xac>
  return -1;
    80005248:	597d                	li	s2,-1
    8000524a:	a835                	j	80005286 <sys_exec+0xfc>
      argv[i] = 0;
    8000524c:	0a8e                	slli	s5,s5,0x3
    8000524e:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffced80>
    80005252:	00878ab3          	add	s5,a5,s0
    80005256:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000525a:	e4040593          	addi	a1,s0,-448
    8000525e:	f4040513          	addi	a0,s0,-192
    80005262:	fffff097          	auipc	ra,0xfffff
    80005266:	172080e7          	jalr	370(ra) # 800043d4 <exec>
    8000526a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000526c:	f4040993          	addi	s3,s0,-192
    80005270:	6088                	ld	a0,0(s1)
    80005272:	c911                	beqz	a0,80005286 <sys_exec+0xfc>
    kfree(argv[i]);
    80005274:	ffffb097          	auipc	ra,0xffffb
    80005278:	da8080e7          	jalr	-600(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000527c:	04a1                	addi	s1,s1,8
    8000527e:	ff3499e3          	bne	s1,s3,80005270 <sys_exec+0xe6>
    80005282:	a011                	j	80005286 <sys_exec+0xfc>
  return -1;
    80005284:	597d                	li	s2,-1
}
    80005286:	854a                	mv	a0,s2
    80005288:	60be                	ld	ra,456(sp)
    8000528a:	641e                	ld	s0,448(sp)
    8000528c:	74fa                	ld	s1,440(sp)
    8000528e:	795a                	ld	s2,432(sp)
    80005290:	79ba                	ld	s3,424(sp)
    80005292:	7a1a                	ld	s4,416(sp)
    80005294:	6afa                	ld	s5,408(sp)
    80005296:	6179                	addi	sp,sp,464
    80005298:	8082                	ret

000000008000529a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000529a:	7139                	addi	sp,sp,-64
    8000529c:	fc06                	sd	ra,56(sp)
    8000529e:	f822                	sd	s0,48(sp)
    800052a0:	f426                	sd	s1,40(sp)
    800052a2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052a4:	ffffc097          	auipc	ra,0xffffc
    800052a8:	bc8080e7          	jalr	-1080(ra) # 80000e6c <myproc>
    800052ac:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800052ae:	fd840593          	addi	a1,s0,-40
    800052b2:	4501                	li	a0,0
    800052b4:	ffffd097          	auipc	ra,0xffffd
    800052b8:	e54080e7          	jalr	-428(ra) # 80002108 <argaddr>
    return -1;
    800052bc:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800052be:	0e054063          	bltz	a0,8000539e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800052c2:	fc840593          	addi	a1,s0,-56
    800052c6:	fd040513          	addi	a0,s0,-48
    800052ca:	fffff097          	auipc	ra,0xfffff
    800052ce:	de6080e7          	jalr	-538(ra) # 800040b0 <pipealloc>
    return -1;
    800052d2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052d4:	0c054563          	bltz	a0,8000539e <sys_pipe+0x104>
  fd0 = -1;
    800052d8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052dc:	fd043503          	ld	a0,-48(s0)
    800052e0:	fffff097          	auipc	ra,0xfffff
    800052e4:	504080e7          	jalr	1284(ra) # 800047e4 <fdalloc>
    800052e8:	fca42223          	sw	a0,-60(s0)
    800052ec:	08054c63          	bltz	a0,80005384 <sys_pipe+0xea>
    800052f0:	fc843503          	ld	a0,-56(s0)
    800052f4:	fffff097          	auipc	ra,0xfffff
    800052f8:	4f0080e7          	jalr	1264(ra) # 800047e4 <fdalloc>
    800052fc:	fca42023          	sw	a0,-64(s0)
    80005300:	06054963          	bltz	a0,80005372 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005304:	4691                	li	a3,4
    80005306:	fc440613          	addi	a2,s0,-60
    8000530a:	fd843583          	ld	a1,-40(s0)
    8000530e:	68a8                	ld	a0,80(s1)
    80005310:	ffffb097          	auipc	ra,0xffffb
    80005314:	7ea080e7          	jalr	2026(ra) # 80000afa <copyout>
    80005318:	02054063          	bltz	a0,80005338 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000531c:	4691                	li	a3,4
    8000531e:	fc040613          	addi	a2,s0,-64
    80005322:	fd843583          	ld	a1,-40(s0)
    80005326:	0591                	addi	a1,a1,4
    80005328:	68a8                	ld	a0,80(s1)
    8000532a:	ffffb097          	auipc	ra,0xffffb
    8000532e:	7d0080e7          	jalr	2000(ra) # 80000afa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005332:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005334:	06055563          	bgez	a0,8000539e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005338:	fc442783          	lw	a5,-60(s0)
    8000533c:	07e9                	addi	a5,a5,26
    8000533e:	078e                	slli	a5,a5,0x3
    80005340:	97a6                	add	a5,a5,s1
    80005342:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005346:	fc042783          	lw	a5,-64(s0)
    8000534a:	07e9                	addi	a5,a5,26
    8000534c:	078e                	slli	a5,a5,0x3
    8000534e:	00f48533          	add	a0,s1,a5
    80005352:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005356:	fd043503          	ld	a0,-48(s0)
    8000535a:	fffff097          	auipc	ra,0xfffff
    8000535e:	a26080e7          	jalr	-1498(ra) # 80003d80 <fileclose>
    fileclose(wf);
    80005362:	fc843503          	ld	a0,-56(s0)
    80005366:	fffff097          	auipc	ra,0xfffff
    8000536a:	a1a080e7          	jalr	-1510(ra) # 80003d80 <fileclose>
    return -1;
    8000536e:	57fd                	li	a5,-1
    80005370:	a03d                	j	8000539e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005372:	fc442783          	lw	a5,-60(s0)
    80005376:	0007c763          	bltz	a5,80005384 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000537a:	07e9                	addi	a5,a5,26
    8000537c:	078e                	slli	a5,a5,0x3
    8000537e:	97a6                	add	a5,a5,s1
    80005380:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005384:	fd043503          	ld	a0,-48(s0)
    80005388:	fffff097          	auipc	ra,0xfffff
    8000538c:	9f8080e7          	jalr	-1544(ra) # 80003d80 <fileclose>
    fileclose(wf);
    80005390:	fc843503          	ld	a0,-56(s0)
    80005394:	fffff097          	auipc	ra,0xfffff
    80005398:	9ec080e7          	jalr	-1556(ra) # 80003d80 <fileclose>
    return -1;
    8000539c:	57fd                	li	a5,-1
}
    8000539e:	853e                	mv	a0,a5
    800053a0:	70e2                	ld	ra,56(sp)
    800053a2:	7442                	ld	s0,48(sp)
    800053a4:	74a2                	ld	s1,40(sp)
    800053a6:	6121                	addi	sp,sp,64
    800053a8:	8082                	ret
    800053aa:	0000                	unimp
    800053ac:	0000                	unimp
	...

00000000800053b0 <kernelvec>:
    800053b0:	7111                	addi	sp,sp,-256
    800053b2:	e006                	sd	ra,0(sp)
    800053b4:	e40a                	sd	sp,8(sp)
    800053b6:	e80e                	sd	gp,16(sp)
    800053b8:	ec12                	sd	tp,24(sp)
    800053ba:	f016                	sd	t0,32(sp)
    800053bc:	f41a                	sd	t1,40(sp)
    800053be:	f81e                	sd	t2,48(sp)
    800053c0:	fc22                	sd	s0,56(sp)
    800053c2:	e0a6                	sd	s1,64(sp)
    800053c4:	e4aa                	sd	a0,72(sp)
    800053c6:	e8ae                	sd	a1,80(sp)
    800053c8:	ecb2                	sd	a2,88(sp)
    800053ca:	f0b6                	sd	a3,96(sp)
    800053cc:	f4ba                	sd	a4,104(sp)
    800053ce:	f8be                	sd	a5,112(sp)
    800053d0:	fcc2                	sd	a6,120(sp)
    800053d2:	e146                	sd	a7,128(sp)
    800053d4:	e54a                	sd	s2,136(sp)
    800053d6:	e94e                	sd	s3,144(sp)
    800053d8:	ed52                	sd	s4,152(sp)
    800053da:	f156                	sd	s5,160(sp)
    800053dc:	f55a                	sd	s6,168(sp)
    800053de:	f95e                	sd	s7,176(sp)
    800053e0:	fd62                	sd	s8,184(sp)
    800053e2:	e1e6                	sd	s9,192(sp)
    800053e4:	e5ea                	sd	s10,200(sp)
    800053e6:	e9ee                	sd	s11,208(sp)
    800053e8:	edf2                	sd	t3,216(sp)
    800053ea:	f1f6                	sd	t4,224(sp)
    800053ec:	f5fa                	sd	t5,232(sp)
    800053ee:	f9fe                	sd	t6,240(sp)
    800053f0:	b29fc0ef          	jal	ra,80001f18 <kerneltrap>
    800053f4:	6082                	ld	ra,0(sp)
    800053f6:	6122                	ld	sp,8(sp)
    800053f8:	61c2                	ld	gp,16(sp)
    800053fa:	7282                	ld	t0,32(sp)
    800053fc:	7322                	ld	t1,40(sp)
    800053fe:	73c2                	ld	t2,48(sp)
    80005400:	7462                	ld	s0,56(sp)
    80005402:	6486                	ld	s1,64(sp)
    80005404:	6526                	ld	a0,72(sp)
    80005406:	65c6                	ld	a1,80(sp)
    80005408:	6666                	ld	a2,88(sp)
    8000540a:	7686                	ld	a3,96(sp)
    8000540c:	7726                	ld	a4,104(sp)
    8000540e:	77c6                	ld	a5,112(sp)
    80005410:	7866                	ld	a6,120(sp)
    80005412:	688a                	ld	a7,128(sp)
    80005414:	692a                	ld	s2,136(sp)
    80005416:	69ca                	ld	s3,144(sp)
    80005418:	6a6a                	ld	s4,152(sp)
    8000541a:	7a8a                	ld	s5,160(sp)
    8000541c:	7b2a                	ld	s6,168(sp)
    8000541e:	7bca                	ld	s7,176(sp)
    80005420:	7c6a                	ld	s8,184(sp)
    80005422:	6c8e                	ld	s9,192(sp)
    80005424:	6d2e                	ld	s10,200(sp)
    80005426:	6dce                	ld	s11,208(sp)
    80005428:	6e6e                	ld	t3,216(sp)
    8000542a:	7e8e                	ld	t4,224(sp)
    8000542c:	7f2e                	ld	t5,232(sp)
    8000542e:	7fce                	ld	t6,240(sp)
    80005430:	6111                	addi	sp,sp,256
    80005432:	10200073          	sret
    80005436:	00000013          	nop
    8000543a:	00000013          	nop
    8000543e:	0001                	nop

0000000080005440 <timervec>:
    80005440:	34051573          	csrrw	a0,mscratch,a0
    80005444:	e10c                	sd	a1,0(a0)
    80005446:	e510                	sd	a2,8(a0)
    80005448:	e914                	sd	a3,16(a0)
    8000544a:	6d0c                	ld	a1,24(a0)
    8000544c:	7110                	ld	a2,32(a0)
    8000544e:	6194                	ld	a3,0(a1)
    80005450:	96b2                	add	a3,a3,a2
    80005452:	e194                	sd	a3,0(a1)
    80005454:	4589                	li	a1,2
    80005456:	14459073          	csrw	sip,a1
    8000545a:	6914                	ld	a3,16(a0)
    8000545c:	6510                	ld	a2,8(a0)
    8000545e:	610c                	ld	a1,0(a0)
    80005460:	34051573          	csrrw	a0,mscratch,a0
    80005464:	30200073          	mret
	...

000000008000546a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000546a:	1141                	addi	sp,sp,-16
    8000546c:	e422                	sd	s0,8(sp)
    8000546e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005470:	0c0007b7          	lui	a5,0xc000
    80005474:	4705                	li	a4,1
    80005476:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005478:	c3d8                	sw	a4,4(a5)
}
    8000547a:	6422                	ld	s0,8(sp)
    8000547c:	0141                	addi	sp,sp,16
    8000547e:	8082                	ret

0000000080005480 <plicinithart>:

void
plicinithart(void)
{
    80005480:	1141                	addi	sp,sp,-16
    80005482:	e406                	sd	ra,8(sp)
    80005484:	e022                	sd	s0,0(sp)
    80005486:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005488:	ffffc097          	auipc	ra,0xffffc
    8000548c:	9b8080e7          	jalr	-1608(ra) # 80000e40 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005490:	0085171b          	slliw	a4,a0,0x8
    80005494:	0c0027b7          	lui	a5,0xc002
    80005498:	97ba                	add	a5,a5,a4
    8000549a:	40200713          	li	a4,1026
    8000549e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054a2:	00d5151b          	slliw	a0,a0,0xd
    800054a6:	0c2017b7          	lui	a5,0xc201
    800054aa:	97aa                	add	a5,a5,a0
    800054ac:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800054b0:	60a2                	ld	ra,8(sp)
    800054b2:	6402                	ld	s0,0(sp)
    800054b4:	0141                	addi	sp,sp,16
    800054b6:	8082                	ret

00000000800054b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054b8:	1141                	addi	sp,sp,-16
    800054ba:	e406                	sd	ra,8(sp)
    800054bc:	e022                	sd	s0,0(sp)
    800054be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054c0:	ffffc097          	auipc	ra,0xffffc
    800054c4:	980080e7          	jalr	-1664(ra) # 80000e40 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054c8:	00d5151b          	slliw	a0,a0,0xd
    800054cc:	0c2017b7          	lui	a5,0xc201
    800054d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800054d2:	43c8                	lw	a0,4(a5)
    800054d4:	60a2                	ld	ra,8(sp)
    800054d6:	6402                	ld	s0,0(sp)
    800054d8:	0141                	addi	sp,sp,16
    800054da:	8082                	ret

00000000800054dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054dc:	1101                	addi	sp,sp,-32
    800054de:	ec06                	sd	ra,24(sp)
    800054e0:	e822                	sd	s0,16(sp)
    800054e2:	e426                	sd	s1,8(sp)
    800054e4:	1000                	addi	s0,sp,32
    800054e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054e8:	ffffc097          	auipc	ra,0xffffc
    800054ec:	958080e7          	jalr	-1704(ra) # 80000e40 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054f0:	00d5151b          	slliw	a0,a0,0xd
    800054f4:	0c2017b7          	lui	a5,0xc201
    800054f8:	97aa                	add	a5,a5,a0
    800054fa:	c3c4                	sw	s1,4(a5)
}
    800054fc:	60e2                	ld	ra,24(sp)
    800054fe:	6442                	ld	s0,16(sp)
    80005500:	64a2                	ld	s1,8(sp)
    80005502:	6105                	addi	sp,sp,32
    80005504:	8082                	ret

0000000080005506 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005506:	1141                	addi	sp,sp,-16
    80005508:	e406                	sd	ra,8(sp)
    8000550a:	e022                	sd	s0,0(sp)
    8000550c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000550e:	479d                	li	a5,7
    80005510:	06a7c863          	blt	a5,a0,80005580 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005514:	00020717          	auipc	a4,0x20
    80005518:	aec70713          	addi	a4,a4,-1300 # 80025000 <disk>
    8000551c:	972a                	add	a4,a4,a0
    8000551e:	6789                	lui	a5,0x2
    80005520:	97ba                	add	a5,a5,a4
    80005522:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005526:	e7ad                	bnez	a5,80005590 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005528:	00451793          	slli	a5,a0,0x4
    8000552c:	00022717          	auipc	a4,0x22
    80005530:	ad470713          	addi	a4,a4,-1324 # 80027000 <disk+0x2000>
    80005534:	6314                	ld	a3,0(a4)
    80005536:	96be                	add	a3,a3,a5
    80005538:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000553c:	6314                	ld	a3,0(a4)
    8000553e:	96be                	add	a3,a3,a5
    80005540:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005544:	6314                	ld	a3,0(a4)
    80005546:	96be                	add	a3,a3,a5
    80005548:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000554c:	6318                	ld	a4,0(a4)
    8000554e:	97ba                	add	a5,a5,a4
    80005550:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005554:	00020717          	auipc	a4,0x20
    80005558:	aac70713          	addi	a4,a4,-1364 # 80025000 <disk>
    8000555c:	972a                	add	a4,a4,a0
    8000555e:	6789                	lui	a5,0x2
    80005560:	97ba                	add	a5,a5,a4
    80005562:	4705                	li	a4,1
    80005564:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005568:	00022517          	auipc	a0,0x22
    8000556c:	ab050513          	addi	a0,a0,-1360 # 80027018 <disk+0x2018>
    80005570:	ffffc097          	auipc	ra,0xffffc
    80005574:	196080e7          	jalr	406(ra) # 80001706 <wakeup>
}
    80005578:	60a2                	ld	ra,8(sp)
    8000557a:	6402                	ld	s0,0(sp)
    8000557c:	0141                	addi	sp,sp,16
    8000557e:	8082                	ret
    panic("free_desc 1");
    80005580:	00003517          	auipc	a0,0x3
    80005584:	18850513          	addi	a0,a0,392 # 80008708 <syscalls+0x358>
    80005588:	00001097          	auipc	ra,0x1
    8000558c:	9c8080e7          	jalr	-1592(ra) # 80005f50 <panic>
    panic("free_desc 2");
    80005590:	00003517          	auipc	a0,0x3
    80005594:	18850513          	addi	a0,a0,392 # 80008718 <syscalls+0x368>
    80005598:	00001097          	auipc	ra,0x1
    8000559c:	9b8080e7          	jalr	-1608(ra) # 80005f50 <panic>

00000000800055a0 <virtio_disk_init>:
{
    800055a0:	1101                	addi	sp,sp,-32
    800055a2:	ec06                	sd	ra,24(sp)
    800055a4:	e822                	sd	s0,16(sp)
    800055a6:	e426                	sd	s1,8(sp)
    800055a8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055aa:	00003597          	auipc	a1,0x3
    800055ae:	17e58593          	addi	a1,a1,382 # 80008728 <syscalls+0x378>
    800055b2:	00022517          	auipc	a0,0x22
    800055b6:	b7650513          	addi	a0,a0,-1162 # 80027128 <disk+0x2128>
    800055ba:	00001097          	auipc	ra,0x1
    800055be:	e3e080e7          	jalr	-450(ra) # 800063f8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055c2:	100017b7          	lui	a5,0x10001
    800055c6:	4398                	lw	a4,0(a5)
    800055c8:	2701                	sext.w	a4,a4
    800055ca:	747277b7          	lui	a5,0x74727
    800055ce:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055d2:	0ef71063          	bne	a4,a5,800056b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800055d6:	100017b7          	lui	a5,0x10001
    800055da:	43dc                	lw	a5,4(a5)
    800055dc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055de:	4705                	li	a4,1
    800055e0:	0ce79963          	bne	a5,a4,800056b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055e4:	100017b7          	lui	a5,0x10001
    800055e8:	479c                	lw	a5,8(a5)
    800055ea:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800055ec:	4709                	li	a4,2
    800055ee:	0ce79263          	bne	a5,a4,800056b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055f2:	100017b7          	lui	a5,0x10001
    800055f6:	47d8                	lw	a4,12(a5)
    800055f8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055fa:	554d47b7          	lui	a5,0x554d4
    800055fe:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005602:	0af71863          	bne	a4,a5,800056b2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005606:	100017b7          	lui	a5,0x10001
    8000560a:	4705                	li	a4,1
    8000560c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000560e:	470d                	li	a4,3
    80005610:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005612:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005614:	c7ffe6b7          	lui	a3,0xc7ffe
    80005618:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fce51f>
    8000561c:	8f75                	and	a4,a4,a3
    8000561e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005620:	472d                	li	a4,11
    80005622:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005624:	473d                	li	a4,15
    80005626:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005628:	6705                	lui	a4,0x1
    8000562a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000562c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005630:	5bdc                	lw	a5,52(a5)
    80005632:	2781                	sext.w	a5,a5
  if(max == 0)
    80005634:	c7d9                	beqz	a5,800056c2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005636:	471d                	li	a4,7
    80005638:	08f77d63          	bgeu	a4,a5,800056d2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000563c:	100014b7          	lui	s1,0x10001
    80005640:	47a1                	li	a5,8
    80005642:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005644:	6609                	lui	a2,0x2
    80005646:	4581                	li	a1,0
    80005648:	00020517          	auipc	a0,0x20
    8000564c:	9b850513          	addi	a0,a0,-1608 # 80025000 <disk>
    80005650:	ffffb097          	auipc	ra,0xffffb
    80005654:	b2a080e7          	jalr	-1238(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005658:	00020717          	auipc	a4,0x20
    8000565c:	9a870713          	addi	a4,a4,-1624 # 80025000 <disk>
    80005660:	00c75793          	srli	a5,a4,0xc
    80005664:	2781                	sext.w	a5,a5
    80005666:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005668:	00022797          	auipc	a5,0x22
    8000566c:	99878793          	addi	a5,a5,-1640 # 80027000 <disk+0x2000>
    80005670:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005672:	00020717          	auipc	a4,0x20
    80005676:	a0e70713          	addi	a4,a4,-1522 # 80025080 <disk+0x80>
    8000567a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000567c:	00021717          	auipc	a4,0x21
    80005680:	98470713          	addi	a4,a4,-1660 # 80026000 <disk+0x1000>
    80005684:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005686:	4705                	li	a4,1
    80005688:	00e78c23          	sb	a4,24(a5)
    8000568c:	00e78ca3          	sb	a4,25(a5)
    80005690:	00e78d23          	sb	a4,26(a5)
    80005694:	00e78da3          	sb	a4,27(a5)
    80005698:	00e78e23          	sb	a4,28(a5)
    8000569c:	00e78ea3          	sb	a4,29(a5)
    800056a0:	00e78f23          	sb	a4,30(a5)
    800056a4:	00e78fa3          	sb	a4,31(a5)
}
    800056a8:	60e2                	ld	ra,24(sp)
    800056aa:	6442                	ld	s0,16(sp)
    800056ac:	64a2                	ld	s1,8(sp)
    800056ae:	6105                	addi	sp,sp,32
    800056b0:	8082                	ret
    panic("could not find virtio disk");
    800056b2:	00003517          	auipc	a0,0x3
    800056b6:	08650513          	addi	a0,a0,134 # 80008738 <syscalls+0x388>
    800056ba:	00001097          	auipc	ra,0x1
    800056be:	896080e7          	jalr	-1898(ra) # 80005f50 <panic>
    panic("virtio disk has no queue 0");
    800056c2:	00003517          	auipc	a0,0x3
    800056c6:	09650513          	addi	a0,a0,150 # 80008758 <syscalls+0x3a8>
    800056ca:	00001097          	auipc	ra,0x1
    800056ce:	886080e7          	jalr	-1914(ra) # 80005f50 <panic>
    panic("virtio disk max queue too short");
    800056d2:	00003517          	auipc	a0,0x3
    800056d6:	0a650513          	addi	a0,a0,166 # 80008778 <syscalls+0x3c8>
    800056da:	00001097          	auipc	ra,0x1
    800056de:	876080e7          	jalr	-1930(ra) # 80005f50 <panic>

00000000800056e2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800056e2:	7119                	addi	sp,sp,-128
    800056e4:	fc86                	sd	ra,120(sp)
    800056e6:	f8a2                	sd	s0,112(sp)
    800056e8:	f4a6                	sd	s1,104(sp)
    800056ea:	f0ca                	sd	s2,96(sp)
    800056ec:	ecce                	sd	s3,88(sp)
    800056ee:	e8d2                	sd	s4,80(sp)
    800056f0:	e4d6                	sd	s5,72(sp)
    800056f2:	e0da                	sd	s6,64(sp)
    800056f4:	fc5e                	sd	s7,56(sp)
    800056f6:	f862                	sd	s8,48(sp)
    800056f8:	f466                	sd	s9,40(sp)
    800056fa:	f06a                	sd	s10,32(sp)
    800056fc:	ec6e                	sd	s11,24(sp)
    800056fe:	0100                	addi	s0,sp,128
    80005700:	8aaa                	mv	s5,a0
    80005702:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005704:	00c52c83          	lw	s9,12(a0)
    80005708:	001c9c9b          	slliw	s9,s9,0x1
    8000570c:	1c82                	slli	s9,s9,0x20
    8000570e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005712:	00022517          	auipc	a0,0x22
    80005716:	a1650513          	addi	a0,a0,-1514 # 80027128 <disk+0x2128>
    8000571a:	00001097          	auipc	ra,0x1
    8000571e:	d6e080e7          	jalr	-658(ra) # 80006488 <acquire>
  for(int i = 0; i < 3; i++){
    80005722:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005724:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005726:	00020c17          	auipc	s8,0x20
    8000572a:	8dac0c13          	addi	s8,s8,-1830 # 80025000 <disk>
    8000572e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005730:	4b0d                	li	s6,3
    80005732:	a0ad                	j	8000579c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005734:	00fc0733          	add	a4,s8,a5
    80005738:	975e                	add	a4,a4,s7
    8000573a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000573e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005740:	0207c563          	bltz	a5,8000576a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005744:	2905                	addiw	s2,s2,1
    80005746:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005748:	19690c63          	beq	s2,s6,800058e0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000574c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000574e:	00022717          	auipc	a4,0x22
    80005752:	8ca70713          	addi	a4,a4,-1846 # 80027018 <disk+0x2018>
    80005756:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005758:	00074683          	lbu	a3,0(a4)
    8000575c:	fee1                	bnez	a3,80005734 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000575e:	2785                	addiw	a5,a5,1
    80005760:	0705                	addi	a4,a4,1
    80005762:	fe979be3          	bne	a5,s1,80005758 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005766:	57fd                	li	a5,-1
    80005768:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000576a:	01205d63          	blez	s2,80005784 <virtio_disk_rw+0xa2>
    8000576e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005770:	000a2503          	lw	a0,0(s4)
    80005774:	00000097          	auipc	ra,0x0
    80005778:	d92080e7          	jalr	-622(ra) # 80005506 <free_desc>
      for(int j = 0; j < i; j++)
    8000577c:	2d85                	addiw	s11,s11,1
    8000577e:	0a11                	addi	s4,s4,4
    80005780:	ff2d98e3          	bne	s11,s2,80005770 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005784:	00022597          	auipc	a1,0x22
    80005788:	9a458593          	addi	a1,a1,-1628 # 80027128 <disk+0x2128>
    8000578c:	00022517          	auipc	a0,0x22
    80005790:	88c50513          	addi	a0,a0,-1908 # 80027018 <disk+0x2018>
    80005794:	ffffc097          	auipc	ra,0xffffc
    80005798:	de6080e7          	jalr	-538(ra) # 8000157a <sleep>
  for(int i = 0; i < 3; i++){
    8000579c:	f8040a13          	addi	s4,s0,-128
{
    800057a0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800057a2:	894e                	mv	s2,s3
    800057a4:	b765                	j	8000574c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800057a6:	00022697          	auipc	a3,0x22
    800057aa:	85a6b683          	ld	a3,-1958(a3) # 80027000 <disk+0x2000>
    800057ae:	96ba                	add	a3,a3,a4
    800057b0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057b4:	00020817          	auipc	a6,0x20
    800057b8:	84c80813          	addi	a6,a6,-1972 # 80025000 <disk>
    800057bc:	00022697          	auipc	a3,0x22
    800057c0:	84468693          	addi	a3,a3,-1980 # 80027000 <disk+0x2000>
    800057c4:	6290                	ld	a2,0(a3)
    800057c6:	963a                	add	a2,a2,a4
    800057c8:	00c65583          	lhu	a1,12(a2)
    800057cc:	0015e593          	ori	a1,a1,1
    800057d0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800057d4:	f8842603          	lw	a2,-120(s0)
    800057d8:	628c                	ld	a1,0(a3)
    800057da:	972e                	add	a4,a4,a1
    800057dc:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800057e0:	20050593          	addi	a1,a0,512
    800057e4:	0592                	slli	a1,a1,0x4
    800057e6:	95c2                	add	a1,a1,a6
    800057e8:	577d                	li	a4,-1
    800057ea:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057ee:	00461713          	slli	a4,a2,0x4
    800057f2:	6290                	ld	a2,0(a3)
    800057f4:	963a                	add	a2,a2,a4
    800057f6:	03078793          	addi	a5,a5,48
    800057fa:	97c2                	add	a5,a5,a6
    800057fc:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800057fe:	629c                	ld	a5,0(a3)
    80005800:	97ba                	add	a5,a5,a4
    80005802:	4605                	li	a2,1
    80005804:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005806:	629c                	ld	a5,0(a3)
    80005808:	97ba                	add	a5,a5,a4
    8000580a:	4809                	li	a6,2
    8000580c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005810:	629c                	ld	a5,0(a3)
    80005812:	97ba                	add	a5,a5,a4
    80005814:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005818:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000581c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005820:	6698                	ld	a4,8(a3)
    80005822:	00275783          	lhu	a5,2(a4)
    80005826:	8b9d                	andi	a5,a5,7
    80005828:	0786                	slli	a5,a5,0x1
    8000582a:	973e                	add	a4,a4,a5
    8000582c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005830:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005834:	6698                	ld	a4,8(a3)
    80005836:	00275783          	lhu	a5,2(a4)
    8000583a:	2785                	addiw	a5,a5,1
    8000583c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005840:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005844:	100017b7          	lui	a5,0x10001
    80005848:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000584c:	004aa783          	lw	a5,4(s5)
    80005850:	02c79163          	bne	a5,a2,80005872 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005854:	00022917          	auipc	s2,0x22
    80005858:	8d490913          	addi	s2,s2,-1836 # 80027128 <disk+0x2128>
  while(b->disk == 1) {
    8000585c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000585e:	85ca                	mv	a1,s2
    80005860:	8556                	mv	a0,s5
    80005862:	ffffc097          	auipc	ra,0xffffc
    80005866:	d18080e7          	jalr	-744(ra) # 8000157a <sleep>
  while(b->disk == 1) {
    8000586a:	004aa783          	lw	a5,4(s5)
    8000586e:	fe9788e3          	beq	a5,s1,8000585e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005872:	f8042903          	lw	s2,-128(s0)
    80005876:	20090713          	addi	a4,s2,512
    8000587a:	0712                	slli	a4,a4,0x4
    8000587c:	0001f797          	auipc	a5,0x1f
    80005880:	78478793          	addi	a5,a5,1924 # 80025000 <disk>
    80005884:	97ba                	add	a5,a5,a4
    80005886:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000588a:	00021997          	auipc	s3,0x21
    8000588e:	77698993          	addi	s3,s3,1910 # 80027000 <disk+0x2000>
    80005892:	00491713          	slli	a4,s2,0x4
    80005896:	0009b783          	ld	a5,0(s3)
    8000589a:	97ba                	add	a5,a5,a4
    8000589c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058a0:	854a                	mv	a0,s2
    800058a2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800058a6:	00000097          	auipc	ra,0x0
    800058aa:	c60080e7          	jalr	-928(ra) # 80005506 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800058ae:	8885                	andi	s1,s1,1
    800058b0:	f0ed                	bnez	s1,80005892 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058b2:	00022517          	auipc	a0,0x22
    800058b6:	87650513          	addi	a0,a0,-1930 # 80027128 <disk+0x2128>
    800058ba:	00001097          	auipc	ra,0x1
    800058be:	c82080e7          	jalr	-894(ra) # 8000653c <release>
}
    800058c2:	70e6                	ld	ra,120(sp)
    800058c4:	7446                	ld	s0,112(sp)
    800058c6:	74a6                	ld	s1,104(sp)
    800058c8:	7906                	ld	s2,96(sp)
    800058ca:	69e6                	ld	s3,88(sp)
    800058cc:	6a46                	ld	s4,80(sp)
    800058ce:	6aa6                	ld	s5,72(sp)
    800058d0:	6b06                	ld	s6,64(sp)
    800058d2:	7be2                	ld	s7,56(sp)
    800058d4:	7c42                	ld	s8,48(sp)
    800058d6:	7ca2                	ld	s9,40(sp)
    800058d8:	7d02                	ld	s10,32(sp)
    800058da:	6de2                	ld	s11,24(sp)
    800058dc:	6109                	addi	sp,sp,128
    800058de:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058e0:	f8042503          	lw	a0,-128(s0)
    800058e4:	20050793          	addi	a5,a0,512
    800058e8:	0792                	slli	a5,a5,0x4
  if(write)
    800058ea:	0001f817          	auipc	a6,0x1f
    800058ee:	71680813          	addi	a6,a6,1814 # 80025000 <disk>
    800058f2:	00f80733          	add	a4,a6,a5
    800058f6:	01a036b3          	snez	a3,s10
    800058fa:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800058fe:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005902:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005906:	7679                	lui	a2,0xffffe
    80005908:	963e                	add	a2,a2,a5
    8000590a:	00021697          	auipc	a3,0x21
    8000590e:	6f668693          	addi	a3,a3,1782 # 80027000 <disk+0x2000>
    80005912:	6298                	ld	a4,0(a3)
    80005914:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005916:	0a878593          	addi	a1,a5,168
    8000591a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000591c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000591e:	6298                	ld	a4,0(a3)
    80005920:	9732                	add	a4,a4,a2
    80005922:	45c1                	li	a1,16
    80005924:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005926:	6298                	ld	a4,0(a3)
    80005928:	9732                	add	a4,a4,a2
    8000592a:	4585                	li	a1,1
    8000592c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005930:	f8442703          	lw	a4,-124(s0)
    80005934:	628c                	ld	a1,0(a3)
    80005936:	962e                	add	a2,a2,a1
    80005938:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcddce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000593c:	0712                	slli	a4,a4,0x4
    8000593e:	6290                	ld	a2,0(a3)
    80005940:	963a                	add	a2,a2,a4
    80005942:	058a8593          	addi	a1,s5,88
    80005946:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005948:	6294                	ld	a3,0(a3)
    8000594a:	96ba                	add	a3,a3,a4
    8000594c:	40000613          	li	a2,1024
    80005950:	c690                	sw	a2,8(a3)
  if(write)
    80005952:	e40d1ae3          	bnez	s10,800057a6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005956:	00021697          	auipc	a3,0x21
    8000595a:	6aa6b683          	ld	a3,1706(a3) # 80027000 <disk+0x2000>
    8000595e:	96ba                	add	a3,a3,a4
    80005960:	4609                	li	a2,2
    80005962:	00c69623          	sh	a2,12(a3)
    80005966:	b5b9                	j	800057b4 <virtio_disk_rw+0xd2>

0000000080005968 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005968:	1101                	addi	sp,sp,-32
    8000596a:	ec06                	sd	ra,24(sp)
    8000596c:	e822                	sd	s0,16(sp)
    8000596e:	e426                	sd	s1,8(sp)
    80005970:	e04a                	sd	s2,0(sp)
    80005972:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005974:	00021517          	auipc	a0,0x21
    80005978:	7b450513          	addi	a0,a0,1972 # 80027128 <disk+0x2128>
    8000597c:	00001097          	auipc	ra,0x1
    80005980:	b0c080e7          	jalr	-1268(ra) # 80006488 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005984:	10001737          	lui	a4,0x10001
    80005988:	533c                	lw	a5,96(a4)
    8000598a:	8b8d                	andi	a5,a5,3
    8000598c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000598e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005992:	00021797          	auipc	a5,0x21
    80005996:	66e78793          	addi	a5,a5,1646 # 80027000 <disk+0x2000>
    8000599a:	6b94                	ld	a3,16(a5)
    8000599c:	0207d703          	lhu	a4,32(a5)
    800059a0:	0026d783          	lhu	a5,2(a3)
    800059a4:	06f70163          	beq	a4,a5,80005a06 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059a8:	0001f917          	auipc	s2,0x1f
    800059ac:	65890913          	addi	s2,s2,1624 # 80025000 <disk>
    800059b0:	00021497          	auipc	s1,0x21
    800059b4:	65048493          	addi	s1,s1,1616 # 80027000 <disk+0x2000>
    __sync_synchronize();
    800059b8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059bc:	6898                	ld	a4,16(s1)
    800059be:	0204d783          	lhu	a5,32(s1)
    800059c2:	8b9d                	andi	a5,a5,7
    800059c4:	078e                	slli	a5,a5,0x3
    800059c6:	97ba                	add	a5,a5,a4
    800059c8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800059ca:	20078713          	addi	a4,a5,512
    800059ce:	0712                	slli	a4,a4,0x4
    800059d0:	974a                	add	a4,a4,s2
    800059d2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800059d6:	e731                	bnez	a4,80005a22 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800059d8:	20078793          	addi	a5,a5,512
    800059dc:	0792                	slli	a5,a5,0x4
    800059de:	97ca                	add	a5,a5,s2
    800059e0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800059e2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800059e6:	ffffc097          	auipc	ra,0xffffc
    800059ea:	d20080e7          	jalr	-736(ra) # 80001706 <wakeup>

    disk.used_idx += 1;
    800059ee:	0204d783          	lhu	a5,32(s1)
    800059f2:	2785                	addiw	a5,a5,1
    800059f4:	17c2                	slli	a5,a5,0x30
    800059f6:	93c1                	srli	a5,a5,0x30
    800059f8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800059fc:	6898                	ld	a4,16(s1)
    800059fe:	00275703          	lhu	a4,2(a4)
    80005a02:	faf71be3          	bne	a4,a5,800059b8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005a06:	00021517          	auipc	a0,0x21
    80005a0a:	72250513          	addi	a0,a0,1826 # 80027128 <disk+0x2128>
    80005a0e:	00001097          	auipc	ra,0x1
    80005a12:	b2e080e7          	jalr	-1234(ra) # 8000653c <release>
}
    80005a16:	60e2                	ld	ra,24(sp)
    80005a18:	6442                	ld	s0,16(sp)
    80005a1a:	64a2                	ld	s1,8(sp)
    80005a1c:	6902                	ld	s2,0(sp)
    80005a1e:	6105                	addi	sp,sp,32
    80005a20:	8082                	ret
      panic("virtio_disk_intr status");
    80005a22:	00003517          	auipc	a0,0x3
    80005a26:	d7650513          	addi	a0,a0,-650 # 80008798 <syscalls+0x3e8>
    80005a2a:	00000097          	auipc	ra,0x0
    80005a2e:	526080e7          	jalr	1318(ra) # 80005f50 <panic>

0000000080005a32 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005a32:	1141                	addi	sp,sp,-16
    80005a34:	e422                	sd	s0,8(sp)
    80005a36:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a38:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005a3c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005a40:	0037979b          	slliw	a5,a5,0x3
    80005a44:	02004737          	lui	a4,0x2004
    80005a48:	97ba                	add	a5,a5,a4
    80005a4a:	0200c737          	lui	a4,0x200c
    80005a4e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005a52:	000f4637          	lui	a2,0xf4
    80005a56:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005a5a:	9732                	add	a4,a4,a2
    80005a5c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005a5e:	00259693          	slli	a3,a1,0x2
    80005a62:	96ae                	add	a3,a3,a1
    80005a64:	068e                	slli	a3,a3,0x3
    80005a66:	00022717          	auipc	a4,0x22
    80005a6a:	59a70713          	addi	a4,a4,1434 # 80028000 <timer_scratch>
    80005a6e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005a70:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005a72:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005a74:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005a78:	00000797          	auipc	a5,0x0
    80005a7c:	9c878793          	addi	a5,a5,-1592 # 80005440 <timervec>
    80005a80:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a84:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a88:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a8c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005a90:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a94:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a98:	30479073          	csrw	mie,a5
}
    80005a9c:	6422                	ld	s0,8(sp)
    80005a9e:	0141                	addi	sp,sp,16
    80005aa0:	8082                	ret

0000000080005aa2 <start>:
{
    80005aa2:	1141                	addi	sp,sp,-16
    80005aa4:	e406                	sd	ra,8(sp)
    80005aa6:	e022                	sd	s0,0(sp)
    80005aa8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005aaa:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005aae:	7779                	lui	a4,0xffffe
    80005ab0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffce5bf>
    80005ab4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005ab6:	6705                	lui	a4,0x1
    80005ab8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005abc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005abe:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005ac2:	ffffb797          	auipc	a5,0xffffb
    80005ac6:	85e78793          	addi	a5,a5,-1954 # 80000320 <main>
    80005aca:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005ace:	4781                	li	a5,0
    80005ad0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005ad4:	67c1                	lui	a5,0x10
    80005ad6:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005ad8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005adc:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005ae0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005ae4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005ae8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005aec:	57fd                	li	a5,-1
    80005aee:	83a9                	srli	a5,a5,0xa
    80005af0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005af4:	47bd                	li	a5,15
    80005af6:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005afa:	00000097          	auipc	ra,0x0
    80005afe:	f38080e7          	jalr	-200(ra) # 80005a32 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b02:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b06:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b08:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b0a:	30200073          	mret
}
    80005b0e:	60a2                	ld	ra,8(sp)
    80005b10:	6402                	ld	s0,0(sp)
    80005b12:	0141                	addi	sp,sp,16
    80005b14:	8082                	ret

0000000080005b16 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005b16:	715d                	addi	sp,sp,-80
    80005b18:	e486                	sd	ra,72(sp)
    80005b1a:	e0a2                	sd	s0,64(sp)
    80005b1c:	fc26                	sd	s1,56(sp)
    80005b1e:	f84a                	sd	s2,48(sp)
    80005b20:	f44e                	sd	s3,40(sp)
    80005b22:	f052                	sd	s4,32(sp)
    80005b24:	ec56                	sd	s5,24(sp)
    80005b26:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005b28:	04c05763          	blez	a2,80005b76 <consolewrite+0x60>
    80005b2c:	8a2a                	mv	s4,a0
    80005b2e:	84ae                	mv	s1,a1
    80005b30:	89b2                	mv	s3,a2
    80005b32:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005b34:	5afd                	li	s5,-1
    80005b36:	4685                	li	a3,1
    80005b38:	8626                	mv	a2,s1
    80005b3a:	85d2                	mv	a1,s4
    80005b3c:	fbf40513          	addi	a0,s0,-65
    80005b40:	ffffc097          	auipc	ra,0xffffc
    80005b44:	e6e080e7          	jalr	-402(ra) # 800019ae <either_copyin>
    80005b48:	01550d63          	beq	a0,s5,80005b62 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005b4c:	fbf44503          	lbu	a0,-65(s0)
    80005b50:	00000097          	auipc	ra,0x0
    80005b54:	77e080e7          	jalr	1918(ra) # 800062ce <uartputc>
  for(i = 0; i < n; i++){
    80005b58:	2905                	addiw	s2,s2,1
    80005b5a:	0485                	addi	s1,s1,1
    80005b5c:	fd299de3          	bne	s3,s2,80005b36 <consolewrite+0x20>
    80005b60:	894e                	mv	s2,s3
  }

  return i;
}
    80005b62:	854a                	mv	a0,s2
    80005b64:	60a6                	ld	ra,72(sp)
    80005b66:	6406                	ld	s0,64(sp)
    80005b68:	74e2                	ld	s1,56(sp)
    80005b6a:	7942                	ld	s2,48(sp)
    80005b6c:	79a2                	ld	s3,40(sp)
    80005b6e:	7a02                	ld	s4,32(sp)
    80005b70:	6ae2                	ld	s5,24(sp)
    80005b72:	6161                	addi	sp,sp,80
    80005b74:	8082                	ret
  for(i = 0; i < n; i++){
    80005b76:	4901                	li	s2,0
    80005b78:	b7ed                	j	80005b62 <consolewrite+0x4c>

0000000080005b7a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005b7a:	7159                	addi	sp,sp,-112
    80005b7c:	f486                	sd	ra,104(sp)
    80005b7e:	f0a2                	sd	s0,96(sp)
    80005b80:	eca6                	sd	s1,88(sp)
    80005b82:	e8ca                	sd	s2,80(sp)
    80005b84:	e4ce                	sd	s3,72(sp)
    80005b86:	e0d2                	sd	s4,64(sp)
    80005b88:	fc56                	sd	s5,56(sp)
    80005b8a:	f85a                	sd	s6,48(sp)
    80005b8c:	f45e                	sd	s7,40(sp)
    80005b8e:	f062                	sd	s8,32(sp)
    80005b90:	ec66                	sd	s9,24(sp)
    80005b92:	e86a                	sd	s10,16(sp)
    80005b94:	1880                	addi	s0,sp,112
    80005b96:	8aaa                	mv	s5,a0
    80005b98:	8a2e                	mv	s4,a1
    80005b9a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b9c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005ba0:	0002a517          	auipc	a0,0x2a
    80005ba4:	5a050513          	addi	a0,a0,1440 # 80030140 <cons>
    80005ba8:	00001097          	auipc	ra,0x1
    80005bac:	8e0080e7          	jalr	-1824(ra) # 80006488 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005bb0:	0002a497          	auipc	s1,0x2a
    80005bb4:	59048493          	addi	s1,s1,1424 # 80030140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005bb8:	0002a917          	auipc	s2,0x2a
    80005bbc:	62090913          	addi	s2,s2,1568 # 800301d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005bc0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005bc2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005bc4:	4ca9                	li	s9,10
  while(n > 0){
    80005bc6:	07305863          	blez	s3,80005c36 <consoleread+0xbc>
    while(cons.r == cons.w){
    80005bca:	0984a783          	lw	a5,152(s1)
    80005bce:	09c4a703          	lw	a4,156(s1)
    80005bd2:	02f71463          	bne	a4,a5,80005bfa <consoleread+0x80>
      if(myproc()->killed){
    80005bd6:	ffffb097          	auipc	ra,0xffffb
    80005bda:	296080e7          	jalr	662(ra) # 80000e6c <myproc>
    80005bde:	551c                	lw	a5,40(a0)
    80005be0:	e7b5                	bnez	a5,80005c4c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005be2:	85a6                	mv	a1,s1
    80005be4:	854a                	mv	a0,s2
    80005be6:	ffffc097          	auipc	ra,0xffffc
    80005bea:	994080e7          	jalr	-1644(ra) # 8000157a <sleep>
    while(cons.r == cons.w){
    80005bee:	0984a783          	lw	a5,152(s1)
    80005bf2:	09c4a703          	lw	a4,156(s1)
    80005bf6:	fef700e3          	beq	a4,a5,80005bd6 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005bfa:	0017871b          	addiw	a4,a5,1
    80005bfe:	08e4ac23          	sw	a4,152(s1)
    80005c02:	07f7f713          	andi	a4,a5,127
    80005c06:	9726                	add	a4,a4,s1
    80005c08:	01874703          	lbu	a4,24(a4)
    80005c0c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005c10:	077d0563          	beq	s10,s7,80005c7a <consoleread+0x100>
    cbuf = c;
    80005c14:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c18:	4685                	li	a3,1
    80005c1a:	f9f40613          	addi	a2,s0,-97
    80005c1e:	85d2                	mv	a1,s4
    80005c20:	8556                	mv	a0,s5
    80005c22:	ffffc097          	auipc	ra,0xffffc
    80005c26:	d36080e7          	jalr	-714(ra) # 80001958 <either_copyout>
    80005c2a:	01850663          	beq	a0,s8,80005c36 <consoleread+0xbc>
    dst++;
    80005c2e:	0a05                	addi	s4,s4,1
    --n;
    80005c30:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005c32:	f99d1ae3          	bne	s10,s9,80005bc6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005c36:	0002a517          	auipc	a0,0x2a
    80005c3a:	50a50513          	addi	a0,a0,1290 # 80030140 <cons>
    80005c3e:	00001097          	auipc	ra,0x1
    80005c42:	8fe080e7          	jalr	-1794(ra) # 8000653c <release>

  return target - n;
    80005c46:	413b053b          	subw	a0,s6,s3
    80005c4a:	a811                	j	80005c5e <consoleread+0xe4>
        release(&cons.lock);
    80005c4c:	0002a517          	auipc	a0,0x2a
    80005c50:	4f450513          	addi	a0,a0,1268 # 80030140 <cons>
    80005c54:	00001097          	auipc	ra,0x1
    80005c58:	8e8080e7          	jalr	-1816(ra) # 8000653c <release>
        return -1;
    80005c5c:	557d                	li	a0,-1
}
    80005c5e:	70a6                	ld	ra,104(sp)
    80005c60:	7406                	ld	s0,96(sp)
    80005c62:	64e6                	ld	s1,88(sp)
    80005c64:	6946                	ld	s2,80(sp)
    80005c66:	69a6                	ld	s3,72(sp)
    80005c68:	6a06                	ld	s4,64(sp)
    80005c6a:	7ae2                	ld	s5,56(sp)
    80005c6c:	7b42                	ld	s6,48(sp)
    80005c6e:	7ba2                	ld	s7,40(sp)
    80005c70:	7c02                	ld	s8,32(sp)
    80005c72:	6ce2                	ld	s9,24(sp)
    80005c74:	6d42                	ld	s10,16(sp)
    80005c76:	6165                	addi	sp,sp,112
    80005c78:	8082                	ret
      if(n < target){
    80005c7a:	0009871b          	sext.w	a4,s3
    80005c7e:	fb677ce3          	bgeu	a4,s6,80005c36 <consoleread+0xbc>
        cons.r--;
    80005c82:	0002a717          	auipc	a4,0x2a
    80005c86:	54f72b23          	sw	a5,1366(a4) # 800301d8 <cons+0x98>
    80005c8a:	b775                	j	80005c36 <consoleread+0xbc>

0000000080005c8c <consputc>:
{
    80005c8c:	1141                	addi	sp,sp,-16
    80005c8e:	e406                	sd	ra,8(sp)
    80005c90:	e022                	sd	s0,0(sp)
    80005c92:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c94:	10000793          	li	a5,256
    80005c98:	00f50a63          	beq	a0,a5,80005cac <consputc+0x20>
    uartputc_sync(c);
    80005c9c:	00000097          	auipc	ra,0x0
    80005ca0:	560080e7          	jalr	1376(ra) # 800061fc <uartputc_sync>
}
    80005ca4:	60a2                	ld	ra,8(sp)
    80005ca6:	6402                	ld	s0,0(sp)
    80005ca8:	0141                	addi	sp,sp,16
    80005caa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005cac:	4521                	li	a0,8
    80005cae:	00000097          	auipc	ra,0x0
    80005cb2:	54e080e7          	jalr	1358(ra) # 800061fc <uartputc_sync>
    80005cb6:	02000513          	li	a0,32
    80005cba:	00000097          	auipc	ra,0x0
    80005cbe:	542080e7          	jalr	1346(ra) # 800061fc <uartputc_sync>
    80005cc2:	4521                	li	a0,8
    80005cc4:	00000097          	auipc	ra,0x0
    80005cc8:	538080e7          	jalr	1336(ra) # 800061fc <uartputc_sync>
    80005ccc:	bfe1                	j	80005ca4 <consputc+0x18>

0000000080005cce <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005cce:	1101                	addi	sp,sp,-32
    80005cd0:	ec06                	sd	ra,24(sp)
    80005cd2:	e822                	sd	s0,16(sp)
    80005cd4:	e426                	sd	s1,8(sp)
    80005cd6:	e04a                	sd	s2,0(sp)
    80005cd8:	1000                	addi	s0,sp,32
    80005cda:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005cdc:	0002a517          	auipc	a0,0x2a
    80005ce0:	46450513          	addi	a0,a0,1124 # 80030140 <cons>
    80005ce4:	00000097          	auipc	ra,0x0
    80005ce8:	7a4080e7          	jalr	1956(ra) # 80006488 <acquire>

  switch(c){
    80005cec:	47d5                	li	a5,21
    80005cee:	0af48663          	beq	s1,a5,80005d9a <consoleintr+0xcc>
    80005cf2:	0297ca63          	blt	a5,s1,80005d26 <consoleintr+0x58>
    80005cf6:	47a1                	li	a5,8
    80005cf8:	0ef48763          	beq	s1,a5,80005de6 <consoleintr+0x118>
    80005cfc:	47c1                	li	a5,16
    80005cfe:	10f49a63          	bne	s1,a5,80005e12 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005d02:	ffffc097          	auipc	ra,0xffffc
    80005d06:	d02080e7          	jalr	-766(ra) # 80001a04 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d0a:	0002a517          	auipc	a0,0x2a
    80005d0e:	43650513          	addi	a0,a0,1078 # 80030140 <cons>
    80005d12:	00001097          	auipc	ra,0x1
    80005d16:	82a080e7          	jalr	-2006(ra) # 8000653c <release>
}
    80005d1a:	60e2                	ld	ra,24(sp)
    80005d1c:	6442                	ld	s0,16(sp)
    80005d1e:	64a2                	ld	s1,8(sp)
    80005d20:	6902                	ld	s2,0(sp)
    80005d22:	6105                	addi	sp,sp,32
    80005d24:	8082                	ret
  switch(c){
    80005d26:	07f00793          	li	a5,127
    80005d2a:	0af48e63          	beq	s1,a5,80005de6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d2e:	0002a717          	auipc	a4,0x2a
    80005d32:	41270713          	addi	a4,a4,1042 # 80030140 <cons>
    80005d36:	0a072783          	lw	a5,160(a4)
    80005d3a:	09872703          	lw	a4,152(a4)
    80005d3e:	9f99                	subw	a5,a5,a4
    80005d40:	07f00713          	li	a4,127
    80005d44:	fcf763e3          	bltu	a4,a5,80005d0a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005d48:	47b5                	li	a5,13
    80005d4a:	0cf48763          	beq	s1,a5,80005e18 <consoleintr+0x14a>
      consputc(c);
    80005d4e:	8526                	mv	a0,s1
    80005d50:	00000097          	auipc	ra,0x0
    80005d54:	f3c080e7          	jalr	-196(ra) # 80005c8c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d58:	0002a797          	auipc	a5,0x2a
    80005d5c:	3e878793          	addi	a5,a5,1000 # 80030140 <cons>
    80005d60:	0a07a703          	lw	a4,160(a5)
    80005d64:	0017069b          	addiw	a3,a4,1
    80005d68:	0006861b          	sext.w	a2,a3
    80005d6c:	0ad7a023          	sw	a3,160(a5)
    80005d70:	07f77713          	andi	a4,a4,127
    80005d74:	97ba                	add	a5,a5,a4
    80005d76:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005d7a:	47a9                	li	a5,10
    80005d7c:	0cf48563          	beq	s1,a5,80005e46 <consoleintr+0x178>
    80005d80:	4791                	li	a5,4
    80005d82:	0cf48263          	beq	s1,a5,80005e46 <consoleintr+0x178>
    80005d86:	0002a797          	auipc	a5,0x2a
    80005d8a:	4527a783          	lw	a5,1106(a5) # 800301d8 <cons+0x98>
    80005d8e:	0807879b          	addiw	a5,a5,128
    80005d92:	f6f61ce3          	bne	a2,a5,80005d0a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d96:	863e                	mv	a2,a5
    80005d98:	a07d                	j	80005e46 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005d9a:	0002a717          	auipc	a4,0x2a
    80005d9e:	3a670713          	addi	a4,a4,934 # 80030140 <cons>
    80005da2:	0a072783          	lw	a5,160(a4)
    80005da6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005daa:	0002a497          	auipc	s1,0x2a
    80005dae:	39648493          	addi	s1,s1,918 # 80030140 <cons>
    while(cons.e != cons.w &&
    80005db2:	4929                	li	s2,10
    80005db4:	f4f70be3          	beq	a4,a5,80005d0a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005db8:	37fd                	addiw	a5,a5,-1
    80005dba:	07f7f713          	andi	a4,a5,127
    80005dbe:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005dc0:	01874703          	lbu	a4,24(a4)
    80005dc4:	f52703e3          	beq	a4,s2,80005d0a <consoleintr+0x3c>
      cons.e--;
    80005dc8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005dcc:	10000513          	li	a0,256
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	ebc080e7          	jalr	-324(ra) # 80005c8c <consputc>
    while(cons.e != cons.w &&
    80005dd8:	0a04a783          	lw	a5,160(s1)
    80005ddc:	09c4a703          	lw	a4,156(s1)
    80005de0:	fcf71ce3          	bne	a4,a5,80005db8 <consoleintr+0xea>
    80005de4:	b71d                	j	80005d0a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005de6:	0002a717          	auipc	a4,0x2a
    80005dea:	35a70713          	addi	a4,a4,858 # 80030140 <cons>
    80005dee:	0a072783          	lw	a5,160(a4)
    80005df2:	09c72703          	lw	a4,156(a4)
    80005df6:	f0f70ae3          	beq	a4,a5,80005d0a <consoleintr+0x3c>
      cons.e--;
    80005dfa:	37fd                	addiw	a5,a5,-1
    80005dfc:	0002a717          	auipc	a4,0x2a
    80005e00:	3ef72223          	sw	a5,996(a4) # 800301e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005e04:	10000513          	li	a0,256
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	e84080e7          	jalr	-380(ra) # 80005c8c <consputc>
    80005e10:	bded                	j	80005d0a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e12:	ee048ce3          	beqz	s1,80005d0a <consoleintr+0x3c>
    80005e16:	bf21                	j	80005d2e <consoleintr+0x60>
      consputc(c);
    80005e18:	4529                	li	a0,10
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	e72080e7          	jalr	-398(ra) # 80005c8c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e22:	0002a797          	auipc	a5,0x2a
    80005e26:	31e78793          	addi	a5,a5,798 # 80030140 <cons>
    80005e2a:	0a07a703          	lw	a4,160(a5)
    80005e2e:	0017069b          	addiw	a3,a4,1
    80005e32:	0006861b          	sext.w	a2,a3
    80005e36:	0ad7a023          	sw	a3,160(a5)
    80005e3a:	07f77713          	andi	a4,a4,127
    80005e3e:	97ba                	add	a5,a5,a4
    80005e40:	4729                	li	a4,10
    80005e42:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005e46:	0002a797          	auipc	a5,0x2a
    80005e4a:	38c7ab23          	sw	a2,918(a5) # 800301dc <cons+0x9c>
        wakeup(&cons.r);
    80005e4e:	0002a517          	auipc	a0,0x2a
    80005e52:	38a50513          	addi	a0,a0,906 # 800301d8 <cons+0x98>
    80005e56:	ffffc097          	auipc	ra,0xffffc
    80005e5a:	8b0080e7          	jalr	-1872(ra) # 80001706 <wakeup>
    80005e5e:	b575                	j	80005d0a <consoleintr+0x3c>

0000000080005e60 <consoleinit>:

void
consoleinit(void)
{
    80005e60:	1141                	addi	sp,sp,-16
    80005e62:	e406                	sd	ra,8(sp)
    80005e64:	e022                	sd	s0,0(sp)
    80005e66:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e68:	00003597          	auipc	a1,0x3
    80005e6c:	94858593          	addi	a1,a1,-1720 # 800087b0 <syscalls+0x400>
    80005e70:	0002a517          	auipc	a0,0x2a
    80005e74:	2d050513          	addi	a0,a0,720 # 80030140 <cons>
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	580080e7          	jalr	1408(ra) # 800063f8 <initlock>

  uartinit();
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	32c080e7          	jalr	812(ra) # 800061ac <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e88:	0001d797          	auipc	a5,0x1d
    80005e8c:	44078793          	addi	a5,a5,1088 # 800232c8 <devsw>
    80005e90:	00000717          	auipc	a4,0x0
    80005e94:	cea70713          	addi	a4,a4,-790 # 80005b7a <consoleread>
    80005e98:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e9a:	00000717          	auipc	a4,0x0
    80005e9e:	c7c70713          	addi	a4,a4,-900 # 80005b16 <consolewrite>
    80005ea2:	ef98                	sd	a4,24(a5)
}
    80005ea4:	60a2                	ld	ra,8(sp)
    80005ea6:	6402                	ld	s0,0(sp)
    80005ea8:	0141                	addi	sp,sp,16
    80005eaa:	8082                	ret

0000000080005eac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005eac:	7179                	addi	sp,sp,-48
    80005eae:	f406                	sd	ra,40(sp)
    80005eb0:	f022                	sd	s0,32(sp)
    80005eb2:	ec26                	sd	s1,24(sp)
    80005eb4:	e84a                	sd	s2,16(sp)
    80005eb6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005eb8:	c219                	beqz	a2,80005ebe <printint+0x12>
    80005eba:	08054763          	bltz	a0,80005f48 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005ebe:	2501                	sext.w	a0,a0
    80005ec0:	4881                	li	a7,0
    80005ec2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ec6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ec8:	2581                	sext.w	a1,a1
    80005eca:	00003617          	auipc	a2,0x3
    80005ece:	91660613          	addi	a2,a2,-1770 # 800087e0 <digits>
    80005ed2:	883a                	mv	a6,a4
    80005ed4:	2705                	addiw	a4,a4,1
    80005ed6:	02b577bb          	remuw	a5,a0,a1
    80005eda:	1782                	slli	a5,a5,0x20
    80005edc:	9381                	srli	a5,a5,0x20
    80005ede:	97b2                	add	a5,a5,a2
    80005ee0:	0007c783          	lbu	a5,0(a5)
    80005ee4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ee8:	0005079b          	sext.w	a5,a0
    80005eec:	02b5553b          	divuw	a0,a0,a1
    80005ef0:	0685                	addi	a3,a3,1
    80005ef2:	feb7f0e3          	bgeu	a5,a1,80005ed2 <printint+0x26>

  if(sign)
    80005ef6:	00088c63          	beqz	a7,80005f0e <printint+0x62>
    buf[i++] = '-';
    80005efa:	fe070793          	addi	a5,a4,-32
    80005efe:	00878733          	add	a4,a5,s0
    80005f02:	02d00793          	li	a5,45
    80005f06:	fef70823          	sb	a5,-16(a4)
    80005f0a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005f0e:	02e05763          	blez	a4,80005f3c <printint+0x90>
    80005f12:	fd040793          	addi	a5,s0,-48
    80005f16:	00e784b3          	add	s1,a5,a4
    80005f1a:	fff78913          	addi	s2,a5,-1
    80005f1e:	993a                	add	s2,s2,a4
    80005f20:	377d                	addiw	a4,a4,-1
    80005f22:	1702                	slli	a4,a4,0x20
    80005f24:	9301                	srli	a4,a4,0x20
    80005f26:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005f2a:	fff4c503          	lbu	a0,-1(s1)
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	d5e080e7          	jalr	-674(ra) # 80005c8c <consputc>
  while(--i >= 0)
    80005f36:	14fd                	addi	s1,s1,-1
    80005f38:	ff2499e3          	bne	s1,s2,80005f2a <printint+0x7e>
}
    80005f3c:	70a2                	ld	ra,40(sp)
    80005f3e:	7402                	ld	s0,32(sp)
    80005f40:	64e2                	ld	s1,24(sp)
    80005f42:	6942                	ld	s2,16(sp)
    80005f44:	6145                	addi	sp,sp,48
    80005f46:	8082                	ret
    x = -xx;
    80005f48:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005f4c:	4885                	li	a7,1
    x = -xx;
    80005f4e:	bf95                	j	80005ec2 <printint+0x16>

0000000080005f50 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005f50:	1101                	addi	sp,sp,-32
    80005f52:	ec06                	sd	ra,24(sp)
    80005f54:	e822                	sd	s0,16(sp)
    80005f56:	e426                	sd	s1,8(sp)
    80005f58:	1000                	addi	s0,sp,32
    80005f5a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f5c:	0002a797          	auipc	a5,0x2a
    80005f60:	2a07a223          	sw	zero,676(a5) # 80030200 <pr+0x18>
  printf("panic: ");
    80005f64:	00003517          	auipc	a0,0x3
    80005f68:	85450513          	addi	a0,a0,-1964 # 800087b8 <syscalls+0x408>
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	02e080e7          	jalr	46(ra) # 80005f9a <printf>
  printf(s);
    80005f74:	8526                	mv	a0,s1
    80005f76:	00000097          	auipc	ra,0x0
    80005f7a:	024080e7          	jalr	36(ra) # 80005f9a <printf>
  printf("\n");
    80005f7e:	00002517          	auipc	a0,0x2
    80005f82:	0ca50513          	addi	a0,a0,202 # 80008048 <etext+0x48>
    80005f86:	00000097          	auipc	ra,0x0
    80005f8a:	014080e7          	jalr	20(ra) # 80005f9a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f8e:	4785                	li	a5,1
    80005f90:	00003717          	auipc	a4,0x3
    80005f94:	08f72623          	sw	a5,140(a4) # 8000901c <panicked>
  for(;;)
    80005f98:	a001                	j	80005f98 <panic+0x48>

0000000080005f9a <printf>:
{
    80005f9a:	7131                	addi	sp,sp,-192
    80005f9c:	fc86                	sd	ra,120(sp)
    80005f9e:	f8a2                	sd	s0,112(sp)
    80005fa0:	f4a6                	sd	s1,104(sp)
    80005fa2:	f0ca                	sd	s2,96(sp)
    80005fa4:	ecce                	sd	s3,88(sp)
    80005fa6:	e8d2                	sd	s4,80(sp)
    80005fa8:	e4d6                	sd	s5,72(sp)
    80005faa:	e0da                	sd	s6,64(sp)
    80005fac:	fc5e                	sd	s7,56(sp)
    80005fae:	f862                	sd	s8,48(sp)
    80005fb0:	f466                	sd	s9,40(sp)
    80005fb2:	f06a                	sd	s10,32(sp)
    80005fb4:	ec6e                	sd	s11,24(sp)
    80005fb6:	0100                	addi	s0,sp,128
    80005fb8:	8a2a                	mv	s4,a0
    80005fba:	e40c                	sd	a1,8(s0)
    80005fbc:	e810                	sd	a2,16(s0)
    80005fbe:	ec14                	sd	a3,24(s0)
    80005fc0:	f018                	sd	a4,32(s0)
    80005fc2:	f41c                	sd	a5,40(s0)
    80005fc4:	03043823          	sd	a6,48(s0)
    80005fc8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005fcc:	0002ad97          	auipc	s11,0x2a
    80005fd0:	234dad83          	lw	s11,564(s11) # 80030200 <pr+0x18>
  if(locking)
    80005fd4:	020d9b63          	bnez	s11,8000600a <printf+0x70>
  if (fmt == 0)
    80005fd8:	040a0263          	beqz	s4,8000601c <printf+0x82>
  va_start(ap, fmt);
    80005fdc:	00840793          	addi	a5,s0,8
    80005fe0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fe4:	000a4503          	lbu	a0,0(s4)
    80005fe8:	14050f63          	beqz	a0,80006146 <printf+0x1ac>
    80005fec:	4981                	li	s3,0
    if(c != '%'){
    80005fee:	02500a93          	li	s5,37
    switch(c){
    80005ff2:	07000b93          	li	s7,112
  consputc('x');
    80005ff6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ff8:	00002b17          	auipc	s6,0x2
    80005ffc:	7e8b0b13          	addi	s6,s6,2024 # 800087e0 <digits>
    switch(c){
    80006000:	07300c93          	li	s9,115
    80006004:	06400c13          	li	s8,100
    80006008:	a82d                	j	80006042 <printf+0xa8>
    acquire(&pr.lock);
    8000600a:	0002a517          	auipc	a0,0x2a
    8000600e:	1de50513          	addi	a0,a0,478 # 800301e8 <pr>
    80006012:	00000097          	auipc	ra,0x0
    80006016:	476080e7          	jalr	1142(ra) # 80006488 <acquire>
    8000601a:	bf7d                	j	80005fd8 <printf+0x3e>
    panic("null fmt");
    8000601c:	00002517          	auipc	a0,0x2
    80006020:	7ac50513          	addi	a0,a0,1964 # 800087c8 <syscalls+0x418>
    80006024:	00000097          	auipc	ra,0x0
    80006028:	f2c080e7          	jalr	-212(ra) # 80005f50 <panic>
      consputc(c);
    8000602c:	00000097          	auipc	ra,0x0
    80006030:	c60080e7          	jalr	-928(ra) # 80005c8c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006034:	2985                	addiw	s3,s3,1
    80006036:	013a07b3          	add	a5,s4,s3
    8000603a:	0007c503          	lbu	a0,0(a5)
    8000603e:	10050463          	beqz	a0,80006146 <printf+0x1ac>
    if(c != '%'){
    80006042:	ff5515e3          	bne	a0,s5,8000602c <printf+0x92>
    c = fmt[++i] & 0xff;
    80006046:	2985                	addiw	s3,s3,1
    80006048:	013a07b3          	add	a5,s4,s3
    8000604c:	0007c783          	lbu	a5,0(a5)
    80006050:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006054:	cbed                	beqz	a5,80006146 <printf+0x1ac>
    switch(c){
    80006056:	05778a63          	beq	a5,s7,800060aa <printf+0x110>
    8000605a:	02fbf663          	bgeu	s7,a5,80006086 <printf+0xec>
    8000605e:	09978863          	beq	a5,s9,800060ee <printf+0x154>
    80006062:	07800713          	li	a4,120
    80006066:	0ce79563          	bne	a5,a4,80006130 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000606a:	f8843783          	ld	a5,-120(s0)
    8000606e:	00878713          	addi	a4,a5,8
    80006072:	f8e43423          	sd	a4,-120(s0)
    80006076:	4605                	li	a2,1
    80006078:	85ea                	mv	a1,s10
    8000607a:	4388                	lw	a0,0(a5)
    8000607c:	00000097          	auipc	ra,0x0
    80006080:	e30080e7          	jalr	-464(ra) # 80005eac <printint>
      break;
    80006084:	bf45                	j	80006034 <printf+0x9a>
    switch(c){
    80006086:	09578f63          	beq	a5,s5,80006124 <printf+0x18a>
    8000608a:	0b879363          	bne	a5,s8,80006130 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000608e:	f8843783          	ld	a5,-120(s0)
    80006092:	00878713          	addi	a4,a5,8
    80006096:	f8e43423          	sd	a4,-120(s0)
    8000609a:	4605                	li	a2,1
    8000609c:	45a9                	li	a1,10
    8000609e:	4388                	lw	a0,0(a5)
    800060a0:	00000097          	auipc	ra,0x0
    800060a4:	e0c080e7          	jalr	-500(ra) # 80005eac <printint>
      break;
    800060a8:	b771                	j	80006034 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800060aa:	f8843783          	ld	a5,-120(s0)
    800060ae:	00878713          	addi	a4,a5,8
    800060b2:	f8e43423          	sd	a4,-120(s0)
    800060b6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800060ba:	03000513          	li	a0,48
    800060be:	00000097          	auipc	ra,0x0
    800060c2:	bce080e7          	jalr	-1074(ra) # 80005c8c <consputc>
  consputc('x');
    800060c6:	07800513          	li	a0,120
    800060ca:	00000097          	auipc	ra,0x0
    800060ce:	bc2080e7          	jalr	-1086(ra) # 80005c8c <consputc>
    800060d2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060d4:	03c95793          	srli	a5,s2,0x3c
    800060d8:	97da                	add	a5,a5,s6
    800060da:	0007c503          	lbu	a0,0(a5)
    800060de:	00000097          	auipc	ra,0x0
    800060e2:	bae080e7          	jalr	-1106(ra) # 80005c8c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800060e6:	0912                	slli	s2,s2,0x4
    800060e8:	34fd                	addiw	s1,s1,-1
    800060ea:	f4ed                	bnez	s1,800060d4 <printf+0x13a>
    800060ec:	b7a1                	j	80006034 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800060ee:	f8843783          	ld	a5,-120(s0)
    800060f2:	00878713          	addi	a4,a5,8
    800060f6:	f8e43423          	sd	a4,-120(s0)
    800060fa:	6384                	ld	s1,0(a5)
    800060fc:	cc89                	beqz	s1,80006116 <printf+0x17c>
      for(; *s; s++)
    800060fe:	0004c503          	lbu	a0,0(s1)
    80006102:	d90d                	beqz	a0,80006034 <printf+0x9a>
        consputc(*s);
    80006104:	00000097          	auipc	ra,0x0
    80006108:	b88080e7          	jalr	-1144(ra) # 80005c8c <consputc>
      for(; *s; s++)
    8000610c:	0485                	addi	s1,s1,1
    8000610e:	0004c503          	lbu	a0,0(s1)
    80006112:	f96d                	bnez	a0,80006104 <printf+0x16a>
    80006114:	b705                	j	80006034 <printf+0x9a>
        s = "(null)";
    80006116:	00002497          	auipc	s1,0x2
    8000611a:	6aa48493          	addi	s1,s1,1706 # 800087c0 <syscalls+0x410>
      for(; *s; s++)
    8000611e:	02800513          	li	a0,40
    80006122:	b7cd                	j	80006104 <printf+0x16a>
      consputc('%');
    80006124:	8556                	mv	a0,s5
    80006126:	00000097          	auipc	ra,0x0
    8000612a:	b66080e7          	jalr	-1178(ra) # 80005c8c <consputc>
      break;
    8000612e:	b719                	j	80006034 <printf+0x9a>
      consputc('%');
    80006130:	8556                	mv	a0,s5
    80006132:	00000097          	auipc	ra,0x0
    80006136:	b5a080e7          	jalr	-1190(ra) # 80005c8c <consputc>
      consputc(c);
    8000613a:	8526                	mv	a0,s1
    8000613c:	00000097          	auipc	ra,0x0
    80006140:	b50080e7          	jalr	-1200(ra) # 80005c8c <consputc>
      break;
    80006144:	bdc5                	j	80006034 <printf+0x9a>
  if(locking)
    80006146:	020d9163          	bnez	s11,80006168 <printf+0x1ce>
}
    8000614a:	70e6                	ld	ra,120(sp)
    8000614c:	7446                	ld	s0,112(sp)
    8000614e:	74a6                	ld	s1,104(sp)
    80006150:	7906                	ld	s2,96(sp)
    80006152:	69e6                	ld	s3,88(sp)
    80006154:	6a46                	ld	s4,80(sp)
    80006156:	6aa6                	ld	s5,72(sp)
    80006158:	6b06                	ld	s6,64(sp)
    8000615a:	7be2                	ld	s7,56(sp)
    8000615c:	7c42                	ld	s8,48(sp)
    8000615e:	7ca2                	ld	s9,40(sp)
    80006160:	7d02                	ld	s10,32(sp)
    80006162:	6de2                	ld	s11,24(sp)
    80006164:	6129                	addi	sp,sp,192
    80006166:	8082                	ret
    release(&pr.lock);
    80006168:	0002a517          	auipc	a0,0x2a
    8000616c:	08050513          	addi	a0,a0,128 # 800301e8 <pr>
    80006170:	00000097          	auipc	ra,0x0
    80006174:	3cc080e7          	jalr	972(ra) # 8000653c <release>
}
    80006178:	bfc9                	j	8000614a <printf+0x1b0>

000000008000617a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000617a:	1101                	addi	sp,sp,-32
    8000617c:	ec06                	sd	ra,24(sp)
    8000617e:	e822                	sd	s0,16(sp)
    80006180:	e426                	sd	s1,8(sp)
    80006182:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006184:	0002a497          	auipc	s1,0x2a
    80006188:	06448493          	addi	s1,s1,100 # 800301e8 <pr>
    8000618c:	00002597          	auipc	a1,0x2
    80006190:	64c58593          	addi	a1,a1,1612 # 800087d8 <syscalls+0x428>
    80006194:	8526                	mv	a0,s1
    80006196:	00000097          	auipc	ra,0x0
    8000619a:	262080e7          	jalr	610(ra) # 800063f8 <initlock>
  pr.locking = 1;
    8000619e:	4785                	li	a5,1
    800061a0:	cc9c                	sw	a5,24(s1)
}
    800061a2:	60e2                	ld	ra,24(sp)
    800061a4:	6442                	ld	s0,16(sp)
    800061a6:	64a2                	ld	s1,8(sp)
    800061a8:	6105                	addi	sp,sp,32
    800061aa:	8082                	ret

00000000800061ac <uartinit>:

void uartstart();

void
uartinit(void)
{
    800061ac:	1141                	addi	sp,sp,-16
    800061ae:	e406                	sd	ra,8(sp)
    800061b0:	e022                	sd	s0,0(sp)
    800061b2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800061b4:	100007b7          	lui	a5,0x10000
    800061b8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800061bc:	f8000713          	li	a4,-128
    800061c0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800061c4:	470d                	li	a4,3
    800061c6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800061ca:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800061ce:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800061d2:	469d                	li	a3,7
    800061d4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800061d8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800061dc:	00002597          	auipc	a1,0x2
    800061e0:	61c58593          	addi	a1,a1,1564 # 800087f8 <digits+0x18>
    800061e4:	0002a517          	auipc	a0,0x2a
    800061e8:	02450513          	addi	a0,a0,36 # 80030208 <uart_tx_lock>
    800061ec:	00000097          	auipc	ra,0x0
    800061f0:	20c080e7          	jalr	524(ra) # 800063f8 <initlock>
}
    800061f4:	60a2                	ld	ra,8(sp)
    800061f6:	6402                	ld	s0,0(sp)
    800061f8:	0141                	addi	sp,sp,16
    800061fa:	8082                	ret

00000000800061fc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800061fc:	1101                	addi	sp,sp,-32
    800061fe:	ec06                	sd	ra,24(sp)
    80006200:	e822                	sd	s0,16(sp)
    80006202:	e426                	sd	s1,8(sp)
    80006204:	1000                	addi	s0,sp,32
    80006206:	84aa                	mv	s1,a0
  push_off();
    80006208:	00000097          	auipc	ra,0x0
    8000620c:	234080e7          	jalr	564(ra) # 8000643c <push_off>

  if(panicked){
    80006210:	00003797          	auipc	a5,0x3
    80006214:	e0c7a783          	lw	a5,-500(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006218:	10000737          	lui	a4,0x10000
  if(panicked){
    8000621c:	c391                	beqz	a5,80006220 <uartputc_sync+0x24>
    for(;;)
    8000621e:	a001                	j	8000621e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006220:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006224:	0207f793          	andi	a5,a5,32
    80006228:	dfe5                	beqz	a5,80006220 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000622a:	0ff4f513          	zext.b	a0,s1
    8000622e:	100007b7          	lui	a5,0x10000
    80006232:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006236:	00000097          	auipc	ra,0x0
    8000623a:	2a6080e7          	jalr	678(ra) # 800064dc <pop_off>
}
    8000623e:	60e2                	ld	ra,24(sp)
    80006240:	6442                	ld	s0,16(sp)
    80006242:	64a2                	ld	s1,8(sp)
    80006244:	6105                	addi	sp,sp,32
    80006246:	8082                	ret

0000000080006248 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006248:	00003797          	auipc	a5,0x3
    8000624c:	dd87b783          	ld	a5,-552(a5) # 80009020 <uart_tx_r>
    80006250:	00003717          	auipc	a4,0x3
    80006254:	dd873703          	ld	a4,-552(a4) # 80009028 <uart_tx_w>
    80006258:	06f70a63          	beq	a4,a5,800062cc <uartstart+0x84>
{
    8000625c:	7139                	addi	sp,sp,-64
    8000625e:	fc06                	sd	ra,56(sp)
    80006260:	f822                	sd	s0,48(sp)
    80006262:	f426                	sd	s1,40(sp)
    80006264:	f04a                	sd	s2,32(sp)
    80006266:	ec4e                	sd	s3,24(sp)
    80006268:	e852                	sd	s4,16(sp)
    8000626a:	e456                	sd	s5,8(sp)
    8000626c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000626e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006272:	0002aa17          	auipc	s4,0x2a
    80006276:	f96a0a13          	addi	s4,s4,-106 # 80030208 <uart_tx_lock>
    uart_tx_r += 1;
    8000627a:	00003497          	auipc	s1,0x3
    8000627e:	da648493          	addi	s1,s1,-602 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006282:	00003997          	auipc	s3,0x3
    80006286:	da698993          	addi	s3,s3,-602 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000628a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000628e:	02077713          	andi	a4,a4,32
    80006292:	c705                	beqz	a4,800062ba <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006294:	01f7f713          	andi	a4,a5,31
    80006298:	9752                	add	a4,a4,s4
    8000629a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000629e:	0785                	addi	a5,a5,1
    800062a0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800062a2:	8526                	mv	a0,s1
    800062a4:	ffffb097          	auipc	ra,0xffffb
    800062a8:	462080e7          	jalr	1122(ra) # 80001706 <wakeup>
    
    WriteReg(THR, c);
    800062ac:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800062b0:	609c                	ld	a5,0(s1)
    800062b2:	0009b703          	ld	a4,0(s3)
    800062b6:	fcf71ae3          	bne	a4,a5,8000628a <uartstart+0x42>
  }
}
    800062ba:	70e2                	ld	ra,56(sp)
    800062bc:	7442                	ld	s0,48(sp)
    800062be:	74a2                	ld	s1,40(sp)
    800062c0:	7902                	ld	s2,32(sp)
    800062c2:	69e2                	ld	s3,24(sp)
    800062c4:	6a42                	ld	s4,16(sp)
    800062c6:	6aa2                	ld	s5,8(sp)
    800062c8:	6121                	addi	sp,sp,64
    800062ca:	8082                	ret
    800062cc:	8082                	ret

00000000800062ce <uartputc>:
{
    800062ce:	7179                	addi	sp,sp,-48
    800062d0:	f406                	sd	ra,40(sp)
    800062d2:	f022                	sd	s0,32(sp)
    800062d4:	ec26                	sd	s1,24(sp)
    800062d6:	e84a                	sd	s2,16(sp)
    800062d8:	e44e                	sd	s3,8(sp)
    800062da:	e052                	sd	s4,0(sp)
    800062dc:	1800                	addi	s0,sp,48
    800062de:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800062e0:	0002a517          	auipc	a0,0x2a
    800062e4:	f2850513          	addi	a0,a0,-216 # 80030208 <uart_tx_lock>
    800062e8:	00000097          	auipc	ra,0x0
    800062ec:	1a0080e7          	jalr	416(ra) # 80006488 <acquire>
  if(panicked){
    800062f0:	00003797          	auipc	a5,0x3
    800062f4:	d2c7a783          	lw	a5,-724(a5) # 8000901c <panicked>
    800062f8:	c391                	beqz	a5,800062fc <uartputc+0x2e>
    for(;;)
    800062fa:	a001                	j	800062fa <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062fc:	00003717          	auipc	a4,0x3
    80006300:	d2c73703          	ld	a4,-724(a4) # 80009028 <uart_tx_w>
    80006304:	00003797          	auipc	a5,0x3
    80006308:	d1c7b783          	ld	a5,-740(a5) # 80009020 <uart_tx_r>
    8000630c:	02078793          	addi	a5,a5,32
    80006310:	02e79b63          	bne	a5,a4,80006346 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006314:	0002a997          	auipc	s3,0x2a
    80006318:	ef498993          	addi	s3,s3,-268 # 80030208 <uart_tx_lock>
    8000631c:	00003497          	auipc	s1,0x3
    80006320:	d0448493          	addi	s1,s1,-764 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006324:	00003917          	auipc	s2,0x3
    80006328:	d0490913          	addi	s2,s2,-764 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000632c:	85ce                	mv	a1,s3
    8000632e:	8526                	mv	a0,s1
    80006330:	ffffb097          	auipc	ra,0xffffb
    80006334:	24a080e7          	jalr	586(ra) # 8000157a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006338:	00093703          	ld	a4,0(s2)
    8000633c:	609c                	ld	a5,0(s1)
    8000633e:	02078793          	addi	a5,a5,32
    80006342:	fee785e3          	beq	a5,a4,8000632c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006346:	0002a497          	auipc	s1,0x2a
    8000634a:	ec248493          	addi	s1,s1,-318 # 80030208 <uart_tx_lock>
    8000634e:	01f77793          	andi	a5,a4,31
    80006352:	97a6                	add	a5,a5,s1
    80006354:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006358:	0705                	addi	a4,a4,1
    8000635a:	00003797          	auipc	a5,0x3
    8000635e:	cce7b723          	sd	a4,-818(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006362:	00000097          	auipc	ra,0x0
    80006366:	ee6080e7          	jalr	-282(ra) # 80006248 <uartstart>
      release(&uart_tx_lock);
    8000636a:	8526                	mv	a0,s1
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	1d0080e7          	jalr	464(ra) # 8000653c <release>
}
    80006374:	70a2                	ld	ra,40(sp)
    80006376:	7402                	ld	s0,32(sp)
    80006378:	64e2                	ld	s1,24(sp)
    8000637a:	6942                	ld	s2,16(sp)
    8000637c:	69a2                	ld	s3,8(sp)
    8000637e:	6a02                	ld	s4,0(sp)
    80006380:	6145                	addi	sp,sp,48
    80006382:	8082                	ret

0000000080006384 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006384:	1141                	addi	sp,sp,-16
    80006386:	e422                	sd	s0,8(sp)
    80006388:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000638a:	100007b7          	lui	a5,0x10000
    8000638e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006392:	8b85                	andi	a5,a5,1
    80006394:	cb81                	beqz	a5,800063a4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006396:	100007b7          	lui	a5,0x10000
    8000639a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000639e:	6422                	ld	s0,8(sp)
    800063a0:	0141                	addi	sp,sp,16
    800063a2:	8082                	ret
    return -1;
    800063a4:	557d                	li	a0,-1
    800063a6:	bfe5                	j	8000639e <uartgetc+0x1a>

00000000800063a8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800063a8:	1101                	addi	sp,sp,-32
    800063aa:	ec06                	sd	ra,24(sp)
    800063ac:	e822                	sd	s0,16(sp)
    800063ae:	e426                	sd	s1,8(sp)
    800063b0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800063b2:	54fd                	li	s1,-1
    800063b4:	a029                	j	800063be <uartintr+0x16>
      break;
    consoleintr(c);
    800063b6:	00000097          	auipc	ra,0x0
    800063ba:	918080e7          	jalr	-1768(ra) # 80005cce <consoleintr>
    int c = uartgetc();
    800063be:	00000097          	auipc	ra,0x0
    800063c2:	fc6080e7          	jalr	-58(ra) # 80006384 <uartgetc>
    if(c == -1)
    800063c6:	fe9518e3          	bne	a0,s1,800063b6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800063ca:	0002a497          	auipc	s1,0x2a
    800063ce:	e3e48493          	addi	s1,s1,-450 # 80030208 <uart_tx_lock>
    800063d2:	8526                	mv	a0,s1
    800063d4:	00000097          	auipc	ra,0x0
    800063d8:	0b4080e7          	jalr	180(ra) # 80006488 <acquire>
  uartstart();
    800063dc:	00000097          	auipc	ra,0x0
    800063e0:	e6c080e7          	jalr	-404(ra) # 80006248 <uartstart>
  release(&uart_tx_lock);
    800063e4:	8526                	mv	a0,s1
    800063e6:	00000097          	auipc	ra,0x0
    800063ea:	156080e7          	jalr	342(ra) # 8000653c <release>
}
    800063ee:	60e2                	ld	ra,24(sp)
    800063f0:	6442                	ld	s0,16(sp)
    800063f2:	64a2                	ld	s1,8(sp)
    800063f4:	6105                	addi	sp,sp,32
    800063f6:	8082                	ret

00000000800063f8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800063f8:	1141                	addi	sp,sp,-16
    800063fa:	e422                	sd	s0,8(sp)
    800063fc:	0800                	addi	s0,sp,16
  lk->name = name;
    800063fe:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006400:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006404:	00053823          	sd	zero,16(a0)
}
    80006408:	6422                	ld	s0,8(sp)
    8000640a:	0141                	addi	sp,sp,16
    8000640c:	8082                	ret

000000008000640e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000640e:	411c                	lw	a5,0(a0)
    80006410:	e399                	bnez	a5,80006416 <holding+0x8>
    80006412:	4501                	li	a0,0
  return r;
}
    80006414:	8082                	ret
{
    80006416:	1101                	addi	sp,sp,-32
    80006418:	ec06                	sd	ra,24(sp)
    8000641a:	e822                	sd	s0,16(sp)
    8000641c:	e426                	sd	s1,8(sp)
    8000641e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006420:	6904                	ld	s1,16(a0)
    80006422:	ffffb097          	auipc	ra,0xffffb
    80006426:	a2e080e7          	jalr	-1490(ra) # 80000e50 <mycpu>
    8000642a:	40a48533          	sub	a0,s1,a0
    8000642e:	00153513          	seqz	a0,a0
}
    80006432:	60e2                	ld	ra,24(sp)
    80006434:	6442                	ld	s0,16(sp)
    80006436:	64a2                	ld	s1,8(sp)
    80006438:	6105                	addi	sp,sp,32
    8000643a:	8082                	ret

000000008000643c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000643c:	1101                	addi	sp,sp,-32
    8000643e:	ec06                	sd	ra,24(sp)
    80006440:	e822                	sd	s0,16(sp)
    80006442:	e426                	sd	s1,8(sp)
    80006444:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006446:	100024f3          	csrr	s1,sstatus
    8000644a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000644e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006450:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006454:	ffffb097          	auipc	ra,0xffffb
    80006458:	9fc080e7          	jalr	-1540(ra) # 80000e50 <mycpu>
    8000645c:	5d3c                	lw	a5,120(a0)
    8000645e:	cf89                	beqz	a5,80006478 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006460:	ffffb097          	auipc	ra,0xffffb
    80006464:	9f0080e7          	jalr	-1552(ra) # 80000e50 <mycpu>
    80006468:	5d3c                	lw	a5,120(a0)
    8000646a:	2785                	addiw	a5,a5,1
    8000646c:	dd3c                	sw	a5,120(a0)
}
    8000646e:	60e2                	ld	ra,24(sp)
    80006470:	6442                	ld	s0,16(sp)
    80006472:	64a2                	ld	s1,8(sp)
    80006474:	6105                	addi	sp,sp,32
    80006476:	8082                	ret
    mycpu()->intena = old;
    80006478:	ffffb097          	auipc	ra,0xffffb
    8000647c:	9d8080e7          	jalr	-1576(ra) # 80000e50 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006480:	8085                	srli	s1,s1,0x1
    80006482:	8885                	andi	s1,s1,1
    80006484:	dd64                	sw	s1,124(a0)
    80006486:	bfe9                	j	80006460 <push_off+0x24>

0000000080006488 <acquire>:
{
    80006488:	1101                	addi	sp,sp,-32
    8000648a:	ec06                	sd	ra,24(sp)
    8000648c:	e822                	sd	s0,16(sp)
    8000648e:	e426                	sd	s1,8(sp)
    80006490:	1000                	addi	s0,sp,32
    80006492:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006494:	00000097          	auipc	ra,0x0
    80006498:	fa8080e7          	jalr	-88(ra) # 8000643c <push_off>
  if(holding(lk))
    8000649c:	8526                	mv	a0,s1
    8000649e:	00000097          	auipc	ra,0x0
    800064a2:	f70080e7          	jalr	-144(ra) # 8000640e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064a6:	4705                	li	a4,1
  if(holding(lk))
    800064a8:	e115                	bnez	a0,800064cc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064aa:	87ba                	mv	a5,a4
    800064ac:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800064b0:	2781                	sext.w	a5,a5
    800064b2:	ffe5                	bnez	a5,800064aa <acquire+0x22>
  __sync_synchronize();
    800064b4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800064b8:	ffffb097          	auipc	ra,0xffffb
    800064bc:	998080e7          	jalr	-1640(ra) # 80000e50 <mycpu>
    800064c0:	e888                	sd	a0,16(s1)
}
    800064c2:	60e2                	ld	ra,24(sp)
    800064c4:	6442                	ld	s0,16(sp)
    800064c6:	64a2                	ld	s1,8(sp)
    800064c8:	6105                	addi	sp,sp,32
    800064ca:	8082                	ret
    panic("acquire");
    800064cc:	00002517          	auipc	a0,0x2
    800064d0:	33450513          	addi	a0,a0,820 # 80008800 <digits+0x20>
    800064d4:	00000097          	auipc	ra,0x0
    800064d8:	a7c080e7          	jalr	-1412(ra) # 80005f50 <panic>

00000000800064dc <pop_off>:

void
pop_off(void)
{
    800064dc:	1141                	addi	sp,sp,-16
    800064de:	e406                	sd	ra,8(sp)
    800064e0:	e022                	sd	s0,0(sp)
    800064e2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800064e4:	ffffb097          	auipc	ra,0xffffb
    800064e8:	96c080e7          	jalr	-1684(ra) # 80000e50 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064ec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800064f0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800064f2:	e78d                	bnez	a5,8000651c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800064f4:	5d3c                	lw	a5,120(a0)
    800064f6:	02f05b63          	blez	a5,8000652c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800064fa:	37fd                	addiw	a5,a5,-1
    800064fc:	0007871b          	sext.w	a4,a5
    80006500:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006502:	eb09                	bnez	a4,80006514 <pop_off+0x38>
    80006504:	5d7c                	lw	a5,124(a0)
    80006506:	c799                	beqz	a5,80006514 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006508:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000650c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006510:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006514:	60a2                	ld	ra,8(sp)
    80006516:	6402                	ld	s0,0(sp)
    80006518:	0141                	addi	sp,sp,16
    8000651a:	8082                	ret
    panic("pop_off - interruptible");
    8000651c:	00002517          	auipc	a0,0x2
    80006520:	2ec50513          	addi	a0,a0,748 # 80008808 <digits+0x28>
    80006524:	00000097          	auipc	ra,0x0
    80006528:	a2c080e7          	jalr	-1492(ra) # 80005f50 <panic>
    panic("pop_off");
    8000652c:	00002517          	auipc	a0,0x2
    80006530:	2f450513          	addi	a0,a0,756 # 80008820 <digits+0x40>
    80006534:	00000097          	auipc	ra,0x0
    80006538:	a1c080e7          	jalr	-1508(ra) # 80005f50 <panic>

000000008000653c <release>:
{
    8000653c:	1101                	addi	sp,sp,-32
    8000653e:	ec06                	sd	ra,24(sp)
    80006540:	e822                	sd	s0,16(sp)
    80006542:	e426                	sd	s1,8(sp)
    80006544:	1000                	addi	s0,sp,32
    80006546:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006548:	00000097          	auipc	ra,0x0
    8000654c:	ec6080e7          	jalr	-314(ra) # 8000640e <holding>
    80006550:	c115                	beqz	a0,80006574 <release+0x38>
  lk->cpu = 0;
    80006552:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006556:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000655a:	0f50000f          	fence	iorw,ow
    8000655e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006562:	00000097          	auipc	ra,0x0
    80006566:	f7a080e7          	jalr	-134(ra) # 800064dc <pop_off>
}
    8000656a:	60e2                	ld	ra,24(sp)
    8000656c:	6442                	ld	s0,16(sp)
    8000656e:	64a2                	ld	s1,8(sp)
    80006570:	6105                	addi	sp,sp,32
    80006572:	8082                	ret
    panic("release");
    80006574:	00002517          	auipc	a0,0x2
    80006578:	2b450513          	addi	a0,a0,692 # 80008828 <digits+0x48>
    8000657c:	00000097          	auipc	ra,0x0
    80006580:	9d4080e7          	jalr	-1580(ra) # 80005f50 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
