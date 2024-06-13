$downloadUrl = "https://example.com/path/to/PaperCutMobilityPrintInstaller.exe"
$outputFile = "C:\Path\To\Installer\PaperCutMobilityPrintInstaller.exe"
Invoke-WebRequest -Uri $downloadUrl -OutFile $outputFile

$installerPath = "C:\Path\To\Installer\PaperCutMobilityPrintInstaller.exe"
Start-Process -FilePath $installerPath -ArgumentList "/silent /norestart" -Wait

if (Test-Path "C:\Program Files\PaperCut Mobility Print") {
    Write-Host "PaperCut Mobility Print is installed successfully."
} else {
    Write-Host "PaperCut Mobility Print installation failed."
}
