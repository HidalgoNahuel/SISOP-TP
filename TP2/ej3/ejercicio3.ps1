<#***********************
Nombre del script:		ejercicio3.ps1
Trabajo Practico Nro:	2
Ejercicio Nro:		    3
Entrega Nro:			1
Integrantes
	Apellidos		Nombre			Dni
-------------------------------------------------------------------

	Della Maddalena	Tomas			    39322141
	Hidalgo			Nahuel Cristian		41427455
	Feito			Gustavo			    27027190
	Pfeiffer		Martin			    39166668
	Zarzycki		Hernan Alejandro	39244031

***********************#>

<#
.SYNOPSIS
	Busca todos los archivos repetidos en un directorio dado.
.DESCRIPTION
	Este script busca en base a su CONTENIDO todos los archivos duplicados en un directorio dado (pathEntrada).
	Los archivos que se tendran en cuenta son todos aquellos cuyo tamaño sea mayor un tamaño dado (umbral), en KB.
	La salida de este sera un archivo de texto plano dentro de un directorio tipo log (pathrioSalida).
.PARAMETER pathEntrada
    Directorio Entrada existente donde se encuentran los archivos a analizar.
.PARAMETER pathSalida
    Directorio Salida o Log existente donde se guardara el informe de archivos duplicados.
.PARAMETER umbral
    Tamaño en KB mayor a 0 desde el cual se comenzara a considerar archivos
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)] 
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
        if( -Not($_ | Test-Path)){
            throw "La carpeta no existe"    #Especificacion y validaciones para el parametro pathEntrada
        }
        return $True
    })]
    [string]
    $Directorio,
    
    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
        if( -Not($_ | Test-Path)){
            throw "La carpeta no existe"    #Especificacion y validaciones para el parametro pathSalida
        }
        return $True
    })]
    [string] 
    $DirectorioSalida,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [ValidateRange("NonNegative")]             #Especificacion y validaciones para el parametro umbral
    [Int64] $Umbral
)
$LOG = New-Item -ItemType File -Path $DirectorioSalida -Name ('Resultado_' + (Get-Date -Format "yyyyMMddHHmm") + '.out') -Force #Generacion del archivo log.

$usedHash = New-Object System.Collections.ArrayList     #Array donde guardaremos todos los Hash que utilicemos para no comparar mas de una vez el mismo hash.

Get-ChildItem -Path $Directorio -File -Recurse | Where-Object {$_.Length -gt $umbral*1024} | ForEach-Object{           #Obtenemos todos los archivos dentro del -pathEntrada
                                                                                                                        #Validando que su tamaño sea mayor al -umbral en KB
    $hash = (Get-FileHash $_ -Algorithm MD5).Hash                                                                       #Por cada Archivo obtenido verificamos que NO se haya comparado 
                                                                                                                        #Y que en su interior NO tenga caracteres ASCII, validacion que utilzamos para
    if( !$usedHash.Contains($hash) -and !((Get-Content $_) -match '[^\x20-\x7F]')){                                     #Verificar si el archivo es de texto plano.    
        Get-ChildItem $Directorio -File -Recurse | Get-FileHash -Algorithm MD5 | Where-Object {$_.Hash -match $hash} | #Obtenemos todos los archivos dento de -pathEntrada cuyo MD5 Hash sea igual 
        ForEach-Object{                                                                                                 #Al que usamos para comparar. 
            if($_.Path.Contains("/")){                                                                                  #Por cada coincidencia, obtenemos el path del archivo, cortamos el string
                $splittedPath = $_.Path.Split("/")                                                                      #Validando que, segun el SO el path cambia en:
            }                                                                                                           #"/" si es ubuntu y "\" si es windows.
            else{                                                                                                       
                $splittedPath = $_.Path.Split("\")
            }
            "{0,-40}`t{1,-40}" -f $splittedPath[$splittedPath.Length-1], $_.Path | Out-File -LiteralPath $LOG -Append   #Formateamos el string de salida con el nombre, path y escribimos en el archivo log.
        }
        $Null = $usedHash.add($hash)                                                                                    #Añadimos el Hash utilizado para comparar a la lista de Hash usados.
        "" | Out-File -LiteralPath $LOG -Append
    }
}