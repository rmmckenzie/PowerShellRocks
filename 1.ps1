Import-Module Autotask
$username = "ewwwsnnpblaybjp@ACADEMIA.CO.UK"
$password = ConvertTo-SecureString '6j~BT$8db0S*@Ep3Yf2#~Lg4m' -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
# Enter your username and password to Autotask
Connect-AutotaskWebAPI -Credential $Credentials -ApiTrackingIdentifier "BJBWUDOSPVKK23UKZVK3MSQQCMP"

$vyCompanies = Get-AtwsAccount -UserDefinedField @{name="Support Divison"; value="Vital York"} | Get-TypeData


#foreach($c in $vyCompanies){
#    $c.AccountName | Sort-Object -Descending
#}

#Get-AtwsAccount -Name 'Dringhouses Primary School'





#$title = "Repair Test"
#$dueDate = (Get-Date).AddDays(3)
#$ticket = New-AtwsTicket -QueueID "Helpdesk Tickets" -Title $title -AccountID 1236 -DueDateTime $dueDate -Priority Medium -Status New
#Write-Output $ticket.TicketNumber
