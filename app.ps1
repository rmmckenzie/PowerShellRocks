#Set-ExecutionPolicy -ExecutionPolicy Bypass
Connect-MsolService -Credential "emailadmin@ApplefieldsSchool.onmicrosoft.com"

Get-MsolAccountSku

$c = Import-CSV "C:\Scripts\a.csv" -Header "email"

foreach($r in $c){
    $email = $r.email
    $pos = $email.IndexOf("@")
    $username = $email.Substring(0, $pos)
    $newEmail = "$username@applefieldsschool.co.uk"
    $n = "$username@applefields.york.sch.uk"
    Set-MsolUserLicense -AddLicenses "ApplefieldsSchool:STANDARDWOFFPACK_FACULTY"
}