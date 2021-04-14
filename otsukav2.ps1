#remove statusdomain.csv if exist
Remove-Item -Path "statusdomain.csv" -ErrorAction SilentlyContinue

$targetDomain = @()
$domainStatus = @{}
$targetDomain = Get-Content .\domain.txt
$tempCSV      = Get-Content .\V4DomainList.csv

# Create status hash table
foreach ($row in $tempCSV) {
    $tempArray = $row.Split(",")
    $domainStatus[$tempArray[0]] = $tempArray[3]
}

foreach ($domain in $targetDomain) {
    if ($domainStatus.ContainsKey($domain)) {
        write-host "$($domain), $($domainStatus[$domain])" -BackgroundColor Black -ForegroundColor Green
        "$($domain), $($domainStatus[$domain])" | out-file -FilePath statusdomain.csv -Append
    }
    else {
        write-host "$($domain) doesn't exist in status file" -BackgroundColor red -ForegroundColor Yellow
    }
}

Read-Host