#!/bin/bash
#***********************
# Nombre del Script:            ejercicio1.sh
# Trabajo Practico Nro:         1
# Ejercicio Nro:                1
# Entrega Nro:                  1
# Integrantes
#
#       Apellidos               Nombre                  Dni
#-------------------------------------------------------------------
#
#       Della Maddalena         Tomas                   39322141
#       Hidalgo                 Nahuel Christian        41427455
#       Feito                   Gustavo                 27027190
#       Pfeiffer                Martin                  39166668
#       Zarzycki                Hernan Alejandro        39244031
#
#***********************

funcA() {
	echo "Error. La sintaxis del script es la siguiente:"
	echo "$0 [Ruta] [Numero] Ejemplo: $0 directorio 5" # COMPLETAR
}
funcB() {
	echo "Error. $1 No coincide con ningun directorio " # COMPLETAR
}
funcC() {
	if [[ ! -d $2 ]]; then
		funcB      					# Verifica que el primer parametro del script    
	fi		   					# coincida con el nombre de algun directorio
}
funcC $# $1 $2 $3 $4 $5
LIST=$(ls -d $1*/)         					#Forma una lista con directorios que incluyan a $1 (primer parametro) en su nombre, luego 
ITEMS=()		   					#les concatena la cantidad de archivos en su interior para facilitar su ordenamiento (10-example)
for d in $LIST; do
	ITEM="`ls $d | wc -l`-$d" 
	ITEMS+=($ITEM)
done
IFS=$'\n' sorted=($(sort -rV -t '-' -k 1 <<<${ITEMS[*]}))  	#Ordena de mayor a menor los directorios para: mostrar por pantalla
CANDIDATES="${sorted[*]:0:$2}"				   	#los $2(segundo parametro) directorios con mayor cantidad de archivos
unset IFS
echo "$2 Directorio/s con mayor cantidad de archivos:" # COMPLETAR
printf "%s\n" "$(cut -d '-' -f 2 <<<${CANDIDATES[*]})"

#Responda:
#1. ¿Cuál es el objetivo de este script?, ¿Qué parámetros recibe?
#2. Comentar el código según la funcionalidad (no describa los comandos, indique la lógica)
#3. Completar los “echo” con el mensaje correspondiente.
#4. ¿Qué nombre debería tener las funciones funcA, funcB, funcC?
#5. ¿Agregaría alguna otra validación a los parámetros?, ¿existe algún error en el script?
#6. ¿Qué información brinda la variable $#? ¿Qué otras variables similares conocen?
#Explíquelas.
#7. Explique las diferencias entre los distintos tipos de comillas que se pueden utilizar en Shell
#scripts.
#8. ¿Qué sucede si se ejecuta el script sin ningún parámetro?

#1. El objetivo es obtener una lista con los directorios ordenados de mayor a menor segun la cantidad de archivos en su interior.
#   Los parametros son 2: 
#   1-Nombre de un directorio o parte de él. 
#   2-Cantidad de directorios a considerar

#4. para funcA() -> errorSintaxis(), para funcB()-> errorCoincidencia(), para funcC() -> validarCoincidencia()

#5. Seria posible validar que el segundo parametro no sea menor que 0, simplemente por que careceria de sentido.
#   Errores:
#   1- La funcion funcA() nunca es llamada en ninguna instancia del script.
#   2- El llamado a funcB se realiza sin ningun parametro, lo correcto hubiera sido: funcB $2 para que de esta forma $1 en funcB tenga valor
#   3- funcC verifica que el nombre del directorio dado coincida exactamente con alguno existente, lo correcto hubiera sido validar que coincida
#      o este incluido ya que es como luego se forma la lista.
#   4- En caso de no existir coincidencias el script continua ejecutando

#6. - $# contiene la cantidad de parametros que se enviaron en la llamda del script.
#   Otras varibles similares son:
#   - $1, $2, ... , ${10}, ... , ${n} contiene el parametro enviado
#   - $@ o $* La lista con todos los parametros
#   - $$ el PID del proceso
#   - $! el PID el proceso hijo en segundo plano
#   - $? valor del ultimo comando

#7. Uso de comillas:

#   Tanto comillas dobles (") como comillas simples(') se utilizan para cadenas de caracteres, la diferencia entre estas es que las comillas simples
#   (') toman todo el contenido como cadena de caracteres.
#   
#   Acento (`) se utiliza para obtener el resultado de la ejecucion de un comando.

#8. Al ejecutarse sin parametros el script muestra mensajes incompletos pero aun asi continua su ejecucion.
