Import-Module ITGlueAPI
Add-ITGlueBaseURI "https://api.eu.itglue.com"
Add-ITGlueAPIKey "ITG.adf8916e399e57b3c5c14008a29fc755.V-7uRvu48fghDnMEakKLr2I6IQvvKs1B9dlpM4MclA1rzYKfWGmQdV3guUuoDEdI"

$csv = Import-CSV "C:\PowershellRocks\PowerShellRocks\ITGlueMirgration\Company Search Results.csv" -Header id, company -Delimiter ","

$companies = @()
$idArray = @()

foreach($company in $csv){
    $companyName = $company.Company
    $orgs = (Get-ITGlueOrganizations -page_size 150 -filter_name "$companyName").data
    $orgid = $orgs.id
    $companies += $orgid
}

foreach($id in $companies){
    $urls = (Get-ITGluePasswords -organization_id $id).data.attributes.'resource-url'
    $ids = Split-Path $urls -Leaf
    $idArray += $ids
}

foreach($passwordID in $idArray){
    $passwordID
    $apiCall = (Get-ItGluePasswords -id $passwordID).data.attributes
    $password = $apiCall.password
    $username = $apiCall.username
    $orgName = $apiCall."organization-name"
    $name = $apiCall.Name
    $notes = $apiCall.Notes
    "$orgName, $name, $username, $password, $notes" | Out-File "cpasswords.csv" -append

}