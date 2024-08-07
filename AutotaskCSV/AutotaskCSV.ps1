$csvImportRootPath = "C:\PowershellRocks\PowerShellRocks\AutotaskCSV\Users"
$csvFiles = Get-ChildItem $csvImportRootPath

$i = 0

foreach($csv in $csvFiles){
    $d = 0
    $i++
    $csvFileName = $csv.Name
    $importedCSV = Import-CSV $csvImportRootPath\$csvFileName -Header "First Name [Required]", "Last Name [Required]", "Email Address [Required]", "Org Unit Path [Required]" | Select -skip 1
    foreach($row in $importedCSV){
        $email = $importedCSV."Email Address [Required]" 
        $fn = $importedCSV."First Name [Required]"
        $sn = $importedCSV."Last Name [Required]"
        $ou = $importedCSV."Org Unit Path [Required]"

        $firstName = (Get-Culture).TextInfo.ToTitleCase($fn[$d])
        $surname = (Get-Culture).TextInfo.ToTitleCase($sn[$d])

        if($ou[$d] -like "*Alderman*"){
            $company = "Alderman Cogan CE Primary Academy"

        } elseif ($ou[$d] -like "*All Saints*"){
            $company = "All Saints Church of England Federation of Academies Hessle"
        } elseif ($ou[$d] -like "*Braeburn*") {
            $company = "Braeburn Primary and Nursery Academy"

        } elseif ($ou[$d] -like "*Brotherton*") {
            $company = "Brotherton and Byram Community Primary Academy"

        } elseif ($ou[$d] -like "*Camblesforth*") {
            $company = "Camblesforth Community Primary Academy"

        } elseif ($ou[$d] -like "*Easington*") {
            $company = "Easington CofE Primary Academy"

        } elseif ($ou[$d] -like "*Filey Infants*") {
            $company = "Filey Church of England Nursery and Infants Academy"

        } elseif ($ou[$d] -like "*Haxby Road*") {
            $company = "Haxby Road Primary Academy"

        } elseif ($ou[$d] -like "*Hob Moor*") {
            $company = "Hob Moor Community Primary & Oaks Academy"

        } elseif ($ou[$d] -like "*Lakeside*") {
            $company = "Lakeside Primary Academy"
            
        } elseif ($ou[$d] -like "*MAR*") {
            $company =  "Marfleet Primary School"

        } elseif ($ou[$d] -like "*Osbaldwick*") {
            $company =  "Osbaldwick Primary Academy"

        } elseif ($ou[$d] -like "*Park Grove*") {
            $company =  "Park Grove Primary Academy"

        } elseif ($ou[$d] -like "*Patrington*") {
            $company =  "Patrington CofE Primary Academy"

        } elseif ($ou[$d] -like "*Riston*") {
            $company =  "Riston Church of England Primary Academy"

        } elseif ($ou[$d] -like "*Wilkinson*") {
            $company =  "Robert Wilkinson Primary Academy"

        } elseif ($ou[$d] -like "*Sproatley*") {
            $company =  "Sproatley Endowed CofE Academy"

        } elseif ($ou[$d] -like "*Staynor*") {
            $company =  "Staynor Hall Primary Academy"

        } elseif ($ou[$d] -like "*Sigglesthorne*") {
            $company =  "Sigglesthorne CofE Primary Academy"

        } elseif ($ou[$d] -like "*Tadcaster*") {
            $company =  "Tadcaster Primary Academy"

        } elseif ($ou[$d] -like "*Tockwith*") {
            $company =  "Tockwith Church of England Primary Academy"

        } elseif ($ou[$d] -like "*Sherburn*") {
            $company =  "Sherburn Primary School"

        }elseif ($ou[$d] -like "*Luttons*") {
            $company =  "Luttons Community Primary Academy"

        }
        elseif ($ou[$d] -like "*CST*") {
            $company =  "Ebor Academy Trust"

        }else {
            $company =  "NOT A SCHOOL"
            Write-Host $company
        }



























        $obj = [pscustomobject]@{
            "Company ID" = ""
            "[required] Company Name" = $company
            "Contact ID [updates only]" = ""
            "External ID" = ""
            "Prefix" = ""
            "[required] First Name" = $firstName
            "Middle Name" = ""
            "[required] Last Name" = $surname
            "Suffix" = ""
            "Title" = ""
            "[required] Email Address" = $email[$d]
            "Email Address 2" = ""
            "Email Address 3" = ""
            "Location" = ""
            "Address 1" = ""
            "Address 2" = ""
            "City" = ""
            "County" = ""
            "Post Code" = ""
            "Country" = ""
            "Additional Address Information" = ""
            "Phone" = ""
            "Extension" = ""
            "Alternate Phone" = ""
            "Mobile Phone" = ""
            "Fax" = ""
            "Facebook URL" = ""
            "Twitter URL" = ""
            "LinkedIn URL" = ""
            "Client Portal User Name" = ""
            "Client Portal Security Level" = ""
            "Active/Inactive" = ""
            "Primary Contact" = ""
            "Accepts Task/Ticket Email (yes or no)" = ""
            "Contact Detail Alert" = ""
            "New Ticket Alert" = ""
            "Ticket Detail Alert" = ""
        }
        $d++
        $obj | Export-CSV "C:\PowershellRocks\PowerShellRocks\AutotaskCSV\$i - ImportFile.csv" -NoTypeInformation -Append
    } 
}