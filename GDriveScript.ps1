$gDrivePath = "$env:LOCALAPPDATA\Google\DriveFS"

$folders = Get-ChildItem $gDrivePath | Where-Object { $_.PSIsContainer}

foreach($folder in $folders){
    $folderName = $folder.Name
    if($folderName.Length -gt 10){
        Copy-Item -Path "\\server079\Staff_Shared\Vital\core_feature_config" -Destination $gDrivePath\$folderName
    }
}