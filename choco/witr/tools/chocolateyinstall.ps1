$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.3.3/witr-windows-amd64.zip'
$checksum64 = '1ae95a354fa7f767828ad7942497f3801e5299f8afad5844ec6d1819703a6b28'
$checksumType64 = 'sha256'

$urlArm64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.3.3/witr-windows-arm64.zip'
$checksumArm64 = 'e644a1e152437a0aff93c672660b363de690361ca90f35a792f88b361ca569e4'
$checksumTypeArm64 = 'sha256'

$url = $url64
$checksum = $checksum64
$checksumType = $checksumType64

if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
  $url = $urlArm64
  $checksum = $checksumArm64
  $checksumType = $checksumTypeArm64
}

Install-ChocolateyZipPackage -PackageName $env:ChocolateyPackageName -Url64bit $url -Checksum64 $checksum -ChecksumType64 $checksumType -UnzipLocation $toolsDir
