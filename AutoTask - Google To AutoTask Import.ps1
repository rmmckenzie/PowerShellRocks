Import-Module Autotask
#Set variables
$user = "ewwwsnnpblaybjp@ACADEMIA.CO.UK"
$PWord = ConvertTo-SecureString '4s#LfD1@7~Apk8$P2Kt*W~0a$' -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

# Connect to the Autotask Web Services API
$ApiKey = "BJBWUDOSPVKK23UKZVK3MSQQCMP"
Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiKey

# Save your credentials locally (NB! Will be exported as SecureString in CliXML)
New-AtwsModuleConfiguration -Credential $Credential -SecureTrackingIdentifier ($ApiKey | ConvertTo-SecureString -AsPlainText -Force) -ProfileName Default

# Module can now load and connect automatically, so you can run any command directly
Get-AtwsAccount -id 0



#Get-Help New-AtwsModuleConfiguration

$importFile = Import-CSV "C:\Scripts\AutoTask Imports\TestImport.csv" -Header "First Name [Required]", "Last Name [Required]", "Email Address [Required]", "Password [Required]","Password Hash Function [UPLOAD ONLY]","OUPath" | Select -skip 1

$createdUsers = 0
$notCreatedUsers = 0

foreach($row in $importFile){
    $fn = $row."First Name [Required]"
    $sn = $row."Last Name [Required]"
    $email = $row."Email Address [Required]"
    $ou = $row."Org Unit Path [Required]"
    if($row.ouPath.ToString() -Match "Braeburn"){
        Write-Host "$fn $sn is a user at Braeburn"
    }

    $getEmail = Get-AtwsContact -Filter {EMailAddress -eq $email} | Select-Object -Exp EMailAddress

    if($getEmail.Length -eq "0"){
        Write-Host -ForegroundColor Yellow "Creating user... $email"
        $createdUsers++
    } else {
        Write-Host -ForegroundColor Red "User $getEmail exists already."
        $notCreatedUsers++
    }

}

Write-Host "Total Created users = $createdUsers"
Write-Host "Total Existing Users = $notCreatedUsers"




