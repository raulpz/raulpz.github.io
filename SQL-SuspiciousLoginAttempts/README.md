<h1>MariaDB - Using SQL queries to evluate suspicious login attempts</h1> 

<h2>Description</h2>
As part of our monthly routine check, we need to explore our EMPLOYEES and LOG_IN_ATTEMPTS tables,  in search for suspicious patterns or login_attempts after business hours 6PM (18:00). 
Extracting the desired information from MariaDB.

Table’s description is outlined as follows:
<img src="https://imgur.com/o98H4y6.png" height="80%" width="80%"/>

<br />

<h2>Retrieve after hours failed login attempts</h2>

We recently discovered a potential security incident that occurred after business hours. To investigate this, we will need to query the log_in_attempts table and review after hours login activity. We are focussing on failed login attempts registered by our Domain Controller running Windows Server 2019.

````
SELECT * FROM log_in_attempts WHERE login_time > '18:00' AND success = '0';
````
<img src="https://imgur.com/6kT2wph.png" height="80%" width="80%"/>

<h2>Retrieve login attempts on specific dates</h2>

A suspicious event occurred on 2022-05-09. To investigate this event, we want to review all login attempts which occurred on this day and the day before. Using filters in SQL to create a query that identifies all login attempts that occurred on 2022-05-09 or 2022-05-08.

````
SELECT * FROM log_in_attempts WHERE login_date = '2022-05-08' OR login_date = '2022-05-09';
````
<img src="https://imgur.com/uD3hfUz.png" height="80%" width="80%"/>


<h2>Retrieve login attempts outside of Mexico</h2>

There’s been suspicious activity with login attempts, but the team has determined that this activity didn't originate in Mexico. Now, we need to investigate login attempts that occurred outside of Mexico. (When referring to Mexico, the country column contains values of both MEX and MEXICO).

````
SELECT * FROM log_in_attempts WHERE NOT country LIKE 'MEX%';
````
<img src="https://imgur.com/D9oA3Fq.png" height="80%" width="80%"/>

<h2>Retrieve employees in Marketing</h2>

Our team wants to perform security updates on specific employee machines in the Marketing department. We are responsible for getting information on these employee machines and will need to query the employees table. (Note: the team only wants data from the East Wing of the building).

````
SELECT * FROM employees WHERE department = 'Marketing' AND office LIKE 'EAST%';
````
<img src="https://imgur.com/IctsQff.png" height="80%" width="80%"/>

<h2>Retrieve all employees not in IT</h2>

The team needs to make one more update to employee machines. The employees who are in the Information Technology department already had this update, but employees in all other departments need it.

````
SELECT * FROM employees WHERE NOT department = 'Information Technology';
````
<img src="https://imgur.com/BC3T9Lh.png" height="80%" width="80%"/>

<h2>Summary</h2>
We need to dive more into the many failed login attempts after hours, this is a company who works with bank business hours most of the time, The  amount of failed login attempts are concerning.
In regards to the Security Patching issue, there are still 161 computers without the  latest Windows 10 Cumulative Update, this is a potential hole for Day Zero Attacks, IT+Helpdesk need teams need to address this ASAP.

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






