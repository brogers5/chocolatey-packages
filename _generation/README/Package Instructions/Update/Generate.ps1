[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $PackageID,
    [Parameter()] [switch] $DifferentEnvironment
)

if ($DifferentEnvironment.IsPresent)
{
    $environmentType = Read-Host -Prompt "Please define the environment (example: `"64-bit Windows 10+`")"
    $environmentType = "with a $environmentType environment similar to the"
}
else 
{
    $environmentType = "using the"
}

$templateFilePath = ".\Update.md.template"

$filePath = ".\Update.md"
Copy-Item -Path $templateFilePath -Destination $filePath -Force
$contents = Get-Content -Path $filePath -Raw

$tokenList = @{
    packageId = $PackageID
    firstVersion = $FirstVersion
    environmentType = $environmentType
}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline