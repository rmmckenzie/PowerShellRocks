Import-Module ActiveDirectory

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
$ssImport = "C:\Scripts\temp.txt"
$requesterTicketType = GetStringBetweenTwoStrings -firstString "Request Type: " -secondString "Requester Name:" -importPath $ssImport
$requesterFullName = GetStringBetweenTwoStrings -firstString "Requester Name: " -secondString "Requester E-Mail:" -importPath $ssImport
$requesterEmail = GetStringBetweenTwoStrings -firstString "Requester E-Mail: " -secondString "Requester Contact Number:" -importPath $ssImport
#String Splits - Current School
$CurrentSchoolName = GetStringBetweenTwoStrings -firstString "School Name: " -secondString "New School Name:" -importPath $ssImport
#String Splits - New User Creation Details
$newUserRequestFullName = GetStringBetweenTwoStrings -firstString "Users Name " -secondString "Users Name" -importPath $ssImport
#$newUserYearGroup = GetStringBetweenTwoStrings -firstString "Year Group: " -secondString "" -importPath $ssImport
$searchYearGroup = "Year Group: "
$lineSearch = Get-Content $ssImport | Select-String $searchYearGroup


if($requesterTicketType.ToString() -match "User Creation"){
    Write-Host "User Creation Ticket - Requester Details" -ForegroundColor Red
    $requesterTicketType
    $requesterFullName
    $requesterEmail
    $CurrentSchoolName          
    #Name Splittin
    Write-Host "User Creation Ticket - New Username Details" -ForegroundColor Red
    $userFullName = $newUserRequestFullName.Trim("(New): ")
    $pos = $userFullName.IndexOf(" ")
    $FirstName = $userFullName.Substring(0, $pos)
    $LastName = $userFullName.Substring($pos+1)
    #Year Group
    $userYearGroup = $lineSearch.ToString().Trim("Year Group: ")

    switch ($userYearGroup)
    {
        1 { $yearOfEntry = 22}
        2 { $yearOfEntry = 21}
        3 { $yearOfEntry = 20}
        4 { $yearOfEntry = 19}
        5 { $yearOfEntry = 18}
        6 { $yearOfEntry = 17}

    } $userYearGroup

    if($CurrentSchoolName -match "Alderman"){
        $schoolID =  "ACS"
    } elseif ($CurrentSchoolName -match "Brotherton") {
        $schoolID =  "BB"
    } elseif ($CurrentSchoolName -match "Braeburn") {
        $schoolID =  "BRA"
    } elseif ($CurrentSchoolName -match "Camblesforth") {
        $schoolID =  "CAM"
    } elseif ($CurrentSchoolName -match "Easington") {
        $schoolID =  "EP"
    } elseif ($CurrentSchoolName -match "Filey") {
        $schoolID =  "FIS"
    } elseif ($CurrentSchoolName -match "Moor") {
        $schoolID =  "HM"
    } elseif ($CurrentSchoolName -match "Haxby") {
        $schoolID =  "HR"
    } elseif ($CurrentSchoolName -match "Lakeside") {
        $schoolID =  "LP"
    } elseif ($CurrentSchoolName -match "Marfleet") {
        $schoolID =  "MAR"
    } elseif ($CurrentSchoolName -match "Osbaldwick") {
        $schoolID =  "OP"
    } elseif ($CurrentSchoolName -match "Grove") {
        $schoolID =  "PG"
    } elseif ($CurrentSchoolName -match "Patrington") {
        $schoolID =  "PP"
    } elseif ($CurrentSchoolName -match "Riston") {
        $schoolID =  "RIS"
    } elseif ($CurrentSchoolName -match "Wilkinson") {
        $schoolID =  "RW"
    } elseif ($CurrentSchoolName -match "Sproatley") {
        $schoolID =  "SE"
    } elseif ($CurrentSchoolName -match "Staynor") {
        $schoolID =  "SH"
    } elseif ($CurrentSchoolName -match "Sigglesthorne") {
        $schoolID =  "SIG"
    } elseif ($CurrentSchoolName -match "Tadcaster") {
        $schoolID =  "TAD"
    } elseif ($CurrentSchoolName -match "Tockwith") {
        $schoolID =  "TOC"
    } else {
        Write-Host "Not a real school"
    }

    $LogPath   = "C:\Academy User Scripts\Pupils_AD_Users.log"
    $emailPath = "C:\Academy User Scripts\Test\Pupil_EmailLog.txt"
    Clear-Content $emailPath
    $exportedUsernamesPath = "C:\Academy User Scripts\Test\Usernames.CSV"
    Clear-Content $exportedUsernamesPath
    "Username,Password" | Out-File $exportedUsernamesPath -Append
    $CSVPath            = "C:\Academy User Scripts\Test\Pupils_AD_Users1.csv"

    function CreateUser(){
        $MAT_Varibles = Import-LocalizedData -BaseDirectory "C:\Academy User Scripts\Misc" -FileName MAT_Varibles.psd1
        $ComputerDomainInfo              = Get-ADDomain -Current LocalComputer
        $ComputerDomainDistinguishedName = $ComputerDomainInfo.DistinguishedName
        $ComputerDNSDomain               = $ComputerDomainInfo.DNSRoot
        $ComputerDomainName              = $ComputerDomainInfo.Name
        #
        # - Sets Static Variables
        #$Date               = Get-Date
        $i                  = 0
        # - Sets Organization Variables
        $TopLevelOUName     = $MAT_Varibles.TopLevelOUName
        $RootUsersOU        = "OU=Users,OU=$TopLevelOUName,$ComputerDomainDistinguishedName"
        $DriveLetter        = "M:"
        # -- Admin - Active Directory / Home Folder / Profiles Home Variables
        $Description           = $SchoolID + " Pupil User"
        $Pupil_LocationOU      = "OU=$YearOfEntry,OU=Pupils,OU=$SchoolID,$RootUsersOU"
        $Pupil_LocationOUNew   = "OU=Pupils,OU=$SchoolID,$RootUsersOU"
        $MATDataServer         = $MAT_Varibles.School_Varibles.$SchoolID.MATDataServer
        $Pupil_HomeDirectory   = "\\$MATDataServer\Pupils\$SchoolID\$YearOfEntry"
        $Pupil_ProfilePath     = "\\$MATDataServer\Profiles$\Pupils\$SchoolID\$YearOfEntry"  
        $MailDomain            = $MAT_Varibles.School_Varibles.$SchoolID.Email
        #
        $DisplayID          = $MAT_Varibles.School_Varibles.$SchoolID.DisplayID
        $DisplayName        = $FirstName + " " + $LastName + " (" + $DisplayID + ")"
        #$ADUserAlias        = "$ComputerDomainName\$Username"
        # - Home Folder & Profile Variables
        $ProfilePath        = "$Pupil_ProfilePath\$Username"
        $HomeRoot           = "$Pupil_HomeDirectory\$Username".ToLower()
        $HomeDirectory      = "$HomeRoot\Documents"
        $UserPrincipalName  = "$Username`@$ComputerDNSDomain".toLower()
        $EmailAddress       = "$Username`@$MailDomain"
        $i++
        # -- Converts Password to a Secure String     
        $SecurePassword     = ConvertTo-SecureString -AsPlainText $Password -force
        # Checks if OU Exists
        $OuCheck = [System.DirectoryServices.DirectoryEntry]::Exists("LDAP://$Pupil_LocationOU")
        # Creates OU If doesnt Exists 
        If ($OuCheck -eq $false) {New-ADOrganizationalUnit -Name $YearOfEntry -Path $Pupil_LocationOUNew}
        # Creates AD User
        New-ADUser -Name $Username -DisplayName $DisplayName -UserPrincipalName $UserPrincipalName -GivenName $FirstName -Surname $LastName -Description $Description -AccountPassword $SecurePassword -ChangePasswordAtLogon $False -PasswordNeverExpires $True -CannotChangePassword $False -Enabled $True -HomeDirectory "$HomeDirectory" -HomeDrive "$DriveLetter" -ProfilePath "$ProfilePath" -Path "$Pupil_LocationOU" -EmailAddress $EmailAddress
        #
        # Creates Users Home Folder
        New-Item "$HomeDirectory" -Type Directory
        New-Item -ErrorAction Ignore "$Pupil_ProfilePath" -Type Directory
        #
        # Pauses Script for 3 Seconds
        Start-Sleep -Seconds 3
        #
        # Sets Permisssions on Users Home Folder 
        icacls.exe $HomeRoot /Grant "${username}:(OI)(CI)M"
        #
        # Set User Group memberships
        If ($SchoolID -ne "MISC") {
        Add-ADGroupMember "$SchoolID`.Pupils" $Username
        }
        #
        # Ouput to log file
        $output  = $i.ToString() + ") Name: " + $DisplayName + "," + " Username: " + $Username + "," + " Initial Password: " + $_.Password + "," + " School ID: " + $SchoolID
        $output | Out-File $logpath -append
        # Email Output File
        $fullName = "Name: $FirstName $LastName" | Add-Content $emailPath 
        $emailOutput = "Username: $emailaddress" | Add-Content $emailPath 
        $passwordOutput = "Password: $password" | Add-Content $emailPath 
        "" | Add-Content $emailPath
        #Output Usernames
        "$username,$password" | Out-File $exportedUsernamesPath -Append

    }

        if($firstName -match "-"){
            $pos = $FirstName.IndexOf("-")
            $left = $FirstName.Substring(0, $pos)
            $FirstName = $left
            Write-Host "Users first name contains a - this has been removed for the username."
        }

        $usernameLength = 1
        $Username = $YearOfEntry + $FirstName.ToLower() + $LastName.Substring(0,$usernameLength).ToLower()
        $UsernameLower = $Username.ToLower()

        Try   { $exists = Get-ADUser -LDAPFilter "(sAMAccountName=$UsernameLower)" }
        Catch {}
        If(!$exists){
            CreateUser
        } else {
            while($exists){
                    $Username = $YearOfEntry + $FirstName.ToLower() + $LastName.Substring(0,$usernameLength).ToLower()
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
    echo "Test"
} elseif ($requesterTicketType.ToString() -match "User Change Request*") {
    echo "testda"
} elseif ($requesterTicketType.ToString() -match "User Name Change"){
    echo "Test1"
} else {
    echo "Type not found"
}

