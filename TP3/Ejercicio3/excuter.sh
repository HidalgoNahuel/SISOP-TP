#!/bin/bash

pipe=./mipipe

if [[ ! -d "./" ]]; then 
	echo "No existe la carpeta"
	exit 1
fi
if [[ ! -p $pipe ]]; then
	mkfifo $pipe
fi
./ProcesoA &
./ProcesoB &

