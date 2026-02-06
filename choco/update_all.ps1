Import-Module au
$ErrorActionPreference = 'Stop'
$au_root = $PSScriptRoot

ls $au_root -Recurse -Filter update.ps1 | Update-AUPackages -Options @{ Push = $true }
