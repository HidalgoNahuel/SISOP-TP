#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <fcntl.h>
#include <unistd.h>

void facturacion_anual(int, int);
void facturacion_mensual(int, int);
void facturacion_media(int, int);
int pedir_anio();

int main(int argc, char*argv[]){

	char*fifo_datos = "./fifoDatos";

	int fd = open(fifo_datos, O_WRONLY); 
	int opc = 0;	

	printf("\tMenu:\n1- Facturacion Mensual.\n2- Facturacion Anual.\n3- Facturacion Media Anual.\n4- Salir.\n");		
	do{
		scanf("%d", &opc);
		switch(opc){
			case 1:
			facturacion_mensual(pedir_anio(), fd);
			break;
	
			case 2:
			facturacion_anual(pedir_anio(), fd);
			break;

			case 3:
			facturacion_media(pedir_anio(), fd);
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
int pedir_anio(){
	int anio;
	printf("Ingrese año de facturacion: ");
		do{
			scanf("%d", &anio);
			if( anio < 0 || anio > 2021)
				printf("Año invalido. Ingrese nuevamente..\n");
			else	
				break;
		}while(1);
	return anio;
}
void facturacion_anual(int anio, int fd){

	char opc = 2 + '0', instruccion[15], res[20];

	sprintf(instruccion, "%c-%d", opc, anio);
	write(fd, instruccion, strlen(instruccion)+1);
	
	read(fd, res, sizeof(res));

	printf("Facturacion Anual correspondiente al año %s es: %s\n", instruccion, res);
}
void facturacion_mensual(int anio, int fd){
	printf("Mensual");
}
void facturacion_media(int anio, int fd){
	printf("Media-Anual");
}
