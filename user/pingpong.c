#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{

  int p[2];

  pipe(p);
  if (fork() == 0) {
    char buf[1];
    // read will block until something is written in the pipe
    read(p[0], buf, 1);
    printf("%d: received ping\n", getpid());
    char buf2[1] = "b";
    write(p[1], buf2, 1);
    exit(0);
  } else {
    char buf[1] = "a";
    write(p[1], buf, 1);
    // This wait sys call will ensure the parent to read the byte written by the child
    // But this does not affect the correctness of this exp.
    wait(0);
    read(p[0], buf, 1);
    // printf("%s", buf);
    printf("%d: received pong\n", getpid());
  }

  exit(0);
}
