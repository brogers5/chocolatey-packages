[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $PackageID
)

$filePath = ".\ChocoProtocol.md"
Copy-Item -Path ".\ChocoProtocol.md.template" -Destination $filePath -Force
$contents = Get-Content -Path $filePath -Raw

$tokenList = @{
    packageId = $PackageID
}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline