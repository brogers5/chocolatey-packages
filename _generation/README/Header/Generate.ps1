[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $PackageID,
    [Parameter(Mandatory = $true)] [string] $PackageTitle,
    [Parameter(Mandatory = $true)] [string] $IconCommitHash
)

$templateFilePath = ".\Header.MD.template"
$filePath = ".\Header.MD"
Copy-Item -Path $templateFilePath -Destination $filePath -Force
$contents = Get-Content -Path $filePath -Raw

$tokenList = @{
    packageId = $PackageID
    commitHash = $IconCommitHash
    packageTitle = $PackageTitle
}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline