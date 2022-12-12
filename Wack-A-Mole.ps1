Write-Host "Wack-a-Mole" -ForegroundColor Green
Write-Host "2022-2023 ASU CCDC Team"
Write-Host "Author: Epi AKA David Lee"
Write-Host "Periodically checks service status and enables services that are disabled"
Write-Host "This tactic that is meant to buy time while defenders can identify how the attackers gained access and persitence to the machine and remove the attacker."

#configure execution policy so script runs bypass
#fix
#

#insert aski art here

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
    $serviceName = Read-Host "Enter Service Name (not display name), confirm after setup that script is running correctly"
}

#formatting
Write-host "---------------------------------------------------------------------------------------------------------"

#while true loop
$wack = "true"
while ($wack -eq "true"){

    #check if service is up, 
    if ((Get-Service $serviceName).Status -eq "Running"){

        #display artifacts
        Write-Host $serviceName" is Running"
        (Get-Date).ToString('G')
        Get-Service $serviceName | Format-Table serviceName, displayName, startType, status


    }

    #if service is Not enabled
    if ((Get-Service $serviceName).Status -ne "Running"){

        #display artifacts
        write-host $serviceName" is not running. Attempting to start service."
        (Get-Date).ToString('G')
        Get-Service $serviceName | Format-Table serviceName, displayName, startType, status

        #try to start service
        Start-Service -Name $serviceName

        #if service is now enabled
        if ((Get-Service $serviceName).Status -eq "Enabled"){

            #display artifacts
            write-host $serviceName" is now running."
            (Get-Date).ToString('G')
            Get-Service $serviceName | Format-Table serviceName, displayName, startType, status
        }
        
        #if service is still not running after the above attempt to get it running
        if ((Get-Service $serviceName).Status -ne "Running"){

            #display artifacts
            write-host "Unable to start "$serviceName". Investigate before the mole wacks you."
            (Get-Date).ToString('G')

            Get-Service $serviceName | Format-Table serviceName, displayName, startType, status

            #stops while loop so Incident responder can investigate
            $wack = "false"

            #wacked ascii art here
        }
    }

    #sleep 30 seconds
    Write-host "---------------------------------------------------------------------------------------------------------"
    Start-Sleep -Seconds 30


    #potental new features
        #execution bypass
        #write output to log
        #user can pause loop to look at output
            #check for input, timeout

} # end of while loop

#https://social.technet.microsoft.com/Forums/windowsserver/en-US/79bf9de7-1c17-45c0-a02b-7558af89807a/powershell-script-to-check-service-status
