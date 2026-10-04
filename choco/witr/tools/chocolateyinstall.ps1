$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.3.4/witr-windows-amd64.zip'
$checksum64 = '34ef930e6f53c026e952f5952442281640bae551e59477137a045f9a2141188f'
$checksumType64 = 'sha256'

$urlArm64      = 'https://github.com/pranshuparmar/witr/releases/download/v0.3.4/witr-windows-arm64.zip'
$checksumArm64 = 'c1db651220bc8a86433fba7e680c87f9db868a41c0fb144427f37750ec62a7ce'
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
