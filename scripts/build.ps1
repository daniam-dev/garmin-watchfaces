param(
    [string]$Project = 'all',
    [string]$SdkPath,
    [string]$DeveloperKeyPath
)

$ErrorActionPreference = 'Stop'
$repoPath = Split-Path -Parent $PSScriptRoot
$projects = Get-Content -LiteralPath (Join-Path $repoPath 'projects.json') -Raw | ConvertFrom-Json
$selected = @($projects.PSObject.Properties | Where-Object { $Project -eq 'all' -or $_.Name -eq $Project })
if ($selected.Count -eq 0) {
    throw "Proyecto desconocido: $Project. Consulta projects.json o usa -Project all."
}
foreach ($entry in $selected) {
    if ($entry.Name -cnotmatch '^[a-z][a-z0-9-]*$' -or $entry.Value -cnotmatch '^[A-Za-z][A-Za-z0-9]*$') {
        throw 'Nombre de proyecto o programa no valido en projects.json.'
    }
}

if (-not $SdkPath) {
    $sdkConfig = Join-Path $env:APPDATA 'Garmin/ConnectIQ/current-sdk.cfg'
    if (-not (Test-Path -LiteralPath $sdkConfig -PathType Leaf)) {
        throw 'Selecciona un SDK en Connect IQ SDK Manager o indica -SdkPath.'
    }
    $SdkPath = (Get-Content -LiteralPath $sdkConfig -Raw).Trim()
}
if (-not $DeveloperKeyPath) {
    $DeveloperKeyPath = Join-Path $repoPath '.local/developer_key.der'
}

$compilerPath = Join-Path $SdkPath 'bin/monkeyc.bat'
if (-not (Test-Path -LiteralPath $compilerPath -PathType Leaf)) {
    throw "No se encuentra el compilador: $compilerPath"
}
if (-not (Test-Path -LiteralPath $DeveloperKeyPath -PathType Leaf)) {
    throw 'No se encuentra la clave de firma. Indica -DeveloperKeyPath o usa .local/developer_key.der.'
}
$compilerPath = (Resolve-Path -LiteralPath $compilerPath).Path
$DeveloperKeyPath = (Resolve-Path -LiteralPath $DeveloperKeyPath).Path
foreach ($entry in $selected) {
    $projectPath = Join-Path $repoPath "watchfaces/$($entry.Name)"
    $outputPath = Join-Path $projectPath 'bin'
    if (-not (Test-Path -LiteralPath (Join-Path $projectPath 'monkey.jungle') -PathType Leaf)) {
        throw "No se encuentra monkey.jungle para $($entry.Name)."
    }
    New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
    $programPath = Join-Path $outputPath ($entry.Value + '.prg')
    Push-Location -LiteralPath $projectPath
    try {
        & $compilerPath -f monkey.jungle -d fr170 -y $DeveloperKeyPath -o $programPath -w
        if ($LASTEXITCODE -ne 0) {
            throw "La compilacion de $($entry.Name) ha fallado (codigo $LASTEXITCODE)."
        }
        Write-Output "Generado: $programPath"
    } finally {
        Pop-Location
    }
}
