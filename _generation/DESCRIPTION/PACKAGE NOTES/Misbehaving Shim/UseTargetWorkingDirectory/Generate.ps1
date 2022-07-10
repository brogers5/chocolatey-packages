[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $BinaryName,
    [Parameter()] [switch] $Gui
)

if ($Gui.IsPresent)
{
    $templateFilePath = ".\Misbehaving GUI Shim.md.template"
    
}
else {
    $templateFilePath = ".\Misbehaving Shim.md.template"
}

$filePath = ".\Misbehaving Shim.md"
Copy-Item -Path $templateFilePath -Destination $filePath -Force
$contents = Get-Content -Path $filePath -Raw

$tokenList = @{
    binaryName = $BinaryName
}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline