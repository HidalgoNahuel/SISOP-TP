#!/bin/bash

pipe=./fifo

if [[ ! -d $1 ]]; then 
	echo "No existe la carpeta"
	exit 1
fi

if [[ ! -p $pipe ]]; then
	mkfifo $pipe
fi

bin/ProcesoA.out $pipe $1 &
bin/ProcesoB.out $pipe
