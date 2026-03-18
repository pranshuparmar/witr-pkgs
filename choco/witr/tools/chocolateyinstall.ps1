$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.3.1/witr-windows-amd64.zip'
$checksum64 = 'c64a3c6496fe7eb2376e4e8632dc686171c0eeed575aaab7d2f8435d65426f67'
$checksumType64 = 'sha256'

$urlArm64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.3.1/witr-windows-arm64.zip'
$checksumArm64 = '53ba33bac48b6a36f4e4687496a35f330c8a36cff00cccee43a4d6a79a2cf1a4'
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
