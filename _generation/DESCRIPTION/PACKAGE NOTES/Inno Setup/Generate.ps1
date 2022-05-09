[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $PackageID,
    [Parameter(Mandatory = $true)] [string] $Version,
    [Parameter()] [switch] $DualArchitecture
)

$templateFilePath = ".\Inno Setup.md.template"
$filePath = ".\Inno Setup.md"
Copy-Item -Path $templateFilePath -Destination $filePath -Force
$contents = Get-Content -Path $filePath -Raw

if ($DualArchitecture.IsPresent)
{
    $link = "reuploaded for quick reference:
* [32-bit installer](https://github.com/brogers5/chocolatey-package-%packageId%/tree/v%version%/install_script_x86.iss)
* [64-bit installer](https://github.com/brogers5/chocolatey-package-%packageId%/tree/v%version%/install_script_x64.iss)"
}
else 
{
    $link = "[reuploaded for quick reference](https://github.com/brogers5/chocolatey-package-%packageId%/tree/v%version%/install_script.iss)."
}

$contents = $contents -replace '%link%', $link

$tokenList = @{
    version = $Version
    packageId = $PackageID
}

foreach ($token in $tokenList.GetEnumerator())
{
    $pattern = '%{0}%' -f $token.key
    $contents = $contents -replace $pattern, $token.Value
}

Out-File -FilePath $filePath -InputObject $contents -Force -NoNewline