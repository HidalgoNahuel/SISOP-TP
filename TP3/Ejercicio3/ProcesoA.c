#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>

#define err(msg){ fprintf(stderr, "Error: %s", msg); exit(1);}
int main(int argc, char*argv[]){
	
	int sz = 0;
	char* fifo_path = "./mipipe", text_line[100];
	FILE*arch = fopen("./text.txt", "rt");
	if(!arch)
		err("errorArchivo");
	int fd = open(fifo_path, O_WRONLY);

	while(fgets(text_line, sizeof(text_line), arch)){
		while(sz != 0){
			ioctl(fd, FIONREAD, &sz);	
		}
   		write(fd, text_line, strlen(text_line));
		ioctl(fd, FIONREAD, &sz);
	}
	close(fd);
	return 0;
}
