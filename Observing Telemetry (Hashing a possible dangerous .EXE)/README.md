<h1>LimaCharlie EDR - Using Telemetry to Block Dangerous payloads (C2 Command and Conquer Attacks)</h1>
This is a Follow up of a previous lab.

<h2>Description</h2>
Project consists of a simple LimaCharlie Home-Lab, being deployed to monitor and block possible C2 Attacks (Command and Control), conducted by unauthorized users or threat actors.
<br />


<h2>Environments Used </h2>

- <b>A Windows 11 22H1 Virtual Machine (Victim)</b> 
- <b>An Ubuntu Server 22.03 VM (Attacker)</b>


<h2>Procedure:</h2>

<b>From the Ubuntu Attacker VM.</b>

-Launch Sliver and initiate an HTTP listener (don't forget to elevate to super user --sudo su-- before launchin Sliver).
```
sudo su
sliver-server
http
```
<img src="http://....jpg" width="900" height="700" />

<b>From the Windows VM.</b>
Launch our C2 Payload named: "APPLICABLE_SUBSTANCE.exe", from Windows Terminal, elevated as Administrator:

```
C:\Users\User\Downloads\APPLICABLE_SUBSTANCE.exe
```
If you see this message, it means our malicious payload is connected to the Sliver-Server, and ready to launch C2 attacks to Windows 11.

<img src="http://....jpg" width="900" height="700" />

<b>From the Ubuntu Attacker VM.</b>

We can find out what user our Implant is running and confirm it's privileges, see which connections are in use, and check our current directory:

```
whoami
getprivs
netsat
pwd
```
All this noise is being detected by our EDR LimaCharlie Sensor.

<b>Let's go back to our EDR Tool, Home-Lab-PTY</b>
Here we can go to the Windows 11 Sensor, and filter by our payload's name.

A lot of hits should be found, with tons of details.

<img src="https://i.imgur.com/AeZkvFQ.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>

<b>Now let's Go Bback to our Ubuntu Attacker.</b>

<h4>Nuking Windows Shadow Copies from an Attacker VM</h4>


<br />
<br />
Observe the wiped disk:  <br/>
<img src="https://i.imgur.com/AeZkvFQ.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
</p>

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
