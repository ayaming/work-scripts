# ----- Variables used to make your request ----- #
$API_KEY       = "at_oMrw4s9RPn4O6O3VI81OHpkjKu7jX"
$DOMAIN_NAME   = "bbc.com"
$LOOKUP_TYPE   = "_all"
$OUTPUT_FORMAT = "JSON"
$REQUEST_URL   = "https://www.whoisxmlapi.com/whoisserver/DNSService?apiKey=$($API_KEY)&domainName=$($DOMAIN_NAME)&type=$($LOOKUP_TYPE)&outputFormat=$($OUTPUT_FORMAT)"
# ----------------------------------------------- #
<#
# Print the URL for the web request that's being called
Write-Host "$($REQUEST_URL)"-BackgroundColor Black -ForegroundColor Cyan

# Call the API and store the response in a variable
# This is limited to 500. The variable will stay after
# you do it once, so you can comment this out and keep
# testing with the same data:
$response = Invoke-WebRequest -Uri $REQUEST_URL

# Convert the content returned from the API into a PowerShell Object
$responseObject = $response.Content | ConvertFrom-Json

# Top Level Object
$responseObject

# DNS Data
$responseObject.DNSData

# Domain Name that was looked up
$responseObject.DNSData.domainName

# Number of DNS Records
$responseObject.DNSData.dnsRecords.Length

# DNS Records Array
$responseObject.DNSData.dnsRecords

# DNS Records First in List
$responseObject.DNSData.dnsRecords[0]

# DNS Records First in List (Record Type)
$responseObject.DNSData.dnsRecords[0].dnsType
#>

$domains = Get-Content -Path .\desktop\getDNS\domains.txt

remove-item -Path .\desktop\getDNS\domains.csv

"Domain|Date|IP|Ping|MX|Mxdata|NS|NSdata" | Out-File -FilePath .\desktop\getDNS\domains.csv -Append

#Get IP Address
Function Get-IpAddress($domain) {
    $info = Test-NetConnection $domain
    if ($info.RemoteAddress -eq $null) {
        return "Null"
    }
    else {
        return $info.RemoteAddress 
    }
}

#Attempt Ping
Function Attempt-PingHost($domain) {
    $info = Test-NetConnection $domain
    if ($info.PingSucceeded -eq $false) {
        return "Failed"
    }
    else {
        return "Succeeded"
    }
}

#Get Date
Function Get-Current-Date() {
    return "$((Get-Date).Month)/$((Get-Date).Day)/$((Get-Date).Year)"
}

#Get mx
Function Get-mx($domain) {
    $mxResult = $null
    $mx = (Resolve-DnsName $domain -Type MX).NameExchange

    if ($mx -eq $null) {
        return "Null"
    }
    else {
        foreach ($element in $mx) {
            $mxResult += $element + "\n" 
        }
        return $mxResult
    }
}

#Get NS
Function Get-ns($domain) {
    $nsResult = $null
    $ns = (Resolve-DnsName $domain -Type NS).NameHost
    if ($ns -eq $null) {
        return "null"
    }
    else {
        foreach ($element in $ns) {
            $nsResult += $element + "\n"
            
        }
        return $nsResult
    }
}

#Get registrar


foreach ($line in $domains){
    $domainName = $line
    $ipAddress  = $null 
    $pingStatus = $null
    $date       = $null
    $mxElements = $null
    $nsElements = $null
    $registrar  = $null
    
    #IP address
    $ipAddress = Get-IpAddress $domainName
    
    #Ping
    $pingStatus = Attempt-PingHost $domainName
    
    #DATE
    $date = Get-Current-Date

    #MX
    $mxElements = Get-mx $domainName
    write-host $mxElements

    #NS
    $nsElements = Get-ns $domainName

    #Registrar
    #$registrar = Get-registrar $domainName
    

    #write-host $line  
    write-host "$($domainName),$($date),$($ipAddress),$($pingStatus),$($mx),$($ns)" 


    <#if ($info.RemoteAddress -eq $null) {
        $noip 
    }
    make sure not empty
    if ($info.RemoteAddress -eq $null) {
       Write-Host "$($line): No IP" -BackgroundColor Black -ForegroundColor Yellow
    }

    if ($info.PingSucceeded -eq $false) {
       Write-Host "$($line): Ping Failed" -BackgroundColor Black -ForegroundColor Yellow
    }`
    #>
    #   A             B         C           D             E                                F              G                                H
    "$($domainName)|$($date)|$($ipAddress)|$($pingStatus)|=SUBSTITUTE(F:F,`"\n`",char(10))|$($mxElements)|=SUBSTITUTE(H:H,`"\n`",char(10))|$($nsElements)" | Out-File -FilePath .\desktop\getDNS\domains.csv -Append  


}





   



