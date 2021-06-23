#!/usr/bin/env bash

usage="
NOMBRE:
	./executer.sh - Genera dos procesos no emparentados que se comunicaran por una tuberia.

SINTAXIS:

	./executer.sh [-f FifoPath]  [-i DirectorioFacturacion]
	
	./executer.sh [ -h ]

Donde:
	-h Muestra la ayuda del script

	-f Path del FIFO / Tuberia.
	-i Directorio donde se encuentran las facturaciones realizadas.

EXAMPLE:

	./executer.sh -f fifo/ -i facturacion/

	./executer.sh -h

"

function indicarAyuda(){
	echo "Vea $1 -h para mas informacion"
	exit 1
}

while getopts ":hf:i:" o; do	
	case "${o}" in	
		d)
			f="${OPTARG}"
			[ ! -e "$d" ] && echo "$0: FIFO inexistente" && indicarAyuda $0
			;;
		l)
			i="${OPTARG}"
			[ ! -d "$l" ] && echo "$0: DirectorioFacturacion inexistente" && indicarAyuda $0
			[ ${l: -1} != "/" ] && l="${l}"/""				#Correccion en caso de que directorioSalida no finalice con "/"
			;;

		h)
			echo "$usage"
			exit
			;;
		:)
			echo "$0: Argumento faltante para" "'${OPTARG}'" && indicarAyuda $0
			;;
		\?*)
			echo "$0: Opcion invalida:" "'-${OPTARG}'" && indicarAyuda $0
			;;
	esac
done

[ $# -lt 5 ] && echo "$0: Cantidad de parametros menor a la esperada" && indicarAyuda $0
[ ! -n "$f" ] && echo "$0: Directorio Entrada erroneo o faltante" && indicarAyuda $0
[ ! -n "$i" ] && echo "$0: Directorio Log erroneo o faltante" && indicarAyuda $0

bin/ProcesoA.out $pipe $1 &
bin/ProcesoB.out $pipe
