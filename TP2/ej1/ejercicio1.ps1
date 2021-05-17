<#***********************
Nombre del script:		ejercicio1.ps1
Trabajo Practico Nro:	2
Ejercicio Nro:		    1
Entrega Nro:			1
Integrantes
	Apellidos		Nombre			Dni
-------------------------------------------------------------------

	Della Maddalena	Tomas				39322141
	Hidalgo			Nahuel Cristian		41427455
	Feito			Gustavo			    27027190
	Pfeiffer		Martin			    39166668
	Zarzycki		Hernan Alejandro	39244031

***********************#>
[CmdletBinding()]
Param (
 [Parameter(Position = 1, Mandatory = $false)] 
 [ValidateScript( { Test-Path -PathType Container $_ } )]	#Especificacion y validacion de parametros
 [String] $path,
 [int] $cantidad = 0
)
$LIST = Get-ChildItem -Path $path -Directory				
$ITEMS = ForEach ($ITEM in $LIST) {
    $COUNT = (Get-ChildItem -Path $ITEM).Length				#Por cada Subdirectorio dentro de _path_
    $props = @{												#Obtenemos todos los archivos, Formamos una estructura para cada archivo,
    name = $ITEM											#Util para poder compararlos. 
    count = $COUNT
 }
 New-Object psobject -Property $props
}
$CANDIDATES = $ITEMS | Sort-Object -Property count -Descending | Select-Object -First $cantidad | Select-Object -Property name #Ordenamos los directorios en base a la cantidad de archivos en su interior
Write-Output "La/s Carpetas con mayor cantidad de archivos son:" $CANDIDATES | Format-Table -HideTableHeaders				 #Nos quedamos con los primeros N (param2) subdirectorios con mayor cantidad.


<#
Respuestas:
1-	El objetivo del script es organizar de mayor a menor los subdirectorios dentro de un directorio dado (path) de mayor a menor en base a los archivos en su interior
4-	Agregaria:
	Validar Paramero cantidad (param2) ya que el script ejecuta erroneamente si la cantidad es menor que 0
	En caso de que el parametro path(param1) no se especifique en la llamada del script, se toma como path la raiz del script, esto puede generar problemas.
5-	CmdletBinding() es un atributo que hace que el script funcione como un cmdlet compilado de PowerShell, lo que permite agregar mas utilidad en el script.
6-	Usos de commilas:
	Comillas dobles (""): Su contendido se puede utilizar texto y tambien interpreta las variables.
	Commilas simples(''): Todo su contenido se interpetra como texto literal, sin interpretacion de variables.
	Acento Grave    (``): Caracter de escape para evitar que se interpreten caracteres especiales.
7-	El script se ejectuta tomando como -path la direccion donde se encuentra el script, -cantidad tiene como valor de default 0 por lo cual no listara ningun directorio.
	El estado de ejecucion es incosistente.
#>