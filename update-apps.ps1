# Update Saleor Apps from Monorepo
# Downloads the latest saleor/apps monorepo and updates each app directory
# with fresh source code and shared packages while preserving local Docker/deploy files.

param(
    [string]$RepoUrl = "https://github.com/saleor/archive/refs/heads/main.zip",
    [string]$TempDir = "$PSScriptRoot\.update-temp",
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

# App-to-packages mapping (must match each app's workspace dependencies)
$AppPackages = @{
    "avatax"        = @("app-problems","logger","otel","shared","ui","errors","react-hook-form-macaw","sentry-utils","webhook-utils","eslint-config","typescript-config")
    "cms"           = @("app-problems","logger","otel","shared","ui","errors","react-hook-form-macaw","sentry-utils","eslint-config","typescript-config")
    "klaviyo"       = @("logger","otel","shared","ui","errors","sentry-utils","eslint-config","typescript-config")
    "np-atobarai"   = @("domain","logger","otel","shared","trpc","ui","dynamo-config-repository","errors","react-hook-form-macaw","sentry-utils","webhook-utils","eslint-config","typescript-config")
    "products-feed" = @("app-problems","logger","otel","shared","ui","errors","handlebars","react-hook-form-macaw","sentry-utils","webhook-utils","eslint-config","typescript-config")
    "search"        = @("app-problems","logger","otel","shared","ui","errors","react-hook-form-macaw","sentry-utils","webhook-utils","eslint-config","typescript-config")
    "segment"       = @("app-problems","logger","otel","shared","ui","errors","react-hook-form-macaw","sentry-utils","webhook-utils","eslint-config","typescript-config")
    "smtp"          = @("logger","otel","shared","ui","errors","handlebars","react-hook-form-macaw","sentry-utils","webhook-utils","eslint-config","typescript-config")
    "stripe"        = @("app-problems","logger","otel","shared","trpc","ui","errors","react-hook-form-macaw","sentry-utils","webhook-utils","eslint-config","typescript-config")
}

# Files to preserve in each app directory (not overwritten from monorepo)
$PreserveFiles = @(
    "Dockerfile",
    "docker-compose.yaml",
    ".env.example",
    ".dockerignore",
    "README.md",
    "pnpm-workspace.yaml"
)

function Write-Step {
    param([string]$Message)
    Write-Host "`n=== $Message ===" -ForegroundColor Cyan
}

function Write-Ok {
    param([string]$Message)
    Write-Host "  OK: $Message" -ForegroundColor Green
}

function Write-Skip {
    param([string]$Message)
    Write-Host "  SKIP: $Message" -ForegroundColor Yellow
}

# Cleanup on exit
trap {
    if (Test-Path $TempDir) {
        Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Step "1. Downloading saleor/apps monorepo"

if (Test-Path $TempDir) {
    Remove-Item $TempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

$ZipPath = Join-Path $TempDir "apps-main.zip"
Write-Host "  Downloading from $RepoUrl..."
Invoke-WebRequest -Uri $RepoUrl -OutFile $ZipPath -UseBasicParsing

Write-Host "  Extracting..."
Expand-Archive -LiteralPath $ZipPath -DestinationPath $TempDir -Force

# Find the extracted root (zip extracts to a folder like apps-main)
$ExtractedRoot = Get-ChildItem $TempDir -Directory | Select-Object -First 1
$MonorepoRoot = $ExtractedRoot.FullName

if (-not (Test-Path (Join-Path $MonorepoRoot "apps"))) {
    throw "Could not find apps/ directory in extracted monorepo. Extraction may have failed."
}

Write-Ok "Monorepo extracted to $MonorepoRoot"

Write-Step "2. Updating apps"

foreach ($AppName in $AppPackages.Keys) {
    $AppDir = Join-Path $PSScriptRoot $AppName
    $AppSource = Join-Path $MonorepoRoot "apps" $AppName

    if (-not (Test-Path $AppSource)) {
        Write-Skip "$AppName not found in monorepo, skipping"
        continue
    }

    if (-not (Test-Path $AppDir)) {
        Write-Skip "$AppDir does not exist, skipping"
        continue
    }

    Write-Host "`n[$AppName]" -ForegroundColor White

    # Preserve local files
    $PreservedPaths = @()
    foreach ($File in $PreserveFiles) {
        $FilePath = Join-Path $AppDir $File
        if (Test-Path $FilePath) {
            $TempPath = Join-Path $TempDir "$AppName.preserve.$File"
            Copy-Item $FilePath $TempPath -Force
            $PreservedPaths += @{ Source = $TempPath; Dest = $FilePath }
        }
    }

    # Replace app source
    $LocalAppSource = Join-Path $AppDir $AppName
    if (Test-Path $LocalAppSource) {
        Remove-Item $LocalAppSource -Recurse -Force
    }
    Copy-Item $AppSource $LocalAppSource -Recurse -Force

    # Remove unnecessary files from app source
    $ExcludeDirs = @("node_modules", ".next", "e2e", "src/__tests__", "src/__tests__")
    foreach ($Dir in $ExcludeDirs) {
        $Path = Join-Path $LocalAppSource $Dir
        if (Test-Path $Path) {
            Remove-Item $Path -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    # Update packages
    $PackagesDir = Join-Path $AppDir "packages"
    if (Test-Path $PackagesDir) {
        Remove-Item $PackagesDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $PackagesDir -Force | Out-Null

    foreach ($Pkg in $AppPackages[$AppName]) {
        $PkgSource = Join-Path $MonorepoRoot "packages" $Pkg
        $PkgDest = Join-Path $PackagesDir $Pkg
        if (Test-Path $PkgSource) {
            Copy-Item $PkgSource $PkgDest -Recurse -Force
        } else {
            Write-Skip "Package '$Pkg' not found for $AppName"
        }
    }

    # Update root files (pnpm-lock.yaml, package.json)
    Copy-Item (Join-Path $MonorepoRoot "pnpm-lock.yaml") (Join-Path $AppDir "pnpm-lock.yaml") -Force
    Copy-Item (Join-Path $MonorepoRoot "package.json") (Join-Path $AppDir "package.json") -Force

    # Restore preserved files
    foreach ($Item in $PreservedPaths) {
        Copy-Item $Item.Source $Item.Dest -Force
    }

    Write-Ok "$AppName updated"
}

Write-Step "3. Cleaning up"
Remove-Item $TempDir -Recurse -Force
Write-Ok "Temporary files removed"

Write-Step "Done"
Write-Host "All apps updated. Push changes and redeploy in Coolify." -ForegroundColor Green
