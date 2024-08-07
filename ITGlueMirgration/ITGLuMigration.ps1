Import-Module ItGlueApi
Add-ITGlueBaseURI "https://api.eu.itglue.com"
Add-ITGlueAPIKey "ITG.bbe00c16157d4ca9a49599b4255b3d9b.DLgi95dncmvpivpWhbQ8QkYYxJWakwtuEbUVnCPl17ENMZ5V5AwZZ-2b7KJKnZnp"




$organisations = (Get-ITGlueOrganizations -page_size 150).data
$i = 0

foreach($org in $organisations){
    $orgID = $org.id
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
    Invoke-WebRequest -UseBasicParsing -Uri "https://itg-api-prod-eu-api-lb-eu-central-1.itglue.com/api/organizations/$orgID/relationships/password_folders" `
    -Method "POST" `
    -WebSession $session `
    -Headers @{
    "authority"="itg-api-prod-eu-api-lb-eu-central-1.itglue.com"
    "method"="POST"
    "path"="/api/organizations/$orgID/relationships/password_folders"
    "scheme"="https"
    "accept"="application/json, text/plain"
    "accept-encoding"="gzip, deflate, br, zstd"
    "accept-language"="en-GB,en-US;q=0.9,en;q=0.8"
    "authorization"="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOjM3Mjg4ODk0NTA0OTYxNjMsImp0aSI6IjE4ZmYyZWI3MmQ2M2UzYjYxODIyMzg2MTBlOTRmMWQ0IiwiaXNzIjoiaXRnbHVlLmNvbSIsImF1ZCI6WyJpdGdsdWUuY29tIiwiYm1zLmthc2V5YS5jb20iXSwiZXhwIjoxNzIwMTkwODE0LCJpYXQiOjE3MjAxODM2MTQsImlkIjozNzI4ODg5NDUwNDk2MTYzLCJpdGdsdWUiOnsiYWNjb3VudF9pZCI6MzY2MDg1NDc0NTQxNTgxMywiZW1haWwiOiJybS5tY2tlbnppZUB2aXRhbHlvcmsuY29tIn19.tsuaDEGKVgz2xkoPmr-DgmGMt37uoXO_YylDHBX61jW3JXQSbD6jCEJjEywGevkR2mmFEy-ZaydT9GwOcBCs33-X6tsYUqAxf2Ngxjgd_B7J6FHIpiviATpY3vs3Y9QI-2L4g6UnQ8X-FMLKM36_T48KMaTxY0UgNzL7GqVOop6JIvnMk-PBTZXK_Xb7vQRNQiiwQhOPnqZ35vyOdAFucccLCTgZnX9TSbLJJAuSAafpnRx8ARYW9O1h5TEjz7EOWWoq9Stz2n4EzbdTW1AGngd40WeC_7-kRaOJkI9n7ffvQX3P8AKnbP5wWLYWJqgcyGz29bMYq5iTdrlj59sSvw"
    "origin"="https://vital-york.eu.itglue.com"
    "priority"="u=1, i"
    "referer"="https://vital-york.eu.itglue.com/$orgID/passwords"
    "sec-ch-ua"="`"Not/A)Brand`";v=`"8`", `"Chromium`";v=`"126`", `"Google Chrome`";v=`"126`""
    "sec-ch-ua-mobile"="?0"
    "sec-ch-ua-platform"="`"Windows`""
    "sec-fetch-dest"="empty"
    "sec-fetch-mode"="cors"
    "sec-fetch-site"="same-site"
    } `
    -ContentType "application/vnd.api+json" `
    -Body "{`"data`":{`"type`":`"password_folders`",`"attributes`":{`"name`":`"Senior Engineers`",`"parent-id`":null}}}"
    $i++
}

