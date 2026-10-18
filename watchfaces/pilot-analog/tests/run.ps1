param([string]$SdkPath, [switch]$SmokeOnly)
$ErrorActionPreference = 'Stop'
$facePath = Split-Path -Parent $PSScriptRoot
if (-not $SdkPath) {
    $SdkPath = (Get-Content -LiteralPath (Join-Path $env:APPDATA 'Garmin/ConnectIQ/current-sdk.cfg') -Raw).Trim()
}
$compiler = Join-Path $SdkPath 'bin/monkeyc.bat'
$runner = Join-Path $SdkPath 'bin/monkeydo.bat'
$key = Join-Path $facePath '../../.local/developer_key.der'
Push-Location -LiteralPath $facePath
try {
    New-Item -ItemType Directory -Path bin -Force | Out-Null
    if (-not $SmokeOnly) {
        & $compiler -f monkey.jungle -d fr170 -y $key -o bin/PilotAnalogTests.prg -w -t
        if ($LASTEXITCODE -ne 0) { throw 'Fallo al compilar las pruebas.' }
        & $runner bin/PilotAnalogTests.prg fr170 /t 2>&1 | Tee-Object -FilePath bin/tests.log
        $output = Get-Content -LiteralPath bin/tests.log
        if ($LASTEXITCODE -ne 0 -or ($output -join "`n") -notmatch 'PASSED \(passed=6, failed=0, errors=0\)') {
            throw 'Las pruebas Monkey C no han pasado. Consulta bin/tests.log.'
        }
    }
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [xml]$manifest = Get-Content -LiteralPath manifest.xml -Raw
    $manifest.manifest.application.entry = 'PilotSmokeApp'
    [IO.File]::WriteAllText((Join-Path $facePath 'bin/smoke-manifest.xml'), $manifest.OuterXml, $utf8)
    $jungle = @'
project.manifest = smoke-manifest.xml
base.sourcePath = ../source;../tests
base.resourcePath = ../resources
'@
    [IO.File]::WriteAllText((Join-Path $facePath 'bin/smoke.jungle'), $jungle, $utf8)
    & $compiler -f bin/smoke.jungle -d fr170 -y $key -o bin/PilotAnalogSmoke.prg -w
    if ($LASTEXITCODE -ne 0) { throw 'Fallo al compilar el diagnostico.' }
    # Entrada Java de monkeydo.bat, con un tiempo de diagnostico limitado.
    $arguments = @('-classpath', ('"' + (Join-Path $SdkPath 'bin/monkeybrains.jar') + '"'),
        'com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux', '-f', 'bin/PilotAnalogSmoke.prg',
        '-d', 'fr170', '-s', ('"' + (Join-Path $SdkPath 'bin/shell.exe') + '"'))
    $process = Start-Process -FilePath 'java.exe' -ArgumentList $arguments -WindowStyle Hidden -PassThru `
        -WorkingDirectory $facePath -RedirectStandardOutput (Join-Path $facePath 'bin/smoke.log') `
        -RedirectStandardError (Join-Path $facePath 'bin/smoke-errors.log')
    try {
        Write-Output 'Esperando el diagnostico fr170 (maximo 45 s)...'
        $deadline = [DateTime]::UtcNow.AddSeconds(45)
        $text = ''
        do {
            Start-Sleep -Milliseconds 250
            $text = [string](Get-Content -LiteralPath bin/smoke.log -Raw)
        } while (-not $process.HasExited -and $text -notmatch 'SMOKE PASS|SMOKE FAIL|Error:' -and [DateTime]::UtcNow -lt $deadline)
        $text | Write-Output
        if ($text -notmatch 'SMOKE PASS' -or $text -match 'SMOKE FAIL|Error:') {
            throw 'El diagnostico no ha pasado. Consulta bin/smoke.log y bin/smoke-errors.log.'
        }
    } finally {
        # Detener solo el transporte creado por este diagnostico.
        Get-CimInstance Win32_Process -Filter "ParentProcessId=$($process.Id)" |
            Where-Object { $_.ExecutablePath -eq (Join-Path $SdkPath 'bin/shell.exe') } |
            ForEach-Object { Stop-Process -Id $_.ProcessId -ErrorAction SilentlyContinue }
        if (-not $process.HasExited) { $process.Kill() }
        $process.Dispose()
    }
} finally {
    Pop-Location
}
