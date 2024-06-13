Import-Module ActiveDirectory
Import-Module Autotask

$User = "hbjok3uryxv4yk2@ACADEMIA.CO.UK"
$PWord = ConvertTo-SecureString -String '6Er~N#8ybL@3$7Jd9Df**1AtP' -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
$ApiTrackingIdentifier = 'BJBWUDOSPVKK23UKZVK3MSQQCMP'
#Connect-AtwsWebAPI -Credential $Credential -ApiTrackingIdentifier $ApiTrackingIdentifier

# Module can now load and connect automatically, so you can run any command directly
$ticketSearch = Get-AtwsTicket -Title "Ebor Staff User Request*" -Like Title -Status "New"

foreach($ticket in $ticketSearch){
    $ticketNumber = $ticket.ticketNumber
    $ticket.Description | Out-File "C:\PowerShellRocks\PowerShellRocks\Ebor - AutoTask\Outputs\$ticketNumber.txt" -Append
}