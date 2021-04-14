
$domains = Get-Content -Path "$($PSScriptRoot)\domains.txt"
#write-host "$($PSScriptRoot)\domains.txt" -BackgroundColor Cyan

#remove old info from csv
remove-item -Path "$($PSScriptRoot)\domains.csv"
"Domain|Registrar" | Out-File -FilePath "$($PSScriptRoot)\domains.csv"

#Get registrar
Function Get-registrar($domain) {
  #Get info from whois API

    write-host "looking up: https://rdap.verisign.com/com/v1/domain/$($domain)" -BackgroundColor Green
    $res = Invoke-WebRequest -Uri "https://rdap.verisign.com/com/v1/domain/$($domain)" -ErrorAction Ignore
    #write-host $res
    
  #$res.RawContent
    $start = $res.RawContent.IndexOf('["fn",{},"text","') 

  #Print out only registrar
    $registrarName = $res.RawContent.Substring($start, 100).split('"')[5].replace("\","")
    #write-host $registrarName -BackgroundColor Yellow

    return $registrarName
}




#Get info
foreach ($line in $domains){
    $domainName = $line
    $registrar  = $null
    
    #Slow down request
    start-sleep -Milliseconds $(get-random -Minimum 1000 -Maximum 5000)

    #Registrar
    $registrar = Get-registrar $domainName
    #write-host $registrar
    

    #write-host $line  
    write-host "$($domainName),$($registrar)" -BackgroundColor Yellow


    #Store info in csv 
    "$($domainName)|$($registrar)" | Out-File -FilePath "$($PSScriptRoot)\domains.csv" -Append  


}