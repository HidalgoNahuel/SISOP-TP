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
 [ValidateScript( { Test-Path -PathType Container $_ } )]
 [String] $param1,
 [int] $param2 = 0
)
$LIST = Get-ChildItem -Path $param1 -Directory
$ITEMS = ForEach ($ITEM in $LIST) {
    $COUNT = (Get-ChildItem -Path $ITEM).Length
    $props = @{
    name = $ITEM
    count = $COUNT
 }
 New-Object psobject -Property $props
}
$CANDIDATES = $ITEMS | Sort-Object -Property count -Descending | Select-Object -First $param2 | Select-Object -Property name
Write-Output "La/s Carpetas con mayor cantidad de archivos son:" $CANDIDATES | Format-Table -HideTableHeaders
