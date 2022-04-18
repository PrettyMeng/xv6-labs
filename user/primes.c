#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{

  int p_left[2];
  int p_right[2];
  int nums[34];
  for (int i = 0; i < 34; i++) {
    nums[i] = i + 2;
  }

  // pipe(p_left);
  // 3, 4
  pipe(p_right);

  int first_num = 0, num;
  if (fork() == 0) {
    while (1) {
      p_left[0] = p_right[0];
      p_left[1] = p_right[1];
      close(p_left[1]);
      // if nothing to read, break.
      if (read(p_left[0], &first_num, 4) == 0) {
        break;
      }
      pipe(p_right);
      printf("prime %d\n", first_num);

      int pid = fork();
      if (pid != 0) {
        close(p_left[0]);
        // printf("waiting pid done %d...\n", pid);
      } else {
        // printf("p_left %d\n", p_left[0]);
        while (read(p_left[0], &num, 4)) {
          if (num % first_num != 0) {
            write(p_right[1], &num, 4);
          }
        }
        exit(0);
      }
    }
    exit(0);
    // necessary to close, otherwise the read call will block forever.  
  } else {
    close(p_right[0]);
    for (int i = 0; i < 34; i++) {
      write(p_right[1], &nums[i], 4);
    }
    close(p_right[1]);
    wait(0);
  }
  exit(0);

}
