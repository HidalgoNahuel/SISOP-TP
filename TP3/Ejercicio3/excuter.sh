#!/bin/bash

pipe=./fifo_datos
pipe2=./fifo_res

if [[ ! -d $1 ]]; then 
	echo "No existe la carpeta"
	exit 1
fi

if [[ ! -p $pipe ]]; then
	mkfifo $pipe
fi

if [[ ! -p $pipe2 ]]; then
	mkfifo $pipe2
fi

./ProcesoA $1 &
./ProcesoB 

