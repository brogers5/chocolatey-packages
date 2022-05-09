[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $PackageID
)

$templateFilePath = ".\Update.md.template"

$filePath = ".\Update.md"
Copy-Item -Path $templateFilePath -Destination $filePath -Force
$contents = Get-Content -Path $filePath -Raw

$tokenList = @{
    packageId = $PackageID
    firstVersion = $FirstVersion
}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline