function Get-DellWarrantyInfo {
    
    Param(   
        $ApiKey = "l747398f2ec39345398d128261b0fb5ea7",
        $KeySecret = "b3ee7c4cad7f4907b27608930b360629"
    )

    $outFile = "C:\Scripts\rr.csv"
    Add-Content $outFile -Value 'Model,ServiceTag,WarrantyDate,InWarranty'
    
    $s = Import-CSV "C:\Scripts\DellST.csv" -Delimiter "," -Header "Service Tag" | Select -Skip 1
    
    $ServiceTags = @()
    foreach($i in $s){
        $serviceTag = $i.'Service Tag'
        $ServiceTags += $serviceTag
        }


    [String]$servicetags = $ServiceTags -join ", "

    $AuthURI = "https://apigtwb2c.us.dell.com/auth/oauth/v2/token"
    $OAuth = "$ApiKey`:$KeySecret"
    $Bytes = [System.Text.Encoding]::ASCII.GetBytes($OAuth)
    $EncodedOAuth = [Convert]::ToBase64String($Bytes)
    $Headers = @{ }
    $Headers.Add("authorization", "Basic $EncodedOAuth")
    $Authbody = 'grant_type=client_credentials'
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Try {
        $AuthResult = Invoke-RESTMethod -Method Post -Uri $AuthURI -Body $AuthBody -Headers $Headers
        $Global:token = $AuthResult.access_token
    }
    Catch {
        $ErrorMessage = $Error[0]
        Write-Error $ErrorMessage
        BREAK        
    }
    Write-Host "Access Token is: $token`n"

    $headers = @{"Accept" = "application/json" }
    $headers.Add("Authorization", "Bearer $token")

    $params = @{ }
    $params = @{servicetags = $servicetags; Method = "GET" }

    $Global:response = Invoke-RestMethod -Uri "https://apigtwb2c.us.dell.com/PROD/sbil/eapi/v5/asset-entitlements" -Headers $headers -Body $params -Method Get -ContentType "application/json"

    $d = 0

    $outArray = @()

    foreach ($Record in $response) {
        $servicetag = $Record.servicetag
        $Json = $Record | ConvertTo-Json
        $Record = $Json | ConvertFrom-Json 
        $Device = $Record.productLineDescription
        $EndDate = ($Record.entitlements | Select -Last 1).endDate
        $Support = ($Record.entitlements | Select -Last 1).serviceLevelDescription
        $EndDate = $EndDate | Get-Date -f "MM-dd-y"
        $today = get-date

        $outArray += $serviceTag
        $outArray += $Device
        $outArray += $EndDate

        Write-Host -ForegroundColor White $Computer
        Write-Host "Service Tag   : $servicetag"
        Write-Host "Model         : $Device"
        if ($today -ge $EndDate) { 
            $wc = "$EndDate" 
            $yi = "No"
            Echo "Out of Warranty"
            $EndDate
            $d++
        }
        else { $wc = $EndDate
            $yi = "Yes" 
            Echo "In Warranty"
            $EndDate
            $d++
        } 
        if (!($ClearEMS)) {
            $i = 0
            foreach ($Item in ($($WarrantyInfo.entitlements.serviceLevelDescription | select -Unique | Sort-Object -Descending))) {
                $i++
                Write-Host -NoNewLine "Service Level : $Item`n"
            }

        }
        else {
            $i = 0
            foreach ($Item in ($($WarrantyInfo.entitlements.serviceLevelDescription | select -Unique | Sort-Object -Descending))) {
                $i++
                Write-Host "Service Level : $Item`n"
            }
        }
        Add-Content -Path "C:\Temp\rr.csv" -Value "$serviceTag, $Device, $wc, $yi"
    }    
}
Get-DellWarrantyInfo