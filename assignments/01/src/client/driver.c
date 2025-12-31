#include <stdio.h>

extern int start();

int main() {
  const char *fifo_server = "../../server.pipe";
  const char *fifo_client = "../../anthony.pipe";

  fd_server = open(fifo_server, O_RDONLY);
  fd_client = open(fifo_client, O_WRONLY);

  printf("server pipe fd is: %d\n", fd_server);
  printf("calling server _start");
  start(fd_server, fd_client);
  printf("finished server execution");

  return 0;
}
