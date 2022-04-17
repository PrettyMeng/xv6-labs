#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{

  int p[2];
  int nums[34];
  for (int i = 0; i < 34; i++) {
    nums[i] = i + 2;
  }

  pipe(p);
  if (fork() == 0) {
    // necessary to close, otherwise the read call will block forever.
    close(p[1]);
    int first_num, num;
    read(p[0], &first_num, 4);
    printf("prime %d\n", first_num);
    while (read(p[0], &num, 4)) {
      if (num % first_num != 0) {
        printf("prime %d\n", num);
      }
    }
    exit(0);
  } else {
    write(p[1], nums, 4 * 34);
    close(p[1]);
    wait(0);
    exit(0);
  }

}
