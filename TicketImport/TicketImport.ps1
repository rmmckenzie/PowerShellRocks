$csvImportRootPath = "C:\PowershellRocks\PowerShellRocks\TicketImport\Inputs"
$csvFiles = Get-ChildItem $csvImportRootPath

$d = 0

foreach($csv in $csvFiles){
    $csvFileName = $csv.Name
    $importedCSV = Import-CSV $csvImportRootPath\$csvFileName -Header "External (Legacy) Ticket ID", "Autotask Ticket Number (updates only)", "[required] Title", "Description", "Tags (separate with |)", "[required] Company", "Location", "Contact", "[required] Status", "[required] Priority",	"[required] Source", "Estimated Hours", "[required if no Queue] Primary Resource", "Role", "[required if no Primary Resource] Queue", "[required] Ticket Type", "Ticket Category", "Issue Type", "Sub-Issue Type",	"Division > Line of Business", "Work Type", "Configuration Item ID", "Configuration Item Name",	"Configuration Item Serial Number",	"Configuration Item Reference Number" ,"Configuration Item Reference Name" ,"Contract Name","Service Level Agreement", "Create Date/Time","Created By Resource",	"Created By Contact", "Complete Date/Time", "[required] Due Date/Time" ,"First Response Date/Time","First Response","Initiating Resource","Resolution","Completed By","Co-managed Visibility"    | Select -skip 1
    $d++
    foreach($row in $importedCSV){
        $title = $row."[required] Title"
        $description = $row."Description"
        $company = $row.'[required] Company'
        $location = $row.Location
        $status = $row.'[required] Status'
        $priority = $row.'[required] Priority'
        $source = $row.'[required] Source'
        $primaryResource = $row.'[required if no Queue] Primary Resource'
        $queue = "Support Tickets"
        $service = $row.'[required] Ticket Type'
        $ticketCategory = $row.'Ticket Category'
        $sla = $row.'Service Level Agreement'
        $createDate = $row.'Create Date/Time'
        $complete = $row.'Complete Date/Time'
        $due = $row.'[required] Due Date/Time'
        $firstResponse = $row.'First Response Date/Time'
        $comanaged = $row.'Co-managed Visibility'

        $char = "'"
        $newCompany = $company -replace $char, ""

        if($primaryResource -match "Robert"){
            $primaryResource = "McKenzie, Rob"
        }

        if($company -match "Hob Moor"){
            $company = "Hob Moor Community Primary & Oaks Academy"
        } elseif($company -match "Hope Learning"){
            $company = "Hope Sentamu Learning Trust"
        } elseif ($company -match "Newland"){
            $company = "Newland St Johns CE Academy"
        } elseif ($company -match "St James*") {
            $company = "St James CE Academy"
        }
        

        $obj = [pscustomobject]@{
            "External (Legacy) Ticket ID" = ""
            "Autotask Ticket Number (updates only)" = ""
            "[required] Title" = $title
            "Description" = $description
            "Tags (separate with |)" = ""
            "[required] Company" = $company
            "Location" = $location
            "Contact"	 = ""
            "[required] Status"	 = "Complete"
            "[required] Priority"	 = $priority
            "[required] Source"	 = "VitalYork"
            "Estimated Hours"	 = ""
            "[required if no Queue] Primary Resource" = $primaryResource
            "Role"	 = ""
            "[required if no Primary Resource] Queue" = $queue
            "[required] Ticket Type" = $service
            "Ticket Category" = "Imported Tickets"
            "Issue Type" = ""
            "Sub-Issue Type" = ""
            "Division > Line of Business" = ""
            "Work Type" = ""
            "Configuration Item ID" = ""
            "Configuration Item Name" = ""
            "Configuration Item Serial Number" = ""
            "Configuration Item Reference Number" = ""
            "Configuration Item Reference Name" = ""
            "Contract Name" = ""
            "Service Level Agreement" = $sla
            "Create Date/Time" = $createDate
            "Created By Resource" = ""
            "Created By Contact" = ""
            "Complete Date/Time" = $complete
            "[required] Due Date/Time" = $due
            "First Response Date/Time" = $firstResponse
            "First Response Initiating Resource" = ""
            "Resolution" = ""
            "Completed By" = "Mckenzie, Rob"
            "Co-managed Visibility" = ""
            "UDF:29682910 Additional Information" = ""
            "UDF:29682909 Escalation Level" = ""
            "UDF:29682911 SLA Timer"		 = ""
        }
        $obj | Export-CSV "C:\PowershellRocks\PowerShellRocks\TicketImport\Outputs\$d - Import Tickets.csv" -NoTypeInformation -Append

    } 
}


