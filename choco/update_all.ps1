Import-Module au
$ErrorActionPreference = 'Stop'

$au_root = $PSScriptRoot

Set-Location $au_root
Update-AUPackages

Get-ChildItem $au_root -Recurse -Filter *.nupkg |
Sort-Object LastWriteTime -Descending |
Select-Object -First 1 |
ForEach-Object {
    choco push $_.FullName --source https://push.chocolatey.org/ --api-key $env:CHOCO_API_KEY
}
