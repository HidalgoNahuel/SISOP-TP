#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argv, char*argc[]){
    	char*fifo_path = "./mipipe",text_line[100];
	int fd = open(fifo_path, O_RDONLY), i=0;	
	while(read(fd, text_line, sizeof(text_line)) != 0){	
   		printf("%dProcessA Text: %s\n",i, text_line);
		i++;
	}
	close(fd);
    return 0;
}
