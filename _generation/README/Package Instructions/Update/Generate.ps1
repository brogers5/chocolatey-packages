[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $PackageID,
    [Parameter()] [switch] $DifferentEnvironment,
    [Parameter()] [switch] $GitHub
)

if ($GitHub)
{
    $templateFilePath = '.\Update-GitHub.md.template'
}
else
{
    $templateFilePath = '.\Update.md.template'
}

if ($DifferentEnvironment)
{
    $environmentType = Read-Host -Prompt "Please define the environment (e.g. `"64-bit Windows 10 v1903+`")"
    $environmentType = "with a $environmentType environment similar to the"
}
else 
{
    $environmentType = 'using the'
}

$filePath = '.\Update.md'
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