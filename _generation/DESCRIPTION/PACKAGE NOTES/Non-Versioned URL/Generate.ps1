[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $Vendor
)

$templateFilePath = ".\Non-Versioned URL.md.template"
$filePath = ".\Non-Versioned URL.md"
Copy-Item -Path $templateFilePath -Destination $filePath -Force
$contents = Get-Content -Path $filePath -Raw

$tokenList = @{
    vendor = $Vendor
}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline