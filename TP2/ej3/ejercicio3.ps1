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
$LOG = New-Item -ItemType File -Path $pathSalida -Name ('Resultado' + '_[', (Get-Date -Format "yyyyMMddHHmm") + '].out') -Force

$usedHash = New-Object System.Collections.ArrayList

Get-ChildItem -Path $pathEntrada -File -Recurse | Where-Object {$_.Length -gt $umbral*1024} | ForEach-Object{    
    
    $hash = (Get-FileHash $_ -Algorithm MD5).Hash

    if( !$usedHash.Contains($hash) -and !((Get-Content $_) -match '[^\x20-\x7F]')){
        Get-ChildItem $pathEntrada -File -Recurse | Get-FileHash -Algorithm MD5 | Where-Object {$_.Hash -match $hash} |
        ForEach-Object{
            if($_.Path.Contains("/")){
                $splittedPath = $_.Path.Split("/")
            }
            else{ 
                $splittedPath = $_.Path.Split("\")
            }
            "{0,-40}`t{1,-40}" -f $splittedPath[$splittedPath.Length-1], $_.Path | Out-File -LiteralPath $LOG -Append
        }
        $Null = $usedHash.add($hash)
        "" | Out-File -LiteralPath $LOG -Append
    }
}
