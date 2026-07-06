param(
    [string]$ProjectPath,

    [ValidateSet("basic", "enhanced")]
    [string]$Mode = "enhanced",

    [Alias("Host", "Tool")]
    [ValidateSet("auto", "codex", "cursor", "claude-code", "opencode", "trae", "zcode", "generic")]
    [string]$TargetHost = "auto",

    [switch]$ListHosts,

    [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")
$sourceRoot = Join-Path $repoRoot "skills"
$hostAdaptersPath = Join-Path $PSScriptRoot "host-adapters.json"

if (-not (Test-Path -LiteralPath $hostAdaptersPath -PathType Leaf)) {
    throw "Missing host adapter registry: $hostAdaptersPath"
}

$hostAdapters = Get-Content -Raw -Encoding UTF8 -LiteralPath $hostAdaptersPath | ConvertFrom-Json
$hostNames = $hostAdapters.PSObject.Properties.Name

if ($ListHosts) {
    foreach ($hostName in $hostNames) {
        $adapter = $hostAdapters.$hostName
        [PSCustomObject]@{
            Host = $hostName
            Label = $adapter.label
            Status = $adapter.status
            PreferredSkillsPath = $adapter.skillRoots[0]
            CompatibleSkillsPaths = ($adapter.skillRoots -join ", ")
        }
    }
    return
}

if ([string]::IsNullOrWhiteSpace($ProjectPath)) {
    throw "ProjectPath is required unless -ListHosts is used."
}

if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
    throw "ProjectPath does not exist or is not a directory: $ProjectPath"
}

$projectRoot = Resolve-Path -LiteralPath $ProjectPath

function ConvertTo-NativeRelativePath {
    param([Parameter(Mandatory = $true)][string]$Path)
    return ($Path -replace '/', [System.IO.Path]::DirectorySeparatorChar)
}

function Get-Adapter {
    param([Parameter(Mandatory = $true)][string]$Name)
    if ($hostNames -notcontains $Name) {
        throw "Unsupported host: $Name"
    }
    return $hostAdapters.$Name
}

function Resolve-AutoHost {
    $probeRules = @(
        [PSCustomObject]@{ Host = "cursor"; SkillRoot = ".cursor/skills" },
        [PSCustomObject]@{ Host = "claude-code"; SkillRoot = ".claude/skills" },
        [PSCustomObject]@{ Host = "opencode"; SkillRoot = ".opencode/skills" },
        [PSCustomObject]@{ Host = "trae"; SkillRoot = ".trae/skills" },
        [PSCustomObject]@{ Host = "zcode"; SkillRoot = ".zcode/skills" },
        [PSCustomObject]@{ Host = "codex"; SkillRoot = ".codex/skills" },
        [PSCustomObject]@{ Host = "generic"; SkillRoot = ".agents/skills" }
    )

    foreach ($rule in $probeRules) {
        $candidateRoot = Join-Path $projectRoot (ConvertTo-NativeRelativePath -Path $rule.SkillRoot)
        if (Test-Path -LiteralPath $candidateRoot -PathType Container) {
            return $rule
        }
    }

    return [PSCustomObject]@{ Host = "generic"; SkillRoot = $null }
}

$resolvedHost = $TargetHost
$autoSkillRoot = $null
if ($resolvedHost -eq "auto") {
    $autoResult = Resolve-AutoHost
    $resolvedHost = $autoResult.Host
    $autoSkillRoot = $autoResult.SkillRoot
}

$adapter = Get-Adapter -Name $resolvedHost
$selectedSkillsRoot = $adapter.skillRoots[0]
if ($autoSkillRoot) {
    $selectedSkillsRoot = $autoSkillRoot
}
$preferredSkillsRoot = ConvertTo-NativeRelativePath -Path $selectedSkillsRoot
$targetRoot = Join-Path $projectRoot $preferredSkillsRoot
New-Item -ItemType Directory -Path $targetRoot -Force | Out-Null
$targetRootResolved = Resolve-Path -LiteralPath $targetRoot

$skillNames = @("solo-spec")
if ($Mode -eq "enhanced") {
    $skillNames += @(
        "solo-spec-product",
        "solo-spec-ux",
        "solo-spec-architecture",
        "solo-spec-tdd",
        "solo-spec-qa",
        "solo-spec-release"
    )
}

$installed = @()

foreach ($skillName in $skillNames) {
    $source = Join-Path $sourceRoot $skillName
    if (-not (Test-Path -LiteralPath $source -PathType Container)) {
        throw "Missing source skill: $source"
    }

    $target = Join-Path $targetRoot $skillName

    if (Test-Path -LiteralPath $target) {
        if (-not $Force) {
            throw "Target already exists: $target. Re-run with -Force to replace SoloSpec skills in this project."
        }

        $targetResolved = Resolve-Path -LiteralPath $target
        $allowedPrefix = $targetRootResolved.Path.TrimEnd("\") + "\"
        if (-not $targetResolved.Path.StartsWith($allowedPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to remove path outside target skills directory: $($targetResolved.Path)"
        }

        Remove-Item -LiteralPath $targetResolved.Path -Recurse -Force
    }

    Copy-Item -LiteralPath $source -Destination $target -Recurse
    $installed += $skillName
}

[PSCustomObject]@{
    Project = $projectRoot.Path
    Mode = $Mode
    Host = $resolvedHost
    RequestedHost = $TargetHost
    HostStatus = $adapter.status
    SkillsPath = $targetRootResolved.Path
    CompatibleSkillsPaths = ($adapter.skillRoots -join ", ")
    Installed = ($installed -join ", ")
}
