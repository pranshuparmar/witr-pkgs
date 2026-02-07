Import-Module au
$ErrorActionPreference = 'Stop'

$au_root = $PSScriptRoot

Update-AUPackages -Path $au_root

choco push "$au_root\**\*.nupkg" --source https://push.chocolatey.org/
