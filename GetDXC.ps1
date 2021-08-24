$SaveFolder = $args[0]
if ($args.count -lt 1)
{
	Write-Host "Missing save folder parameter"
}

New-Item -ItemType Directory -Force -Path $SaveFolder

$JSONURL = "https://api.github.com/repos/microsoft/DirectXShaderCompiler/releases/latest"
$JSON = Invoke-WebRequest -Uri $JSONURL
$ParsedJSON = ConvertFrom-Json -InputObject $JSON
$Assets = Select-Object -InputObject $ParsedJSON -ExpandProperty assets
Foreach ($Asset IN $Assets)
{
	if ($Asset.name -match 'dxc.*.zip')
	{
		$DownloadURL = $Asset.browser_download_url
		$ZIPPath = Join-Path -Path $SaveFolder -ChildPath "dxc.zip"
		Invoke-WebRequest -Uri $DownloadURL -OutFile $ZIPPath
		Expand-Archive -Path $ZIPPath -DestinationPath $SaveFolder -Force
		Remove-Item -Path $ZIPPath
		Write-Host "Sucessfully downloaded DXC $($Asset.name)"
		exit 0
	}
}

Write-Host "Something went wrong, couldn't download DXC"
exit 1
