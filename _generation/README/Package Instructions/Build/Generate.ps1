[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $PackageID,
    [Parameter(Mandatory = $true)] [string] $PackageTitle,
    [Parameter(Mandatory = $true)] [ValidateSet("virtual", "installer", "portable")] [string] $PackageType,
    [Parameter(Mandatory = $true)] [ValidateSet("binary", "MSI", "ZIP archive")] [string] $DistributionType,
    [Parameter(Mandatory = $true)] [string] $ExampleVersion,
    [Parameter()] [switch] $Redistributed,
    [Parameter()] [switch] $Mirrored
)

if ($Redistributed.IsPresent)
{
    $templateFilePath = ".\Redistributed Build.md.template"
}
else
{
    $templateFilePath = ".\Downloaded Build.md.template"
}

$filePath = ".\Build.md"
Copy-Item -Path $templateFilePath -Destination $filePath -Force
$contents = Get-Content -Path $filePath -Raw

if ($ExampleVersion.Split('.').Count -eq 2)
{
    $versionTemplate = "x.y"
}
elseif ($ExampleVersion.Split('.').Count -eq 3)
{
    $versionTemplate = "x.y.z"
}
elseif ($ExampleVersion.Split('.').Count -eq 4)
{
    $versionTemplate = "w.x.y.z"
}

if ($Mirrored)
{
    $downloadLocation = "mirror created by this package (to ensure reproducibility in case of an older version)"
}
else
{
    $downloadLocation = "official distribution point"
}

$tokenList = @{
    packageId = $PackageID
    packageTitle = $PackageTitle
    packageType = $PackageType
    versionTemplate = $versionTemplate
    distributionType = $DistributionType
    downloadLocation = $downloadLocation
}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline