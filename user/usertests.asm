
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <opentest>:

// simple file system tests

void
opentest(char *s)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	1000                	addi	s0,sp,32
       a:	84aa                	mv	s1,a0
  int fd;

  fd = open("echo", 0);
       c:	4581                	li	a1,0
       e:	00006517          	auipc	a0,0x6
      12:	d4a50513          	addi	a0,a0,-694 # 5d58 <malloc+0xe8>
      16:	00006097          	auipc	ra,0x6
      1a:	858080e7          	jalr	-1960(ra) # 586e <open>
  if(fd < 0){
      1e:	02054663          	bltz	a0,4a <opentest+0x4a>
    printf("%s: open echo failed!\n", s);
    exit(1);
  }
  close(fd);
      22:	00006097          	auipc	ra,0x6
      26:	834080e7          	jalr	-1996(ra) # 5856 <close>
  fd = open("doesnotexist", 0);
      2a:	4581                	li	a1,0
      2c:	00006517          	auipc	a0,0x6
      30:	d4c50513          	addi	a0,a0,-692 # 5d78 <malloc+0x108>
      34:	00006097          	auipc	ra,0x6
      38:	83a080e7          	jalr	-1990(ra) # 586e <open>
  if(fd >= 0){
      3c:	02055563          	bgez	a0,66 <opentest+0x66>
    printf("%s: open doesnotexist succeeded!\n", s);
    exit(1);
  }
}
      40:	60e2                	ld	ra,24(sp)
      42:	6442                	ld	s0,16(sp)
      44:	64a2                	ld	s1,8(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret
    printf("%s: open echo failed!\n", s);
      4a:	85a6                	mv	a1,s1
      4c:	00006517          	auipc	a0,0x6
      50:	d1450513          	addi	a0,a0,-748 # 5d60 <malloc+0xf0>
      54:	00006097          	auipc	ra,0x6
      58:	b64080e7          	jalr	-1180(ra) # 5bb8 <printf>
    exit(1);
      5c:	4505                	li	a0,1
      5e:	00005097          	auipc	ra,0x5
      62:	7d0080e7          	jalr	2000(ra) # 582e <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
      66:	85a6                	mv	a1,s1
      68:	00006517          	auipc	a0,0x6
      6c:	d2050513          	addi	a0,a0,-736 # 5d88 <malloc+0x118>
      70:	00006097          	auipc	ra,0x6
      74:	b48080e7          	jalr	-1208(ra) # 5bb8 <printf>
    exit(1);
      78:	4505                	li	a0,1
      7a:	00005097          	auipc	ra,0x5
      7e:	7b4080e7          	jalr	1972(ra) # 582e <exit>

0000000000000082 <createtest>:
}

// many creates, followed by unlink test
void
createtest(char *s)
{
      82:	7179                	addi	sp,sp,-48
      84:	f406                	sd	ra,40(sp)
      86:	f022                	sd	s0,32(sp)
      88:	ec26                	sd	s1,24(sp)
      8a:	e84a                	sd	s2,16(sp)
      8c:	1800                	addi	s0,sp,48
  int i, fd;
  enum { N=52 };

  char name[3];
  name[0] = 'a';
      8e:	06100793          	li	a5,97
      92:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
      96:	fc040d23          	sb	zero,-38(s0)
      9a:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
      9e:	06400913          	li	s2,100
    name[1] = '0' + i;
      a2:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
      a6:	20200593          	li	a1,514
      aa:	fd840513          	addi	a0,s0,-40
      ae:	00005097          	auipc	ra,0x5
      b2:	7c0080e7          	jalr	1984(ra) # 586e <open>
    close(fd);
      b6:	00005097          	auipc	ra,0x5
      ba:	7a0080e7          	jalr	1952(ra) # 5856 <close>
  for(i = 0; i < N; i++){
      be:	2485                	addiw	s1,s1,1
      c0:	0ff4f493          	zext.b	s1,s1
      c4:	fd249fe3          	bne	s1,s2,a2 <createtest+0x20>
  }
  name[0] = 'a';
      c8:	06100793          	li	a5,97
      cc:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
      d0:	fc040d23          	sb	zero,-38(s0)
      d4:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
      d8:	06400913          	li	s2,100
    name[1] = '0' + i;
      dc:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
      e0:	fd840513          	addi	a0,s0,-40
      e4:	00005097          	auipc	ra,0x5
      e8:	79a080e7          	jalr	1946(ra) # 587e <unlink>
  for(i = 0; i < N; i++){
      ec:	2485                	addiw	s1,s1,1
      ee:	0ff4f493          	zext.b	s1,s1
      f2:	ff2495e3          	bne	s1,s2,dc <createtest+0x5a>
  }
}
      f6:	70a2                	ld	ra,40(sp)
      f8:	7402                	ld	s0,32(sp)
      fa:	64e2                	ld	s1,24(sp)
      fc:	6942                	ld	s2,16(sp)
      fe:	6145                	addi	sp,sp,48
     100:	8082                	ret

0000000000000102 <writetest>:
{
     102:	7139                	addi	sp,sp,-64
     104:	fc06                	sd	ra,56(sp)
     106:	f822                	sd	s0,48(sp)
     108:	f426                	sd	s1,40(sp)
     10a:	f04a                	sd	s2,32(sp)
     10c:	ec4e                	sd	s3,24(sp)
     10e:	e852                	sd	s4,16(sp)
     110:	e456                	sd	s5,8(sp)
     112:	e05a                	sd	s6,0(sp)
     114:	0080                	addi	s0,sp,64
     116:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     118:	20200593          	li	a1,514
     11c:	00006517          	auipc	a0,0x6
     120:	c9450513          	addi	a0,a0,-876 # 5db0 <malloc+0x140>
     124:	00005097          	auipc	ra,0x5
     128:	74a080e7          	jalr	1866(ra) # 586e <open>
  if(fd < 0){
     12c:	0a054d63          	bltz	a0,1e6 <writetest+0xe4>
     130:	892a                	mv	s2,a0
     132:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     134:	00006997          	auipc	s3,0x6
     138:	ca498993          	addi	s3,s3,-860 # 5dd8 <malloc+0x168>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     13c:	00006a97          	auipc	s5,0x6
     140:	cd4a8a93          	addi	s5,s5,-812 # 5e10 <malloc+0x1a0>
  for(i = 0; i < N; i++){
     144:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     148:	4629                	li	a2,10
     14a:	85ce                	mv	a1,s3
     14c:	854a                	mv	a0,s2
     14e:	00005097          	auipc	ra,0x5
     152:	700080e7          	jalr	1792(ra) # 584e <write>
     156:	47a9                	li	a5,10
     158:	0af51563          	bne	a0,a5,202 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     15c:	4629                	li	a2,10
     15e:	85d6                	mv	a1,s5
     160:	854a                	mv	a0,s2
     162:	00005097          	auipc	ra,0x5
     166:	6ec080e7          	jalr	1772(ra) # 584e <write>
     16a:	47a9                	li	a5,10
     16c:	0af51a63          	bne	a0,a5,220 <writetest+0x11e>
  for(i = 0; i < N; i++){
     170:	2485                	addiw	s1,s1,1
     172:	fd449be3          	bne	s1,s4,148 <writetest+0x46>
  close(fd);
     176:	854a                	mv	a0,s2
     178:	00005097          	auipc	ra,0x5
     17c:	6de080e7          	jalr	1758(ra) # 5856 <close>
  fd = open("small", O_RDONLY);
     180:	4581                	li	a1,0
     182:	00006517          	auipc	a0,0x6
     186:	c2e50513          	addi	a0,a0,-978 # 5db0 <malloc+0x140>
     18a:	00005097          	auipc	ra,0x5
     18e:	6e4080e7          	jalr	1764(ra) # 586e <open>
     192:	84aa                	mv	s1,a0
  if(fd < 0){
     194:	0a054563          	bltz	a0,23e <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     198:	7d000613          	li	a2,2000
     19c:	0000c597          	auipc	a1,0xc
     1a0:	83458593          	addi	a1,a1,-1996 # b9d0 <buf>
     1a4:	00005097          	auipc	ra,0x5
     1a8:	6a2080e7          	jalr	1698(ra) # 5846 <read>
  if(i != N*SZ*2){
     1ac:	7d000793          	li	a5,2000
     1b0:	0af51563          	bne	a0,a5,25a <writetest+0x158>
  close(fd);
     1b4:	8526                	mv	a0,s1
     1b6:	00005097          	auipc	ra,0x5
     1ba:	6a0080e7          	jalr	1696(ra) # 5856 <close>
  if(unlink("small") < 0){
     1be:	00006517          	auipc	a0,0x6
     1c2:	bf250513          	addi	a0,a0,-1038 # 5db0 <malloc+0x140>
     1c6:	00005097          	auipc	ra,0x5
     1ca:	6b8080e7          	jalr	1720(ra) # 587e <unlink>
     1ce:	0a054463          	bltz	a0,276 <writetest+0x174>
}
     1d2:	70e2                	ld	ra,56(sp)
     1d4:	7442                	ld	s0,48(sp)
     1d6:	74a2                	ld	s1,40(sp)
     1d8:	7902                	ld	s2,32(sp)
     1da:	69e2                	ld	s3,24(sp)
     1dc:	6a42                	ld	s4,16(sp)
     1de:	6aa2                	ld	s5,8(sp)
     1e0:	6b02                	ld	s6,0(sp)
     1e2:	6121                	addi	sp,sp,64
     1e4:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     1e6:	85da                	mv	a1,s6
     1e8:	00006517          	auipc	a0,0x6
     1ec:	bd050513          	addi	a0,a0,-1072 # 5db8 <malloc+0x148>
     1f0:	00006097          	auipc	ra,0x6
     1f4:	9c8080e7          	jalr	-1592(ra) # 5bb8 <printf>
    exit(1);
     1f8:	4505                	li	a0,1
     1fa:	00005097          	auipc	ra,0x5
     1fe:	634080e7          	jalr	1588(ra) # 582e <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     202:	8626                	mv	a2,s1
     204:	85da                	mv	a1,s6
     206:	00006517          	auipc	a0,0x6
     20a:	be250513          	addi	a0,a0,-1054 # 5de8 <malloc+0x178>
     20e:	00006097          	auipc	ra,0x6
     212:	9aa080e7          	jalr	-1622(ra) # 5bb8 <printf>
      exit(1);
     216:	4505                	li	a0,1
     218:	00005097          	auipc	ra,0x5
     21c:	616080e7          	jalr	1558(ra) # 582e <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     220:	8626                	mv	a2,s1
     222:	85da                	mv	a1,s6
     224:	00006517          	auipc	a0,0x6
     228:	bfc50513          	addi	a0,a0,-1028 # 5e20 <malloc+0x1b0>
     22c:	00006097          	auipc	ra,0x6
     230:	98c080e7          	jalr	-1652(ra) # 5bb8 <printf>
      exit(1);
     234:	4505                	li	a0,1
     236:	00005097          	auipc	ra,0x5
     23a:	5f8080e7          	jalr	1528(ra) # 582e <exit>
    printf("%s: error: open small failed!\n", s);
     23e:	85da                	mv	a1,s6
     240:	00006517          	auipc	a0,0x6
     244:	c0850513          	addi	a0,a0,-1016 # 5e48 <malloc+0x1d8>
     248:	00006097          	auipc	ra,0x6
     24c:	970080e7          	jalr	-1680(ra) # 5bb8 <printf>
    exit(1);
     250:	4505                	li	a0,1
     252:	00005097          	auipc	ra,0x5
     256:	5dc080e7          	jalr	1500(ra) # 582e <exit>
    printf("%s: read failed\n", s);
     25a:	85da                	mv	a1,s6
     25c:	00006517          	auipc	a0,0x6
     260:	c0c50513          	addi	a0,a0,-1012 # 5e68 <malloc+0x1f8>
     264:	00006097          	auipc	ra,0x6
     268:	954080e7          	jalr	-1708(ra) # 5bb8 <printf>
    exit(1);
     26c:	4505                	li	a0,1
     26e:	00005097          	auipc	ra,0x5
     272:	5c0080e7          	jalr	1472(ra) # 582e <exit>
    printf("%s: unlink small failed\n", s);
     276:	85da                	mv	a1,s6
     278:	00006517          	auipc	a0,0x6
     27c:	c0850513          	addi	a0,a0,-1016 # 5e80 <malloc+0x210>
     280:	00006097          	auipc	ra,0x6
     284:	938080e7          	jalr	-1736(ra) # 5bb8 <printf>
    exit(1);
     288:	4505                	li	a0,1
     28a:	00005097          	auipc	ra,0x5
     28e:	5a4080e7          	jalr	1444(ra) # 582e <exit>

0000000000000292 <writebig>:
{
     292:	7139                	addi	sp,sp,-64
     294:	fc06                	sd	ra,56(sp)
     296:	f822                	sd	s0,48(sp)
     298:	f426                	sd	s1,40(sp)
     29a:	f04a                	sd	s2,32(sp)
     29c:	ec4e                	sd	s3,24(sp)
     29e:	e852                	sd	s4,16(sp)
     2a0:	e456                	sd	s5,8(sp)
     2a2:	0080                	addi	s0,sp,64
     2a4:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	00006517          	auipc	a0,0x6
     2ae:	bf650513          	addi	a0,a0,-1034 # 5ea0 <malloc+0x230>
     2b2:	00005097          	auipc	ra,0x5
     2b6:	5bc080e7          	jalr	1468(ra) # 586e <open>
     2ba:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     2bc:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     2be:	0000b917          	auipc	s2,0xb
     2c2:	71290913          	addi	s2,s2,1810 # b9d0 <buf>
  for(i = 0; i < MAXFILE; i++){
     2c6:	10c00a13          	li	s4,268
  if(fd < 0){
     2ca:	06054c63          	bltz	a0,342 <writebig+0xb0>
    ((int*)buf)[0] = i;
     2ce:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     2d2:	40000613          	li	a2,1024
     2d6:	85ca                	mv	a1,s2
     2d8:	854e                	mv	a0,s3
     2da:	00005097          	auipc	ra,0x5
     2de:	574080e7          	jalr	1396(ra) # 584e <write>
     2e2:	40000793          	li	a5,1024
     2e6:	06f51c63          	bne	a0,a5,35e <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     2ea:	2485                	addiw	s1,s1,1
     2ec:	ff4491e3          	bne	s1,s4,2ce <writebig+0x3c>
  close(fd);
     2f0:	854e                	mv	a0,s3
     2f2:	00005097          	auipc	ra,0x5
     2f6:	564080e7          	jalr	1380(ra) # 5856 <close>
  fd = open("big", O_RDONLY);
     2fa:	4581                	li	a1,0
     2fc:	00006517          	auipc	a0,0x6
     300:	ba450513          	addi	a0,a0,-1116 # 5ea0 <malloc+0x230>
     304:	00005097          	auipc	ra,0x5
     308:	56a080e7          	jalr	1386(ra) # 586e <open>
     30c:	89aa                	mv	s3,a0
  n = 0;
     30e:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     310:	0000b917          	auipc	s2,0xb
     314:	6c090913          	addi	s2,s2,1728 # b9d0 <buf>
  if(fd < 0){
     318:	06054263          	bltz	a0,37c <writebig+0xea>
    i = read(fd, buf, BSIZE);
     31c:	40000613          	li	a2,1024
     320:	85ca                	mv	a1,s2
     322:	854e                	mv	a0,s3
     324:	00005097          	auipc	ra,0x5
     328:	522080e7          	jalr	1314(ra) # 5846 <read>
    if(i == 0){
     32c:	c535                	beqz	a0,398 <writebig+0x106>
    } else if(i != BSIZE){
     32e:	40000793          	li	a5,1024
     332:	0af51f63          	bne	a0,a5,3f0 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     336:	00092683          	lw	a3,0(s2)
     33a:	0c969a63          	bne	a3,s1,40e <writebig+0x17c>
    n++;
     33e:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     340:	bff1                	j	31c <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     342:	85d6                	mv	a1,s5
     344:	00006517          	auipc	a0,0x6
     348:	b6450513          	addi	a0,a0,-1180 # 5ea8 <malloc+0x238>
     34c:	00006097          	auipc	ra,0x6
     350:	86c080e7          	jalr	-1940(ra) # 5bb8 <printf>
    exit(1);
     354:	4505                	li	a0,1
     356:	00005097          	auipc	ra,0x5
     35a:	4d8080e7          	jalr	1240(ra) # 582e <exit>
      printf("%s: error: write big file failed\n", s, i);
     35e:	8626                	mv	a2,s1
     360:	85d6                	mv	a1,s5
     362:	00006517          	auipc	a0,0x6
     366:	b6650513          	addi	a0,a0,-1178 # 5ec8 <malloc+0x258>
     36a:	00006097          	auipc	ra,0x6
     36e:	84e080e7          	jalr	-1970(ra) # 5bb8 <printf>
      exit(1);
     372:	4505                	li	a0,1
     374:	00005097          	auipc	ra,0x5
     378:	4ba080e7          	jalr	1210(ra) # 582e <exit>
    printf("%s: error: open big failed!\n", s);
     37c:	85d6                	mv	a1,s5
     37e:	00006517          	auipc	a0,0x6
     382:	b7250513          	addi	a0,a0,-1166 # 5ef0 <malloc+0x280>
     386:	00006097          	auipc	ra,0x6
     38a:	832080e7          	jalr	-1998(ra) # 5bb8 <printf>
    exit(1);
     38e:	4505                	li	a0,1
     390:	00005097          	auipc	ra,0x5
     394:	49e080e7          	jalr	1182(ra) # 582e <exit>
      if(n == MAXFILE - 1){
     398:	10b00793          	li	a5,267
     39c:	02f48a63          	beq	s1,a5,3d0 <writebig+0x13e>
  close(fd);
     3a0:	854e                	mv	a0,s3
     3a2:	00005097          	auipc	ra,0x5
     3a6:	4b4080e7          	jalr	1204(ra) # 5856 <close>
  if(unlink("big") < 0){
     3aa:	00006517          	auipc	a0,0x6
     3ae:	af650513          	addi	a0,a0,-1290 # 5ea0 <malloc+0x230>
     3b2:	00005097          	auipc	ra,0x5
     3b6:	4cc080e7          	jalr	1228(ra) # 587e <unlink>
     3ba:	06054963          	bltz	a0,42c <writebig+0x19a>
}
     3be:	70e2                	ld	ra,56(sp)
     3c0:	7442                	ld	s0,48(sp)
     3c2:	74a2                	ld	s1,40(sp)
     3c4:	7902                	ld	s2,32(sp)
     3c6:	69e2                	ld	s3,24(sp)
     3c8:	6a42                	ld	s4,16(sp)
     3ca:	6aa2                	ld	s5,8(sp)
     3cc:	6121                	addi	sp,sp,64
     3ce:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     3d0:	10b00613          	li	a2,267
     3d4:	85d6                	mv	a1,s5
     3d6:	00006517          	auipc	a0,0x6
     3da:	b3a50513          	addi	a0,a0,-1222 # 5f10 <malloc+0x2a0>
     3de:	00005097          	auipc	ra,0x5
     3e2:	7da080e7          	jalr	2010(ra) # 5bb8 <printf>
        exit(1);
     3e6:	4505                	li	a0,1
     3e8:	00005097          	auipc	ra,0x5
     3ec:	446080e7          	jalr	1094(ra) # 582e <exit>
      printf("%s: read failed %d\n", s, i);
     3f0:	862a                	mv	a2,a0
     3f2:	85d6                	mv	a1,s5
     3f4:	00006517          	auipc	a0,0x6
     3f8:	b4450513          	addi	a0,a0,-1212 # 5f38 <malloc+0x2c8>
     3fc:	00005097          	auipc	ra,0x5
     400:	7bc080e7          	jalr	1980(ra) # 5bb8 <printf>
      exit(1);
     404:	4505                	li	a0,1
     406:	00005097          	auipc	ra,0x5
     40a:	428080e7          	jalr	1064(ra) # 582e <exit>
      printf("%s: read content of block %d is %d\n", s,
     40e:	8626                	mv	a2,s1
     410:	85d6                	mv	a1,s5
     412:	00006517          	auipc	a0,0x6
     416:	b3e50513          	addi	a0,a0,-1218 # 5f50 <malloc+0x2e0>
     41a:	00005097          	auipc	ra,0x5
     41e:	79e080e7          	jalr	1950(ra) # 5bb8 <printf>
      exit(1);
     422:	4505                	li	a0,1
     424:	00005097          	auipc	ra,0x5
     428:	40a080e7          	jalr	1034(ra) # 582e <exit>
    printf("%s: unlink big failed\n", s);
     42c:	85d6                	mv	a1,s5
     42e:	00006517          	auipc	a0,0x6
     432:	b4a50513          	addi	a0,a0,-1206 # 5f78 <malloc+0x308>
     436:	00005097          	auipc	ra,0x5
     43a:	782080e7          	jalr	1922(ra) # 5bb8 <printf>
    exit(1);
     43e:	4505                	li	a0,1
     440:	00005097          	auipc	ra,0x5
     444:	3ee080e7          	jalr	1006(ra) # 582e <exit>

0000000000000448 <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(char *s)
{
     448:	715d                	addi	sp,sp,-80
     44a:	e486                	sd	ra,72(sp)
     44c:	e0a2                	sd	s0,64(sp)
     44e:	fc26                	sd	s1,56(sp)
     450:	f84a                	sd	s2,48(sp)
     452:	f44e                	sd	s3,40(sp)
     454:	f052                	sd	s4,32(sp)
     456:	ec56                	sd	s5,24(sp)
     458:	e85a                	sd	s6,16(sp)
     45a:	0880                	addi	s0,sp,80
     45c:	89aa                	mv	s3,a0
  enum { N = 500 };
  int i, fd;
  char name[10];

  unlink("bd");
     45e:	00006517          	auipc	a0,0x6
     462:	b3250513          	addi	a0,a0,-1230 # 5f90 <malloc+0x320>
     466:	00005097          	auipc	ra,0x5
     46a:	418080e7          	jalr	1048(ra) # 587e <unlink>

  fd = open("bd", O_CREATE);
     46e:	20000593          	li	a1,512
     472:	00006517          	auipc	a0,0x6
     476:	b1e50513          	addi	a0,a0,-1250 # 5f90 <malloc+0x320>
     47a:	00005097          	auipc	ra,0x5
     47e:	3f4080e7          	jalr	1012(ra) # 586e <open>
  if(fd < 0){
     482:	0c054963          	bltz	a0,554 <bigdir+0x10c>
    printf("%s: bigdir create failed\n", s);
    exit(1);
  }
  close(fd);
     486:	00005097          	auipc	ra,0x5
     48a:	3d0080e7          	jalr	976(ra) # 5856 <close>

  for(i = 0; i < N; i++){
     48e:	4901                	li	s2,0
    name[0] = 'x';
     490:	07800a93          	li	s5,120
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
     494:	00006a17          	auipc	s4,0x6
     498:	afca0a13          	addi	s4,s4,-1284 # 5f90 <malloc+0x320>
  for(i = 0; i < N; i++){
     49c:	1f400b13          	li	s6,500
    name[0] = 'x';
     4a0:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     4a4:	41f9571b          	sraiw	a4,s2,0x1f
     4a8:	01a7571b          	srliw	a4,a4,0x1a
     4ac:	012707bb          	addw	a5,a4,s2
     4b0:	4067d69b          	sraiw	a3,a5,0x6
     4b4:	0306869b          	addiw	a3,a3,48
     4b8:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     4bc:	03f7f793          	andi	a5,a5,63
     4c0:	9f99                	subw	a5,a5,a4
     4c2:	0307879b          	addiw	a5,a5,48
     4c6:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     4ca:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     4ce:	fb040593          	addi	a1,s0,-80
     4d2:	8552                	mv	a0,s4
     4d4:	00005097          	auipc	ra,0x5
     4d8:	3ba080e7          	jalr	954(ra) # 588e <link>
     4dc:	84aa                	mv	s1,a0
     4de:	e949                	bnez	a0,570 <bigdir+0x128>
  for(i = 0; i < N; i++){
     4e0:	2905                	addiw	s2,s2,1
     4e2:	fb691fe3          	bne	s2,s6,4a0 <bigdir+0x58>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
      exit(1);
    }
  }

  unlink("bd");
     4e6:	00006517          	auipc	a0,0x6
     4ea:	aaa50513          	addi	a0,a0,-1366 # 5f90 <malloc+0x320>
     4ee:	00005097          	auipc	ra,0x5
     4f2:	390080e7          	jalr	912(ra) # 587e <unlink>
  for(i = 0; i < N; i++){
    name[0] = 'x';
     4f6:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     4fa:	1f400a13          	li	s4,500
    name[0] = 'x';
     4fe:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     502:	41f4d71b          	sraiw	a4,s1,0x1f
     506:	01a7571b          	srliw	a4,a4,0x1a
     50a:	009707bb          	addw	a5,a4,s1
     50e:	4067d69b          	sraiw	a3,a5,0x6
     512:	0306869b          	addiw	a3,a3,48
     516:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     51a:	03f7f793          	andi	a5,a5,63
     51e:	9f99                	subw	a5,a5,a4
     520:	0307879b          	addiw	a5,a5,48
     524:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     528:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     52c:	fb040513          	addi	a0,s0,-80
     530:	00005097          	auipc	ra,0x5
     534:	34e080e7          	jalr	846(ra) # 587e <unlink>
     538:	ed21                	bnez	a0,590 <bigdir+0x148>
  for(i = 0; i < N; i++){
     53a:	2485                	addiw	s1,s1,1
     53c:	fd4491e3          	bne	s1,s4,4fe <bigdir+0xb6>
      printf("%s: bigdir unlink failed", s);
      exit(1);
    }
  }
}
     540:	60a6                	ld	ra,72(sp)
     542:	6406                	ld	s0,64(sp)
     544:	74e2                	ld	s1,56(sp)
     546:	7942                	ld	s2,48(sp)
     548:	79a2                	ld	s3,40(sp)
     54a:	7a02                	ld	s4,32(sp)
     54c:	6ae2                	ld	s5,24(sp)
     54e:	6b42                	ld	s6,16(sp)
     550:	6161                	addi	sp,sp,80
     552:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     554:	85ce                	mv	a1,s3
     556:	00006517          	auipc	a0,0x6
     55a:	a4250513          	addi	a0,a0,-1470 # 5f98 <malloc+0x328>
     55e:	00005097          	auipc	ra,0x5
     562:	65a080e7          	jalr	1626(ra) # 5bb8 <printf>
    exit(1);
     566:	4505                	li	a0,1
     568:	00005097          	auipc	ra,0x5
     56c:	2c6080e7          	jalr	710(ra) # 582e <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
     570:	fb040613          	addi	a2,s0,-80
     574:	85ce                	mv	a1,s3
     576:	00006517          	auipc	a0,0x6
     57a:	a4250513          	addi	a0,a0,-1470 # 5fb8 <malloc+0x348>
     57e:	00005097          	auipc	ra,0x5
     582:	63a080e7          	jalr	1594(ra) # 5bb8 <printf>
      exit(1);
     586:	4505                	li	a0,1
     588:	00005097          	auipc	ra,0x5
     58c:	2a6080e7          	jalr	678(ra) # 582e <exit>
      printf("%s: bigdir unlink failed", s);
     590:	85ce                	mv	a1,s3
     592:	00006517          	auipc	a0,0x6
     596:	a4650513          	addi	a0,a0,-1466 # 5fd8 <malloc+0x368>
     59a:	00005097          	auipc	ra,0x5
     59e:	61e080e7          	jalr	1566(ra) # 5bb8 <printf>
      exit(1);
     5a2:	4505                	li	a0,1
     5a4:	00005097          	auipc	ra,0x5
     5a8:	28a080e7          	jalr	650(ra) # 582e <exit>

00000000000005ac <validatetest>:
  } 
}

void
validatetest(char *s)
{
     5ac:	7139                	addi	sp,sp,-64
     5ae:	fc06                	sd	ra,56(sp)
     5b0:	f822                	sd	s0,48(sp)
     5b2:	f426                	sd	s1,40(sp)
     5b4:	f04a                	sd	s2,32(sp)
     5b6:	ec4e                	sd	s3,24(sp)
     5b8:	e852                	sd	s4,16(sp)
     5ba:	e456                	sd	s5,8(sp)
     5bc:	e05a                	sd	s6,0(sp)
     5be:	0080                	addi	s0,sp,64
     5c0:	8b2a                	mv	s6,a0
  int hi;
  uint64 p;

  hi = 1100*1024;
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     5c2:	4481                	li	s1,0
    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
     5c4:	00006997          	auipc	s3,0x6
     5c8:	a3498993          	addi	s3,s3,-1484 # 5ff8 <malloc+0x388>
     5cc:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     5ce:	6a85                	lui	s5,0x1
     5d0:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     5d4:	85a6                	mv	a1,s1
     5d6:	854e                	mv	a0,s3
     5d8:	00005097          	auipc	ra,0x5
     5dc:	2b6080e7          	jalr	694(ra) # 588e <link>
     5e0:	01251f63          	bne	a0,s2,5fe <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     5e4:	94d6                	add	s1,s1,s5
     5e6:	ff4497e3          	bne	s1,s4,5d4 <validatetest+0x28>
      printf("%s: link should not succeed\n", s);
      exit(1);
    }
  }
}
     5ea:	70e2                	ld	ra,56(sp)
     5ec:	7442                	ld	s0,48(sp)
     5ee:	74a2                	ld	s1,40(sp)
     5f0:	7902                	ld	s2,32(sp)
     5f2:	69e2                	ld	s3,24(sp)
     5f4:	6a42                	ld	s4,16(sp)
     5f6:	6aa2                	ld	s5,8(sp)
     5f8:	6b02                	ld	s6,0(sp)
     5fa:	6121                	addi	sp,sp,64
     5fc:	8082                	ret
      printf("%s: link should not succeed\n", s);
     5fe:	85da                	mv	a1,s6
     600:	00006517          	auipc	a0,0x6
     604:	a0850513          	addi	a0,a0,-1528 # 6008 <malloc+0x398>
     608:	00005097          	auipc	ra,0x5
     60c:	5b0080e7          	jalr	1456(ra) # 5bb8 <printf>
      exit(1);
     610:	4505                	li	a0,1
     612:	00005097          	auipc	ra,0x5
     616:	21c080e7          	jalr	540(ra) # 582e <exit>

000000000000061a <pipe1>:
{
     61a:	711d                	addi	sp,sp,-96
     61c:	ec86                	sd	ra,88(sp)
     61e:	e8a2                	sd	s0,80(sp)
     620:	e4a6                	sd	s1,72(sp)
     622:	e0ca                	sd	s2,64(sp)
     624:	fc4e                	sd	s3,56(sp)
     626:	f852                	sd	s4,48(sp)
     628:	f456                	sd	s5,40(sp)
     62a:	f05a                	sd	s6,32(sp)
     62c:	ec5e                	sd	s7,24(sp)
     62e:	1080                	addi	s0,sp,96
     630:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
     632:	fa840513          	addi	a0,s0,-88
     636:	00005097          	auipc	ra,0x5
     63a:	208080e7          	jalr	520(ra) # 583e <pipe>
     63e:	e93d                	bnez	a0,6b4 <pipe1+0x9a>
     640:	84aa                	mv	s1,a0
  pid = fork();
     642:	00005097          	auipc	ra,0x5
     646:	1e4080e7          	jalr	484(ra) # 5826 <fork>
     64a:	8a2a                	mv	s4,a0
  if(pid == 0){
     64c:	c151                	beqz	a0,6d0 <pipe1+0xb6>
  } else if(pid > 0){
     64e:	16a05d63          	blez	a0,7c8 <pipe1+0x1ae>
    close(fds[1]);
     652:	fac42503          	lw	a0,-84(s0)
     656:	00005097          	auipc	ra,0x5
     65a:	200080e7          	jalr	512(ra) # 5856 <close>
    total = 0;
     65e:	8a26                	mv	s4,s1
    cc = 1;
     660:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
     662:	0000ba97          	auipc	s5,0xb
     666:	36ea8a93          	addi	s5,s5,878 # b9d0 <buf>
      if(cc > sizeof(buf))
     66a:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
     66c:	864e                	mv	a2,s3
     66e:	85d6                	mv	a1,s5
     670:	fa842503          	lw	a0,-88(s0)
     674:	00005097          	auipc	ra,0x5
     678:	1d2080e7          	jalr	466(ra) # 5846 <read>
     67c:	10a05163          	blez	a0,77e <pipe1+0x164>
      for(i = 0; i < n; i++){
     680:	0000b717          	auipc	a4,0xb
     684:	35070713          	addi	a4,a4,848 # b9d0 <buf>
     688:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     68c:	00074683          	lbu	a3,0(a4)
     690:	0ff4f793          	zext.b	a5,s1
     694:	2485                	addiw	s1,s1,1
     696:	0cf69063          	bne	a3,a5,756 <pipe1+0x13c>
      for(i = 0; i < n; i++){
     69a:	0705                	addi	a4,a4,1
     69c:	fec498e3          	bne	s1,a2,68c <pipe1+0x72>
      total += n;
     6a0:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
     6a4:	0019979b          	slliw	a5,s3,0x1
     6a8:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
     6ac:	fd3b70e3          	bgeu	s6,s3,66c <pipe1+0x52>
        cc = sizeof(buf);
     6b0:	89da                	mv	s3,s6
     6b2:	bf6d                	j	66c <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
     6b4:	85ca                	mv	a1,s2
     6b6:	00006517          	auipc	a0,0x6
     6ba:	97250513          	addi	a0,a0,-1678 # 6028 <malloc+0x3b8>
     6be:	00005097          	auipc	ra,0x5
     6c2:	4fa080e7          	jalr	1274(ra) # 5bb8 <printf>
    exit(1);
     6c6:	4505                	li	a0,1
     6c8:	00005097          	auipc	ra,0x5
     6cc:	166080e7          	jalr	358(ra) # 582e <exit>
    close(fds[0]);
     6d0:	fa842503          	lw	a0,-88(s0)
     6d4:	00005097          	auipc	ra,0x5
     6d8:	182080e7          	jalr	386(ra) # 5856 <close>
    for(n = 0; n < N; n++){
     6dc:	0000bb17          	auipc	s6,0xb
     6e0:	2f4b0b13          	addi	s6,s6,756 # b9d0 <buf>
     6e4:	416004bb          	negw	s1,s6
     6e8:	0ff4f493          	zext.b	s1,s1
     6ec:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
     6f0:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
     6f2:	6a85                	lui	s5,0x1
     6f4:	42da8a93          	addi	s5,s5,1069 # 142d <iref+0x89>
{
     6f8:	87da                	mv	a5,s6
        buf[i] = seq++;
     6fa:	0097873b          	addw	a4,a5,s1
     6fe:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
     702:	0785                	addi	a5,a5,1
     704:	fef99be3          	bne	s3,a5,6fa <pipe1+0xe0>
        buf[i] = seq++;
     708:	409a0a1b          	addiw	s4,s4,1033 # 114409 <__BSS_END__+0x105a29>
      if(write(fds[1], buf, SZ) != SZ){
     70c:	40900613          	li	a2,1033
     710:	85de                	mv	a1,s7
     712:	fac42503          	lw	a0,-84(s0)
     716:	00005097          	auipc	ra,0x5
     71a:	138080e7          	jalr	312(ra) # 584e <write>
     71e:	40900793          	li	a5,1033
     722:	00f51c63          	bne	a0,a5,73a <pipe1+0x120>
    for(n = 0; n < N; n++){
     726:	24a5                	addiw	s1,s1,9
     728:	0ff4f493          	zext.b	s1,s1
     72c:	fd5a16e3          	bne	s4,s5,6f8 <pipe1+0xde>
    exit(0);
     730:	4501                	li	a0,0
     732:	00005097          	auipc	ra,0x5
     736:	0fc080e7          	jalr	252(ra) # 582e <exit>
        printf("%s: pipe1 oops 1\n", s);
     73a:	85ca                	mv	a1,s2
     73c:	00006517          	auipc	a0,0x6
     740:	90450513          	addi	a0,a0,-1788 # 6040 <malloc+0x3d0>
     744:	00005097          	auipc	ra,0x5
     748:	474080e7          	jalr	1140(ra) # 5bb8 <printf>
        exit(1);
     74c:	4505                	li	a0,1
     74e:	00005097          	auipc	ra,0x5
     752:	0e0080e7          	jalr	224(ra) # 582e <exit>
          printf("%s: pipe1 oops 2\n", s);
     756:	85ca                	mv	a1,s2
     758:	00006517          	auipc	a0,0x6
     75c:	90050513          	addi	a0,a0,-1792 # 6058 <malloc+0x3e8>
     760:	00005097          	auipc	ra,0x5
     764:	458080e7          	jalr	1112(ra) # 5bb8 <printf>
}
     768:	60e6                	ld	ra,88(sp)
     76a:	6446                	ld	s0,80(sp)
     76c:	64a6                	ld	s1,72(sp)
     76e:	6906                	ld	s2,64(sp)
     770:	79e2                	ld	s3,56(sp)
     772:	7a42                	ld	s4,48(sp)
     774:	7aa2                	ld	s5,40(sp)
     776:	7b02                	ld	s6,32(sp)
     778:	6be2                	ld	s7,24(sp)
     77a:	6125                	addi	sp,sp,96
     77c:	8082                	ret
    if(total != N * SZ){
     77e:	6785                	lui	a5,0x1
     780:	42d78793          	addi	a5,a5,1069 # 142d <iref+0x89>
     784:	02fa0063          	beq	s4,a5,7a4 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
     788:	85d2                	mv	a1,s4
     78a:	00006517          	auipc	a0,0x6
     78e:	8e650513          	addi	a0,a0,-1818 # 6070 <malloc+0x400>
     792:	00005097          	auipc	ra,0x5
     796:	426080e7          	jalr	1062(ra) # 5bb8 <printf>
      exit(1);
     79a:	4505                	li	a0,1
     79c:	00005097          	auipc	ra,0x5
     7a0:	092080e7          	jalr	146(ra) # 582e <exit>
    close(fds[0]);
     7a4:	fa842503          	lw	a0,-88(s0)
     7a8:	00005097          	auipc	ra,0x5
     7ac:	0ae080e7          	jalr	174(ra) # 5856 <close>
    wait(&xstatus);
     7b0:	fa440513          	addi	a0,s0,-92
     7b4:	00005097          	auipc	ra,0x5
     7b8:	082080e7          	jalr	130(ra) # 5836 <wait>
    exit(xstatus);
     7bc:	fa442503          	lw	a0,-92(s0)
     7c0:	00005097          	auipc	ra,0x5
     7c4:	06e080e7          	jalr	110(ra) # 582e <exit>
    printf("%s: fork() failed\n", s);
     7c8:	85ca                	mv	a1,s2
     7ca:	00006517          	auipc	a0,0x6
     7ce:	8c650513          	addi	a0,a0,-1850 # 6090 <malloc+0x420>
     7d2:	00005097          	auipc	ra,0x5
     7d6:	3e6080e7          	jalr	998(ra) # 5bb8 <printf>
    exit(1);
     7da:	4505                	li	a0,1
     7dc:	00005097          	auipc	ra,0x5
     7e0:	052080e7          	jalr	82(ra) # 582e <exit>

00000000000007e4 <exitwait>:
{
     7e4:	7139                	addi	sp,sp,-64
     7e6:	fc06                	sd	ra,56(sp)
     7e8:	f822                	sd	s0,48(sp)
     7ea:	f426                	sd	s1,40(sp)
     7ec:	f04a                	sd	s2,32(sp)
     7ee:	ec4e                	sd	s3,24(sp)
     7f0:	e852                	sd	s4,16(sp)
     7f2:	0080                	addi	s0,sp,64
     7f4:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
     7f6:	4901                	li	s2,0
     7f8:	06400993          	li	s3,100
    pid = fork();
     7fc:	00005097          	auipc	ra,0x5
     800:	02a080e7          	jalr	42(ra) # 5826 <fork>
     804:	84aa                	mv	s1,a0
    if(pid < 0){
     806:	02054a63          	bltz	a0,83a <exitwait+0x56>
    if(pid){
     80a:	c151                	beqz	a0,88e <exitwait+0xaa>
      if(wait(&xstate) != pid){
     80c:	fcc40513          	addi	a0,s0,-52
     810:	00005097          	auipc	ra,0x5
     814:	026080e7          	jalr	38(ra) # 5836 <wait>
     818:	02951f63          	bne	a0,s1,856 <exitwait+0x72>
      if(i != xstate) {
     81c:	fcc42783          	lw	a5,-52(s0)
     820:	05279963          	bne	a5,s2,872 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
     824:	2905                	addiw	s2,s2,1
     826:	fd391be3          	bne	s2,s3,7fc <exitwait+0x18>
}
     82a:	70e2                	ld	ra,56(sp)
     82c:	7442                	ld	s0,48(sp)
     82e:	74a2                	ld	s1,40(sp)
     830:	7902                	ld	s2,32(sp)
     832:	69e2                	ld	s3,24(sp)
     834:	6a42                	ld	s4,16(sp)
     836:	6121                	addi	sp,sp,64
     838:	8082                	ret
      printf("%s: fork failed\n", s);
     83a:	85d2                	mv	a1,s4
     83c:	00006517          	auipc	a0,0x6
     840:	86c50513          	addi	a0,a0,-1940 # 60a8 <malloc+0x438>
     844:	00005097          	auipc	ra,0x5
     848:	374080e7          	jalr	884(ra) # 5bb8 <printf>
      exit(1);
     84c:	4505                	li	a0,1
     84e:	00005097          	auipc	ra,0x5
     852:	fe0080e7          	jalr	-32(ra) # 582e <exit>
        printf("%s: wait wrong pid\n", s);
     856:	85d2                	mv	a1,s4
     858:	00006517          	auipc	a0,0x6
     85c:	86850513          	addi	a0,a0,-1944 # 60c0 <malloc+0x450>
     860:	00005097          	auipc	ra,0x5
     864:	358080e7          	jalr	856(ra) # 5bb8 <printf>
        exit(1);
     868:	4505                	li	a0,1
     86a:	00005097          	auipc	ra,0x5
     86e:	fc4080e7          	jalr	-60(ra) # 582e <exit>
        printf("%s: wait wrong exit status\n", s);
     872:	85d2                	mv	a1,s4
     874:	00006517          	auipc	a0,0x6
     878:	86450513          	addi	a0,a0,-1948 # 60d8 <malloc+0x468>
     87c:	00005097          	auipc	ra,0x5
     880:	33c080e7          	jalr	828(ra) # 5bb8 <printf>
        exit(1);
     884:	4505                	li	a0,1
     886:	00005097          	auipc	ra,0x5
     88a:	fa8080e7          	jalr	-88(ra) # 582e <exit>
      exit(i);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	f9e080e7          	jalr	-98(ra) # 582e <exit>

0000000000000898 <forktest>:
{
     898:	7179                	addi	sp,sp,-48
     89a:	f406                	sd	ra,40(sp)
     89c:	f022                	sd	s0,32(sp)
     89e:	ec26                	sd	s1,24(sp)
     8a0:	e84a                	sd	s2,16(sp)
     8a2:	e44e                	sd	s3,8(sp)
     8a4:	1800                	addi	s0,sp,48
     8a6:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
     8a8:	4481                	li	s1,0
     8aa:	3e800913          	li	s2,1000
    pid = fork();
     8ae:	00005097          	auipc	ra,0x5
     8b2:	f78080e7          	jalr	-136(ra) # 5826 <fork>
    if(pid < 0)
     8b6:	02054863          	bltz	a0,8e6 <forktest+0x4e>
    if(pid == 0)
     8ba:	c115                	beqz	a0,8de <forktest+0x46>
  for(n=0; n<N; n++){
     8bc:	2485                	addiw	s1,s1,1
     8be:	ff2498e3          	bne	s1,s2,8ae <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
     8c2:	85ce                	mv	a1,s3
     8c4:	00006517          	auipc	a0,0x6
     8c8:	84c50513          	addi	a0,a0,-1972 # 6110 <malloc+0x4a0>
     8cc:	00005097          	auipc	ra,0x5
     8d0:	2ec080e7          	jalr	748(ra) # 5bb8 <printf>
    exit(1);
     8d4:	4505                	li	a0,1
     8d6:	00005097          	auipc	ra,0x5
     8da:	f58080e7          	jalr	-168(ra) # 582e <exit>
      exit(0);
     8de:	00005097          	auipc	ra,0x5
     8e2:	f50080e7          	jalr	-176(ra) # 582e <exit>
  if (n == 0) {
     8e6:	cc9d                	beqz	s1,924 <forktest+0x8c>
  if(n == N){
     8e8:	3e800793          	li	a5,1000
     8ec:	fcf48be3          	beq	s1,a5,8c2 <forktest+0x2a>
  for(; n > 0; n--){
     8f0:	00905b63          	blez	s1,906 <forktest+0x6e>
    if(wait(0) < 0){
     8f4:	4501                	li	a0,0
     8f6:	00005097          	auipc	ra,0x5
     8fa:	f40080e7          	jalr	-192(ra) # 5836 <wait>
     8fe:	04054163          	bltz	a0,940 <forktest+0xa8>
  for(; n > 0; n--){
     902:	34fd                	addiw	s1,s1,-1
     904:	f8e5                	bnez	s1,8f4 <forktest+0x5c>
  if(wait(0) != -1){
     906:	4501                	li	a0,0
     908:	00005097          	auipc	ra,0x5
     90c:	f2e080e7          	jalr	-210(ra) # 5836 <wait>
     910:	57fd                	li	a5,-1
     912:	04f51563          	bne	a0,a5,95c <forktest+0xc4>
}
     916:	70a2                	ld	ra,40(sp)
     918:	7402                	ld	s0,32(sp)
     91a:	64e2                	ld	s1,24(sp)
     91c:	6942                	ld	s2,16(sp)
     91e:	69a2                	ld	s3,8(sp)
     920:	6145                	addi	sp,sp,48
     922:	8082                	ret
    printf("%s: no fork at all!\n", s);
     924:	85ce                	mv	a1,s3
     926:	00005517          	auipc	a0,0x5
     92a:	7d250513          	addi	a0,a0,2002 # 60f8 <malloc+0x488>
     92e:	00005097          	auipc	ra,0x5
     932:	28a080e7          	jalr	650(ra) # 5bb8 <printf>
    exit(1);
     936:	4505                	li	a0,1
     938:	00005097          	auipc	ra,0x5
     93c:	ef6080e7          	jalr	-266(ra) # 582e <exit>
      printf("%s: wait stopped early\n", s);
     940:	85ce                	mv	a1,s3
     942:	00005517          	auipc	a0,0x5
     946:	7f650513          	addi	a0,a0,2038 # 6138 <malloc+0x4c8>
     94a:	00005097          	auipc	ra,0x5
     94e:	26e080e7          	jalr	622(ra) # 5bb8 <printf>
      exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	eda080e7          	jalr	-294(ra) # 582e <exit>
    printf("%s: wait got too many\n", s);
     95c:	85ce                	mv	a1,s3
     95e:	00005517          	auipc	a0,0x5
     962:	7f250513          	addi	a0,a0,2034 # 6150 <malloc+0x4e0>
     966:	00005097          	auipc	ra,0x5
     96a:	252080e7          	jalr	594(ra) # 5bb8 <printf>
    exit(1);
     96e:	4505                	li	a0,1
     970:	00005097          	auipc	ra,0x5
     974:	ebe080e7          	jalr	-322(ra) # 582e <exit>

0000000000000978 <kernmem>:
{
     978:	715d                	addi	sp,sp,-80
     97a:	e486                	sd	ra,72(sp)
     97c:	e0a2                	sd	s0,64(sp)
     97e:	fc26                	sd	s1,56(sp)
     980:	f84a                	sd	s2,48(sp)
     982:	f44e                	sd	s3,40(sp)
     984:	f052                	sd	s4,32(sp)
     986:	ec56                	sd	s5,24(sp)
     988:	0880                	addi	s0,sp,80
     98a:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     98c:	4485                	li	s1,1
     98e:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
     990:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     992:	69b1                	lui	s3,0xc
     994:	35098993          	addi	s3,s3,848 # c350 <buf+0x980>
     998:	1003d937          	lui	s2,0x1003d
     99c:	090e                	slli	s2,s2,0x3
     99e:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002eaa0>
    pid = fork();
     9a2:	00005097          	auipc	ra,0x5
     9a6:	e84080e7          	jalr	-380(ra) # 5826 <fork>
    if(pid < 0){
     9aa:	02054963          	bltz	a0,9dc <kernmem+0x64>
    if(pid == 0){
     9ae:	c529                	beqz	a0,9f8 <kernmem+0x80>
    wait(&xstatus);
     9b0:	fbc40513          	addi	a0,s0,-68
     9b4:	00005097          	auipc	ra,0x5
     9b8:	e82080e7          	jalr	-382(ra) # 5836 <wait>
    if(xstatus != -1)  // did kernel kill child?
     9bc:	fbc42783          	lw	a5,-68(s0)
     9c0:	05579d63          	bne	a5,s5,a1a <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     9c4:	94ce                	add	s1,s1,s3
     9c6:	fd249ee3          	bne	s1,s2,9a2 <kernmem+0x2a>
}
     9ca:	60a6                	ld	ra,72(sp)
     9cc:	6406                	ld	s0,64(sp)
     9ce:	74e2                	ld	s1,56(sp)
     9d0:	7942                	ld	s2,48(sp)
     9d2:	79a2                	ld	s3,40(sp)
     9d4:	7a02                	ld	s4,32(sp)
     9d6:	6ae2                	ld	s5,24(sp)
     9d8:	6161                	addi	sp,sp,80
     9da:	8082                	ret
      printf("%s: fork failed\n", s);
     9dc:	85d2                	mv	a1,s4
     9de:	00005517          	auipc	a0,0x5
     9e2:	6ca50513          	addi	a0,a0,1738 # 60a8 <malloc+0x438>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	1d2080e7          	jalr	466(ra) # 5bb8 <printf>
      exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	e3e080e7          	jalr	-450(ra) # 582e <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
     9f8:	0004c683          	lbu	a3,0(s1)
     9fc:	8626                	mv	a2,s1
     9fe:	85d2                	mv	a1,s4
     a00:	00005517          	auipc	a0,0x5
     a04:	76850513          	addi	a0,a0,1896 # 6168 <malloc+0x4f8>
     a08:	00005097          	auipc	ra,0x5
     a0c:	1b0080e7          	jalr	432(ra) # 5bb8 <printf>
      exit(1);
     a10:	4505                	li	a0,1
     a12:	00005097          	auipc	ra,0x5
     a16:	e1c080e7          	jalr	-484(ra) # 582e <exit>
      exit(1);
     a1a:	4505                	li	a0,1
     a1c:	00005097          	auipc	ra,0x5
     a20:	e12080e7          	jalr	-494(ra) # 582e <exit>

0000000000000a24 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest(char *s)
{
     a24:	7179                	addi	sp,sp,-48
     a26:	f406                	sd	ra,40(sp)
     a28:	f022                	sd	s0,32(sp)
     a2a:	ec26                	sd	s1,24(sp)
     a2c:	1800                	addi	s0,sp,48
     a2e:	84aa                	mv	s1,a0
  int pid;
  int xstatus;
  
  pid = fork();
     a30:	00005097          	auipc	ra,0x5
     a34:	df6080e7          	jalr	-522(ra) # 5826 <fork>
  if(pid == 0) {
     a38:	c115                	beqz	a0,a5c <stacktest+0x38>
    char *sp = (char *) r_sp();
    sp -= PGSIZE;
    // the *sp should cause a trap.
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    exit(1);
  } else if(pid < 0){
     a3a:	04054463          	bltz	a0,a82 <stacktest+0x5e>
    printf("%s: fork failed\n", s);
    exit(1);
  }
  wait(&xstatus);
     a3e:	fdc40513          	addi	a0,s0,-36
     a42:	00005097          	auipc	ra,0x5
     a46:	df4080e7          	jalr	-524(ra) # 5836 <wait>
  if(xstatus == -1)  // kernel killed child?
     a4a:	fdc42503          	lw	a0,-36(s0)
     a4e:	57fd                	li	a5,-1
     a50:	04f50763          	beq	a0,a5,a9e <stacktest+0x7a>
    exit(0);
  else
    exit(xstatus);
     a54:	00005097          	auipc	ra,0x5
     a58:	dda080e7          	jalr	-550(ra) # 582e <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
     a5c:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
     a5e:	77fd                	lui	a5,0xfffff
     a60:	97ba                	add	a5,a5,a4
     a62:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0620>
     a66:	85a6                	mv	a1,s1
     a68:	00005517          	auipc	a0,0x5
     a6c:	72050513          	addi	a0,a0,1824 # 6188 <malloc+0x518>
     a70:	00005097          	auipc	ra,0x5
     a74:	148080e7          	jalr	328(ra) # 5bb8 <printf>
    exit(1);
     a78:	4505                	li	a0,1
     a7a:	00005097          	auipc	ra,0x5
     a7e:	db4080e7          	jalr	-588(ra) # 582e <exit>
    printf("%s: fork failed\n", s);
     a82:	85a6                	mv	a1,s1
     a84:	00005517          	auipc	a0,0x5
     a88:	62450513          	addi	a0,a0,1572 # 60a8 <malloc+0x438>
     a8c:	00005097          	auipc	ra,0x5
     a90:	12c080e7          	jalr	300(ra) # 5bb8 <printf>
    exit(1);
     a94:	4505                	li	a0,1
     a96:	00005097          	auipc	ra,0x5
     a9a:	d98080e7          	jalr	-616(ra) # 582e <exit>
    exit(0);
     a9e:	4501                	li	a0,0
     aa0:	00005097          	auipc	ra,0x5
     aa4:	d8e080e7          	jalr	-626(ra) # 582e <exit>

0000000000000aa8 <sbrkarg>:
{
     aa8:	7179                	addi	sp,sp,-48
     aaa:	f406                	sd	ra,40(sp)
     aac:	f022                	sd	s0,32(sp)
     aae:	ec26                	sd	s1,24(sp)
     ab0:	e84a                	sd	s2,16(sp)
     ab2:	e44e                	sd	s3,8(sp)
     ab4:	1800                	addi	s0,sp,48
     ab6:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
     ab8:	6505                	lui	a0,0x1
     aba:	00005097          	auipc	ra,0x5
     abe:	dfc080e7          	jalr	-516(ra) # 58b6 <sbrk>
     ac2:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
     ac4:	20100593          	li	a1,513
     ac8:	00005517          	auipc	a0,0x5
     acc:	6e850513          	addi	a0,a0,1768 # 61b0 <malloc+0x540>
     ad0:	00005097          	auipc	ra,0x5
     ad4:	d9e080e7          	jalr	-610(ra) # 586e <open>
     ad8:	84aa                	mv	s1,a0
  unlink("sbrk");
     ada:	00005517          	auipc	a0,0x5
     ade:	6d650513          	addi	a0,a0,1750 # 61b0 <malloc+0x540>
     ae2:	00005097          	auipc	ra,0x5
     ae6:	d9c080e7          	jalr	-612(ra) # 587e <unlink>
  if(fd < 0)  {
     aea:	0404c163          	bltz	s1,b2c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
     aee:	6605                	lui	a2,0x1
     af0:	85ca                	mv	a1,s2
     af2:	8526                	mv	a0,s1
     af4:	00005097          	auipc	ra,0x5
     af8:	d5a080e7          	jalr	-678(ra) # 584e <write>
     afc:	04054663          	bltz	a0,b48 <sbrkarg+0xa0>
  close(fd);
     b00:	8526                	mv	a0,s1
     b02:	00005097          	auipc	ra,0x5
     b06:	d54080e7          	jalr	-684(ra) # 5856 <close>
  a = sbrk(PGSIZE);
     b0a:	6505                	lui	a0,0x1
     b0c:	00005097          	auipc	ra,0x5
     b10:	daa080e7          	jalr	-598(ra) # 58b6 <sbrk>
  if(pipe((int *) a) != 0){
     b14:	00005097          	auipc	ra,0x5
     b18:	d2a080e7          	jalr	-726(ra) # 583e <pipe>
     b1c:	e521                	bnez	a0,b64 <sbrkarg+0xbc>
}
     b1e:	70a2                	ld	ra,40(sp)
     b20:	7402                	ld	s0,32(sp)
     b22:	64e2                	ld	s1,24(sp)
     b24:	6942                	ld	s2,16(sp)
     b26:	69a2                	ld	s3,8(sp)
     b28:	6145                	addi	sp,sp,48
     b2a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
     b2c:	85ce                	mv	a1,s3
     b2e:	00005517          	auipc	a0,0x5
     b32:	68a50513          	addi	a0,a0,1674 # 61b8 <malloc+0x548>
     b36:	00005097          	auipc	ra,0x5
     b3a:	082080e7          	jalr	130(ra) # 5bb8 <printf>
    exit(1);
     b3e:	4505                	li	a0,1
     b40:	00005097          	auipc	ra,0x5
     b44:	cee080e7          	jalr	-786(ra) # 582e <exit>
    printf("%s: write sbrk failed\n", s);
     b48:	85ce                	mv	a1,s3
     b4a:	00005517          	auipc	a0,0x5
     b4e:	68650513          	addi	a0,a0,1670 # 61d0 <malloc+0x560>
     b52:	00005097          	auipc	ra,0x5
     b56:	066080e7          	jalr	102(ra) # 5bb8 <printf>
    exit(1);
     b5a:	4505                	li	a0,1
     b5c:	00005097          	auipc	ra,0x5
     b60:	cd2080e7          	jalr	-814(ra) # 582e <exit>
    printf("%s: pipe() failed\n", s);
     b64:	85ce                	mv	a1,s3
     b66:	00005517          	auipc	a0,0x5
     b6a:	4c250513          	addi	a0,a0,1218 # 6028 <malloc+0x3b8>
     b6e:	00005097          	auipc	ra,0x5
     b72:	04a080e7          	jalr	74(ra) # 5bb8 <printf>
    exit(1);
     b76:	4505                	li	a0,1
     b78:	00005097          	auipc	ra,0x5
     b7c:	cb6080e7          	jalr	-842(ra) # 582e <exit>

0000000000000b80 <sbrklast>:
// if process size was somewhat more than a page boundary, and then
// shrunk to be somewhat less than that page boundary, can the kernel
// still copyin() from addresses in the last page?
void
sbrklast(char *s)
{
     b80:	7179                	addi	sp,sp,-48
     b82:	f406                	sd	ra,40(sp)
     b84:	f022                	sd	s0,32(sp)
     b86:	ec26                	sd	s1,24(sp)
     b88:	e84a                	sd	s2,16(sp)
     b8a:	e44e                	sd	s3,8(sp)
     b8c:	e052                	sd	s4,0(sp)
     b8e:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
     b90:	4501                	li	a0,0
     b92:	00005097          	auipc	ra,0x5
     b96:	d24080e7          	jalr	-732(ra) # 58b6 <sbrk>
  if((top % 4096) != 0)
     b9a:	03451793          	slli	a5,a0,0x34
     b9e:	ebd9                	bnez	a5,c34 <sbrklast+0xb4>
    sbrk(4096 - (top % 4096));
  sbrk(4096);
     ba0:	6505                	lui	a0,0x1
     ba2:	00005097          	auipc	ra,0x5
     ba6:	d14080e7          	jalr	-748(ra) # 58b6 <sbrk>
  sbrk(10);
     baa:	4529                	li	a0,10
     bac:	00005097          	auipc	ra,0x5
     bb0:	d0a080e7          	jalr	-758(ra) # 58b6 <sbrk>
  sbrk(-20);
     bb4:	5531                	li	a0,-20
     bb6:	00005097          	auipc	ra,0x5
     bba:	d00080e7          	jalr	-768(ra) # 58b6 <sbrk>
  top = (uint64) sbrk(0);
     bbe:	4501                	li	a0,0
     bc0:	00005097          	auipc	ra,0x5
     bc4:	cf6080e7          	jalr	-778(ra) # 58b6 <sbrk>
     bc8:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
     bca:	fc050913          	addi	s2,a0,-64 # fc0 <exitiputtest+0xbe>
  p[0] = 'x';
     bce:	07800a13          	li	s4,120
     bd2:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
     bd6:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
     bda:	20200593          	li	a1,514
     bde:	854a                	mv	a0,s2
     be0:	00005097          	auipc	ra,0x5
     be4:	c8e080e7          	jalr	-882(ra) # 586e <open>
     be8:	89aa                	mv	s3,a0
  write(fd, p, 1);
     bea:	4605                	li	a2,1
     bec:	85ca                	mv	a1,s2
     bee:	00005097          	auipc	ra,0x5
     bf2:	c60080e7          	jalr	-928(ra) # 584e <write>
  close(fd);
     bf6:	854e                	mv	a0,s3
     bf8:	00005097          	auipc	ra,0x5
     bfc:	c5e080e7          	jalr	-930(ra) # 5856 <close>
  fd = open(p, O_RDWR);
     c00:	4589                	li	a1,2
     c02:	854a                	mv	a0,s2
     c04:	00005097          	auipc	ra,0x5
     c08:	c6a080e7          	jalr	-918(ra) # 586e <open>
  p[0] = '\0';
     c0c:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
     c10:	4605                	li	a2,1
     c12:	85ca                	mv	a1,s2
     c14:	00005097          	auipc	ra,0x5
     c18:	c32080e7          	jalr	-974(ra) # 5846 <read>
  if(p[0] != 'x')
     c1c:	fc04c783          	lbu	a5,-64(s1)
     c20:	03479463          	bne	a5,s4,c48 <sbrklast+0xc8>
    exit(1);
}
     c24:	70a2                	ld	ra,40(sp)
     c26:	7402                	ld	s0,32(sp)
     c28:	64e2                	ld	s1,24(sp)
     c2a:	6942                	ld	s2,16(sp)
     c2c:	69a2                	ld	s3,8(sp)
     c2e:	6a02                	ld	s4,0(sp)
     c30:	6145                	addi	sp,sp,48
     c32:	8082                	ret
    sbrk(4096 - (top % 4096));
     c34:	0347d513          	srli	a0,a5,0x34
     c38:	6785                	lui	a5,0x1
     c3a:	40a7853b          	subw	a0,a5,a0
     c3e:	00005097          	auipc	ra,0x5
     c42:	c78080e7          	jalr	-904(ra) # 58b6 <sbrk>
     c46:	bfa9                	j	ba0 <sbrklast+0x20>
    exit(1);
     c48:	4505                	li	a0,1
     c4a:	00005097          	auipc	ra,0x5
     c4e:	be4080e7          	jalr	-1052(ra) # 582e <exit>

0000000000000c52 <sbrk8000>:

// does sbrk handle signed int32 wrap-around with
// negative arguments?
void
sbrk8000(char *s)
{
     c52:	1141                	addi	sp,sp,-16
     c54:	e406                	sd	ra,8(sp)
     c56:	e022                	sd	s0,0(sp)
     c58:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
     c5a:	80000537          	lui	a0,0x80000
     c5e:	0511                	addi	a0,a0,4 # ffffffff80000004 <__BSS_END__+0xffffffff7fff1624>
     c60:	00005097          	auipc	ra,0x5
     c64:	c56080e7          	jalr	-938(ra) # 58b6 <sbrk>
  volatile char *top = sbrk(0);
     c68:	4501                	li	a0,0
     c6a:	00005097          	auipc	ra,0x5
     c6e:	c4c080e7          	jalr	-948(ra) # 58b6 <sbrk>
  *(top-1) = *(top-1) + 1;
     c72:	fff54783          	lbu	a5,-1(a0)
     c76:	2785                	addiw	a5,a5,1 # 1001 <rmdot+0x17>
     c78:	0ff7f793          	zext.b	a5,a5
     c7c:	fef50fa3          	sb	a5,-1(a0)
}
     c80:	60a2                	ld	ra,8(sp)
     c82:	6402                	ld	s0,0(sp)
     c84:	0141                	addi	sp,sp,16
     c86:	8082                	ret

0000000000000c88 <fourteen>:
{
     c88:	1101                	addi	sp,sp,-32
     c8a:	ec06                	sd	ra,24(sp)
     c8c:	e822                	sd	s0,16(sp)
     c8e:	e426                	sd	s1,8(sp)
     c90:	1000                	addi	s0,sp,32
     c92:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
     c94:	00005517          	auipc	a0,0x5
     c98:	72450513          	addi	a0,a0,1828 # 63b8 <malloc+0x748>
     c9c:	00005097          	auipc	ra,0x5
     ca0:	bfa080e7          	jalr	-1030(ra) # 5896 <mkdir>
     ca4:	e165                	bnez	a0,d84 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
     ca6:	00005517          	auipc	a0,0x5
     caa:	56a50513          	addi	a0,a0,1386 # 6210 <malloc+0x5a0>
     cae:	00005097          	auipc	ra,0x5
     cb2:	be8080e7          	jalr	-1048(ra) # 5896 <mkdir>
     cb6:	e56d                	bnez	a0,da0 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
     cb8:	20000593          	li	a1,512
     cbc:	00005517          	auipc	a0,0x5
     cc0:	5ac50513          	addi	a0,a0,1452 # 6268 <malloc+0x5f8>
     cc4:	00005097          	auipc	ra,0x5
     cc8:	baa080e7          	jalr	-1110(ra) # 586e <open>
  if(fd < 0){
     ccc:	0e054863          	bltz	a0,dbc <fourteen+0x134>
  close(fd);
     cd0:	00005097          	auipc	ra,0x5
     cd4:	b86080e7          	jalr	-1146(ra) # 5856 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
     cd8:	4581                	li	a1,0
     cda:	00005517          	auipc	a0,0x5
     cde:	60650513          	addi	a0,a0,1542 # 62e0 <malloc+0x670>
     ce2:	00005097          	auipc	ra,0x5
     ce6:	b8c080e7          	jalr	-1140(ra) # 586e <open>
  if(fd < 0){
     cea:	0e054763          	bltz	a0,dd8 <fourteen+0x150>
  close(fd);
     cee:	00005097          	auipc	ra,0x5
     cf2:	b68080e7          	jalr	-1176(ra) # 5856 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
     cf6:	00005517          	auipc	a0,0x5
     cfa:	65a50513          	addi	a0,a0,1626 # 6350 <malloc+0x6e0>
     cfe:	00005097          	auipc	ra,0x5
     d02:	b98080e7          	jalr	-1128(ra) # 5896 <mkdir>
     d06:	c57d                	beqz	a0,df4 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
     d08:	00005517          	auipc	a0,0x5
     d0c:	6a050513          	addi	a0,a0,1696 # 63a8 <malloc+0x738>
     d10:	00005097          	auipc	ra,0x5
     d14:	b86080e7          	jalr	-1146(ra) # 5896 <mkdir>
     d18:	cd65                	beqz	a0,e10 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
     d1a:	00005517          	auipc	a0,0x5
     d1e:	68e50513          	addi	a0,a0,1678 # 63a8 <malloc+0x738>
     d22:	00005097          	auipc	ra,0x5
     d26:	b5c080e7          	jalr	-1188(ra) # 587e <unlink>
  unlink("12345678901234/12345678901234");
     d2a:	00005517          	auipc	a0,0x5
     d2e:	62650513          	addi	a0,a0,1574 # 6350 <malloc+0x6e0>
     d32:	00005097          	auipc	ra,0x5
     d36:	b4c080e7          	jalr	-1204(ra) # 587e <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
     d3a:	00005517          	auipc	a0,0x5
     d3e:	5a650513          	addi	a0,a0,1446 # 62e0 <malloc+0x670>
     d42:	00005097          	auipc	ra,0x5
     d46:	b3c080e7          	jalr	-1220(ra) # 587e <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
     d4a:	00005517          	auipc	a0,0x5
     d4e:	51e50513          	addi	a0,a0,1310 # 6268 <malloc+0x5f8>
     d52:	00005097          	auipc	ra,0x5
     d56:	b2c080e7          	jalr	-1236(ra) # 587e <unlink>
  unlink("12345678901234/123456789012345");
     d5a:	00005517          	auipc	a0,0x5
     d5e:	4b650513          	addi	a0,a0,1206 # 6210 <malloc+0x5a0>
     d62:	00005097          	auipc	ra,0x5
     d66:	b1c080e7          	jalr	-1252(ra) # 587e <unlink>
  unlink("12345678901234");
     d6a:	00005517          	auipc	a0,0x5
     d6e:	64e50513          	addi	a0,a0,1614 # 63b8 <malloc+0x748>
     d72:	00005097          	auipc	ra,0x5
     d76:	b0c080e7          	jalr	-1268(ra) # 587e <unlink>
}
     d7a:	60e2                	ld	ra,24(sp)
     d7c:	6442                	ld	s0,16(sp)
     d7e:	64a2                	ld	s1,8(sp)
     d80:	6105                	addi	sp,sp,32
     d82:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
     d84:	85a6                	mv	a1,s1
     d86:	00005517          	auipc	a0,0x5
     d8a:	46250513          	addi	a0,a0,1122 # 61e8 <malloc+0x578>
     d8e:	00005097          	auipc	ra,0x5
     d92:	e2a080e7          	jalr	-470(ra) # 5bb8 <printf>
    exit(1);
     d96:	4505                	li	a0,1
     d98:	00005097          	auipc	ra,0x5
     d9c:	a96080e7          	jalr	-1386(ra) # 582e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
     da0:	85a6                	mv	a1,s1
     da2:	00005517          	auipc	a0,0x5
     da6:	48e50513          	addi	a0,a0,1166 # 6230 <malloc+0x5c0>
     daa:	00005097          	auipc	ra,0x5
     dae:	e0e080e7          	jalr	-498(ra) # 5bb8 <printf>
    exit(1);
     db2:	4505                	li	a0,1
     db4:	00005097          	auipc	ra,0x5
     db8:	a7a080e7          	jalr	-1414(ra) # 582e <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
     dbc:	85a6                	mv	a1,s1
     dbe:	00005517          	auipc	a0,0x5
     dc2:	4da50513          	addi	a0,a0,1242 # 6298 <malloc+0x628>
     dc6:	00005097          	auipc	ra,0x5
     dca:	df2080e7          	jalr	-526(ra) # 5bb8 <printf>
    exit(1);
     dce:	4505                	li	a0,1
     dd0:	00005097          	auipc	ra,0x5
     dd4:	a5e080e7          	jalr	-1442(ra) # 582e <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
     dd8:	85a6                	mv	a1,s1
     dda:	00005517          	auipc	a0,0x5
     dde:	53650513          	addi	a0,a0,1334 # 6310 <malloc+0x6a0>
     de2:	00005097          	auipc	ra,0x5
     de6:	dd6080e7          	jalr	-554(ra) # 5bb8 <printf>
    exit(1);
     dea:	4505                	li	a0,1
     dec:	00005097          	auipc	ra,0x5
     df0:	a42080e7          	jalr	-1470(ra) # 582e <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
     df4:	85a6                	mv	a1,s1
     df6:	00005517          	auipc	a0,0x5
     dfa:	57a50513          	addi	a0,a0,1402 # 6370 <malloc+0x700>
     dfe:	00005097          	auipc	ra,0x5
     e02:	dba080e7          	jalr	-582(ra) # 5bb8 <printf>
    exit(1);
     e06:	4505                	li	a0,1
     e08:	00005097          	auipc	ra,0x5
     e0c:	a26080e7          	jalr	-1498(ra) # 582e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
     e10:	85a6                	mv	a1,s1
     e12:	00005517          	auipc	a0,0x5
     e16:	5b650513          	addi	a0,a0,1462 # 63c8 <malloc+0x758>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	d9e080e7          	jalr	-610(ra) # 5bb8 <printf>
    exit(1);
     e22:	4505                	li	a0,1
     e24:	00005097          	auipc	ra,0x5
     e28:	a0a080e7          	jalr	-1526(ra) # 582e <exit>

0000000000000e2c <iputtest>:
{
     e2c:	1101                	addi	sp,sp,-32
     e2e:	ec06                	sd	ra,24(sp)
     e30:	e822                	sd	s0,16(sp)
     e32:	e426                	sd	s1,8(sp)
     e34:	1000                	addi	s0,sp,32
     e36:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
     e38:	00005517          	auipc	a0,0x5
     e3c:	5c850513          	addi	a0,a0,1480 # 6400 <malloc+0x790>
     e40:	00005097          	auipc	ra,0x5
     e44:	a56080e7          	jalr	-1450(ra) # 5896 <mkdir>
     e48:	04054563          	bltz	a0,e92 <iputtest+0x66>
  if(chdir("iputdir") < 0){
     e4c:	00005517          	auipc	a0,0x5
     e50:	5b450513          	addi	a0,a0,1460 # 6400 <malloc+0x790>
     e54:	00005097          	auipc	ra,0x5
     e58:	a4a080e7          	jalr	-1462(ra) # 589e <chdir>
     e5c:	04054963          	bltz	a0,eae <iputtest+0x82>
  if(unlink("../iputdir") < 0){
     e60:	00005517          	auipc	a0,0x5
     e64:	5e050513          	addi	a0,a0,1504 # 6440 <malloc+0x7d0>
     e68:	00005097          	auipc	ra,0x5
     e6c:	a16080e7          	jalr	-1514(ra) # 587e <unlink>
     e70:	04054d63          	bltz	a0,eca <iputtest+0x9e>
  if(chdir("/") < 0){
     e74:	00005517          	auipc	a0,0x5
     e78:	5fc50513          	addi	a0,a0,1532 # 6470 <malloc+0x800>
     e7c:	00005097          	auipc	ra,0x5
     e80:	a22080e7          	jalr	-1502(ra) # 589e <chdir>
     e84:	06054163          	bltz	a0,ee6 <iputtest+0xba>
}
     e88:	60e2                	ld	ra,24(sp)
     e8a:	6442                	ld	s0,16(sp)
     e8c:	64a2                	ld	s1,8(sp)
     e8e:	6105                	addi	sp,sp,32
     e90:	8082                	ret
    printf("%s: mkdir failed\n", s);
     e92:	85a6                	mv	a1,s1
     e94:	00005517          	auipc	a0,0x5
     e98:	57450513          	addi	a0,a0,1396 # 6408 <malloc+0x798>
     e9c:	00005097          	auipc	ra,0x5
     ea0:	d1c080e7          	jalr	-740(ra) # 5bb8 <printf>
    exit(1);
     ea4:	4505                	li	a0,1
     ea6:	00005097          	auipc	ra,0x5
     eaa:	988080e7          	jalr	-1656(ra) # 582e <exit>
    printf("%s: chdir iputdir failed\n", s);
     eae:	85a6                	mv	a1,s1
     eb0:	00005517          	auipc	a0,0x5
     eb4:	57050513          	addi	a0,a0,1392 # 6420 <malloc+0x7b0>
     eb8:	00005097          	auipc	ra,0x5
     ebc:	d00080e7          	jalr	-768(ra) # 5bb8 <printf>
    exit(1);
     ec0:	4505                	li	a0,1
     ec2:	00005097          	auipc	ra,0x5
     ec6:	96c080e7          	jalr	-1684(ra) # 582e <exit>
    printf("%s: unlink ../iputdir failed\n", s);
     eca:	85a6                	mv	a1,s1
     ecc:	00005517          	auipc	a0,0x5
     ed0:	58450513          	addi	a0,a0,1412 # 6450 <malloc+0x7e0>
     ed4:	00005097          	auipc	ra,0x5
     ed8:	ce4080e7          	jalr	-796(ra) # 5bb8 <printf>
    exit(1);
     edc:	4505                	li	a0,1
     ede:	00005097          	auipc	ra,0x5
     ee2:	950080e7          	jalr	-1712(ra) # 582e <exit>
    printf("%s: chdir / failed\n", s);
     ee6:	85a6                	mv	a1,s1
     ee8:	00005517          	auipc	a0,0x5
     eec:	59050513          	addi	a0,a0,1424 # 6478 <malloc+0x808>
     ef0:	00005097          	auipc	ra,0x5
     ef4:	cc8080e7          	jalr	-824(ra) # 5bb8 <printf>
    exit(1);
     ef8:	4505                	li	a0,1
     efa:	00005097          	auipc	ra,0x5
     efe:	934080e7          	jalr	-1740(ra) # 582e <exit>

0000000000000f02 <exitiputtest>:
{
     f02:	7179                	addi	sp,sp,-48
     f04:	f406                	sd	ra,40(sp)
     f06:	f022                	sd	s0,32(sp)
     f08:	ec26                	sd	s1,24(sp)
     f0a:	1800                	addi	s0,sp,48
     f0c:	84aa                	mv	s1,a0
  pid = fork();
     f0e:	00005097          	auipc	ra,0x5
     f12:	918080e7          	jalr	-1768(ra) # 5826 <fork>
  if(pid < 0){
     f16:	04054663          	bltz	a0,f62 <exitiputtest+0x60>
  if(pid == 0){
     f1a:	ed45                	bnez	a0,fd2 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     f1c:	00005517          	auipc	a0,0x5
     f20:	4e450513          	addi	a0,a0,1252 # 6400 <malloc+0x790>
     f24:	00005097          	auipc	ra,0x5
     f28:	972080e7          	jalr	-1678(ra) # 5896 <mkdir>
     f2c:	04054963          	bltz	a0,f7e <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
     f30:	00005517          	auipc	a0,0x5
     f34:	4d050513          	addi	a0,a0,1232 # 6400 <malloc+0x790>
     f38:	00005097          	auipc	ra,0x5
     f3c:	966080e7          	jalr	-1690(ra) # 589e <chdir>
     f40:	04054d63          	bltz	a0,f9a <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
     f44:	00005517          	auipc	a0,0x5
     f48:	4fc50513          	addi	a0,a0,1276 # 6440 <malloc+0x7d0>
     f4c:	00005097          	auipc	ra,0x5
     f50:	932080e7          	jalr	-1742(ra) # 587e <unlink>
     f54:	06054163          	bltz	a0,fb6 <exitiputtest+0xb4>
    exit(0);
     f58:	4501                	li	a0,0
     f5a:	00005097          	auipc	ra,0x5
     f5e:	8d4080e7          	jalr	-1836(ra) # 582e <exit>
    printf("%s: fork failed\n", s);
     f62:	85a6                	mv	a1,s1
     f64:	00005517          	auipc	a0,0x5
     f68:	14450513          	addi	a0,a0,324 # 60a8 <malloc+0x438>
     f6c:	00005097          	auipc	ra,0x5
     f70:	c4c080e7          	jalr	-948(ra) # 5bb8 <printf>
    exit(1);
     f74:	4505                	li	a0,1
     f76:	00005097          	auipc	ra,0x5
     f7a:	8b8080e7          	jalr	-1864(ra) # 582e <exit>
      printf("%s: mkdir failed\n", s);
     f7e:	85a6                	mv	a1,s1
     f80:	00005517          	auipc	a0,0x5
     f84:	48850513          	addi	a0,a0,1160 # 6408 <malloc+0x798>
     f88:	00005097          	auipc	ra,0x5
     f8c:	c30080e7          	jalr	-976(ra) # 5bb8 <printf>
      exit(1);
     f90:	4505                	li	a0,1
     f92:	00005097          	auipc	ra,0x5
     f96:	89c080e7          	jalr	-1892(ra) # 582e <exit>
      printf("%s: child chdir failed\n", s);
     f9a:	85a6                	mv	a1,s1
     f9c:	00005517          	auipc	a0,0x5
     fa0:	4f450513          	addi	a0,a0,1268 # 6490 <malloc+0x820>
     fa4:	00005097          	auipc	ra,0x5
     fa8:	c14080e7          	jalr	-1004(ra) # 5bb8 <printf>
      exit(1);
     fac:	4505                	li	a0,1
     fae:	00005097          	auipc	ra,0x5
     fb2:	880080e7          	jalr	-1920(ra) # 582e <exit>
      printf("%s: unlink ../iputdir failed\n", s);
     fb6:	85a6                	mv	a1,s1
     fb8:	00005517          	auipc	a0,0x5
     fbc:	49850513          	addi	a0,a0,1176 # 6450 <malloc+0x7e0>
     fc0:	00005097          	auipc	ra,0x5
     fc4:	bf8080e7          	jalr	-1032(ra) # 5bb8 <printf>
      exit(1);
     fc8:	4505                	li	a0,1
     fca:	00005097          	auipc	ra,0x5
     fce:	864080e7          	jalr	-1948(ra) # 582e <exit>
  wait(&xstatus);
     fd2:	fdc40513          	addi	a0,s0,-36
     fd6:	00005097          	auipc	ra,0x5
     fda:	860080e7          	jalr	-1952(ra) # 5836 <wait>
  exit(xstatus);
     fde:	fdc42503          	lw	a0,-36(s0)
     fe2:	00005097          	auipc	ra,0x5
     fe6:	84c080e7          	jalr	-1972(ra) # 582e <exit>

0000000000000fea <rmdot>:
{
     fea:	1101                	addi	sp,sp,-32
     fec:	ec06                	sd	ra,24(sp)
     fee:	e822                	sd	s0,16(sp)
     ff0:	e426                	sd	s1,8(sp)
     ff2:	1000                	addi	s0,sp,32
     ff4:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
     ff6:	00005517          	auipc	a0,0x5
     ffa:	4b250513          	addi	a0,a0,1202 # 64a8 <malloc+0x838>
     ffe:	00005097          	auipc	ra,0x5
    1002:	898080e7          	jalr	-1896(ra) # 5896 <mkdir>
    1006:	e549                	bnez	a0,1090 <rmdot+0xa6>
  if(chdir("dots") != 0){
    1008:	00005517          	auipc	a0,0x5
    100c:	4a050513          	addi	a0,a0,1184 # 64a8 <malloc+0x838>
    1010:	00005097          	auipc	ra,0x5
    1014:	88e080e7          	jalr	-1906(ra) # 589e <chdir>
    1018:	e951                	bnez	a0,10ac <rmdot+0xc2>
  if(unlink(".") == 0){
    101a:	00005517          	auipc	a0,0x5
    101e:	4c650513          	addi	a0,a0,1222 # 64e0 <malloc+0x870>
    1022:	00005097          	auipc	ra,0x5
    1026:	85c080e7          	jalr	-1956(ra) # 587e <unlink>
    102a:	cd59                	beqz	a0,10c8 <rmdot+0xde>
  if(unlink("..") == 0){
    102c:	00005517          	auipc	a0,0x5
    1030:	4d450513          	addi	a0,a0,1236 # 6500 <malloc+0x890>
    1034:	00005097          	auipc	ra,0x5
    1038:	84a080e7          	jalr	-1974(ra) # 587e <unlink>
    103c:	c545                	beqz	a0,10e4 <rmdot+0xfa>
  if(chdir("/") != 0){
    103e:	00005517          	auipc	a0,0x5
    1042:	43250513          	addi	a0,a0,1074 # 6470 <malloc+0x800>
    1046:	00005097          	auipc	ra,0x5
    104a:	858080e7          	jalr	-1960(ra) # 589e <chdir>
    104e:	e94d                	bnez	a0,1100 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    1050:	00005517          	auipc	a0,0x5
    1054:	4d050513          	addi	a0,a0,1232 # 6520 <malloc+0x8b0>
    1058:	00005097          	auipc	ra,0x5
    105c:	826080e7          	jalr	-2010(ra) # 587e <unlink>
    1060:	cd55                	beqz	a0,111c <rmdot+0x132>
  if(unlink("dots/..") == 0){
    1062:	00005517          	auipc	a0,0x5
    1066:	4e650513          	addi	a0,a0,1254 # 6548 <malloc+0x8d8>
    106a:	00005097          	auipc	ra,0x5
    106e:	814080e7          	jalr	-2028(ra) # 587e <unlink>
    1072:	c179                	beqz	a0,1138 <rmdot+0x14e>
  if(unlink("dots") != 0){
    1074:	00005517          	auipc	a0,0x5
    1078:	43450513          	addi	a0,a0,1076 # 64a8 <malloc+0x838>
    107c:	00005097          	auipc	ra,0x5
    1080:	802080e7          	jalr	-2046(ra) # 587e <unlink>
    1084:	e961                	bnez	a0,1154 <rmdot+0x16a>
}
    1086:	60e2                	ld	ra,24(sp)
    1088:	6442                	ld	s0,16(sp)
    108a:	64a2                	ld	s1,8(sp)
    108c:	6105                	addi	sp,sp,32
    108e:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    1090:	85a6                	mv	a1,s1
    1092:	00005517          	auipc	a0,0x5
    1096:	41e50513          	addi	a0,a0,1054 # 64b0 <malloc+0x840>
    109a:	00005097          	auipc	ra,0x5
    109e:	b1e080e7          	jalr	-1250(ra) # 5bb8 <printf>
    exit(1);
    10a2:	4505                	li	a0,1
    10a4:	00004097          	auipc	ra,0x4
    10a8:	78a080e7          	jalr	1930(ra) # 582e <exit>
    printf("%s: chdir dots failed\n", s);
    10ac:	85a6                	mv	a1,s1
    10ae:	00005517          	auipc	a0,0x5
    10b2:	41a50513          	addi	a0,a0,1050 # 64c8 <malloc+0x858>
    10b6:	00005097          	auipc	ra,0x5
    10ba:	b02080e7          	jalr	-1278(ra) # 5bb8 <printf>
    exit(1);
    10be:	4505                	li	a0,1
    10c0:	00004097          	auipc	ra,0x4
    10c4:	76e080e7          	jalr	1902(ra) # 582e <exit>
    printf("%s: rm . worked!\n", s);
    10c8:	85a6                	mv	a1,s1
    10ca:	00005517          	auipc	a0,0x5
    10ce:	41e50513          	addi	a0,a0,1054 # 64e8 <malloc+0x878>
    10d2:	00005097          	auipc	ra,0x5
    10d6:	ae6080e7          	jalr	-1306(ra) # 5bb8 <printf>
    exit(1);
    10da:	4505                	li	a0,1
    10dc:	00004097          	auipc	ra,0x4
    10e0:	752080e7          	jalr	1874(ra) # 582e <exit>
    printf("%s: rm .. worked!\n", s);
    10e4:	85a6                	mv	a1,s1
    10e6:	00005517          	auipc	a0,0x5
    10ea:	42250513          	addi	a0,a0,1058 # 6508 <malloc+0x898>
    10ee:	00005097          	auipc	ra,0x5
    10f2:	aca080e7          	jalr	-1334(ra) # 5bb8 <printf>
    exit(1);
    10f6:	4505                	li	a0,1
    10f8:	00004097          	auipc	ra,0x4
    10fc:	736080e7          	jalr	1846(ra) # 582e <exit>
    printf("%s: chdir / failed\n", s);
    1100:	85a6                	mv	a1,s1
    1102:	00005517          	auipc	a0,0x5
    1106:	37650513          	addi	a0,a0,886 # 6478 <malloc+0x808>
    110a:	00005097          	auipc	ra,0x5
    110e:	aae080e7          	jalr	-1362(ra) # 5bb8 <printf>
    exit(1);
    1112:	4505                	li	a0,1
    1114:	00004097          	auipc	ra,0x4
    1118:	71a080e7          	jalr	1818(ra) # 582e <exit>
    printf("%s: unlink dots/. worked!\n", s);
    111c:	85a6                	mv	a1,s1
    111e:	00005517          	auipc	a0,0x5
    1122:	40a50513          	addi	a0,a0,1034 # 6528 <malloc+0x8b8>
    1126:	00005097          	auipc	ra,0x5
    112a:	a92080e7          	jalr	-1390(ra) # 5bb8 <printf>
    exit(1);
    112e:	4505                	li	a0,1
    1130:	00004097          	auipc	ra,0x4
    1134:	6fe080e7          	jalr	1790(ra) # 582e <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    1138:	85a6                	mv	a1,s1
    113a:	00005517          	auipc	a0,0x5
    113e:	41650513          	addi	a0,a0,1046 # 6550 <malloc+0x8e0>
    1142:	00005097          	auipc	ra,0x5
    1146:	a76080e7          	jalr	-1418(ra) # 5bb8 <printf>
    exit(1);
    114a:	4505                	li	a0,1
    114c:	00004097          	auipc	ra,0x4
    1150:	6e2080e7          	jalr	1762(ra) # 582e <exit>
    printf("%s: unlink dots failed!\n", s);
    1154:	85a6                	mv	a1,s1
    1156:	00005517          	auipc	a0,0x5
    115a:	41a50513          	addi	a0,a0,1050 # 6570 <malloc+0x900>
    115e:	00005097          	auipc	ra,0x5
    1162:	a5a080e7          	jalr	-1446(ra) # 5bb8 <printf>
    exit(1);
    1166:	4505                	li	a0,1
    1168:	00004097          	auipc	ra,0x4
    116c:	6c6080e7          	jalr	1734(ra) # 582e <exit>

0000000000001170 <dirfile>:
{
    1170:	1101                	addi	sp,sp,-32
    1172:	ec06                	sd	ra,24(sp)
    1174:	e822                	sd	s0,16(sp)
    1176:	e426                	sd	s1,8(sp)
    1178:	e04a                	sd	s2,0(sp)
    117a:	1000                	addi	s0,sp,32
    117c:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    117e:	20000593          	li	a1,512
    1182:	00005517          	auipc	a0,0x5
    1186:	40e50513          	addi	a0,a0,1038 # 6590 <malloc+0x920>
    118a:	00004097          	auipc	ra,0x4
    118e:	6e4080e7          	jalr	1764(ra) # 586e <open>
  if(fd < 0){
    1192:	0e054d63          	bltz	a0,128c <dirfile+0x11c>
  close(fd);
    1196:	00004097          	auipc	ra,0x4
    119a:	6c0080e7          	jalr	1728(ra) # 5856 <close>
  if(chdir("dirfile") == 0){
    119e:	00005517          	auipc	a0,0x5
    11a2:	3f250513          	addi	a0,a0,1010 # 6590 <malloc+0x920>
    11a6:	00004097          	auipc	ra,0x4
    11aa:	6f8080e7          	jalr	1784(ra) # 589e <chdir>
    11ae:	cd6d                	beqz	a0,12a8 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    11b0:	4581                	li	a1,0
    11b2:	00005517          	auipc	a0,0x5
    11b6:	42650513          	addi	a0,a0,1062 # 65d8 <malloc+0x968>
    11ba:	00004097          	auipc	ra,0x4
    11be:	6b4080e7          	jalr	1716(ra) # 586e <open>
  if(fd >= 0){
    11c2:	10055163          	bgez	a0,12c4 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    11c6:	20000593          	li	a1,512
    11ca:	00005517          	auipc	a0,0x5
    11ce:	40e50513          	addi	a0,a0,1038 # 65d8 <malloc+0x968>
    11d2:	00004097          	auipc	ra,0x4
    11d6:	69c080e7          	jalr	1692(ra) # 586e <open>
  if(fd >= 0){
    11da:	10055363          	bgez	a0,12e0 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    11de:	00005517          	auipc	a0,0x5
    11e2:	3fa50513          	addi	a0,a0,1018 # 65d8 <malloc+0x968>
    11e6:	00004097          	auipc	ra,0x4
    11ea:	6b0080e7          	jalr	1712(ra) # 5896 <mkdir>
    11ee:	10050763          	beqz	a0,12fc <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    11f2:	00005517          	auipc	a0,0x5
    11f6:	3e650513          	addi	a0,a0,998 # 65d8 <malloc+0x968>
    11fa:	00004097          	auipc	ra,0x4
    11fe:	684080e7          	jalr	1668(ra) # 587e <unlink>
    1202:	10050b63          	beqz	a0,1318 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    1206:	00005597          	auipc	a1,0x5
    120a:	3d258593          	addi	a1,a1,978 # 65d8 <malloc+0x968>
    120e:	00005517          	auipc	a0,0x5
    1212:	45250513          	addi	a0,a0,1106 # 6660 <malloc+0x9f0>
    1216:	00004097          	auipc	ra,0x4
    121a:	678080e7          	jalr	1656(ra) # 588e <link>
    121e:	10050b63          	beqz	a0,1334 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    1222:	00005517          	auipc	a0,0x5
    1226:	36e50513          	addi	a0,a0,878 # 6590 <malloc+0x920>
    122a:	00004097          	auipc	ra,0x4
    122e:	654080e7          	jalr	1620(ra) # 587e <unlink>
    1232:	10051f63          	bnez	a0,1350 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    1236:	4589                	li	a1,2
    1238:	00005517          	auipc	a0,0x5
    123c:	2a850513          	addi	a0,a0,680 # 64e0 <malloc+0x870>
    1240:	00004097          	auipc	ra,0x4
    1244:	62e080e7          	jalr	1582(ra) # 586e <open>
  if(fd >= 0){
    1248:	12055263          	bgez	a0,136c <dirfile+0x1fc>
  fd = open(".", 0);
    124c:	4581                	li	a1,0
    124e:	00005517          	auipc	a0,0x5
    1252:	29250513          	addi	a0,a0,658 # 64e0 <malloc+0x870>
    1256:	00004097          	auipc	ra,0x4
    125a:	618080e7          	jalr	1560(ra) # 586e <open>
    125e:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    1260:	4605                	li	a2,1
    1262:	00005597          	auipc	a1,0x5
    1266:	47658593          	addi	a1,a1,1142 # 66d8 <malloc+0xa68>
    126a:	00004097          	auipc	ra,0x4
    126e:	5e4080e7          	jalr	1508(ra) # 584e <write>
    1272:	10a04b63          	bgtz	a0,1388 <dirfile+0x218>
  close(fd);
    1276:	8526                	mv	a0,s1
    1278:	00004097          	auipc	ra,0x4
    127c:	5de080e7          	jalr	1502(ra) # 5856 <close>
}
    1280:	60e2                	ld	ra,24(sp)
    1282:	6442                	ld	s0,16(sp)
    1284:	64a2                	ld	s1,8(sp)
    1286:	6902                	ld	s2,0(sp)
    1288:	6105                	addi	sp,sp,32
    128a:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    128c:	85ca                	mv	a1,s2
    128e:	00005517          	auipc	a0,0x5
    1292:	30a50513          	addi	a0,a0,778 # 6598 <malloc+0x928>
    1296:	00005097          	auipc	ra,0x5
    129a:	922080e7          	jalr	-1758(ra) # 5bb8 <printf>
    exit(1);
    129e:	4505                	li	a0,1
    12a0:	00004097          	auipc	ra,0x4
    12a4:	58e080e7          	jalr	1422(ra) # 582e <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    12a8:	85ca                	mv	a1,s2
    12aa:	00005517          	auipc	a0,0x5
    12ae:	30e50513          	addi	a0,a0,782 # 65b8 <malloc+0x948>
    12b2:	00005097          	auipc	ra,0x5
    12b6:	906080e7          	jalr	-1786(ra) # 5bb8 <printf>
    exit(1);
    12ba:	4505                	li	a0,1
    12bc:	00004097          	auipc	ra,0x4
    12c0:	572080e7          	jalr	1394(ra) # 582e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    12c4:	85ca                	mv	a1,s2
    12c6:	00005517          	auipc	a0,0x5
    12ca:	32250513          	addi	a0,a0,802 # 65e8 <malloc+0x978>
    12ce:	00005097          	auipc	ra,0x5
    12d2:	8ea080e7          	jalr	-1814(ra) # 5bb8 <printf>
    exit(1);
    12d6:	4505                	li	a0,1
    12d8:	00004097          	auipc	ra,0x4
    12dc:	556080e7          	jalr	1366(ra) # 582e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    12e0:	85ca                	mv	a1,s2
    12e2:	00005517          	auipc	a0,0x5
    12e6:	30650513          	addi	a0,a0,774 # 65e8 <malloc+0x978>
    12ea:	00005097          	auipc	ra,0x5
    12ee:	8ce080e7          	jalr	-1842(ra) # 5bb8 <printf>
    exit(1);
    12f2:	4505                	li	a0,1
    12f4:	00004097          	auipc	ra,0x4
    12f8:	53a080e7          	jalr	1338(ra) # 582e <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    12fc:	85ca                	mv	a1,s2
    12fe:	00005517          	auipc	a0,0x5
    1302:	31250513          	addi	a0,a0,786 # 6610 <malloc+0x9a0>
    1306:	00005097          	auipc	ra,0x5
    130a:	8b2080e7          	jalr	-1870(ra) # 5bb8 <printf>
    exit(1);
    130e:	4505                	li	a0,1
    1310:	00004097          	auipc	ra,0x4
    1314:	51e080e7          	jalr	1310(ra) # 582e <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    1318:	85ca                	mv	a1,s2
    131a:	00005517          	auipc	a0,0x5
    131e:	31e50513          	addi	a0,a0,798 # 6638 <malloc+0x9c8>
    1322:	00005097          	auipc	ra,0x5
    1326:	896080e7          	jalr	-1898(ra) # 5bb8 <printf>
    exit(1);
    132a:	4505                	li	a0,1
    132c:	00004097          	auipc	ra,0x4
    1330:	502080e7          	jalr	1282(ra) # 582e <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    1334:	85ca                	mv	a1,s2
    1336:	00005517          	auipc	a0,0x5
    133a:	33250513          	addi	a0,a0,818 # 6668 <malloc+0x9f8>
    133e:	00005097          	auipc	ra,0x5
    1342:	87a080e7          	jalr	-1926(ra) # 5bb8 <printf>
    exit(1);
    1346:	4505                	li	a0,1
    1348:	00004097          	auipc	ra,0x4
    134c:	4e6080e7          	jalr	1254(ra) # 582e <exit>
    printf("%s: unlink dirfile failed!\n", s);
    1350:	85ca                	mv	a1,s2
    1352:	00005517          	auipc	a0,0x5
    1356:	33e50513          	addi	a0,a0,830 # 6690 <malloc+0xa20>
    135a:	00005097          	auipc	ra,0x5
    135e:	85e080e7          	jalr	-1954(ra) # 5bb8 <printf>
    exit(1);
    1362:	4505                	li	a0,1
    1364:	00004097          	auipc	ra,0x4
    1368:	4ca080e7          	jalr	1226(ra) # 582e <exit>
    printf("%s: open . for writing succeeded!\n", s);
    136c:	85ca                	mv	a1,s2
    136e:	00005517          	auipc	a0,0x5
    1372:	34250513          	addi	a0,a0,834 # 66b0 <malloc+0xa40>
    1376:	00005097          	auipc	ra,0x5
    137a:	842080e7          	jalr	-1982(ra) # 5bb8 <printf>
    exit(1);
    137e:	4505                	li	a0,1
    1380:	00004097          	auipc	ra,0x4
    1384:	4ae080e7          	jalr	1198(ra) # 582e <exit>
    printf("%s: write . succeeded!\n", s);
    1388:	85ca                	mv	a1,s2
    138a:	00005517          	auipc	a0,0x5
    138e:	35650513          	addi	a0,a0,854 # 66e0 <malloc+0xa70>
    1392:	00005097          	auipc	ra,0x5
    1396:	826080e7          	jalr	-2010(ra) # 5bb8 <printf>
    exit(1);
    139a:	4505                	li	a0,1
    139c:	00004097          	auipc	ra,0x4
    13a0:	492080e7          	jalr	1170(ra) # 582e <exit>

00000000000013a4 <iref>:
{
    13a4:	7139                	addi	sp,sp,-64
    13a6:	fc06                	sd	ra,56(sp)
    13a8:	f822                	sd	s0,48(sp)
    13aa:	f426                	sd	s1,40(sp)
    13ac:	f04a                	sd	s2,32(sp)
    13ae:	ec4e                	sd	s3,24(sp)
    13b0:	e852                	sd	s4,16(sp)
    13b2:	e456                	sd	s5,8(sp)
    13b4:	e05a                	sd	s6,0(sp)
    13b6:	0080                	addi	s0,sp,64
    13b8:	8b2a                	mv	s6,a0
    13ba:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    13be:	00005a17          	auipc	s4,0x5
    13c2:	33aa0a13          	addi	s4,s4,826 # 66f8 <malloc+0xa88>
    mkdir("");
    13c6:	00006497          	auipc	s1,0x6
    13ca:	1c248493          	addi	s1,s1,450 # 7588 <malloc+0x1918>
    link("README", "");
    13ce:	00005a97          	auipc	s5,0x5
    13d2:	292a8a93          	addi	s5,s5,658 # 6660 <malloc+0x9f0>
    fd = open("xx", O_CREATE);
    13d6:	00005997          	auipc	s3,0x5
    13da:	20a98993          	addi	s3,s3,522 # 65e0 <malloc+0x970>
    13de:	a891                	j	1432 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    13e0:	85da                	mv	a1,s6
    13e2:	00005517          	auipc	a0,0x5
    13e6:	31e50513          	addi	a0,a0,798 # 6700 <malloc+0xa90>
    13ea:	00004097          	auipc	ra,0x4
    13ee:	7ce080e7          	jalr	1998(ra) # 5bb8 <printf>
      exit(1);
    13f2:	4505                	li	a0,1
    13f4:	00004097          	auipc	ra,0x4
    13f8:	43a080e7          	jalr	1082(ra) # 582e <exit>
      printf("%s: chdir irefd failed\n", s);
    13fc:	85da                	mv	a1,s6
    13fe:	00005517          	auipc	a0,0x5
    1402:	31a50513          	addi	a0,a0,794 # 6718 <malloc+0xaa8>
    1406:	00004097          	auipc	ra,0x4
    140a:	7b2080e7          	jalr	1970(ra) # 5bb8 <printf>
      exit(1);
    140e:	4505                	li	a0,1
    1410:	00004097          	auipc	ra,0x4
    1414:	41e080e7          	jalr	1054(ra) # 582e <exit>
      close(fd);
    1418:	00004097          	auipc	ra,0x4
    141c:	43e080e7          	jalr	1086(ra) # 5856 <close>
    1420:	a889                	j	1472 <iref+0xce>
    unlink("xx");
    1422:	854e                	mv	a0,s3
    1424:	00004097          	auipc	ra,0x4
    1428:	45a080e7          	jalr	1114(ra) # 587e <unlink>
  for(i = 0; i < NINODE + 1; i++){
    142c:	397d                	addiw	s2,s2,-1
    142e:	06090063          	beqz	s2,148e <iref+0xea>
    if(mkdir("irefd") != 0){
    1432:	8552                	mv	a0,s4
    1434:	00004097          	auipc	ra,0x4
    1438:	462080e7          	jalr	1122(ra) # 5896 <mkdir>
    143c:	f155                	bnez	a0,13e0 <iref+0x3c>
    if(chdir("irefd") != 0){
    143e:	8552                	mv	a0,s4
    1440:	00004097          	auipc	ra,0x4
    1444:	45e080e7          	jalr	1118(ra) # 589e <chdir>
    1448:	f955                	bnez	a0,13fc <iref+0x58>
    mkdir("");
    144a:	8526                	mv	a0,s1
    144c:	00004097          	auipc	ra,0x4
    1450:	44a080e7          	jalr	1098(ra) # 5896 <mkdir>
    link("README", "");
    1454:	85a6                	mv	a1,s1
    1456:	8556                	mv	a0,s5
    1458:	00004097          	auipc	ra,0x4
    145c:	436080e7          	jalr	1078(ra) # 588e <link>
    fd = open("", O_CREATE);
    1460:	20000593          	li	a1,512
    1464:	8526                	mv	a0,s1
    1466:	00004097          	auipc	ra,0x4
    146a:	408080e7          	jalr	1032(ra) # 586e <open>
    if(fd >= 0)
    146e:	fa0555e3          	bgez	a0,1418 <iref+0x74>
    fd = open("xx", O_CREATE);
    1472:	20000593          	li	a1,512
    1476:	854e                	mv	a0,s3
    1478:	00004097          	auipc	ra,0x4
    147c:	3f6080e7          	jalr	1014(ra) # 586e <open>
    if(fd >= 0)
    1480:	fa0541e3          	bltz	a0,1422 <iref+0x7e>
      close(fd);
    1484:	00004097          	auipc	ra,0x4
    1488:	3d2080e7          	jalr	978(ra) # 5856 <close>
    148c:	bf59                	j	1422 <iref+0x7e>
    148e:	03300493          	li	s1,51
    chdir("..");
    1492:	00005997          	auipc	s3,0x5
    1496:	06e98993          	addi	s3,s3,110 # 6500 <malloc+0x890>
    unlink("irefd");
    149a:	00005917          	auipc	s2,0x5
    149e:	25e90913          	addi	s2,s2,606 # 66f8 <malloc+0xa88>
    chdir("..");
    14a2:	854e                	mv	a0,s3
    14a4:	00004097          	auipc	ra,0x4
    14a8:	3fa080e7          	jalr	1018(ra) # 589e <chdir>
    unlink("irefd");
    14ac:	854a                	mv	a0,s2
    14ae:	00004097          	auipc	ra,0x4
    14b2:	3d0080e7          	jalr	976(ra) # 587e <unlink>
  for(i = 0; i < NINODE + 1; i++){
    14b6:	34fd                	addiw	s1,s1,-1
    14b8:	f4ed                	bnez	s1,14a2 <iref+0xfe>
  chdir("/");
    14ba:	00005517          	auipc	a0,0x5
    14be:	fb650513          	addi	a0,a0,-74 # 6470 <malloc+0x800>
    14c2:	00004097          	auipc	ra,0x4
    14c6:	3dc080e7          	jalr	988(ra) # 589e <chdir>
}
    14ca:	70e2                	ld	ra,56(sp)
    14cc:	7442                	ld	s0,48(sp)
    14ce:	74a2                	ld	s1,40(sp)
    14d0:	7902                	ld	s2,32(sp)
    14d2:	69e2                	ld	s3,24(sp)
    14d4:	6a42                	ld	s4,16(sp)
    14d6:	6aa2                	ld	s5,8(sp)
    14d8:	6b02                	ld	s6,0(sp)
    14da:	6121                	addi	sp,sp,64
    14dc:	8082                	ret

00000000000014de <openiputtest>:
{
    14de:	7179                	addi	sp,sp,-48
    14e0:	f406                	sd	ra,40(sp)
    14e2:	f022                	sd	s0,32(sp)
    14e4:	ec26                	sd	s1,24(sp)
    14e6:	1800                	addi	s0,sp,48
    14e8:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    14ea:	00005517          	auipc	a0,0x5
    14ee:	24650513          	addi	a0,a0,582 # 6730 <malloc+0xac0>
    14f2:	00004097          	auipc	ra,0x4
    14f6:	3a4080e7          	jalr	932(ra) # 5896 <mkdir>
    14fa:	04054263          	bltz	a0,153e <openiputtest+0x60>
  pid = fork();
    14fe:	00004097          	auipc	ra,0x4
    1502:	328080e7          	jalr	808(ra) # 5826 <fork>
  if(pid < 0){
    1506:	04054a63          	bltz	a0,155a <openiputtest+0x7c>
  if(pid == 0){
    150a:	e93d                	bnez	a0,1580 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    150c:	4589                	li	a1,2
    150e:	00005517          	auipc	a0,0x5
    1512:	22250513          	addi	a0,a0,546 # 6730 <malloc+0xac0>
    1516:	00004097          	auipc	ra,0x4
    151a:	358080e7          	jalr	856(ra) # 586e <open>
    if(fd >= 0){
    151e:	04054c63          	bltz	a0,1576 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    1522:	85a6                	mv	a1,s1
    1524:	00005517          	auipc	a0,0x5
    1528:	22c50513          	addi	a0,a0,556 # 6750 <malloc+0xae0>
    152c:	00004097          	auipc	ra,0x4
    1530:	68c080e7          	jalr	1676(ra) # 5bb8 <printf>
      exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	2f8080e7          	jalr	760(ra) # 582e <exit>
    printf("%s: mkdir oidir failed\n", s);
    153e:	85a6                	mv	a1,s1
    1540:	00005517          	auipc	a0,0x5
    1544:	1f850513          	addi	a0,a0,504 # 6738 <malloc+0xac8>
    1548:	00004097          	auipc	ra,0x4
    154c:	670080e7          	jalr	1648(ra) # 5bb8 <printf>
    exit(1);
    1550:	4505                	li	a0,1
    1552:	00004097          	auipc	ra,0x4
    1556:	2dc080e7          	jalr	732(ra) # 582e <exit>
    printf("%s: fork failed\n", s);
    155a:	85a6                	mv	a1,s1
    155c:	00005517          	auipc	a0,0x5
    1560:	b4c50513          	addi	a0,a0,-1204 # 60a8 <malloc+0x438>
    1564:	00004097          	auipc	ra,0x4
    1568:	654080e7          	jalr	1620(ra) # 5bb8 <printf>
    exit(1);
    156c:	4505                	li	a0,1
    156e:	00004097          	auipc	ra,0x4
    1572:	2c0080e7          	jalr	704(ra) # 582e <exit>
    exit(0);
    1576:	4501                	li	a0,0
    1578:	00004097          	auipc	ra,0x4
    157c:	2b6080e7          	jalr	694(ra) # 582e <exit>
  sleep(1);
    1580:	4505                	li	a0,1
    1582:	00004097          	auipc	ra,0x4
    1586:	33c080e7          	jalr	828(ra) # 58be <sleep>
  if(unlink("oidir") != 0){
    158a:	00005517          	auipc	a0,0x5
    158e:	1a650513          	addi	a0,a0,422 # 6730 <malloc+0xac0>
    1592:	00004097          	auipc	ra,0x4
    1596:	2ec080e7          	jalr	748(ra) # 587e <unlink>
    159a:	cd19                	beqz	a0,15b8 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    159c:	85a6                	mv	a1,s1
    159e:	00005517          	auipc	a0,0x5
    15a2:	1da50513          	addi	a0,a0,474 # 6778 <malloc+0xb08>
    15a6:	00004097          	auipc	ra,0x4
    15aa:	612080e7          	jalr	1554(ra) # 5bb8 <printf>
    exit(1);
    15ae:	4505                	li	a0,1
    15b0:	00004097          	auipc	ra,0x4
    15b4:	27e080e7          	jalr	638(ra) # 582e <exit>
  wait(&xstatus);
    15b8:	fdc40513          	addi	a0,s0,-36
    15bc:	00004097          	auipc	ra,0x4
    15c0:	27a080e7          	jalr	634(ra) # 5836 <wait>
  exit(xstatus);
    15c4:	fdc42503          	lw	a0,-36(s0)
    15c8:	00004097          	auipc	ra,0x4
    15cc:	266080e7          	jalr	614(ra) # 582e <exit>

00000000000015d0 <killstatus>:
{
    15d0:	7139                	addi	sp,sp,-64
    15d2:	fc06                	sd	ra,56(sp)
    15d4:	f822                	sd	s0,48(sp)
    15d6:	f426                	sd	s1,40(sp)
    15d8:	f04a                	sd	s2,32(sp)
    15da:	ec4e                	sd	s3,24(sp)
    15dc:	e852                	sd	s4,16(sp)
    15de:	0080                	addi	s0,sp,64
    15e0:	8a2a                	mv	s4,a0
    15e2:	06400913          	li	s2,100
    if(xst != -1) {
    15e6:	59fd                	li	s3,-1
    int pid1 = fork();
    15e8:	00004097          	auipc	ra,0x4
    15ec:	23e080e7          	jalr	574(ra) # 5826 <fork>
    15f0:	84aa                	mv	s1,a0
    if(pid1 < 0){
    15f2:	02054f63          	bltz	a0,1630 <killstatus+0x60>
    if(pid1 == 0){
    15f6:	c939                	beqz	a0,164c <killstatus+0x7c>
    sleep(1);
    15f8:	4505                	li	a0,1
    15fa:	00004097          	auipc	ra,0x4
    15fe:	2c4080e7          	jalr	708(ra) # 58be <sleep>
    kill(pid1);
    1602:	8526                	mv	a0,s1
    1604:	00004097          	auipc	ra,0x4
    1608:	25a080e7          	jalr	602(ra) # 585e <kill>
    wait(&xst);
    160c:	fcc40513          	addi	a0,s0,-52
    1610:	00004097          	auipc	ra,0x4
    1614:	226080e7          	jalr	550(ra) # 5836 <wait>
    if(xst != -1) {
    1618:	fcc42783          	lw	a5,-52(s0)
    161c:	03379d63          	bne	a5,s3,1656 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    1620:	397d                	addiw	s2,s2,-1
    1622:	fc0913e3          	bnez	s2,15e8 <killstatus+0x18>
  exit(0);
    1626:	4501                	li	a0,0
    1628:	00004097          	auipc	ra,0x4
    162c:	206080e7          	jalr	518(ra) # 582e <exit>
      printf("%s: fork failed\n", s);
    1630:	85d2                	mv	a1,s4
    1632:	00005517          	auipc	a0,0x5
    1636:	a7650513          	addi	a0,a0,-1418 # 60a8 <malloc+0x438>
    163a:	00004097          	auipc	ra,0x4
    163e:	57e080e7          	jalr	1406(ra) # 5bb8 <printf>
      exit(1);
    1642:	4505                	li	a0,1
    1644:	00004097          	auipc	ra,0x4
    1648:	1ea080e7          	jalr	490(ra) # 582e <exit>
        getpid();
    164c:	00004097          	auipc	ra,0x4
    1650:	262080e7          	jalr	610(ra) # 58ae <getpid>
      while(1) {
    1654:	bfe5                	j	164c <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    1656:	85d2                	mv	a1,s4
    1658:	00005517          	auipc	a0,0x5
    165c:	13850513          	addi	a0,a0,312 # 6790 <malloc+0xb20>
    1660:	00004097          	auipc	ra,0x4
    1664:	558080e7          	jalr	1368(ra) # 5bb8 <printf>
       exit(1);
    1668:	4505                	li	a0,1
    166a:	00004097          	auipc	ra,0x4
    166e:	1c4080e7          	jalr	452(ra) # 582e <exit>

0000000000001672 <preempt>:
{
    1672:	7139                	addi	sp,sp,-64
    1674:	fc06                	sd	ra,56(sp)
    1676:	f822                	sd	s0,48(sp)
    1678:	f426                	sd	s1,40(sp)
    167a:	f04a                	sd	s2,32(sp)
    167c:	ec4e                	sd	s3,24(sp)
    167e:	e852                	sd	s4,16(sp)
    1680:	0080                	addi	s0,sp,64
    1682:	892a                	mv	s2,a0
  pid1 = fork();
    1684:	00004097          	auipc	ra,0x4
    1688:	1a2080e7          	jalr	418(ra) # 5826 <fork>
  if(pid1 < 0) {
    168c:	00054563          	bltz	a0,1696 <preempt+0x24>
    1690:	84aa                	mv	s1,a0
  if(pid1 == 0)
    1692:	e105                	bnez	a0,16b2 <preempt+0x40>
    for(;;)
    1694:	a001                	j	1694 <preempt+0x22>
    printf("%s: fork failed", s);
    1696:	85ca                	mv	a1,s2
    1698:	00005517          	auipc	a0,0x5
    169c:	11850513          	addi	a0,a0,280 # 67b0 <malloc+0xb40>
    16a0:	00004097          	auipc	ra,0x4
    16a4:	518080e7          	jalr	1304(ra) # 5bb8 <printf>
    exit(1);
    16a8:	4505                	li	a0,1
    16aa:	00004097          	auipc	ra,0x4
    16ae:	184080e7          	jalr	388(ra) # 582e <exit>
  pid2 = fork();
    16b2:	00004097          	auipc	ra,0x4
    16b6:	174080e7          	jalr	372(ra) # 5826 <fork>
    16ba:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    16bc:	00054463          	bltz	a0,16c4 <preempt+0x52>
  if(pid2 == 0)
    16c0:	e105                	bnez	a0,16e0 <preempt+0x6e>
    for(;;)
    16c2:	a001                	j	16c2 <preempt+0x50>
    printf("%s: fork failed\n", s);
    16c4:	85ca                	mv	a1,s2
    16c6:	00005517          	auipc	a0,0x5
    16ca:	9e250513          	addi	a0,a0,-1566 # 60a8 <malloc+0x438>
    16ce:	00004097          	auipc	ra,0x4
    16d2:	4ea080e7          	jalr	1258(ra) # 5bb8 <printf>
    exit(1);
    16d6:	4505                	li	a0,1
    16d8:	00004097          	auipc	ra,0x4
    16dc:	156080e7          	jalr	342(ra) # 582e <exit>
  pipe(pfds);
    16e0:	fc840513          	addi	a0,s0,-56
    16e4:	00004097          	auipc	ra,0x4
    16e8:	15a080e7          	jalr	346(ra) # 583e <pipe>
  pid3 = fork();
    16ec:	00004097          	auipc	ra,0x4
    16f0:	13a080e7          	jalr	314(ra) # 5826 <fork>
    16f4:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    16f6:	02054e63          	bltz	a0,1732 <preempt+0xc0>
  if(pid3 == 0){
    16fa:	e525                	bnez	a0,1762 <preempt+0xf0>
    close(pfds[0]);
    16fc:	fc842503          	lw	a0,-56(s0)
    1700:	00004097          	auipc	ra,0x4
    1704:	156080e7          	jalr	342(ra) # 5856 <close>
    if(write(pfds[1], "x", 1) != 1)
    1708:	4605                	li	a2,1
    170a:	00005597          	auipc	a1,0x5
    170e:	fce58593          	addi	a1,a1,-50 # 66d8 <malloc+0xa68>
    1712:	fcc42503          	lw	a0,-52(s0)
    1716:	00004097          	auipc	ra,0x4
    171a:	138080e7          	jalr	312(ra) # 584e <write>
    171e:	4785                	li	a5,1
    1720:	02f51763          	bne	a0,a5,174e <preempt+0xdc>
    close(pfds[1]);
    1724:	fcc42503          	lw	a0,-52(s0)
    1728:	00004097          	auipc	ra,0x4
    172c:	12e080e7          	jalr	302(ra) # 5856 <close>
    for(;;)
    1730:	a001                	j	1730 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    1732:	85ca                	mv	a1,s2
    1734:	00005517          	auipc	a0,0x5
    1738:	97450513          	addi	a0,a0,-1676 # 60a8 <malloc+0x438>
    173c:	00004097          	auipc	ra,0x4
    1740:	47c080e7          	jalr	1148(ra) # 5bb8 <printf>
     exit(1);
    1744:	4505                	li	a0,1
    1746:	00004097          	auipc	ra,0x4
    174a:	0e8080e7          	jalr	232(ra) # 582e <exit>
      printf("%s: preempt write error", s);
    174e:	85ca                	mv	a1,s2
    1750:	00005517          	auipc	a0,0x5
    1754:	07050513          	addi	a0,a0,112 # 67c0 <malloc+0xb50>
    1758:	00004097          	auipc	ra,0x4
    175c:	460080e7          	jalr	1120(ra) # 5bb8 <printf>
    1760:	b7d1                	j	1724 <preempt+0xb2>
  close(pfds[1]);
    1762:	fcc42503          	lw	a0,-52(s0)
    1766:	00004097          	auipc	ra,0x4
    176a:	0f0080e7          	jalr	240(ra) # 5856 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    176e:	660d                	lui	a2,0x3
    1770:	0000a597          	auipc	a1,0xa
    1774:	26058593          	addi	a1,a1,608 # b9d0 <buf>
    1778:	fc842503          	lw	a0,-56(s0)
    177c:	00004097          	auipc	ra,0x4
    1780:	0ca080e7          	jalr	202(ra) # 5846 <read>
    1784:	4785                	li	a5,1
    1786:	02f50363          	beq	a0,a5,17ac <preempt+0x13a>
    printf("%s: preempt read error", s);
    178a:	85ca                	mv	a1,s2
    178c:	00005517          	auipc	a0,0x5
    1790:	04c50513          	addi	a0,a0,76 # 67d8 <malloc+0xb68>
    1794:	00004097          	auipc	ra,0x4
    1798:	424080e7          	jalr	1060(ra) # 5bb8 <printf>
}
    179c:	70e2                	ld	ra,56(sp)
    179e:	7442                	ld	s0,48(sp)
    17a0:	74a2                	ld	s1,40(sp)
    17a2:	7902                	ld	s2,32(sp)
    17a4:	69e2                	ld	s3,24(sp)
    17a6:	6a42                	ld	s4,16(sp)
    17a8:	6121                	addi	sp,sp,64
    17aa:	8082                	ret
  close(pfds[0]);
    17ac:	fc842503          	lw	a0,-56(s0)
    17b0:	00004097          	auipc	ra,0x4
    17b4:	0a6080e7          	jalr	166(ra) # 5856 <close>
  printf("kill... ");
    17b8:	00005517          	auipc	a0,0x5
    17bc:	03850513          	addi	a0,a0,56 # 67f0 <malloc+0xb80>
    17c0:	00004097          	auipc	ra,0x4
    17c4:	3f8080e7          	jalr	1016(ra) # 5bb8 <printf>
  kill(pid1);
    17c8:	8526                	mv	a0,s1
    17ca:	00004097          	auipc	ra,0x4
    17ce:	094080e7          	jalr	148(ra) # 585e <kill>
  kill(pid2);
    17d2:	854e                	mv	a0,s3
    17d4:	00004097          	auipc	ra,0x4
    17d8:	08a080e7          	jalr	138(ra) # 585e <kill>
  kill(pid3);
    17dc:	8552                	mv	a0,s4
    17de:	00004097          	auipc	ra,0x4
    17e2:	080080e7          	jalr	128(ra) # 585e <kill>
  printf("wait... ");
    17e6:	00005517          	auipc	a0,0x5
    17ea:	01a50513          	addi	a0,a0,26 # 6800 <malloc+0xb90>
    17ee:	00004097          	auipc	ra,0x4
    17f2:	3ca080e7          	jalr	970(ra) # 5bb8 <printf>
  wait(0);
    17f6:	4501                	li	a0,0
    17f8:	00004097          	auipc	ra,0x4
    17fc:	03e080e7          	jalr	62(ra) # 5836 <wait>
  wait(0);
    1800:	4501                	li	a0,0
    1802:	00004097          	auipc	ra,0x4
    1806:	034080e7          	jalr	52(ra) # 5836 <wait>
  wait(0);
    180a:	4501                	li	a0,0
    180c:	00004097          	auipc	ra,0x4
    1810:	02a080e7          	jalr	42(ra) # 5836 <wait>
    1814:	b761                	j	179c <preempt+0x12a>

0000000000001816 <sbrkfail>:
{
    1816:	7119                	addi	sp,sp,-128
    1818:	fc86                	sd	ra,120(sp)
    181a:	f8a2                	sd	s0,112(sp)
    181c:	f4a6                	sd	s1,104(sp)
    181e:	f0ca                	sd	s2,96(sp)
    1820:	ecce                	sd	s3,88(sp)
    1822:	e8d2                	sd	s4,80(sp)
    1824:	e4d6                	sd	s5,72(sp)
    1826:	0100                	addi	s0,sp,128
    1828:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    182a:	fb040513          	addi	a0,s0,-80
    182e:	00004097          	auipc	ra,0x4
    1832:	010080e7          	jalr	16(ra) # 583e <pipe>
    1836:	e901                	bnez	a0,1846 <sbrkfail+0x30>
    1838:	f8040493          	addi	s1,s0,-128
    183c:	fa840993          	addi	s3,s0,-88
    1840:	8926                	mv	s2,s1
    if(pids[i] != -1)
    1842:	5a7d                	li	s4,-1
    1844:	a085                	j	18a4 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    1846:	85d6                	mv	a1,s5
    1848:	00004517          	auipc	a0,0x4
    184c:	7e050513          	addi	a0,a0,2016 # 6028 <malloc+0x3b8>
    1850:	00004097          	auipc	ra,0x4
    1854:	368080e7          	jalr	872(ra) # 5bb8 <printf>
    exit(1);
    1858:	4505                	li	a0,1
    185a:	00004097          	auipc	ra,0x4
    185e:	fd4080e7          	jalr	-44(ra) # 582e <exit>
      sbrk(BIG - (uint64)sbrk(0));
    1862:	00004097          	auipc	ra,0x4
    1866:	054080e7          	jalr	84(ra) # 58b6 <sbrk>
    186a:	064007b7          	lui	a5,0x6400
    186e:	40a7853b          	subw	a0,a5,a0
    1872:	00004097          	auipc	ra,0x4
    1876:	044080e7          	jalr	68(ra) # 58b6 <sbrk>
      write(fds[1], "x", 1);
    187a:	4605                	li	a2,1
    187c:	00005597          	auipc	a1,0x5
    1880:	e5c58593          	addi	a1,a1,-420 # 66d8 <malloc+0xa68>
    1884:	fb442503          	lw	a0,-76(s0)
    1888:	00004097          	auipc	ra,0x4
    188c:	fc6080e7          	jalr	-58(ra) # 584e <write>
      for(;;) sleep(1000);
    1890:	3e800513          	li	a0,1000
    1894:	00004097          	auipc	ra,0x4
    1898:	02a080e7          	jalr	42(ra) # 58be <sleep>
    189c:	bfd5                	j	1890 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    189e:	0911                	addi	s2,s2,4
    18a0:	03390563          	beq	s2,s3,18ca <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    18a4:	00004097          	auipc	ra,0x4
    18a8:	f82080e7          	jalr	-126(ra) # 5826 <fork>
    18ac:	00a92023          	sw	a0,0(s2)
    18b0:	d94d                	beqz	a0,1862 <sbrkfail+0x4c>
    if(pids[i] != -1)
    18b2:	ff4506e3          	beq	a0,s4,189e <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    18b6:	4605                	li	a2,1
    18b8:	faf40593          	addi	a1,s0,-81
    18bc:	fb042503          	lw	a0,-80(s0)
    18c0:	00004097          	auipc	ra,0x4
    18c4:	f86080e7          	jalr	-122(ra) # 5846 <read>
    18c8:	bfd9                	j	189e <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    18ca:	6505                	lui	a0,0x1
    18cc:	00004097          	auipc	ra,0x4
    18d0:	fea080e7          	jalr	-22(ra) # 58b6 <sbrk>
    18d4:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    18d6:	597d                	li	s2,-1
    18d8:	a021                	j	18e0 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    18da:	0491                	addi	s1,s1,4
    18dc:	01348f63          	beq	s1,s3,18fa <sbrkfail+0xe4>
    if(pids[i] == -1)
    18e0:	4088                	lw	a0,0(s1)
    18e2:	ff250ce3          	beq	a0,s2,18da <sbrkfail+0xc4>
    kill(pids[i]);
    18e6:	00004097          	auipc	ra,0x4
    18ea:	f78080e7          	jalr	-136(ra) # 585e <kill>
    wait(0);
    18ee:	4501                	li	a0,0
    18f0:	00004097          	auipc	ra,0x4
    18f4:	f46080e7          	jalr	-186(ra) # 5836 <wait>
    18f8:	b7cd                	j	18da <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    18fa:	57fd                	li	a5,-1
    18fc:	04fa0163          	beq	s4,a5,193e <sbrkfail+0x128>
  pid = fork();
    1900:	00004097          	auipc	ra,0x4
    1904:	f26080e7          	jalr	-218(ra) # 5826 <fork>
    1908:	84aa                	mv	s1,a0
  if(pid < 0){
    190a:	04054863          	bltz	a0,195a <sbrkfail+0x144>
  if(pid == 0){
    190e:	c525                	beqz	a0,1976 <sbrkfail+0x160>
  wait(&xstatus);
    1910:	fbc40513          	addi	a0,s0,-68
    1914:	00004097          	auipc	ra,0x4
    1918:	f22080e7          	jalr	-222(ra) # 5836 <wait>
  if(xstatus != -1 && xstatus != 2)
    191c:	fbc42783          	lw	a5,-68(s0)
    1920:	577d                	li	a4,-1
    1922:	00e78563          	beq	a5,a4,192c <sbrkfail+0x116>
    1926:	4709                	li	a4,2
    1928:	08e79d63          	bne	a5,a4,19c2 <sbrkfail+0x1ac>
}
    192c:	70e6                	ld	ra,120(sp)
    192e:	7446                	ld	s0,112(sp)
    1930:	74a6                	ld	s1,104(sp)
    1932:	7906                	ld	s2,96(sp)
    1934:	69e6                	ld	s3,88(sp)
    1936:	6a46                	ld	s4,80(sp)
    1938:	6aa6                	ld	s5,72(sp)
    193a:	6109                	addi	sp,sp,128
    193c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    193e:	85d6                	mv	a1,s5
    1940:	00005517          	auipc	a0,0x5
    1944:	ed050513          	addi	a0,a0,-304 # 6810 <malloc+0xba0>
    1948:	00004097          	auipc	ra,0x4
    194c:	270080e7          	jalr	624(ra) # 5bb8 <printf>
    exit(1);
    1950:	4505                	li	a0,1
    1952:	00004097          	auipc	ra,0x4
    1956:	edc080e7          	jalr	-292(ra) # 582e <exit>
    printf("%s: fork failed\n", s);
    195a:	85d6                	mv	a1,s5
    195c:	00004517          	auipc	a0,0x4
    1960:	74c50513          	addi	a0,a0,1868 # 60a8 <malloc+0x438>
    1964:	00004097          	auipc	ra,0x4
    1968:	254080e7          	jalr	596(ra) # 5bb8 <printf>
    exit(1);
    196c:	4505                	li	a0,1
    196e:	00004097          	auipc	ra,0x4
    1972:	ec0080e7          	jalr	-320(ra) # 582e <exit>
    a = sbrk(0);
    1976:	4501                	li	a0,0
    1978:	00004097          	auipc	ra,0x4
    197c:	f3e080e7          	jalr	-194(ra) # 58b6 <sbrk>
    1980:	892a                	mv	s2,a0
    sbrk(10*BIG);
    1982:	3e800537          	lui	a0,0x3e800
    1986:	00004097          	auipc	ra,0x4
    198a:	f30080e7          	jalr	-208(ra) # 58b6 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    198e:	87ca                	mv	a5,s2
    1990:	3e800737          	lui	a4,0x3e800
    1994:	993a                	add	s2,s2,a4
    1996:	6705                	lui	a4,0x1
      n += *(a+i);
    1998:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1620>
    199c:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    199e:	97ba                	add	a5,a5,a4
    19a0:	ff279ce3          	bne	a5,s2,1998 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    19a4:	8626                	mv	a2,s1
    19a6:	85d6                	mv	a1,s5
    19a8:	00005517          	auipc	a0,0x5
    19ac:	e8850513          	addi	a0,a0,-376 # 6830 <malloc+0xbc0>
    19b0:	00004097          	auipc	ra,0x4
    19b4:	208080e7          	jalr	520(ra) # 5bb8 <printf>
    exit(1);
    19b8:	4505                	li	a0,1
    19ba:	00004097          	auipc	ra,0x4
    19be:	e74080e7          	jalr	-396(ra) # 582e <exit>
    exit(1);
    19c2:	4505                	li	a0,1
    19c4:	00004097          	auipc	ra,0x4
    19c8:	e6a080e7          	jalr	-406(ra) # 582e <exit>

00000000000019cc <mem>:
{
    19cc:	7139                	addi	sp,sp,-64
    19ce:	fc06                	sd	ra,56(sp)
    19d0:	f822                	sd	s0,48(sp)
    19d2:	f426                	sd	s1,40(sp)
    19d4:	f04a                	sd	s2,32(sp)
    19d6:	ec4e                	sd	s3,24(sp)
    19d8:	0080                	addi	s0,sp,64
    19da:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    19dc:	00004097          	auipc	ra,0x4
    19e0:	e4a080e7          	jalr	-438(ra) # 5826 <fork>
    m1 = 0;
    19e4:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    19e6:	6909                	lui	s2,0x2
    19e8:	71190913          	addi	s2,s2,1809 # 2711 <truncate3+0x3d>
  if((pid = fork()) == 0){
    19ec:	c115                	beqz	a0,1a10 <mem+0x44>
    wait(&xstatus);
    19ee:	fcc40513          	addi	a0,s0,-52
    19f2:	00004097          	auipc	ra,0x4
    19f6:	e44080e7          	jalr	-444(ra) # 5836 <wait>
    if(xstatus == -1){
    19fa:	fcc42503          	lw	a0,-52(s0)
    19fe:	57fd                	li	a5,-1
    1a00:	06f50363          	beq	a0,a5,1a66 <mem+0x9a>
    exit(xstatus);
    1a04:	00004097          	auipc	ra,0x4
    1a08:	e2a080e7          	jalr	-470(ra) # 582e <exit>
      *(char**)m2 = m1;
    1a0c:	e104                	sd	s1,0(a0)
      m1 = m2;
    1a0e:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    1a10:	854a                	mv	a0,s2
    1a12:	00004097          	auipc	ra,0x4
    1a16:	25e080e7          	jalr	606(ra) # 5c70 <malloc>
    1a1a:	f96d                	bnez	a0,1a0c <mem+0x40>
    while(m1){
    1a1c:	c881                	beqz	s1,1a2c <mem+0x60>
      m2 = *(char**)m1;
    1a1e:	8526                	mv	a0,s1
    1a20:	6084                	ld	s1,0(s1)
      free(m1);
    1a22:	00004097          	auipc	ra,0x4
    1a26:	1cc080e7          	jalr	460(ra) # 5bee <free>
    while(m1){
    1a2a:	f8f5                	bnez	s1,1a1e <mem+0x52>
    m1 = malloc(1024*20);
    1a2c:	6515                	lui	a0,0x5
    1a2e:	00004097          	auipc	ra,0x4
    1a32:	242080e7          	jalr	578(ra) # 5c70 <malloc>
    if(m1 == 0){
    1a36:	c911                	beqz	a0,1a4a <mem+0x7e>
    free(m1);
    1a38:	00004097          	auipc	ra,0x4
    1a3c:	1b6080e7          	jalr	438(ra) # 5bee <free>
    exit(0);
    1a40:	4501                	li	a0,0
    1a42:	00004097          	auipc	ra,0x4
    1a46:	dec080e7          	jalr	-532(ra) # 582e <exit>
      printf("couldn't allocate mem?!!\n", s);
    1a4a:	85ce                	mv	a1,s3
    1a4c:	00005517          	auipc	a0,0x5
    1a50:	e1450513          	addi	a0,a0,-492 # 6860 <malloc+0xbf0>
    1a54:	00004097          	auipc	ra,0x4
    1a58:	164080e7          	jalr	356(ra) # 5bb8 <printf>
      exit(1);
    1a5c:	4505                	li	a0,1
    1a5e:	00004097          	auipc	ra,0x4
    1a62:	dd0080e7          	jalr	-560(ra) # 582e <exit>
      exit(0);
    1a66:	4501                	li	a0,0
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	dc6080e7          	jalr	-570(ra) # 582e <exit>

0000000000001a70 <bigfile>:
{
    1a70:	7139                	addi	sp,sp,-64
    1a72:	fc06                	sd	ra,56(sp)
    1a74:	f822                	sd	s0,48(sp)
    1a76:	f426                	sd	s1,40(sp)
    1a78:	f04a                	sd	s2,32(sp)
    1a7a:	ec4e                	sd	s3,24(sp)
    1a7c:	e852                	sd	s4,16(sp)
    1a7e:	e456                	sd	s5,8(sp)
    1a80:	0080                	addi	s0,sp,64
    1a82:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    1a84:	00005517          	auipc	a0,0x5
    1a88:	dfc50513          	addi	a0,a0,-516 # 6880 <malloc+0xc10>
    1a8c:	00004097          	auipc	ra,0x4
    1a90:	df2080e7          	jalr	-526(ra) # 587e <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    1a94:	20200593          	li	a1,514
    1a98:	00005517          	auipc	a0,0x5
    1a9c:	de850513          	addi	a0,a0,-536 # 6880 <malloc+0xc10>
    1aa0:	00004097          	auipc	ra,0x4
    1aa4:	dce080e7          	jalr	-562(ra) # 586e <open>
    1aa8:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    1aaa:	4481                	li	s1,0
    memset(buf, i, SZ);
    1aac:	0000a917          	auipc	s2,0xa
    1ab0:	f2490913          	addi	s2,s2,-220 # b9d0 <buf>
  for(i = 0; i < N; i++){
    1ab4:	4a51                	li	s4,20
  if(fd < 0){
    1ab6:	0a054063          	bltz	a0,1b56 <bigfile+0xe6>
    memset(buf, i, SZ);
    1aba:	25800613          	li	a2,600
    1abe:	85a6                	mv	a1,s1
    1ac0:	854a                	mv	a0,s2
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	b72080e7          	jalr	-1166(ra) # 5634 <memset>
    if(write(fd, buf, SZ) != SZ){
    1aca:	25800613          	li	a2,600
    1ace:	85ca                	mv	a1,s2
    1ad0:	854e                	mv	a0,s3
    1ad2:	00004097          	auipc	ra,0x4
    1ad6:	d7c080e7          	jalr	-644(ra) # 584e <write>
    1ada:	25800793          	li	a5,600
    1ade:	08f51a63          	bne	a0,a5,1b72 <bigfile+0x102>
  for(i = 0; i < N; i++){
    1ae2:	2485                	addiw	s1,s1,1
    1ae4:	fd449be3          	bne	s1,s4,1aba <bigfile+0x4a>
  close(fd);
    1ae8:	854e                	mv	a0,s3
    1aea:	00004097          	auipc	ra,0x4
    1aee:	d6c080e7          	jalr	-660(ra) # 5856 <close>
  fd = open("bigfile.dat", 0);
    1af2:	4581                	li	a1,0
    1af4:	00005517          	auipc	a0,0x5
    1af8:	d8c50513          	addi	a0,a0,-628 # 6880 <malloc+0xc10>
    1afc:	00004097          	auipc	ra,0x4
    1b00:	d72080e7          	jalr	-654(ra) # 586e <open>
    1b04:	8a2a                	mv	s4,a0
  total = 0;
    1b06:	4981                	li	s3,0
  for(i = 0; ; i++){
    1b08:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    1b0a:	0000a917          	auipc	s2,0xa
    1b0e:	ec690913          	addi	s2,s2,-314 # b9d0 <buf>
  if(fd < 0){
    1b12:	06054e63          	bltz	a0,1b8e <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    1b16:	12c00613          	li	a2,300
    1b1a:	85ca                	mv	a1,s2
    1b1c:	8552                	mv	a0,s4
    1b1e:	00004097          	auipc	ra,0x4
    1b22:	d28080e7          	jalr	-728(ra) # 5846 <read>
    if(cc < 0){
    1b26:	08054263          	bltz	a0,1baa <bigfile+0x13a>
    if(cc == 0)
    1b2a:	c971                	beqz	a0,1bfe <bigfile+0x18e>
    if(cc != SZ/2){
    1b2c:	12c00793          	li	a5,300
    1b30:	08f51b63          	bne	a0,a5,1bc6 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    1b34:	01f4d79b          	srliw	a5,s1,0x1f
    1b38:	9fa5                	addw	a5,a5,s1
    1b3a:	4017d79b          	sraiw	a5,a5,0x1
    1b3e:	00094703          	lbu	a4,0(s2)
    1b42:	0af71063          	bne	a4,a5,1be2 <bigfile+0x172>
    1b46:	12b94703          	lbu	a4,299(s2)
    1b4a:	08f71c63          	bne	a4,a5,1be2 <bigfile+0x172>
    total += cc;
    1b4e:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    1b52:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    1b54:	b7c9                	j	1b16 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    1b56:	85d6                	mv	a1,s5
    1b58:	00005517          	auipc	a0,0x5
    1b5c:	d3850513          	addi	a0,a0,-712 # 6890 <malloc+0xc20>
    1b60:	00004097          	auipc	ra,0x4
    1b64:	058080e7          	jalr	88(ra) # 5bb8 <printf>
    exit(1);
    1b68:	4505                	li	a0,1
    1b6a:	00004097          	auipc	ra,0x4
    1b6e:	cc4080e7          	jalr	-828(ra) # 582e <exit>
      printf("%s: write bigfile failed\n", s);
    1b72:	85d6                	mv	a1,s5
    1b74:	00005517          	auipc	a0,0x5
    1b78:	d3c50513          	addi	a0,a0,-708 # 68b0 <malloc+0xc40>
    1b7c:	00004097          	auipc	ra,0x4
    1b80:	03c080e7          	jalr	60(ra) # 5bb8 <printf>
      exit(1);
    1b84:	4505                	li	a0,1
    1b86:	00004097          	auipc	ra,0x4
    1b8a:	ca8080e7          	jalr	-856(ra) # 582e <exit>
    printf("%s: cannot open bigfile\n", s);
    1b8e:	85d6                	mv	a1,s5
    1b90:	00005517          	auipc	a0,0x5
    1b94:	d4050513          	addi	a0,a0,-704 # 68d0 <malloc+0xc60>
    1b98:	00004097          	auipc	ra,0x4
    1b9c:	020080e7          	jalr	32(ra) # 5bb8 <printf>
    exit(1);
    1ba0:	4505                	li	a0,1
    1ba2:	00004097          	auipc	ra,0x4
    1ba6:	c8c080e7          	jalr	-884(ra) # 582e <exit>
      printf("%s: read bigfile failed\n", s);
    1baa:	85d6                	mv	a1,s5
    1bac:	00005517          	auipc	a0,0x5
    1bb0:	d4450513          	addi	a0,a0,-700 # 68f0 <malloc+0xc80>
    1bb4:	00004097          	auipc	ra,0x4
    1bb8:	004080e7          	jalr	4(ra) # 5bb8 <printf>
      exit(1);
    1bbc:	4505                	li	a0,1
    1bbe:	00004097          	auipc	ra,0x4
    1bc2:	c70080e7          	jalr	-912(ra) # 582e <exit>
      printf("%s: short read bigfile\n", s);
    1bc6:	85d6                	mv	a1,s5
    1bc8:	00005517          	auipc	a0,0x5
    1bcc:	d4850513          	addi	a0,a0,-696 # 6910 <malloc+0xca0>
    1bd0:	00004097          	auipc	ra,0x4
    1bd4:	fe8080e7          	jalr	-24(ra) # 5bb8 <printf>
      exit(1);
    1bd8:	4505                	li	a0,1
    1bda:	00004097          	auipc	ra,0x4
    1bde:	c54080e7          	jalr	-940(ra) # 582e <exit>
      printf("%s: read bigfile wrong data\n", s);
    1be2:	85d6                	mv	a1,s5
    1be4:	00005517          	auipc	a0,0x5
    1be8:	d4450513          	addi	a0,a0,-700 # 6928 <malloc+0xcb8>
    1bec:	00004097          	auipc	ra,0x4
    1bf0:	fcc080e7          	jalr	-52(ra) # 5bb8 <printf>
      exit(1);
    1bf4:	4505                	li	a0,1
    1bf6:	00004097          	auipc	ra,0x4
    1bfa:	c38080e7          	jalr	-968(ra) # 582e <exit>
  close(fd);
    1bfe:	8552                	mv	a0,s4
    1c00:	00004097          	auipc	ra,0x4
    1c04:	c56080e7          	jalr	-938(ra) # 5856 <close>
  if(total != N*SZ){
    1c08:	678d                	lui	a5,0x3
    1c0a:	ee078793          	addi	a5,a5,-288 # 2ee0 <sharedfd+0x54>
    1c0e:	02f99363          	bne	s3,a5,1c34 <bigfile+0x1c4>
  unlink("bigfile.dat");
    1c12:	00005517          	auipc	a0,0x5
    1c16:	c6e50513          	addi	a0,a0,-914 # 6880 <malloc+0xc10>
    1c1a:	00004097          	auipc	ra,0x4
    1c1e:	c64080e7          	jalr	-924(ra) # 587e <unlink>
}
    1c22:	70e2                	ld	ra,56(sp)
    1c24:	7442                	ld	s0,48(sp)
    1c26:	74a2                	ld	s1,40(sp)
    1c28:	7902                	ld	s2,32(sp)
    1c2a:	69e2                	ld	s3,24(sp)
    1c2c:	6a42                	ld	s4,16(sp)
    1c2e:	6aa2                	ld	s5,8(sp)
    1c30:	6121                	addi	sp,sp,64
    1c32:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    1c34:	85d6                	mv	a1,s5
    1c36:	00005517          	auipc	a0,0x5
    1c3a:	d1250513          	addi	a0,a0,-750 # 6948 <malloc+0xcd8>
    1c3e:	00004097          	auipc	ra,0x4
    1c42:	f7a080e7          	jalr	-134(ra) # 5bb8 <printf>
    exit(1);
    1c46:	4505                	li	a0,1
    1c48:	00004097          	auipc	ra,0x4
    1c4c:	be6080e7          	jalr	-1050(ra) # 582e <exit>

0000000000001c50 <copyin>:
{
    1c50:	715d                	addi	sp,sp,-80
    1c52:	e486                	sd	ra,72(sp)
    1c54:	e0a2                	sd	s0,64(sp)
    1c56:	fc26                	sd	s1,56(sp)
    1c58:	f84a                	sd	s2,48(sp)
    1c5a:	f44e                	sd	s3,40(sp)
    1c5c:	f052                	sd	s4,32(sp)
    1c5e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
    1c60:	4785                	li	a5,1
    1c62:	07fe                	slli	a5,a5,0x1f
    1c64:	fcf43023          	sd	a5,-64(s0)
    1c68:	57fd                	li	a5,-1
    1c6a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
    1c6e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
    1c72:	00005a17          	auipc	s4,0x5
    1c76:	cf6a0a13          	addi	s4,s4,-778 # 6968 <malloc+0xcf8>
    uint64 addr = addrs[ai];
    1c7a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
    1c7e:	20100593          	li	a1,513
    1c82:	8552                	mv	a0,s4
    1c84:	00004097          	auipc	ra,0x4
    1c88:	bea080e7          	jalr	-1046(ra) # 586e <open>
    1c8c:	84aa                	mv	s1,a0
    if(fd < 0){
    1c8e:	08054863          	bltz	a0,1d1e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
    1c92:	6609                	lui	a2,0x2
    1c94:	85ce                	mv	a1,s3
    1c96:	00004097          	auipc	ra,0x4
    1c9a:	bb8080e7          	jalr	-1096(ra) # 584e <write>
    if(n >= 0){
    1c9e:	08055d63          	bgez	a0,1d38 <copyin+0xe8>
    close(fd);
    1ca2:	8526                	mv	a0,s1
    1ca4:	00004097          	auipc	ra,0x4
    1ca8:	bb2080e7          	jalr	-1102(ra) # 5856 <close>
    unlink("copyin1");
    1cac:	8552                	mv	a0,s4
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	bd0080e7          	jalr	-1072(ra) # 587e <unlink>
    n = write(1, (char*)addr, 8192);
    1cb6:	6609                	lui	a2,0x2
    1cb8:	85ce                	mv	a1,s3
    1cba:	4505                	li	a0,1
    1cbc:	00004097          	auipc	ra,0x4
    1cc0:	b92080e7          	jalr	-1134(ra) # 584e <write>
    if(n > 0){
    1cc4:	08a04963          	bgtz	a0,1d56 <copyin+0x106>
    if(pipe(fds) < 0){
    1cc8:	fb840513          	addi	a0,s0,-72
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	b72080e7          	jalr	-1166(ra) # 583e <pipe>
    1cd4:	0a054063          	bltz	a0,1d74 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
    1cd8:	6609                	lui	a2,0x2
    1cda:	85ce                	mv	a1,s3
    1cdc:	fbc42503          	lw	a0,-68(s0)
    1ce0:	00004097          	auipc	ra,0x4
    1ce4:	b6e080e7          	jalr	-1170(ra) # 584e <write>
    if(n > 0){
    1ce8:	0aa04363          	bgtz	a0,1d8e <copyin+0x13e>
    close(fds[0]);
    1cec:	fb842503          	lw	a0,-72(s0)
    1cf0:	00004097          	auipc	ra,0x4
    1cf4:	b66080e7          	jalr	-1178(ra) # 5856 <close>
    close(fds[1]);
    1cf8:	fbc42503          	lw	a0,-68(s0)
    1cfc:	00004097          	auipc	ra,0x4
    1d00:	b5a080e7          	jalr	-1190(ra) # 5856 <close>
  for(int ai = 0; ai < 2; ai++){
    1d04:	0921                	addi	s2,s2,8
    1d06:	fd040793          	addi	a5,s0,-48
    1d0a:	f6f918e3          	bne	s2,a5,1c7a <copyin+0x2a>
}
    1d0e:	60a6                	ld	ra,72(sp)
    1d10:	6406                	ld	s0,64(sp)
    1d12:	74e2                	ld	s1,56(sp)
    1d14:	7942                	ld	s2,48(sp)
    1d16:	79a2                	ld	s3,40(sp)
    1d18:	7a02                	ld	s4,32(sp)
    1d1a:	6161                	addi	sp,sp,80
    1d1c:	8082                	ret
      printf("open(copyin1) failed\n");
    1d1e:	00005517          	auipc	a0,0x5
    1d22:	c5250513          	addi	a0,a0,-942 # 6970 <malloc+0xd00>
    1d26:	00004097          	auipc	ra,0x4
    1d2a:	e92080e7          	jalr	-366(ra) # 5bb8 <printf>
      exit(1);
    1d2e:	4505                	li	a0,1
    1d30:	00004097          	auipc	ra,0x4
    1d34:	afe080e7          	jalr	-1282(ra) # 582e <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
    1d38:	862a                	mv	a2,a0
    1d3a:	85ce                	mv	a1,s3
    1d3c:	00005517          	auipc	a0,0x5
    1d40:	c4c50513          	addi	a0,a0,-948 # 6988 <malloc+0xd18>
    1d44:	00004097          	auipc	ra,0x4
    1d48:	e74080e7          	jalr	-396(ra) # 5bb8 <printf>
      exit(1);
    1d4c:	4505                	li	a0,1
    1d4e:	00004097          	auipc	ra,0x4
    1d52:	ae0080e7          	jalr	-1312(ra) # 582e <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
    1d56:	862a                	mv	a2,a0
    1d58:	85ce                	mv	a1,s3
    1d5a:	00005517          	auipc	a0,0x5
    1d5e:	c5e50513          	addi	a0,a0,-930 # 69b8 <malloc+0xd48>
    1d62:	00004097          	auipc	ra,0x4
    1d66:	e56080e7          	jalr	-426(ra) # 5bb8 <printf>
      exit(1);
    1d6a:	4505                	li	a0,1
    1d6c:	00004097          	auipc	ra,0x4
    1d70:	ac2080e7          	jalr	-1342(ra) # 582e <exit>
      printf("pipe() failed\n");
    1d74:	00005517          	auipc	a0,0x5
    1d78:	c7450513          	addi	a0,a0,-908 # 69e8 <malloc+0xd78>
    1d7c:	00004097          	auipc	ra,0x4
    1d80:	e3c080e7          	jalr	-452(ra) # 5bb8 <printf>
      exit(1);
    1d84:	4505                	li	a0,1
    1d86:	00004097          	auipc	ra,0x4
    1d8a:	aa8080e7          	jalr	-1368(ra) # 582e <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
    1d8e:	862a                	mv	a2,a0
    1d90:	85ce                	mv	a1,s3
    1d92:	00005517          	auipc	a0,0x5
    1d96:	c6650513          	addi	a0,a0,-922 # 69f8 <malloc+0xd88>
    1d9a:	00004097          	auipc	ra,0x4
    1d9e:	e1e080e7          	jalr	-482(ra) # 5bb8 <printf>
      exit(1);
    1da2:	4505                	li	a0,1
    1da4:	00004097          	auipc	ra,0x4
    1da8:	a8a080e7          	jalr	-1398(ra) # 582e <exit>

0000000000001dac <copyout>:
{
    1dac:	711d                	addi	sp,sp,-96
    1dae:	ec86                	sd	ra,88(sp)
    1db0:	e8a2                	sd	s0,80(sp)
    1db2:	e4a6                	sd	s1,72(sp)
    1db4:	e0ca                	sd	s2,64(sp)
    1db6:	fc4e                	sd	s3,56(sp)
    1db8:	f852                	sd	s4,48(sp)
    1dba:	f456                	sd	s5,40(sp)
    1dbc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
    1dbe:	4785                	li	a5,1
    1dc0:	07fe                	slli	a5,a5,0x1f
    1dc2:	faf43823          	sd	a5,-80(s0)
    1dc6:	57fd                	li	a5,-1
    1dc8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
    1dcc:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
    1dd0:	00005a17          	auipc	s4,0x5
    1dd4:	890a0a13          	addi	s4,s4,-1904 # 6660 <malloc+0x9f0>
    n = write(fds[1], "x", 1);
    1dd8:	00005a97          	auipc	s5,0x5
    1ddc:	900a8a93          	addi	s5,s5,-1792 # 66d8 <malloc+0xa68>
    uint64 addr = addrs[ai];
    1de0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
    1de4:	4581                	li	a1,0
    1de6:	8552                	mv	a0,s4
    1de8:	00004097          	auipc	ra,0x4
    1dec:	a86080e7          	jalr	-1402(ra) # 586e <open>
    1df0:	84aa                	mv	s1,a0
    if(fd < 0){
    1df2:	08054663          	bltz	a0,1e7e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
    1df6:	6609                	lui	a2,0x2
    1df8:	85ce                	mv	a1,s3
    1dfa:	00004097          	auipc	ra,0x4
    1dfe:	a4c080e7          	jalr	-1460(ra) # 5846 <read>
    if(n > 0){
    1e02:	08a04b63          	bgtz	a0,1e98 <copyout+0xec>
    close(fd);
    1e06:	8526                	mv	a0,s1
    1e08:	00004097          	auipc	ra,0x4
    1e0c:	a4e080e7          	jalr	-1458(ra) # 5856 <close>
    if(pipe(fds) < 0){
    1e10:	fa840513          	addi	a0,s0,-88
    1e14:	00004097          	auipc	ra,0x4
    1e18:	a2a080e7          	jalr	-1494(ra) # 583e <pipe>
    1e1c:	08054d63          	bltz	a0,1eb6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
    1e20:	4605                	li	a2,1
    1e22:	85d6                	mv	a1,s5
    1e24:	fac42503          	lw	a0,-84(s0)
    1e28:	00004097          	auipc	ra,0x4
    1e2c:	a26080e7          	jalr	-1498(ra) # 584e <write>
    if(n != 1){
    1e30:	4785                	li	a5,1
    1e32:	08f51f63          	bne	a0,a5,1ed0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
    1e36:	6609                	lui	a2,0x2
    1e38:	85ce                	mv	a1,s3
    1e3a:	fa842503          	lw	a0,-88(s0)
    1e3e:	00004097          	auipc	ra,0x4
    1e42:	a08080e7          	jalr	-1528(ra) # 5846 <read>
    if(n > 0){
    1e46:	0aa04263          	bgtz	a0,1eea <copyout+0x13e>
    close(fds[0]);
    1e4a:	fa842503          	lw	a0,-88(s0)
    1e4e:	00004097          	auipc	ra,0x4
    1e52:	a08080e7          	jalr	-1528(ra) # 5856 <close>
    close(fds[1]);
    1e56:	fac42503          	lw	a0,-84(s0)
    1e5a:	00004097          	auipc	ra,0x4
    1e5e:	9fc080e7          	jalr	-1540(ra) # 5856 <close>
  for(int ai = 0; ai < 2; ai++){
    1e62:	0921                	addi	s2,s2,8
    1e64:	fc040793          	addi	a5,s0,-64
    1e68:	f6f91ce3          	bne	s2,a5,1de0 <copyout+0x34>
}
    1e6c:	60e6                	ld	ra,88(sp)
    1e6e:	6446                	ld	s0,80(sp)
    1e70:	64a6                	ld	s1,72(sp)
    1e72:	6906                	ld	s2,64(sp)
    1e74:	79e2                	ld	s3,56(sp)
    1e76:	7a42                	ld	s4,48(sp)
    1e78:	7aa2                	ld	s5,40(sp)
    1e7a:	6125                	addi	sp,sp,96
    1e7c:	8082                	ret
      printf("open(README) failed\n");
    1e7e:	00005517          	auipc	a0,0x5
    1e82:	baa50513          	addi	a0,a0,-1110 # 6a28 <malloc+0xdb8>
    1e86:	00004097          	auipc	ra,0x4
    1e8a:	d32080e7          	jalr	-718(ra) # 5bb8 <printf>
      exit(1);
    1e8e:	4505                	li	a0,1
    1e90:	00004097          	auipc	ra,0x4
    1e94:	99e080e7          	jalr	-1634(ra) # 582e <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
    1e98:	862a                	mv	a2,a0
    1e9a:	85ce                	mv	a1,s3
    1e9c:	00005517          	auipc	a0,0x5
    1ea0:	ba450513          	addi	a0,a0,-1116 # 6a40 <malloc+0xdd0>
    1ea4:	00004097          	auipc	ra,0x4
    1ea8:	d14080e7          	jalr	-748(ra) # 5bb8 <printf>
      exit(1);
    1eac:	4505                	li	a0,1
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	980080e7          	jalr	-1664(ra) # 582e <exit>
      printf("pipe() failed\n");
    1eb6:	00005517          	auipc	a0,0x5
    1eba:	b3250513          	addi	a0,a0,-1230 # 69e8 <malloc+0xd78>
    1ebe:	00004097          	auipc	ra,0x4
    1ec2:	cfa080e7          	jalr	-774(ra) # 5bb8 <printf>
      exit(1);
    1ec6:	4505                	li	a0,1
    1ec8:	00004097          	auipc	ra,0x4
    1ecc:	966080e7          	jalr	-1690(ra) # 582e <exit>
      printf("pipe write failed\n");
    1ed0:	00005517          	auipc	a0,0x5
    1ed4:	ba050513          	addi	a0,a0,-1120 # 6a70 <malloc+0xe00>
    1ed8:	00004097          	auipc	ra,0x4
    1edc:	ce0080e7          	jalr	-800(ra) # 5bb8 <printf>
      exit(1);
    1ee0:	4505                	li	a0,1
    1ee2:	00004097          	auipc	ra,0x4
    1ee6:	94c080e7          	jalr	-1716(ra) # 582e <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
    1eea:	862a                	mv	a2,a0
    1eec:	85ce                	mv	a1,s3
    1eee:	00005517          	auipc	a0,0x5
    1ef2:	b9a50513          	addi	a0,a0,-1126 # 6a88 <malloc+0xe18>
    1ef6:	00004097          	auipc	ra,0x4
    1efa:	cc2080e7          	jalr	-830(ra) # 5bb8 <printf>
      exit(1);
    1efe:	4505                	li	a0,1
    1f00:	00004097          	auipc	ra,0x4
    1f04:	92e080e7          	jalr	-1746(ra) # 582e <exit>

0000000000001f08 <copyinstr1>:
{
    1f08:	1141                	addi	sp,sp,-16
    1f0a:	e406                	sd	ra,8(sp)
    1f0c:	e022                	sd	s0,0(sp)
    1f0e:	0800                	addi	s0,sp,16
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
    1f10:	20100593          	li	a1,513
    1f14:	4505                	li	a0,1
    1f16:	057e                	slli	a0,a0,0x1f
    1f18:	00004097          	auipc	ra,0x4
    1f1c:	956080e7          	jalr	-1706(ra) # 586e <open>
    if(fd >= 0){
    1f20:	02055063          	bgez	a0,1f40 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
    1f24:	20100593          	li	a1,513
    1f28:	557d                	li	a0,-1
    1f2a:	00004097          	auipc	ra,0x4
    1f2e:	944080e7          	jalr	-1724(ra) # 586e <open>
    uint64 addr = addrs[ai];
    1f32:	55fd                	li	a1,-1
    if(fd >= 0){
    1f34:	00055863          	bgez	a0,1f44 <copyinstr1+0x3c>
}
    1f38:	60a2                	ld	ra,8(sp)
    1f3a:	6402                	ld	s0,0(sp)
    1f3c:	0141                	addi	sp,sp,16
    1f3e:	8082                	ret
    uint64 addr = addrs[ai];
    1f40:	4585                	li	a1,1
    1f42:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
    1f44:	862a                	mv	a2,a0
    1f46:	00005517          	auipc	a0,0x5
    1f4a:	b7250513          	addi	a0,a0,-1166 # 6ab8 <malloc+0xe48>
    1f4e:	00004097          	auipc	ra,0x4
    1f52:	c6a080e7          	jalr	-918(ra) # 5bb8 <printf>
      exit(1);
    1f56:	4505                	li	a0,1
    1f58:	00004097          	auipc	ra,0x4
    1f5c:	8d6080e7          	jalr	-1834(ra) # 582e <exit>

0000000000001f60 <copyinstr2>:
{
    1f60:	7155                	addi	sp,sp,-208
    1f62:	e586                	sd	ra,200(sp)
    1f64:	e1a2                	sd	s0,192(sp)
    1f66:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1f68:	f6840793          	addi	a5,s0,-152
    1f6c:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    1f70:	07800713          	li	a4,120
    1f74:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1f78:	0785                	addi	a5,a5,1
    1f7a:	fed79de3          	bne	a5,a3,1f74 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    1f7e:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1f82:	f6840513          	addi	a0,s0,-152
    1f86:	00004097          	auipc	ra,0x4
    1f8a:	8f8080e7          	jalr	-1800(ra) # 587e <unlink>
  if(ret != -1){
    1f8e:	57fd                	li	a5,-1
    1f90:	0ef51063          	bne	a0,a5,2070 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    1f94:	20100593          	li	a1,513
    1f98:	f6840513          	addi	a0,s0,-152
    1f9c:	00004097          	auipc	ra,0x4
    1fa0:	8d2080e7          	jalr	-1838(ra) # 586e <open>
  if(fd != -1){
    1fa4:	57fd                	li	a5,-1
    1fa6:	0ef51563          	bne	a0,a5,2090 <copyinstr2+0x130>
  ret = link(b, b);
    1faa:	f6840593          	addi	a1,s0,-152
    1fae:	852e                	mv	a0,a1
    1fb0:	00004097          	auipc	ra,0x4
    1fb4:	8de080e7          	jalr	-1826(ra) # 588e <link>
  if(ret != -1){
    1fb8:	57fd                	li	a5,-1
    1fba:	0ef51b63          	bne	a0,a5,20b0 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1fbe:	00004797          	auipc	a5,0x4
    1fc2:	62278793          	addi	a5,a5,1570 # 65e0 <malloc+0x970>
    1fc6:	f4f43c23          	sd	a5,-168(s0)
    1fca:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1fce:	f5840593          	addi	a1,s0,-168
    1fd2:	f6840513          	addi	a0,s0,-152
    1fd6:	00004097          	auipc	ra,0x4
    1fda:	890080e7          	jalr	-1904(ra) # 5866 <exec>
  if(ret != -1){
    1fde:	57fd                	li	a5,-1
    1fe0:	0ef51963          	bne	a0,a5,20d2 <copyinstr2+0x172>
  int pid = fork();
    1fe4:	00004097          	auipc	ra,0x4
    1fe8:	842080e7          	jalr	-1982(ra) # 5826 <fork>
  if(pid < 0){
    1fec:	10054363          	bltz	a0,20f2 <copyinstr2+0x192>
  if(pid == 0){
    1ff0:	12051463          	bnez	a0,2118 <copyinstr2+0x1b8>
    1ff4:	00006797          	auipc	a5,0x6
    1ff8:	2c478793          	addi	a5,a5,708 # 82b8 <big.0>
    1ffc:	00007697          	auipc	a3,0x7
    2000:	2bc68693          	addi	a3,a3,700 # 92b8 <__global_pointer$+0x910>
      big[i] = 'x';
    2004:	07800713          	li	a4,120
    2008:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    200c:	0785                	addi	a5,a5,1
    200e:	fed79de3          	bne	a5,a3,2008 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    2012:	00007797          	auipc	a5,0x7
    2016:	2a078323          	sb	zero,678(a5) # 92b8 <__global_pointer$+0x910>
    char *args2[] = { big, big, big, 0 };
    201a:	00006797          	auipc	a5,0x6
    201e:	f4678793          	addi	a5,a5,-186 # 7f60 <malloc+0x22f0>
    2022:	6390                	ld	a2,0(a5)
    2024:	6794                	ld	a3,8(a5)
    2026:	6b98                	ld	a4,16(a5)
    2028:	6f9c                	ld	a5,24(a5)
    202a:	f2c43823          	sd	a2,-208(s0)
    202e:	f2d43c23          	sd	a3,-200(s0)
    2032:	f4e43023          	sd	a4,-192(s0)
    2036:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    203a:	f3040593          	addi	a1,s0,-208
    203e:	00004517          	auipc	a0,0x4
    2042:	d1a50513          	addi	a0,a0,-742 # 5d58 <malloc+0xe8>
    2046:	00004097          	auipc	ra,0x4
    204a:	820080e7          	jalr	-2016(ra) # 5866 <exec>
    if(ret != -1){
    204e:	57fd                	li	a5,-1
    2050:	0af50e63          	beq	a0,a5,210c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    2054:	55fd                	li	a1,-1
    2056:	00005517          	auipc	a0,0x5
    205a:	b0a50513          	addi	a0,a0,-1270 # 6b60 <malloc+0xef0>
    205e:	00004097          	auipc	ra,0x4
    2062:	b5a080e7          	jalr	-1190(ra) # 5bb8 <printf>
      exit(1);
    2066:	4505                	li	a0,1
    2068:	00003097          	auipc	ra,0x3
    206c:	7c6080e7          	jalr	1990(ra) # 582e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2070:	862a                	mv	a2,a0
    2072:	f6840593          	addi	a1,s0,-152
    2076:	00005517          	auipc	a0,0x5
    207a:	a6250513          	addi	a0,a0,-1438 # 6ad8 <malloc+0xe68>
    207e:	00004097          	auipc	ra,0x4
    2082:	b3a080e7          	jalr	-1222(ra) # 5bb8 <printf>
    exit(1);
    2086:	4505                	li	a0,1
    2088:	00003097          	auipc	ra,0x3
    208c:	7a6080e7          	jalr	1958(ra) # 582e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2090:	862a                	mv	a2,a0
    2092:	f6840593          	addi	a1,s0,-152
    2096:	00005517          	auipc	a0,0x5
    209a:	a6250513          	addi	a0,a0,-1438 # 6af8 <malloc+0xe88>
    209e:	00004097          	auipc	ra,0x4
    20a2:	b1a080e7          	jalr	-1254(ra) # 5bb8 <printf>
    exit(1);
    20a6:	4505                	li	a0,1
    20a8:	00003097          	auipc	ra,0x3
    20ac:	786080e7          	jalr	1926(ra) # 582e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    20b0:	86aa                	mv	a3,a0
    20b2:	f6840613          	addi	a2,s0,-152
    20b6:	85b2                	mv	a1,a2
    20b8:	00005517          	auipc	a0,0x5
    20bc:	a6050513          	addi	a0,a0,-1440 # 6b18 <malloc+0xea8>
    20c0:	00004097          	auipc	ra,0x4
    20c4:	af8080e7          	jalr	-1288(ra) # 5bb8 <printf>
    exit(1);
    20c8:	4505                	li	a0,1
    20ca:	00003097          	auipc	ra,0x3
    20ce:	764080e7          	jalr	1892(ra) # 582e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    20d2:	567d                	li	a2,-1
    20d4:	f6840593          	addi	a1,s0,-152
    20d8:	00005517          	auipc	a0,0x5
    20dc:	a6850513          	addi	a0,a0,-1432 # 6b40 <malloc+0xed0>
    20e0:	00004097          	auipc	ra,0x4
    20e4:	ad8080e7          	jalr	-1320(ra) # 5bb8 <printf>
    exit(1);
    20e8:	4505                	li	a0,1
    20ea:	00003097          	auipc	ra,0x3
    20ee:	744080e7          	jalr	1860(ra) # 582e <exit>
    printf("fork failed\n");
    20f2:	00006517          	auipc	a0,0x6
    20f6:	ac650513          	addi	a0,a0,-1338 # 7bb8 <malloc+0x1f48>
    20fa:	00004097          	auipc	ra,0x4
    20fe:	abe080e7          	jalr	-1346(ra) # 5bb8 <printf>
    exit(1);
    2102:	4505                	li	a0,1
    2104:	00003097          	auipc	ra,0x3
    2108:	72a080e7          	jalr	1834(ra) # 582e <exit>
    exit(747); // OK
    210c:	2eb00513          	li	a0,747
    2110:	00003097          	auipc	ra,0x3
    2114:	71e080e7          	jalr	1822(ra) # 582e <exit>
  int st = 0;
    2118:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    211c:	f5440513          	addi	a0,s0,-172
    2120:	00003097          	auipc	ra,0x3
    2124:	716080e7          	jalr	1814(ra) # 5836 <wait>
  if(st != 747){
    2128:	f5442703          	lw	a4,-172(s0)
    212c:	2eb00793          	li	a5,747
    2130:	00f71663          	bne	a4,a5,213c <copyinstr2+0x1dc>
}
    2134:	60ae                	ld	ra,200(sp)
    2136:	640e                	ld	s0,192(sp)
    2138:	6169                	addi	sp,sp,208
    213a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    213c:	00005517          	auipc	a0,0x5
    2140:	a4c50513          	addi	a0,a0,-1460 # 6b88 <malloc+0xf18>
    2144:	00004097          	auipc	ra,0x4
    2148:	a74080e7          	jalr	-1420(ra) # 5bb8 <printf>
    exit(1);
    214c:	4505                	li	a0,1
    214e:	00003097          	auipc	ra,0x3
    2152:	6e0080e7          	jalr	1760(ra) # 582e <exit>

0000000000002156 <copyinstr3>:
{
    2156:	7179                	addi	sp,sp,-48
    2158:	f406                	sd	ra,40(sp)
    215a:	f022                	sd	s0,32(sp)
    215c:	ec26                	sd	s1,24(sp)
    215e:	1800                	addi	s0,sp,48
  sbrk(8192);
    2160:	6509                	lui	a0,0x2
    2162:	00003097          	auipc	ra,0x3
    2166:	754080e7          	jalr	1876(ra) # 58b6 <sbrk>
  uint64 top = (uint64) sbrk(0);
    216a:	4501                	li	a0,0
    216c:	00003097          	auipc	ra,0x3
    2170:	74a080e7          	jalr	1866(ra) # 58b6 <sbrk>
  if((top % PGSIZE) != 0){
    2174:	03451793          	slli	a5,a0,0x34
    2178:	e3c9                	bnez	a5,21fa <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    217a:	4501                	li	a0,0
    217c:	00003097          	auipc	ra,0x3
    2180:	73a080e7          	jalr	1850(ra) # 58b6 <sbrk>
  if(top % PGSIZE){
    2184:	03451793          	slli	a5,a0,0x34
    2188:	e3d9                	bnez	a5,220e <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    218a:	fff50493          	addi	s1,a0,-1 # 1fff <copyinstr2+0x9f>
  *b = 'x';
    218e:	07800793          	li	a5,120
    2192:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2196:	8526                	mv	a0,s1
    2198:	00003097          	auipc	ra,0x3
    219c:	6e6080e7          	jalr	1766(ra) # 587e <unlink>
  if(ret != -1){
    21a0:	57fd                	li	a5,-1
    21a2:	08f51363          	bne	a0,a5,2228 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    21a6:	20100593          	li	a1,513
    21aa:	8526                	mv	a0,s1
    21ac:	00003097          	auipc	ra,0x3
    21b0:	6c2080e7          	jalr	1730(ra) # 586e <open>
  if(fd != -1){
    21b4:	57fd                	li	a5,-1
    21b6:	08f51863          	bne	a0,a5,2246 <copyinstr3+0xf0>
  ret = link(b, b);
    21ba:	85a6                	mv	a1,s1
    21bc:	8526                	mv	a0,s1
    21be:	00003097          	auipc	ra,0x3
    21c2:	6d0080e7          	jalr	1744(ra) # 588e <link>
  if(ret != -1){
    21c6:	57fd                	li	a5,-1
    21c8:	08f51e63          	bne	a0,a5,2264 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    21cc:	00004797          	auipc	a5,0x4
    21d0:	41478793          	addi	a5,a5,1044 # 65e0 <malloc+0x970>
    21d4:	fcf43823          	sd	a5,-48(s0)
    21d8:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    21dc:	fd040593          	addi	a1,s0,-48
    21e0:	8526                	mv	a0,s1
    21e2:	00003097          	auipc	ra,0x3
    21e6:	684080e7          	jalr	1668(ra) # 5866 <exec>
  if(ret != -1){
    21ea:	57fd                	li	a5,-1
    21ec:	08f51c63          	bne	a0,a5,2284 <copyinstr3+0x12e>
}
    21f0:	70a2                	ld	ra,40(sp)
    21f2:	7402                	ld	s0,32(sp)
    21f4:	64e2                	ld	s1,24(sp)
    21f6:	6145                	addi	sp,sp,48
    21f8:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    21fa:	0347d513          	srli	a0,a5,0x34
    21fe:	6785                	lui	a5,0x1
    2200:	40a7853b          	subw	a0,a5,a0
    2204:	00003097          	auipc	ra,0x3
    2208:	6b2080e7          	jalr	1714(ra) # 58b6 <sbrk>
    220c:	b7bd                	j	217a <copyinstr3+0x24>
    printf("oops\n");
    220e:	00005517          	auipc	a0,0x5
    2212:	9aa50513          	addi	a0,a0,-1622 # 6bb8 <malloc+0xf48>
    2216:	00004097          	auipc	ra,0x4
    221a:	9a2080e7          	jalr	-1630(ra) # 5bb8 <printf>
    exit(1);
    221e:	4505                	li	a0,1
    2220:	00003097          	auipc	ra,0x3
    2224:	60e080e7          	jalr	1550(ra) # 582e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2228:	862a                	mv	a2,a0
    222a:	85a6                	mv	a1,s1
    222c:	00005517          	auipc	a0,0x5
    2230:	8ac50513          	addi	a0,a0,-1876 # 6ad8 <malloc+0xe68>
    2234:	00004097          	auipc	ra,0x4
    2238:	984080e7          	jalr	-1660(ra) # 5bb8 <printf>
    exit(1);
    223c:	4505                	li	a0,1
    223e:	00003097          	auipc	ra,0x3
    2242:	5f0080e7          	jalr	1520(ra) # 582e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2246:	862a                	mv	a2,a0
    2248:	85a6                	mv	a1,s1
    224a:	00005517          	auipc	a0,0x5
    224e:	8ae50513          	addi	a0,a0,-1874 # 6af8 <malloc+0xe88>
    2252:	00004097          	auipc	ra,0x4
    2256:	966080e7          	jalr	-1690(ra) # 5bb8 <printf>
    exit(1);
    225a:	4505                	li	a0,1
    225c:	00003097          	auipc	ra,0x3
    2260:	5d2080e7          	jalr	1490(ra) # 582e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2264:	86aa                	mv	a3,a0
    2266:	8626                	mv	a2,s1
    2268:	85a6                	mv	a1,s1
    226a:	00005517          	auipc	a0,0x5
    226e:	8ae50513          	addi	a0,a0,-1874 # 6b18 <malloc+0xea8>
    2272:	00004097          	auipc	ra,0x4
    2276:	946080e7          	jalr	-1722(ra) # 5bb8 <printf>
    exit(1);
    227a:	4505                	li	a0,1
    227c:	00003097          	auipc	ra,0x3
    2280:	5b2080e7          	jalr	1458(ra) # 582e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2284:	567d                	li	a2,-1
    2286:	85a6                	mv	a1,s1
    2288:	00005517          	auipc	a0,0x5
    228c:	8b850513          	addi	a0,a0,-1864 # 6b40 <malloc+0xed0>
    2290:	00004097          	auipc	ra,0x4
    2294:	928080e7          	jalr	-1752(ra) # 5bb8 <printf>
    exit(1);
    2298:	4505                	li	a0,1
    229a:	00003097          	auipc	ra,0x3
    229e:	594080e7          	jalr	1428(ra) # 582e <exit>

00000000000022a2 <rwsbrk>:
{
    22a2:	1101                	addi	sp,sp,-32
    22a4:	ec06                	sd	ra,24(sp)
    22a6:	e822                	sd	s0,16(sp)
    22a8:	e426                	sd	s1,8(sp)
    22aa:	e04a                	sd	s2,0(sp)
    22ac:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    22ae:	6509                	lui	a0,0x2
    22b0:	00003097          	auipc	ra,0x3
    22b4:	606080e7          	jalr	1542(ra) # 58b6 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    22b8:	57fd                	li	a5,-1
    22ba:	06f50263          	beq	a0,a5,231e <rwsbrk+0x7c>
    22be:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    22c0:	7579                	lui	a0,0xffffe
    22c2:	00003097          	auipc	ra,0x3
    22c6:	5f4080e7          	jalr	1524(ra) # 58b6 <sbrk>
    22ca:	57fd                	li	a5,-1
    22cc:	06f50663          	beq	a0,a5,2338 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    22d0:	20100593          	li	a1,513
    22d4:	00005517          	auipc	a0,0x5
    22d8:	92450513          	addi	a0,a0,-1756 # 6bf8 <malloc+0xf88>
    22dc:	00003097          	auipc	ra,0x3
    22e0:	592080e7          	jalr	1426(ra) # 586e <open>
    22e4:	892a                	mv	s2,a0
  if(fd < 0){
    22e6:	06054663          	bltz	a0,2352 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    22ea:	6785                	lui	a5,0x1
    22ec:	94be                	add	s1,s1,a5
    22ee:	40000613          	li	a2,1024
    22f2:	85a6                	mv	a1,s1
    22f4:	00003097          	auipc	ra,0x3
    22f8:	55a080e7          	jalr	1370(ra) # 584e <write>
    22fc:	862a                	mv	a2,a0
  if(n >= 0){
    22fe:	06054763          	bltz	a0,236c <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2302:	85a6                	mv	a1,s1
    2304:	00005517          	auipc	a0,0x5
    2308:	91450513          	addi	a0,a0,-1772 # 6c18 <malloc+0xfa8>
    230c:	00004097          	auipc	ra,0x4
    2310:	8ac080e7          	jalr	-1876(ra) # 5bb8 <printf>
    exit(1);
    2314:	4505                	li	a0,1
    2316:	00003097          	auipc	ra,0x3
    231a:	518080e7          	jalr	1304(ra) # 582e <exit>
    printf("sbrk(rwsbrk) failed\n");
    231e:	00005517          	auipc	a0,0x5
    2322:	8a250513          	addi	a0,a0,-1886 # 6bc0 <malloc+0xf50>
    2326:	00004097          	auipc	ra,0x4
    232a:	892080e7          	jalr	-1902(ra) # 5bb8 <printf>
    exit(1);
    232e:	4505                	li	a0,1
    2330:	00003097          	auipc	ra,0x3
    2334:	4fe080e7          	jalr	1278(ra) # 582e <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2338:	00005517          	auipc	a0,0x5
    233c:	8a050513          	addi	a0,a0,-1888 # 6bd8 <malloc+0xf68>
    2340:	00004097          	auipc	ra,0x4
    2344:	878080e7          	jalr	-1928(ra) # 5bb8 <printf>
    exit(1);
    2348:	4505                	li	a0,1
    234a:	00003097          	auipc	ra,0x3
    234e:	4e4080e7          	jalr	1252(ra) # 582e <exit>
    printf("open(rwsbrk) failed\n");
    2352:	00005517          	auipc	a0,0x5
    2356:	8ae50513          	addi	a0,a0,-1874 # 6c00 <malloc+0xf90>
    235a:	00004097          	auipc	ra,0x4
    235e:	85e080e7          	jalr	-1954(ra) # 5bb8 <printf>
    exit(1);
    2362:	4505                	li	a0,1
    2364:	00003097          	auipc	ra,0x3
    2368:	4ca080e7          	jalr	1226(ra) # 582e <exit>
  close(fd);
    236c:	854a                	mv	a0,s2
    236e:	00003097          	auipc	ra,0x3
    2372:	4e8080e7          	jalr	1256(ra) # 5856 <close>
  unlink("rwsbrk");
    2376:	00005517          	auipc	a0,0x5
    237a:	88250513          	addi	a0,a0,-1918 # 6bf8 <malloc+0xf88>
    237e:	00003097          	auipc	ra,0x3
    2382:	500080e7          	jalr	1280(ra) # 587e <unlink>
  fd = open("README", O_RDONLY);
    2386:	4581                	li	a1,0
    2388:	00004517          	auipc	a0,0x4
    238c:	2d850513          	addi	a0,a0,728 # 6660 <malloc+0x9f0>
    2390:	00003097          	auipc	ra,0x3
    2394:	4de080e7          	jalr	1246(ra) # 586e <open>
    2398:	892a                	mv	s2,a0
  if(fd < 0){
    239a:	02054963          	bltz	a0,23cc <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    239e:	4629                	li	a2,10
    23a0:	85a6                	mv	a1,s1
    23a2:	00003097          	auipc	ra,0x3
    23a6:	4a4080e7          	jalr	1188(ra) # 5846 <read>
    23aa:	862a                	mv	a2,a0
  if(n >= 0){
    23ac:	02054d63          	bltz	a0,23e6 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    23b0:	85a6                	mv	a1,s1
    23b2:	00005517          	auipc	a0,0x5
    23b6:	89650513          	addi	a0,a0,-1898 # 6c48 <malloc+0xfd8>
    23ba:	00003097          	auipc	ra,0x3
    23be:	7fe080e7          	jalr	2046(ra) # 5bb8 <printf>
    exit(1);
    23c2:	4505                	li	a0,1
    23c4:	00003097          	auipc	ra,0x3
    23c8:	46a080e7          	jalr	1130(ra) # 582e <exit>
    printf("open(rwsbrk) failed\n");
    23cc:	00005517          	auipc	a0,0x5
    23d0:	83450513          	addi	a0,a0,-1996 # 6c00 <malloc+0xf90>
    23d4:	00003097          	auipc	ra,0x3
    23d8:	7e4080e7          	jalr	2020(ra) # 5bb8 <printf>
    exit(1);
    23dc:	4505                	li	a0,1
    23de:	00003097          	auipc	ra,0x3
    23e2:	450080e7          	jalr	1104(ra) # 582e <exit>
  close(fd);
    23e6:	854a                	mv	a0,s2
    23e8:	00003097          	auipc	ra,0x3
    23ec:	46e080e7          	jalr	1134(ra) # 5856 <close>
  exit(0);
    23f0:	4501                	li	a0,0
    23f2:	00003097          	auipc	ra,0x3
    23f6:	43c080e7          	jalr	1084(ra) # 582e <exit>

00000000000023fa <truncate1>:
{
    23fa:	711d                	addi	sp,sp,-96
    23fc:	ec86                	sd	ra,88(sp)
    23fe:	e8a2                	sd	s0,80(sp)
    2400:	e4a6                	sd	s1,72(sp)
    2402:	e0ca                	sd	s2,64(sp)
    2404:	fc4e                	sd	s3,56(sp)
    2406:	f852                	sd	s4,48(sp)
    2408:	f456                	sd	s5,40(sp)
    240a:	1080                	addi	s0,sp,96
    240c:	8aaa                	mv	s5,a0
  unlink("truncfile");
    240e:	00005517          	auipc	a0,0x5
    2412:	86250513          	addi	a0,a0,-1950 # 6c70 <malloc+0x1000>
    2416:	00003097          	auipc	ra,0x3
    241a:	468080e7          	jalr	1128(ra) # 587e <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    241e:	60100593          	li	a1,1537
    2422:	00005517          	auipc	a0,0x5
    2426:	84e50513          	addi	a0,a0,-1970 # 6c70 <malloc+0x1000>
    242a:	00003097          	auipc	ra,0x3
    242e:	444080e7          	jalr	1092(ra) # 586e <open>
    2432:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
    2434:	4611                	li	a2,4
    2436:	00005597          	auipc	a1,0x5
    243a:	84a58593          	addi	a1,a1,-1974 # 6c80 <malloc+0x1010>
    243e:	00003097          	auipc	ra,0x3
    2442:	410080e7          	jalr	1040(ra) # 584e <write>
  close(fd1);
    2446:	8526                	mv	a0,s1
    2448:	00003097          	auipc	ra,0x3
    244c:	40e080e7          	jalr	1038(ra) # 5856 <close>
  int fd2 = open("truncfile", O_RDONLY);
    2450:	4581                	li	a1,0
    2452:	00005517          	auipc	a0,0x5
    2456:	81e50513          	addi	a0,a0,-2018 # 6c70 <malloc+0x1000>
    245a:	00003097          	auipc	ra,0x3
    245e:	414080e7          	jalr	1044(ra) # 586e <open>
    2462:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
    2464:	02000613          	li	a2,32
    2468:	fa040593          	addi	a1,s0,-96
    246c:	00003097          	auipc	ra,0x3
    2470:	3da080e7          	jalr	986(ra) # 5846 <read>
  if(n != 4){
    2474:	4791                	li	a5,4
    2476:	0cf51e63          	bne	a0,a5,2552 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
    247a:	40100593          	li	a1,1025
    247e:	00004517          	auipc	a0,0x4
    2482:	7f250513          	addi	a0,a0,2034 # 6c70 <malloc+0x1000>
    2486:	00003097          	auipc	ra,0x3
    248a:	3e8080e7          	jalr	1000(ra) # 586e <open>
    248e:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
    2490:	4581                	li	a1,0
    2492:	00004517          	auipc	a0,0x4
    2496:	7de50513          	addi	a0,a0,2014 # 6c70 <malloc+0x1000>
    249a:	00003097          	auipc	ra,0x3
    249e:	3d4080e7          	jalr	980(ra) # 586e <open>
    24a2:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
    24a4:	02000613          	li	a2,32
    24a8:	fa040593          	addi	a1,s0,-96
    24ac:	00003097          	auipc	ra,0x3
    24b0:	39a080e7          	jalr	922(ra) # 5846 <read>
    24b4:	8a2a                	mv	s4,a0
  if(n != 0){
    24b6:	ed4d                	bnez	a0,2570 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
    24b8:	02000613          	li	a2,32
    24bc:	fa040593          	addi	a1,s0,-96
    24c0:	8526                	mv	a0,s1
    24c2:	00003097          	auipc	ra,0x3
    24c6:	384080e7          	jalr	900(ra) # 5846 <read>
    24ca:	8a2a                	mv	s4,a0
  if(n != 0){
    24cc:	e971                	bnez	a0,25a0 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
    24ce:	4619                	li	a2,6
    24d0:	00005597          	auipc	a1,0x5
    24d4:	81858593          	addi	a1,a1,-2024 # 6ce8 <malloc+0x1078>
    24d8:	854e                	mv	a0,s3
    24da:	00003097          	auipc	ra,0x3
    24de:	374080e7          	jalr	884(ra) # 584e <write>
  n = read(fd3, buf, sizeof(buf));
    24e2:	02000613          	li	a2,32
    24e6:	fa040593          	addi	a1,s0,-96
    24ea:	854a                	mv	a0,s2
    24ec:	00003097          	auipc	ra,0x3
    24f0:	35a080e7          	jalr	858(ra) # 5846 <read>
  if(n != 6){
    24f4:	4799                	li	a5,6
    24f6:	0cf51d63          	bne	a0,a5,25d0 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
    24fa:	02000613          	li	a2,32
    24fe:	fa040593          	addi	a1,s0,-96
    2502:	8526                	mv	a0,s1
    2504:	00003097          	auipc	ra,0x3
    2508:	342080e7          	jalr	834(ra) # 5846 <read>
  if(n != 2){
    250c:	4789                	li	a5,2
    250e:	0ef51063          	bne	a0,a5,25ee <truncate1+0x1f4>
  unlink("truncfile");
    2512:	00004517          	auipc	a0,0x4
    2516:	75e50513          	addi	a0,a0,1886 # 6c70 <malloc+0x1000>
    251a:	00003097          	auipc	ra,0x3
    251e:	364080e7          	jalr	868(ra) # 587e <unlink>
  close(fd1);
    2522:	854e                	mv	a0,s3
    2524:	00003097          	auipc	ra,0x3
    2528:	332080e7          	jalr	818(ra) # 5856 <close>
  close(fd2);
    252c:	8526                	mv	a0,s1
    252e:	00003097          	auipc	ra,0x3
    2532:	328080e7          	jalr	808(ra) # 5856 <close>
  close(fd3);
    2536:	854a                	mv	a0,s2
    2538:	00003097          	auipc	ra,0x3
    253c:	31e080e7          	jalr	798(ra) # 5856 <close>
}
    2540:	60e6                	ld	ra,88(sp)
    2542:	6446                	ld	s0,80(sp)
    2544:	64a6                	ld	s1,72(sp)
    2546:	6906                	ld	s2,64(sp)
    2548:	79e2                	ld	s3,56(sp)
    254a:	7a42                	ld	s4,48(sp)
    254c:	7aa2                	ld	s5,40(sp)
    254e:	6125                	addi	sp,sp,96
    2550:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
    2552:	862a                	mv	a2,a0
    2554:	85d6                	mv	a1,s5
    2556:	00004517          	auipc	a0,0x4
    255a:	73250513          	addi	a0,a0,1842 # 6c88 <malloc+0x1018>
    255e:	00003097          	auipc	ra,0x3
    2562:	65a080e7          	jalr	1626(ra) # 5bb8 <printf>
    exit(1);
    2566:	4505                	li	a0,1
    2568:	00003097          	auipc	ra,0x3
    256c:	2c6080e7          	jalr	710(ra) # 582e <exit>
    printf("aaa fd3=%d\n", fd3);
    2570:	85ca                	mv	a1,s2
    2572:	00004517          	auipc	a0,0x4
    2576:	73650513          	addi	a0,a0,1846 # 6ca8 <malloc+0x1038>
    257a:	00003097          	auipc	ra,0x3
    257e:	63e080e7          	jalr	1598(ra) # 5bb8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
    2582:	8652                	mv	a2,s4
    2584:	85d6                	mv	a1,s5
    2586:	00004517          	auipc	a0,0x4
    258a:	73250513          	addi	a0,a0,1842 # 6cb8 <malloc+0x1048>
    258e:	00003097          	auipc	ra,0x3
    2592:	62a080e7          	jalr	1578(ra) # 5bb8 <printf>
    exit(1);
    2596:	4505                	li	a0,1
    2598:	00003097          	auipc	ra,0x3
    259c:	296080e7          	jalr	662(ra) # 582e <exit>
    printf("bbb fd2=%d\n", fd2);
    25a0:	85a6                	mv	a1,s1
    25a2:	00004517          	auipc	a0,0x4
    25a6:	73650513          	addi	a0,a0,1846 # 6cd8 <malloc+0x1068>
    25aa:	00003097          	auipc	ra,0x3
    25ae:	60e080e7          	jalr	1550(ra) # 5bb8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
    25b2:	8652                	mv	a2,s4
    25b4:	85d6                	mv	a1,s5
    25b6:	00004517          	auipc	a0,0x4
    25ba:	70250513          	addi	a0,a0,1794 # 6cb8 <malloc+0x1048>
    25be:	00003097          	auipc	ra,0x3
    25c2:	5fa080e7          	jalr	1530(ra) # 5bb8 <printf>
    exit(1);
    25c6:	4505                	li	a0,1
    25c8:	00003097          	auipc	ra,0x3
    25cc:	266080e7          	jalr	614(ra) # 582e <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
    25d0:	862a                	mv	a2,a0
    25d2:	85d6                	mv	a1,s5
    25d4:	00004517          	auipc	a0,0x4
    25d8:	71c50513          	addi	a0,a0,1820 # 6cf0 <malloc+0x1080>
    25dc:	00003097          	auipc	ra,0x3
    25e0:	5dc080e7          	jalr	1500(ra) # 5bb8 <printf>
    exit(1);
    25e4:	4505                	li	a0,1
    25e6:	00003097          	auipc	ra,0x3
    25ea:	248080e7          	jalr	584(ra) # 582e <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
    25ee:	862a                	mv	a2,a0
    25f0:	85d6                	mv	a1,s5
    25f2:	00004517          	auipc	a0,0x4
    25f6:	71e50513          	addi	a0,a0,1822 # 6d10 <malloc+0x10a0>
    25fa:	00003097          	auipc	ra,0x3
    25fe:	5be080e7          	jalr	1470(ra) # 5bb8 <printf>
    exit(1);
    2602:	4505                	li	a0,1
    2604:	00003097          	auipc	ra,0x3
    2608:	22a080e7          	jalr	554(ra) # 582e <exit>

000000000000260c <truncate2>:
{
    260c:	7179                	addi	sp,sp,-48
    260e:	f406                	sd	ra,40(sp)
    2610:	f022                	sd	s0,32(sp)
    2612:	ec26                	sd	s1,24(sp)
    2614:	e84a                	sd	s2,16(sp)
    2616:	e44e                	sd	s3,8(sp)
    2618:	1800                	addi	s0,sp,48
    261a:	89aa                	mv	s3,a0
  unlink("truncfile");
    261c:	00004517          	auipc	a0,0x4
    2620:	65450513          	addi	a0,a0,1620 # 6c70 <malloc+0x1000>
    2624:	00003097          	auipc	ra,0x3
    2628:	25a080e7          	jalr	602(ra) # 587e <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
    262c:	60100593          	li	a1,1537
    2630:	00004517          	auipc	a0,0x4
    2634:	64050513          	addi	a0,a0,1600 # 6c70 <malloc+0x1000>
    2638:	00003097          	auipc	ra,0x3
    263c:	236080e7          	jalr	566(ra) # 586e <open>
    2640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
    2642:	4611                	li	a2,4
    2644:	00004597          	auipc	a1,0x4
    2648:	63c58593          	addi	a1,a1,1596 # 6c80 <malloc+0x1010>
    264c:	00003097          	auipc	ra,0x3
    2650:	202080e7          	jalr	514(ra) # 584e <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
    2654:	40100593          	li	a1,1025
    2658:	00004517          	auipc	a0,0x4
    265c:	61850513          	addi	a0,a0,1560 # 6c70 <malloc+0x1000>
    2660:	00003097          	auipc	ra,0x3
    2664:	20e080e7          	jalr	526(ra) # 586e <open>
    2668:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
    266a:	4605                	li	a2,1
    266c:	00004597          	auipc	a1,0x4
    2670:	06c58593          	addi	a1,a1,108 # 66d8 <malloc+0xa68>
    2674:	8526                	mv	a0,s1
    2676:	00003097          	auipc	ra,0x3
    267a:	1d8080e7          	jalr	472(ra) # 584e <write>
  if(n != -1){
    267e:	57fd                	li	a5,-1
    2680:	02f51b63          	bne	a0,a5,26b6 <truncate2+0xaa>
  unlink("truncfile");
    2684:	00004517          	auipc	a0,0x4
    2688:	5ec50513          	addi	a0,a0,1516 # 6c70 <malloc+0x1000>
    268c:	00003097          	auipc	ra,0x3
    2690:	1f2080e7          	jalr	498(ra) # 587e <unlink>
  close(fd1);
    2694:	8526                	mv	a0,s1
    2696:	00003097          	auipc	ra,0x3
    269a:	1c0080e7          	jalr	448(ra) # 5856 <close>
  close(fd2);
    269e:	854a                	mv	a0,s2
    26a0:	00003097          	auipc	ra,0x3
    26a4:	1b6080e7          	jalr	438(ra) # 5856 <close>
}
    26a8:	70a2                	ld	ra,40(sp)
    26aa:	7402                	ld	s0,32(sp)
    26ac:	64e2                	ld	s1,24(sp)
    26ae:	6942                	ld	s2,16(sp)
    26b0:	69a2                	ld	s3,8(sp)
    26b2:	6145                	addi	sp,sp,48
    26b4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
    26b6:	862a                	mv	a2,a0
    26b8:	85ce                	mv	a1,s3
    26ba:	00004517          	auipc	a0,0x4
    26be:	67650513          	addi	a0,a0,1654 # 6d30 <malloc+0x10c0>
    26c2:	00003097          	auipc	ra,0x3
    26c6:	4f6080e7          	jalr	1270(ra) # 5bb8 <printf>
    exit(1);
    26ca:	4505                	li	a0,1
    26cc:	00003097          	auipc	ra,0x3
    26d0:	162080e7          	jalr	354(ra) # 582e <exit>

00000000000026d4 <truncate3>:
{
    26d4:	7159                	addi	sp,sp,-112
    26d6:	f486                	sd	ra,104(sp)
    26d8:	f0a2                	sd	s0,96(sp)
    26da:	eca6                	sd	s1,88(sp)
    26dc:	e8ca                	sd	s2,80(sp)
    26de:	e4ce                	sd	s3,72(sp)
    26e0:	e0d2                	sd	s4,64(sp)
    26e2:	fc56                	sd	s5,56(sp)
    26e4:	1880                	addi	s0,sp,112
    26e6:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    26e8:	60100593          	li	a1,1537
    26ec:	00004517          	auipc	a0,0x4
    26f0:	58450513          	addi	a0,a0,1412 # 6c70 <malloc+0x1000>
    26f4:	00003097          	auipc	ra,0x3
    26f8:	17a080e7          	jalr	378(ra) # 586e <open>
    26fc:	00003097          	auipc	ra,0x3
    2700:	15a080e7          	jalr	346(ra) # 5856 <close>
  pid = fork();
    2704:	00003097          	auipc	ra,0x3
    2708:	122080e7          	jalr	290(ra) # 5826 <fork>
  if(pid < 0){
    270c:	08054063          	bltz	a0,278c <truncate3+0xb8>
  if(pid == 0){
    2710:	e969                	bnez	a0,27e2 <truncate3+0x10e>
    2712:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    2716:	00004a17          	auipc	s4,0x4
    271a:	55aa0a13          	addi	s4,s4,1370 # 6c70 <malloc+0x1000>
      int n = write(fd, "1234567890", 10);
    271e:	00004a97          	auipc	s5,0x4
    2722:	652a8a93          	addi	s5,s5,1618 # 6d70 <malloc+0x1100>
      int fd = open("truncfile", O_WRONLY);
    2726:	4585                	li	a1,1
    2728:	8552                	mv	a0,s4
    272a:	00003097          	auipc	ra,0x3
    272e:	144080e7          	jalr	324(ra) # 586e <open>
    2732:	84aa                	mv	s1,a0
      if(fd < 0){
    2734:	06054a63          	bltz	a0,27a8 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    2738:	4629                	li	a2,10
    273a:	85d6                	mv	a1,s5
    273c:	00003097          	auipc	ra,0x3
    2740:	112080e7          	jalr	274(ra) # 584e <write>
      if(n != 10){
    2744:	47a9                	li	a5,10
    2746:	06f51f63          	bne	a0,a5,27c4 <truncate3+0xf0>
      close(fd);
    274a:	8526                	mv	a0,s1
    274c:	00003097          	auipc	ra,0x3
    2750:	10a080e7          	jalr	266(ra) # 5856 <close>
      fd = open("truncfile", O_RDONLY);
    2754:	4581                	li	a1,0
    2756:	8552                	mv	a0,s4
    2758:	00003097          	auipc	ra,0x3
    275c:	116080e7          	jalr	278(ra) # 586e <open>
    2760:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    2762:	02000613          	li	a2,32
    2766:	f9840593          	addi	a1,s0,-104
    276a:	00003097          	auipc	ra,0x3
    276e:	0dc080e7          	jalr	220(ra) # 5846 <read>
      close(fd);
    2772:	8526                	mv	a0,s1
    2774:	00003097          	auipc	ra,0x3
    2778:	0e2080e7          	jalr	226(ra) # 5856 <close>
    for(int i = 0; i < 100; i++){
    277c:	39fd                	addiw	s3,s3,-1
    277e:	fa0994e3          	bnez	s3,2726 <truncate3+0x52>
    exit(0);
    2782:	4501                	li	a0,0
    2784:	00003097          	auipc	ra,0x3
    2788:	0aa080e7          	jalr	170(ra) # 582e <exit>
    printf("%s: fork failed\n", s);
    278c:	85ca                	mv	a1,s2
    278e:	00004517          	auipc	a0,0x4
    2792:	91a50513          	addi	a0,a0,-1766 # 60a8 <malloc+0x438>
    2796:	00003097          	auipc	ra,0x3
    279a:	422080e7          	jalr	1058(ra) # 5bb8 <printf>
    exit(1);
    279e:	4505                	li	a0,1
    27a0:	00003097          	auipc	ra,0x3
    27a4:	08e080e7          	jalr	142(ra) # 582e <exit>
        printf("%s: open failed\n", s);
    27a8:	85ca                	mv	a1,s2
    27aa:	00004517          	auipc	a0,0x4
    27ae:	5ae50513          	addi	a0,a0,1454 # 6d58 <malloc+0x10e8>
    27b2:	00003097          	auipc	ra,0x3
    27b6:	406080e7          	jalr	1030(ra) # 5bb8 <printf>
        exit(1);
    27ba:	4505                	li	a0,1
    27bc:	00003097          	auipc	ra,0x3
    27c0:	072080e7          	jalr	114(ra) # 582e <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    27c4:	862a                	mv	a2,a0
    27c6:	85ca                	mv	a1,s2
    27c8:	00004517          	auipc	a0,0x4
    27cc:	5b850513          	addi	a0,a0,1464 # 6d80 <malloc+0x1110>
    27d0:	00003097          	auipc	ra,0x3
    27d4:	3e8080e7          	jalr	1000(ra) # 5bb8 <printf>
        exit(1);
    27d8:	4505                	li	a0,1
    27da:	00003097          	auipc	ra,0x3
    27de:	054080e7          	jalr	84(ra) # 582e <exit>
    27e2:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    27e6:	00004a17          	auipc	s4,0x4
    27ea:	48aa0a13          	addi	s4,s4,1162 # 6c70 <malloc+0x1000>
    int n = write(fd, "xxx", 3);
    27ee:	00004a97          	auipc	s5,0x4
    27f2:	5b2a8a93          	addi	s5,s5,1458 # 6da0 <malloc+0x1130>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    27f6:	60100593          	li	a1,1537
    27fa:	8552                	mv	a0,s4
    27fc:	00003097          	auipc	ra,0x3
    2800:	072080e7          	jalr	114(ra) # 586e <open>
    2804:	84aa                	mv	s1,a0
    if(fd < 0){
    2806:	04054763          	bltz	a0,2854 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    280a:	460d                	li	a2,3
    280c:	85d6                	mv	a1,s5
    280e:	00003097          	auipc	ra,0x3
    2812:	040080e7          	jalr	64(ra) # 584e <write>
    if(n != 3){
    2816:	478d                	li	a5,3
    2818:	04f51c63          	bne	a0,a5,2870 <truncate3+0x19c>
    close(fd);
    281c:	8526                	mv	a0,s1
    281e:	00003097          	auipc	ra,0x3
    2822:	038080e7          	jalr	56(ra) # 5856 <close>
  for(int i = 0; i < 150; i++){
    2826:	39fd                	addiw	s3,s3,-1
    2828:	fc0997e3          	bnez	s3,27f6 <truncate3+0x122>
  wait(&xstatus);
    282c:	fbc40513          	addi	a0,s0,-68
    2830:	00003097          	auipc	ra,0x3
    2834:	006080e7          	jalr	6(ra) # 5836 <wait>
  unlink("truncfile");
    2838:	00004517          	auipc	a0,0x4
    283c:	43850513          	addi	a0,a0,1080 # 6c70 <malloc+0x1000>
    2840:	00003097          	auipc	ra,0x3
    2844:	03e080e7          	jalr	62(ra) # 587e <unlink>
  exit(xstatus);
    2848:	fbc42503          	lw	a0,-68(s0)
    284c:	00003097          	auipc	ra,0x3
    2850:	fe2080e7          	jalr	-30(ra) # 582e <exit>
      printf("%s: open failed\n", s);
    2854:	85ca                	mv	a1,s2
    2856:	00004517          	auipc	a0,0x4
    285a:	50250513          	addi	a0,a0,1282 # 6d58 <malloc+0x10e8>
    285e:	00003097          	auipc	ra,0x3
    2862:	35a080e7          	jalr	858(ra) # 5bb8 <printf>
      exit(1);
    2866:	4505                	li	a0,1
    2868:	00003097          	auipc	ra,0x3
    286c:	fc6080e7          	jalr	-58(ra) # 582e <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    2870:	862a                	mv	a2,a0
    2872:	85ca                	mv	a1,s2
    2874:	00004517          	auipc	a0,0x4
    2878:	53450513          	addi	a0,a0,1332 # 6da8 <malloc+0x1138>
    287c:	00003097          	auipc	ra,0x3
    2880:	33c080e7          	jalr	828(ra) # 5bb8 <printf>
      exit(1);
    2884:	4505                	li	a0,1
    2886:	00003097          	auipc	ra,0x3
    288a:	fa8080e7          	jalr	-88(ra) # 582e <exit>

000000000000288e <dirtest>:
{
    288e:	1101                	addi	sp,sp,-32
    2890:	ec06                	sd	ra,24(sp)
    2892:	e822                	sd	s0,16(sp)
    2894:	e426                	sd	s1,8(sp)
    2896:	1000                	addi	s0,sp,32
    2898:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    289a:	00004517          	auipc	a0,0x4
    289e:	52e50513          	addi	a0,a0,1326 # 6dc8 <malloc+0x1158>
    28a2:	00003097          	auipc	ra,0x3
    28a6:	ff4080e7          	jalr	-12(ra) # 5896 <mkdir>
    28aa:	04054563          	bltz	a0,28f4 <dirtest+0x66>
  if(chdir("dir0") < 0){
    28ae:	00004517          	auipc	a0,0x4
    28b2:	51a50513          	addi	a0,a0,1306 # 6dc8 <malloc+0x1158>
    28b6:	00003097          	auipc	ra,0x3
    28ba:	fe8080e7          	jalr	-24(ra) # 589e <chdir>
    28be:	04054963          	bltz	a0,2910 <dirtest+0x82>
  if(chdir("..") < 0){
    28c2:	00004517          	auipc	a0,0x4
    28c6:	c3e50513          	addi	a0,a0,-962 # 6500 <malloc+0x890>
    28ca:	00003097          	auipc	ra,0x3
    28ce:	fd4080e7          	jalr	-44(ra) # 589e <chdir>
    28d2:	04054d63          	bltz	a0,292c <dirtest+0x9e>
  if(unlink("dir0") < 0){
    28d6:	00004517          	auipc	a0,0x4
    28da:	4f250513          	addi	a0,a0,1266 # 6dc8 <malloc+0x1158>
    28de:	00003097          	auipc	ra,0x3
    28e2:	fa0080e7          	jalr	-96(ra) # 587e <unlink>
    28e6:	06054163          	bltz	a0,2948 <dirtest+0xba>
}
    28ea:	60e2                	ld	ra,24(sp)
    28ec:	6442                	ld	s0,16(sp)
    28ee:	64a2                	ld	s1,8(sp)
    28f0:	6105                	addi	sp,sp,32
    28f2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    28f4:	85a6                	mv	a1,s1
    28f6:	00004517          	auipc	a0,0x4
    28fa:	b1250513          	addi	a0,a0,-1262 # 6408 <malloc+0x798>
    28fe:	00003097          	auipc	ra,0x3
    2902:	2ba080e7          	jalr	698(ra) # 5bb8 <printf>
    exit(1);
    2906:	4505                	li	a0,1
    2908:	00003097          	auipc	ra,0x3
    290c:	f26080e7          	jalr	-218(ra) # 582e <exit>
    printf("%s: chdir dir0 failed\n", s);
    2910:	85a6                	mv	a1,s1
    2912:	00004517          	auipc	a0,0x4
    2916:	4be50513          	addi	a0,a0,1214 # 6dd0 <malloc+0x1160>
    291a:	00003097          	auipc	ra,0x3
    291e:	29e080e7          	jalr	670(ra) # 5bb8 <printf>
    exit(1);
    2922:	4505                	li	a0,1
    2924:	00003097          	auipc	ra,0x3
    2928:	f0a080e7          	jalr	-246(ra) # 582e <exit>
    printf("%s: chdir .. failed\n", s);
    292c:	85a6                	mv	a1,s1
    292e:	00004517          	auipc	a0,0x4
    2932:	4ba50513          	addi	a0,a0,1210 # 6de8 <malloc+0x1178>
    2936:	00003097          	auipc	ra,0x3
    293a:	282080e7          	jalr	642(ra) # 5bb8 <printf>
    exit(1);
    293e:	4505                	li	a0,1
    2940:	00003097          	auipc	ra,0x3
    2944:	eee080e7          	jalr	-274(ra) # 582e <exit>
    printf("%s: unlink dir0 failed\n", s);
    2948:	85a6                	mv	a1,s1
    294a:	00004517          	auipc	a0,0x4
    294e:	4b650513          	addi	a0,a0,1206 # 6e00 <malloc+0x1190>
    2952:	00003097          	auipc	ra,0x3
    2956:	266080e7          	jalr	614(ra) # 5bb8 <printf>
    exit(1);
    295a:	4505                	li	a0,1
    295c:	00003097          	auipc	ra,0x3
    2960:	ed2080e7          	jalr	-302(ra) # 582e <exit>

0000000000002964 <exectest>:
{
    2964:	715d                	addi	sp,sp,-80
    2966:	e486                	sd	ra,72(sp)
    2968:	e0a2                	sd	s0,64(sp)
    296a:	fc26                	sd	s1,56(sp)
    296c:	f84a                	sd	s2,48(sp)
    296e:	0880                	addi	s0,sp,80
    2970:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    2972:	00003797          	auipc	a5,0x3
    2976:	3e678793          	addi	a5,a5,998 # 5d58 <malloc+0xe8>
    297a:	fcf43023          	sd	a5,-64(s0)
    297e:	00004797          	auipc	a5,0x4
    2982:	49a78793          	addi	a5,a5,1178 # 6e18 <malloc+0x11a8>
    2986:	fcf43423          	sd	a5,-56(s0)
    298a:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    298e:	00004517          	auipc	a0,0x4
    2992:	49250513          	addi	a0,a0,1170 # 6e20 <malloc+0x11b0>
    2996:	00003097          	auipc	ra,0x3
    299a:	ee8080e7          	jalr	-280(ra) # 587e <unlink>
  pid = fork();
    299e:	00003097          	auipc	ra,0x3
    29a2:	e88080e7          	jalr	-376(ra) # 5826 <fork>
  if(pid < 0) {
    29a6:	04054663          	bltz	a0,29f2 <exectest+0x8e>
    29aa:	84aa                	mv	s1,a0
  if(pid == 0) {
    29ac:	e959                	bnez	a0,2a42 <exectest+0xde>
    close(1);
    29ae:	4505                	li	a0,1
    29b0:	00003097          	auipc	ra,0x3
    29b4:	ea6080e7          	jalr	-346(ra) # 5856 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    29b8:	20100593          	li	a1,513
    29bc:	00004517          	auipc	a0,0x4
    29c0:	46450513          	addi	a0,a0,1124 # 6e20 <malloc+0x11b0>
    29c4:	00003097          	auipc	ra,0x3
    29c8:	eaa080e7          	jalr	-342(ra) # 586e <open>
    if(fd < 0) {
    29cc:	04054163          	bltz	a0,2a0e <exectest+0xaa>
    if(fd != 1) {
    29d0:	4785                	li	a5,1
    29d2:	04f50c63          	beq	a0,a5,2a2a <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    29d6:	85ca                	mv	a1,s2
    29d8:	00004517          	auipc	a0,0x4
    29dc:	46850513          	addi	a0,a0,1128 # 6e40 <malloc+0x11d0>
    29e0:	00003097          	auipc	ra,0x3
    29e4:	1d8080e7          	jalr	472(ra) # 5bb8 <printf>
      exit(1);
    29e8:	4505                	li	a0,1
    29ea:	00003097          	auipc	ra,0x3
    29ee:	e44080e7          	jalr	-444(ra) # 582e <exit>
     printf("%s: fork failed\n", s);
    29f2:	85ca                	mv	a1,s2
    29f4:	00003517          	auipc	a0,0x3
    29f8:	6b450513          	addi	a0,a0,1716 # 60a8 <malloc+0x438>
    29fc:	00003097          	auipc	ra,0x3
    2a00:	1bc080e7          	jalr	444(ra) # 5bb8 <printf>
     exit(1);
    2a04:	4505                	li	a0,1
    2a06:	00003097          	auipc	ra,0x3
    2a0a:	e28080e7          	jalr	-472(ra) # 582e <exit>
      printf("%s: create failed\n", s);
    2a0e:	85ca                	mv	a1,s2
    2a10:	00004517          	auipc	a0,0x4
    2a14:	41850513          	addi	a0,a0,1048 # 6e28 <malloc+0x11b8>
    2a18:	00003097          	auipc	ra,0x3
    2a1c:	1a0080e7          	jalr	416(ra) # 5bb8 <printf>
      exit(1);
    2a20:	4505                	li	a0,1
    2a22:	00003097          	auipc	ra,0x3
    2a26:	e0c080e7          	jalr	-500(ra) # 582e <exit>
    if(exec("echo", echoargv) < 0){
    2a2a:	fc040593          	addi	a1,s0,-64
    2a2e:	00003517          	auipc	a0,0x3
    2a32:	32a50513          	addi	a0,a0,810 # 5d58 <malloc+0xe8>
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	e30080e7          	jalr	-464(ra) # 5866 <exec>
    2a3e:	02054163          	bltz	a0,2a60 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    2a42:	fdc40513          	addi	a0,s0,-36
    2a46:	00003097          	auipc	ra,0x3
    2a4a:	df0080e7          	jalr	-528(ra) # 5836 <wait>
    2a4e:	02951763          	bne	a0,s1,2a7c <exectest+0x118>
  if(xstatus != 0)
    2a52:	fdc42503          	lw	a0,-36(s0)
    2a56:	cd0d                	beqz	a0,2a90 <exectest+0x12c>
    exit(xstatus);
    2a58:	00003097          	auipc	ra,0x3
    2a5c:	dd6080e7          	jalr	-554(ra) # 582e <exit>
      printf("%s: exec echo failed\n", s);
    2a60:	85ca                	mv	a1,s2
    2a62:	00004517          	auipc	a0,0x4
    2a66:	3ee50513          	addi	a0,a0,1006 # 6e50 <malloc+0x11e0>
    2a6a:	00003097          	auipc	ra,0x3
    2a6e:	14e080e7          	jalr	334(ra) # 5bb8 <printf>
      exit(1);
    2a72:	4505                	li	a0,1
    2a74:	00003097          	auipc	ra,0x3
    2a78:	dba080e7          	jalr	-582(ra) # 582e <exit>
    printf("%s: wait failed!\n", s);
    2a7c:	85ca                	mv	a1,s2
    2a7e:	00004517          	auipc	a0,0x4
    2a82:	3ea50513          	addi	a0,a0,1002 # 6e68 <malloc+0x11f8>
    2a86:	00003097          	auipc	ra,0x3
    2a8a:	132080e7          	jalr	306(ra) # 5bb8 <printf>
    2a8e:	b7d1                	j	2a52 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    2a90:	4581                	li	a1,0
    2a92:	00004517          	auipc	a0,0x4
    2a96:	38e50513          	addi	a0,a0,910 # 6e20 <malloc+0x11b0>
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	dd4080e7          	jalr	-556(ra) # 586e <open>
  if(fd < 0) {
    2aa2:	02054a63          	bltz	a0,2ad6 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    2aa6:	4609                	li	a2,2
    2aa8:	fb840593          	addi	a1,s0,-72
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	d9a080e7          	jalr	-614(ra) # 5846 <read>
    2ab4:	4789                	li	a5,2
    2ab6:	02f50e63          	beq	a0,a5,2af2 <exectest+0x18e>
    printf("%s: read failed\n", s);
    2aba:	85ca                	mv	a1,s2
    2abc:	00003517          	auipc	a0,0x3
    2ac0:	3ac50513          	addi	a0,a0,940 # 5e68 <malloc+0x1f8>
    2ac4:	00003097          	auipc	ra,0x3
    2ac8:	0f4080e7          	jalr	244(ra) # 5bb8 <printf>
    exit(1);
    2acc:	4505                	li	a0,1
    2ace:	00003097          	auipc	ra,0x3
    2ad2:	d60080e7          	jalr	-672(ra) # 582e <exit>
    printf("%s: open failed\n", s);
    2ad6:	85ca                	mv	a1,s2
    2ad8:	00004517          	auipc	a0,0x4
    2adc:	28050513          	addi	a0,a0,640 # 6d58 <malloc+0x10e8>
    2ae0:	00003097          	auipc	ra,0x3
    2ae4:	0d8080e7          	jalr	216(ra) # 5bb8 <printf>
    exit(1);
    2ae8:	4505                	li	a0,1
    2aea:	00003097          	auipc	ra,0x3
    2aee:	d44080e7          	jalr	-700(ra) # 582e <exit>
  unlink("echo-ok");
    2af2:	00004517          	auipc	a0,0x4
    2af6:	32e50513          	addi	a0,a0,814 # 6e20 <malloc+0x11b0>
    2afa:	00003097          	auipc	ra,0x3
    2afe:	d84080e7          	jalr	-636(ra) # 587e <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    2b02:	fb844703          	lbu	a4,-72(s0)
    2b06:	04f00793          	li	a5,79
    2b0a:	00f71863          	bne	a4,a5,2b1a <exectest+0x1b6>
    2b0e:	fb944703          	lbu	a4,-71(s0)
    2b12:	04b00793          	li	a5,75
    2b16:	02f70063          	beq	a4,a5,2b36 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    2b1a:	85ca                	mv	a1,s2
    2b1c:	00004517          	auipc	a0,0x4
    2b20:	36450513          	addi	a0,a0,868 # 6e80 <malloc+0x1210>
    2b24:	00003097          	auipc	ra,0x3
    2b28:	094080e7          	jalr	148(ra) # 5bb8 <printf>
    exit(1);
    2b2c:	4505                	li	a0,1
    2b2e:	00003097          	auipc	ra,0x3
    2b32:	d00080e7          	jalr	-768(ra) # 582e <exit>
    exit(0);
    2b36:	4501                	li	a0,0
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	cf6080e7          	jalr	-778(ra) # 582e <exit>

0000000000002b40 <reparent>:
{
    2b40:	7179                	addi	sp,sp,-48
    2b42:	f406                	sd	ra,40(sp)
    2b44:	f022                	sd	s0,32(sp)
    2b46:	ec26                	sd	s1,24(sp)
    2b48:	e84a                	sd	s2,16(sp)
    2b4a:	e44e                	sd	s3,8(sp)
    2b4c:	e052                	sd	s4,0(sp)
    2b4e:	1800                	addi	s0,sp,48
    2b50:	89aa                	mv	s3,a0
  int master_pid = getpid();
    2b52:	00003097          	auipc	ra,0x3
    2b56:	d5c080e7          	jalr	-676(ra) # 58ae <getpid>
    2b5a:	8a2a                	mv	s4,a0
    2b5c:	0c800913          	li	s2,200
    int pid = fork();
    2b60:	00003097          	auipc	ra,0x3
    2b64:	cc6080e7          	jalr	-826(ra) # 5826 <fork>
    2b68:	84aa                	mv	s1,a0
    if(pid < 0){
    2b6a:	02054263          	bltz	a0,2b8e <reparent+0x4e>
    if(pid){
    2b6e:	cd21                	beqz	a0,2bc6 <reparent+0x86>
      if(wait(0) != pid){
    2b70:	4501                	li	a0,0
    2b72:	00003097          	auipc	ra,0x3
    2b76:	cc4080e7          	jalr	-828(ra) # 5836 <wait>
    2b7a:	02951863          	bne	a0,s1,2baa <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    2b7e:	397d                	addiw	s2,s2,-1
    2b80:	fe0910e3          	bnez	s2,2b60 <reparent+0x20>
  exit(0);
    2b84:	4501                	li	a0,0
    2b86:	00003097          	auipc	ra,0x3
    2b8a:	ca8080e7          	jalr	-856(ra) # 582e <exit>
      printf("%s: fork failed\n", s);
    2b8e:	85ce                	mv	a1,s3
    2b90:	00003517          	auipc	a0,0x3
    2b94:	51850513          	addi	a0,a0,1304 # 60a8 <malloc+0x438>
    2b98:	00003097          	auipc	ra,0x3
    2b9c:	020080e7          	jalr	32(ra) # 5bb8 <printf>
      exit(1);
    2ba0:	4505                	li	a0,1
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	c8c080e7          	jalr	-884(ra) # 582e <exit>
        printf("%s: wait wrong pid\n", s);
    2baa:	85ce                	mv	a1,s3
    2bac:	00003517          	auipc	a0,0x3
    2bb0:	51450513          	addi	a0,a0,1300 # 60c0 <malloc+0x450>
    2bb4:	00003097          	auipc	ra,0x3
    2bb8:	004080e7          	jalr	4(ra) # 5bb8 <printf>
        exit(1);
    2bbc:	4505                	li	a0,1
    2bbe:	00003097          	auipc	ra,0x3
    2bc2:	c70080e7          	jalr	-912(ra) # 582e <exit>
      int pid2 = fork();
    2bc6:	00003097          	auipc	ra,0x3
    2bca:	c60080e7          	jalr	-928(ra) # 5826 <fork>
      if(pid2 < 0){
    2bce:	00054763          	bltz	a0,2bdc <reparent+0x9c>
      exit(0);
    2bd2:	4501                	li	a0,0
    2bd4:	00003097          	auipc	ra,0x3
    2bd8:	c5a080e7          	jalr	-934(ra) # 582e <exit>
        kill(master_pid);
    2bdc:	8552                	mv	a0,s4
    2bde:	00003097          	auipc	ra,0x3
    2be2:	c80080e7          	jalr	-896(ra) # 585e <kill>
        exit(1);
    2be6:	4505                	li	a0,1
    2be8:	00003097          	auipc	ra,0x3
    2bec:	c46080e7          	jalr	-954(ra) # 582e <exit>

0000000000002bf0 <twochildren>:
{
    2bf0:	1101                	addi	sp,sp,-32
    2bf2:	ec06                	sd	ra,24(sp)
    2bf4:	e822                	sd	s0,16(sp)
    2bf6:	e426                	sd	s1,8(sp)
    2bf8:	e04a                	sd	s2,0(sp)
    2bfa:	1000                	addi	s0,sp,32
    2bfc:	892a                	mv	s2,a0
    2bfe:	3e800493          	li	s1,1000
    int pid1 = fork();
    2c02:	00003097          	auipc	ra,0x3
    2c06:	c24080e7          	jalr	-988(ra) # 5826 <fork>
    if(pid1 < 0){
    2c0a:	02054c63          	bltz	a0,2c42 <twochildren+0x52>
    if(pid1 == 0){
    2c0e:	c921                	beqz	a0,2c5e <twochildren+0x6e>
      int pid2 = fork();
    2c10:	00003097          	auipc	ra,0x3
    2c14:	c16080e7          	jalr	-1002(ra) # 5826 <fork>
      if(pid2 < 0){
    2c18:	04054763          	bltz	a0,2c66 <twochildren+0x76>
      if(pid2 == 0){
    2c1c:	c13d                	beqz	a0,2c82 <twochildren+0x92>
        wait(0);
    2c1e:	4501                	li	a0,0
    2c20:	00003097          	auipc	ra,0x3
    2c24:	c16080e7          	jalr	-1002(ra) # 5836 <wait>
        wait(0);
    2c28:	4501                	li	a0,0
    2c2a:	00003097          	auipc	ra,0x3
    2c2e:	c0c080e7          	jalr	-1012(ra) # 5836 <wait>
  for(int i = 0; i < 1000; i++){
    2c32:	34fd                	addiw	s1,s1,-1
    2c34:	f4f9                	bnez	s1,2c02 <twochildren+0x12>
}
    2c36:	60e2                	ld	ra,24(sp)
    2c38:	6442                	ld	s0,16(sp)
    2c3a:	64a2                	ld	s1,8(sp)
    2c3c:	6902                	ld	s2,0(sp)
    2c3e:	6105                	addi	sp,sp,32
    2c40:	8082                	ret
      printf("%s: fork failed\n", s);
    2c42:	85ca                	mv	a1,s2
    2c44:	00003517          	auipc	a0,0x3
    2c48:	46450513          	addi	a0,a0,1124 # 60a8 <malloc+0x438>
    2c4c:	00003097          	auipc	ra,0x3
    2c50:	f6c080e7          	jalr	-148(ra) # 5bb8 <printf>
      exit(1);
    2c54:	4505                	li	a0,1
    2c56:	00003097          	auipc	ra,0x3
    2c5a:	bd8080e7          	jalr	-1064(ra) # 582e <exit>
      exit(0);
    2c5e:	00003097          	auipc	ra,0x3
    2c62:	bd0080e7          	jalr	-1072(ra) # 582e <exit>
        printf("%s: fork failed\n", s);
    2c66:	85ca                	mv	a1,s2
    2c68:	00003517          	auipc	a0,0x3
    2c6c:	44050513          	addi	a0,a0,1088 # 60a8 <malloc+0x438>
    2c70:	00003097          	auipc	ra,0x3
    2c74:	f48080e7          	jalr	-184(ra) # 5bb8 <printf>
        exit(1);
    2c78:	4505                	li	a0,1
    2c7a:	00003097          	auipc	ra,0x3
    2c7e:	bb4080e7          	jalr	-1100(ra) # 582e <exit>
        exit(0);
    2c82:	00003097          	auipc	ra,0x3
    2c86:	bac080e7          	jalr	-1108(ra) # 582e <exit>

0000000000002c8a <forkfork>:
{
    2c8a:	7179                	addi	sp,sp,-48
    2c8c:	f406                	sd	ra,40(sp)
    2c8e:	f022                	sd	s0,32(sp)
    2c90:	ec26                	sd	s1,24(sp)
    2c92:	1800                	addi	s0,sp,48
    2c94:	84aa                	mv	s1,a0
    int pid = fork();
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	b90080e7          	jalr	-1136(ra) # 5826 <fork>
    if(pid < 0){
    2c9e:	04054163          	bltz	a0,2ce0 <forkfork+0x56>
    if(pid == 0){
    2ca2:	cd29                	beqz	a0,2cfc <forkfork+0x72>
    int pid = fork();
    2ca4:	00003097          	auipc	ra,0x3
    2ca8:	b82080e7          	jalr	-1150(ra) # 5826 <fork>
    if(pid < 0){
    2cac:	02054a63          	bltz	a0,2ce0 <forkfork+0x56>
    if(pid == 0){
    2cb0:	c531                	beqz	a0,2cfc <forkfork+0x72>
    wait(&xstatus);
    2cb2:	fdc40513          	addi	a0,s0,-36
    2cb6:	00003097          	auipc	ra,0x3
    2cba:	b80080e7          	jalr	-1152(ra) # 5836 <wait>
    if(xstatus != 0) {
    2cbe:	fdc42783          	lw	a5,-36(s0)
    2cc2:	ebbd                	bnez	a5,2d38 <forkfork+0xae>
    wait(&xstatus);
    2cc4:	fdc40513          	addi	a0,s0,-36
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	b6e080e7          	jalr	-1170(ra) # 5836 <wait>
    if(xstatus != 0) {
    2cd0:	fdc42783          	lw	a5,-36(s0)
    2cd4:	e3b5                	bnez	a5,2d38 <forkfork+0xae>
}
    2cd6:	70a2                	ld	ra,40(sp)
    2cd8:	7402                	ld	s0,32(sp)
    2cda:	64e2                	ld	s1,24(sp)
    2cdc:	6145                	addi	sp,sp,48
    2cde:	8082                	ret
      printf("%s: fork failed", s);
    2ce0:	85a6                	mv	a1,s1
    2ce2:	00004517          	auipc	a0,0x4
    2ce6:	ace50513          	addi	a0,a0,-1330 # 67b0 <malloc+0xb40>
    2cea:	00003097          	auipc	ra,0x3
    2cee:	ece080e7          	jalr	-306(ra) # 5bb8 <printf>
      exit(1);
    2cf2:	4505                	li	a0,1
    2cf4:	00003097          	auipc	ra,0x3
    2cf8:	b3a080e7          	jalr	-1222(ra) # 582e <exit>
{
    2cfc:	0c800493          	li	s1,200
        int pid1 = fork();
    2d00:	00003097          	auipc	ra,0x3
    2d04:	b26080e7          	jalr	-1242(ra) # 5826 <fork>
        if(pid1 < 0){
    2d08:	00054f63          	bltz	a0,2d26 <forkfork+0x9c>
        if(pid1 == 0){
    2d0c:	c115                	beqz	a0,2d30 <forkfork+0xa6>
        wait(0);
    2d0e:	4501                	li	a0,0
    2d10:	00003097          	auipc	ra,0x3
    2d14:	b26080e7          	jalr	-1242(ra) # 5836 <wait>
      for(int j = 0; j < 200; j++){
    2d18:	34fd                	addiw	s1,s1,-1
    2d1a:	f0fd                	bnez	s1,2d00 <forkfork+0x76>
      exit(0);
    2d1c:	4501                	li	a0,0
    2d1e:	00003097          	auipc	ra,0x3
    2d22:	b10080e7          	jalr	-1264(ra) # 582e <exit>
          exit(1);
    2d26:	4505                	li	a0,1
    2d28:	00003097          	auipc	ra,0x3
    2d2c:	b06080e7          	jalr	-1274(ra) # 582e <exit>
          exit(0);
    2d30:	00003097          	auipc	ra,0x3
    2d34:	afe080e7          	jalr	-1282(ra) # 582e <exit>
      printf("%s: fork in child failed", s);
    2d38:	85a6                	mv	a1,s1
    2d3a:	00004517          	auipc	a0,0x4
    2d3e:	15e50513          	addi	a0,a0,350 # 6e98 <malloc+0x1228>
    2d42:	00003097          	auipc	ra,0x3
    2d46:	e76080e7          	jalr	-394(ra) # 5bb8 <printf>
      exit(1);
    2d4a:	4505                	li	a0,1
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	ae2080e7          	jalr	-1310(ra) # 582e <exit>

0000000000002d54 <forkforkfork>:
{
    2d54:	1101                	addi	sp,sp,-32
    2d56:	ec06                	sd	ra,24(sp)
    2d58:	e822                	sd	s0,16(sp)
    2d5a:	e426                	sd	s1,8(sp)
    2d5c:	1000                	addi	s0,sp,32
    2d5e:	84aa                	mv	s1,a0
  unlink("stopforking");
    2d60:	00004517          	auipc	a0,0x4
    2d64:	15850513          	addi	a0,a0,344 # 6eb8 <malloc+0x1248>
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	b16080e7          	jalr	-1258(ra) # 587e <unlink>
  int pid = fork();
    2d70:	00003097          	auipc	ra,0x3
    2d74:	ab6080e7          	jalr	-1354(ra) # 5826 <fork>
  if(pid < 0){
    2d78:	04054563          	bltz	a0,2dc2 <forkforkfork+0x6e>
  if(pid == 0){
    2d7c:	c12d                	beqz	a0,2dde <forkforkfork+0x8a>
  sleep(20); // two seconds
    2d7e:	4551                	li	a0,20
    2d80:	00003097          	auipc	ra,0x3
    2d84:	b3e080e7          	jalr	-1218(ra) # 58be <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    2d88:	20200593          	li	a1,514
    2d8c:	00004517          	auipc	a0,0x4
    2d90:	12c50513          	addi	a0,a0,300 # 6eb8 <malloc+0x1248>
    2d94:	00003097          	auipc	ra,0x3
    2d98:	ada080e7          	jalr	-1318(ra) # 586e <open>
    2d9c:	00003097          	auipc	ra,0x3
    2da0:	aba080e7          	jalr	-1350(ra) # 5856 <close>
  wait(0);
    2da4:	4501                	li	a0,0
    2da6:	00003097          	auipc	ra,0x3
    2daa:	a90080e7          	jalr	-1392(ra) # 5836 <wait>
  sleep(10); // one second
    2dae:	4529                	li	a0,10
    2db0:	00003097          	auipc	ra,0x3
    2db4:	b0e080e7          	jalr	-1266(ra) # 58be <sleep>
}
    2db8:	60e2                	ld	ra,24(sp)
    2dba:	6442                	ld	s0,16(sp)
    2dbc:	64a2                	ld	s1,8(sp)
    2dbe:	6105                	addi	sp,sp,32
    2dc0:	8082                	ret
    printf("%s: fork failed", s);
    2dc2:	85a6                	mv	a1,s1
    2dc4:	00004517          	auipc	a0,0x4
    2dc8:	9ec50513          	addi	a0,a0,-1556 # 67b0 <malloc+0xb40>
    2dcc:	00003097          	auipc	ra,0x3
    2dd0:	dec080e7          	jalr	-532(ra) # 5bb8 <printf>
    exit(1);
    2dd4:	4505                	li	a0,1
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	a58080e7          	jalr	-1448(ra) # 582e <exit>
      int fd = open("stopforking", 0);
    2dde:	00004497          	auipc	s1,0x4
    2de2:	0da48493          	addi	s1,s1,218 # 6eb8 <malloc+0x1248>
    2de6:	4581                	li	a1,0
    2de8:	8526                	mv	a0,s1
    2dea:	00003097          	auipc	ra,0x3
    2dee:	a84080e7          	jalr	-1404(ra) # 586e <open>
      if(fd >= 0){
    2df2:	02055463          	bgez	a0,2e1a <forkforkfork+0xc6>
      if(fork() < 0){
    2df6:	00003097          	auipc	ra,0x3
    2dfa:	a30080e7          	jalr	-1488(ra) # 5826 <fork>
    2dfe:	fe0554e3          	bgez	a0,2de6 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    2e02:	20200593          	li	a1,514
    2e06:	8526                	mv	a0,s1
    2e08:	00003097          	auipc	ra,0x3
    2e0c:	a66080e7          	jalr	-1434(ra) # 586e <open>
    2e10:	00003097          	auipc	ra,0x3
    2e14:	a46080e7          	jalr	-1466(ra) # 5856 <close>
    2e18:	b7f9                	j	2de6 <forkforkfork+0x92>
        exit(0);
    2e1a:	4501                	li	a0,0
    2e1c:	00003097          	auipc	ra,0x3
    2e20:	a12080e7          	jalr	-1518(ra) # 582e <exit>

0000000000002e24 <reparent2>:
{
    2e24:	1101                	addi	sp,sp,-32
    2e26:	ec06                	sd	ra,24(sp)
    2e28:	e822                	sd	s0,16(sp)
    2e2a:	e426                	sd	s1,8(sp)
    2e2c:	1000                	addi	s0,sp,32
    2e2e:	32000493          	li	s1,800
    int pid1 = fork();
    2e32:	00003097          	auipc	ra,0x3
    2e36:	9f4080e7          	jalr	-1548(ra) # 5826 <fork>
    if(pid1 < 0){
    2e3a:	00054f63          	bltz	a0,2e58 <reparent2+0x34>
    if(pid1 == 0){
    2e3e:	c915                	beqz	a0,2e72 <reparent2+0x4e>
    wait(0);
    2e40:	4501                	li	a0,0
    2e42:	00003097          	auipc	ra,0x3
    2e46:	9f4080e7          	jalr	-1548(ra) # 5836 <wait>
  for(int i = 0; i < 800; i++){
    2e4a:	34fd                	addiw	s1,s1,-1
    2e4c:	f0fd                	bnez	s1,2e32 <reparent2+0xe>
  exit(0);
    2e4e:	4501                	li	a0,0
    2e50:	00003097          	auipc	ra,0x3
    2e54:	9de080e7          	jalr	-1570(ra) # 582e <exit>
      printf("fork failed\n");
    2e58:	00005517          	auipc	a0,0x5
    2e5c:	d6050513          	addi	a0,a0,-672 # 7bb8 <malloc+0x1f48>
    2e60:	00003097          	auipc	ra,0x3
    2e64:	d58080e7          	jalr	-680(ra) # 5bb8 <printf>
      exit(1);
    2e68:	4505                	li	a0,1
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	9c4080e7          	jalr	-1596(ra) # 582e <exit>
      fork();
    2e72:	00003097          	auipc	ra,0x3
    2e76:	9b4080e7          	jalr	-1612(ra) # 5826 <fork>
      fork();
    2e7a:	00003097          	auipc	ra,0x3
    2e7e:	9ac080e7          	jalr	-1620(ra) # 5826 <fork>
      exit(0);
    2e82:	4501                	li	a0,0
    2e84:	00003097          	auipc	ra,0x3
    2e88:	9aa080e7          	jalr	-1622(ra) # 582e <exit>

0000000000002e8c <sharedfd>:
{
    2e8c:	7159                	addi	sp,sp,-112
    2e8e:	f486                	sd	ra,104(sp)
    2e90:	f0a2                	sd	s0,96(sp)
    2e92:	eca6                	sd	s1,88(sp)
    2e94:	e8ca                	sd	s2,80(sp)
    2e96:	e4ce                	sd	s3,72(sp)
    2e98:	e0d2                	sd	s4,64(sp)
    2e9a:	fc56                	sd	s5,56(sp)
    2e9c:	f85a                	sd	s6,48(sp)
    2e9e:	f45e                	sd	s7,40(sp)
    2ea0:	1880                	addi	s0,sp,112
    2ea2:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    2ea4:	00004517          	auipc	a0,0x4
    2ea8:	02450513          	addi	a0,a0,36 # 6ec8 <malloc+0x1258>
    2eac:	00003097          	auipc	ra,0x3
    2eb0:	9d2080e7          	jalr	-1582(ra) # 587e <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    2eb4:	20200593          	li	a1,514
    2eb8:	00004517          	auipc	a0,0x4
    2ebc:	01050513          	addi	a0,a0,16 # 6ec8 <malloc+0x1258>
    2ec0:	00003097          	auipc	ra,0x3
    2ec4:	9ae080e7          	jalr	-1618(ra) # 586e <open>
  if(fd < 0){
    2ec8:	04054a63          	bltz	a0,2f1c <sharedfd+0x90>
    2ecc:	892a                	mv	s2,a0
  pid = fork();
    2ece:	00003097          	auipc	ra,0x3
    2ed2:	958080e7          	jalr	-1704(ra) # 5826 <fork>
    2ed6:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2ed8:	06300593          	li	a1,99
    2edc:	c119                	beqz	a0,2ee2 <sharedfd+0x56>
    2ede:	07000593          	li	a1,112
    2ee2:	4629                	li	a2,10
    2ee4:	fa040513          	addi	a0,s0,-96
    2ee8:	00002097          	auipc	ra,0x2
    2eec:	74c080e7          	jalr	1868(ra) # 5634 <memset>
    2ef0:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    2ef4:	4629                	li	a2,10
    2ef6:	fa040593          	addi	a1,s0,-96
    2efa:	854a                	mv	a0,s2
    2efc:	00003097          	auipc	ra,0x3
    2f00:	952080e7          	jalr	-1710(ra) # 584e <write>
    2f04:	47a9                	li	a5,10
    2f06:	02f51963          	bne	a0,a5,2f38 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    2f0a:	34fd                	addiw	s1,s1,-1
    2f0c:	f4e5                	bnez	s1,2ef4 <sharedfd+0x68>
  if(pid == 0) {
    2f0e:	04099363          	bnez	s3,2f54 <sharedfd+0xc8>
    exit(0);
    2f12:	4501                	li	a0,0
    2f14:	00003097          	auipc	ra,0x3
    2f18:	91a080e7          	jalr	-1766(ra) # 582e <exit>
    printf("%s: cannot open sharedfd for writing", s);
    2f1c:	85d2                	mv	a1,s4
    2f1e:	00004517          	auipc	a0,0x4
    2f22:	fba50513          	addi	a0,a0,-70 # 6ed8 <malloc+0x1268>
    2f26:	00003097          	auipc	ra,0x3
    2f2a:	c92080e7          	jalr	-878(ra) # 5bb8 <printf>
    exit(1);
    2f2e:	4505                	li	a0,1
    2f30:	00003097          	auipc	ra,0x3
    2f34:	8fe080e7          	jalr	-1794(ra) # 582e <exit>
      printf("%s: write sharedfd failed\n", s);
    2f38:	85d2                	mv	a1,s4
    2f3a:	00004517          	auipc	a0,0x4
    2f3e:	fc650513          	addi	a0,a0,-58 # 6f00 <malloc+0x1290>
    2f42:	00003097          	auipc	ra,0x3
    2f46:	c76080e7          	jalr	-906(ra) # 5bb8 <printf>
      exit(1);
    2f4a:	4505                	li	a0,1
    2f4c:	00003097          	auipc	ra,0x3
    2f50:	8e2080e7          	jalr	-1822(ra) # 582e <exit>
    wait(&xstatus);
    2f54:	f9c40513          	addi	a0,s0,-100
    2f58:	00003097          	auipc	ra,0x3
    2f5c:	8de080e7          	jalr	-1826(ra) # 5836 <wait>
    if(xstatus != 0)
    2f60:	f9c42983          	lw	s3,-100(s0)
    2f64:	00098763          	beqz	s3,2f72 <sharedfd+0xe6>
      exit(xstatus);
    2f68:	854e                	mv	a0,s3
    2f6a:	00003097          	auipc	ra,0x3
    2f6e:	8c4080e7          	jalr	-1852(ra) # 582e <exit>
  close(fd);
    2f72:	854a                	mv	a0,s2
    2f74:	00003097          	auipc	ra,0x3
    2f78:	8e2080e7          	jalr	-1822(ra) # 5856 <close>
  fd = open("sharedfd", 0);
    2f7c:	4581                	li	a1,0
    2f7e:	00004517          	auipc	a0,0x4
    2f82:	f4a50513          	addi	a0,a0,-182 # 6ec8 <malloc+0x1258>
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	8e8080e7          	jalr	-1816(ra) # 586e <open>
    2f8e:	8baa                	mv	s7,a0
  nc = np = 0;
    2f90:	8ace                	mv	s5,s3
  if(fd < 0){
    2f92:	02054563          	bltz	a0,2fbc <sharedfd+0x130>
    2f96:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    2f9a:	06300493          	li	s1,99
      if(buf[i] == 'p')
    2f9e:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    2fa2:	4629                	li	a2,10
    2fa4:	fa040593          	addi	a1,s0,-96
    2fa8:	855e                	mv	a0,s7
    2faa:	00003097          	auipc	ra,0x3
    2fae:	89c080e7          	jalr	-1892(ra) # 5846 <read>
    2fb2:	02a05f63          	blez	a0,2ff0 <sharedfd+0x164>
    2fb6:	fa040793          	addi	a5,s0,-96
    2fba:	a01d                	j	2fe0 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    2fbc:	85d2                	mv	a1,s4
    2fbe:	00004517          	auipc	a0,0x4
    2fc2:	f6250513          	addi	a0,a0,-158 # 6f20 <malloc+0x12b0>
    2fc6:	00003097          	auipc	ra,0x3
    2fca:	bf2080e7          	jalr	-1038(ra) # 5bb8 <printf>
    exit(1);
    2fce:	4505                	li	a0,1
    2fd0:	00003097          	auipc	ra,0x3
    2fd4:	85e080e7          	jalr	-1954(ra) # 582e <exit>
        nc++;
    2fd8:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    2fda:	0785                	addi	a5,a5,1
    2fdc:	fd2783e3          	beq	a5,s2,2fa2 <sharedfd+0x116>
      if(buf[i] == 'c')
    2fe0:	0007c703          	lbu	a4,0(a5)
    2fe4:	fe970ae3          	beq	a4,s1,2fd8 <sharedfd+0x14c>
      if(buf[i] == 'p')
    2fe8:	ff6719e3          	bne	a4,s6,2fda <sharedfd+0x14e>
        np++;
    2fec:	2a85                	addiw	s5,s5,1
    2fee:	b7f5                	j	2fda <sharedfd+0x14e>
  close(fd);
    2ff0:	855e                	mv	a0,s7
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	864080e7          	jalr	-1948(ra) # 5856 <close>
  unlink("sharedfd");
    2ffa:	00004517          	auipc	a0,0x4
    2ffe:	ece50513          	addi	a0,a0,-306 # 6ec8 <malloc+0x1258>
    3002:	00003097          	auipc	ra,0x3
    3006:	87c080e7          	jalr	-1924(ra) # 587e <unlink>
  if(nc == N*SZ && np == N*SZ){
    300a:	6789                	lui	a5,0x2
    300c:	71078793          	addi	a5,a5,1808 # 2710 <truncate3+0x3c>
    3010:	00f99763          	bne	s3,a5,301e <sharedfd+0x192>
    3014:	6789                	lui	a5,0x2
    3016:	71078793          	addi	a5,a5,1808 # 2710 <truncate3+0x3c>
    301a:	02fa8063          	beq	s5,a5,303a <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    301e:	85d2                	mv	a1,s4
    3020:	00004517          	auipc	a0,0x4
    3024:	f2850513          	addi	a0,a0,-216 # 6f48 <malloc+0x12d8>
    3028:	00003097          	auipc	ra,0x3
    302c:	b90080e7          	jalr	-1136(ra) # 5bb8 <printf>
    exit(1);
    3030:	4505                	li	a0,1
    3032:	00002097          	auipc	ra,0x2
    3036:	7fc080e7          	jalr	2044(ra) # 582e <exit>
    exit(0);
    303a:	4501                	li	a0,0
    303c:	00002097          	auipc	ra,0x2
    3040:	7f2080e7          	jalr	2034(ra) # 582e <exit>

0000000000003044 <fourfiles>:
{
    3044:	7171                	addi	sp,sp,-176
    3046:	f506                	sd	ra,168(sp)
    3048:	f122                	sd	s0,160(sp)
    304a:	ed26                	sd	s1,152(sp)
    304c:	e94a                	sd	s2,144(sp)
    304e:	e54e                	sd	s3,136(sp)
    3050:	e152                	sd	s4,128(sp)
    3052:	fcd6                	sd	s5,120(sp)
    3054:	f8da                	sd	s6,112(sp)
    3056:	f4de                	sd	s7,104(sp)
    3058:	f0e2                	sd	s8,96(sp)
    305a:	ece6                	sd	s9,88(sp)
    305c:	e8ea                	sd	s10,80(sp)
    305e:	e4ee                	sd	s11,72(sp)
    3060:	1900                	addi	s0,sp,176
    3062:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    3066:	00004797          	auipc	a5,0x4
    306a:	efa78793          	addi	a5,a5,-262 # 6f60 <malloc+0x12f0>
    306e:	f6f43823          	sd	a5,-144(s0)
    3072:	00004797          	auipc	a5,0x4
    3076:	ef678793          	addi	a5,a5,-266 # 6f68 <malloc+0x12f8>
    307a:	f6f43c23          	sd	a5,-136(s0)
    307e:	00004797          	auipc	a5,0x4
    3082:	ef278793          	addi	a5,a5,-270 # 6f70 <malloc+0x1300>
    3086:	f8f43023          	sd	a5,-128(s0)
    308a:	00004797          	auipc	a5,0x4
    308e:	eee78793          	addi	a5,a5,-274 # 6f78 <malloc+0x1308>
    3092:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3096:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    309a:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    309c:	4481                	li	s1,0
    309e:	4a11                	li	s4,4
    fname = names[pi];
    30a0:	00093983          	ld	s3,0(s2)
    unlink(fname);
    30a4:	854e                	mv	a0,s3
    30a6:	00002097          	auipc	ra,0x2
    30aa:	7d8080e7          	jalr	2008(ra) # 587e <unlink>
    pid = fork();
    30ae:	00002097          	auipc	ra,0x2
    30b2:	778080e7          	jalr	1912(ra) # 5826 <fork>
    if(pid < 0){
    30b6:	04054463          	bltz	a0,30fe <fourfiles+0xba>
    if(pid == 0){
    30ba:	c12d                	beqz	a0,311c <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    30bc:	2485                	addiw	s1,s1,1
    30be:	0921                	addi	s2,s2,8
    30c0:	ff4490e3          	bne	s1,s4,30a0 <fourfiles+0x5c>
    30c4:	4491                	li	s1,4
    wait(&xstatus);
    30c6:	f6c40513          	addi	a0,s0,-148
    30ca:	00002097          	auipc	ra,0x2
    30ce:	76c080e7          	jalr	1900(ra) # 5836 <wait>
    if(xstatus != 0)
    30d2:	f6c42b03          	lw	s6,-148(s0)
    30d6:	0c0b1e63          	bnez	s6,31b2 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    30da:	34fd                	addiw	s1,s1,-1
    30dc:	f4ed                	bnez	s1,30c6 <fourfiles+0x82>
    30de:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    30e2:	00009a17          	auipc	s4,0x9
    30e6:	8eea0a13          	addi	s4,s4,-1810 # b9d0 <buf>
    30ea:	00009a97          	auipc	s5,0x9
    30ee:	8e7a8a93          	addi	s5,s5,-1817 # b9d1 <buf+0x1>
    if(total != N*SZ){
    30f2:	6d85                	lui	s11,0x1
    30f4:	770d8d93          	addi	s11,s11,1904 # 1770 <preempt+0xfe>
  for(i = 0; i < NCHILD; i++){
    30f8:	03400d13          	li	s10,52
    30fc:	aa1d                	j	3232 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    30fe:	f5843583          	ld	a1,-168(s0)
    3102:	00005517          	auipc	a0,0x5
    3106:	ab650513          	addi	a0,a0,-1354 # 7bb8 <malloc+0x1f48>
    310a:	00003097          	auipc	ra,0x3
    310e:	aae080e7          	jalr	-1362(ra) # 5bb8 <printf>
      exit(1);
    3112:	4505                	li	a0,1
    3114:	00002097          	auipc	ra,0x2
    3118:	71a080e7          	jalr	1818(ra) # 582e <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    311c:	20200593          	li	a1,514
    3120:	854e                	mv	a0,s3
    3122:	00002097          	auipc	ra,0x2
    3126:	74c080e7          	jalr	1868(ra) # 586e <open>
    312a:	892a                	mv	s2,a0
      if(fd < 0){
    312c:	04054763          	bltz	a0,317a <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    3130:	1f400613          	li	a2,500
    3134:	0304859b          	addiw	a1,s1,48
    3138:	00009517          	auipc	a0,0x9
    313c:	89850513          	addi	a0,a0,-1896 # b9d0 <buf>
    3140:	00002097          	auipc	ra,0x2
    3144:	4f4080e7          	jalr	1268(ra) # 5634 <memset>
    3148:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    314a:	00009997          	auipc	s3,0x9
    314e:	88698993          	addi	s3,s3,-1914 # b9d0 <buf>
    3152:	1f400613          	li	a2,500
    3156:	85ce                	mv	a1,s3
    3158:	854a                	mv	a0,s2
    315a:	00002097          	auipc	ra,0x2
    315e:	6f4080e7          	jalr	1780(ra) # 584e <write>
    3162:	85aa                	mv	a1,a0
    3164:	1f400793          	li	a5,500
    3168:	02f51863          	bne	a0,a5,3198 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    316c:	34fd                	addiw	s1,s1,-1
    316e:	f0f5                	bnez	s1,3152 <fourfiles+0x10e>
      exit(0);
    3170:	4501                	li	a0,0
    3172:	00002097          	auipc	ra,0x2
    3176:	6bc080e7          	jalr	1724(ra) # 582e <exit>
        printf("create failed\n", s);
    317a:	f5843583          	ld	a1,-168(s0)
    317e:	00004517          	auipc	a0,0x4
    3182:	e0250513          	addi	a0,a0,-510 # 6f80 <malloc+0x1310>
    3186:	00003097          	auipc	ra,0x3
    318a:	a32080e7          	jalr	-1486(ra) # 5bb8 <printf>
        exit(1);
    318e:	4505                	li	a0,1
    3190:	00002097          	auipc	ra,0x2
    3194:	69e080e7          	jalr	1694(ra) # 582e <exit>
          printf("write failed %d\n", n);
    3198:	00004517          	auipc	a0,0x4
    319c:	df850513          	addi	a0,a0,-520 # 6f90 <malloc+0x1320>
    31a0:	00003097          	auipc	ra,0x3
    31a4:	a18080e7          	jalr	-1512(ra) # 5bb8 <printf>
          exit(1);
    31a8:	4505                	li	a0,1
    31aa:	00002097          	auipc	ra,0x2
    31ae:	684080e7          	jalr	1668(ra) # 582e <exit>
      exit(xstatus);
    31b2:	855a                	mv	a0,s6
    31b4:	00002097          	auipc	ra,0x2
    31b8:	67a080e7          	jalr	1658(ra) # 582e <exit>
          printf("wrong char\n", s);
    31bc:	f5843583          	ld	a1,-168(s0)
    31c0:	00004517          	auipc	a0,0x4
    31c4:	de850513          	addi	a0,a0,-536 # 6fa8 <malloc+0x1338>
    31c8:	00003097          	auipc	ra,0x3
    31cc:	9f0080e7          	jalr	-1552(ra) # 5bb8 <printf>
          exit(1);
    31d0:	4505                	li	a0,1
    31d2:	00002097          	auipc	ra,0x2
    31d6:	65c080e7          	jalr	1628(ra) # 582e <exit>
      total += n;
    31da:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    31de:	660d                	lui	a2,0x3
    31e0:	85d2                	mv	a1,s4
    31e2:	854e                	mv	a0,s3
    31e4:	00002097          	auipc	ra,0x2
    31e8:	662080e7          	jalr	1634(ra) # 5846 <read>
    31ec:	02a05363          	blez	a0,3212 <fourfiles+0x1ce>
    31f0:	00008797          	auipc	a5,0x8
    31f4:	7e078793          	addi	a5,a5,2016 # b9d0 <buf>
    31f8:	fff5069b          	addiw	a3,a0,-1
    31fc:	1682                	slli	a3,a3,0x20
    31fe:	9281                	srli	a3,a3,0x20
    3200:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    3202:	0007c703          	lbu	a4,0(a5)
    3206:	fa971be3          	bne	a4,s1,31bc <fourfiles+0x178>
      for(j = 0; j < n; j++){
    320a:	0785                	addi	a5,a5,1
    320c:	fed79be3          	bne	a5,a3,3202 <fourfiles+0x1be>
    3210:	b7e9                	j	31da <fourfiles+0x196>
    close(fd);
    3212:	854e                	mv	a0,s3
    3214:	00002097          	auipc	ra,0x2
    3218:	642080e7          	jalr	1602(ra) # 5856 <close>
    if(total != N*SZ){
    321c:	03b91863          	bne	s2,s11,324c <fourfiles+0x208>
    unlink(fname);
    3220:	8566                	mv	a0,s9
    3222:	00002097          	auipc	ra,0x2
    3226:	65c080e7          	jalr	1628(ra) # 587e <unlink>
  for(i = 0; i < NCHILD; i++){
    322a:	0c21                	addi	s8,s8,8
    322c:	2b85                	addiw	s7,s7,1
    322e:	03ab8d63          	beq	s7,s10,3268 <fourfiles+0x224>
    fname = names[i];
    3232:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    3236:	4581                	li	a1,0
    3238:	8566                	mv	a0,s9
    323a:	00002097          	auipc	ra,0x2
    323e:	634080e7          	jalr	1588(ra) # 586e <open>
    3242:	89aa                	mv	s3,a0
    total = 0;
    3244:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    3246:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    324a:	bf51                	j	31de <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    324c:	85ca                	mv	a1,s2
    324e:	00004517          	auipc	a0,0x4
    3252:	d6a50513          	addi	a0,a0,-662 # 6fb8 <malloc+0x1348>
    3256:	00003097          	auipc	ra,0x3
    325a:	962080e7          	jalr	-1694(ra) # 5bb8 <printf>
      exit(1);
    325e:	4505                	li	a0,1
    3260:	00002097          	auipc	ra,0x2
    3264:	5ce080e7          	jalr	1486(ra) # 582e <exit>
}
    3268:	70aa                	ld	ra,168(sp)
    326a:	740a                	ld	s0,160(sp)
    326c:	64ea                	ld	s1,152(sp)
    326e:	694a                	ld	s2,144(sp)
    3270:	69aa                	ld	s3,136(sp)
    3272:	6a0a                	ld	s4,128(sp)
    3274:	7ae6                	ld	s5,120(sp)
    3276:	7b46                	ld	s6,112(sp)
    3278:	7ba6                	ld	s7,104(sp)
    327a:	7c06                	ld	s8,96(sp)
    327c:	6ce6                	ld	s9,88(sp)
    327e:	6d46                	ld	s10,80(sp)
    3280:	6da6                	ld	s11,72(sp)
    3282:	614d                	addi	sp,sp,176
    3284:	8082                	ret

0000000000003286 <createdelete>:
{
    3286:	7175                	addi	sp,sp,-144
    3288:	e506                	sd	ra,136(sp)
    328a:	e122                	sd	s0,128(sp)
    328c:	fca6                	sd	s1,120(sp)
    328e:	f8ca                	sd	s2,112(sp)
    3290:	f4ce                	sd	s3,104(sp)
    3292:	f0d2                	sd	s4,96(sp)
    3294:	ecd6                	sd	s5,88(sp)
    3296:	e8da                	sd	s6,80(sp)
    3298:	e4de                	sd	s7,72(sp)
    329a:	e0e2                	sd	s8,64(sp)
    329c:	fc66                	sd	s9,56(sp)
    329e:	0900                	addi	s0,sp,144
    32a0:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    32a2:	4901                	li	s2,0
    32a4:	4991                	li	s3,4
    pid = fork();
    32a6:	00002097          	auipc	ra,0x2
    32aa:	580080e7          	jalr	1408(ra) # 5826 <fork>
    32ae:	84aa                	mv	s1,a0
    if(pid < 0){
    32b0:	02054f63          	bltz	a0,32ee <createdelete+0x68>
    if(pid == 0){
    32b4:	c939                	beqz	a0,330a <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    32b6:	2905                	addiw	s2,s2,1
    32b8:	ff3917e3          	bne	s2,s3,32a6 <createdelete+0x20>
    32bc:	4491                	li	s1,4
    wait(&xstatus);
    32be:	f7c40513          	addi	a0,s0,-132
    32c2:	00002097          	auipc	ra,0x2
    32c6:	574080e7          	jalr	1396(ra) # 5836 <wait>
    if(xstatus != 0)
    32ca:	f7c42903          	lw	s2,-132(s0)
    32ce:	0e091263          	bnez	s2,33b2 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    32d2:	34fd                	addiw	s1,s1,-1
    32d4:	f4ed                	bnez	s1,32be <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    32d6:	f8040123          	sb	zero,-126(s0)
    32da:	03000993          	li	s3,48
    32de:	5a7d                	li	s4,-1
    32e0:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    32e4:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    32e6:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    32e8:	07400a93          	li	s5,116
    32ec:	a29d                	j	3452 <createdelete+0x1cc>
      printf("fork failed\n", s);
    32ee:	85e6                	mv	a1,s9
    32f0:	00005517          	auipc	a0,0x5
    32f4:	8c850513          	addi	a0,a0,-1848 # 7bb8 <malloc+0x1f48>
    32f8:	00003097          	auipc	ra,0x3
    32fc:	8c0080e7          	jalr	-1856(ra) # 5bb8 <printf>
      exit(1);
    3300:	4505                	li	a0,1
    3302:	00002097          	auipc	ra,0x2
    3306:	52c080e7          	jalr	1324(ra) # 582e <exit>
      name[0] = 'p' + pi;
    330a:	0709091b          	addiw	s2,s2,112
    330e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    3312:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    3316:	4951                	li	s2,20
    3318:	a015                	j	333c <createdelete+0xb6>
          printf("%s: create failed\n", s);
    331a:	85e6                	mv	a1,s9
    331c:	00004517          	auipc	a0,0x4
    3320:	b0c50513          	addi	a0,a0,-1268 # 6e28 <malloc+0x11b8>
    3324:	00003097          	auipc	ra,0x3
    3328:	894080e7          	jalr	-1900(ra) # 5bb8 <printf>
          exit(1);
    332c:	4505                	li	a0,1
    332e:	00002097          	auipc	ra,0x2
    3332:	500080e7          	jalr	1280(ra) # 582e <exit>
      for(i = 0; i < N; i++){
    3336:	2485                	addiw	s1,s1,1
    3338:	07248863          	beq	s1,s2,33a8 <createdelete+0x122>
        name[1] = '0' + i;
    333c:	0304879b          	addiw	a5,s1,48
    3340:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    3344:	20200593          	li	a1,514
    3348:	f8040513          	addi	a0,s0,-128
    334c:	00002097          	auipc	ra,0x2
    3350:	522080e7          	jalr	1314(ra) # 586e <open>
        if(fd < 0){
    3354:	fc0543e3          	bltz	a0,331a <createdelete+0x94>
        close(fd);
    3358:	00002097          	auipc	ra,0x2
    335c:	4fe080e7          	jalr	1278(ra) # 5856 <close>
        if(i > 0 && (i % 2 ) == 0){
    3360:	fc905be3          	blez	s1,3336 <createdelete+0xb0>
    3364:	0014f793          	andi	a5,s1,1
    3368:	f7f9                	bnez	a5,3336 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    336a:	01f4d79b          	srliw	a5,s1,0x1f
    336e:	9fa5                	addw	a5,a5,s1
    3370:	4017d79b          	sraiw	a5,a5,0x1
    3374:	0307879b          	addiw	a5,a5,48
    3378:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    337c:	f8040513          	addi	a0,s0,-128
    3380:	00002097          	auipc	ra,0x2
    3384:	4fe080e7          	jalr	1278(ra) # 587e <unlink>
    3388:	fa0557e3          	bgez	a0,3336 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    338c:	85e6                	mv	a1,s9
    338e:	00003517          	auipc	a0,0x3
    3392:	3ea50513          	addi	a0,a0,1002 # 6778 <malloc+0xb08>
    3396:	00003097          	auipc	ra,0x3
    339a:	822080e7          	jalr	-2014(ra) # 5bb8 <printf>
            exit(1);
    339e:	4505                	li	a0,1
    33a0:	00002097          	auipc	ra,0x2
    33a4:	48e080e7          	jalr	1166(ra) # 582e <exit>
      exit(0);
    33a8:	4501                	li	a0,0
    33aa:	00002097          	auipc	ra,0x2
    33ae:	484080e7          	jalr	1156(ra) # 582e <exit>
      exit(1);
    33b2:	4505                	li	a0,1
    33b4:	00002097          	auipc	ra,0x2
    33b8:	47a080e7          	jalr	1146(ra) # 582e <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    33bc:	f8040613          	addi	a2,s0,-128
    33c0:	85e6                	mv	a1,s9
    33c2:	00004517          	auipc	a0,0x4
    33c6:	c0e50513          	addi	a0,a0,-1010 # 6fd0 <malloc+0x1360>
    33ca:	00002097          	auipc	ra,0x2
    33ce:	7ee080e7          	jalr	2030(ra) # 5bb8 <printf>
        exit(1);
    33d2:	4505                	li	a0,1
    33d4:	00002097          	auipc	ra,0x2
    33d8:	45a080e7          	jalr	1114(ra) # 582e <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    33dc:	054b7163          	bgeu	s6,s4,341e <createdelete+0x198>
      if(fd >= 0)
    33e0:	02055a63          	bgez	a0,3414 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    33e4:	2485                	addiw	s1,s1,1
    33e6:	0ff4f493          	zext.b	s1,s1
    33ea:	05548c63          	beq	s1,s5,3442 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    33ee:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    33f2:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    33f6:	4581                	li	a1,0
    33f8:	f8040513          	addi	a0,s0,-128
    33fc:	00002097          	auipc	ra,0x2
    3400:	472080e7          	jalr	1138(ra) # 586e <open>
      if((i == 0 || i >= N/2) && fd < 0){
    3404:	00090463          	beqz	s2,340c <createdelete+0x186>
    3408:	fd2bdae3          	bge	s7,s2,33dc <createdelete+0x156>
    340c:	fa0548e3          	bltz	a0,33bc <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    3410:	014b7963          	bgeu	s6,s4,3422 <createdelete+0x19c>
        close(fd);
    3414:	00002097          	auipc	ra,0x2
    3418:	442080e7          	jalr	1090(ra) # 5856 <close>
    341c:	b7e1                	j	33e4 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    341e:	fc0543e3          	bltz	a0,33e4 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    3422:	f8040613          	addi	a2,s0,-128
    3426:	85e6                	mv	a1,s9
    3428:	00004517          	auipc	a0,0x4
    342c:	bd050513          	addi	a0,a0,-1072 # 6ff8 <malloc+0x1388>
    3430:	00002097          	auipc	ra,0x2
    3434:	788080e7          	jalr	1928(ra) # 5bb8 <printf>
        exit(1);
    3438:	4505                	li	a0,1
    343a:	00002097          	auipc	ra,0x2
    343e:	3f4080e7          	jalr	1012(ra) # 582e <exit>
  for(i = 0; i < N; i++){
    3442:	2905                	addiw	s2,s2,1
    3444:	2a05                	addiw	s4,s4,1
    3446:	2985                	addiw	s3,s3,1
    3448:	0ff9f993          	zext.b	s3,s3
    344c:	47d1                	li	a5,20
    344e:	02f90a63          	beq	s2,a5,3482 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    3452:	84e2                	mv	s1,s8
    3454:	bf69                	j	33ee <createdelete+0x168>
  for(i = 0; i < N; i++){
    3456:	2905                	addiw	s2,s2,1
    3458:	0ff97913          	zext.b	s2,s2
    345c:	2985                	addiw	s3,s3,1
    345e:	0ff9f993          	zext.b	s3,s3
    3462:	03490863          	beq	s2,s4,3492 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    3466:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    3468:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    346c:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    3470:	f8040513          	addi	a0,s0,-128
    3474:	00002097          	auipc	ra,0x2
    3478:	40a080e7          	jalr	1034(ra) # 587e <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    347c:	34fd                	addiw	s1,s1,-1
    347e:	f4ed                	bnez	s1,3468 <createdelete+0x1e2>
    3480:	bfd9                	j	3456 <createdelete+0x1d0>
    3482:	03000993          	li	s3,48
    3486:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    348a:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    348c:	08400a13          	li	s4,132
    3490:	bfd9                	j	3466 <createdelete+0x1e0>
}
    3492:	60aa                	ld	ra,136(sp)
    3494:	640a                	ld	s0,128(sp)
    3496:	74e6                	ld	s1,120(sp)
    3498:	7946                	ld	s2,112(sp)
    349a:	79a6                	ld	s3,104(sp)
    349c:	7a06                	ld	s4,96(sp)
    349e:	6ae6                	ld	s5,88(sp)
    34a0:	6b46                	ld	s6,80(sp)
    34a2:	6ba6                	ld	s7,72(sp)
    34a4:	6c06                	ld	s8,64(sp)
    34a6:	7ce2                	ld	s9,56(sp)
    34a8:	6149                	addi	sp,sp,144
    34aa:	8082                	ret

00000000000034ac <unlinkread>:
{
    34ac:	7179                	addi	sp,sp,-48
    34ae:	f406                	sd	ra,40(sp)
    34b0:	f022                	sd	s0,32(sp)
    34b2:	ec26                	sd	s1,24(sp)
    34b4:	e84a                	sd	s2,16(sp)
    34b6:	e44e                	sd	s3,8(sp)
    34b8:	1800                	addi	s0,sp,48
    34ba:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
    34bc:	20200593          	li	a1,514
    34c0:	00004517          	auipc	a0,0x4
    34c4:	b6050513          	addi	a0,a0,-1184 # 7020 <malloc+0x13b0>
    34c8:	00002097          	auipc	ra,0x2
    34cc:	3a6080e7          	jalr	934(ra) # 586e <open>
  if(fd < 0){
    34d0:	0e054563          	bltz	a0,35ba <unlinkread+0x10e>
    34d4:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
    34d6:	4615                	li	a2,5
    34d8:	00004597          	auipc	a1,0x4
    34dc:	b7858593          	addi	a1,a1,-1160 # 7050 <malloc+0x13e0>
    34e0:	00002097          	auipc	ra,0x2
    34e4:	36e080e7          	jalr	878(ra) # 584e <write>
  close(fd);
    34e8:	8526                	mv	a0,s1
    34ea:	00002097          	auipc	ra,0x2
    34ee:	36c080e7          	jalr	876(ra) # 5856 <close>
  fd = open("unlinkread", O_RDWR);
    34f2:	4589                	li	a1,2
    34f4:	00004517          	auipc	a0,0x4
    34f8:	b2c50513          	addi	a0,a0,-1236 # 7020 <malloc+0x13b0>
    34fc:	00002097          	auipc	ra,0x2
    3500:	372080e7          	jalr	882(ra) # 586e <open>
    3504:	84aa                	mv	s1,a0
  if(fd < 0){
    3506:	0c054863          	bltz	a0,35d6 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
    350a:	00004517          	auipc	a0,0x4
    350e:	b1650513          	addi	a0,a0,-1258 # 7020 <malloc+0x13b0>
    3512:	00002097          	auipc	ra,0x2
    3516:	36c080e7          	jalr	876(ra) # 587e <unlink>
    351a:	ed61                	bnez	a0,35f2 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    351c:	20200593          	li	a1,514
    3520:	00004517          	auipc	a0,0x4
    3524:	b0050513          	addi	a0,a0,-1280 # 7020 <malloc+0x13b0>
    3528:	00002097          	auipc	ra,0x2
    352c:	346080e7          	jalr	838(ra) # 586e <open>
    3530:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    3532:	460d                	li	a2,3
    3534:	00004597          	auipc	a1,0x4
    3538:	b6458593          	addi	a1,a1,-1180 # 7098 <malloc+0x1428>
    353c:	00002097          	auipc	ra,0x2
    3540:	312080e7          	jalr	786(ra) # 584e <write>
  close(fd1);
    3544:	854a                	mv	a0,s2
    3546:	00002097          	auipc	ra,0x2
    354a:	310080e7          	jalr	784(ra) # 5856 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
    354e:	660d                	lui	a2,0x3
    3550:	00008597          	auipc	a1,0x8
    3554:	48058593          	addi	a1,a1,1152 # b9d0 <buf>
    3558:	8526                	mv	a0,s1
    355a:	00002097          	auipc	ra,0x2
    355e:	2ec080e7          	jalr	748(ra) # 5846 <read>
    3562:	4795                	li	a5,5
    3564:	0af51563          	bne	a0,a5,360e <unlinkread+0x162>
  if(buf[0] != 'h'){
    3568:	00008717          	auipc	a4,0x8
    356c:	46874703          	lbu	a4,1128(a4) # b9d0 <buf>
    3570:	06800793          	li	a5,104
    3574:	0af71b63          	bne	a4,a5,362a <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
    3578:	4629                	li	a2,10
    357a:	00008597          	auipc	a1,0x8
    357e:	45658593          	addi	a1,a1,1110 # b9d0 <buf>
    3582:	8526                	mv	a0,s1
    3584:	00002097          	auipc	ra,0x2
    3588:	2ca080e7          	jalr	714(ra) # 584e <write>
    358c:	47a9                	li	a5,10
    358e:	0af51c63          	bne	a0,a5,3646 <unlinkread+0x19a>
  close(fd);
    3592:	8526                	mv	a0,s1
    3594:	00002097          	auipc	ra,0x2
    3598:	2c2080e7          	jalr	706(ra) # 5856 <close>
  unlink("unlinkread");
    359c:	00004517          	auipc	a0,0x4
    35a0:	a8450513          	addi	a0,a0,-1404 # 7020 <malloc+0x13b0>
    35a4:	00002097          	auipc	ra,0x2
    35a8:	2da080e7          	jalr	730(ra) # 587e <unlink>
}
    35ac:	70a2                	ld	ra,40(sp)
    35ae:	7402                	ld	s0,32(sp)
    35b0:	64e2                	ld	s1,24(sp)
    35b2:	6942                	ld	s2,16(sp)
    35b4:	69a2                	ld	s3,8(sp)
    35b6:	6145                	addi	sp,sp,48
    35b8:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
    35ba:	85ce                	mv	a1,s3
    35bc:	00004517          	auipc	a0,0x4
    35c0:	a7450513          	addi	a0,a0,-1420 # 7030 <malloc+0x13c0>
    35c4:	00002097          	auipc	ra,0x2
    35c8:	5f4080e7          	jalr	1524(ra) # 5bb8 <printf>
    exit(1);
    35cc:	4505                	li	a0,1
    35ce:	00002097          	auipc	ra,0x2
    35d2:	260080e7          	jalr	608(ra) # 582e <exit>
    printf("%s: open unlinkread failed\n", s);
    35d6:	85ce                	mv	a1,s3
    35d8:	00004517          	auipc	a0,0x4
    35dc:	a8050513          	addi	a0,a0,-1408 # 7058 <malloc+0x13e8>
    35e0:	00002097          	auipc	ra,0x2
    35e4:	5d8080e7          	jalr	1496(ra) # 5bb8 <printf>
    exit(1);
    35e8:	4505                	li	a0,1
    35ea:	00002097          	auipc	ra,0x2
    35ee:	244080e7          	jalr	580(ra) # 582e <exit>
    printf("%s: unlink unlinkread failed\n", s);
    35f2:	85ce                	mv	a1,s3
    35f4:	00004517          	auipc	a0,0x4
    35f8:	a8450513          	addi	a0,a0,-1404 # 7078 <malloc+0x1408>
    35fc:	00002097          	auipc	ra,0x2
    3600:	5bc080e7          	jalr	1468(ra) # 5bb8 <printf>
    exit(1);
    3604:	4505                	li	a0,1
    3606:	00002097          	auipc	ra,0x2
    360a:	228080e7          	jalr	552(ra) # 582e <exit>
    printf("%s: unlinkread read failed", s);
    360e:	85ce                	mv	a1,s3
    3610:	00004517          	auipc	a0,0x4
    3614:	a9050513          	addi	a0,a0,-1392 # 70a0 <malloc+0x1430>
    3618:	00002097          	auipc	ra,0x2
    361c:	5a0080e7          	jalr	1440(ra) # 5bb8 <printf>
    exit(1);
    3620:	4505                	li	a0,1
    3622:	00002097          	auipc	ra,0x2
    3626:	20c080e7          	jalr	524(ra) # 582e <exit>
    printf("%s: unlinkread wrong data\n", s);
    362a:	85ce                	mv	a1,s3
    362c:	00004517          	auipc	a0,0x4
    3630:	a9450513          	addi	a0,a0,-1388 # 70c0 <malloc+0x1450>
    3634:	00002097          	auipc	ra,0x2
    3638:	584080e7          	jalr	1412(ra) # 5bb8 <printf>
    exit(1);
    363c:	4505                	li	a0,1
    363e:	00002097          	auipc	ra,0x2
    3642:	1f0080e7          	jalr	496(ra) # 582e <exit>
    printf("%s: unlinkread write failed\n", s);
    3646:	85ce                	mv	a1,s3
    3648:	00004517          	auipc	a0,0x4
    364c:	a9850513          	addi	a0,a0,-1384 # 70e0 <malloc+0x1470>
    3650:	00002097          	auipc	ra,0x2
    3654:	568080e7          	jalr	1384(ra) # 5bb8 <printf>
    exit(1);
    3658:	4505                	li	a0,1
    365a:	00002097          	auipc	ra,0x2
    365e:	1d4080e7          	jalr	468(ra) # 582e <exit>

0000000000003662 <linktest>:
{
    3662:	1101                	addi	sp,sp,-32
    3664:	ec06                	sd	ra,24(sp)
    3666:	e822                	sd	s0,16(sp)
    3668:	e426                	sd	s1,8(sp)
    366a:	e04a                	sd	s2,0(sp)
    366c:	1000                	addi	s0,sp,32
    366e:	892a                	mv	s2,a0
  unlink("lf1");
    3670:	00004517          	auipc	a0,0x4
    3674:	a9050513          	addi	a0,a0,-1392 # 7100 <malloc+0x1490>
    3678:	00002097          	auipc	ra,0x2
    367c:	206080e7          	jalr	518(ra) # 587e <unlink>
  unlink("lf2");
    3680:	00004517          	auipc	a0,0x4
    3684:	a8850513          	addi	a0,a0,-1400 # 7108 <malloc+0x1498>
    3688:	00002097          	auipc	ra,0x2
    368c:	1f6080e7          	jalr	502(ra) # 587e <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    3690:	20200593          	li	a1,514
    3694:	00004517          	auipc	a0,0x4
    3698:	a6c50513          	addi	a0,a0,-1428 # 7100 <malloc+0x1490>
    369c:	00002097          	auipc	ra,0x2
    36a0:	1d2080e7          	jalr	466(ra) # 586e <open>
  if(fd < 0){
    36a4:	10054763          	bltz	a0,37b2 <linktest+0x150>
    36a8:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    36aa:	4615                	li	a2,5
    36ac:	00004597          	auipc	a1,0x4
    36b0:	9a458593          	addi	a1,a1,-1628 # 7050 <malloc+0x13e0>
    36b4:	00002097          	auipc	ra,0x2
    36b8:	19a080e7          	jalr	410(ra) # 584e <write>
    36bc:	4795                	li	a5,5
    36be:	10f51863          	bne	a0,a5,37ce <linktest+0x16c>
  close(fd);
    36c2:	8526                	mv	a0,s1
    36c4:	00002097          	auipc	ra,0x2
    36c8:	192080e7          	jalr	402(ra) # 5856 <close>
  if(link("lf1", "lf2") < 0){
    36cc:	00004597          	auipc	a1,0x4
    36d0:	a3c58593          	addi	a1,a1,-1476 # 7108 <malloc+0x1498>
    36d4:	00004517          	auipc	a0,0x4
    36d8:	a2c50513          	addi	a0,a0,-1492 # 7100 <malloc+0x1490>
    36dc:	00002097          	auipc	ra,0x2
    36e0:	1b2080e7          	jalr	434(ra) # 588e <link>
    36e4:	10054363          	bltz	a0,37ea <linktest+0x188>
  unlink("lf1");
    36e8:	00004517          	auipc	a0,0x4
    36ec:	a1850513          	addi	a0,a0,-1512 # 7100 <malloc+0x1490>
    36f0:	00002097          	auipc	ra,0x2
    36f4:	18e080e7          	jalr	398(ra) # 587e <unlink>
  if(open("lf1", 0) >= 0){
    36f8:	4581                	li	a1,0
    36fa:	00004517          	auipc	a0,0x4
    36fe:	a0650513          	addi	a0,a0,-1530 # 7100 <malloc+0x1490>
    3702:	00002097          	auipc	ra,0x2
    3706:	16c080e7          	jalr	364(ra) # 586e <open>
    370a:	0e055e63          	bgez	a0,3806 <linktest+0x1a4>
  fd = open("lf2", 0);
    370e:	4581                	li	a1,0
    3710:	00004517          	auipc	a0,0x4
    3714:	9f850513          	addi	a0,a0,-1544 # 7108 <malloc+0x1498>
    3718:	00002097          	auipc	ra,0x2
    371c:	156080e7          	jalr	342(ra) # 586e <open>
    3720:	84aa                	mv	s1,a0
  if(fd < 0){
    3722:	10054063          	bltz	a0,3822 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    3726:	660d                	lui	a2,0x3
    3728:	00008597          	auipc	a1,0x8
    372c:	2a858593          	addi	a1,a1,680 # b9d0 <buf>
    3730:	00002097          	auipc	ra,0x2
    3734:	116080e7          	jalr	278(ra) # 5846 <read>
    3738:	4795                	li	a5,5
    373a:	10f51263          	bne	a0,a5,383e <linktest+0x1dc>
  close(fd);
    373e:	8526                	mv	a0,s1
    3740:	00002097          	auipc	ra,0x2
    3744:	116080e7          	jalr	278(ra) # 5856 <close>
  if(link("lf2", "lf2") >= 0){
    3748:	00004597          	auipc	a1,0x4
    374c:	9c058593          	addi	a1,a1,-1600 # 7108 <malloc+0x1498>
    3750:	852e                	mv	a0,a1
    3752:	00002097          	auipc	ra,0x2
    3756:	13c080e7          	jalr	316(ra) # 588e <link>
    375a:	10055063          	bgez	a0,385a <linktest+0x1f8>
  unlink("lf2");
    375e:	00004517          	auipc	a0,0x4
    3762:	9aa50513          	addi	a0,a0,-1622 # 7108 <malloc+0x1498>
    3766:	00002097          	auipc	ra,0x2
    376a:	118080e7          	jalr	280(ra) # 587e <unlink>
  if(link("lf2", "lf1") >= 0){
    376e:	00004597          	auipc	a1,0x4
    3772:	99258593          	addi	a1,a1,-1646 # 7100 <malloc+0x1490>
    3776:	00004517          	auipc	a0,0x4
    377a:	99250513          	addi	a0,a0,-1646 # 7108 <malloc+0x1498>
    377e:	00002097          	auipc	ra,0x2
    3782:	110080e7          	jalr	272(ra) # 588e <link>
    3786:	0e055863          	bgez	a0,3876 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    378a:	00004597          	auipc	a1,0x4
    378e:	97658593          	addi	a1,a1,-1674 # 7100 <malloc+0x1490>
    3792:	00003517          	auipc	a0,0x3
    3796:	d4e50513          	addi	a0,a0,-690 # 64e0 <malloc+0x870>
    379a:	00002097          	auipc	ra,0x2
    379e:	0f4080e7          	jalr	244(ra) # 588e <link>
    37a2:	0e055863          	bgez	a0,3892 <linktest+0x230>
}
    37a6:	60e2                	ld	ra,24(sp)
    37a8:	6442                	ld	s0,16(sp)
    37aa:	64a2                	ld	s1,8(sp)
    37ac:	6902                	ld	s2,0(sp)
    37ae:	6105                	addi	sp,sp,32
    37b0:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    37b2:	85ca                	mv	a1,s2
    37b4:	00004517          	auipc	a0,0x4
    37b8:	95c50513          	addi	a0,a0,-1700 # 7110 <malloc+0x14a0>
    37bc:	00002097          	auipc	ra,0x2
    37c0:	3fc080e7          	jalr	1020(ra) # 5bb8 <printf>
    exit(1);
    37c4:	4505                	li	a0,1
    37c6:	00002097          	auipc	ra,0x2
    37ca:	068080e7          	jalr	104(ra) # 582e <exit>
    printf("%s: write lf1 failed\n", s);
    37ce:	85ca                	mv	a1,s2
    37d0:	00004517          	auipc	a0,0x4
    37d4:	95850513          	addi	a0,a0,-1704 # 7128 <malloc+0x14b8>
    37d8:	00002097          	auipc	ra,0x2
    37dc:	3e0080e7          	jalr	992(ra) # 5bb8 <printf>
    exit(1);
    37e0:	4505                	li	a0,1
    37e2:	00002097          	auipc	ra,0x2
    37e6:	04c080e7          	jalr	76(ra) # 582e <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    37ea:	85ca                	mv	a1,s2
    37ec:	00004517          	auipc	a0,0x4
    37f0:	95450513          	addi	a0,a0,-1708 # 7140 <malloc+0x14d0>
    37f4:	00002097          	auipc	ra,0x2
    37f8:	3c4080e7          	jalr	964(ra) # 5bb8 <printf>
    exit(1);
    37fc:	4505                	li	a0,1
    37fe:	00002097          	auipc	ra,0x2
    3802:	030080e7          	jalr	48(ra) # 582e <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    3806:	85ca                	mv	a1,s2
    3808:	00004517          	auipc	a0,0x4
    380c:	95850513          	addi	a0,a0,-1704 # 7160 <malloc+0x14f0>
    3810:	00002097          	auipc	ra,0x2
    3814:	3a8080e7          	jalr	936(ra) # 5bb8 <printf>
    exit(1);
    3818:	4505                	li	a0,1
    381a:	00002097          	auipc	ra,0x2
    381e:	014080e7          	jalr	20(ra) # 582e <exit>
    printf("%s: open lf2 failed\n", s);
    3822:	85ca                	mv	a1,s2
    3824:	00004517          	auipc	a0,0x4
    3828:	96c50513          	addi	a0,a0,-1684 # 7190 <malloc+0x1520>
    382c:	00002097          	auipc	ra,0x2
    3830:	38c080e7          	jalr	908(ra) # 5bb8 <printf>
    exit(1);
    3834:	4505                	li	a0,1
    3836:	00002097          	auipc	ra,0x2
    383a:	ff8080e7          	jalr	-8(ra) # 582e <exit>
    printf("%s: read lf2 failed\n", s);
    383e:	85ca                	mv	a1,s2
    3840:	00004517          	auipc	a0,0x4
    3844:	96850513          	addi	a0,a0,-1688 # 71a8 <malloc+0x1538>
    3848:	00002097          	auipc	ra,0x2
    384c:	370080e7          	jalr	880(ra) # 5bb8 <printf>
    exit(1);
    3850:	4505                	li	a0,1
    3852:	00002097          	auipc	ra,0x2
    3856:	fdc080e7          	jalr	-36(ra) # 582e <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    385a:	85ca                	mv	a1,s2
    385c:	00004517          	auipc	a0,0x4
    3860:	96450513          	addi	a0,a0,-1692 # 71c0 <malloc+0x1550>
    3864:	00002097          	auipc	ra,0x2
    3868:	354080e7          	jalr	852(ra) # 5bb8 <printf>
    exit(1);
    386c:	4505                	li	a0,1
    386e:	00002097          	auipc	ra,0x2
    3872:	fc0080e7          	jalr	-64(ra) # 582e <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    3876:	85ca                	mv	a1,s2
    3878:	00004517          	auipc	a0,0x4
    387c:	97050513          	addi	a0,a0,-1680 # 71e8 <malloc+0x1578>
    3880:	00002097          	auipc	ra,0x2
    3884:	338080e7          	jalr	824(ra) # 5bb8 <printf>
    exit(1);
    3888:	4505                	li	a0,1
    388a:	00002097          	auipc	ra,0x2
    388e:	fa4080e7          	jalr	-92(ra) # 582e <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    3892:	85ca                	mv	a1,s2
    3894:	00004517          	auipc	a0,0x4
    3898:	97c50513          	addi	a0,a0,-1668 # 7210 <malloc+0x15a0>
    389c:	00002097          	auipc	ra,0x2
    38a0:	31c080e7          	jalr	796(ra) # 5bb8 <printf>
    exit(1);
    38a4:	4505                	li	a0,1
    38a6:	00002097          	auipc	ra,0x2
    38aa:	f88080e7          	jalr	-120(ra) # 582e <exit>

00000000000038ae <concreate>:
{
    38ae:	7135                	addi	sp,sp,-160
    38b0:	ed06                	sd	ra,152(sp)
    38b2:	e922                	sd	s0,144(sp)
    38b4:	e526                	sd	s1,136(sp)
    38b6:	e14a                	sd	s2,128(sp)
    38b8:	fcce                	sd	s3,120(sp)
    38ba:	f8d2                	sd	s4,112(sp)
    38bc:	f4d6                	sd	s5,104(sp)
    38be:	f0da                	sd	s6,96(sp)
    38c0:	ecde                	sd	s7,88(sp)
    38c2:	1100                	addi	s0,sp,160
    38c4:	89aa                	mv	s3,a0
  file[0] = 'C';
    38c6:	04300793          	li	a5,67
    38ca:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    38ce:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    38d2:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    38d4:	4b0d                	li	s6,3
    38d6:	4a85                	li	s5,1
      link("C0", file);
    38d8:	00004b97          	auipc	s7,0x4
    38dc:	958b8b93          	addi	s7,s7,-1704 # 7230 <malloc+0x15c0>
  for(i = 0; i < N; i++){
    38e0:	02800a13          	li	s4,40
    38e4:	acc9                	j	3bb6 <concreate+0x308>
      link("C0", file);
    38e6:	fa840593          	addi	a1,s0,-88
    38ea:	855e                	mv	a0,s7
    38ec:	00002097          	auipc	ra,0x2
    38f0:	fa2080e7          	jalr	-94(ra) # 588e <link>
    if(pid == 0) {
    38f4:	a465                	j	3b9c <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    38f6:	4795                	li	a5,5
    38f8:	02f9693b          	remw	s2,s2,a5
    38fc:	4785                	li	a5,1
    38fe:	02f90b63          	beq	s2,a5,3934 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    3902:	20200593          	li	a1,514
    3906:	fa840513          	addi	a0,s0,-88
    390a:	00002097          	auipc	ra,0x2
    390e:	f64080e7          	jalr	-156(ra) # 586e <open>
      if(fd < 0){
    3912:	26055c63          	bgez	a0,3b8a <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    3916:	fa840593          	addi	a1,s0,-88
    391a:	00004517          	auipc	a0,0x4
    391e:	91e50513          	addi	a0,a0,-1762 # 7238 <malloc+0x15c8>
    3922:	00002097          	auipc	ra,0x2
    3926:	296080e7          	jalr	662(ra) # 5bb8 <printf>
        exit(1);
    392a:	4505                	li	a0,1
    392c:	00002097          	auipc	ra,0x2
    3930:	f02080e7          	jalr	-254(ra) # 582e <exit>
      link("C0", file);
    3934:	fa840593          	addi	a1,s0,-88
    3938:	00004517          	auipc	a0,0x4
    393c:	8f850513          	addi	a0,a0,-1800 # 7230 <malloc+0x15c0>
    3940:	00002097          	auipc	ra,0x2
    3944:	f4e080e7          	jalr	-178(ra) # 588e <link>
      exit(0);
    3948:	4501                	li	a0,0
    394a:	00002097          	auipc	ra,0x2
    394e:	ee4080e7          	jalr	-284(ra) # 582e <exit>
        exit(1);
    3952:	4505                	li	a0,1
    3954:	00002097          	auipc	ra,0x2
    3958:	eda080e7          	jalr	-294(ra) # 582e <exit>
  memset(fa, 0, sizeof(fa));
    395c:	02800613          	li	a2,40
    3960:	4581                	li	a1,0
    3962:	f8040513          	addi	a0,s0,-128
    3966:	00002097          	auipc	ra,0x2
    396a:	cce080e7          	jalr	-818(ra) # 5634 <memset>
  fd = open(".", 0);
    396e:	4581                	li	a1,0
    3970:	00003517          	auipc	a0,0x3
    3974:	b7050513          	addi	a0,a0,-1168 # 64e0 <malloc+0x870>
    3978:	00002097          	auipc	ra,0x2
    397c:	ef6080e7          	jalr	-266(ra) # 586e <open>
    3980:	892a                	mv	s2,a0
  n = 0;
    3982:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3984:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3988:	02700b13          	li	s6,39
      fa[i] = 1;
    398c:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    398e:	4641                	li	a2,16
    3990:	f7040593          	addi	a1,s0,-144
    3994:	854a                	mv	a0,s2
    3996:	00002097          	auipc	ra,0x2
    399a:	eb0080e7          	jalr	-336(ra) # 5846 <read>
    399e:	08a05263          	blez	a0,3a22 <concreate+0x174>
    if(de.inum == 0)
    39a2:	f7045783          	lhu	a5,-144(s0)
    39a6:	d7e5                	beqz	a5,398e <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    39a8:	f7244783          	lbu	a5,-142(s0)
    39ac:	ff4791e3          	bne	a5,s4,398e <concreate+0xe0>
    39b0:	f7444783          	lbu	a5,-140(s0)
    39b4:	ffe9                	bnez	a5,398e <concreate+0xe0>
      i = de.name[1] - '0';
    39b6:	f7344783          	lbu	a5,-141(s0)
    39ba:	fd07879b          	addiw	a5,a5,-48
    39be:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    39c2:	02eb6063          	bltu	s6,a4,39e2 <concreate+0x134>
      if(fa[i]){
    39c6:	fb070793          	addi	a5,a4,-80
    39ca:	97a2                	add	a5,a5,s0
    39cc:	fd07c783          	lbu	a5,-48(a5)
    39d0:	eb8d                	bnez	a5,3a02 <concreate+0x154>
      fa[i] = 1;
    39d2:	fb070793          	addi	a5,a4,-80
    39d6:	00878733          	add	a4,a5,s0
    39da:	fd770823          	sb	s7,-48(a4)
      n++;
    39de:	2a85                	addiw	s5,s5,1
    39e0:	b77d                	j	398e <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    39e2:	f7240613          	addi	a2,s0,-142
    39e6:	85ce                	mv	a1,s3
    39e8:	00004517          	auipc	a0,0x4
    39ec:	87050513          	addi	a0,a0,-1936 # 7258 <malloc+0x15e8>
    39f0:	00002097          	auipc	ra,0x2
    39f4:	1c8080e7          	jalr	456(ra) # 5bb8 <printf>
        exit(1);
    39f8:	4505                	li	a0,1
    39fa:	00002097          	auipc	ra,0x2
    39fe:	e34080e7          	jalr	-460(ra) # 582e <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3a02:	f7240613          	addi	a2,s0,-142
    3a06:	85ce                	mv	a1,s3
    3a08:	00004517          	auipc	a0,0x4
    3a0c:	87050513          	addi	a0,a0,-1936 # 7278 <malloc+0x1608>
    3a10:	00002097          	auipc	ra,0x2
    3a14:	1a8080e7          	jalr	424(ra) # 5bb8 <printf>
        exit(1);
    3a18:	4505                	li	a0,1
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	e14080e7          	jalr	-492(ra) # 582e <exit>
  close(fd);
    3a22:	854a                	mv	a0,s2
    3a24:	00002097          	auipc	ra,0x2
    3a28:	e32080e7          	jalr	-462(ra) # 5856 <close>
  if(n != N){
    3a2c:	02800793          	li	a5,40
    3a30:	00fa9763          	bne	s5,a5,3a3e <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    3a34:	4a8d                	li	s5,3
    3a36:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3a38:	02800a13          	li	s4,40
    3a3c:	a8c9                	j	3b0e <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    3a3e:	85ce                	mv	a1,s3
    3a40:	00004517          	auipc	a0,0x4
    3a44:	86050513          	addi	a0,a0,-1952 # 72a0 <malloc+0x1630>
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	170080e7          	jalr	368(ra) # 5bb8 <printf>
    exit(1);
    3a50:	4505                	li	a0,1
    3a52:	00002097          	auipc	ra,0x2
    3a56:	ddc080e7          	jalr	-548(ra) # 582e <exit>
      printf("%s: fork failed\n", s);
    3a5a:	85ce                	mv	a1,s3
    3a5c:	00002517          	auipc	a0,0x2
    3a60:	64c50513          	addi	a0,a0,1612 # 60a8 <malloc+0x438>
    3a64:	00002097          	auipc	ra,0x2
    3a68:	154080e7          	jalr	340(ra) # 5bb8 <printf>
      exit(1);
    3a6c:	4505                	li	a0,1
    3a6e:	00002097          	auipc	ra,0x2
    3a72:	dc0080e7          	jalr	-576(ra) # 582e <exit>
      close(open(file, 0));
    3a76:	4581                	li	a1,0
    3a78:	fa840513          	addi	a0,s0,-88
    3a7c:	00002097          	auipc	ra,0x2
    3a80:	df2080e7          	jalr	-526(ra) # 586e <open>
    3a84:	00002097          	auipc	ra,0x2
    3a88:	dd2080e7          	jalr	-558(ra) # 5856 <close>
      close(open(file, 0));
    3a8c:	4581                	li	a1,0
    3a8e:	fa840513          	addi	a0,s0,-88
    3a92:	00002097          	auipc	ra,0x2
    3a96:	ddc080e7          	jalr	-548(ra) # 586e <open>
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	dbc080e7          	jalr	-580(ra) # 5856 <close>
      close(open(file, 0));
    3aa2:	4581                	li	a1,0
    3aa4:	fa840513          	addi	a0,s0,-88
    3aa8:	00002097          	auipc	ra,0x2
    3aac:	dc6080e7          	jalr	-570(ra) # 586e <open>
    3ab0:	00002097          	auipc	ra,0x2
    3ab4:	da6080e7          	jalr	-602(ra) # 5856 <close>
      close(open(file, 0));
    3ab8:	4581                	li	a1,0
    3aba:	fa840513          	addi	a0,s0,-88
    3abe:	00002097          	auipc	ra,0x2
    3ac2:	db0080e7          	jalr	-592(ra) # 586e <open>
    3ac6:	00002097          	auipc	ra,0x2
    3aca:	d90080e7          	jalr	-624(ra) # 5856 <close>
      close(open(file, 0));
    3ace:	4581                	li	a1,0
    3ad0:	fa840513          	addi	a0,s0,-88
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	d9a080e7          	jalr	-614(ra) # 586e <open>
    3adc:	00002097          	auipc	ra,0x2
    3ae0:	d7a080e7          	jalr	-646(ra) # 5856 <close>
      close(open(file, 0));
    3ae4:	4581                	li	a1,0
    3ae6:	fa840513          	addi	a0,s0,-88
    3aea:	00002097          	auipc	ra,0x2
    3aee:	d84080e7          	jalr	-636(ra) # 586e <open>
    3af2:	00002097          	auipc	ra,0x2
    3af6:	d64080e7          	jalr	-668(ra) # 5856 <close>
    if(pid == 0)
    3afa:	08090363          	beqz	s2,3b80 <concreate+0x2d2>
      wait(0);
    3afe:	4501                	li	a0,0
    3b00:	00002097          	auipc	ra,0x2
    3b04:	d36080e7          	jalr	-714(ra) # 5836 <wait>
  for(i = 0; i < N; i++){
    3b08:	2485                	addiw	s1,s1,1
    3b0a:	0f448563          	beq	s1,s4,3bf4 <concreate+0x346>
    file[1] = '0' + i;
    3b0e:	0304879b          	addiw	a5,s1,48
    3b12:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    3b16:	00002097          	auipc	ra,0x2
    3b1a:	d10080e7          	jalr	-752(ra) # 5826 <fork>
    3b1e:	892a                	mv	s2,a0
    if(pid < 0){
    3b20:	f2054de3          	bltz	a0,3a5a <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    3b24:	0354e73b          	remw	a4,s1,s5
    3b28:	00a767b3          	or	a5,a4,a0
    3b2c:	2781                	sext.w	a5,a5
    3b2e:	d7a1                	beqz	a5,3a76 <concreate+0x1c8>
    3b30:	01671363          	bne	a4,s6,3b36 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    3b34:	f129                	bnez	a0,3a76 <concreate+0x1c8>
      unlink(file);
    3b36:	fa840513          	addi	a0,s0,-88
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	d44080e7          	jalr	-700(ra) # 587e <unlink>
      unlink(file);
    3b42:	fa840513          	addi	a0,s0,-88
    3b46:	00002097          	auipc	ra,0x2
    3b4a:	d38080e7          	jalr	-712(ra) # 587e <unlink>
      unlink(file);
    3b4e:	fa840513          	addi	a0,s0,-88
    3b52:	00002097          	auipc	ra,0x2
    3b56:	d2c080e7          	jalr	-724(ra) # 587e <unlink>
      unlink(file);
    3b5a:	fa840513          	addi	a0,s0,-88
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	d20080e7          	jalr	-736(ra) # 587e <unlink>
      unlink(file);
    3b66:	fa840513          	addi	a0,s0,-88
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	d14080e7          	jalr	-748(ra) # 587e <unlink>
      unlink(file);
    3b72:	fa840513          	addi	a0,s0,-88
    3b76:	00002097          	auipc	ra,0x2
    3b7a:	d08080e7          	jalr	-760(ra) # 587e <unlink>
    3b7e:	bfb5                	j	3afa <concreate+0x24c>
      exit(0);
    3b80:	4501                	li	a0,0
    3b82:	00002097          	auipc	ra,0x2
    3b86:	cac080e7          	jalr	-852(ra) # 582e <exit>
      close(fd);
    3b8a:	00002097          	auipc	ra,0x2
    3b8e:	ccc080e7          	jalr	-820(ra) # 5856 <close>
    if(pid == 0) {
    3b92:	bb5d                	j	3948 <concreate+0x9a>
      close(fd);
    3b94:	00002097          	auipc	ra,0x2
    3b98:	cc2080e7          	jalr	-830(ra) # 5856 <close>
      wait(&xstatus);
    3b9c:	f6c40513          	addi	a0,s0,-148
    3ba0:	00002097          	auipc	ra,0x2
    3ba4:	c96080e7          	jalr	-874(ra) # 5836 <wait>
      if(xstatus != 0)
    3ba8:	f6c42483          	lw	s1,-148(s0)
    3bac:	da0493e3          	bnez	s1,3952 <concreate+0xa4>
  for(i = 0; i < N; i++){
    3bb0:	2905                	addiw	s2,s2,1
    3bb2:	db4905e3          	beq	s2,s4,395c <concreate+0xae>
    file[1] = '0' + i;
    3bb6:	0309079b          	addiw	a5,s2,48
    3bba:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    3bbe:	fa840513          	addi	a0,s0,-88
    3bc2:	00002097          	auipc	ra,0x2
    3bc6:	cbc080e7          	jalr	-836(ra) # 587e <unlink>
    pid = fork();
    3bca:	00002097          	auipc	ra,0x2
    3bce:	c5c080e7          	jalr	-932(ra) # 5826 <fork>
    if(pid && (i % 3) == 1){
    3bd2:	d20502e3          	beqz	a0,38f6 <concreate+0x48>
    3bd6:	036967bb          	remw	a5,s2,s6
    3bda:	d15786e3          	beq	a5,s5,38e6 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    3bde:	20200593          	li	a1,514
    3be2:	fa840513          	addi	a0,s0,-88
    3be6:	00002097          	auipc	ra,0x2
    3bea:	c88080e7          	jalr	-888(ra) # 586e <open>
      if(fd < 0){
    3bee:	fa0553e3          	bgez	a0,3b94 <concreate+0x2e6>
    3bf2:	b315                	j	3916 <concreate+0x68>
}
    3bf4:	60ea                	ld	ra,152(sp)
    3bf6:	644a                	ld	s0,144(sp)
    3bf8:	64aa                	ld	s1,136(sp)
    3bfa:	690a                	ld	s2,128(sp)
    3bfc:	79e6                	ld	s3,120(sp)
    3bfe:	7a46                	ld	s4,112(sp)
    3c00:	7aa6                	ld	s5,104(sp)
    3c02:	7b06                	ld	s6,96(sp)
    3c04:	6be6                	ld	s7,88(sp)
    3c06:	610d                	addi	sp,sp,160
    3c08:	8082                	ret

0000000000003c0a <linkunlink>:
{
    3c0a:	711d                	addi	sp,sp,-96
    3c0c:	ec86                	sd	ra,88(sp)
    3c0e:	e8a2                	sd	s0,80(sp)
    3c10:	e4a6                	sd	s1,72(sp)
    3c12:	e0ca                	sd	s2,64(sp)
    3c14:	fc4e                	sd	s3,56(sp)
    3c16:	f852                	sd	s4,48(sp)
    3c18:	f456                	sd	s5,40(sp)
    3c1a:	f05a                	sd	s6,32(sp)
    3c1c:	ec5e                	sd	s7,24(sp)
    3c1e:	e862                	sd	s8,16(sp)
    3c20:	e466                	sd	s9,8(sp)
    3c22:	1080                	addi	s0,sp,96
    3c24:	84aa                	mv	s1,a0
  unlink("x");
    3c26:	00003517          	auipc	a0,0x3
    3c2a:	ab250513          	addi	a0,a0,-1358 # 66d8 <malloc+0xa68>
    3c2e:	00002097          	auipc	ra,0x2
    3c32:	c50080e7          	jalr	-944(ra) # 587e <unlink>
  pid = fork();
    3c36:	00002097          	auipc	ra,0x2
    3c3a:	bf0080e7          	jalr	-1040(ra) # 5826 <fork>
  if(pid < 0){
    3c3e:	02054b63          	bltz	a0,3c74 <linkunlink+0x6a>
    3c42:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    3c44:	4c85                	li	s9,1
    3c46:	e119                	bnez	a0,3c4c <linkunlink+0x42>
    3c48:	06100c93          	li	s9,97
    3c4c:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    3c50:	41c659b7          	lui	s3,0x41c65
    3c54:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <__BSS_END__+0x41c5648d>
    3c58:	690d                	lui	s2,0x3
    3c5a:	0399091b          	addiw	s2,s2,57 # 3039 <sharedfd+0x1ad>
    if((x % 3) == 0){
    3c5e:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    3c60:	4b05                	li	s6,1
      unlink("x");
    3c62:	00003a97          	auipc	s5,0x3
    3c66:	a76a8a93          	addi	s5,s5,-1418 # 66d8 <malloc+0xa68>
      link("cat", "x");
    3c6a:	00003b97          	auipc	s7,0x3
    3c6e:	66eb8b93          	addi	s7,s7,1646 # 72d8 <malloc+0x1668>
    3c72:	a825                	j	3caa <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    3c74:	85a6                	mv	a1,s1
    3c76:	00002517          	auipc	a0,0x2
    3c7a:	43250513          	addi	a0,a0,1074 # 60a8 <malloc+0x438>
    3c7e:	00002097          	auipc	ra,0x2
    3c82:	f3a080e7          	jalr	-198(ra) # 5bb8 <printf>
    exit(1);
    3c86:	4505                	li	a0,1
    3c88:	00002097          	auipc	ra,0x2
    3c8c:	ba6080e7          	jalr	-1114(ra) # 582e <exit>
      close(open("x", O_RDWR | O_CREATE));
    3c90:	20200593          	li	a1,514
    3c94:	8556                	mv	a0,s5
    3c96:	00002097          	auipc	ra,0x2
    3c9a:	bd8080e7          	jalr	-1064(ra) # 586e <open>
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	bb8080e7          	jalr	-1096(ra) # 5856 <close>
  for(i = 0; i < 100; i++){
    3ca6:	34fd                	addiw	s1,s1,-1
    3ca8:	c88d                	beqz	s1,3cda <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    3caa:	033c87bb          	mulw	a5,s9,s3
    3cae:	012787bb          	addw	a5,a5,s2
    3cb2:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    3cb6:	0347f7bb          	remuw	a5,a5,s4
    3cba:	dbf9                	beqz	a5,3c90 <linkunlink+0x86>
    } else if((x % 3) == 1){
    3cbc:	01678863          	beq	a5,s6,3ccc <linkunlink+0xc2>
      unlink("x");
    3cc0:	8556                	mv	a0,s5
    3cc2:	00002097          	auipc	ra,0x2
    3cc6:	bbc080e7          	jalr	-1092(ra) # 587e <unlink>
    3cca:	bff1                	j	3ca6 <linkunlink+0x9c>
      link("cat", "x");
    3ccc:	85d6                	mv	a1,s5
    3cce:	855e                	mv	a0,s7
    3cd0:	00002097          	auipc	ra,0x2
    3cd4:	bbe080e7          	jalr	-1090(ra) # 588e <link>
    3cd8:	b7f9                	j	3ca6 <linkunlink+0x9c>
  if(pid)
    3cda:	020c0463          	beqz	s8,3d02 <linkunlink+0xf8>
    wait(0);
    3cde:	4501                	li	a0,0
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	b56080e7          	jalr	-1194(ra) # 5836 <wait>
}
    3ce8:	60e6                	ld	ra,88(sp)
    3cea:	6446                	ld	s0,80(sp)
    3cec:	64a6                	ld	s1,72(sp)
    3cee:	6906                	ld	s2,64(sp)
    3cf0:	79e2                	ld	s3,56(sp)
    3cf2:	7a42                	ld	s4,48(sp)
    3cf4:	7aa2                	ld	s5,40(sp)
    3cf6:	7b02                	ld	s6,32(sp)
    3cf8:	6be2                	ld	s7,24(sp)
    3cfa:	6c42                	ld	s8,16(sp)
    3cfc:	6ca2                	ld	s9,8(sp)
    3cfe:	6125                	addi	sp,sp,96
    3d00:	8082                	ret
    exit(0);
    3d02:	4501                	li	a0,0
    3d04:	00002097          	auipc	ra,0x2
    3d08:	b2a080e7          	jalr	-1238(ra) # 582e <exit>

0000000000003d0c <subdir>:
{
    3d0c:	1101                	addi	sp,sp,-32
    3d0e:	ec06                	sd	ra,24(sp)
    3d10:	e822                	sd	s0,16(sp)
    3d12:	e426                	sd	s1,8(sp)
    3d14:	e04a                	sd	s2,0(sp)
    3d16:	1000                	addi	s0,sp,32
    3d18:	892a                	mv	s2,a0
  unlink("ff");
    3d1a:	00003517          	auipc	a0,0x3
    3d1e:	6f650513          	addi	a0,a0,1782 # 7410 <malloc+0x17a0>
    3d22:	00002097          	auipc	ra,0x2
    3d26:	b5c080e7          	jalr	-1188(ra) # 587e <unlink>
  if(mkdir("dd") != 0){
    3d2a:	00003517          	auipc	a0,0x3
    3d2e:	5b650513          	addi	a0,a0,1462 # 72e0 <malloc+0x1670>
    3d32:	00002097          	auipc	ra,0x2
    3d36:	b64080e7          	jalr	-1180(ra) # 5896 <mkdir>
    3d3a:	38051663          	bnez	a0,40c6 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3d3e:	20200593          	li	a1,514
    3d42:	00003517          	auipc	a0,0x3
    3d46:	5be50513          	addi	a0,a0,1470 # 7300 <malloc+0x1690>
    3d4a:	00002097          	auipc	ra,0x2
    3d4e:	b24080e7          	jalr	-1244(ra) # 586e <open>
    3d52:	84aa                	mv	s1,a0
  if(fd < 0){
    3d54:	38054763          	bltz	a0,40e2 <subdir+0x3d6>
  write(fd, "ff", 2);
    3d58:	4609                	li	a2,2
    3d5a:	00003597          	auipc	a1,0x3
    3d5e:	6b658593          	addi	a1,a1,1718 # 7410 <malloc+0x17a0>
    3d62:	00002097          	auipc	ra,0x2
    3d66:	aec080e7          	jalr	-1300(ra) # 584e <write>
  close(fd);
    3d6a:	8526                	mv	a0,s1
    3d6c:	00002097          	auipc	ra,0x2
    3d70:	aea080e7          	jalr	-1302(ra) # 5856 <close>
  if(unlink("dd") >= 0){
    3d74:	00003517          	auipc	a0,0x3
    3d78:	56c50513          	addi	a0,a0,1388 # 72e0 <malloc+0x1670>
    3d7c:	00002097          	auipc	ra,0x2
    3d80:	b02080e7          	jalr	-1278(ra) # 587e <unlink>
    3d84:	36055d63          	bgez	a0,40fe <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3d88:	00003517          	auipc	a0,0x3
    3d8c:	5d050513          	addi	a0,a0,1488 # 7358 <malloc+0x16e8>
    3d90:	00002097          	auipc	ra,0x2
    3d94:	b06080e7          	jalr	-1274(ra) # 5896 <mkdir>
    3d98:	38051163          	bnez	a0,411a <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3d9c:	20200593          	li	a1,514
    3da0:	00003517          	auipc	a0,0x3
    3da4:	5e050513          	addi	a0,a0,1504 # 7380 <malloc+0x1710>
    3da8:	00002097          	auipc	ra,0x2
    3dac:	ac6080e7          	jalr	-1338(ra) # 586e <open>
    3db0:	84aa                	mv	s1,a0
  if(fd < 0){
    3db2:	38054263          	bltz	a0,4136 <subdir+0x42a>
  write(fd, "FF", 2);
    3db6:	4609                	li	a2,2
    3db8:	00003597          	auipc	a1,0x3
    3dbc:	5f858593          	addi	a1,a1,1528 # 73b0 <malloc+0x1740>
    3dc0:	00002097          	auipc	ra,0x2
    3dc4:	a8e080e7          	jalr	-1394(ra) # 584e <write>
  close(fd);
    3dc8:	8526                	mv	a0,s1
    3dca:	00002097          	auipc	ra,0x2
    3dce:	a8c080e7          	jalr	-1396(ra) # 5856 <close>
  fd = open("dd/dd/../ff", 0);
    3dd2:	4581                	li	a1,0
    3dd4:	00003517          	auipc	a0,0x3
    3dd8:	5e450513          	addi	a0,a0,1508 # 73b8 <malloc+0x1748>
    3ddc:	00002097          	auipc	ra,0x2
    3de0:	a92080e7          	jalr	-1390(ra) # 586e <open>
    3de4:	84aa                	mv	s1,a0
  if(fd < 0){
    3de6:	36054663          	bltz	a0,4152 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3dea:	660d                	lui	a2,0x3
    3dec:	00008597          	auipc	a1,0x8
    3df0:	be458593          	addi	a1,a1,-1052 # b9d0 <buf>
    3df4:	00002097          	auipc	ra,0x2
    3df8:	a52080e7          	jalr	-1454(ra) # 5846 <read>
  if(cc != 2 || buf[0] != 'f'){
    3dfc:	4789                	li	a5,2
    3dfe:	36f51863          	bne	a0,a5,416e <subdir+0x462>
    3e02:	00008717          	auipc	a4,0x8
    3e06:	bce74703          	lbu	a4,-1074(a4) # b9d0 <buf>
    3e0a:	06600793          	li	a5,102
    3e0e:	36f71063          	bne	a4,a5,416e <subdir+0x462>
  close(fd);
    3e12:	8526                	mv	a0,s1
    3e14:	00002097          	auipc	ra,0x2
    3e18:	a42080e7          	jalr	-1470(ra) # 5856 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3e1c:	00003597          	auipc	a1,0x3
    3e20:	5ec58593          	addi	a1,a1,1516 # 7408 <malloc+0x1798>
    3e24:	00003517          	auipc	a0,0x3
    3e28:	55c50513          	addi	a0,a0,1372 # 7380 <malloc+0x1710>
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	a62080e7          	jalr	-1438(ra) # 588e <link>
    3e34:	34051b63          	bnez	a0,418a <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3e38:	00003517          	auipc	a0,0x3
    3e3c:	54850513          	addi	a0,a0,1352 # 7380 <malloc+0x1710>
    3e40:	00002097          	auipc	ra,0x2
    3e44:	a3e080e7          	jalr	-1474(ra) # 587e <unlink>
    3e48:	34051f63          	bnez	a0,41a6 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3e4c:	4581                	li	a1,0
    3e4e:	00003517          	auipc	a0,0x3
    3e52:	53250513          	addi	a0,a0,1330 # 7380 <malloc+0x1710>
    3e56:	00002097          	auipc	ra,0x2
    3e5a:	a18080e7          	jalr	-1512(ra) # 586e <open>
    3e5e:	36055263          	bgez	a0,41c2 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3e62:	00003517          	auipc	a0,0x3
    3e66:	47e50513          	addi	a0,a0,1150 # 72e0 <malloc+0x1670>
    3e6a:	00002097          	auipc	ra,0x2
    3e6e:	a34080e7          	jalr	-1484(ra) # 589e <chdir>
    3e72:	36051663          	bnez	a0,41de <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3e76:	00003517          	auipc	a0,0x3
    3e7a:	62a50513          	addi	a0,a0,1578 # 74a0 <malloc+0x1830>
    3e7e:	00002097          	auipc	ra,0x2
    3e82:	a20080e7          	jalr	-1504(ra) # 589e <chdir>
    3e86:	36051a63          	bnez	a0,41fa <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3e8a:	00003517          	auipc	a0,0x3
    3e8e:	64650513          	addi	a0,a0,1606 # 74d0 <malloc+0x1860>
    3e92:	00002097          	auipc	ra,0x2
    3e96:	a0c080e7          	jalr	-1524(ra) # 589e <chdir>
    3e9a:	36051e63          	bnez	a0,4216 <subdir+0x50a>
  if(chdir("./..") != 0){
    3e9e:	00003517          	auipc	a0,0x3
    3ea2:	66250513          	addi	a0,a0,1634 # 7500 <malloc+0x1890>
    3ea6:	00002097          	auipc	ra,0x2
    3eaa:	9f8080e7          	jalr	-1544(ra) # 589e <chdir>
    3eae:	38051263          	bnez	a0,4232 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3eb2:	4581                	li	a1,0
    3eb4:	00003517          	auipc	a0,0x3
    3eb8:	55450513          	addi	a0,a0,1364 # 7408 <malloc+0x1798>
    3ebc:	00002097          	auipc	ra,0x2
    3ec0:	9b2080e7          	jalr	-1614(ra) # 586e <open>
    3ec4:	84aa                	mv	s1,a0
  if(fd < 0){
    3ec6:	38054463          	bltz	a0,424e <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3eca:	660d                	lui	a2,0x3
    3ecc:	00008597          	auipc	a1,0x8
    3ed0:	b0458593          	addi	a1,a1,-1276 # b9d0 <buf>
    3ed4:	00002097          	auipc	ra,0x2
    3ed8:	972080e7          	jalr	-1678(ra) # 5846 <read>
    3edc:	4789                	li	a5,2
    3ede:	38f51663          	bne	a0,a5,426a <subdir+0x55e>
  close(fd);
    3ee2:	8526                	mv	a0,s1
    3ee4:	00002097          	auipc	ra,0x2
    3ee8:	972080e7          	jalr	-1678(ra) # 5856 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3eec:	4581                	li	a1,0
    3eee:	00003517          	auipc	a0,0x3
    3ef2:	49250513          	addi	a0,a0,1170 # 7380 <malloc+0x1710>
    3ef6:	00002097          	auipc	ra,0x2
    3efa:	978080e7          	jalr	-1672(ra) # 586e <open>
    3efe:	38055463          	bgez	a0,4286 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3f02:	20200593          	li	a1,514
    3f06:	00003517          	auipc	a0,0x3
    3f0a:	68a50513          	addi	a0,a0,1674 # 7590 <malloc+0x1920>
    3f0e:	00002097          	auipc	ra,0x2
    3f12:	960080e7          	jalr	-1696(ra) # 586e <open>
    3f16:	38055663          	bgez	a0,42a2 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3f1a:	20200593          	li	a1,514
    3f1e:	00003517          	auipc	a0,0x3
    3f22:	6a250513          	addi	a0,a0,1698 # 75c0 <malloc+0x1950>
    3f26:	00002097          	auipc	ra,0x2
    3f2a:	948080e7          	jalr	-1720(ra) # 586e <open>
    3f2e:	38055863          	bgez	a0,42be <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3f32:	20000593          	li	a1,512
    3f36:	00003517          	auipc	a0,0x3
    3f3a:	3aa50513          	addi	a0,a0,938 # 72e0 <malloc+0x1670>
    3f3e:	00002097          	auipc	ra,0x2
    3f42:	930080e7          	jalr	-1744(ra) # 586e <open>
    3f46:	38055a63          	bgez	a0,42da <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3f4a:	4589                	li	a1,2
    3f4c:	00003517          	auipc	a0,0x3
    3f50:	39450513          	addi	a0,a0,916 # 72e0 <malloc+0x1670>
    3f54:	00002097          	auipc	ra,0x2
    3f58:	91a080e7          	jalr	-1766(ra) # 586e <open>
    3f5c:	38055d63          	bgez	a0,42f6 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3f60:	4585                	li	a1,1
    3f62:	00003517          	auipc	a0,0x3
    3f66:	37e50513          	addi	a0,a0,894 # 72e0 <malloc+0x1670>
    3f6a:	00002097          	auipc	ra,0x2
    3f6e:	904080e7          	jalr	-1788(ra) # 586e <open>
    3f72:	3a055063          	bgez	a0,4312 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3f76:	00003597          	auipc	a1,0x3
    3f7a:	6da58593          	addi	a1,a1,1754 # 7650 <malloc+0x19e0>
    3f7e:	00003517          	auipc	a0,0x3
    3f82:	61250513          	addi	a0,a0,1554 # 7590 <malloc+0x1920>
    3f86:	00002097          	auipc	ra,0x2
    3f8a:	908080e7          	jalr	-1784(ra) # 588e <link>
    3f8e:	3a050063          	beqz	a0,432e <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3f92:	00003597          	auipc	a1,0x3
    3f96:	6be58593          	addi	a1,a1,1726 # 7650 <malloc+0x19e0>
    3f9a:	00003517          	auipc	a0,0x3
    3f9e:	62650513          	addi	a0,a0,1574 # 75c0 <malloc+0x1950>
    3fa2:	00002097          	auipc	ra,0x2
    3fa6:	8ec080e7          	jalr	-1812(ra) # 588e <link>
    3faa:	3a050063          	beqz	a0,434a <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3fae:	00003597          	auipc	a1,0x3
    3fb2:	45a58593          	addi	a1,a1,1114 # 7408 <malloc+0x1798>
    3fb6:	00003517          	auipc	a0,0x3
    3fba:	34a50513          	addi	a0,a0,842 # 7300 <malloc+0x1690>
    3fbe:	00002097          	auipc	ra,0x2
    3fc2:	8d0080e7          	jalr	-1840(ra) # 588e <link>
    3fc6:	3a050063          	beqz	a0,4366 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3fca:	00003517          	auipc	a0,0x3
    3fce:	5c650513          	addi	a0,a0,1478 # 7590 <malloc+0x1920>
    3fd2:	00002097          	auipc	ra,0x2
    3fd6:	8c4080e7          	jalr	-1852(ra) # 5896 <mkdir>
    3fda:	3a050463          	beqz	a0,4382 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3fde:	00003517          	auipc	a0,0x3
    3fe2:	5e250513          	addi	a0,a0,1506 # 75c0 <malloc+0x1950>
    3fe6:	00002097          	auipc	ra,0x2
    3fea:	8b0080e7          	jalr	-1872(ra) # 5896 <mkdir>
    3fee:	3a050863          	beqz	a0,439e <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3ff2:	00003517          	auipc	a0,0x3
    3ff6:	41650513          	addi	a0,a0,1046 # 7408 <malloc+0x1798>
    3ffa:	00002097          	auipc	ra,0x2
    3ffe:	89c080e7          	jalr	-1892(ra) # 5896 <mkdir>
    4002:	3a050c63          	beqz	a0,43ba <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    4006:	00003517          	auipc	a0,0x3
    400a:	5ba50513          	addi	a0,a0,1466 # 75c0 <malloc+0x1950>
    400e:	00002097          	auipc	ra,0x2
    4012:	870080e7          	jalr	-1936(ra) # 587e <unlink>
    4016:	3c050063          	beqz	a0,43d6 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    401a:	00003517          	auipc	a0,0x3
    401e:	57650513          	addi	a0,a0,1398 # 7590 <malloc+0x1920>
    4022:	00002097          	auipc	ra,0x2
    4026:	85c080e7          	jalr	-1956(ra) # 587e <unlink>
    402a:	3c050463          	beqz	a0,43f2 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    402e:	00003517          	auipc	a0,0x3
    4032:	2d250513          	addi	a0,a0,722 # 7300 <malloc+0x1690>
    4036:	00002097          	auipc	ra,0x2
    403a:	868080e7          	jalr	-1944(ra) # 589e <chdir>
    403e:	3c050863          	beqz	a0,440e <subdir+0x702>
  if(chdir("dd/xx") == 0){
    4042:	00003517          	auipc	a0,0x3
    4046:	75e50513          	addi	a0,a0,1886 # 77a0 <malloc+0x1b30>
    404a:	00002097          	auipc	ra,0x2
    404e:	854080e7          	jalr	-1964(ra) # 589e <chdir>
    4052:	3c050c63          	beqz	a0,442a <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    4056:	00003517          	auipc	a0,0x3
    405a:	3b250513          	addi	a0,a0,946 # 7408 <malloc+0x1798>
    405e:	00002097          	auipc	ra,0x2
    4062:	820080e7          	jalr	-2016(ra) # 587e <unlink>
    4066:	3e051063          	bnez	a0,4446 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    406a:	00003517          	auipc	a0,0x3
    406e:	29650513          	addi	a0,a0,662 # 7300 <malloc+0x1690>
    4072:	00002097          	auipc	ra,0x2
    4076:	80c080e7          	jalr	-2036(ra) # 587e <unlink>
    407a:	3e051463          	bnez	a0,4462 <subdir+0x756>
  if(unlink("dd") == 0){
    407e:	00003517          	auipc	a0,0x3
    4082:	26250513          	addi	a0,a0,610 # 72e0 <malloc+0x1670>
    4086:	00001097          	auipc	ra,0x1
    408a:	7f8080e7          	jalr	2040(ra) # 587e <unlink>
    408e:	3e050863          	beqz	a0,447e <subdir+0x772>
  if(unlink("dd/dd") < 0){
    4092:	00003517          	auipc	a0,0x3
    4096:	77e50513          	addi	a0,a0,1918 # 7810 <malloc+0x1ba0>
    409a:	00001097          	auipc	ra,0x1
    409e:	7e4080e7          	jalr	2020(ra) # 587e <unlink>
    40a2:	3e054c63          	bltz	a0,449a <subdir+0x78e>
  if(unlink("dd") < 0){
    40a6:	00003517          	auipc	a0,0x3
    40aa:	23a50513          	addi	a0,a0,570 # 72e0 <malloc+0x1670>
    40ae:	00001097          	auipc	ra,0x1
    40b2:	7d0080e7          	jalr	2000(ra) # 587e <unlink>
    40b6:	40054063          	bltz	a0,44b6 <subdir+0x7aa>
}
    40ba:	60e2                	ld	ra,24(sp)
    40bc:	6442                	ld	s0,16(sp)
    40be:	64a2                	ld	s1,8(sp)
    40c0:	6902                	ld	s2,0(sp)
    40c2:	6105                	addi	sp,sp,32
    40c4:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    40c6:	85ca                	mv	a1,s2
    40c8:	00003517          	auipc	a0,0x3
    40cc:	22050513          	addi	a0,a0,544 # 72e8 <malloc+0x1678>
    40d0:	00002097          	auipc	ra,0x2
    40d4:	ae8080e7          	jalr	-1304(ra) # 5bb8 <printf>
    exit(1);
    40d8:	4505                	li	a0,1
    40da:	00001097          	auipc	ra,0x1
    40de:	754080e7          	jalr	1876(ra) # 582e <exit>
    printf("%s: create dd/ff failed\n", s);
    40e2:	85ca                	mv	a1,s2
    40e4:	00003517          	auipc	a0,0x3
    40e8:	22450513          	addi	a0,a0,548 # 7308 <malloc+0x1698>
    40ec:	00002097          	auipc	ra,0x2
    40f0:	acc080e7          	jalr	-1332(ra) # 5bb8 <printf>
    exit(1);
    40f4:	4505                	li	a0,1
    40f6:	00001097          	auipc	ra,0x1
    40fa:	738080e7          	jalr	1848(ra) # 582e <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    40fe:	85ca                	mv	a1,s2
    4100:	00003517          	auipc	a0,0x3
    4104:	22850513          	addi	a0,a0,552 # 7328 <malloc+0x16b8>
    4108:	00002097          	auipc	ra,0x2
    410c:	ab0080e7          	jalr	-1360(ra) # 5bb8 <printf>
    exit(1);
    4110:	4505                	li	a0,1
    4112:	00001097          	auipc	ra,0x1
    4116:	71c080e7          	jalr	1820(ra) # 582e <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    411a:	85ca                	mv	a1,s2
    411c:	00003517          	auipc	a0,0x3
    4120:	24450513          	addi	a0,a0,580 # 7360 <malloc+0x16f0>
    4124:	00002097          	auipc	ra,0x2
    4128:	a94080e7          	jalr	-1388(ra) # 5bb8 <printf>
    exit(1);
    412c:	4505                	li	a0,1
    412e:	00001097          	auipc	ra,0x1
    4132:	700080e7          	jalr	1792(ra) # 582e <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    4136:	85ca                	mv	a1,s2
    4138:	00003517          	auipc	a0,0x3
    413c:	25850513          	addi	a0,a0,600 # 7390 <malloc+0x1720>
    4140:	00002097          	auipc	ra,0x2
    4144:	a78080e7          	jalr	-1416(ra) # 5bb8 <printf>
    exit(1);
    4148:	4505                	li	a0,1
    414a:	00001097          	auipc	ra,0x1
    414e:	6e4080e7          	jalr	1764(ra) # 582e <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    4152:	85ca                	mv	a1,s2
    4154:	00003517          	auipc	a0,0x3
    4158:	27450513          	addi	a0,a0,628 # 73c8 <malloc+0x1758>
    415c:	00002097          	auipc	ra,0x2
    4160:	a5c080e7          	jalr	-1444(ra) # 5bb8 <printf>
    exit(1);
    4164:	4505                	li	a0,1
    4166:	00001097          	auipc	ra,0x1
    416a:	6c8080e7          	jalr	1736(ra) # 582e <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    416e:	85ca                	mv	a1,s2
    4170:	00003517          	auipc	a0,0x3
    4174:	27850513          	addi	a0,a0,632 # 73e8 <malloc+0x1778>
    4178:	00002097          	auipc	ra,0x2
    417c:	a40080e7          	jalr	-1472(ra) # 5bb8 <printf>
    exit(1);
    4180:	4505                	li	a0,1
    4182:	00001097          	auipc	ra,0x1
    4186:	6ac080e7          	jalr	1708(ra) # 582e <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    418a:	85ca                	mv	a1,s2
    418c:	00003517          	auipc	a0,0x3
    4190:	28c50513          	addi	a0,a0,652 # 7418 <malloc+0x17a8>
    4194:	00002097          	auipc	ra,0x2
    4198:	a24080e7          	jalr	-1500(ra) # 5bb8 <printf>
    exit(1);
    419c:	4505                	li	a0,1
    419e:	00001097          	auipc	ra,0x1
    41a2:	690080e7          	jalr	1680(ra) # 582e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    41a6:	85ca                	mv	a1,s2
    41a8:	00003517          	auipc	a0,0x3
    41ac:	29850513          	addi	a0,a0,664 # 7440 <malloc+0x17d0>
    41b0:	00002097          	auipc	ra,0x2
    41b4:	a08080e7          	jalr	-1528(ra) # 5bb8 <printf>
    exit(1);
    41b8:	4505                	li	a0,1
    41ba:	00001097          	auipc	ra,0x1
    41be:	674080e7          	jalr	1652(ra) # 582e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    41c2:	85ca                	mv	a1,s2
    41c4:	00003517          	auipc	a0,0x3
    41c8:	29c50513          	addi	a0,a0,668 # 7460 <malloc+0x17f0>
    41cc:	00002097          	auipc	ra,0x2
    41d0:	9ec080e7          	jalr	-1556(ra) # 5bb8 <printf>
    exit(1);
    41d4:	4505                	li	a0,1
    41d6:	00001097          	auipc	ra,0x1
    41da:	658080e7          	jalr	1624(ra) # 582e <exit>
    printf("%s: chdir dd failed\n", s);
    41de:	85ca                	mv	a1,s2
    41e0:	00003517          	auipc	a0,0x3
    41e4:	2a850513          	addi	a0,a0,680 # 7488 <malloc+0x1818>
    41e8:	00002097          	auipc	ra,0x2
    41ec:	9d0080e7          	jalr	-1584(ra) # 5bb8 <printf>
    exit(1);
    41f0:	4505                	li	a0,1
    41f2:	00001097          	auipc	ra,0x1
    41f6:	63c080e7          	jalr	1596(ra) # 582e <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    41fa:	85ca                	mv	a1,s2
    41fc:	00003517          	auipc	a0,0x3
    4200:	2b450513          	addi	a0,a0,692 # 74b0 <malloc+0x1840>
    4204:	00002097          	auipc	ra,0x2
    4208:	9b4080e7          	jalr	-1612(ra) # 5bb8 <printf>
    exit(1);
    420c:	4505                	li	a0,1
    420e:	00001097          	auipc	ra,0x1
    4212:	620080e7          	jalr	1568(ra) # 582e <exit>
    printf("chdir dd/../../dd failed\n", s);
    4216:	85ca                	mv	a1,s2
    4218:	00003517          	auipc	a0,0x3
    421c:	2c850513          	addi	a0,a0,712 # 74e0 <malloc+0x1870>
    4220:	00002097          	auipc	ra,0x2
    4224:	998080e7          	jalr	-1640(ra) # 5bb8 <printf>
    exit(1);
    4228:	4505                	li	a0,1
    422a:	00001097          	auipc	ra,0x1
    422e:	604080e7          	jalr	1540(ra) # 582e <exit>
    printf("%s: chdir ./.. failed\n", s);
    4232:	85ca                	mv	a1,s2
    4234:	00003517          	auipc	a0,0x3
    4238:	2d450513          	addi	a0,a0,724 # 7508 <malloc+0x1898>
    423c:	00002097          	auipc	ra,0x2
    4240:	97c080e7          	jalr	-1668(ra) # 5bb8 <printf>
    exit(1);
    4244:	4505                	li	a0,1
    4246:	00001097          	auipc	ra,0x1
    424a:	5e8080e7          	jalr	1512(ra) # 582e <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    424e:	85ca                	mv	a1,s2
    4250:	00003517          	auipc	a0,0x3
    4254:	2d050513          	addi	a0,a0,720 # 7520 <malloc+0x18b0>
    4258:	00002097          	auipc	ra,0x2
    425c:	960080e7          	jalr	-1696(ra) # 5bb8 <printf>
    exit(1);
    4260:	4505                	li	a0,1
    4262:	00001097          	auipc	ra,0x1
    4266:	5cc080e7          	jalr	1484(ra) # 582e <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    426a:	85ca                	mv	a1,s2
    426c:	00003517          	auipc	a0,0x3
    4270:	2d450513          	addi	a0,a0,724 # 7540 <malloc+0x18d0>
    4274:	00002097          	auipc	ra,0x2
    4278:	944080e7          	jalr	-1724(ra) # 5bb8 <printf>
    exit(1);
    427c:	4505                	li	a0,1
    427e:	00001097          	auipc	ra,0x1
    4282:	5b0080e7          	jalr	1456(ra) # 582e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    4286:	85ca                	mv	a1,s2
    4288:	00003517          	auipc	a0,0x3
    428c:	2d850513          	addi	a0,a0,728 # 7560 <malloc+0x18f0>
    4290:	00002097          	auipc	ra,0x2
    4294:	928080e7          	jalr	-1752(ra) # 5bb8 <printf>
    exit(1);
    4298:	4505                	li	a0,1
    429a:	00001097          	auipc	ra,0x1
    429e:	594080e7          	jalr	1428(ra) # 582e <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    42a2:	85ca                	mv	a1,s2
    42a4:	00003517          	auipc	a0,0x3
    42a8:	2fc50513          	addi	a0,a0,764 # 75a0 <malloc+0x1930>
    42ac:	00002097          	auipc	ra,0x2
    42b0:	90c080e7          	jalr	-1780(ra) # 5bb8 <printf>
    exit(1);
    42b4:	4505                	li	a0,1
    42b6:	00001097          	auipc	ra,0x1
    42ba:	578080e7          	jalr	1400(ra) # 582e <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    42be:	85ca                	mv	a1,s2
    42c0:	00003517          	auipc	a0,0x3
    42c4:	31050513          	addi	a0,a0,784 # 75d0 <malloc+0x1960>
    42c8:	00002097          	auipc	ra,0x2
    42cc:	8f0080e7          	jalr	-1808(ra) # 5bb8 <printf>
    exit(1);
    42d0:	4505                	li	a0,1
    42d2:	00001097          	auipc	ra,0x1
    42d6:	55c080e7          	jalr	1372(ra) # 582e <exit>
    printf("%s: create dd succeeded!\n", s);
    42da:	85ca                	mv	a1,s2
    42dc:	00003517          	auipc	a0,0x3
    42e0:	31450513          	addi	a0,a0,788 # 75f0 <malloc+0x1980>
    42e4:	00002097          	auipc	ra,0x2
    42e8:	8d4080e7          	jalr	-1836(ra) # 5bb8 <printf>
    exit(1);
    42ec:	4505                	li	a0,1
    42ee:	00001097          	auipc	ra,0x1
    42f2:	540080e7          	jalr	1344(ra) # 582e <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    42f6:	85ca                	mv	a1,s2
    42f8:	00003517          	auipc	a0,0x3
    42fc:	31850513          	addi	a0,a0,792 # 7610 <malloc+0x19a0>
    4300:	00002097          	auipc	ra,0x2
    4304:	8b8080e7          	jalr	-1864(ra) # 5bb8 <printf>
    exit(1);
    4308:	4505                	li	a0,1
    430a:	00001097          	auipc	ra,0x1
    430e:	524080e7          	jalr	1316(ra) # 582e <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    4312:	85ca                	mv	a1,s2
    4314:	00003517          	auipc	a0,0x3
    4318:	31c50513          	addi	a0,a0,796 # 7630 <malloc+0x19c0>
    431c:	00002097          	auipc	ra,0x2
    4320:	89c080e7          	jalr	-1892(ra) # 5bb8 <printf>
    exit(1);
    4324:	4505                	li	a0,1
    4326:	00001097          	auipc	ra,0x1
    432a:	508080e7          	jalr	1288(ra) # 582e <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    432e:	85ca                	mv	a1,s2
    4330:	00003517          	auipc	a0,0x3
    4334:	33050513          	addi	a0,a0,816 # 7660 <malloc+0x19f0>
    4338:	00002097          	auipc	ra,0x2
    433c:	880080e7          	jalr	-1920(ra) # 5bb8 <printf>
    exit(1);
    4340:	4505                	li	a0,1
    4342:	00001097          	auipc	ra,0x1
    4346:	4ec080e7          	jalr	1260(ra) # 582e <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    434a:	85ca                	mv	a1,s2
    434c:	00003517          	auipc	a0,0x3
    4350:	33c50513          	addi	a0,a0,828 # 7688 <malloc+0x1a18>
    4354:	00002097          	auipc	ra,0x2
    4358:	864080e7          	jalr	-1948(ra) # 5bb8 <printf>
    exit(1);
    435c:	4505                	li	a0,1
    435e:	00001097          	auipc	ra,0x1
    4362:	4d0080e7          	jalr	1232(ra) # 582e <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    4366:	85ca                	mv	a1,s2
    4368:	00003517          	auipc	a0,0x3
    436c:	34850513          	addi	a0,a0,840 # 76b0 <malloc+0x1a40>
    4370:	00002097          	auipc	ra,0x2
    4374:	848080e7          	jalr	-1976(ra) # 5bb8 <printf>
    exit(1);
    4378:	4505                	li	a0,1
    437a:	00001097          	auipc	ra,0x1
    437e:	4b4080e7          	jalr	1204(ra) # 582e <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    4382:	85ca                	mv	a1,s2
    4384:	00003517          	auipc	a0,0x3
    4388:	35450513          	addi	a0,a0,852 # 76d8 <malloc+0x1a68>
    438c:	00002097          	auipc	ra,0x2
    4390:	82c080e7          	jalr	-2004(ra) # 5bb8 <printf>
    exit(1);
    4394:	4505                	li	a0,1
    4396:	00001097          	auipc	ra,0x1
    439a:	498080e7          	jalr	1176(ra) # 582e <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    439e:	85ca                	mv	a1,s2
    43a0:	00003517          	auipc	a0,0x3
    43a4:	35850513          	addi	a0,a0,856 # 76f8 <malloc+0x1a88>
    43a8:	00002097          	auipc	ra,0x2
    43ac:	810080e7          	jalr	-2032(ra) # 5bb8 <printf>
    exit(1);
    43b0:	4505                	li	a0,1
    43b2:	00001097          	auipc	ra,0x1
    43b6:	47c080e7          	jalr	1148(ra) # 582e <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    43ba:	85ca                	mv	a1,s2
    43bc:	00003517          	auipc	a0,0x3
    43c0:	35c50513          	addi	a0,a0,860 # 7718 <malloc+0x1aa8>
    43c4:	00001097          	auipc	ra,0x1
    43c8:	7f4080e7          	jalr	2036(ra) # 5bb8 <printf>
    exit(1);
    43cc:	4505                	li	a0,1
    43ce:	00001097          	auipc	ra,0x1
    43d2:	460080e7          	jalr	1120(ra) # 582e <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    43d6:	85ca                	mv	a1,s2
    43d8:	00003517          	auipc	a0,0x3
    43dc:	36850513          	addi	a0,a0,872 # 7740 <malloc+0x1ad0>
    43e0:	00001097          	auipc	ra,0x1
    43e4:	7d8080e7          	jalr	2008(ra) # 5bb8 <printf>
    exit(1);
    43e8:	4505                	li	a0,1
    43ea:	00001097          	auipc	ra,0x1
    43ee:	444080e7          	jalr	1092(ra) # 582e <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    43f2:	85ca                	mv	a1,s2
    43f4:	00003517          	auipc	a0,0x3
    43f8:	36c50513          	addi	a0,a0,876 # 7760 <malloc+0x1af0>
    43fc:	00001097          	auipc	ra,0x1
    4400:	7bc080e7          	jalr	1980(ra) # 5bb8 <printf>
    exit(1);
    4404:	4505                	li	a0,1
    4406:	00001097          	auipc	ra,0x1
    440a:	428080e7          	jalr	1064(ra) # 582e <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    440e:	85ca                	mv	a1,s2
    4410:	00003517          	auipc	a0,0x3
    4414:	37050513          	addi	a0,a0,880 # 7780 <malloc+0x1b10>
    4418:	00001097          	auipc	ra,0x1
    441c:	7a0080e7          	jalr	1952(ra) # 5bb8 <printf>
    exit(1);
    4420:	4505                	li	a0,1
    4422:	00001097          	auipc	ra,0x1
    4426:	40c080e7          	jalr	1036(ra) # 582e <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    442a:	85ca                	mv	a1,s2
    442c:	00003517          	auipc	a0,0x3
    4430:	37c50513          	addi	a0,a0,892 # 77a8 <malloc+0x1b38>
    4434:	00001097          	auipc	ra,0x1
    4438:	784080e7          	jalr	1924(ra) # 5bb8 <printf>
    exit(1);
    443c:	4505                	li	a0,1
    443e:	00001097          	auipc	ra,0x1
    4442:	3f0080e7          	jalr	1008(ra) # 582e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    4446:	85ca                	mv	a1,s2
    4448:	00003517          	auipc	a0,0x3
    444c:	ff850513          	addi	a0,a0,-8 # 7440 <malloc+0x17d0>
    4450:	00001097          	auipc	ra,0x1
    4454:	768080e7          	jalr	1896(ra) # 5bb8 <printf>
    exit(1);
    4458:	4505                	li	a0,1
    445a:	00001097          	auipc	ra,0x1
    445e:	3d4080e7          	jalr	980(ra) # 582e <exit>
    printf("%s: unlink dd/ff failed\n", s);
    4462:	85ca                	mv	a1,s2
    4464:	00003517          	auipc	a0,0x3
    4468:	36450513          	addi	a0,a0,868 # 77c8 <malloc+0x1b58>
    446c:	00001097          	auipc	ra,0x1
    4470:	74c080e7          	jalr	1868(ra) # 5bb8 <printf>
    exit(1);
    4474:	4505                	li	a0,1
    4476:	00001097          	auipc	ra,0x1
    447a:	3b8080e7          	jalr	952(ra) # 582e <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    447e:	85ca                	mv	a1,s2
    4480:	00003517          	auipc	a0,0x3
    4484:	36850513          	addi	a0,a0,872 # 77e8 <malloc+0x1b78>
    4488:	00001097          	auipc	ra,0x1
    448c:	730080e7          	jalr	1840(ra) # 5bb8 <printf>
    exit(1);
    4490:	4505                	li	a0,1
    4492:	00001097          	auipc	ra,0x1
    4496:	39c080e7          	jalr	924(ra) # 582e <exit>
    printf("%s: unlink dd/dd failed\n", s);
    449a:	85ca                	mv	a1,s2
    449c:	00003517          	auipc	a0,0x3
    44a0:	37c50513          	addi	a0,a0,892 # 7818 <malloc+0x1ba8>
    44a4:	00001097          	auipc	ra,0x1
    44a8:	714080e7          	jalr	1812(ra) # 5bb8 <printf>
    exit(1);
    44ac:	4505                	li	a0,1
    44ae:	00001097          	auipc	ra,0x1
    44b2:	380080e7          	jalr	896(ra) # 582e <exit>
    printf("%s: unlink dd failed\n", s);
    44b6:	85ca                	mv	a1,s2
    44b8:	00003517          	auipc	a0,0x3
    44bc:	38050513          	addi	a0,a0,896 # 7838 <malloc+0x1bc8>
    44c0:	00001097          	auipc	ra,0x1
    44c4:	6f8080e7          	jalr	1784(ra) # 5bb8 <printf>
    exit(1);
    44c8:	4505                	li	a0,1
    44ca:	00001097          	auipc	ra,0x1
    44ce:	364080e7          	jalr	868(ra) # 582e <exit>

00000000000044d2 <bigwrite>:
{
    44d2:	715d                	addi	sp,sp,-80
    44d4:	e486                	sd	ra,72(sp)
    44d6:	e0a2                	sd	s0,64(sp)
    44d8:	fc26                	sd	s1,56(sp)
    44da:	f84a                	sd	s2,48(sp)
    44dc:	f44e                	sd	s3,40(sp)
    44de:	f052                	sd	s4,32(sp)
    44e0:	ec56                	sd	s5,24(sp)
    44e2:	e85a                	sd	s6,16(sp)
    44e4:	e45e                	sd	s7,8(sp)
    44e6:	0880                	addi	s0,sp,80
    44e8:	8baa                	mv	s7,a0
  unlink("bigwrite");
    44ea:	00003517          	auipc	a0,0x3
    44ee:	36650513          	addi	a0,a0,870 # 7850 <malloc+0x1be0>
    44f2:	00001097          	auipc	ra,0x1
    44f6:	38c080e7          	jalr	908(ra) # 587e <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    44fa:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
    44fe:	00003a97          	auipc	s5,0x3
    4502:	352a8a93          	addi	s5,s5,850 # 7850 <malloc+0x1be0>
      int cc = write(fd, buf, sz);
    4506:	00007a17          	auipc	s4,0x7
    450a:	4caa0a13          	addi	s4,s4,1226 # b9d0 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    450e:	6b0d                	lui	s6,0x3
    4510:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourfiles+0x185>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    4514:	20200593          	li	a1,514
    4518:	8556                	mv	a0,s5
    451a:	00001097          	auipc	ra,0x1
    451e:	354080e7          	jalr	852(ra) # 586e <open>
    4522:	892a                	mv	s2,a0
    if(fd < 0){
    4524:	04054d63          	bltz	a0,457e <bigwrite+0xac>
      int cc = write(fd, buf, sz);
    4528:	8626                	mv	a2,s1
    452a:	85d2                	mv	a1,s4
    452c:	00001097          	auipc	ra,0x1
    4530:	322080e7          	jalr	802(ra) # 584e <write>
    4534:	89aa                	mv	s3,a0
      if(cc != sz){
    4536:	06a49263          	bne	s1,a0,459a <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
    453a:	8626                	mv	a2,s1
    453c:	85d2                	mv	a1,s4
    453e:	854a                	mv	a0,s2
    4540:	00001097          	auipc	ra,0x1
    4544:	30e080e7          	jalr	782(ra) # 584e <write>
      if(cc != sz){
    4548:	04951a63          	bne	a0,s1,459c <bigwrite+0xca>
    close(fd);
    454c:	854a                	mv	a0,s2
    454e:	00001097          	auipc	ra,0x1
    4552:	308080e7          	jalr	776(ra) # 5856 <close>
    unlink("bigwrite");
    4556:	8556                	mv	a0,s5
    4558:	00001097          	auipc	ra,0x1
    455c:	326080e7          	jalr	806(ra) # 587e <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    4560:	1d74849b          	addiw	s1,s1,471
    4564:	fb6498e3          	bne	s1,s6,4514 <bigwrite+0x42>
}
    4568:	60a6                	ld	ra,72(sp)
    456a:	6406                	ld	s0,64(sp)
    456c:	74e2                	ld	s1,56(sp)
    456e:	7942                	ld	s2,48(sp)
    4570:	79a2                	ld	s3,40(sp)
    4572:	7a02                	ld	s4,32(sp)
    4574:	6ae2                	ld	s5,24(sp)
    4576:	6b42                	ld	s6,16(sp)
    4578:	6ba2                	ld	s7,8(sp)
    457a:	6161                	addi	sp,sp,80
    457c:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
    457e:	85de                	mv	a1,s7
    4580:	00003517          	auipc	a0,0x3
    4584:	2e050513          	addi	a0,a0,736 # 7860 <malloc+0x1bf0>
    4588:	00001097          	auipc	ra,0x1
    458c:	630080e7          	jalr	1584(ra) # 5bb8 <printf>
      exit(1);
    4590:	4505                	li	a0,1
    4592:	00001097          	auipc	ra,0x1
    4596:	29c080e7          	jalr	668(ra) # 582e <exit>
      if(cc != sz){
    459a:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
    459c:	86aa                	mv	a3,a0
    459e:	864e                	mv	a2,s3
    45a0:	85de                	mv	a1,s7
    45a2:	00003517          	auipc	a0,0x3
    45a6:	2de50513          	addi	a0,a0,734 # 7880 <malloc+0x1c10>
    45aa:	00001097          	auipc	ra,0x1
    45ae:	60e080e7          	jalr	1550(ra) # 5bb8 <printf>
        exit(1);
    45b2:	4505                	li	a0,1
    45b4:	00001097          	auipc	ra,0x1
    45b8:	27a080e7          	jalr	634(ra) # 582e <exit>

00000000000045bc <manywrites>:
{
    45bc:	711d                	addi	sp,sp,-96
    45be:	ec86                	sd	ra,88(sp)
    45c0:	e8a2                	sd	s0,80(sp)
    45c2:	e4a6                	sd	s1,72(sp)
    45c4:	e0ca                	sd	s2,64(sp)
    45c6:	fc4e                	sd	s3,56(sp)
    45c8:	f852                	sd	s4,48(sp)
    45ca:	f456                	sd	s5,40(sp)
    45cc:	f05a                	sd	s6,32(sp)
    45ce:	ec5e                	sd	s7,24(sp)
    45d0:	1080                	addi	s0,sp,96
    45d2:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    45d4:	4981                	li	s3,0
    45d6:	4911                	li	s2,4
    int pid = fork();
    45d8:	00001097          	auipc	ra,0x1
    45dc:	24e080e7          	jalr	590(ra) # 5826 <fork>
    45e0:	84aa                	mv	s1,a0
    if(pid < 0){
    45e2:	02054963          	bltz	a0,4614 <manywrites+0x58>
    if(pid == 0){
    45e6:	c521                	beqz	a0,462e <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    45e8:	2985                	addiw	s3,s3,1
    45ea:	ff2997e3          	bne	s3,s2,45d8 <manywrites+0x1c>
    45ee:	4491                	li	s1,4
    int st = 0;
    45f0:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    45f4:	fa840513          	addi	a0,s0,-88
    45f8:	00001097          	auipc	ra,0x1
    45fc:	23e080e7          	jalr	574(ra) # 5836 <wait>
    if(st != 0)
    4600:	fa842503          	lw	a0,-88(s0)
    4604:	ed6d                	bnez	a0,46fe <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    4606:	34fd                	addiw	s1,s1,-1
    4608:	f4e5                	bnez	s1,45f0 <manywrites+0x34>
  exit(0);
    460a:	4501                	li	a0,0
    460c:	00001097          	auipc	ra,0x1
    4610:	222080e7          	jalr	546(ra) # 582e <exit>
      printf("fork failed\n");
    4614:	00003517          	auipc	a0,0x3
    4618:	5a450513          	addi	a0,a0,1444 # 7bb8 <malloc+0x1f48>
    461c:	00001097          	auipc	ra,0x1
    4620:	59c080e7          	jalr	1436(ra) # 5bb8 <printf>
      exit(1);
    4624:	4505                	li	a0,1
    4626:	00001097          	auipc	ra,0x1
    462a:	208080e7          	jalr	520(ra) # 582e <exit>
      name[0] = 'b';
    462e:	06200793          	li	a5,98
    4632:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    4636:	0619879b          	addiw	a5,s3,97
    463a:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    463e:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    4642:	fa840513          	addi	a0,s0,-88
    4646:	00001097          	auipc	ra,0x1
    464a:	238080e7          	jalr	568(ra) # 587e <unlink>
    464e:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    4650:	00007b17          	auipc	s6,0x7
    4654:	380b0b13          	addi	s6,s6,896 # b9d0 <buf>
        for(int i = 0; i < ci+1; i++){
    4658:	8a26                	mv	s4,s1
    465a:	0209ce63          	bltz	s3,4696 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    465e:	20200593          	li	a1,514
    4662:	fa840513          	addi	a0,s0,-88
    4666:	00001097          	auipc	ra,0x1
    466a:	208080e7          	jalr	520(ra) # 586e <open>
    466e:	892a                	mv	s2,a0
          if(fd < 0){
    4670:	04054763          	bltz	a0,46be <manywrites+0x102>
          int cc = write(fd, buf, sz);
    4674:	660d                	lui	a2,0x3
    4676:	85da                	mv	a1,s6
    4678:	00001097          	auipc	ra,0x1
    467c:	1d6080e7          	jalr	470(ra) # 584e <write>
          if(cc != sz){
    4680:	678d                	lui	a5,0x3
    4682:	04f51e63          	bne	a0,a5,46de <manywrites+0x122>
          close(fd);
    4686:	854a                	mv	a0,s2
    4688:	00001097          	auipc	ra,0x1
    468c:	1ce080e7          	jalr	462(ra) # 5856 <close>
        for(int i = 0; i < ci+1; i++){
    4690:	2a05                	addiw	s4,s4,1
    4692:	fd49d6e3          	bge	s3,s4,465e <manywrites+0xa2>
        unlink(name);
    4696:	fa840513          	addi	a0,s0,-88
    469a:	00001097          	auipc	ra,0x1
    469e:	1e4080e7          	jalr	484(ra) # 587e <unlink>
      for(int iters = 0; iters < howmany; iters++){
    46a2:	3bfd                	addiw	s7,s7,-1
    46a4:	fa0b9ae3          	bnez	s7,4658 <manywrites+0x9c>
      unlink(name);
    46a8:	fa840513          	addi	a0,s0,-88
    46ac:	00001097          	auipc	ra,0x1
    46b0:	1d2080e7          	jalr	466(ra) # 587e <unlink>
      exit(0);
    46b4:	4501                	li	a0,0
    46b6:	00001097          	auipc	ra,0x1
    46ba:	178080e7          	jalr	376(ra) # 582e <exit>
            printf("%s: cannot create %s\n", s, name);
    46be:	fa840613          	addi	a2,s0,-88
    46c2:	85d6                	mv	a1,s5
    46c4:	00003517          	auipc	a0,0x3
    46c8:	1d450513          	addi	a0,a0,468 # 7898 <malloc+0x1c28>
    46cc:	00001097          	auipc	ra,0x1
    46d0:	4ec080e7          	jalr	1260(ra) # 5bb8 <printf>
            exit(1);
    46d4:	4505                	li	a0,1
    46d6:	00001097          	auipc	ra,0x1
    46da:	158080e7          	jalr	344(ra) # 582e <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    46de:	86aa                	mv	a3,a0
    46e0:	660d                	lui	a2,0x3
    46e2:	85d6                	mv	a1,s5
    46e4:	00003517          	auipc	a0,0x3
    46e8:	19c50513          	addi	a0,a0,412 # 7880 <malloc+0x1c10>
    46ec:	00001097          	auipc	ra,0x1
    46f0:	4cc080e7          	jalr	1228(ra) # 5bb8 <printf>
            exit(1);
    46f4:	4505                	li	a0,1
    46f6:	00001097          	auipc	ra,0x1
    46fa:	138080e7          	jalr	312(ra) # 582e <exit>
      exit(st);
    46fe:	00001097          	auipc	ra,0x1
    4702:	130080e7          	jalr	304(ra) # 582e <exit>

0000000000004706 <sbrkbasic>:
{
    4706:	7139                	addi	sp,sp,-64
    4708:	fc06                	sd	ra,56(sp)
    470a:	f822                	sd	s0,48(sp)
    470c:	f426                	sd	s1,40(sp)
    470e:	f04a                	sd	s2,32(sp)
    4710:	ec4e                	sd	s3,24(sp)
    4712:	e852                	sd	s4,16(sp)
    4714:	0080                	addi	s0,sp,64
    4716:	8a2a                	mv	s4,a0
  pid = fork();
    4718:	00001097          	auipc	ra,0x1
    471c:	10e080e7          	jalr	270(ra) # 5826 <fork>
  if(pid < 0){
    4720:	02054c63          	bltz	a0,4758 <sbrkbasic+0x52>
  if(pid == 0){
    4724:	ed21                	bnez	a0,477c <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    4726:	40000537          	lui	a0,0x40000
    472a:	00001097          	auipc	ra,0x1
    472e:	18c080e7          	jalr	396(ra) # 58b6 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    4732:	57fd                	li	a5,-1
    4734:	02f50f63          	beq	a0,a5,4772 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    4738:	400007b7          	lui	a5,0x40000
    473c:	97aa                	add	a5,a5,a0
      *b = 99;
    473e:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    4742:	6705                	lui	a4,0x1
      *b = 99;
    4744:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1620>
    for(b = a; b < a+TOOMUCH; b += 4096){
    4748:	953a                	add	a0,a0,a4
    474a:	fef51de3          	bne	a0,a5,4744 <sbrkbasic+0x3e>
    exit(1);
    474e:	4505                	li	a0,1
    4750:	00001097          	auipc	ra,0x1
    4754:	0de080e7          	jalr	222(ra) # 582e <exit>
    printf("fork failed in sbrkbasic\n");
    4758:	00003517          	auipc	a0,0x3
    475c:	15850513          	addi	a0,a0,344 # 78b0 <malloc+0x1c40>
    4760:	00001097          	auipc	ra,0x1
    4764:	458080e7          	jalr	1112(ra) # 5bb8 <printf>
    exit(1);
    4768:	4505                	li	a0,1
    476a:	00001097          	auipc	ra,0x1
    476e:	0c4080e7          	jalr	196(ra) # 582e <exit>
      exit(0);
    4772:	4501                	li	a0,0
    4774:	00001097          	auipc	ra,0x1
    4778:	0ba080e7          	jalr	186(ra) # 582e <exit>
  wait(&xstatus);
    477c:	fcc40513          	addi	a0,s0,-52
    4780:	00001097          	auipc	ra,0x1
    4784:	0b6080e7          	jalr	182(ra) # 5836 <wait>
  if(xstatus == 1){
    4788:	fcc42703          	lw	a4,-52(s0)
    478c:	4785                	li	a5,1
    478e:	00f70d63          	beq	a4,a5,47a8 <sbrkbasic+0xa2>
  a = sbrk(0);
    4792:	4501                	li	a0,0
    4794:	00001097          	auipc	ra,0x1
    4798:	122080e7          	jalr	290(ra) # 58b6 <sbrk>
    479c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    479e:	4901                	li	s2,0
    47a0:	6985                	lui	s3,0x1
    47a2:	38898993          	addi	s3,s3,904 # 1388 <dirfile+0x218>
    47a6:	a005                	j	47c6 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    47a8:	85d2                	mv	a1,s4
    47aa:	00003517          	auipc	a0,0x3
    47ae:	12650513          	addi	a0,a0,294 # 78d0 <malloc+0x1c60>
    47b2:	00001097          	auipc	ra,0x1
    47b6:	406080e7          	jalr	1030(ra) # 5bb8 <printf>
    exit(1);
    47ba:	4505                	li	a0,1
    47bc:	00001097          	auipc	ra,0x1
    47c0:	072080e7          	jalr	114(ra) # 582e <exit>
    a = b + 1;
    47c4:	84be                	mv	s1,a5
    b = sbrk(1);
    47c6:	4505                	li	a0,1
    47c8:	00001097          	auipc	ra,0x1
    47cc:	0ee080e7          	jalr	238(ra) # 58b6 <sbrk>
    if(b != a){
    47d0:	04951c63          	bne	a0,s1,4828 <sbrkbasic+0x122>
    *b = 1;
    47d4:	4785                	li	a5,1
    47d6:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    47da:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    47de:	2905                	addiw	s2,s2,1
    47e0:	ff3912e3          	bne	s2,s3,47c4 <sbrkbasic+0xbe>
  pid = fork();
    47e4:	00001097          	auipc	ra,0x1
    47e8:	042080e7          	jalr	66(ra) # 5826 <fork>
    47ec:	892a                	mv	s2,a0
  if(pid < 0){
    47ee:	04054e63          	bltz	a0,484a <sbrkbasic+0x144>
  c = sbrk(1);
    47f2:	4505                	li	a0,1
    47f4:	00001097          	auipc	ra,0x1
    47f8:	0c2080e7          	jalr	194(ra) # 58b6 <sbrk>
  c = sbrk(1);
    47fc:	4505                	li	a0,1
    47fe:	00001097          	auipc	ra,0x1
    4802:	0b8080e7          	jalr	184(ra) # 58b6 <sbrk>
  if(c != a + 1){
    4806:	0489                	addi	s1,s1,2
    4808:	04a48f63          	beq	s1,a0,4866 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    480c:	85d2                	mv	a1,s4
    480e:	00003517          	auipc	a0,0x3
    4812:	12250513          	addi	a0,a0,290 # 7930 <malloc+0x1cc0>
    4816:	00001097          	auipc	ra,0x1
    481a:	3a2080e7          	jalr	930(ra) # 5bb8 <printf>
    exit(1);
    481e:	4505                	li	a0,1
    4820:	00001097          	auipc	ra,0x1
    4824:	00e080e7          	jalr	14(ra) # 582e <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    4828:	872a                	mv	a4,a0
    482a:	86a6                	mv	a3,s1
    482c:	864a                	mv	a2,s2
    482e:	85d2                	mv	a1,s4
    4830:	00003517          	auipc	a0,0x3
    4834:	0c050513          	addi	a0,a0,192 # 78f0 <malloc+0x1c80>
    4838:	00001097          	auipc	ra,0x1
    483c:	380080e7          	jalr	896(ra) # 5bb8 <printf>
      exit(1);
    4840:	4505                	li	a0,1
    4842:	00001097          	auipc	ra,0x1
    4846:	fec080e7          	jalr	-20(ra) # 582e <exit>
    printf("%s: sbrk test fork failed\n", s);
    484a:	85d2                	mv	a1,s4
    484c:	00003517          	auipc	a0,0x3
    4850:	0c450513          	addi	a0,a0,196 # 7910 <malloc+0x1ca0>
    4854:	00001097          	auipc	ra,0x1
    4858:	364080e7          	jalr	868(ra) # 5bb8 <printf>
    exit(1);
    485c:	4505                	li	a0,1
    485e:	00001097          	auipc	ra,0x1
    4862:	fd0080e7          	jalr	-48(ra) # 582e <exit>
  if(pid == 0)
    4866:	00091763          	bnez	s2,4874 <sbrkbasic+0x16e>
    exit(0);
    486a:	4501                	li	a0,0
    486c:	00001097          	auipc	ra,0x1
    4870:	fc2080e7          	jalr	-62(ra) # 582e <exit>
  wait(&xstatus);
    4874:	fcc40513          	addi	a0,s0,-52
    4878:	00001097          	auipc	ra,0x1
    487c:	fbe080e7          	jalr	-66(ra) # 5836 <wait>
  exit(xstatus);
    4880:	fcc42503          	lw	a0,-52(s0)
    4884:	00001097          	auipc	ra,0x1
    4888:	faa080e7          	jalr	-86(ra) # 582e <exit>

000000000000488c <sbrkmuch>:
{
    488c:	7179                	addi	sp,sp,-48
    488e:	f406                	sd	ra,40(sp)
    4890:	f022                	sd	s0,32(sp)
    4892:	ec26                	sd	s1,24(sp)
    4894:	e84a                	sd	s2,16(sp)
    4896:	e44e                	sd	s3,8(sp)
    4898:	e052                	sd	s4,0(sp)
    489a:	1800                	addi	s0,sp,48
    489c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    489e:	4501                	li	a0,0
    48a0:	00001097          	auipc	ra,0x1
    48a4:	016080e7          	jalr	22(ra) # 58b6 <sbrk>
    48a8:	892a                	mv	s2,a0
  a = sbrk(0);
    48aa:	4501                	li	a0,0
    48ac:	00001097          	auipc	ra,0x1
    48b0:	00a080e7          	jalr	10(ra) # 58b6 <sbrk>
    48b4:	84aa                	mv	s1,a0
  p = sbrk(amt);
    48b6:	06400537          	lui	a0,0x6400
    48ba:	9d05                	subw	a0,a0,s1
    48bc:	00001097          	auipc	ra,0x1
    48c0:	ffa080e7          	jalr	-6(ra) # 58b6 <sbrk>
  if (p != a) {
    48c4:	0ca49863          	bne	s1,a0,4994 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    48c8:	4501                	li	a0,0
    48ca:	00001097          	auipc	ra,0x1
    48ce:	fec080e7          	jalr	-20(ra) # 58b6 <sbrk>
    48d2:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    48d4:	00a4f963          	bgeu	s1,a0,48e6 <sbrkmuch+0x5a>
    *pp = 1;
    48d8:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    48da:	6705                	lui	a4,0x1
    *pp = 1;
    48dc:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    48e0:	94ba                	add	s1,s1,a4
    48e2:	fef4ede3          	bltu	s1,a5,48dc <sbrkmuch+0x50>
  *lastaddr = 99;
    48e6:	064007b7          	lui	a5,0x6400
    48ea:	06300713          	li	a4,99
    48ee:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f161f>
  a = sbrk(0);
    48f2:	4501                	li	a0,0
    48f4:	00001097          	auipc	ra,0x1
    48f8:	fc2080e7          	jalr	-62(ra) # 58b6 <sbrk>
    48fc:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    48fe:	757d                	lui	a0,0xfffff
    4900:	00001097          	auipc	ra,0x1
    4904:	fb6080e7          	jalr	-74(ra) # 58b6 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    4908:	57fd                	li	a5,-1
    490a:	0af50363          	beq	a0,a5,49b0 <sbrkmuch+0x124>
  c = sbrk(0);
    490e:	4501                	li	a0,0
    4910:	00001097          	auipc	ra,0x1
    4914:	fa6080e7          	jalr	-90(ra) # 58b6 <sbrk>
  if(c != a - PGSIZE){
    4918:	77fd                	lui	a5,0xfffff
    491a:	97a6                	add	a5,a5,s1
    491c:	0af51863          	bne	a0,a5,49cc <sbrkmuch+0x140>
  a = sbrk(0);
    4920:	4501                	li	a0,0
    4922:	00001097          	auipc	ra,0x1
    4926:	f94080e7          	jalr	-108(ra) # 58b6 <sbrk>
    492a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    492c:	6505                	lui	a0,0x1
    492e:	00001097          	auipc	ra,0x1
    4932:	f88080e7          	jalr	-120(ra) # 58b6 <sbrk>
    4936:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    4938:	0aa49a63          	bne	s1,a0,49ec <sbrkmuch+0x160>
    493c:	4501                	li	a0,0
    493e:	00001097          	auipc	ra,0x1
    4942:	f78080e7          	jalr	-136(ra) # 58b6 <sbrk>
    4946:	6785                	lui	a5,0x1
    4948:	97a6                	add	a5,a5,s1
    494a:	0af51163          	bne	a0,a5,49ec <sbrkmuch+0x160>
  if(*lastaddr == 99){
    494e:	064007b7          	lui	a5,0x6400
    4952:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f161f>
    4956:	06300793          	li	a5,99
    495a:	0af70963          	beq	a4,a5,4a0c <sbrkmuch+0x180>
  a = sbrk(0);
    495e:	4501                	li	a0,0
    4960:	00001097          	auipc	ra,0x1
    4964:	f56080e7          	jalr	-170(ra) # 58b6 <sbrk>
    4968:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    496a:	4501                	li	a0,0
    496c:	00001097          	auipc	ra,0x1
    4970:	f4a080e7          	jalr	-182(ra) # 58b6 <sbrk>
    4974:	40a9053b          	subw	a0,s2,a0
    4978:	00001097          	auipc	ra,0x1
    497c:	f3e080e7          	jalr	-194(ra) # 58b6 <sbrk>
  if(c != a){
    4980:	0aa49463          	bne	s1,a0,4a28 <sbrkmuch+0x19c>
}
    4984:	70a2                	ld	ra,40(sp)
    4986:	7402                	ld	s0,32(sp)
    4988:	64e2                	ld	s1,24(sp)
    498a:	6942                	ld	s2,16(sp)
    498c:	69a2                	ld	s3,8(sp)
    498e:	6a02                	ld	s4,0(sp)
    4990:	6145                	addi	sp,sp,48
    4992:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    4994:	85ce                	mv	a1,s3
    4996:	00003517          	auipc	a0,0x3
    499a:	fba50513          	addi	a0,a0,-70 # 7950 <malloc+0x1ce0>
    499e:	00001097          	auipc	ra,0x1
    49a2:	21a080e7          	jalr	538(ra) # 5bb8 <printf>
    exit(1);
    49a6:	4505                	li	a0,1
    49a8:	00001097          	auipc	ra,0x1
    49ac:	e86080e7          	jalr	-378(ra) # 582e <exit>
    printf("%s: sbrk could not deallocate\n", s);
    49b0:	85ce                	mv	a1,s3
    49b2:	00003517          	auipc	a0,0x3
    49b6:	fe650513          	addi	a0,a0,-26 # 7998 <malloc+0x1d28>
    49ba:	00001097          	auipc	ra,0x1
    49be:	1fe080e7          	jalr	510(ra) # 5bb8 <printf>
    exit(1);
    49c2:	4505                	li	a0,1
    49c4:	00001097          	auipc	ra,0x1
    49c8:	e6a080e7          	jalr	-406(ra) # 582e <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    49cc:	86aa                	mv	a3,a0
    49ce:	8626                	mv	a2,s1
    49d0:	85ce                	mv	a1,s3
    49d2:	00003517          	auipc	a0,0x3
    49d6:	fe650513          	addi	a0,a0,-26 # 79b8 <malloc+0x1d48>
    49da:	00001097          	auipc	ra,0x1
    49de:	1de080e7          	jalr	478(ra) # 5bb8 <printf>
    exit(1);
    49e2:	4505                	li	a0,1
    49e4:	00001097          	auipc	ra,0x1
    49e8:	e4a080e7          	jalr	-438(ra) # 582e <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    49ec:	86d2                	mv	a3,s4
    49ee:	8626                	mv	a2,s1
    49f0:	85ce                	mv	a1,s3
    49f2:	00003517          	auipc	a0,0x3
    49f6:	00650513          	addi	a0,a0,6 # 79f8 <malloc+0x1d88>
    49fa:	00001097          	auipc	ra,0x1
    49fe:	1be080e7          	jalr	446(ra) # 5bb8 <printf>
    exit(1);
    4a02:	4505                	li	a0,1
    4a04:	00001097          	auipc	ra,0x1
    4a08:	e2a080e7          	jalr	-470(ra) # 582e <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    4a0c:	85ce                	mv	a1,s3
    4a0e:	00003517          	auipc	a0,0x3
    4a12:	01a50513          	addi	a0,a0,26 # 7a28 <malloc+0x1db8>
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	1a2080e7          	jalr	418(ra) # 5bb8 <printf>
    exit(1);
    4a1e:	4505                	li	a0,1
    4a20:	00001097          	auipc	ra,0x1
    4a24:	e0e080e7          	jalr	-498(ra) # 582e <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    4a28:	86aa                	mv	a3,a0
    4a2a:	8626                	mv	a2,s1
    4a2c:	85ce                	mv	a1,s3
    4a2e:	00003517          	auipc	a0,0x3
    4a32:	03250513          	addi	a0,a0,50 # 7a60 <malloc+0x1df0>
    4a36:	00001097          	auipc	ra,0x1
    4a3a:	182080e7          	jalr	386(ra) # 5bb8 <printf>
    exit(1);
    4a3e:	4505                	li	a0,1
    4a40:	00001097          	auipc	ra,0x1
    4a44:	dee080e7          	jalr	-530(ra) # 582e <exit>

0000000000004a48 <MAXVAplus>:
{
    4a48:	7179                	addi	sp,sp,-48
    4a4a:	f406                	sd	ra,40(sp)
    4a4c:	f022                	sd	s0,32(sp)
    4a4e:	ec26                	sd	s1,24(sp)
    4a50:	e84a                	sd	s2,16(sp)
    4a52:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    4a54:	4785                	li	a5,1
    4a56:	179a                	slli	a5,a5,0x26
    4a58:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    4a5c:	fd843783          	ld	a5,-40(s0)
    4a60:	cf85                	beqz	a5,4a98 <MAXVAplus+0x50>
    4a62:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    4a64:	54fd                	li	s1,-1
    pid = fork();
    4a66:	00001097          	auipc	ra,0x1
    4a6a:	dc0080e7          	jalr	-576(ra) # 5826 <fork>
    if(pid < 0){
    4a6e:	02054b63          	bltz	a0,4aa4 <MAXVAplus+0x5c>
    if(pid == 0){
    4a72:	c539                	beqz	a0,4ac0 <MAXVAplus+0x78>
    wait(&xstatus);
    4a74:	fd440513          	addi	a0,s0,-44
    4a78:	00001097          	auipc	ra,0x1
    4a7c:	dbe080e7          	jalr	-578(ra) # 5836 <wait>
    if(xstatus != -1)  // did kernel kill child?
    4a80:	fd442783          	lw	a5,-44(s0)
    4a84:	06979463          	bne	a5,s1,4aec <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    4a88:	fd843783          	ld	a5,-40(s0)
    4a8c:	0786                	slli	a5,a5,0x1
    4a8e:	fcf43c23          	sd	a5,-40(s0)
    4a92:	fd843783          	ld	a5,-40(s0)
    4a96:	fbe1                	bnez	a5,4a66 <MAXVAplus+0x1e>
}
    4a98:	70a2                	ld	ra,40(sp)
    4a9a:	7402                	ld	s0,32(sp)
    4a9c:	64e2                	ld	s1,24(sp)
    4a9e:	6942                	ld	s2,16(sp)
    4aa0:	6145                	addi	sp,sp,48
    4aa2:	8082                	ret
      printf("%s: fork failed\n", s);
    4aa4:	85ca                	mv	a1,s2
    4aa6:	00001517          	auipc	a0,0x1
    4aaa:	60250513          	addi	a0,a0,1538 # 60a8 <malloc+0x438>
    4aae:	00001097          	auipc	ra,0x1
    4ab2:	10a080e7          	jalr	266(ra) # 5bb8 <printf>
      exit(1);
    4ab6:	4505                	li	a0,1
    4ab8:	00001097          	auipc	ra,0x1
    4abc:	d76080e7          	jalr	-650(ra) # 582e <exit>
      *(char*)a = 99;
    4ac0:	fd843783          	ld	a5,-40(s0)
    4ac4:	06300713          	li	a4,99
    4ac8:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    4acc:	fd843603          	ld	a2,-40(s0)
    4ad0:	85ca                	mv	a1,s2
    4ad2:	00003517          	auipc	a0,0x3
    4ad6:	fb650513          	addi	a0,a0,-74 # 7a88 <malloc+0x1e18>
    4ada:	00001097          	auipc	ra,0x1
    4ade:	0de080e7          	jalr	222(ra) # 5bb8 <printf>
      exit(1);
    4ae2:	4505                	li	a0,1
    4ae4:	00001097          	auipc	ra,0x1
    4ae8:	d4a080e7          	jalr	-694(ra) # 582e <exit>
      exit(1);
    4aec:	4505                	li	a0,1
    4aee:	00001097          	auipc	ra,0x1
    4af2:	d40080e7          	jalr	-704(ra) # 582e <exit>

0000000000004af6 <bsstest>:
  for(i = 0; i < sizeof(uninit); i++){
    4af6:	00004797          	auipc	a5,0x4
    4afa:	7ca78793          	addi	a5,a5,1994 # 92c0 <uninit>
    4afe:	00007697          	auipc	a3,0x7
    4b02:	ed268693          	addi	a3,a3,-302 # b9d0 <buf>
    if(uninit[i] != '\0'){
    4b06:	0007c703          	lbu	a4,0(a5)
    4b0a:	e709                	bnez	a4,4b14 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
    4b0c:	0785                	addi	a5,a5,1
    4b0e:	fed79ce3          	bne	a5,a3,4b06 <bsstest+0x10>
    4b12:	8082                	ret
{
    4b14:	1141                	addi	sp,sp,-16
    4b16:	e406                	sd	ra,8(sp)
    4b18:	e022                	sd	s0,0(sp)
    4b1a:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
    4b1c:	85aa                	mv	a1,a0
    4b1e:	00003517          	auipc	a0,0x3
    4b22:	f8250513          	addi	a0,a0,-126 # 7aa0 <malloc+0x1e30>
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	092080e7          	jalr	146(ra) # 5bb8 <printf>
      exit(1);
    4b2e:	4505                	li	a0,1
    4b30:	00001097          	auipc	ra,0x1
    4b34:	cfe080e7          	jalr	-770(ra) # 582e <exit>

0000000000004b38 <bigargtest>:
{
    4b38:	7179                	addi	sp,sp,-48
    4b3a:	f406                	sd	ra,40(sp)
    4b3c:	f022                	sd	s0,32(sp)
    4b3e:	ec26                	sd	s1,24(sp)
    4b40:	1800                	addi	s0,sp,48
    4b42:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4b44:	00003517          	auipc	a0,0x3
    4b48:	f7450513          	addi	a0,a0,-140 # 7ab8 <malloc+0x1e48>
    4b4c:	00001097          	auipc	ra,0x1
    4b50:	d32080e7          	jalr	-718(ra) # 587e <unlink>
  pid = fork();
    4b54:	00001097          	auipc	ra,0x1
    4b58:	cd2080e7          	jalr	-814(ra) # 5826 <fork>
  if(pid == 0){
    4b5c:	c121                	beqz	a0,4b9c <bigargtest+0x64>
  } else if(pid < 0){
    4b5e:	0a054063          	bltz	a0,4bfe <bigargtest+0xc6>
  wait(&xstatus);
    4b62:	fdc40513          	addi	a0,s0,-36
    4b66:	00001097          	auipc	ra,0x1
    4b6a:	cd0080e7          	jalr	-816(ra) # 5836 <wait>
  if(xstatus != 0)
    4b6e:	fdc42503          	lw	a0,-36(s0)
    4b72:	e545                	bnez	a0,4c1a <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    4b74:	4581                	li	a1,0
    4b76:	00003517          	auipc	a0,0x3
    4b7a:	f4250513          	addi	a0,a0,-190 # 7ab8 <malloc+0x1e48>
    4b7e:	00001097          	auipc	ra,0x1
    4b82:	cf0080e7          	jalr	-784(ra) # 586e <open>
  if(fd < 0){
    4b86:	08054e63          	bltz	a0,4c22 <bigargtest+0xea>
  close(fd);
    4b8a:	00001097          	auipc	ra,0x1
    4b8e:	ccc080e7          	jalr	-820(ra) # 5856 <close>
}
    4b92:	70a2                	ld	ra,40(sp)
    4b94:	7402                	ld	s0,32(sp)
    4b96:	64e2                	ld	s1,24(sp)
    4b98:	6145                	addi	sp,sp,48
    4b9a:	8082                	ret
    4b9c:	00003797          	auipc	a5,0x3
    4ba0:	61c78793          	addi	a5,a5,1564 # 81b8 <args.1>
    4ba4:	00003697          	auipc	a3,0x3
    4ba8:	70c68693          	addi	a3,a3,1804 # 82b0 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    4bac:	00003717          	auipc	a4,0x3
    4bb0:	f1c70713          	addi	a4,a4,-228 # 7ac8 <malloc+0x1e58>
    4bb4:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4bb6:	07a1                	addi	a5,a5,8
    4bb8:	fed79ee3          	bne	a5,a3,4bb4 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    4bbc:	00003597          	auipc	a1,0x3
    4bc0:	5fc58593          	addi	a1,a1,1532 # 81b8 <args.1>
    4bc4:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    4bc8:	00001517          	auipc	a0,0x1
    4bcc:	19050513          	addi	a0,a0,400 # 5d58 <malloc+0xe8>
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	c96080e7          	jalr	-874(ra) # 5866 <exec>
    fd = open("bigarg-ok", O_CREATE);
    4bd8:	20000593          	li	a1,512
    4bdc:	00003517          	auipc	a0,0x3
    4be0:	edc50513          	addi	a0,a0,-292 # 7ab8 <malloc+0x1e48>
    4be4:	00001097          	auipc	ra,0x1
    4be8:	c8a080e7          	jalr	-886(ra) # 586e <open>
    close(fd);
    4bec:	00001097          	auipc	ra,0x1
    4bf0:	c6a080e7          	jalr	-918(ra) # 5856 <close>
    exit(0);
    4bf4:	4501                	li	a0,0
    4bf6:	00001097          	auipc	ra,0x1
    4bfa:	c38080e7          	jalr	-968(ra) # 582e <exit>
    printf("%s: bigargtest: fork failed\n", s);
    4bfe:	85a6                	mv	a1,s1
    4c00:	00003517          	auipc	a0,0x3
    4c04:	fa850513          	addi	a0,a0,-88 # 7ba8 <malloc+0x1f38>
    4c08:	00001097          	auipc	ra,0x1
    4c0c:	fb0080e7          	jalr	-80(ra) # 5bb8 <printf>
    exit(1);
    4c10:	4505                	li	a0,1
    4c12:	00001097          	auipc	ra,0x1
    4c16:	c1c080e7          	jalr	-996(ra) # 582e <exit>
    exit(xstatus);
    4c1a:	00001097          	auipc	ra,0x1
    4c1e:	c14080e7          	jalr	-1004(ra) # 582e <exit>
    printf("%s: bigarg test failed!\n", s);
    4c22:	85a6                	mv	a1,s1
    4c24:	00003517          	auipc	a0,0x3
    4c28:	fa450513          	addi	a0,a0,-92 # 7bc8 <malloc+0x1f58>
    4c2c:	00001097          	auipc	ra,0x1
    4c30:	f8c080e7          	jalr	-116(ra) # 5bb8 <printf>
    exit(1);
    4c34:	4505                	li	a0,1
    4c36:	00001097          	auipc	ra,0x1
    4c3a:	bf8080e7          	jalr	-1032(ra) # 582e <exit>

0000000000004c3e <fsfull>:
{
    4c3e:	7171                	addi	sp,sp,-176
    4c40:	f506                	sd	ra,168(sp)
    4c42:	f122                	sd	s0,160(sp)
    4c44:	ed26                	sd	s1,152(sp)
    4c46:	e94a                	sd	s2,144(sp)
    4c48:	e54e                	sd	s3,136(sp)
    4c4a:	e152                	sd	s4,128(sp)
    4c4c:	fcd6                	sd	s5,120(sp)
    4c4e:	f8da                	sd	s6,112(sp)
    4c50:	f4de                	sd	s7,104(sp)
    4c52:	f0e2                	sd	s8,96(sp)
    4c54:	ece6                	sd	s9,88(sp)
    4c56:	e8ea                	sd	s10,80(sp)
    4c58:	e4ee                	sd	s11,72(sp)
    4c5a:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4c5c:	00003517          	auipc	a0,0x3
    4c60:	f8c50513          	addi	a0,a0,-116 # 7be8 <malloc+0x1f78>
    4c64:	00001097          	auipc	ra,0x1
    4c68:	f54080e7          	jalr	-172(ra) # 5bb8 <printf>
  for(nfiles = 0; ; nfiles++){
    4c6c:	4481                	li	s1,0
    name[0] = 'f';
    4c6e:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4c72:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4c76:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4c7a:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4c7c:	00003c97          	auipc	s9,0x3
    4c80:	f7cc8c93          	addi	s9,s9,-132 # 7bf8 <malloc+0x1f88>
    int total = 0;
    4c84:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4c86:	00007a17          	auipc	s4,0x7
    4c8a:	d4aa0a13          	addi	s4,s4,-694 # b9d0 <buf>
    name[0] = 'f';
    4c8e:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4c92:	0384c7bb          	divw	a5,s1,s8
    4c96:	0307879b          	addiw	a5,a5,48
    4c9a:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4c9e:	0384e7bb          	remw	a5,s1,s8
    4ca2:	0377c7bb          	divw	a5,a5,s7
    4ca6:	0307879b          	addiw	a5,a5,48
    4caa:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4cae:	0374e7bb          	remw	a5,s1,s7
    4cb2:	0367c7bb          	divw	a5,a5,s6
    4cb6:	0307879b          	addiw	a5,a5,48
    4cba:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4cbe:	0364e7bb          	remw	a5,s1,s6
    4cc2:	0307879b          	addiw	a5,a5,48
    4cc6:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4cca:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4cce:	f5040593          	addi	a1,s0,-176
    4cd2:	8566                	mv	a0,s9
    4cd4:	00001097          	auipc	ra,0x1
    4cd8:	ee4080e7          	jalr	-284(ra) # 5bb8 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4cdc:	20200593          	li	a1,514
    4ce0:	f5040513          	addi	a0,s0,-176
    4ce4:	00001097          	auipc	ra,0x1
    4ce8:	b8a080e7          	jalr	-1142(ra) # 586e <open>
    4cec:	892a                	mv	s2,a0
    if(fd < 0){
    4cee:	0a055663          	bgez	a0,4d9a <fsfull+0x15c>
      printf("open %s failed\n", name);
    4cf2:	f5040593          	addi	a1,s0,-176
    4cf6:	00003517          	auipc	a0,0x3
    4cfa:	f1250513          	addi	a0,a0,-238 # 7c08 <malloc+0x1f98>
    4cfe:	00001097          	auipc	ra,0x1
    4d02:	eba080e7          	jalr	-326(ra) # 5bb8 <printf>
  while(nfiles >= 0){
    4d06:	0604c363          	bltz	s1,4d6c <fsfull+0x12e>
    name[0] = 'f';
    4d0a:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4d0e:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d12:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d16:	4929                	li	s2,10
  while(nfiles >= 0){
    4d18:	5afd                	li	s5,-1
    name[0] = 'f';
    4d1a:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d1e:	0344c7bb          	divw	a5,s1,s4
    4d22:	0307879b          	addiw	a5,a5,48
    4d26:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d2a:	0344e7bb          	remw	a5,s1,s4
    4d2e:	0337c7bb          	divw	a5,a5,s3
    4d32:	0307879b          	addiw	a5,a5,48
    4d36:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d3a:	0334e7bb          	remw	a5,s1,s3
    4d3e:	0327c7bb          	divw	a5,a5,s2
    4d42:	0307879b          	addiw	a5,a5,48
    4d46:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4d4a:	0324e7bb          	remw	a5,s1,s2
    4d4e:	0307879b          	addiw	a5,a5,48
    4d52:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4d56:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4d5a:	f5040513          	addi	a0,s0,-176
    4d5e:	00001097          	auipc	ra,0x1
    4d62:	b20080e7          	jalr	-1248(ra) # 587e <unlink>
    nfiles--;
    4d66:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4d68:	fb5499e3          	bne	s1,s5,4d1a <fsfull+0xdc>
  printf("fsfull test finished\n");
    4d6c:	00003517          	auipc	a0,0x3
    4d70:	ebc50513          	addi	a0,a0,-324 # 7c28 <malloc+0x1fb8>
    4d74:	00001097          	auipc	ra,0x1
    4d78:	e44080e7          	jalr	-444(ra) # 5bb8 <printf>
}
    4d7c:	70aa                	ld	ra,168(sp)
    4d7e:	740a                	ld	s0,160(sp)
    4d80:	64ea                	ld	s1,152(sp)
    4d82:	694a                	ld	s2,144(sp)
    4d84:	69aa                	ld	s3,136(sp)
    4d86:	6a0a                	ld	s4,128(sp)
    4d88:	7ae6                	ld	s5,120(sp)
    4d8a:	7b46                	ld	s6,112(sp)
    4d8c:	7ba6                	ld	s7,104(sp)
    4d8e:	7c06                	ld	s8,96(sp)
    4d90:	6ce6                	ld	s9,88(sp)
    4d92:	6d46                	ld	s10,80(sp)
    4d94:	6da6                	ld	s11,72(sp)
    4d96:	614d                	addi	sp,sp,176
    4d98:	8082                	ret
    int total = 0;
    4d9a:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4d9c:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4da0:	40000613          	li	a2,1024
    4da4:	85d2                	mv	a1,s4
    4da6:	854a                	mv	a0,s2
    4da8:	00001097          	auipc	ra,0x1
    4dac:	aa6080e7          	jalr	-1370(ra) # 584e <write>
      if(cc < BSIZE)
    4db0:	00aad563          	bge	s5,a0,4dba <fsfull+0x17c>
      total += cc;
    4db4:	00a989bb          	addw	s3,s3,a0
    while(1){
    4db8:	b7e5                	j	4da0 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4dba:	85ce                	mv	a1,s3
    4dbc:	00003517          	auipc	a0,0x3
    4dc0:	e5c50513          	addi	a0,a0,-420 # 7c18 <malloc+0x1fa8>
    4dc4:	00001097          	auipc	ra,0x1
    4dc8:	df4080e7          	jalr	-524(ra) # 5bb8 <printf>
    close(fd);
    4dcc:	854a                	mv	a0,s2
    4dce:	00001097          	auipc	ra,0x1
    4dd2:	a88080e7          	jalr	-1400(ra) # 5856 <close>
    if(total == 0)
    4dd6:	f20988e3          	beqz	s3,4d06 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4dda:	2485                	addiw	s1,s1,1
    4ddc:	bd4d                	j	4c8e <fsfull+0x50>

0000000000004dde <argptest>:
{
    4dde:	1101                	addi	sp,sp,-32
    4de0:	ec06                	sd	ra,24(sp)
    4de2:	e822                	sd	s0,16(sp)
    4de4:	e426                	sd	s1,8(sp)
    4de6:	e04a                	sd	s2,0(sp)
    4de8:	1000                	addi	s0,sp,32
    4dea:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    4dec:	4581                	li	a1,0
    4dee:	00003517          	auipc	a0,0x3
    4df2:	e5250513          	addi	a0,a0,-430 # 7c40 <malloc+0x1fd0>
    4df6:	00001097          	auipc	ra,0x1
    4dfa:	a78080e7          	jalr	-1416(ra) # 586e <open>
  if (fd < 0) {
    4dfe:	02054b63          	bltz	a0,4e34 <argptest+0x56>
    4e02:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    4e04:	4501                	li	a0,0
    4e06:	00001097          	auipc	ra,0x1
    4e0a:	ab0080e7          	jalr	-1360(ra) # 58b6 <sbrk>
    4e0e:	567d                	li	a2,-1
    4e10:	fff50593          	addi	a1,a0,-1
    4e14:	8526                	mv	a0,s1
    4e16:	00001097          	auipc	ra,0x1
    4e1a:	a30080e7          	jalr	-1488(ra) # 5846 <read>
  close(fd);
    4e1e:	8526                	mv	a0,s1
    4e20:	00001097          	auipc	ra,0x1
    4e24:	a36080e7          	jalr	-1482(ra) # 5856 <close>
}
    4e28:	60e2                	ld	ra,24(sp)
    4e2a:	6442                	ld	s0,16(sp)
    4e2c:	64a2                	ld	s1,8(sp)
    4e2e:	6902                	ld	s2,0(sp)
    4e30:	6105                	addi	sp,sp,32
    4e32:	8082                	ret
    printf("%s: open failed\n", s);
    4e34:	85ca                	mv	a1,s2
    4e36:	00002517          	auipc	a0,0x2
    4e3a:	f2250513          	addi	a0,a0,-222 # 6d58 <malloc+0x10e8>
    4e3e:	00001097          	auipc	ra,0x1
    4e42:	d7a080e7          	jalr	-646(ra) # 5bb8 <printf>
    exit(1);
    4e46:	4505                	li	a0,1
    4e48:	00001097          	auipc	ra,0x1
    4e4c:	9e6080e7          	jalr	-1562(ra) # 582e <exit>

0000000000004e50 <pgbug>:
{
    4e50:	7179                	addi	sp,sp,-48
    4e52:	f406                	sd	ra,40(sp)
    4e54:	f022                	sd	s0,32(sp)
    4e56:	ec26                	sd	s1,24(sp)
    4e58:	1800                	addi	s0,sp,48
  argv[0] = 0;
    4e5a:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    4e5e:	00003497          	auipc	s1,0x3
    4e62:	34a4b483          	ld	s1,842(s1) # 81a8 <__SDATA_BEGIN__>
    4e66:	fd840593          	addi	a1,s0,-40
    4e6a:	8526                	mv	a0,s1
    4e6c:	00001097          	auipc	ra,0x1
    4e70:	9fa080e7          	jalr	-1542(ra) # 5866 <exec>
  pipe((int*)0xeaeb0b5b00002f5e);
    4e74:	8526                	mv	a0,s1
    4e76:	00001097          	auipc	ra,0x1
    4e7a:	9c8080e7          	jalr	-1592(ra) # 583e <pipe>
  exit(0);
    4e7e:	4501                	li	a0,0
    4e80:	00001097          	auipc	ra,0x1
    4e84:	9ae080e7          	jalr	-1618(ra) # 582e <exit>

0000000000004e88 <sbrkbugs>:
{
    4e88:	1141                	addi	sp,sp,-16
    4e8a:	e406                	sd	ra,8(sp)
    4e8c:	e022                	sd	s0,0(sp)
    4e8e:	0800                	addi	s0,sp,16
  int pid = fork();
    4e90:	00001097          	auipc	ra,0x1
    4e94:	996080e7          	jalr	-1642(ra) # 5826 <fork>
  if(pid < 0){
    4e98:	02054263          	bltz	a0,4ebc <sbrkbugs+0x34>
  if(pid == 0){
    4e9c:	ed0d                	bnez	a0,4ed6 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    4e9e:	00001097          	auipc	ra,0x1
    4ea2:	a18080e7          	jalr	-1512(ra) # 58b6 <sbrk>
    sbrk(-sz);
    4ea6:	40a0053b          	negw	a0,a0
    4eaa:	00001097          	auipc	ra,0x1
    4eae:	a0c080e7          	jalr	-1524(ra) # 58b6 <sbrk>
    exit(0);
    4eb2:	4501                	li	a0,0
    4eb4:	00001097          	auipc	ra,0x1
    4eb8:	97a080e7          	jalr	-1670(ra) # 582e <exit>
    printf("fork failed\n");
    4ebc:	00003517          	auipc	a0,0x3
    4ec0:	cfc50513          	addi	a0,a0,-772 # 7bb8 <malloc+0x1f48>
    4ec4:	00001097          	auipc	ra,0x1
    4ec8:	cf4080e7          	jalr	-780(ra) # 5bb8 <printf>
    exit(1);
    4ecc:	4505                	li	a0,1
    4ece:	00001097          	auipc	ra,0x1
    4ed2:	960080e7          	jalr	-1696(ra) # 582e <exit>
  wait(0);
    4ed6:	4501                	li	a0,0
    4ed8:	00001097          	auipc	ra,0x1
    4edc:	95e080e7          	jalr	-1698(ra) # 5836 <wait>
  pid = fork();
    4ee0:	00001097          	auipc	ra,0x1
    4ee4:	946080e7          	jalr	-1722(ra) # 5826 <fork>
  if(pid < 0){
    4ee8:	02054563          	bltz	a0,4f12 <sbrkbugs+0x8a>
  if(pid == 0){
    4eec:	e121                	bnez	a0,4f2c <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    4eee:	00001097          	auipc	ra,0x1
    4ef2:	9c8080e7          	jalr	-1592(ra) # 58b6 <sbrk>
    sbrk(-(sz - 3500));
    4ef6:	6785                	lui	a5,0x1
    4ef8:	dac7879b          	addiw	a5,a5,-596 # dac <fourteen+0x124>
    4efc:	40a7853b          	subw	a0,a5,a0
    4f00:	00001097          	auipc	ra,0x1
    4f04:	9b6080e7          	jalr	-1610(ra) # 58b6 <sbrk>
    exit(0);
    4f08:	4501                	li	a0,0
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	924080e7          	jalr	-1756(ra) # 582e <exit>
    printf("fork failed\n");
    4f12:	00003517          	auipc	a0,0x3
    4f16:	ca650513          	addi	a0,a0,-858 # 7bb8 <malloc+0x1f48>
    4f1a:	00001097          	auipc	ra,0x1
    4f1e:	c9e080e7          	jalr	-866(ra) # 5bb8 <printf>
    exit(1);
    4f22:	4505                	li	a0,1
    4f24:	00001097          	auipc	ra,0x1
    4f28:	90a080e7          	jalr	-1782(ra) # 582e <exit>
  wait(0);
    4f2c:	4501                	li	a0,0
    4f2e:	00001097          	auipc	ra,0x1
    4f32:	908080e7          	jalr	-1784(ra) # 5836 <wait>
  pid = fork();
    4f36:	00001097          	auipc	ra,0x1
    4f3a:	8f0080e7          	jalr	-1808(ra) # 5826 <fork>
  if(pid < 0){
    4f3e:	02054a63          	bltz	a0,4f72 <sbrkbugs+0xea>
  if(pid == 0){
    4f42:	e529                	bnez	a0,4f8c <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    4f44:	00001097          	auipc	ra,0x1
    4f48:	972080e7          	jalr	-1678(ra) # 58b6 <sbrk>
    4f4c:	67ad                	lui	a5,0xb
    4f4e:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1540>
    4f52:	40a7853b          	subw	a0,a5,a0
    4f56:	00001097          	auipc	ra,0x1
    4f5a:	960080e7          	jalr	-1696(ra) # 58b6 <sbrk>
    sbrk(-10);
    4f5e:	5559                	li	a0,-10
    4f60:	00001097          	auipc	ra,0x1
    4f64:	956080e7          	jalr	-1706(ra) # 58b6 <sbrk>
    exit(0);
    4f68:	4501                	li	a0,0
    4f6a:	00001097          	auipc	ra,0x1
    4f6e:	8c4080e7          	jalr	-1852(ra) # 582e <exit>
    printf("fork failed\n");
    4f72:	00003517          	auipc	a0,0x3
    4f76:	c4650513          	addi	a0,a0,-954 # 7bb8 <malloc+0x1f48>
    4f7a:	00001097          	auipc	ra,0x1
    4f7e:	c3e080e7          	jalr	-962(ra) # 5bb8 <printf>
    exit(1);
    4f82:	4505                	li	a0,1
    4f84:	00001097          	auipc	ra,0x1
    4f88:	8aa080e7          	jalr	-1878(ra) # 582e <exit>
  wait(0);
    4f8c:	4501                	li	a0,0
    4f8e:	00001097          	auipc	ra,0x1
    4f92:	8a8080e7          	jalr	-1880(ra) # 5836 <wait>
  exit(0);
    4f96:	4501                	li	a0,0
    4f98:	00001097          	auipc	ra,0x1
    4f9c:	896080e7          	jalr	-1898(ra) # 582e <exit>

0000000000004fa0 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
    4fa0:	7179                	addi	sp,sp,-48
    4fa2:	f406                	sd	ra,40(sp)
    4fa4:	f022                	sd	s0,32(sp)
    4fa6:	ec26                	sd	s1,24(sp)
    4fa8:	e84a                	sd	s2,16(sp)
    4faa:	e44e                	sd	s3,8(sp)
    4fac:	e052                	sd	s4,0(sp)
    4fae:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
    4fb0:	00003517          	auipc	a0,0x3
    4fb4:	c9850513          	addi	a0,a0,-872 # 7c48 <malloc+0x1fd8>
    4fb8:	00001097          	auipc	ra,0x1
    4fbc:	8c6080e7          	jalr	-1850(ra) # 587e <unlink>
    4fc0:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
    4fc4:	00003997          	auipc	s3,0x3
    4fc8:	c8498993          	addi	s3,s3,-892 # 7c48 <malloc+0x1fd8>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
    4fcc:	5a7d                	li	s4,-1
    4fce:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4fd2:	20100593          	li	a1,513
    4fd6:	854e                	mv	a0,s3
    4fd8:	00001097          	auipc	ra,0x1
    4fdc:	896080e7          	jalr	-1898(ra) # 586e <open>
    4fe0:	84aa                	mv	s1,a0
    if(fd < 0){
    4fe2:	06054b63          	bltz	a0,5058 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4fe6:	4605                	li	a2,1
    4fe8:	85d2                	mv	a1,s4
    4fea:	00001097          	auipc	ra,0x1
    4fee:	864080e7          	jalr	-1948(ra) # 584e <write>
    close(fd);
    4ff2:	8526                	mv	a0,s1
    4ff4:	00001097          	auipc	ra,0x1
    4ff8:	862080e7          	jalr	-1950(ra) # 5856 <close>
    unlink("junk");
    4ffc:	854e                	mv	a0,s3
    4ffe:	00001097          	auipc	ra,0x1
    5002:	880080e7          	jalr	-1920(ra) # 587e <unlink>
  for(int i = 0; i < assumed_free; i++){
    5006:	397d                	addiw	s2,s2,-1
    5008:	fc0915e3          	bnez	s2,4fd2 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
    500c:	20100593          	li	a1,513
    5010:	00003517          	auipc	a0,0x3
    5014:	c3850513          	addi	a0,a0,-968 # 7c48 <malloc+0x1fd8>
    5018:	00001097          	auipc	ra,0x1
    501c:	856080e7          	jalr	-1962(ra) # 586e <open>
    5020:	84aa                	mv	s1,a0
  if(fd < 0){
    5022:	04054863          	bltz	a0,5072 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
    5026:	4605                	li	a2,1
    5028:	00001597          	auipc	a1,0x1
    502c:	6b058593          	addi	a1,a1,1712 # 66d8 <malloc+0xa68>
    5030:	00001097          	auipc	ra,0x1
    5034:	81e080e7          	jalr	-2018(ra) # 584e <write>
    5038:	4785                	li	a5,1
    503a:	04f50963          	beq	a0,a5,508c <badwrite+0xec>
    printf("write failed\n");
    503e:	00003517          	auipc	a0,0x3
    5042:	c2a50513          	addi	a0,a0,-982 # 7c68 <malloc+0x1ff8>
    5046:	00001097          	auipc	ra,0x1
    504a:	b72080e7          	jalr	-1166(ra) # 5bb8 <printf>
    exit(1);
    504e:	4505                	li	a0,1
    5050:	00000097          	auipc	ra,0x0
    5054:	7de080e7          	jalr	2014(ra) # 582e <exit>
      printf("open junk failed\n");
    5058:	00003517          	auipc	a0,0x3
    505c:	bf850513          	addi	a0,a0,-1032 # 7c50 <malloc+0x1fe0>
    5060:	00001097          	auipc	ra,0x1
    5064:	b58080e7          	jalr	-1192(ra) # 5bb8 <printf>
      exit(1);
    5068:	4505                	li	a0,1
    506a:	00000097          	auipc	ra,0x0
    506e:	7c4080e7          	jalr	1988(ra) # 582e <exit>
    printf("open junk failed\n");
    5072:	00003517          	auipc	a0,0x3
    5076:	bde50513          	addi	a0,a0,-1058 # 7c50 <malloc+0x1fe0>
    507a:	00001097          	auipc	ra,0x1
    507e:	b3e080e7          	jalr	-1218(ra) # 5bb8 <printf>
    exit(1);
    5082:	4505                	li	a0,1
    5084:	00000097          	auipc	ra,0x0
    5088:	7aa080e7          	jalr	1962(ra) # 582e <exit>
  }
  close(fd);
    508c:	8526                	mv	a0,s1
    508e:	00000097          	auipc	ra,0x0
    5092:	7c8080e7          	jalr	1992(ra) # 5856 <close>
  unlink("junk");
    5096:	00003517          	auipc	a0,0x3
    509a:	bb250513          	addi	a0,a0,-1102 # 7c48 <malloc+0x1fd8>
    509e:	00000097          	auipc	ra,0x0
    50a2:	7e0080e7          	jalr	2016(ra) # 587e <unlink>

  exit(0);
    50a6:	4501                	li	a0,0
    50a8:	00000097          	auipc	ra,0x0
    50ac:	786080e7          	jalr	1926(ra) # 582e <exit>

00000000000050b0 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    50b0:	7139                	addi	sp,sp,-64
    50b2:	fc06                	sd	ra,56(sp)
    50b4:	f822                	sd	s0,48(sp)
    50b6:	f426                	sd	s1,40(sp)
    50b8:	f04a                	sd	s2,32(sp)
    50ba:	ec4e                	sd	s3,24(sp)
    50bc:	0080                	addi	s0,sp,64
    50be:	64b1                	lui	s1,0xc
    50c0:	35048493          	addi	s1,s1,848 # c350 <buf+0x980>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    50c4:	597d                	li	s2,-1
    50c6:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    50ca:	00001997          	auipc	s3,0x1
    50ce:	c8e98993          	addi	s3,s3,-882 # 5d58 <malloc+0xe8>
    argv[0] = (char*)0xffffffff;
    50d2:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    50d6:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    50da:	fc040593          	addi	a1,s0,-64
    50de:	854e                	mv	a0,s3
    50e0:	00000097          	auipc	ra,0x0
    50e4:	786080e7          	jalr	1926(ra) # 5866 <exec>
  for(int i = 0; i < 50000; i++){
    50e8:	34fd                	addiw	s1,s1,-1
    50ea:	f4e5                	bnez	s1,50d2 <badarg+0x22>
  }
  
  exit(0);
    50ec:	4501                	li	a0,0
    50ee:	00000097          	auipc	ra,0x0
    50f2:	740080e7          	jalr	1856(ra) # 582e <exit>

00000000000050f6 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    50f6:	715d                	addi	sp,sp,-80
    50f8:	e486                	sd	ra,72(sp)
    50fa:	e0a2                	sd	s0,64(sp)
    50fc:	fc26                	sd	s1,56(sp)
    50fe:	f84a                	sd	s2,48(sp)
    5100:	f44e                	sd	s3,40(sp)
    5102:	f052                	sd	s4,32(sp)
    5104:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    5106:	4901                	li	s2,0
    5108:	49bd                	li	s3,15
    int pid = fork();
    510a:	00000097          	auipc	ra,0x0
    510e:	71c080e7          	jalr	1820(ra) # 5826 <fork>
    5112:	84aa                	mv	s1,a0
    if(pid < 0){
    5114:	02054063          	bltz	a0,5134 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    5118:	c91d                	beqz	a0,514e <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    511a:	4501                	li	a0,0
    511c:	00000097          	auipc	ra,0x0
    5120:	71a080e7          	jalr	1818(ra) # 5836 <wait>
  for(int avail = 0; avail < 15; avail++){
    5124:	2905                	addiw	s2,s2,1
    5126:	ff3912e3          	bne	s2,s3,510a <execout+0x14>
    }
  }

  exit(0);
    512a:	4501                	li	a0,0
    512c:	00000097          	auipc	ra,0x0
    5130:	702080e7          	jalr	1794(ra) # 582e <exit>
      printf("fork failed\n");
    5134:	00003517          	auipc	a0,0x3
    5138:	a8450513          	addi	a0,a0,-1404 # 7bb8 <malloc+0x1f48>
    513c:	00001097          	auipc	ra,0x1
    5140:	a7c080e7          	jalr	-1412(ra) # 5bb8 <printf>
      exit(1);
    5144:	4505                	li	a0,1
    5146:	00000097          	auipc	ra,0x0
    514a:	6e8080e7          	jalr	1768(ra) # 582e <exit>
        if(a == 0xffffffffffffffffLL)
    514e:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    5150:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    5152:	6505                	lui	a0,0x1
    5154:	00000097          	auipc	ra,0x0
    5158:	762080e7          	jalr	1890(ra) # 58b6 <sbrk>
        if(a == 0xffffffffffffffffLL)
    515c:	01350763          	beq	a0,s3,516a <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    5160:	6785                	lui	a5,0x1
    5162:	97aa                	add	a5,a5,a0
    5164:	ff478fa3          	sb	s4,-1(a5) # fff <rmdot+0x15>
      while(1){
    5168:	b7ed                	j	5152 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    516a:	01205a63          	blez	s2,517e <execout+0x88>
        sbrk(-4096);
    516e:	757d                	lui	a0,0xfffff
    5170:	00000097          	auipc	ra,0x0
    5174:	746080e7          	jalr	1862(ra) # 58b6 <sbrk>
      for(int i = 0; i < avail; i++)
    5178:	2485                	addiw	s1,s1,1
    517a:	ff249ae3          	bne	s1,s2,516e <execout+0x78>
      close(1);
    517e:	4505                	li	a0,1
    5180:	00000097          	auipc	ra,0x0
    5184:	6d6080e7          	jalr	1750(ra) # 5856 <close>
      char *args[] = { "echo", "x", 0 };
    5188:	00001517          	auipc	a0,0x1
    518c:	bd050513          	addi	a0,a0,-1072 # 5d58 <malloc+0xe8>
    5190:	faa43c23          	sd	a0,-72(s0)
    5194:	00001797          	auipc	a5,0x1
    5198:	54478793          	addi	a5,a5,1348 # 66d8 <malloc+0xa68>
    519c:	fcf43023          	sd	a5,-64(s0)
    51a0:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    51a4:	fb840593          	addi	a1,s0,-72
    51a8:	00000097          	auipc	ra,0x0
    51ac:	6be080e7          	jalr	1726(ra) # 5866 <exec>
      exit(0);
    51b0:	4501                	li	a0,0
    51b2:	00000097          	auipc	ra,0x0
    51b6:	67c080e7          	jalr	1660(ra) # 582e <exit>

00000000000051ba <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    51ba:	7139                	addi	sp,sp,-64
    51bc:	fc06                	sd	ra,56(sp)
    51be:	f822                	sd	s0,48(sp)
    51c0:	f426                	sd	s1,40(sp)
    51c2:	f04a                	sd	s2,32(sp)
    51c4:	ec4e                	sd	s3,24(sp)
    51c6:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    51c8:	fc840513          	addi	a0,s0,-56
    51cc:	00000097          	auipc	ra,0x0
    51d0:	672080e7          	jalr	1650(ra) # 583e <pipe>
    51d4:	06054763          	bltz	a0,5242 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    51d8:	00000097          	auipc	ra,0x0
    51dc:	64e080e7          	jalr	1614(ra) # 5826 <fork>

  if(pid < 0){
    51e0:	06054e63          	bltz	a0,525c <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    51e4:	ed51                	bnez	a0,5280 <countfree+0xc6>
    close(fds[0]);
    51e6:	fc842503          	lw	a0,-56(s0)
    51ea:	00000097          	auipc	ra,0x0
    51ee:	66c080e7          	jalr	1644(ra) # 5856 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    51f2:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    51f4:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    51f6:	00001997          	auipc	s3,0x1
    51fa:	4e298993          	addi	s3,s3,1250 # 66d8 <malloc+0xa68>
      uint64 a = (uint64) sbrk(4096);
    51fe:	6505                	lui	a0,0x1
    5200:	00000097          	auipc	ra,0x0
    5204:	6b6080e7          	jalr	1718(ra) # 58b6 <sbrk>
      if(a == 0xffffffffffffffff){
    5208:	07250763          	beq	a0,s2,5276 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    520c:	6785                	lui	a5,0x1
    520e:	97aa                	add	a5,a5,a0
    5210:	fe978fa3          	sb	s1,-1(a5) # fff <rmdot+0x15>
      if(write(fds[1], "x", 1) != 1){
    5214:	8626                	mv	a2,s1
    5216:	85ce                	mv	a1,s3
    5218:	fcc42503          	lw	a0,-52(s0)
    521c:	00000097          	auipc	ra,0x0
    5220:	632080e7          	jalr	1586(ra) # 584e <write>
    5224:	fc950de3          	beq	a0,s1,51fe <countfree+0x44>
        printf("write() failed in countfree()\n");
    5228:	00003517          	auipc	a0,0x3
    522c:	a9050513          	addi	a0,a0,-1392 # 7cb8 <malloc+0x2048>
    5230:	00001097          	auipc	ra,0x1
    5234:	988080e7          	jalr	-1656(ra) # 5bb8 <printf>
        exit(1);
    5238:	4505                	li	a0,1
    523a:	00000097          	auipc	ra,0x0
    523e:	5f4080e7          	jalr	1524(ra) # 582e <exit>
    printf("pipe() failed in countfree()\n");
    5242:	00003517          	auipc	a0,0x3
    5246:	a3650513          	addi	a0,a0,-1482 # 7c78 <malloc+0x2008>
    524a:	00001097          	auipc	ra,0x1
    524e:	96e080e7          	jalr	-1682(ra) # 5bb8 <printf>
    exit(1);
    5252:	4505                	li	a0,1
    5254:	00000097          	auipc	ra,0x0
    5258:	5da080e7          	jalr	1498(ra) # 582e <exit>
    printf("fork failed in countfree()\n");
    525c:	00003517          	auipc	a0,0x3
    5260:	a3c50513          	addi	a0,a0,-1476 # 7c98 <malloc+0x2028>
    5264:	00001097          	auipc	ra,0x1
    5268:	954080e7          	jalr	-1708(ra) # 5bb8 <printf>
    exit(1);
    526c:	4505                	li	a0,1
    526e:	00000097          	auipc	ra,0x0
    5272:	5c0080e7          	jalr	1472(ra) # 582e <exit>
      }
    }

    exit(0);
    5276:	4501                	li	a0,0
    5278:	00000097          	auipc	ra,0x0
    527c:	5b6080e7          	jalr	1462(ra) # 582e <exit>
  }

  close(fds[1]);
    5280:	fcc42503          	lw	a0,-52(s0)
    5284:	00000097          	auipc	ra,0x0
    5288:	5d2080e7          	jalr	1490(ra) # 5856 <close>

  int n = 0;
    528c:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    528e:	4605                	li	a2,1
    5290:	fc740593          	addi	a1,s0,-57
    5294:	fc842503          	lw	a0,-56(s0)
    5298:	00000097          	auipc	ra,0x0
    529c:	5ae080e7          	jalr	1454(ra) # 5846 <read>
    if(cc < 0){
    52a0:	00054563          	bltz	a0,52aa <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    52a4:	c105                	beqz	a0,52c4 <countfree+0x10a>
      break;
    n += 1;
    52a6:	2485                	addiw	s1,s1,1
  while(1){
    52a8:	b7dd                	j	528e <countfree+0xd4>
      printf("read() failed in countfree()\n");
    52aa:	00003517          	auipc	a0,0x3
    52ae:	a2e50513          	addi	a0,a0,-1490 # 7cd8 <malloc+0x2068>
    52b2:	00001097          	auipc	ra,0x1
    52b6:	906080e7          	jalr	-1786(ra) # 5bb8 <printf>
      exit(1);
    52ba:	4505                	li	a0,1
    52bc:	00000097          	auipc	ra,0x0
    52c0:	572080e7          	jalr	1394(ra) # 582e <exit>
  }

  close(fds[0]);
    52c4:	fc842503          	lw	a0,-56(s0)
    52c8:	00000097          	auipc	ra,0x0
    52cc:	58e080e7          	jalr	1422(ra) # 5856 <close>
  wait((int*)0);
    52d0:	4501                	li	a0,0
    52d2:	00000097          	auipc	ra,0x0
    52d6:	564080e7          	jalr	1380(ra) # 5836 <wait>
  
  return n;
}
    52da:	8526                	mv	a0,s1
    52dc:	70e2                	ld	ra,56(sp)
    52de:	7442                	ld	s0,48(sp)
    52e0:	74a2                	ld	s1,40(sp)
    52e2:	7902                	ld	s2,32(sp)
    52e4:	69e2                	ld	s3,24(sp)
    52e6:	6121                	addi	sp,sp,64
    52e8:	8082                	ret

00000000000052ea <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    52ea:	7179                	addi	sp,sp,-48
    52ec:	f406                	sd	ra,40(sp)
    52ee:	f022                	sd	s0,32(sp)
    52f0:	ec26                	sd	s1,24(sp)
    52f2:	e84a                	sd	s2,16(sp)
    52f4:	1800                	addi	s0,sp,48
    52f6:	84aa                	mv	s1,a0
    52f8:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    52fa:	00003517          	auipc	a0,0x3
    52fe:	9fe50513          	addi	a0,a0,-1538 # 7cf8 <malloc+0x2088>
    5302:	00001097          	auipc	ra,0x1
    5306:	8b6080e7          	jalr	-1866(ra) # 5bb8 <printf>
  if((pid = fork()) < 0) {
    530a:	00000097          	auipc	ra,0x0
    530e:	51c080e7          	jalr	1308(ra) # 5826 <fork>
    5312:	02054e63          	bltz	a0,534e <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5316:	c929                	beqz	a0,5368 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5318:	fdc40513          	addi	a0,s0,-36
    531c:	00000097          	auipc	ra,0x0
    5320:	51a080e7          	jalr	1306(ra) # 5836 <wait>
    if(xstatus != 0) 
    5324:	fdc42783          	lw	a5,-36(s0)
    5328:	c7b9                	beqz	a5,5376 <run+0x8c>
      printf("FAILED\n");
    532a:	00003517          	auipc	a0,0x3
    532e:	9f650513          	addi	a0,a0,-1546 # 7d20 <malloc+0x20b0>
    5332:	00001097          	auipc	ra,0x1
    5336:	886080e7          	jalr	-1914(ra) # 5bb8 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    533a:	fdc42503          	lw	a0,-36(s0)
  }
}
    533e:	00153513          	seqz	a0,a0
    5342:	70a2                	ld	ra,40(sp)
    5344:	7402                	ld	s0,32(sp)
    5346:	64e2                	ld	s1,24(sp)
    5348:	6942                	ld	s2,16(sp)
    534a:	6145                	addi	sp,sp,48
    534c:	8082                	ret
    printf("runtest: fork error\n");
    534e:	00003517          	auipc	a0,0x3
    5352:	9ba50513          	addi	a0,a0,-1606 # 7d08 <malloc+0x2098>
    5356:	00001097          	auipc	ra,0x1
    535a:	862080e7          	jalr	-1950(ra) # 5bb8 <printf>
    exit(1);
    535e:	4505                	li	a0,1
    5360:	00000097          	auipc	ra,0x0
    5364:	4ce080e7          	jalr	1230(ra) # 582e <exit>
    f(s);
    5368:	854a                	mv	a0,s2
    536a:	9482                	jalr	s1
    exit(0);
    536c:	4501                	li	a0,0
    536e:	00000097          	auipc	ra,0x0
    5372:	4c0080e7          	jalr	1216(ra) # 582e <exit>
      printf("OK\n");
    5376:	00003517          	auipc	a0,0x3
    537a:	9b250513          	addi	a0,a0,-1614 # 7d28 <malloc+0x20b8>
    537e:	00001097          	auipc	ra,0x1
    5382:	83a080e7          	jalr	-1990(ra) # 5bb8 <printf>
    5386:	bf55                	j	533a <run+0x50>

0000000000005388 <main>:

int
main(int argc, char *argv[])
{
    5388:	7141                	addi	sp,sp,-496
    538a:	f786                	sd	ra,488(sp)
    538c:	f3a2                	sd	s0,480(sp)
    538e:	efa6                	sd	s1,472(sp)
    5390:	ebca                	sd	s2,464(sp)
    5392:	e7ce                	sd	s3,456(sp)
    5394:	e3d2                	sd	s4,448(sp)
    5396:	ff56                	sd	s5,440(sp)
    5398:	fb5a                	sd	s6,432(sp)
    539a:	1b80                	addi	s0,sp,496
    539c:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    539e:	4789                	li	a5,2
    53a0:	08f50f63          	beq	a0,a5,543e <main+0xb6>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    53a4:	4785                	li	a5,1
  char *justone = 0;
    53a6:	4901                	li	s2,0
  } else if(argc > 1){
    53a8:	0ca7c963          	blt	a5,a0,547a <main+0xf2>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    53ac:	00003797          	auipc	a5,0x3
    53b0:	bd478793          	addi	a5,a5,-1068 # 7f80 <malloc+0x2310>
    53b4:	e1040713          	addi	a4,s0,-496
    53b8:	00003317          	auipc	t1,0x3
    53bc:	d7830313          	addi	t1,t1,-648 # 8130 <malloc+0x24c0>
    53c0:	0007b883          	ld	a7,0(a5)
    53c4:	0087b803          	ld	a6,8(a5)
    53c8:	6b88                	ld	a0,16(a5)
    53ca:	6f8c                	ld	a1,24(a5)
    53cc:	7390                	ld	a2,32(a5)
    53ce:	7794                	ld	a3,40(a5)
    53d0:	01173023          	sd	a7,0(a4)
    53d4:	01073423          	sd	a6,8(a4)
    53d8:	eb08                	sd	a0,16(a4)
    53da:	ef0c                	sd	a1,24(a4)
    53dc:	f310                	sd	a2,32(a4)
    53de:	f714                	sd	a3,40(a4)
    53e0:	03078793          	addi	a5,a5,48
    53e4:	03070713          	addi	a4,a4,48
    53e8:	fc679ce3          	bne	a5,t1,53c0 <main+0x38>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    53ec:	00003517          	auipc	a0,0x3
    53f0:	9f450513          	addi	a0,a0,-1548 # 7de0 <malloc+0x2170>
    53f4:	00000097          	auipc	ra,0x0
    53f8:	7c4080e7          	jalr	1988(ra) # 5bb8 <printf>
  int free0 = countfree();
    53fc:	00000097          	auipc	ra,0x0
    5400:	dbe080e7          	jalr	-578(ra) # 51ba <countfree>
    5404:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5406:	e1843503          	ld	a0,-488(s0)
    540a:	e1040493          	addi	s1,s0,-496
  int fail = 0;
    540e:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5410:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    5412:	e55d                	bnez	a0,54c0 <main+0x138>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    5414:	00000097          	auipc	ra,0x0
    5418:	da6080e7          	jalr	-602(ra) # 51ba <countfree>
    541c:	85aa                	mv	a1,a0
    541e:	0f455163          	bge	a0,s4,5500 <main+0x178>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5422:	8652                	mv	a2,s4
    5424:	00003517          	auipc	a0,0x3
    5428:	97450513          	addi	a0,a0,-1676 # 7d98 <malloc+0x2128>
    542c:	00000097          	auipc	ra,0x0
    5430:	78c080e7          	jalr	1932(ra) # 5bb8 <printf>
    exit(1);
    5434:	4505                	li	a0,1
    5436:	00000097          	auipc	ra,0x0
    543a:	3f8080e7          	jalr	1016(ra) # 582e <exit>
    543e:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5440:	00003597          	auipc	a1,0x3
    5444:	8f058593          	addi	a1,a1,-1808 # 7d30 <malloc+0x20c0>
    5448:	6488                	ld	a0,8(s1)
    544a:	00000097          	auipc	ra,0x0
    544e:	194080e7          	jalr	404(ra) # 55de <strcmp>
    5452:	10050563          	beqz	a0,555c <main+0x1d4>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5456:	00003597          	auipc	a1,0x3
    545a:	9c258593          	addi	a1,a1,-1598 # 7e18 <malloc+0x21a8>
    545e:	6488                	ld	a0,8(s1)
    5460:	00000097          	auipc	ra,0x0
    5464:	17e080e7          	jalr	382(ra) # 55de <strcmp>
    5468:	c97d                	beqz	a0,555e <main+0x1d6>
  } else if(argc == 2 && argv[1][0] != '-'){
    546a:	0084b903          	ld	s2,8(s1)
    546e:	00094703          	lbu	a4,0(s2)
    5472:	02d00793          	li	a5,45
    5476:	f2f71be3          	bne	a4,a5,53ac <main+0x24>
    printf("Usage: usertests [-c] [testname]\n");
    547a:	00003517          	auipc	a0,0x3
    547e:	8be50513          	addi	a0,a0,-1858 # 7d38 <malloc+0x20c8>
    5482:	00000097          	auipc	ra,0x0
    5486:	736080e7          	jalr	1846(ra) # 5bb8 <printf>
    exit(1);
    548a:	4505                	li	a0,1
    548c:	00000097          	auipc	ra,0x0
    5490:	3a2080e7          	jalr	930(ra) # 582e <exit>
          exit(1);
    5494:	4505                	li	a0,1
    5496:	00000097          	auipc	ra,0x0
    549a:	398080e7          	jalr	920(ra) # 582e <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    549e:	40a905bb          	subw	a1,s2,a0
    54a2:	855a                	mv	a0,s6
    54a4:	00000097          	auipc	ra,0x0
    54a8:	714080e7          	jalr	1812(ra) # 5bb8 <printf>
        if(continuous != 2)
    54ac:	09498463          	beq	s3,s4,5534 <main+0x1ac>
          exit(1);
    54b0:	4505                	li	a0,1
    54b2:	00000097          	auipc	ra,0x0
    54b6:	37c080e7          	jalr	892(ra) # 582e <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    54ba:	04c1                	addi	s1,s1,16
    54bc:	6488                	ld	a0,8(s1)
    54be:	c115                	beqz	a0,54e2 <main+0x15a>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    54c0:	00090863          	beqz	s2,54d0 <main+0x148>
    54c4:	85ca                	mv	a1,s2
    54c6:	00000097          	auipc	ra,0x0
    54ca:	118080e7          	jalr	280(ra) # 55de <strcmp>
    54ce:	f575                	bnez	a0,54ba <main+0x132>
      if(!run(t->f, t->s))
    54d0:	648c                	ld	a1,8(s1)
    54d2:	6088                	ld	a0,0(s1)
    54d4:	00000097          	auipc	ra,0x0
    54d8:	e16080e7          	jalr	-490(ra) # 52ea <run>
    54dc:	fd79                	bnez	a0,54ba <main+0x132>
        fail = 1;
    54de:	89d6                	mv	s3,s5
    54e0:	bfe9                	j	54ba <main+0x132>
  if(fail){
    54e2:	f20989e3          	beqz	s3,5414 <main+0x8c>
    printf("SOME TESTS FAILED\n");
    54e6:	00003517          	auipc	a0,0x3
    54ea:	89a50513          	addi	a0,a0,-1894 # 7d80 <malloc+0x2110>
    54ee:	00000097          	auipc	ra,0x0
    54f2:	6ca080e7          	jalr	1738(ra) # 5bb8 <printf>
    exit(1);
    54f6:	4505                	li	a0,1
    54f8:	00000097          	auipc	ra,0x0
    54fc:	336080e7          	jalr	822(ra) # 582e <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5500:	00003517          	auipc	a0,0x3
    5504:	8c850513          	addi	a0,a0,-1848 # 7dc8 <malloc+0x2158>
    5508:	00000097          	auipc	ra,0x0
    550c:	6b0080e7          	jalr	1712(ra) # 5bb8 <printf>
    exit(0);
    5510:	4501                	li	a0,0
    5512:	00000097          	auipc	ra,0x0
    5516:	31c080e7          	jalr	796(ra) # 582e <exit>
        printf("SOME TESTS FAILED\n");
    551a:	8556                	mv	a0,s5
    551c:	00000097          	auipc	ra,0x0
    5520:	69c080e7          	jalr	1692(ra) # 5bb8 <printf>
        if(continuous != 2)
    5524:	f74998e3          	bne	s3,s4,5494 <main+0x10c>
      int free1 = countfree();
    5528:	00000097          	auipc	ra,0x0
    552c:	c92080e7          	jalr	-878(ra) # 51ba <countfree>
      if(free1 < free0){
    5530:	f72547e3          	blt	a0,s2,549e <main+0x116>
      int free0 = countfree();
    5534:	00000097          	auipc	ra,0x0
    5538:	c86080e7          	jalr	-890(ra) # 51ba <countfree>
    553c:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    553e:	e1843583          	ld	a1,-488(s0)
    5542:	d1fd                	beqz	a1,5528 <main+0x1a0>
    5544:	e1040493          	addi	s1,s0,-496
        if(!run(t->f, t->s)){
    5548:	6088                	ld	a0,0(s1)
    554a:	00000097          	auipc	ra,0x0
    554e:	da0080e7          	jalr	-608(ra) # 52ea <run>
    5552:	d561                	beqz	a0,551a <main+0x192>
      for (struct test *t = tests; t->s != 0; t++) {
    5554:	04c1                	addi	s1,s1,16
    5556:	648c                	ld	a1,8(s1)
    5558:	f9e5                	bnez	a1,5548 <main+0x1c0>
    555a:	b7f9                	j	5528 <main+0x1a0>
    continuous = 1;
    555c:	4985                	li	s3,1
  } tests[] = {
    555e:	00003797          	auipc	a5,0x3
    5562:	a2278793          	addi	a5,a5,-1502 # 7f80 <malloc+0x2310>
    5566:	e1040713          	addi	a4,s0,-496
    556a:	00003317          	auipc	t1,0x3
    556e:	bc630313          	addi	t1,t1,-1082 # 8130 <malloc+0x24c0>
    5572:	0007b883          	ld	a7,0(a5)
    5576:	0087b803          	ld	a6,8(a5)
    557a:	6b88                	ld	a0,16(a5)
    557c:	6f8c                	ld	a1,24(a5)
    557e:	7390                	ld	a2,32(a5)
    5580:	7794                	ld	a3,40(a5)
    5582:	01173023          	sd	a7,0(a4)
    5586:	01073423          	sd	a6,8(a4)
    558a:	eb08                	sd	a0,16(a4)
    558c:	ef0c                	sd	a1,24(a4)
    558e:	f310                	sd	a2,32(a4)
    5590:	f714                	sd	a3,40(a4)
    5592:	03078793          	addi	a5,a5,48
    5596:	03070713          	addi	a4,a4,48
    559a:	fc679ce3          	bne	a5,t1,5572 <main+0x1ea>
    printf("continuous usertests starting\n");
    559e:	00003517          	auipc	a0,0x3
    55a2:	85a50513          	addi	a0,a0,-1958 # 7df8 <malloc+0x2188>
    55a6:	00000097          	auipc	ra,0x0
    55aa:	612080e7          	jalr	1554(ra) # 5bb8 <printf>
        printf("SOME TESTS FAILED\n");
    55ae:	00002a97          	auipc	s5,0x2
    55b2:	7d2a8a93          	addi	s5,s5,2002 # 7d80 <malloc+0x2110>
        if(continuous != 2)
    55b6:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    55b8:	00002b17          	auipc	s6,0x2
    55bc:	7a8b0b13          	addi	s6,s6,1960 # 7d60 <malloc+0x20f0>
    55c0:	bf95                	j	5534 <main+0x1ac>

00000000000055c2 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    55c2:	1141                	addi	sp,sp,-16
    55c4:	e422                	sd	s0,8(sp)
    55c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    55c8:	87aa                	mv	a5,a0
    55ca:	0585                	addi	a1,a1,1
    55cc:	0785                	addi	a5,a5,1
    55ce:	fff5c703          	lbu	a4,-1(a1)
    55d2:	fee78fa3          	sb	a4,-1(a5)
    55d6:	fb75                	bnez	a4,55ca <strcpy+0x8>
    ;
  return os;
}
    55d8:	6422                	ld	s0,8(sp)
    55da:	0141                	addi	sp,sp,16
    55dc:	8082                	ret

00000000000055de <strcmp>:

int
strcmp(const char *p, const char *q)
{
    55de:	1141                	addi	sp,sp,-16
    55e0:	e422                	sd	s0,8(sp)
    55e2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    55e4:	00054783          	lbu	a5,0(a0)
    55e8:	cb91                	beqz	a5,55fc <strcmp+0x1e>
    55ea:	0005c703          	lbu	a4,0(a1)
    55ee:	00f71763          	bne	a4,a5,55fc <strcmp+0x1e>
    p++, q++;
    55f2:	0505                	addi	a0,a0,1
    55f4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    55f6:	00054783          	lbu	a5,0(a0)
    55fa:	fbe5                	bnez	a5,55ea <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    55fc:	0005c503          	lbu	a0,0(a1)
}
    5600:	40a7853b          	subw	a0,a5,a0
    5604:	6422                	ld	s0,8(sp)
    5606:	0141                	addi	sp,sp,16
    5608:	8082                	ret

000000000000560a <strlen>:

uint
strlen(const char *s)
{
    560a:	1141                	addi	sp,sp,-16
    560c:	e422                	sd	s0,8(sp)
    560e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5610:	00054783          	lbu	a5,0(a0)
    5614:	cf91                	beqz	a5,5630 <strlen+0x26>
    5616:	0505                	addi	a0,a0,1
    5618:	87aa                	mv	a5,a0
    561a:	4685                	li	a3,1
    561c:	9e89                	subw	a3,a3,a0
    561e:	00f6853b          	addw	a0,a3,a5
    5622:	0785                	addi	a5,a5,1
    5624:	fff7c703          	lbu	a4,-1(a5)
    5628:	fb7d                	bnez	a4,561e <strlen+0x14>
    ;
  return n;
}
    562a:	6422                	ld	s0,8(sp)
    562c:	0141                	addi	sp,sp,16
    562e:	8082                	ret
  for(n = 0; s[n]; n++)
    5630:	4501                	li	a0,0
    5632:	bfe5                	j	562a <strlen+0x20>

0000000000005634 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5634:	1141                	addi	sp,sp,-16
    5636:	e422                	sd	s0,8(sp)
    5638:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    563a:	ca19                	beqz	a2,5650 <memset+0x1c>
    563c:	87aa                	mv	a5,a0
    563e:	1602                	slli	a2,a2,0x20
    5640:	9201                	srli	a2,a2,0x20
    5642:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5646:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    564a:	0785                	addi	a5,a5,1
    564c:	fee79de3          	bne	a5,a4,5646 <memset+0x12>
  }
  return dst;
}
    5650:	6422                	ld	s0,8(sp)
    5652:	0141                	addi	sp,sp,16
    5654:	8082                	ret

0000000000005656 <strchr>:

char*
strchr(const char *s, char c)
{
    5656:	1141                	addi	sp,sp,-16
    5658:	e422                	sd	s0,8(sp)
    565a:	0800                	addi	s0,sp,16
  for(; *s; s++)
    565c:	00054783          	lbu	a5,0(a0)
    5660:	cb99                	beqz	a5,5676 <strchr+0x20>
    if(*s == c)
    5662:	00f58763          	beq	a1,a5,5670 <strchr+0x1a>
  for(; *s; s++)
    5666:	0505                	addi	a0,a0,1
    5668:	00054783          	lbu	a5,0(a0)
    566c:	fbfd                	bnez	a5,5662 <strchr+0xc>
      return (char*)s;
  return 0;
    566e:	4501                	li	a0,0
}
    5670:	6422                	ld	s0,8(sp)
    5672:	0141                	addi	sp,sp,16
    5674:	8082                	ret
  return 0;
    5676:	4501                	li	a0,0
    5678:	bfe5                	j	5670 <strchr+0x1a>

000000000000567a <gets>:

char*
gets(char *buf, int max)
{
    567a:	711d                	addi	sp,sp,-96
    567c:	ec86                	sd	ra,88(sp)
    567e:	e8a2                	sd	s0,80(sp)
    5680:	e4a6                	sd	s1,72(sp)
    5682:	e0ca                	sd	s2,64(sp)
    5684:	fc4e                	sd	s3,56(sp)
    5686:	f852                	sd	s4,48(sp)
    5688:	f456                	sd	s5,40(sp)
    568a:	f05a                	sd	s6,32(sp)
    568c:	ec5e                	sd	s7,24(sp)
    568e:	1080                	addi	s0,sp,96
    5690:	8baa                	mv	s7,a0
    5692:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5694:	892a                	mv	s2,a0
    5696:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5698:	4aa9                	li	s5,10
    569a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    569c:	89a6                	mv	s3,s1
    569e:	2485                	addiw	s1,s1,1
    56a0:	0344d863          	bge	s1,s4,56d0 <gets+0x56>
    cc = read(0, &c, 1);
    56a4:	4605                	li	a2,1
    56a6:	faf40593          	addi	a1,s0,-81
    56aa:	4501                	li	a0,0
    56ac:	00000097          	auipc	ra,0x0
    56b0:	19a080e7          	jalr	410(ra) # 5846 <read>
    if(cc < 1)
    56b4:	00a05e63          	blez	a0,56d0 <gets+0x56>
    buf[i++] = c;
    56b8:	faf44783          	lbu	a5,-81(s0)
    56bc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    56c0:	01578763          	beq	a5,s5,56ce <gets+0x54>
    56c4:	0905                	addi	s2,s2,1
    56c6:	fd679be3          	bne	a5,s6,569c <gets+0x22>
  for(i=0; i+1 < max; ){
    56ca:	89a6                	mv	s3,s1
    56cc:	a011                	j	56d0 <gets+0x56>
    56ce:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    56d0:	99de                	add	s3,s3,s7
    56d2:	00098023          	sb	zero,0(s3)
  return buf;
}
    56d6:	855e                	mv	a0,s7
    56d8:	60e6                	ld	ra,88(sp)
    56da:	6446                	ld	s0,80(sp)
    56dc:	64a6                	ld	s1,72(sp)
    56de:	6906                	ld	s2,64(sp)
    56e0:	79e2                	ld	s3,56(sp)
    56e2:	7a42                	ld	s4,48(sp)
    56e4:	7aa2                	ld	s5,40(sp)
    56e6:	7b02                	ld	s6,32(sp)
    56e8:	6be2                	ld	s7,24(sp)
    56ea:	6125                	addi	sp,sp,96
    56ec:	8082                	ret

00000000000056ee <stat>:

int
stat(const char *n, struct stat *st)
{
    56ee:	1101                	addi	sp,sp,-32
    56f0:	ec06                	sd	ra,24(sp)
    56f2:	e822                	sd	s0,16(sp)
    56f4:	e426                	sd	s1,8(sp)
    56f6:	e04a                	sd	s2,0(sp)
    56f8:	1000                	addi	s0,sp,32
    56fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    56fc:	4581                	li	a1,0
    56fe:	00000097          	auipc	ra,0x0
    5702:	170080e7          	jalr	368(ra) # 586e <open>
  if(fd < 0)
    5706:	02054563          	bltz	a0,5730 <stat+0x42>
    570a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    570c:	85ca                	mv	a1,s2
    570e:	00000097          	auipc	ra,0x0
    5712:	178080e7          	jalr	376(ra) # 5886 <fstat>
    5716:	892a                	mv	s2,a0
  close(fd);
    5718:	8526                	mv	a0,s1
    571a:	00000097          	auipc	ra,0x0
    571e:	13c080e7          	jalr	316(ra) # 5856 <close>
  return r;
}
    5722:	854a                	mv	a0,s2
    5724:	60e2                	ld	ra,24(sp)
    5726:	6442                	ld	s0,16(sp)
    5728:	64a2                	ld	s1,8(sp)
    572a:	6902                	ld	s2,0(sp)
    572c:	6105                	addi	sp,sp,32
    572e:	8082                	ret
    return -1;
    5730:	597d                	li	s2,-1
    5732:	bfc5                	j	5722 <stat+0x34>

0000000000005734 <atoi>:

int
atoi(const char *s)
{
    5734:	1141                	addi	sp,sp,-16
    5736:	e422                	sd	s0,8(sp)
    5738:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    573a:	00054683          	lbu	a3,0(a0)
    573e:	fd06879b          	addiw	a5,a3,-48
    5742:	0ff7f793          	zext.b	a5,a5
    5746:	4625                	li	a2,9
    5748:	02f66863          	bltu	a2,a5,5778 <atoi+0x44>
    574c:	872a                	mv	a4,a0
  n = 0;
    574e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5750:	0705                	addi	a4,a4,1
    5752:	0025179b          	slliw	a5,a0,0x2
    5756:	9fa9                	addw	a5,a5,a0
    5758:	0017979b          	slliw	a5,a5,0x1
    575c:	9fb5                	addw	a5,a5,a3
    575e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5762:	00074683          	lbu	a3,0(a4)
    5766:	fd06879b          	addiw	a5,a3,-48
    576a:	0ff7f793          	zext.b	a5,a5
    576e:	fef671e3          	bgeu	a2,a5,5750 <atoi+0x1c>
  return n;
}
    5772:	6422                	ld	s0,8(sp)
    5774:	0141                	addi	sp,sp,16
    5776:	8082                	ret
  n = 0;
    5778:	4501                	li	a0,0
    577a:	bfe5                	j	5772 <atoi+0x3e>

000000000000577c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    577c:	1141                	addi	sp,sp,-16
    577e:	e422                	sd	s0,8(sp)
    5780:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5782:	02b57463          	bgeu	a0,a1,57aa <memmove+0x2e>
    while(n-- > 0)
    5786:	00c05f63          	blez	a2,57a4 <memmove+0x28>
    578a:	1602                	slli	a2,a2,0x20
    578c:	9201                	srli	a2,a2,0x20
    578e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5792:	872a                	mv	a4,a0
      *dst++ = *src++;
    5794:	0585                	addi	a1,a1,1
    5796:	0705                	addi	a4,a4,1
    5798:	fff5c683          	lbu	a3,-1(a1)
    579c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    57a0:	fee79ae3          	bne	a5,a4,5794 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    57a4:	6422                	ld	s0,8(sp)
    57a6:	0141                	addi	sp,sp,16
    57a8:	8082                	ret
    dst += n;
    57aa:	00c50733          	add	a4,a0,a2
    src += n;
    57ae:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    57b0:	fec05ae3          	blez	a2,57a4 <memmove+0x28>
    57b4:	fff6079b          	addiw	a5,a2,-1 # 2fff <sharedfd+0x173>
    57b8:	1782                	slli	a5,a5,0x20
    57ba:	9381                	srli	a5,a5,0x20
    57bc:	fff7c793          	not	a5,a5
    57c0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    57c2:	15fd                	addi	a1,a1,-1
    57c4:	177d                	addi	a4,a4,-1
    57c6:	0005c683          	lbu	a3,0(a1)
    57ca:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    57ce:	fee79ae3          	bne	a5,a4,57c2 <memmove+0x46>
    57d2:	bfc9                	j	57a4 <memmove+0x28>

00000000000057d4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    57d4:	1141                	addi	sp,sp,-16
    57d6:	e422                	sd	s0,8(sp)
    57d8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    57da:	ca05                	beqz	a2,580a <memcmp+0x36>
    57dc:	fff6069b          	addiw	a3,a2,-1
    57e0:	1682                	slli	a3,a3,0x20
    57e2:	9281                	srli	a3,a3,0x20
    57e4:	0685                	addi	a3,a3,1
    57e6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    57e8:	00054783          	lbu	a5,0(a0)
    57ec:	0005c703          	lbu	a4,0(a1)
    57f0:	00e79863          	bne	a5,a4,5800 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    57f4:	0505                	addi	a0,a0,1
    p2++;
    57f6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    57f8:	fed518e3          	bne	a0,a3,57e8 <memcmp+0x14>
  }
  return 0;
    57fc:	4501                	li	a0,0
    57fe:	a019                	j	5804 <memcmp+0x30>
      return *p1 - *p2;
    5800:	40e7853b          	subw	a0,a5,a4
}
    5804:	6422                	ld	s0,8(sp)
    5806:	0141                	addi	sp,sp,16
    5808:	8082                	ret
  return 0;
    580a:	4501                	li	a0,0
    580c:	bfe5                	j	5804 <memcmp+0x30>

000000000000580e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    580e:	1141                	addi	sp,sp,-16
    5810:	e406                	sd	ra,8(sp)
    5812:	e022                	sd	s0,0(sp)
    5814:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5816:	00000097          	auipc	ra,0x0
    581a:	f66080e7          	jalr	-154(ra) # 577c <memmove>
}
    581e:	60a2                	ld	ra,8(sp)
    5820:	6402                	ld	s0,0(sp)
    5822:	0141                	addi	sp,sp,16
    5824:	8082                	ret

0000000000005826 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5826:	4885                	li	a7,1
 ecall
    5828:	00000073          	ecall
 ret
    582c:	8082                	ret

000000000000582e <exit>:
.global exit
exit:
 li a7, SYS_exit
    582e:	4889                	li	a7,2
 ecall
    5830:	00000073          	ecall
 ret
    5834:	8082                	ret

0000000000005836 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5836:	488d                	li	a7,3
 ecall
    5838:	00000073          	ecall
 ret
    583c:	8082                	ret

000000000000583e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    583e:	4891                	li	a7,4
 ecall
    5840:	00000073          	ecall
 ret
    5844:	8082                	ret

0000000000005846 <read>:
.global read
read:
 li a7, SYS_read
    5846:	4895                	li	a7,5
 ecall
    5848:	00000073          	ecall
 ret
    584c:	8082                	ret

000000000000584e <write>:
.global write
write:
 li a7, SYS_write
    584e:	48c1                	li	a7,16
 ecall
    5850:	00000073          	ecall
 ret
    5854:	8082                	ret

0000000000005856 <close>:
.global close
close:
 li a7, SYS_close
    5856:	48d5                	li	a7,21
 ecall
    5858:	00000073          	ecall
 ret
    585c:	8082                	ret

000000000000585e <kill>:
.global kill
kill:
 li a7, SYS_kill
    585e:	4899                	li	a7,6
 ecall
    5860:	00000073          	ecall
 ret
    5864:	8082                	ret

0000000000005866 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5866:	489d                	li	a7,7
 ecall
    5868:	00000073          	ecall
 ret
    586c:	8082                	ret

000000000000586e <open>:
.global open
open:
 li a7, SYS_open
    586e:	48bd                	li	a7,15
 ecall
    5870:	00000073          	ecall
 ret
    5874:	8082                	ret

0000000000005876 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5876:	48c5                	li	a7,17
 ecall
    5878:	00000073          	ecall
 ret
    587c:	8082                	ret

000000000000587e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    587e:	48c9                	li	a7,18
 ecall
    5880:	00000073          	ecall
 ret
    5884:	8082                	ret

0000000000005886 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5886:	48a1                	li	a7,8
 ecall
    5888:	00000073          	ecall
 ret
    588c:	8082                	ret

000000000000588e <link>:
.global link
link:
 li a7, SYS_link
    588e:	48cd                	li	a7,19
 ecall
    5890:	00000073          	ecall
 ret
    5894:	8082                	ret

0000000000005896 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5896:	48d1                	li	a7,20
 ecall
    5898:	00000073          	ecall
 ret
    589c:	8082                	ret

000000000000589e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    589e:	48a5                	li	a7,9
 ecall
    58a0:	00000073          	ecall
 ret
    58a4:	8082                	ret

00000000000058a6 <dup>:
.global dup
dup:
 li a7, SYS_dup
    58a6:	48a9                	li	a7,10
 ecall
    58a8:	00000073          	ecall
 ret
    58ac:	8082                	ret

00000000000058ae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    58ae:	48ad                	li	a7,11
 ecall
    58b0:	00000073          	ecall
 ret
    58b4:	8082                	ret

00000000000058b6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    58b6:	48b1                	li	a7,12
 ecall
    58b8:	00000073          	ecall
 ret
    58bc:	8082                	ret

00000000000058be <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    58be:	48b5                	li	a7,13
 ecall
    58c0:	00000073          	ecall
 ret
    58c4:	8082                	ret

00000000000058c6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    58c6:	48b9                	li	a7,14
 ecall
    58c8:	00000073          	ecall
 ret
    58cc:	8082                	ret

00000000000058ce <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
    58ce:	48d9                	li	a7,22
 ecall
    58d0:	00000073          	ecall
 ret
    58d4:	8082                	ret

00000000000058d6 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
    58d6:	48dd                	li	a7,23
 ecall
    58d8:	00000073          	ecall
 ret
    58dc:	8082                	ret

00000000000058de <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    58de:	1101                	addi	sp,sp,-32
    58e0:	ec06                	sd	ra,24(sp)
    58e2:	e822                	sd	s0,16(sp)
    58e4:	1000                	addi	s0,sp,32
    58e6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    58ea:	4605                	li	a2,1
    58ec:	fef40593          	addi	a1,s0,-17
    58f0:	00000097          	auipc	ra,0x0
    58f4:	f5e080e7          	jalr	-162(ra) # 584e <write>
}
    58f8:	60e2                	ld	ra,24(sp)
    58fa:	6442                	ld	s0,16(sp)
    58fc:	6105                	addi	sp,sp,32
    58fe:	8082                	ret

0000000000005900 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5900:	7139                	addi	sp,sp,-64
    5902:	fc06                	sd	ra,56(sp)
    5904:	f822                	sd	s0,48(sp)
    5906:	f426                	sd	s1,40(sp)
    5908:	f04a                	sd	s2,32(sp)
    590a:	ec4e                	sd	s3,24(sp)
    590c:	0080                	addi	s0,sp,64
    590e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5910:	c299                	beqz	a3,5916 <printint+0x16>
    5912:	0805c963          	bltz	a1,59a4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5916:	2581                	sext.w	a1,a1
  neg = 0;
    5918:	4881                	li	a7,0
    591a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    591e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5920:	2601                	sext.w	a2,a2
    5922:	00003517          	auipc	a0,0x3
    5926:	86e50513          	addi	a0,a0,-1938 # 8190 <digits>
    592a:	883a                	mv	a6,a4
    592c:	2705                	addiw	a4,a4,1
    592e:	02c5f7bb          	remuw	a5,a1,a2
    5932:	1782                	slli	a5,a5,0x20
    5934:	9381                	srli	a5,a5,0x20
    5936:	97aa                	add	a5,a5,a0
    5938:	0007c783          	lbu	a5,0(a5)
    593c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5940:	0005879b          	sext.w	a5,a1
    5944:	02c5d5bb          	divuw	a1,a1,a2
    5948:	0685                	addi	a3,a3,1
    594a:	fec7f0e3          	bgeu	a5,a2,592a <printint+0x2a>
  if(neg)
    594e:	00088c63          	beqz	a7,5966 <printint+0x66>
    buf[i++] = '-';
    5952:	fd070793          	addi	a5,a4,-48
    5956:	00878733          	add	a4,a5,s0
    595a:	02d00793          	li	a5,45
    595e:	fef70823          	sb	a5,-16(a4)
    5962:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5966:	02e05863          	blez	a4,5996 <printint+0x96>
    596a:	fc040793          	addi	a5,s0,-64
    596e:	00e78933          	add	s2,a5,a4
    5972:	fff78993          	addi	s3,a5,-1
    5976:	99ba                	add	s3,s3,a4
    5978:	377d                	addiw	a4,a4,-1
    597a:	1702                	slli	a4,a4,0x20
    597c:	9301                	srli	a4,a4,0x20
    597e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5982:	fff94583          	lbu	a1,-1(s2)
    5986:	8526                	mv	a0,s1
    5988:	00000097          	auipc	ra,0x0
    598c:	f56080e7          	jalr	-170(ra) # 58de <putc>
  while(--i >= 0)
    5990:	197d                	addi	s2,s2,-1
    5992:	ff3918e3          	bne	s2,s3,5982 <printint+0x82>
}
    5996:	70e2                	ld	ra,56(sp)
    5998:	7442                	ld	s0,48(sp)
    599a:	74a2                	ld	s1,40(sp)
    599c:	7902                	ld	s2,32(sp)
    599e:	69e2                	ld	s3,24(sp)
    59a0:	6121                	addi	sp,sp,64
    59a2:	8082                	ret
    x = -xx;
    59a4:	40b005bb          	negw	a1,a1
    neg = 1;
    59a8:	4885                	li	a7,1
    x = -xx;
    59aa:	bf85                	j	591a <printint+0x1a>

00000000000059ac <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    59ac:	7119                	addi	sp,sp,-128
    59ae:	fc86                	sd	ra,120(sp)
    59b0:	f8a2                	sd	s0,112(sp)
    59b2:	f4a6                	sd	s1,104(sp)
    59b4:	f0ca                	sd	s2,96(sp)
    59b6:	ecce                	sd	s3,88(sp)
    59b8:	e8d2                	sd	s4,80(sp)
    59ba:	e4d6                	sd	s5,72(sp)
    59bc:	e0da                	sd	s6,64(sp)
    59be:	fc5e                	sd	s7,56(sp)
    59c0:	f862                	sd	s8,48(sp)
    59c2:	f466                	sd	s9,40(sp)
    59c4:	f06a                	sd	s10,32(sp)
    59c6:	ec6e                	sd	s11,24(sp)
    59c8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    59ca:	0005c903          	lbu	s2,0(a1)
    59ce:	18090f63          	beqz	s2,5b6c <vprintf+0x1c0>
    59d2:	8aaa                	mv	s5,a0
    59d4:	8b32                	mv	s6,a2
    59d6:	00158493          	addi	s1,a1,1
  state = 0;
    59da:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    59dc:	02500a13          	li	s4,37
    59e0:	4c55                	li	s8,21
    59e2:	00002c97          	auipc	s9,0x2
    59e6:	756c8c93          	addi	s9,s9,1878 # 8138 <malloc+0x24c8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    59ea:	02800d93          	li	s11,40
  putc(fd, 'x');
    59ee:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    59f0:	00002b97          	auipc	s7,0x2
    59f4:	7a0b8b93          	addi	s7,s7,1952 # 8190 <digits>
    59f8:	a839                	j	5a16 <vprintf+0x6a>
        putc(fd, c);
    59fa:	85ca                	mv	a1,s2
    59fc:	8556                	mv	a0,s5
    59fe:	00000097          	auipc	ra,0x0
    5a02:	ee0080e7          	jalr	-288(ra) # 58de <putc>
    5a06:	a019                	j	5a0c <vprintf+0x60>
    } else if(state == '%'){
    5a08:	01498d63          	beq	s3,s4,5a22 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    5a0c:	0485                	addi	s1,s1,1
    5a0e:	fff4c903          	lbu	s2,-1(s1)
    5a12:	14090d63          	beqz	s2,5b6c <vprintf+0x1c0>
    if(state == 0){
    5a16:	fe0999e3          	bnez	s3,5a08 <vprintf+0x5c>
      if(c == '%'){
    5a1a:	ff4910e3          	bne	s2,s4,59fa <vprintf+0x4e>
        state = '%';
    5a1e:	89d2                	mv	s3,s4
    5a20:	b7f5                	j	5a0c <vprintf+0x60>
      if(c == 'd'){
    5a22:	11490c63          	beq	s2,s4,5b3a <vprintf+0x18e>
    5a26:	f9d9079b          	addiw	a5,s2,-99
    5a2a:	0ff7f793          	zext.b	a5,a5
    5a2e:	10fc6e63          	bltu	s8,a5,5b4a <vprintf+0x19e>
    5a32:	f9d9079b          	addiw	a5,s2,-99
    5a36:	0ff7f713          	zext.b	a4,a5
    5a3a:	10ec6863          	bltu	s8,a4,5b4a <vprintf+0x19e>
    5a3e:	00271793          	slli	a5,a4,0x2
    5a42:	97e6                	add	a5,a5,s9
    5a44:	439c                	lw	a5,0(a5)
    5a46:	97e6                	add	a5,a5,s9
    5a48:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5a4a:	008b0913          	addi	s2,s6,8
    5a4e:	4685                	li	a3,1
    5a50:	4629                	li	a2,10
    5a52:	000b2583          	lw	a1,0(s6)
    5a56:	8556                	mv	a0,s5
    5a58:	00000097          	auipc	ra,0x0
    5a5c:	ea8080e7          	jalr	-344(ra) # 5900 <printint>
    5a60:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5a62:	4981                	li	s3,0
    5a64:	b765                	j	5a0c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a66:	008b0913          	addi	s2,s6,8
    5a6a:	4681                	li	a3,0
    5a6c:	4629                	li	a2,10
    5a6e:	000b2583          	lw	a1,0(s6)
    5a72:	8556                	mv	a0,s5
    5a74:	00000097          	auipc	ra,0x0
    5a78:	e8c080e7          	jalr	-372(ra) # 5900 <printint>
    5a7c:	8b4a                	mv	s6,s2
      state = 0;
    5a7e:	4981                	li	s3,0
    5a80:	b771                	j	5a0c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5a82:	008b0913          	addi	s2,s6,8
    5a86:	4681                	li	a3,0
    5a88:	866a                	mv	a2,s10
    5a8a:	000b2583          	lw	a1,0(s6)
    5a8e:	8556                	mv	a0,s5
    5a90:	00000097          	auipc	ra,0x0
    5a94:	e70080e7          	jalr	-400(ra) # 5900 <printint>
    5a98:	8b4a                	mv	s6,s2
      state = 0;
    5a9a:	4981                	li	s3,0
    5a9c:	bf85                	j	5a0c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5a9e:	008b0793          	addi	a5,s6,8
    5aa2:	f8f43423          	sd	a5,-120(s0)
    5aa6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5aaa:	03000593          	li	a1,48
    5aae:	8556                	mv	a0,s5
    5ab0:	00000097          	auipc	ra,0x0
    5ab4:	e2e080e7          	jalr	-466(ra) # 58de <putc>
  putc(fd, 'x');
    5ab8:	07800593          	li	a1,120
    5abc:	8556                	mv	a0,s5
    5abe:	00000097          	auipc	ra,0x0
    5ac2:	e20080e7          	jalr	-480(ra) # 58de <putc>
    5ac6:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5ac8:	03c9d793          	srli	a5,s3,0x3c
    5acc:	97de                	add	a5,a5,s7
    5ace:	0007c583          	lbu	a1,0(a5)
    5ad2:	8556                	mv	a0,s5
    5ad4:	00000097          	auipc	ra,0x0
    5ad8:	e0a080e7          	jalr	-502(ra) # 58de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5adc:	0992                	slli	s3,s3,0x4
    5ade:	397d                	addiw	s2,s2,-1
    5ae0:	fe0914e3          	bnez	s2,5ac8 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    5ae4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5ae8:	4981                	li	s3,0
    5aea:	b70d                	j	5a0c <vprintf+0x60>
        s = va_arg(ap, char*);
    5aec:	008b0913          	addi	s2,s6,8
    5af0:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    5af4:	02098163          	beqz	s3,5b16 <vprintf+0x16a>
        while(*s != 0){
    5af8:	0009c583          	lbu	a1,0(s3)
    5afc:	c5ad                	beqz	a1,5b66 <vprintf+0x1ba>
          putc(fd, *s);
    5afe:	8556                	mv	a0,s5
    5b00:	00000097          	auipc	ra,0x0
    5b04:	dde080e7          	jalr	-546(ra) # 58de <putc>
          s++;
    5b08:	0985                	addi	s3,s3,1
        while(*s != 0){
    5b0a:	0009c583          	lbu	a1,0(s3)
    5b0e:	f9e5                	bnez	a1,5afe <vprintf+0x152>
        s = va_arg(ap, char*);
    5b10:	8b4a                	mv	s6,s2
      state = 0;
    5b12:	4981                	li	s3,0
    5b14:	bde5                	j	5a0c <vprintf+0x60>
          s = "(null)";
    5b16:	00002997          	auipc	s3,0x2
    5b1a:	61a98993          	addi	s3,s3,1562 # 8130 <malloc+0x24c0>
        while(*s != 0){
    5b1e:	85ee                	mv	a1,s11
    5b20:	bff9                	j	5afe <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    5b22:	008b0913          	addi	s2,s6,8
    5b26:	000b4583          	lbu	a1,0(s6)
    5b2a:	8556                	mv	a0,s5
    5b2c:	00000097          	auipc	ra,0x0
    5b30:	db2080e7          	jalr	-590(ra) # 58de <putc>
    5b34:	8b4a                	mv	s6,s2
      state = 0;
    5b36:	4981                	li	s3,0
    5b38:	bdd1                	j	5a0c <vprintf+0x60>
        putc(fd, c);
    5b3a:	85d2                	mv	a1,s4
    5b3c:	8556                	mv	a0,s5
    5b3e:	00000097          	auipc	ra,0x0
    5b42:	da0080e7          	jalr	-608(ra) # 58de <putc>
      state = 0;
    5b46:	4981                	li	s3,0
    5b48:	b5d1                	j	5a0c <vprintf+0x60>
        putc(fd, '%');
    5b4a:	85d2                	mv	a1,s4
    5b4c:	8556                	mv	a0,s5
    5b4e:	00000097          	auipc	ra,0x0
    5b52:	d90080e7          	jalr	-624(ra) # 58de <putc>
        putc(fd, c);
    5b56:	85ca                	mv	a1,s2
    5b58:	8556                	mv	a0,s5
    5b5a:	00000097          	auipc	ra,0x0
    5b5e:	d84080e7          	jalr	-636(ra) # 58de <putc>
      state = 0;
    5b62:	4981                	li	s3,0
    5b64:	b565                	j	5a0c <vprintf+0x60>
        s = va_arg(ap, char*);
    5b66:	8b4a                	mv	s6,s2
      state = 0;
    5b68:	4981                	li	s3,0
    5b6a:	b54d                	j	5a0c <vprintf+0x60>
    }
  }
}
    5b6c:	70e6                	ld	ra,120(sp)
    5b6e:	7446                	ld	s0,112(sp)
    5b70:	74a6                	ld	s1,104(sp)
    5b72:	7906                	ld	s2,96(sp)
    5b74:	69e6                	ld	s3,88(sp)
    5b76:	6a46                	ld	s4,80(sp)
    5b78:	6aa6                	ld	s5,72(sp)
    5b7a:	6b06                	ld	s6,64(sp)
    5b7c:	7be2                	ld	s7,56(sp)
    5b7e:	7c42                	ld	s8,48(sp)
    5b80:	7ca2                	ld	s9,40(sp)
    5b82:	7d02                	ld	s10,32(sp)
    5b84:	6de2                	ld	s11,24(sp)
    5b86:	6109                	addi	sp,sp,128
    5b88:	8082                	ret

0000000000005b8a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5b8a:	715d                	addi	sp,sp,-80
    5b8c:	ec06                	sd	ra,24(sp)
    5b8e:	e822                	sd	s0,16(sp)
    5b90:	1000                	addi	s0,sp,32
    5b92:	e010                	sd	a2,0(s0)
    5b94:	e414                	sd	a3,8(s0)
    5b96:	e818                	sd	a4,16(s0)
    5b98:	ec1c                	sd	a5,24(s0)
    5b9a:	03043023          	sd	a6,32(s0)
    5b9e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5ba2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5ba6:	8622                	mv	a2,s0
    5ba8:	00000097          	auipc	ra,0x0
    5bac:	e04080e7          	jalr	-508(ra) # 59ac <vprintf>
}
    5bb0:	60e2                	ld	ra,24(sp)
    5bb2:	6442                	ld	s0,16(sp)
    5bb4:	6161                	addi	sp,sp,80
    5bb6:	8082                	ret

0000000000005bb8 <printf>:

void
printf(const char *fmt, ...)
{
    5bb8:	711d                	addi	sp,sp,-96
    5bba:	ec06                	sd	ra,24(sp)
    5bbc:	e822                	sd	s0,16(sp)
    5bbe:	1000                	addi	s0,sp,32
    5bc0:	e40c                	sd	a1,8(s0)
    5bc2:	e810                	sd	a2,16(s0)
    5bc4:	ec14                	sd	a3,24(s0)
    5bc6:	f018                	sd	a4,32(s0)
    5bc8:	f41c                	sd	a5,40(s0)
    5bca:	03043823          	sd	a6,48(s0)
    5bce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5bd2:	00840613          	addi	a2,s0,8
    5bd6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5bda:	85aa                	mv	a1,a0
    5bdc:	4505                	li	a0,1
    5bde:	00000097          	auipc	ra,0x0
    5be2:	dce080e7          	jalr	-562(ra) # 59ac <vprintf>
}
    5be6:	60e2                	ld	ra,24(sp)
    5be8:	6442                	ld	s0,16(sp)
    5bea:	6125                	addi	sp,sp,96
    5bec:	8082                	ret

0000000000005bee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5bee:	1141                	addi	sp,sp,-16
    5bf0:	e422                	sd	s0,8(sp)
    5bf2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5bf4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5bf8:	00002797          	auipc	a5,0x2
    5bfc:	5b87b783          	ld	a5,1464(a5) # 81b0 <freep>
    5c00:	a02d                	j	5c2a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5c02:	4618                	lw	a4,8(a2)
    5c04:	9f2d                	addw	a4,a4,a1
    5c06:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5c0a:	6398                	ld	a4,0(a5)
    5c0c:	6310                	ld	a2,0(a4)
    5c0e:	a83d                	j	5c4c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5c10:	ff852703          	lw	a4,-8(a0)
    5c14:	9f31                	addw	a4,a4,a2
    5c16:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5c18:	ff053683          	ld	a3,-16(a0)
    5c1c:	a091                	j	5c60 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c1e:	6398                	ld	a4,0(a5)
    5c20:	00e7e463          	bltu	a5,a4,5c28 <free+0x3a>
    5c24:	00e6ea63          	bltu	a3,a4,5c38 <free+0x4a>
{
    5c28:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c2a:	fed7fae3          	bgeu	a5,a3,5c1e <free+0x30>
    5c2e:	6398                	ld	a4,0(a5)
    5c30:	00e6e463          	bltu	a3,a4,5c38 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c34:	fee7eae3          	bltu	a5,a4,5c28 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5c38:	ff852583          	lw	a1,-8(a0)
    5c3c:	6390                	ld	a2,0(a5)
    5c3e:	02059813          	slli	a6,a1,0x20
    5c42:	01c85713          	srli	a4,a6,0x1c
    5c46:	9736                	add	a4,a4,a3
    5c48:	fae60de3          	beq	a2,a4,5c02 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5c4c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5c50:	4790                	lw	a2,8(a5)
    5c52:	02061593          	slli	a1,a2,0x20
    5c56:	01c5d713          	srli	a4,a1,0x1c
    5c5a:	973e                	add	a4,a4,a5
    5c5c:	fae68ae3          	beq	a3,a4,5c10 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5c60:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5c62:	00002717          	auipc	a4,0x2
    5c66:	54f73723          	sd	a5,1358(a4) # 81b0 <freep>
}
    5c6a:	6422                	ld	s0,8(sp)
    5c6c:	0141                	addi	sp,sp,16
    5c6e:	8082                	ret

0000000000005c70 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5c70:	7139                	addi	sp,sp,-64
    5c72:	fc06                	sd	ra,56(sp)
    5c74:	f822                	sd	s0,48(sp)
    5c76:	f426                	sd	s1,40(sp)
    5c78:	f04a                	sd	s2,32(sp)
    5c7a:	ec4e                	sd	s3,24(sp)
    5c7c:	e852                	sd	s4,16(sp)
    5c7e:	e456                	sd	s5,8(sp)
    5c80:	e05a                	sd	s6,0(sp)
    5c82:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5c84:	02051493          	slli	s1,a0,0x20
    5c88:	9081                	srli	s1,s1,0x20
    5c8a:	04bd                	addi	s1,s1,15
    5c8c:	8091                	srli	s1,s1,0x4
    5c8e:	0014899b          	addiw	s3,s1,1
    5c92:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5c94:	00002517          	auipc	a0,0x2
    5c98:	51c53503          	ld	a0,1308(a0) # 81b0 <freep>
    5c9c:	c515                	beqz	a0,5cc8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5c9e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5ca0:	4798                	lw	a4,8(a5)
    5ca2:	02977f63          	bgeu	a4,s1,5ce0 <malloc+0x70>
    5ca6:	8a4e                	mv	s4,s3
    5ca8:	0009871b          	sext.w	a4,s3
    5cac:	6685                	lui	a3,0x1
    5cae:	00d77363          	bgeu	a4,a3,5cb4 <malloc+0x44>
    5cb2:	6a05                	lui	s4,0x1
    5cb4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5cb8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5cbc:	00002917          	auipc	s2,0x2
    5cc0:	4f490913          	addi	s2,s2,1268 # 81b0 <freep>
  if(p == (char*)-1)
    5cc4:	5afd                	li	s5,-1
    5cc6:	a895                	j	5d3a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5cc8:	00009797          	auipc	a5,0x9
    5ccc:	d0878793          	addi	a5,a5,-760 # e9d0 <base>
    5cd0:	00002717          	auipc	a4,0x2
    5cd4:	4ef73023          	sd	a5,1248(a4) # 81b0 <freep>
    5cd8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5cda:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5cde:	b7e1                	j	5ca6 <malloc+0x36>
      if(p->s.size == nunits)
    5ce0:	02e48c63          	beq	s1,a4,5d18 <malloc+0xa8>
        p->s.size -= nunits;
    5ce4:	4137073b          	subw	a4,a4,s3
    5ce8:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5cea:	02071693          	slli	a3,a4,0x20
    5cee:	01c6d713          	srli	a4,a3,0x1c
    5cf2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5cf4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5cf8:	00002717          	auipc	a4,0x2
    5cfc:	4aa73c23          	sd	a0,1208(a4) # 81b0 <freep>
      return (void*)(p + 1);
    5d00:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5d04:	70e2                	ld	ra,56(sp)
    5d06:	7442                	ld	s0,48(sp)
    5d08:	74a2                	ld	s1,40(sp)
    5d0a:	7902                	ld	s2,32(sp)
    5d0c:	69e2                	ld	s3,24(sp)
    5d0e:	6a42                	ld	s4,16(sp)
    5d10:	6aa2                	ld	s5,8(sp)
    5d12:	6b02                	ld	s6,0(sp)
    5d14:	6121                	addi	sp,sp,64
    5d16:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5d18:	6398                	ld	a4,0(a5)
    5d1a:	e118                	sd	a4,0(a0)
    5d1c:	bff1                	j	5cf8 <malloc+0x88>
  hp->s.size = nu;
    5d1e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5d22:	0541                	addi	a0,a0,16
    5d24:	00000097          	auipc	ra,0x0
    5d28:	eca080e7          	jalr	-310(ra) # 5bee <free>
  return freep;
    5d2c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5d30:	d971                	beqz	a0,5d04 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5d32:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5d34:	4798                	lw	a4,8(a5)
    5d36:	fa9775e3          	bgeu	a4,s1,5ce0 <malloc+0x70>
    if(p == freep)
    5d3a:	00093703          	ld	a4,0(s2)
    5d3e:	853e                	mv	a0,a5
    5d40:	fef719e3          	bne	a4,a5,5d32 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5d44:	8552                	mv	a0,s4
    5d46:	00000097          	auipc	ra,0x0
    5d4a:	b70080e7          	jalr	-1168(ra) # 58b6 <sbrk>
  if(p == (char*)-1)
    5d4e:	fd5518e3          	bne	a0,s5,5d1e <malloc+0xae>
        return 0;
    5d52:	4501                	li	a0,0
    5d54:	bf45                	j	5d04 <malloc+0x94>
