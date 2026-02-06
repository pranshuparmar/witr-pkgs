Import-Module au
$au_root = $PSScriptRoot

Get-ChildItem -Path $au_root -Filter update.ps1 -Recurse | ForEach-Object {
    Write-Host "Running update for $($_.Directory.Name)"
    Push-Location $_.DirectoryName
    try {
        & $_.FullName
    } finally {
        Pop-Location
    }
}
