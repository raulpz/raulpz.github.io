

Write-Host ""
Write-Host "Pick an Option"
Write-Host "1- Collect a new Baseline"
Write-Host "2- Begin Monitoring files with existing Baseline"
Write-Host ""

Function Calculate-Hashes($filepath) {
   $filehash = Get-FileHash -Path $filepath -Algorithm MD5
   return $filehash
}

Function Erase-existing-baselineTXT() {
  $baselineExists = Test-Path .\baseline.txt
  if ($baselineExists) {
  #nuke it
  Remove-Item -Path .\baseline.txt
  }
}

#$hash = Calculate-Hashes "C:\Users\Public\Documents\Files\Azuero.txt"

$response = Read-Host -Prompt "Please enter '1' or '2'"

if ($response -eq "1".ToUpper()) {
   #Delete baseline.txt if one exists already
   Erase-existing-baselineTXT

   #Generate Hash from the files and save them to baseline.txt

   #Collect all files from our Files folder
   $files = Get-ChildItem -Path .\Files
  
   #For each file, calculate the MD5 hash, and print it to baseline.txt
   foreach ($f in $files) {
     $hash = Calculate-Hashes $f.FullName
      "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
     }
   
   Write-Host "I got the MD5 Hashes, they are now in baseline.txt" -ForegroundColor Cyan
   
}
elseif ($response -eq "2".ToUpper()) {

   $fileHashDictionary = @{}

   #Load file|hash from baseline.txt save ir into a dictionary
   $filePathAndHashes = Get-Content -Path .\baseline.txt
   
   foreach ($f in $filePathAndHashes) {
     $fileHashDictionary.Add($f.Split("|")[0],$f.Split("|")[1])

   }

   #Start the loop to monitoring the files state
   Write-Host "Reading existing baseline.txt, Start Monitoring files...." -ForegroundColor Magenta

   #Begin monitoring files
   while ($true) {
       Start-Sleep -Seconds 2

       $files = Get-ChildItem -Path .\Files

         #For each file, calculate the MD5 hash, and print it to baseline.txt
         foreach ($f in $files) {
            $hash = Calculate-Hashes $f.FullName
           # "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append

           #Notify is a file has been created or removed
           if ($fileHashDictionary[$hash.Path] -eq $null){
              #A file was removed or added to our folder
              Write-Host "A File was removed from or added to the folder, Integrity is Compromised!"-ForegroundColor Red
              Write-Host "A File was removed from or added to the folder, Integrity is Compromised!"-ForegroundColor Red
              Exit
           }

           else {

           #Notify if a file has been changed
           if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
              #File has not changed
              Write-Host "File Integrity is OK..." 
           }
           else {
              #File has been compromised
             Write-Host "A File was modified!!, Integrity is Compromised!!" -ForegroundColor Red
	     Exit
             } 
              
           }}


   }

}



