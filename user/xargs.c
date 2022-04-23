#include "kernel/param.h"
#include "kernel/types.h"
#include "user/user.h"
#include <stddef.h>

int main(int argc, char *argv[]) {

  char *exec_argv[MAXARG];
  // char *cmd_p = argv[1];

  int i;
  for (i = 1; i < argc; i++) {
    exec_argv[i - 1] = argv[i];
  }
  printf("%d\n", i);

  // TAKEAWAY: make sure you have allocated the memory for char*
  exec_argv[i - 1] = malloc(sizeof(char) * 128);
  char *stdin_p = exec_argv[i - 1];

  exec_argv[i] = "\0";

  while (read(0, stdin_p++, sizeof(char))) {
    while (*(stdin_p - 1) != '\n' && *(stdin_p - 1) != '\0') {
      read(0, stdin_p++, sizeof(char));
      // printf("\n");
    }
    *(stdin_p - 1) = '\0';
    if (fork() == 0) {


      exec(exec_argv[0], exec_argv);

      printf("exec fail\n");
    } else {
      int status;
      wait(&status);
    }
  }
  
  exit(0);
}