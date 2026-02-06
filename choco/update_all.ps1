Import-Module au
$ErrorActionPreference = 'Stop'
$au_root = $PSScriptRoot

Get-AUPackages $au_root | Update-AUPackages
