import-module au
$ErrorActionPreference = 'Stop'

$releases = 'https://api.github.com/repos/pranshuparmar/witr/releases/latest'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*`$url64\s*=\s*)('.*')"        = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*`$checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*`$urlArm64\s*=\s*)('.*')"     = "`$1'$($Latest.URLARM64)'"
            "(?i)(^\s*`$checksumArm64\s*=\s*)('.*')"= "`$1'$($Latest.ChecksumARM64)'"
        }
    }
}

function global:au_GetLatest {
    $json = Invoke-RestMethod -Uri $releases

    $url64 = $json.assets | Where-Object { $_.name -like "*windows-amd64.zip" } | Select-Object -ExpandProperty browser_download_url
    $urlArm64 = $json.assets | Where-Object { $_.name -like "*windows-arm64.zip" } | Select-Object -ExpandProperty browser_download_url
    $version = $json.tag_name.TrimStart('v')

    if (-not $url64) { throw "amd64 asset not found" }
    if (-not $urlArm64) { throw "arm64 asset not found" }

    @{
        Version  = $version
        URL64    = $url64
        URLARM64 = $urlArm64
        FileType = 'zip'
    }
}

Update-Package -ChecksumFor all
