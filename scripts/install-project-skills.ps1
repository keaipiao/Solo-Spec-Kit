param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [ValidateSet("basic", "enhanced")]
    [string]$Mode = "enhanced",

    [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")
$sourceRoot = Join-Path $repoRoot "skills"

if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
    throw "ProjectPath does not exist or is not a directory: $ProjectPath"
}

$projectRoot = Resolve-Path -LiteralPath $ProjectPath
$targetRoot = Join-Path $projectRoot ".agents\skills"
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
    SkillsPath = $targetRootResolved.Path
    Installed = ($installed -join ", ")
}
