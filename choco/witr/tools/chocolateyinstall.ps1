$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.2.5/witr-windows-amd64.zip'
$checksum64 = '59DE5A9E4541E6C2215D4519BEED21CB26C0BC28A6E88FD86E9B7AA6DDC20083'
$checksumType64 = 'sha256'

$urlArm64      = ''
$checksumArm64 = ''
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
