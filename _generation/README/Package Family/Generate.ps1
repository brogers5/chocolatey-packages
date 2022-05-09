[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $PackageID,
    [Parameter(Mandatory = $true)] [string] $PackageTitle,
    [Parameter(Mandatory = $true)] [ValidateSet('virtual', 'installer', 'portable')] [string] $PackageType
)

$templateFilePath = ".\PackageFamily.MD.template"
$filePath = ".\PackageFamily.MD"
Copy-Item -Path $templateFilePath -Destination $filePath -Force

$tokenList = @{
    packageId = $PackageID
    packageTitle = $PackageTitle
    packageType = $PackageType
}

$contents = Select-String -Pattern "\* For the $PackageType package," -Path $filePath -NotMatch | ForEach-Object {$_.Line + "`r`n"}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline