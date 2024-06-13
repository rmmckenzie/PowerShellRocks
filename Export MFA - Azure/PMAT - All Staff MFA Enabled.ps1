Import-Module MSOnline
$pmatOutput = "C:\Scripts\PMAT - Users.txt"
Clear-Content $pmatOutput   
$Report = [System.Collections.Generic.List[Object]]::new() # Create output file
#Connect-MsolService
$allGroups =@("0fd6db34-e565-4421-82e8-e5915c4b7e3a",
"fb2a13ec-5481-4000-b13e-dde9da5f9f2b",
"2f998189-1a2f-4847-a8c1-d2bf1494e5c7",
"69f61fad-1748-49e5-aedb-94b2b6161a71",
"516f3938-4f5c-4e5e-bb57-bc7e92f7e128",
"6cfd7c58-1de1-46dd-978f-dfef6133a4bc",
"f94209b1-4173-49b7-8a9c-1488eb362cec",
"3386c56a-dfa2-42ad-9a14-b9ba1c4c6075",
"cb79e491-9f32-48e6-80a9-d607f0a19f82",
"6f1cb7b4-2d74-4107-ac77-9d25f1f874c8",
"bb63de80-d1d6-4f8c-9efe-13e3c5ed1370",
"12506830-a9df-4f1b-b286-1a351e465ca4",
"e5a088af-5544-4ec4-b17a-263629b73499",
"fe142f90-8e37-49e4-8ea4-e60526249227",
"2567a8b9-c9c2-47a3-931c-a7abfefb224c",
"0e823300-bece-44f8-b58f-4640b2c7dd53",
"e59e6ffd-b839-4870-aaa1-4e306ef3f9e0",
"8f5c4a8f-c963-48cc-918e-b1448a360662",
"d07d5d29-c134-4501-9d17-f541d56bcc9a",
"7aa32872-1b48-445b-bd88-1c43bc18d000",
"73537747-c998-40c3-b128-08b43c037c64",
"e98faccb-7864-4406-bd93-923b117801e2",
"3f91d61f-dcdb-446a-946b-2261923c0e25",
"6eefb1d7-b0ba-45be-b26a-6a6164908b9d",
"78c375ad-17c4-4b7e-b8b9-d896d6395fff",
"c546ffc1-cb01-465d-ad8b-614a7738b7f2",
"bbc72ca2-6472-4bad-adf6-ddc675e15ea2",
"ef65baf2-79e6-4253-8033-044f2ef7fd1f",
"6b2d78aa-b9f2-4d51-86fc-3045007c7cdc",
"9202b7d6-b7b5-408b-a243-f31c86c6d528",
"e84b936e-eb2f-406e-967d-52175d7ced6c",
"cd344a90-35dc-4a47-971b-c408c32acc60",
"ebfc5c2a-df5f-4937-bc59-670189ea0c44",
"8c4268de-c49b-4dc3-9018-de237cd62764")
$i = 0

foreach($group in $AllGroups){
    $i++
    $users = Get-MsolGroupMember -GroupObjectID "$group"
    $userAddress = $users.EmailAddress
    $userAddress | Out-File $pmatOutput -Append
}

$usersFile = Get-Content $pmatOutput

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
Write-Host "Report is in c:\temp\MFAUsers - Azure.csv"
$Report | Select-Object UserPrincipalName, DisplayName, MFAState, MFADefaultMethod, MFAPhoneNumber, PrimarySMTP, Aliases | Sort-Object UserPrincipalName | Out-GridView
$Report | Sort-Object UserPrincipalName | Export-CSV -Encoding UTF8 -NoTypeInformation c:\temp\MFAUsers.csv


