$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.2.6/witr-windows-amd64.zip'
$checksum64 = 'e95c3790d8e00a586bb780aecc2a5171786c8215dbdb9e239f33f6b0df709424'
$checksumType64 = 'sha256'

$urlArm64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.2.6/witr-windows-arm64.zip'
$checksumArm64 = '200f2725d73e4e64f1732ba5056d6e17969bdeb9d8374b771ec4cd2867bdf7b8'
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
