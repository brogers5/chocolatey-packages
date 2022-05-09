[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $BasePackageID,
    [Parameter(Mandatory = $true)] [string] $BasePackageTitle,
    [Parameter(Mandatory = $true)] [ValidateSet('virtual', 'installer', 'portable')] [string] $PackageType
)

$templateFilePath = ".\PackageFamily.MD.template"
$filePath = ".\PackageFamily.MD"
Copy-Item -Path $templateFilePath -Destination $filePath -Force

$tokenList = @{
    packageId = $BasePackageID
    packageTitle = $BasePackageTitle
    packageType = $PackageType
}

$contents = Select-String -Pattern "\* For the $PackageType package," -Path $filePath -NotMatch | ForEach-Object {$_.Line + "`r`n"}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline