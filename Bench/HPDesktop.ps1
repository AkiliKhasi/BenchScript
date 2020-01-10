import-module .\switchuaclevel.psm1
Write-Host "UAC Level"
set-uaclevel 0
Write-Host "Enabling Remote Desktop"
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
Write-Host "Complete"
Write-Host "Power Setting Configuration"
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
Write-Host "Power Settings Configured"
Write-Host "Disabling Firewall"
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Write-Host "Firewall Disabled"
Write-Host "Uninstalling Bloatware"
get-package -name "hp device*" | uninstall-package -force
get-package -name "hp support as*" | uninstall-package -force
get-package -name "hp*" | uninstall-package -force
Get-AppxPackage -AllUsers | where-object {($_.name –notlike “*store*”) -and ($_.name -notlike "*calc*") -and ($_.name -notlike "*stickynotes*")} | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {($_.packagename –notlike “*store*”) -and ($_.packagename -notlike "*calc*") -and ($_.packagename -notlike "*stickynotes*")} | Remove-AppxProvisionedPackage -online 
Write-Host "Uninstalling Office"
Get-AppxPackage *officehub* | Remove-AppxPackage
.\o15-ctrremove.diagcab
Write-Host "Configuring Windows Update Settings"
cd c:
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name BranchReadinessLevel -Value 32
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name DeferFeatureUpdatesPeriodInDays -Value 90
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d -Name RegisteredWithAU -Value 1
Set-ItemProperty -Path 'Registry::HKU\.DEFAULT\Control Panel\Keyboard' -Name "InitialKeyboardIndicators" -Value "2"
Write-Host "Windows Update Configured"
Read-Host "Press ENTER to Install Java"
Write-Host "Installing Java"
New-Item -path "c:\" -Name "Source" -ItemType "directory"
$url = "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=234474_96a7b8442fe848ef90c96a2fad6ed6d1"
$output = "c:\source\javainstall.exe"
Invoke-WebRequest -uri $url -OutFile $output
cd c:\source
.\javainstall.exe
Read-Host "Press ENTER to Install Adobe Reader"
Function Get-FTPFileList { 

Param (
 [System.Uri]$server,
 [string]$directory

)

try 
 {
    $uri =  "ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/" 

    $FTPRequest = [System.Net.FtpWebRequest]::Create($uri)
	

    $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails
    
    $FTPResponse = $FTPRequest.GetResponse() 
    
    $ResponseStream = $FTPResponse.GetResponseStream()
    
    $StreamReader = New-Object System.IO.StreamReader $ResponseStream  
   
    $files = New-Object System.Collections.ArrayList
    While ($file = $StreamReader.ReadLine())
     {
       [void] $files.add("$file")
      
    }

}
catch {
    write-host -message $_.Exception.InnerException.Message
}

    $StreamReader.close()
    $ResponseStream.close()
    $FTPResponse.Close()

    Return $files


}

$server = 'ftp://ftp.adobe.com/'
$directory ='pub/adobe/reader/win/AcrobatDC/'

$filelist = Get-FTPFileList -server $server -directory $directory

$file = $filelist | Select -First 1

$filename = $file.substring($file.get_length()-10)

$FTPFolderUrl = $server + $directory

$LatestFile = "AcroRdrDC" + $filename + "_en_US.exe"
				$DownloadURL = $FTPFolderUrl + $filename + "/" + $latestfile
				$output = "c:\source\AdobeInstall.exe"
Invoke-WebRequest -uri $DownloadURL -OutFile $output
cd c:\source
.\AdobeInstall.exe