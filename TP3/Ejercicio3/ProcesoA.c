#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <dirent.h>

#define err(msg){ fprintf(stderr, "%s", msg); exit(1);}

float facturacion(const char*, const char*);

float facturacion_mensual(const char*);
float facturacion_anual_o_media(const char*, int);

int main(int argc, char*argv[]){
	
	if(argc < 3)
		err("argumentos insuficientes");
	
	float res = facturacion(argv[1], argv[2]);

	printf("%.2f\n", res);

	char resultado[20]; 
	sprintf(resultado, "%.2f", res);

	int fd = open(argv[1], O_WRONLY);
	write(fd, resultado, strlen(resultado)+1);
	close(fd);

	return 0;
}

float facturacion(const char* fifo, const char* dir){

	char instruccion[15];

	int fd = open(fifo, O_RDONLY);
	read(fd, instruccion, sizeof(instruccion));
	close(fd);

	const char opc = strtok(instruccion, "-")[0];
	const char*anio = strtok(NULL, "-");
	const char*mes = strtok(NULL, "-");	
	
	char folder_path[strlen(dir)+strlen(anio)];
	strcpy(folder_path, dir);
	strcat(folder_path, anio);

	switch(opc - '0'){
		case 1:
			return facturacion_mensual(strcat(folder_path, mes));
		case 2:
			return facturacion_anual_o_media(folder_path, 2);
		case 3:
			return facturacion_anual_o_media(folder_path, 3);
	}

}

float facturacion_mensual(const char* path_name){
	puts("fact mens");

	float total = 0, value;
	FILE*arch = fopen(path_name, "rt");

	if(!arch)
		return 0;
	
	while(fscanf(arch, "%f\n", &value) != EOF){
		total += value;
	}
	return total;
}

float facturacion_anual_o_media(const char* folder_path, int opc){

	float total = 0;	
	int count = 0;
	
	DIR *d;
	struct dirent *folder;
	d = opendir(folder_path);

	if(d){
		while((folder = readdir(d)) != NULL){
			count++;
			char path_name[strlen(folder_path) + 10];
			strcpy(path_name, folder_path);
			strcat(path_name, folder->d_name);
			
			FILE*arch = fopen(path_name, "rt");
			
			if(!arch)
				return 0;
			
			float value;
			while(fscanf(arch, "%f\n", &value) != EOF){
				total += value;
			}
			fclose(arch);
		}	
		closedir(d);	
	}
	return opc == 2? total:total/count;
}
