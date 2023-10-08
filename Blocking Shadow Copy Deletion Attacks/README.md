<h1>Blocking Shadow Copy Deletion Attacks using LimaCharlie Endpoint Detection and Response tool</h1>

<h2>Description</h2>
This little lab consists of documenting the steps to block Shadow Copy deletion attempts, orchrestrated by unauthorized users or threat actors. We will be using LimaCharlie EDR.
Volume Shadow Copies offer an easy way to recover specific files or an entire file system to an earlier state, making it a highly appealing choice for recovering from a ransomware attack.

So if your company is due to receive a Ransomware Attack, threat actors might want to get rid of your Windows' backups first.

It is important to pay attention to Shadow Copy Deletion routines, since they might be a prelude to a incoming Ransomware Virus attack.
<br />

<h2>Utilities Used</h2>

- <b>LimaCharlie Endpoint Detection and Response</b> 

<h2>Environments Used </h2>

- <b>Virtual Machine - Windows 11 22H2</b> (Victim VM) 
- <b>Virtual Machine - Ubuntu Server 22.03.1</b> (Attacker VM)

<h2>Walk-through:</h2>

Turn on Windows 11 and Ubuntu Server VMs.

We will need to launch Sliver Server with Super User rights (please check my previous lab notes).
From Sliver Server, we will connect to our malicious payload using it's session ID.

Once connected, we will run:
```
shell
```
<img src="https://imgur.com/dSx4DHH.png" height="80%" width="80%"/>

There will be a warning about this being bad for Operations Security, we will answer Yes and hit Enter.
Now we are ready to launch any command we like from Powershell with Administrator's Rights.

We will then run the command that tells Windows to nuke it's Shadow Copies of files and folders:
```
vssadmin delete shadows /all
```
The command may fail to do so, but we just want to make some noise, to generate Telemetry data for our LimaCharlie Sensor.

Now if we go back to our EDR's organization named Home-Lab-PTY, and head over to detections; it should be raising the flag for a Shadow Copies Deletion Command being executed.

<img src="https://imgur.com/DrDt5gC.png" height="80%" width="80%"/>
It even tells us, it's coming from a Powershell prompt.

OK, now let's click on "View Event Timeline", this will take us to our timeline tab, and from there we can build a Detection and Response Rule for this event.

<img src="https://imgur.com/3ynooXM.png" height="60%" width="60%"/>

<img src="https://imgur.com/nButIix.png" height="60%" width="60%"/>


**** Crafting the Response Rule

Here we are going to use the default generated Detection rule, for the response part, I will use this:
```
- action: report
  name: VSS-KILL-SWITCH
- action: task
  command:
    - deny_tree
    - <<routing/parent>>
```
This defines an action named "VSS-KILL-SWITCH" of type report. When a condition is met, it will generate a report with this name.
And a task action that involves denying access to a directory structure (deny_tree) with a placeholder for the parent routing information.

<img src="https://imgur.com/qwq252u.png" height="60%" width="60%"/>

Hit Save.

For a Reference visit: [Sensor Commands](https://docs.limacharlie.io/docs/sensors-sensor-commands#deny_tree "LimaCharlie Documentation - deny_tree")

#### Done
This will prevent future Command and Control Attacks (C2) , who target Windows' Shadow Copies.

Test your rule by re running the command from Sliver-Server (using your Ubuntu Linux Server VM).
```
vssadmin delete shadows /all
```

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
