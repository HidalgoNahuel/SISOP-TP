[CmdletBinding()]
Param (
 [Parameter(Position = 1, Mandatory = $false)] 
 [ValidateScript( { Test-Path -PathType Container $_ } )]
 [String] $param1,
 [int] $param2 = 0
)
$LIST = Get-ChildItem -Path $param1 -Directory
$ITEMS = ForEach ($ITEM in $LIST) {
    Write-Output "$ITEMS"
    $COUNT = (Get-ChildItem -Path $ITEM).Length
    $props = @{
    name = $ITEM
    count = $COUNT
 }
 New-Object psobject -Property $props
}
$CANDIDATES = $ITEMS | Sort-Object -Property count -Descending | Select-Object -First $param2 | Select-Object -Property name
Write-Output "....................." # COMPLETAR
$CANDIDATES | Format-Table -HideTableHeaders
