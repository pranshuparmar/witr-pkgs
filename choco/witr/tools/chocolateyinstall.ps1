$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.3.2/witr-windows-amd64.zip'
$checksum64 = 'c15d609f5a81438716aada23b03686c6448126d261989ceeda67d2f56437e2b1'
$checksumType64 = 'sha256'

$urlArm64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.3.2/witr-windows-arm64.zip'
$checksumArm64 = 'c8fd31796e566926b94eea95d13caf28d80cd338cabb188d737fa836b81641c0'
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
