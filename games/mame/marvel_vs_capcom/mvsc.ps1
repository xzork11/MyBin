<#
Gets and Runs Marvel vs. Capcom MAME ROMS
PowerShell -ExecutionPolicy Bypass .\mvsc_mame.ps1
#>
function Main(){
    Add-Type -AssemblyName presentationCore 
    $mediaPlayer = New-Object system.windows.media.mediaplayer
    $music = "http://a.tumblr.com/tumblr_lxlq4i1EPI1qckwxco1.mp3"
    $mediaPlayer.open($music) 
    $mediaPlayer.Play() 
    
    $folder = "mvsc"
    $storageDir = "$pwd"
    
    function DownloadFile($url, $targetFile)
    
    {
    
       $uri = New-Object "System.Uri" "$url"
    
       $request = [System.Net.HttpWebRequest]::Create($uri)
    
       $request.set_Timeout(15000) #15 second timeout
    
       $response = $request.GetResponse()
    
       $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024)
    
       $responseStream = $response.GetResponseStream()
    
       $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $targetFile, Create
    
       $buffer = new-object byte[] 10KB
    
       $count = $responseStream.Read($buffer,0,$buffer.length)
    
       $downloadedBytes = $count
    
       while ($count -gt 0)
    
       {
    
           $targetStream.Write($buffer, 0, $count)
    
           $count = $responseStream.Read($buffer,0,$buffer.length)
    
           $downloadedBytes = $downloadedBytes + $count
    
           Write-Progress -activity "Downloading file '$($url.split('/') | Select -Last 1)'" -status "Downloaded ($([System.Math]::Floor($downloadedBytes/1024))K of $($totalLength)K): " -PercentComplete ((([System.Math]::Floor($downloadedBytes/1024)) / $totalLength)  * 100)
    
       }
    
       #Write-Progress -activity "Finished downloading file '$($url.split('/') | Select -Last 1)'"
    
       $targetStream.Flush()
    
       $targetStream.Close()
    
       $targetStream.Dispose()
    
       $responseStream.Dispose()
    
    }
    
    cls
    Write-Output "Welcome!!!"
    Start-Sleep -seconds 2
    

    
    if(!(Test-Path -Path $folder )){
        Write-Output "Downloading Emulator for Windows..."
        Start-Sleep -seconds 2
    
        $url = "https://dl.dropbox.com/s/dy4ilomcxvvjrd9/mvsc.zip"
        $file = "$storageDir\mvsc.zip"
        DownloadFile $url $file 
    
        Write-Output "Unzipping Emulator for Windows"
        Start-Sleep -seconds 2
        
        $shell = new-object -com shell.application
        $zip = $shell.NameSpace("$file")
    
        foreach($item in $zip.items())
        {
            $shell.Namespace("$storageDir\").copyhere($item)
        }
        Remove-Item $file -Force -Recurse
    }else{
        Write-Output "Emulator Already Installed";
        Start-Sleep -seconds 2
    }
    
    


    $file = "mvsc.zip"
    $rom = "$folder\roms\$file"
    
    Write-Output "Starting Game!!!"
    
    $mediaPlayer.Stop()

    write-output $pwd\$folder
    cd $pwd\$folder
    cmd /c mame $rom
    cd $storageDir
    
    $del = Read-Host 'Do you want to remove the emulator and roms? (Y/n)'
    
    if(($del -eq "Y" ) -or ( $del -eq "")){
        Write-Output "Removing Emulator and ROMS"
        Remove-Item $folder -Force -Recurse
    }
    
    write-output "Thank you for playing"
}

Main
