param([string]$Project = 'all', [string]$SdkPath)

$ErrorActionPreference = 'Stop'
$repoPath = Split-Path -Parent $PSScriptRoot
$projects = Get-Content -LiteralPath (Join-Path $repoPath 'projects.json') -Raw | ConvertFrom-Json
$selected = @($projects.PSObject.Properties | Where-Object { $Project -eq 'all' -or $_.Name -eq $Project })
if ($selected.Count -eq 0) { throw "Proyecto desconocido: $Project" }
foreach ($entry in $selected) {
    if ($entry.Name -cnotmatch '^[a-z][a-z0-9-]*$' -or $entry.Value -cnotmatch '^[A-Za-z][A-Za-z0-9]*$') {
        throw 'Nombre de proyecto o programa no valido.'
    }
}
if (-not $SdkPath) {
    $SdkPath = (Get-Content -LiteralPath (Join-Path $env:APPDATA 'Garmin/ConnectIQ/current-sdk.cfg') -Raw).Trim()
}
$compiler = Join-Path $SdkPath 'bin/monkeyc.bat'
$simulator = Join-Path $SdkPath 'bin/simulator.exe'
$key = Join-Path $repoPath '.local/developer_key.der'
if (-not (Get-Process simulator -ErrorAction SilentlyContinue)) {
    Start-Process -FilePath $simulator -WorkingDirectory (Join-Path $SdkPath 'bin') -WindowStyle Hidden
    Start-Sleep -Seconds 2
}
foreach ($entry in $selected) {
    $facePath = Join-Path $repoPath "watchfaces/$($entry.Name)"
    New-Item -ItemType Directory -Path (Join-Path $facePath 'bin') -Force | Out-Null
    $program = Join-Path $facePath "bin/$($entry.Value)Tests.prg"
    $log = Join-Path $facePath 'bin/tests.log'
    $errorLog = Join-Path $facePath 'bin/tests-errors.log'
    Push-Location -LiteralPath $facePath
    try {
        & $compiler -f monkey.jungle -d fr170 -y $key -o $program -w -t
        if ($LASTEXITCODE -ne 0) { throw "Fallo al compilar pruebas de $($entry.Name)." }
        $arguments = @('-classpath', ('"' + (Join-Path $SdkPath 'bin/monkeybrains.jar') + '"'),
            'com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux', '-f', ('"' + $program + '"'),
            '-d', 'fr170', '-s', ('"' + (Join-Path $SdkPath 'bin/shell.exe') + '"'), '-t')
        $process = Start-Process -FilePath 'java.exe' -ArgumentList $arguments -WindowStyle Hidden -PassThru `
            -WorkingDirectory $facePath -RedirectStandardOutput $log -RedirectStandardError $errorLog
        # Conservar el handle antes de que termine para obtener ExitCode en Windows PowerShell.
        $null = $process.Handle
        try {
            if (-not $process.WaitForExit(45000)) { throw "Tiempo agotado en $($entry.Name). Consulta bin/tests.log." }
            $output = [IO.File]::ReadAllText($log)
            Write-Output $output
            # SDK 9.2 devuelve 1 también al terminar una sesión con todas las pruebas PASSED.
            # Exigir el veredicto del simulador y ausencia de errores de transporte.
            if ($process.ExitCode -notin @(0,1) -or
                $output -notmatch 'PASSED \(passed=[1-9]\d*, failed=0, errors=0\)' -or
                $output -match '(?m)^\s*(FAILED|ERROR\b|Error:)' -or
                -not [string]::IsNullOrWhiteSpace([IO.File]::ReadAllText($errorLog))) {
                throw "Pruebas fallidas en $($entry.Name) (salida: $($process.ExitCode)). Consulta bin/tests.log y bin/tests-errors.log."
            }
        } finally {
            Get-CimInstance Win32_Process -Filter "ParentProcessId=$($process.Id)" |
                Where-Object { $_.ExecutablePath -eq (Join-Path $SdkPath 'bin/shell.exe') } |
                ForEach-Object { Stop-Process -Id $_.ProcessId -ErrorAction SilentlyContinue }
            if (-not $process.HasExited) { $process.Kill() }
            $process.Dispose()
        }
    } finally { Pop-Location }
}
