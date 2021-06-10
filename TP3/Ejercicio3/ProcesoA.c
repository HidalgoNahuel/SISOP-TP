#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>

#define err(msg){ fprintf(stderr, "Error: %s", msg); exit(1);}

float total_mensual(const char*, const char*);
float total_anual(const char*);
float media_anual(const char*);

int main(int argc, char*argv[]){
	
	if(argc < 2)
		err("argumentos insuficientes");
	
	float res = 0;
	int fd = open("./fifoDatos", O_RDONLY);
	char instruccion[15];
	
	read(fd, instruccion, sizeof(instruccion));
	
	char*str = strtok(instruccion, "-");
	char opc = str[0];
	char*anio = strtok(instruccion, "-");
	char*mes = strtok(instruccion, "-");

	switch(opc-'0'){
		case '1':
		res = total_mensual(anio, mes);
		break;
		
		case '2':
		res = total_anual(anio);
		break;

		case '3':
		res = media_anual(anio);
		break;
	}
	return 0;

	char resultado[20];

	sprintf(resultado, "%.2f", res);
	write(fd, resultado, strlen(resultado)+1);
	close(fd);
}

float total_mensual(const char* anio, const char* mes){
	return 0;
}
float total_anual(const char* anio){
	return 1.69;
}
float media_anual(const char* anio){
	return 1.32;
}
