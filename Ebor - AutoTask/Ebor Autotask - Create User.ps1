Import-Module ActiveDirectory
Import-Module Autotask

$ticketNumber = Read-Host "Enter ticket number"

$User = "hbjok3uryxv4yk2@ACADEMIA.CO.UK"
$PWord = ConvertTo-SecureString -String '6Er~N#8ybL@3$7Jd9Df**1AtP' -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
$ApiTrackingIdentifier = 'BJBWUDOSPVKK23UKZVK3MSQQCMP'

Get-Atwsticket -ticketNumber $ticketNumber | Select -Expand Description | Out-File "C:\Academy User Scripts\Autotask\Tickets\$ticketNumber.txt"


function GetStringBetweenTwoStrings($firstString, $secondString, $importPath){
    #Get content from file
    $file = Get-Content $importPath
    #Regex pattern to compare two strings
    $pattern = "$firstString(.*?)$secondString"
    #Perform the opperation
    $result = [regex]::Match($file,$pattern).Groups[1].Value
    #Return result
    return $result
}

#String Splits - Requester Details
$ssImport = "C:\Academy User Scripts\Autotask\Tickets\$ticketNumber.txt"
$requesterTicketType = GetStringBetweenTwoStrings -firstString "Request Type: " -secondString "Requester Name:" -importPath $ssImport
$requesterFullName = GetStringBetweenTwoStrings -firstString "Requester Name: " -secondString "Requester E-Mail:" -importPath $ssImport
$requesterEmail = GetStringBetweenTwoStrings -firstString "Requester E-Mail: " -secondString "Requester Contact Number:" -importPath $ssImport
#String Splits - Current School
$CurrentSchoolName = GetStringBetweenTwoStrings -firstString "School Name: " -secondString "New School Name:" -importPath $ssImport
#String Splits - New User Creation Details
$newUserRequestFullName = GetStringBetweenTwoStrings -firstString 'Users Name \(New\): ' -secondString "Users Name" -importPath $ssImport
$newUserRole = GetStringBetweenTwoStrings -firstString 'User Role: ' -secondString "Users Name \(New\): " -importPath $ssImport
$newUserTitle = GetStringBetweenTwoStrings -firstString "Users Title \(New\): " -secondString "Users Title: " -importPath $ssImport
$newUserGroups = GetStringBetweenTwoStrings -firstString "Group Memberships: " -secondString "Additional Group Memberships:" -importPath $ssImport
$newCurrentUserTitle = GetStringBetweenTwoStrings -firstString "Users Title \(Current\): " -secondString "Group Memberships:" -importPath $ssImport

