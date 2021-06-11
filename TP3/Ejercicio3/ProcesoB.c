#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <fcntl.h>
#include <unistd.h>

#define err(msg){ fprintf(stderr, "%s", msg); exit(1);}

int pedir_anio(), pedir_mes();

int main(int argc, char*argv[]){

	if(argc < 2){
		puts("Argumentos insuficientes");
		return 0;
	}
	char * fifo_path = argv[1]; 

	int fd,opc;
	char resultado[10];
	printf("\tMenu:\n1- Facturacion Mensual.\n2- Facturacion Anual.\n3- Facturacion Media Anual.\n4- Salir.\n");		
	do{
		int opc;	
		scanf("%d", &opc);
		if(opc > 0 && opc < 4){
			int anio = pedir_anio();
			int mes = 0;
			if(opc == 1){
				mes = pedir_mes();
			}
		
			char instruccion[15];
			sprintf(instruccion, "%d-%d/-%d", opc, anio, mes);
		
			fd = open(fifo_path, O_WRONLY);
			write(fd, instruccion, strlen(instruccion)+1);
			close(fd);
			
			break;	
		}
		else
			printf("Opcion Invalida. Ingrese Nuevamente..\n");
	}while(opc != 4);

	fd = open(fifo_path, O_RDONLY);
	read(fd, resultado, sizeof(resultado));
	close(fd);
	
	printf("Resultado total: %s\n", resultado);

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
int pedir_mes(){

	int mes;
	printf("Ingrese mes de facturacion: ");
	do{
		scanf("%d", &mes);
		if(mes < 0 || mes > 12)
			printf("Mes invaldo. Ingrese nuevamente.. \n");
		else
			break;
	}while(1);
	return mes;
}
