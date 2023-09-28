# Enterprise IT Systems Advisor

#### Technical Skills: UNIX FreeBSD, Python, MariaDB, Azure(adminstration), Security Patching

### Small\Hobbie Projects

## Detect a Shadow Copy Removal attempts perpetrated by unauthorized attacker with LimaCharlie EDR

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
![alt text](https://github.com/raulpz/raulpz.github.io/blob/main/assets/images/install-sensor.png)

Wait a couple of minutes to go back to Sensors List, and your new agent should be already reporting back to our EDR.
![alt text](https://github.com/raulpz/raulpz.github.io/blob/main/assets/images/sensor-ok.png)

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
![alt text](https://github.com/raulpz/raulpz.github.io/blob/main/assets/images/Artifacts-collection.png)

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
![alt text](https://github.com/raulpz/raulpz.github.io/blob/main/assets/images/sliver-server.png)
