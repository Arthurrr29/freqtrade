[CmdletBinding()]
param(
    [switch]$SkipInstall
)

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSCommandPath
$uiRoot = Join-Path $repositoryRoot 'freqtrade-ui'
$uiPackage = Join-Path $uiRoot 'package.json'
$distributionRoot = Join-Path $uiRoot 'dist'
$installedUiRoot = Join-Path $repositoryRoot 'freqtrade\rpc\api_server\ui\installed'

if (-not (Test-Path -LiteralPath $uiPackage -PathType Leaf)) {
    throw 'FreqUI source is missing. Run: git submodule update --init --recursive'
}

Push-Location $uiRoot
try {
    if (-not $SkipInstall) {
        & pnpm install --frozen-lockfile
        if ($LASTEXITCODE -ne 0) {
            throw "pnpm install failed with exit code $LASTEXITCODE."
        }
    }

    & pnpm build
    if ($LASTEXITCODE -ne 0) {
        throw "pnpm build failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}

if (-not (Test-Path -LiteralPath $distributionRoot -PathType Container)) {
    throw "FreqUI build output was not created at $distributionRoot."
}

New-Item -ItemType Directory -Path $installedUiRoot -Force | Out-Null
& robocopy $distributionRoot $installedUiRoot /MIR /NFL /NDL /NJH /NJS /NP
$robocopyExitCode = $LASTEXITCODE
if ($robocopyExitCode -ge 8) {
    throw "FreqUI installation failed with robocopy exit code $robocopyExitCode."
}

$uiVersion = (Get-Content -LiteralPath $uiPackage -Raw | ConvertFrom-Json).version
Set-Content -LiteralPath (Join-Path $installedUiRoot '.uiversion') -Value $uiVersion -NoNewline
New-Item -ItemType File -Path (Join-Path $installedUiRoot '.gitkeep') -Force | Out-Null

Write-Host "Localized FreqUI installed at $installedUiRoot"
