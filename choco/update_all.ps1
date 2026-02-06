Import-Module au
$ErrorActionPreference = 'Stop'

$au_root = $PSScriptRoot

ls $au_root -Recurse -Filter update.ps1 | Update-AUPackages

choco push "$au_root\**\*.nupkg" --source https://push.chocolatey.org/
