param([string]$RootPath = (Split-Path -Parent $PSScriptRoot))

$ErrorActionPreference = 'Stop'
$RootPath = (Resolve-Path -LiteralPath $RootPath).Path
function Assert-Valid([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
}

$projects = Get-Content -LiteralPath (Join-Path $RootPath 'projects.json') -Raw | ConvertFrom-Json
$entries = @($projects.PSObject.Properties)
Assert-Valid ($entries.Count -gt 0) 'projects.json esta vacio.'
$workspace = Get-Content -LiteralPath (Join-Path $RootPath 'garmin-watchfaces.code-workspace') -Raw | ConvertFrom-Json
$ids = @{}
$programs = @{}
foreach ($entry in $entries) {
    Assert-Valid ($entry.Name -cmatch '^[a-z][a-z0-9-]*$') 'Nombre de proyecto no valido.'
    Assert-Valid ($entry.Value -is [string] -and $entry.Value -cmatch '^[A-Za-z][A-Za-z0-9]*$') 'Nombre de programa no valido.'
    Assert-Valid (-not $programs.ContainsKey($entry.Value)) 'Nombre de programa duplicado.'
    $programs[$entry.Value] = $true
    $relativePath = "watchfaces/$($entry.Name)"
    $projectPath = Join-Path $RootPath $relativePath
    foreach ($file in @('manifest.xml', 'monkey.jungle', 'AGENTS.md', 'PRODUCT.md')) {
        Assert-Valid (Test-Path -LiteralPath (Join-Path $projectPath $file) -PathType Leaf) "Falta $relativePath/$file."
    }
    foreach ($directory in @('source', 'resources')) {
        Assert-Valid (Test-Path -LiteralPath (Join-Path $projectPath $directory) -PathType Container) "Falta $relativePath/$directory."
    }
    [xml]$manifest = Get-Content -LiteralPath (Join-Path $projectPath 'manifest.xml') -Raw
    $ns = New-Object System.Xml.XmlNamespaceManager($manifest.NameTable)
    $ns.AddNamespace('iq', 'http://www.garmin.com/xml/connectiq')
    $app = $manifest.SelectSingleNode('/iq:manifest/iq:application', $ns)
    Assert-Valid ($null -ne $app -and $app.GetAttribute('type') -eq 'watchface') "Tipo de aplicacion incorrecto: $relativePath."
    $guid = [guid]::Empty
    Assert-Valid ([guid]::TryParse($app.GetAttribute('id'), [ref]$guid)) "ID no valido: $relativePath."
    $id = $guid.ToString('N')
    Assert-Valid (-not $ids.ContainsKey($id)) 'ID de aplicacion duplicado.'
    $ids[$id] = $true
    $devices = @($app.SelectNodes('iq:products/iq:product', $ns))
    Assert-Valid ($devices.Count -eq 1 -and $devices[0].GetAttribute('id') -eq 'fr170') "Solo se admite fr170: $relativePath."
    $jungle = (Get-Content -LiteralPath (Join-Path $projectPath 'monkey.jungle') -Raw).Trim()
    Assert-Valid ($jungle -eq 'project.manifest = manifest.xml') "El proyecto debe usar su manifiesto y rutas locales: $relativePath."
    foreach ($xmlFile in (Get-ChildItem -LiteralPath (Join-Path $projectPath 'resources') -Recurse -File -Filter '*.xml')) {
        [xml]$resource = Get-Content -LiteralPath $xmlFile.FullName -Raw
    }
    $folders = @($workspace.folders | Where-Object { $_.path -eq $relativePath })
    Assert-Valid ($folders.Count -eq 1) "Carpeta ausente o repetida en el workspace: $relativePath."
    $tasks = @($workspace.tasks.tasks | Where-Object {
        $arguments = @($_.args)
        $projectIndex = [array]::IndexOf($arguments, '-Project')
        $projectIndex -ge 0 -and $projectIndex + 1 -lt $arguments.Count -and $arguments[$projectIndex + 1] -eq $entry.Name
    })
    Assert-Valid ($tasks.Count -eq 1) "Debe haber una tarea de compilacion para $($entry.Name)."
}
$directories = @(Get-ChildItem -LiteralPath (Join-Path $RootPath 'watchfaces') -Directory)
Assert-Valid ($directories.Count -eq $entries.Count -and @($directories | Where-Object { $_.Name -notin $entries.Name }).Count -eq 0) 'Hay esferas sin registrar en projects.json.'
$config = Get-Content -LiteralPath (Join-Path $RootPath '.impeccable/config.json') -Raw | ConvertFrom-Json
Assert-Valid (@($config.projectRoots).Count -eq 1 -and $config.projectRoots[0] -eq 'watchfaces/*') 'Impeccable debe apuntar a watchfaces/*.'
Assert-Valid (Test-Path -LiteralPath (Join-Path $RootPath 'AGENTS.md') -PathType Leaf) 'Falta AGENTS.md raiz.'
foreach ($script in (Get-ChildItem -LiteralPath (Join-Path $RootPath 'scripts') -File -Filter '*.ps1')) {
    $tokens = $null
    $parseErrors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$parseErrors)
    Assert-Valid ($parseErrors.Count -eq 0) "Sintaxis PowerShell incorrecta: $($script.Name)."
}
Write-Output "PASS: $($entries.Count) esferas independientes, IDs unicos, fr170, recursos, workspace, Impeccable y scripts."
