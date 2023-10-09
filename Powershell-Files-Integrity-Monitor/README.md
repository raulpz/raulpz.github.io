<h1>File Integrity Monitor with Powershell</h1>

<h2>Description</h2>
Project consists of a simple Proof of Concept PowerShell script, that monitors the integrity of a folder and it's files, by making sure they are not modfied, using Hashing Algorithm MD5.
<br />

<h2>FlowChart</h2>
<img src="https://imgur.com/0NbsWOc.png" height="80%" width="80%"/>

<br />

<h2>Languages and Utilities Used</h2>

- <b>PowerShell</b> 

<h2>Environments Used </h2>

- <b>Windows 11</b> (21H2)

<h2>Program walk-through:</h2>

Proceed to copy the 'Integrity-Check.ps1' file and the extracted Files folder into 
````
C:\Users\Public\Documents\
````

Open Powershell as Administrator, and change Windows Execution Policy:
````
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
````
Select YES to ALL.

Change directory to our Public\Documents folder.
````
cd C:\Users\Public\Documents
````

From there Run the 'Integrity-Check.ps1'script file.
````
 .\Integrity-Check.ps1
````
<br />
From there select '1' and hit ENTER to create a new file containing the MD5 hashes of all our files:
<img src="https://imgur.com/0TUxNwx.png" height="80%" width="80%"/>

Observe a new file is created named 'baseline.txt', containing all the MD5 hashes for our files:
````
C:\Users\Public\Documents\Files\Azuero.txt|425C597FB66FC08DB09DBE02AD670562
C:\Users\Public\Documents\Files\Herrera.txt|945EB56C9408C93A14A6C289A0FBAE5C
C:\Users\Public\Documents\Files\Los-Santos.txt|4DDEBBAAC3996065E96BD4C6ED0D8531
C:\Users\Public\Documents\Files\Veraguas.txt|05A30A5BBF5994B5ACA8FF5CCA543E50
````

<h2>Monitoring our Folder</h2>
Now Run the 'Integrity-Check.ps1'script file.
````
 .\Integrity-Check.ps1
````
Select option 2 and Hit ENTER.
The program will now start to monitor for changes:
<img src="https://imgur.com/0QkTGgM.png" height="80%" width="80%"/>

If any file is added\removed\modified, the user will be notified on screen inmediatly:
<img src="https://imgur.com/qSsOin1.png" height="80%" width="80%"/>

END

raul@pinedo.xyz

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
