[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)] 
    [ValidateNotNullOrEmpty()]
    [String] $pathEntrada,
    
    [Parameter(Mandatory=$True)] [String] $pathSalida,
    [Parameter(Mandatory=$True)] [int] $umbral
)
Get-Help 
    -PathEntrada String