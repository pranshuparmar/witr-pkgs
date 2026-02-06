import-module au

$releases = 'https://api.github.com/repos/pranshuparmar/witr/releases/latest'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*`$url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*`$checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*`$urlArm64\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*`$checksumArm64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $json = $download_page.Content | ConvertFrom-Json

    $url64 = $json.assets | Where-Object { $_.name -like "*windows-amd64.zip" } | Select-Object -ExpandProperty browser_download_url
    $urlArm64 = $json.assets | Where-Object { $_.name -like "*windows-arm64.zip" } | Select-Object -ExpandProperty browser_download_url
    $version = $json.tag_name.TrimStart('v')

    @{
        Version    = $version
        URL64      = $url64
        URL32      = $urlArm64
        FileType   = 'zip'
    }
}

Update-Package -ChecksumFor 64 -ChecksumFor32
