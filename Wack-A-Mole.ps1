Write-Host "Wack-a-Mole" -ForegroundColor Green
Write-Host "2022-2023 ASU CCDC Team"
Write-Host "Author: Epi AKA David Lee"
Write-Host "Periodically checks service status and enables services that are disabled"
Write-Host "This tactic that is meant to buy time while defenders can identify how the attackers gained access and persitence to the machine and remove the attacker."


#configure execution policy so script runs
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force

$monitoredServiceList = [System.Collections.ArrayList]::new()

#list of services to monitor, Last item is entering manual name
Write-Host "Select which services to monitor (separated by commas)"
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
$optionNumbers = read-host "Select a number from above list: "

foreach ($option in $optionNumbers.Split(",")) {
    $option = $option.trim() #Remove whitespace left over from Split()

    #Nine if statements to determine the $serviceName Value based on user input
    if ($option -eq 1) {
        $serviceName = "FTP"
    }
    if ($option -eq 2) {
        $serviceName = "HTTP"
    }
    if ($option -eq 3) {
        $serviceName = "HTTPS"
    }
    if ($option -eq 4) {
        $serviceName = "SMB"
    }
    if ($option -eq 5) {
        $serviceName = "DNS"
    }
    if ($option -eq 6) {
        $serviceName = "VNC"
    }
    if ($option -eq 7) {
        $serviceName = "SSH"
    }
    if ($option -eq 8) {
        $serviceName = "Telnet"
    }
    if ($option -eq 9) {
        #This last option promps user for custom service not listed above
        $serviceName = Read-Host "Enter Service Name (not display name), confirm after setup that script is running correctly"
    }
    $monitoredServiceList.Add($serviceName) #Add service name to monitoring list
}
#formatting
Write-host "---------------------------------------------------------------------------------------------------------"

#while true loop
$wack = "true"
while ($wack -eq "true") {
    foreach ($serviceName in $monitoredServiceList) {

        #check if service is up, 
        if ((Get-Service $serviceName).Status -eq "Running") {

            #display artifacts
            Write-Host $serviceName" is Running"
            (Get-Date).ToString('G')
            Get-Service $serviceName | Format-Table serviceName, displayName, startType, status


        }

        #if service is Not enabled
        if ((Get-Service $serviceName).Status -ne "Running") {

            #display artifacts
            write-host $serviceName" is not running. Attempting to start service."
            (Get-Date).ToString('G')
            Get-Service $serviceName | Format-Table serviceName, displayName, startType, status

            #try to start service
            Start-Service -Name $serviceName

            #if service is now enabled
            if ((Get-Service $serviceName).Status -eq "Enabled") {

                #display artifacts
                write-host $serviceName" is now running."
                (Get-Date).ToString('G')
                Get-Service $serviceName | Format-Table serviceName, displayName, startType, status
            }
        
            #if service is still not running after the above attempt to get it running
            if ((Get-Service $serviceName).Status -ne "Running") {

                #display artifacts
                write-host "Unable to start "$serviceName". Investigate before the mole wacks you."
                (Get-Date).ToString('G')

                Get-Service $serviceName | Format-Table serviceName, displayName, startType, status

                #stops while loop so Incident responder can investigate
                $wack = "false"

                #wacked ascii art here
            }
        }
    }

    #sleep 30 seconds
    Write-host "---------------------------------------------------------------------------------------------------------"
    Start-Sleep -Seconds 30


    #potental new features
    #write output to log
    #user can pause loop to look at output
    #check for input, timeout
    
} # end of while loop

#reference
#https://social.technet.microsoft.com/Forums/windowsserver/en-US/79bf9de7-1c17-45c0-a02b-7558af89807a/powershell-script-to-check-service-status
