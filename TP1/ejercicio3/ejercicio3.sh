#!/bin/bash
#***********************
# Nombre del script:		ejercicio3.sh
# Trabajo Practico Nro:		1
# Ejercicio Nro:		3
# Entrega Nro:			1
# Integrantes
#
#	Apellidos		Nombre			Dni
#-------------------------------------------------------------------
#
#	Della Maddalena		Tomas			39322141
#	Hidalgo			Nahuel Cristian		41427455
#	Feito			Gustavo			27027190
#	Pfeiffer		Martin			39166668
#	Zarzycki		Hernan Alejandro	39244031
#
#***********************

###Ejercicio 3:
##En una determinada empresa se corre un proceso que genera archivos de texto plano de sus operaciones diarias,
##pero sucede que dicho proceso algunos dias genera mas de una copia del mismo archivos y hasta con diferentes nombres.
##Se requiere generar un script que pueda determinar que archivos son copia de otros archivos (por su contenido) para posteriormente
##tomar la decision de cuales archivos eliminaran. Ademas, se debe generar un archivo log en otro directorio donde se listen los archivos
##repetidos con su ubicacion original, cuyo nombre sera: Resultado_[YYYYMMDDHHmm].out
##
##Dicho script debe recibir los siguientes parametros:
##	- Directorio: directorio donde se generan los archivs generados por el proceso. El mismo puede contener subdirecciones y los archivos encontrarse
##	dentro o fuera de estos.
##
##	- DirectorioSalida: directorio donde se guardan los archivos log, no debe ser el mismo que -Directorio
##
##	- Umbral: tamaño en KB a partir del cual se empezara a evaluar si los archivos presentan duplicados en el directorio ya que
##	a veces el proceso tambien genera archivos erroneso(vacios) o incompletos y se desean filtrar del script
##
##Los mismos se deben poder recibir en cualquier orden.
##Si por ejemplo tenemos 3 archivos "A", "B", "C" iguales y 2 archivos "D", "E". El script deberia informar cada grupo de archivos duplicados
##delimitados por una linea vacia. Puede darse el caso que los archivos A B C se encuentran en subdirectorios diferentes y la salida del script debe
##ser la misma
##
##Ejemplo de saloda(A, B, C son iguales entre si. D, E son iguales entre si):
##
##	A		/home/Entrada
##	B		/home/Entrada
##	C		/home/Entrada/SubDirectorio1
##
##	D		/home/Entrada/SubDirectorio2
##	E		/home/Entrada/SubDirectorio3
## Criterios de correccion:
## --------------------------------------------------------------------------------------------------
## |Control											    |	
## |El script ofrese ayuda con -h, -? o -help explicando como se lo debe invocar	|Obligatorio|
## |Valida parametros(Existencia de rutas y permisos, cantidad de parametros)		|Obligatorio|
## |Se adjuntan archivos de prueba por parte del grupo					|Obligatorio|
## |Funciona correctamente segun enunciado						|Obligatorio|
## |Funciona con rutas relativas, absolutas o con espacios				|Obligatorio|
## |Se implementan funciones								|Deseable   |
## --------------------------------------------------------------------------------------------------

usage="
NOMBRE:
	ejercicio3.sh - Busca todos los archivos repetidos.

DESCRIPCION:
	
	Este script busca en base a su CONTENIDO todos los archivos duplicados en un directorio dado (DirectorioEntrada).
	Los archivos que se tendran en cuenta son todos aquellos cuyo tamaño sea mayor un umbral dado, en KB.
	La salida de este sera un archivo de texto plano dentro de un directorio tipo log (DirectorioSalida).

SINTAXIS:

	El orden de los parametros puede variar:

	$0 [ -d ] ... [ -l ] ... [ -k ] ...

	Para conocer la ayuda:

	$0 [ -h ]

Donde:
	-h Muestra la ayuda del script

	-d Directorio Entrada existente donde se encuentran los archivos a analizar.
	-l Directorio Salida o Log existente donde se guardara el informe de archivos duplicaods
	-k Tamaño en KB mayor a 0 desde el cual se comenzara a considerar archivos

EXAMPLE:

	$0 -d directorioEntrada/ -l directorioLog/ -k 10

	$0 -l 'directorio Log' -k 25 -d 'operaciones'

	$0 -h
	
"

function indicarAyuda(){
	echo "Vea $1 -h para mas informacion"
	exit 1
}

##Funcion para generar el archivo Resultado_[YYYYMMDDHHmm].out
function escribirLog(){		
	
	if [ ! -e "$logFile" ]; then							#Validacion de existencia del archivo log
		touch "$logFile"
	fi
	printf "%-40s\t%-40s\n" "`echo "$1" | cut -d " " -f2- | rev | cut -d "/" -f1 | rev`" "`echo $1 | cut -d " " -f2-`" >> "$logFile"

}									


## Ciclo para validar parametros		
while getopts ":hd:l:k:" o; do	
	case "${o}" in	
		d)
			d="${OPTARG}"
			[ ! -d "$d" ] && echo "$0: DirectorioEntrada inexistente" && indicarAyuda $0
			;;
		l)
			l="${OPTARG}"
			[ ! -d "$l" ] && echo "$0: DirectorioSalida inexistente" && indicarAyuda $0
			[ ${l: -1} != "/" ] && l="${l}"/""				#Correccion en caso de que directorioSalida no finalice con "/"
			;;
		k)
			k="${OPTARG}"
			[ $k -lt 0 ] && echo "$0: El valor del umbral debe ser mayor a 0" && indicarAyuda $0
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

#Validacion de cantidad de parametros
[ $# -lt 6 ] && echo "$0: Cantidad de parametros menor a la esperada" && indicarAyuda $0

#Validacion en caso de error en la sintaxis
[ ! -n "$d" ] && echo "$0: Directorio Entrada erroneo o faltante" && indicarAyuda $0
[ ! -n "$l" ] && echo "$0: Directorio Log erroneo o faltante" && indicarAyuda $0
[ ! -n "$k" ] && echo "$0: Tamaño erroneo o inexistente" && indicarAyuda $0

#Validacion si -Directorio coincicide con -DirectorioSalida
[ "$l" == "$d" ] && echo "$0: directorioEntrada debe ser distinto al directorioSalida" && indicarAyuda $0


#########################################################################################################


logFile="$l""Resultado_[`date +%Y%m%d%H%M`].out"					#Formulacion del nombre del archivo log, unico por ejecucion.

find "$d" -type f -size +"$k"k | while read file
do
	[ `file -i "$file" | rev | cut -d " " -f2 | rev` != "text/plain;" ] && continue

	currentHash="`md5sum "$file" | cut -d " " -f 1`"				#Obtenemos el md5 hash del archivo en base a su contenido,
											#cortamos para solamente quedarnos con el hashcode
	[ `echo "$usedHash" | grep -c $currentHash` -ge 1 ] && continue			#En caso de que el hash obtenido ya exista dentro de la lista de hash usados salteamos
	
	find "$d" -type f -size +"$k"k -print0 | xargs -0 md5sum | grep $currentHash | 
		while read line 
		do
		       	escribirLog "$line" 
		done

	printf "\n" >> "$logFile" 							#Obtenemos todos los archivos dentro del directorio cuyo md5 hash sea identico al de $file 
				 							#considerando aquellos archivos cuyo Tamaño sea mayor a $k en KB
	usedHash+=$currentHash								#Escribimos lo obtenido en el archivo log y agregamos el hash a la lista de 
											#HashCodes utilizados para asi mantener un historial de que archivos ya fueron comparados
done
