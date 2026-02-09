<#
.SYNOPSIS
Updates the winget manifests for witr package.

.DESCRIPTION
Fetches the latest release from GitHub, checks if it's already in the winget manifests,
and if not, creates a new version by downloading assets and calculating hashes.


.PARAMETER Submit
If specified, submits the manifests to the winget-pkgs repository using wingetcreate.
#>
param(
    [string]$GitHubToken,
    [switch]$Submit
)

$ErrorActionPreference = 'Stop'

# Configuration
$RepoOwner = "pranshuparmar"
$RepoName = "witr"
$PackageId = "PranshuParmar.witr"
$ManifestsRoot = "$PSScriptRoot/../winget/manifests/p/PranshuParmar/witr"

# Helper to get latest release
function Get-LatestRelease {
    $headers = @{}
    if ($GitHubToken) {
        $headers["Authorization"] = "token $GitHubToken"
    }
    $url = "https://api.github.com/repos/$RepoOwner/$RepoName/releases/latest"
    return Invoke-RestMethod -Uri $url -Headers $headers
}

# Main logic
Write-Host "Fetching latest release for $RepoOwner/$RepoName..."
$latestRelease = Get-LatestRelease
$latestVersion = $latestRelease.tag_name -replace '^v', ''
Write-Host "Latest version: $latestVersion"

# Check if version already exists
$versionDir = Join-Path $ManifestsRoot $latestVersion
if (Test-Path $versionDir) {
    Write-Host "Version $latestVersion already exists in manifests. Exiting."
    return
}

Write-Host "New version detected. Preparing update..."

# Get previous version to copy from
$existingVersions = Get-ChildItem $ManifestsRoot -Directory | 
    Sort-Object { [System.Version]$_.Name } -Descending
if ($existingVersions.Count -eq 0) {
    Write-Error "No existing versions found to copy from."
}
$previousVersionDir = $existingVersions[0].FullName
Write-Host "Copying from previous version: $($existingVersions[0].Name)"

# Create new version directory
New-Item -ItemType Directory -Path $versionDir -Force | Out-Null

# Copy existing manifests
Copy-Item "$previousVersionDir/*" -Destination $versionDir

# Download assets and calculate hashes
$assets = @{
    "x64"   = "witr-windows-amd64.zip"
    "arm64" = "witr-windows-arm64.zip"
}
$hashes = @{}

foreach ($arch in $assets.Keys) {
    $assetName = $assets[$arch]
    $downloadUrl = "https://github.com/pranshuparmar/witr/releases/download/v$latestVersion/$assetName"
    $tempFile = Join-Path $env:TEMP $assetName
    
    Write-Host "Downloading $assetName..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile
    
    Write-Host "Calculating hash for $assetName..."
    $hash = (Get-FileHash $tempFile -Algorithm SHA256).Hash
    $hashes[$arch] = $hash
    
    Remove-Item $tempFile
}

# Update Manifests
$manifestFiles = Get-ChildItem $versionDir -Filter "*.yaml"
$todayDate = (Get-Date).ToString("yyyy-MM-dd")

foreach ($file in $manifestFiles) {
    Write-Host "Updating $($file.Name)..."
    $content = Get-Content $file.FullName -Raw

    # Update Version
    $content = $content -replace "PackageVersion: .*", "PackageVersion: $latestVersion"
    
    # Update URLs and Hashes
    if ($file.Name -like "*.installer.yaml") {
        # x64
        $content = $content -replace "InstallerUrl: .*witr-windows-amd64.zip", "InstallerUrl: https://github.com/$RepoOwner/$RepoName/releases/download/v$latestVersion/witr-windows-amd64.zip"
        # We need to be careful with regex for hashes to target the right architecture
        # Assuming the order is preserved or using a more robust replacement strategy if possible.
        # Since the file is simple, we can try to replace the SHA based on the previous file content, but that's risky if we don't know the previous SHA (we do, but it's cleaner to just regex replace the specific lines if we can identify them by architecture).
        # Actually, let's read the file line by line for the installer manifest to ensure we match the right arch.
        
        $lines = Get-Content $file.FullName
        $newLines = @()
        $currentArch = ""
        
        foreach ($line in $lines) {
            if ($line -match "- Architecture: (.*)") {
                $currentArch = $matches[1].Trim()
            }
            
            if ($line -match "InstallerUrl:") {
                # Update URL based on architecture if we are in a block, or just global replace if it's unique enough (it is unique by filename)
                 if ($line -match "amd64") {
                     $line = "  InstallerUrl: https://github.com/$RepoOwner/$RepoName/releases/download/v$latestVersion/witr-windows-amd64.zip"
                 } elseif ($line -match "arm64") {
                     $line = "  InstallerUrl: https://github.com/$RepoOwner/$RepoName/releases/download/v$latestVersion/witr-windows-arm64.zip"
                 }
            }
            
            if ($line -match "InstallerSha256:") {
                if ($currentArch -eq "x64") {
                    $line = "  InstallerSha256: $($hashes['x64'])"
                } elseif ($currentArch -eq "arm64") {
                    $line = "  InstallerSha256: $($hashes['arm64'])"
                }
            }
            
            $newLines += $line
        }
        $content = $newLines -join "`r`n"
    }
    
    # Update Release Date if present (usually in check or version manifest, but good practice)
    # The example manifests didn't explicitly show ReleaseDate, but wingetcreate might add it.
    # We'll skip for now as it wasn't in the viewed files.
    

    Set-Content -Path $file.FullName -Value $content
}

Write-Host "Successfully created manifests for version $latestVersion"

if ($Submit) {
    if (-not $GitHubToken) {
        Write-Error "GitHubToken is required for submission."
    }

    Write-Host "Submitting to winget-pkgs..."
    try {
        # wingetcreate submit <path-to-manifests> --token <token>
        # The path should be the directory containing the manifests for this version
        $submitArgs = @("submit", $versionDir, "--token", $GitHubToken)
        & wingetcreate $submitArgs
    } catch {
        Write-Error "Failed to submit manifests: $_"
    }
}
