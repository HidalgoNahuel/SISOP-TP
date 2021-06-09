#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <fcntl.h>
#include <unistd.h>

int facturacion_anual();
int facturacion_mensual();
int facturacion_media();

int main(int argv, char*argc[]){

    	char*fifo_path = "./mipipe",text_line[100];
	
	int fd = open(fifo_path, O_RDWR);
	int opc = 0;	

	printf("\tMenu:\n1- Facturacion Mensual.\n2- Facturacion Anual.\n3- Facturacion Media Anual.\n4- Salir.\n");		
	
	do{	
		scanf("%d", &opc);
		switch(opc){
		
			case 1:
			facturacion_mensual(fd);
			break;
		
			case 2:
			facturacion_anual(fd);
			break;

			case 3:
			facturacion_media(fd);
			break;
			
			case 4:
			break;

			default:
			printf("Opcion Invalida. Ingrese Nuevamente..\n");
			break;
		}

	}while(opc != 1 && opc != 2 && opc != 3 && opc != 4);

	close(fd);

    return 0;
}

int facturacion_anual(int fd){

	int anio = 0;
	char opc = 2 + '0';

	char instruccion[5];
	char res[100];

	printf("Ingrese año de facturacion: ");
	
	do{
		scanf("%d", &anio);
		if( anio < 0 || anio > 2021)
			printf("Año invalido. Ingrese nuevamente..\n");
		else
			break;
	}
	while(1);
	
	
	sprintf(instruccion, "%d", anio);
	
	write(fd, instruccion, strlen(instruccion)+1);
	write(fd, &opc, 1);

	printf("Facturacion Anual correspondiente al año %s es: %s\n", instruccion, read(fd, res, sizeof(res)));

	return 0;
}
int facturacion_mensual(){
	printf("Mensual");
	return 0;
}
int facturacion_media(){
	printf("Media-Anual");
	return 0;
}
