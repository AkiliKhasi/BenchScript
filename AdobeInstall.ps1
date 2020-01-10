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