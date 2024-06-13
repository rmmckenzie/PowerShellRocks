Import-Module MSOnline
Clear-Content "C:\Scripts\Users.txt"
$Report = [System.Collections.Generic.List[Object]]::new() # Create output file
#Connect-MsolService
$allGroups =@("06889a07-76f0-46ad-93d3-fb9bfdbf7123","1f1cfa81-e65f-45d1-b6f1-24ff62e09f04","47bef721-e2aa-48c3-ad44-1a40d0924a82","74a476f1-d55e-4b50-ab71-6d7bfab95980","
8005d2fe-8138-4884-8328-6d706e35613f","bf61032a-c012-42c3-afb6-deacdbf77fdd", "c2ae5be6-6388-444b-a972-6602445a7d1f","d79054a2-a935-41ce-8160-dec12b654429","e6a3743e-5303-4ac1-aa94-cd990a511cfc","fa1019c3-2b7f-4571-84a9-f46921528121","a6ef67be-05bc-47d9-bac2-7589666e1105")

$i = 0

foreach($group in $AllGroups){
    $i++
    $users = Get-MsolGroupMember -GroupObjectID "$group"
    $userAddress = $users.EmailAddress
    $userAddress | Out-File "C:\Scripts\Users.txt" -Append
}

$usersFile = Get-Content "C:\Scripts\Users.txt"

foreach($userName in $usersFile){

    $user = Get-MsolUser -UserPrincipalName $userName

    $MFADefaultMethod = ($User.StrongAuthenticationMethods | Where-Object { $_.IsDefault -eq "True" }).MethodType
    If ($User.StrongAuthenticationRequirements) {
        $MFAState = $User.StrongAuthenticationRequirements.State
    }
    Else {
        $MFAState = 'Disabled'
    }
    If ($MFADefaultMethod) {
        Switch ($MFADefaultMethod) {
            "OneWaySMS" { $MFADefaultMethod = "Text code authentication phone" }
            "TwoWayVoiceMobile" { $MFADefaultMethod = "Call authentication phone" }
            "TwoWayVoiceOffice" { $MFADefaultMethod = "Call office phone" }
            "PhoneAppOTP" { $MFADefaultMethod = "Authenticator app or hardware token" }
            "PhoneAppNotification" { $MFADefaultMethod = "Microsoft authenticator app" }
        }
    }
    Else {
        $MFADefaultMethod = "Not enabled"
    }
    $ReportLine = [PSCustomObject] @{
        UserPrincipalName = $User.UserPrincipalName
        DisplayName       = $User.DisplayName
        MFAState          = $MFAState
        MFADefaultMethod  = $MFADefaultMethod
        MFAPhoneNumber    = $MFAPhoneNumber
        PrimarySMTP       = ($PrimarySMTP -join ',')
        Aliases           = ($Aliases -join ',')
    }
                 
    $Report.Add($ReportLine)
}
Write-Host "Report is in c:\temp\MFAUsers.csv"
$Report | Select-Object UserPrincipalName, DisplayName, MFAState, MFADefaultMethod, MFAPhoneNumber, PrimarySMTP, Aliases | Sort-Object UserPrincipalName | Out-GridView
$Report | Sort-Object UserPrincipalName | Export-CSV -Encoding UTF8 -NoTypeInformation c:\temp\MFAUsers.csv

