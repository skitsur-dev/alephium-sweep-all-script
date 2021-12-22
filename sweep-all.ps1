$Password = ""
$WalletName = ""
$ColdWalletAddress = ""
$apiUrl = "http://127.0.0.1:12973/"


### UNLOCK
$unlockUrl = $apiUrl + "wallets/" + $WalletName +"/" + "unlock"

$Form = 
@{
    password  = $Password
}

Invoke-WebRequest -Uri $unlockUrl -Method Post -Body ($Form|ConvertTo-Json) -ContentType "application/json" -UseBasicParsing

#######

### Get addresses

$balencesUrl = $apiUrl + "wallets/" + $WalletName +"/" + "balances"

Write-Output $balencesUrl

$result = Invoke-WebRequest -Uri $balencesUrl -ContentType "application/json" -UseBasicParsing | ConvertFrom-Json


########

### Change active address and sweep.

foreach ($i in $result.balances)
{
    $changeActiveAddressUrl = $apiUrl + "wallets/" + $WalletName +"/" + "change-active-address"

    $Form = @{
        address  = $i.address
    }

    Invoke-WebRequest -Uri $changeActiveAddressUrl -Method Post -Body ($Form|ConvertTo-Json) -ContentType "application/json" -UseBasicParsing


    $sweepAllUrl = $apiUrl + "wallets/" + $WalletName +"/sweep-all"

    $Form = @{
        toAddress  = $ColdWalletAddress
    }

    Invoke-WebRequest -Uri $sweepAllUrl -Method Post -Body ($Form|ConvertTo-Json) -ContentType "application/json" -UseBasicParsing
}
