[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $PackageID,
    [Parameter(Mandatory = $true)] [string] $PackageTitle,
    [Parameter(Mandatory = $true)] [string] $ExampleVersion,
    [Parameter()] [switch] $Redistributed,
    [Parameter()] [switch] $Mirrored,
    [Parameter()] [switch] $GitHub
)

if ($Redistributed.IsPresent)
{
    $packageType = Read-Host -Prompt 'Enter the type of software this package consumes (i.e. installer/portable)'
    $distributionType = Read-Host -Prompt 'Enter the type of package this software is distributed in (i.e. binary/binaries, MSI(s), ZIP archive(s))'
    $templateFilePath = ".\Redistributed Build.md.template"

    if ($GitHub)
    {
        $requiredModules = "the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au), and the [PowerShellForGitHub PowerShell Module](https://github.com/microsoft/PowerShellForGitHub)"
    }
    else
    {
        $requiredModules = "and the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au)"
    }
}
else
{
    $templateFilePath = ".\Downloaded Build.md.template"
}

$filePath = ".\Build.md"
Copy-Item -Path $templateFilePath -Destination $filePath -Force
$contents = Get-Content -Path $filePath -Raw

if ($null -ne $distributionType -and $distributionType.EndsWith('s'))
{
    $linkingVerb = 'are'
}
else
{
    $linkingVerb = 'is'
}

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
    packageType = $packageType
    versionTemplate = $versionTemplate
    distributionType = $distributionType
    linkingVerb = $linkingVerb
    downloadLocation = $downloadLocation
    requiredModules = $requiredModules
}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline