Write-Host "Wack-a-Mole" -ForegroundColor Green
Write-Host "2022-2023 ASU CCDC Team"
Write-Host "Author: Epi AKA David Lee"
Write-Host "Periodically checks service status and enables services that are disabled"
Write-Host "This tactic that is meant to buy time while defenders can identify how the attackers gained access and persitence to the machine and remove the attacker."

#configure execution policy so script runs bypass
#& '.\Start Menu'

#list of services to monitor, Last item is entering manual name
Write-Host "Select a service to monitor"
Write-Host "#1 FTP"
Write-Host "#2 HTTP"
Write-Host "#3 HTTPS"
Write-Host "#4 SMB"
Write-Host "#5 DNS"
Write-Host "#6 VNC"
Write-Host "#7 SSH"
Write-Host "#8 telnet"
Write-Host "#9 Custom"

#prompt user for number
$optionNumber = read-host "Select a number from above list: "

#Nine if statements to determine the $serviceName Value based on user input
if ($optionNumber -eq 1){
    $serviceName = "FTP"
}
if ($optionNumber -eq 2){
    $serviceName = "HTTP"
}
if ($optionNumber -eq 3){
    $serviceName = "HTTPS"
}
if ($optionNumber -eq 4){
    $serviceName = "SMB"
}
if ($optionNumber -eq 5){
    $serviceName = "DNS"
}
if ($optionNumber -eq 6){
    $serviceName = "VNC"
}
if ($optionNumber -eq 7){
    $serviceName = "SSH"
}
if ($optionNumber -eq 8){
    $serviceName = "Telnet"
}
if ($optionNumber -eq 9){
    #This last option promps user for custom service not listed above
    $serviceName = Read-Host "Enter Service Name, confirm after setup that script is running correctly"
}

$wack = "true"

#while true loop
while ($wack -eq "true"){
    Start-Sleep -Seconds 3
    Write-Host "wack"

    #check if service is up, 
    if ((Get-Service $serviceName | Select Status) -eq “Running”){
        #print time $serviceName name, starttype, status
        #Get-Service $serviceName | Select-Object -Property Name, StartType, Status;
        Write-Host "Why are you running"
    }

    #if service is Not enabled
    if ((Get-Service $serviceName | Select Status) -ne "Running"){
    write-host "not running"
    }
        #print time, $serviceName is $serviceName.status
        #set-service to enabled

        #if service is enabled
            #print time, $serviceName is now enable
        #if service is not enabled

            # stop loop, print time, $serviceName is not enabled. Investigate before you get wacked.
            #$wack = "false"
    
    #sleep 20 seconds
    #Start-Sleep -Seconds 15
    #Write-host "---------------"
    #user can pause loop to look at output
    #write output to log

} # end of while loop

#https://social.technet.microsoft.com/Forums/windowsserver/en-US/79bf9de7-1c17-45c0-a02b-7558af89807a/powershell-script-to-check-service-status