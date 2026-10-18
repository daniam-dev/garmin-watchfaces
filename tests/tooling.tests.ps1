$ErrorActionPreference = 'Stop'
$repoPath = Split-Path -Parent $PSScriptRoot
$verifyScript = Join-Path $repoPath 'scripts/verify.ps1'
$fixturePath = Join-Path ([IO.Path]::GetFullPath($env:TEMP)) ('garmin-tooling-' + [guid]::NewGuid().ToString('N'))
$utf8 = New-Object System.Text.UTF8Encoding($false)
New-Item -ItemType Directory -Path $fixturePath | Out-Null
try {
    foreach ($name in @('projects.json', 'garmin-watchfaces.code-workspace', 'AGENTS.md')) {
        Copy-Item -LiteralPath (Join-Path $repoPath $name) -Destination $fixturePath
    }
    New-Item -ItemType Directory -Path (Join-Path $fixturePath '.impeccable'), (Join-Path $fixturePath 'scripts') | Out-Null
    Copy-Item -LiteralPath (Join-Path $repoPath '.impeccable/config.json') -Destination (Join-Path $fixturePath '.impeccable')
    Copy-Item -LiteralPath $verifyScript -Destination (Join-Path $fixturePath 'scripts')
    $projects = Get-Content -LiteralPath (Join-Path $repoPath 'projects.json') -Raw | ConvertFrom-Json
    foreach ($entry in $projects.PSObject.Properties) {
        $projectPath = Join-Path $repoPath "watchfaces/$($entry.Name)"
        $destination = Join-Path $fixturePath "watchfaces/$($entry.Name)"
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
        foreach ($name in @('manifest.xml', 'monkey.jungle', 'AGENTS.md', 'PRODUCT.md', 'source', 'resources')) {
            Copy-Item -LiteralPath (Join-Path $projectPath $name) -Destination $destination -Recurse
        }
    }
    $manifestPath = Join-Path $fixturePath 'watchfaces/pixel-analog/manifest.xml'
    $workspacePath = Join-Path $fixturePath 'garmin-watchfaces.code-workspace'
    $registryPath = Join-Path $fixturePath 'projects.json'
    $originals = @{}
    foreach ($path in @($manifestPath, $workspacePath, $registryPath)) {
        $originals[$path] = [IO.File]::ReadAllText($path)
    }

    function Assert-Rejected([string]$Label, [string]$Expected, [scriptblock]$Change) {
        try {
            & $Change
            $rejected = $false
            try { & $verifyScript -RootPath $fixturePath | Out-Null } catch {
                if ($_.Exception.Message -notlike "*$Expected*") { throw }
                $rejected = $true
            }
            if (-not $rejected) { throw "No se rechazo: $Label" }
            Write-Output "PASS: $Label"
        } finally {
            foreach ($path in $originals.Keys) { [IO.File]::WriteAllText($path, $originals[$path], $utf8) }
        }
    }

    & $verifyScript -RootPath $fixturePath | Out-Null
    Write-Output 'PASS: estructura valida sin SDK ni clave'
    Assert-Rejected 'IDs duplicados con distinto formato UUID' 'ID de aplicacion duplicado' {
        $text = $originals[$manifestPath].Replace('cd8b48b6a99b479d92574e20ffa230a4', '60e7de33-3720-4ecd-ba97-e40f6e1bb1a0')
        [IO.File]::WriteAllText($manifestPath, $text, $utf8)
    }
    Assert-Rejected 'dispositivo incompatible' 'Solo se admite fr170' {
        [IO.File]::WriteAllText($manifestPath, $originals[$manifestPath].Replace('id="fr170"', 'id="fr165"'), $utf8)
    }
    Assert-Rejected 'tarea de proyecto ausente' 'Debe haber una tarea de compilacion' {
        $workspace = $originals[$workspacePath] | ConvertFrom-Json
        $workspace.tasks.tasks = @($workspace.tasks.tasks | Where-Object { $_.args -notcontains 'pixel-analog' })
        [IO.File]::WriteAllText($workspacePath, ($workspace | ConvertTo-Json -Depth 12), $utf8)
    }
    Assert-Rejected 'ruta de proyecto fuera de la convencion' 'Nombre de proyecto no valido' {
        [IO.File]::WriteAllText($registryPath, $originals[$registryPath].Replace('pixel-analog', '../pixel-analog'), $utf8)
    }
} finally {
    $resolvedFixture = [IO.Path]::GetFullPath($fixturePath)
    $resolvedTemp = [IO.Path]::GetFullPath($env:TEMP).TrimEnd('\') + '\'
    if (-not $resolvedFixture.StartsWith($resolvedTemp, [StringComparison]::OrdinalIgnoreCase) -or
        (Split-Path -Leaf $resolvedFixture) -notmatch '^garmin-tooling-[a-f0-9]{32}$') {
        throw 'Destino temporal no seguro; no se elimina.'
    }
    Remove-Item -LiteralPath $resolvedFixture -Recurse -Force
}
