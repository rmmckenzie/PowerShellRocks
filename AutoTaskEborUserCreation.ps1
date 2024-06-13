Import-Module Autotask

$User = "hbjok3uryxv4yk2@ACADEMIA.CO.UK"
$PWord = ConvertTo-SecureString -String '6Er~N#8ybL@3$7Jd9Df**1AtP' -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
$ApiTrackingIdentifier = ConvertTo-SecureString -String 'BJBWUDOSPVKK23UKZVK3MSQQCMP' -AsPlainText -Force

$ticketNumber = "T20240516.0224"

$ticketDesc = Get-Atwsticket -ticketNumber "T20240516.0224" | Select -Expand Description | Out-File "C:\Scripts\temp.txt"

$ticketDesc