#include <stdio.h>

extern int start();

int main() {
  const char *fifo_server = "../../server.pipe";
  const char *fifo_client = "../../client.pipe";

  fd_server = open(fifo_server, O_RDONLY);
  fd_client = open(fifo_client, O_WRONLY);

  dup2(fd_server, STDIN_FILENO);
  dup2(fd_client, STDOUT_FILENO);

  close(fd_server);
  close(fd_client);

  printf("server pipe fd is: %s\n", fd_server);
  printf("calling server _start");

  start(fd_server, fd_client);
  printf("finished server execution");

  return 0;
}
