[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $PackageID,
    [Parameter(Mandatory = $true)] [string] $FirstVersion,
    [Parameter()] [switch] $Inherited,
    [Parameter()] [switch] $HasDependency
)

if ($Inherited.IsPresent)
{
    $templateFilePath = ".\Inherited Install.md.template"
}
else
{
    $templateFilePath = ".\Install.md.template"
}

$installSource = 'the current directory'
if ($HasDependency.IsPresent)
{
    $packageSource = '.;https://community.chocolatey.org/api/v2/'
    $installSource += ' (with dependencies sourced from the Community Repository)'
}
else
{
    $packageSource = '.'
}

$filePath = ".\Install.md"
Copy-Item -Path $templateFilePath -Destination $filePath -Force
$contents = Get-Content -Path $filePath -Raw

$tokenList = @{
    packageId = $PackageID
    firstVersion = $FirstVersion
    packageSource = $packageSource
    installSource = $installSource
}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline