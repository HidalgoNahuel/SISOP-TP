<#
.SYNOPSIS
	Busca todos los archivos repetidos en un directorio dado.
.DESCRIPTION
	Este script busca en base a su CONTENIDO todos los archivos duplicados en un directorio dado (DirectorioEntrada).
	Los archivos que se tendran en cuenta son todos aquellos cuyo tamaño sea mayor un umbral dado, en KB.
	La salida de este sera un archivo de texto plano dentro de un directorio tipo log (DirectorioSalida).
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
            throw "La carpeta no existe"
        }
        return $True
    })]
    [string]
    $pathEntrada,
    
    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
        if( -Not($_ | Test-Path)){
            throw "La carpeta no existe"
        }
        return $True
    })]
    [string] 
    $pathSalida,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [ValidateRange("Positive")]
    [Int64] $umbral
)
$LIST = Get-ChildItem -Path $pathEntrada -File -Recurse | Where-Object {$_.Length -gt $umbral*1024}
foreach($file in $LIST){
    $file.Attributes
    #(Get-FileHash -Algorithm MD5 $file).Hash


}