if($requesterTicketType.ToString() -match "User Creation"){
    Write-Host "User Creation Ticket - Requester Details" -ForegroundColor Red
    $requesterTicketType
    $requesterFullName
    $requesterEmail
    $CurrentSchoolName          
    #Name Splitting
    Write-Host "User Creation Ticket - New Username Details" -ForegroundColor Red
    Write-Host $newUserRequestFullName
    $userFullName = $newUserRequestFullName.Trim()
    $pos = $userFullName.IndexOf(" ")
    $FirstName = $userFullName.Substring(0, $pos)
    $LastName = $userFullName.Substring($pos+1)

    if($newUserTitle.Length -gt 1){
        #Write-Host $newUserTitle.Length
        $Title = $newUserTitle
    } elseif ($newCurrentUserTitle -gt 2){
        #Write-Host "Current Title"
        $Title = $newCurrentUserTitle
    } else {
        #Write-Host "No title found"
        $title = ""
    }

       
    $password = Read-Host "Enter AD password"
    $GPassword = Read-Host "Enter Google password"

    if($CurrentSchoolName -match "Alderman"){
        $schoolID =  "ACS"
        $GOU = "Alderman Cogan"
    } elseif ($CurrentSchoolName -match "Church of England Infant Academy"){
        $schoolID =  "ASI"
        $GOU = "All Saints/Infants"
    } elseif ($CurrentSchoolName -match "Church of England Junior Academy"){
        $schoolID =  "ASJ"
        $GOU = "All Saints/Junior"
    } elseif ($CurrentSchoolName -match "Brotherton") {
        $schoolID =  "BB"
        $GOU = "Brotherton and Byram"
    } elseif ($CurrentSchoolName -match "Braeburn") {
        $schoolID =  "BRA"
        $GOU = "Braeburn"
    } elseif ($CurrentSchoolName -match "Camblesforth") {
        $schoolID =  "CAM"
        $GOU = "Camblesforth"
    } elseif ($CurrentSchoolName -match "Easington") {
        $schoolID =  "EP"
        $GOU = "Easington"
    } elseif ($CurrentSchoolName -match "Filey") {
        $schoolID =  "FIS"
        $GOU = "Filey Infants"
    } elseif ($CurrentSchoolName -match "Moor") {
        $schoolID =  "HM"
        $GOU = "Hob Moor/HMP"
    } elseif ($CurrentSchoolName -match "Haxby") {
        $schoolID =  "HR"
        $GOU = "Haxby Road"
    } elseif ($CurrentSchoolName -match "Lakeside") {
        $schoolID =  "LP"
        $GOU = "Lakeside"
    } elseif ($CurrentSchoolName -match "Marfleet") {
        $schoolID =  "MAR"
        $GOU = "MAR"
    } elseif ($CurrentSchoolName -match "Osbaldwick") {
        $schoolID =  "OP"
        $GOU = "Osbaldwick"
    } elseif ($CurrentSchoolName -match "Grove") {
        $schoolID =  "PG"
        $GOU = "Park Grove"
    } elseif ($CurrentSchoolName -match "Patrington") {
        $schoolID =  "PP"
        $GOU = "Patrington"
    } elseif ($CurrentSchoolName -match "Riston") {
        $schoolID =  "RIS"
        $GOU = "Riston"
    } elseif ($CurrentSchoolName -match "Wilkinson") {
        $schoolID =  "RW"
        $GOU = "Robert Wilkinson"
    } elseif ($CurrentSchoolName -match "Sproatley") {
        $schoolID =  "SE"
        $GOU = "Sproatley Endowed"
    } elseif ($CurrentSchoolName -match "Staynor") {
        $schoolID =  "SH"
        $GOU = "Staynor Hall"
    } elseif ($CurrentSchoolName -match "Sigglesthorne") {
        $schoolID =  "SIG"
        $GOU = "Sigglesthorne"
    } elseif ($CurrentSchoolName -match "Tadcaster") {
        $schoolID =  "TAD"
        $GOU = "Tadcaster"
    } elseif ($CurrentSchoolName -match "Tockwith") {
        $schoolID =  "TOC"
        $GOU = "Tockwith"
    } else {
        Write-Host "Not a real school"
    }
    Clear-Content $emailPath
    $exportedUsernamesPath = "C:\Academy User Scripts\Test\Usernames.CSV"
    Clear-Content $exportedUsernamesPath
    "Username,Password" | Out-File $exportedUsernamesPath -Append

    function CreateUser(){
        $MAT_Varibles = Import-LocalizedData -BaseDirectory "C:\Academy User Scripts\Misc" -FileName MAT_Varibles.psd1
        $ComputerDomainInfo              = Get-ADDomain -Current LocalComputer
        $ComputerDomainDistinguishedName = $ComputerDomainInfo.DistinguishedName
        $ComputerDNSDomain               = $ComputerDomainInfo.DNSRoot
        $ComputerDomainName              = $ComputerDomainInfo.Name
        #
        # - Sets Static Variables
        $Date               = Get-Date
        $i                  = 0
        # - Sets Organization Variables
        $TopLevelOUName     = $MAT_Varibles.TopLevelOUName
        $RootUsersOU        = "OU=Users,OU=$TopLevelOUName,$ComputerDomainDistinguishedName"
        $DriveLetter        = "M:"
        # -- Admin - Active Directory / Home Folder / Profiles Home Variables
        $Description           = $SchoolID + " Staff User"
        $Staff_LocationOU      = "OU=Staff,OU=$SchoolID,$RootUsersOU"
        $MATDataServer         = $MAT_Varibles.School_Varibles.$SchoolID.MATDataServer
        $Staff_HomeDirectory   = "\\$MATDataServer\Staff\$SchoolID"
        $Staff_ProfilePath     = "\\$MATDataServer\RoamingProfiles`$\Staff\$SchoolID"  
        $MailDomain            = $MAT_Varibles.School_Varibles.$SchoolID.Email
        #
        $UserPrincipalName  = "$Username`@$ComputerDNSDomain".toLower()
        $DisplayID          =  $MAT_Varibles.School_Varibles.$SchoolID.DisplayID
        $DisplayName        =  $Title + " " + $FirstName.Substring(0,1) + " " + $LastName + " (" + $DisplayID + ")"
        $ADUserAlias        = "$ComputerDomainName\$Username"
        $EmailAddress       = "$Username`@ebor.academy"
        # - Home Folder & Profile Variables
        $HomeRoot           = "$Staff_HomeDirectory\$Username"
        $HomeDirectory      = "$HomeRoot\Documents"
        $ProfilePath        = "$Staff_ProfilePath\$Username"  
        # -- Converts Password to a Secure String     
        $SecurePassword     = ConvertTo-SecureString -AsPlainText $Password -force
        # Creates AD User
        New-ADUser -Name $Username -DisplayName $DisplayName -UserPrincipalName $UserPrincipalName -GivenName $FirstName -Surname $LastName -Description $Description -AccountPassword $SecurePassword -ChangePasswordAtLogon $False -PasswordNeverExpires $True -CannotChangePassword $False -Enabled $True -HomeDirectory "$HomeDirectory" -HomeDrive "$DriveLetter" -Path "$Staff_LocationOU" -EmailAddress $EmailAddress
        #
        # Creates Users Home Folder
        New-Item "$HomeDirectory" -Type Directory
        #New-Item -ErrorAction Ignore "$Staff_ProfilePath" -Type Directory
        #
        # Pauses Script for 3 Seconds
        Sleep -Seconds 3
        #
        # Sets Permisssions on Users Home Folder 
        icacls.exe $HomeRoot /Grant "${username}:(OI)(CI)M"
        #
        # Set User Group memberships

        
        
        # Ouput to log file
        $outputPath = "C:\Academy User Scripts\Autotask\Tickets\Outputs"
        $outPath = New-Item "$outputPath\$ticketNumber - Output.txt"
        #$output  = $i.ToString() + ") Name: " + $DisplayName + "," + " Username: " + $Username + "," + " Initial Password: " + $_.Password + "," + " School ID: " + $SchoolID
        # Email Output File
        "Name: $newUserRequestFullName" | Add-Content $outPath
        "Username: $username" | Add-Content $outPath
        "Email: $emailaddress" | Add-Content $outPath 
        "Password: $Gpassword" | Add-Content $outPath 

        Write-Host "User has been created"

        & C:\GAM\Gam\Ebor\gam.exe create user $EmailAddress firstname $Title lastname $LastName password $GPassword changepassword on org /$GOU/Staff/

        #Group Array
        $groupArray = @()
        $groupSplits = $newUserGroups -replace '\s','' -split "," | foreach{$groupArray += $_}
        if($groupArray -eq "TeacherGroup"){
            #Google Group - Teachers
            Write-Host "Adding to Teacher Group"
            & C:\GAM\Gam\Ebor\gam.exe update group all.teachers.$schoolID add member $EmailAddress
        } if ($groupArray -eq "AdminGroup") {
            Write-Host "Adding to Admin Group"
            #AD & Google - Admin
            Add-ADGroupMember -Identity "$schoolID.admin" -Members $username
            & C:\GAM\Gam\Ebor\gam.exe update group all.admin.$schoolID add member $EmailAddress
        } if ($groupArray -eq "GovernorGroup") {
            #Google Group - Governor
            Write-Host "Adding to Governor Group"
            & C:\GAM\Gam\Ebor\gam.exe update group all.governors.$schoolID add member $EmailAddress
        } if ($groupArray -eq "TAGroup") {
            #Google Group - TAs
            if($schoolId -eq "BRA" -or $schoolId -eq "HR" -or $schoolId -eq "RW" -or $schoolId -eq "SH"){
                & C:\GAM\Gam\Ebor\gam.exe update group all.ats.$schoolID add member $EmailAddress
            } else {
                & C:\GAM\Gam\Ebor\gam.exe update group all.tas.$schoolID add member $EmailAddress
            }
        } if ($groupArray -eq "StaffGroup") {
            #AD - All Staff
            Write-Host "Adding to Staff Group"
            Add-ADGroupMember -Identity "$schoolID.staff" -Members $username
        }
        #All staff groups
        & C:\GAM\Gam\Ebor\gam.exe update group all.staff.$schoolID add member $EmailAddress
    }

    if($firstName -match "-"){
            $pos = $FirstName.IndexOf("-")
            $left = $FirstName.Substring(0, $pos)
            $FirstName = $left
            Write-Host "Users first name contains a - this has been removed for the username."
        }

        $usernameLength = 1
        $username = $FirstName.Substring(0,1).ToLower() + "." + $LastName.ToLower()
        $UsernameLower = $Username.ToLower()
        $UsernameLower

        Try   { $exists = Get-ADUser -LDAPFilter "(sAMAccountName=$UsernameLower)" }
        Catch {}
        If(!$exists){
            CreateUser
        } else {
            while($exists){
                    $Username = $FirstName.Substring(0,1).ToLower() + "." + $LastName.ToLower() + $usernameLength
                    $EmailAdress = $EmailAddress + $usernameLength
                    $usernameLength++
                    Try   { $exists = Get-ADUser -LDAPFilter "(sAMAccountName=$Username)" }
                    Catch {}
                    If($exists){
                        Write-Host "$username already exists, adding a letter."
                        Start-Sleep -s 1
                    } else {
                        CreateUser             
                    }
                } 
    }

} elseif ($requesterTicketType.ToString() -match "User Suspension") {
    Write-Host "Ticket Request - User Suspension Ticket"
    $newUserRequestFullName = GetStringBetweenTwoStrings -firstString 'Users Name \(Current\): ' -secondString "Users Title" -importPath $ssImport
    Write-Host "User Suspension Ticket - Requester Details" -ForegroundColor Red
    $requesterTicketType
    $requesterFullName
    $requesterEmail
    $CurrentSchoolName          
    #Name Splitting
    Write-Host "User Creation Ticket - New Username Details" -ForegroundColor Red
    Write-Host $newUserRequestFullName
    $userFullName = $newUserRequestFullName.Trim()
    $pos = $userFullName.IndexOf(" ")
    $FirstName = $userFullName.Substring(0, $pos).ToLower()
    $LastName = $userFullName.Substring($pos+1) 
    $suspendedUsername = $firstName.Substring(0,1) + "." + $LastName.ToLower()
    $suspendedUserCheck = Get-Aduser -ErrorAction SilentlyContinue -Filter {samAccountName -eq $suspendedUsername}

    $currentMonth = Get-Date -UFormat %B
    $currentYear = Get-Date -Format yyyy


    if ($suspendedUserCheck){
        Set-AdUser -Identity $suspendedUsername -Enabled $false
        & C:\GAM\Gam\Ebor\gam.exe update user "$suspendedUsername@ebor.academy" suspended on ou /*suspended/$currentYear/$currentMonth/
    } else {
        Write-Host "User not found. Please check the username."
    }
} 
 else {
    echo "Type not found"
}

