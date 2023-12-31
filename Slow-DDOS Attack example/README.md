# Slow DDOS Attacks (not your typical weekend DDOS Attack)

Let's test how robust our infrastructure by firing Slow DDOS type of attacks.
This will test your company's load balancer, your HTTPD config file, and the ability to only accept Complete HTTP headers.

## Materials needed
-A Linux Based workstation (KALI not needed, but OK if you have it), I will be using Linux Mint.

-A Victum, preferrably a webpage, service or appliance, who relies a lot on HTTP.

-Permission from your Victim, please make sure you are authorized to perform this test.

![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/SlowDDOSpicture.png)

## Some Background:
A Slow DDoS (Distributed Denial of Service) attack is a type of cyber attack where the attacker deliberately slows down the target system's performance rather than overwhelming it with a massive volume of traffic all at once. In simple terms:

## Traditional DDoS Attack:

Objective: Overwhelm and flood a system with a massive amount of traffic.

Method: The attacker sends a huge volume of requests to the target, making it difficult for the system to handle legitimate requests.

Effect: The system becomes unavailable or slow due to the excessive traffic.


## Slow DDoS Attack:

Objective: Degrade the target system's performance over time without an immediate flood of traffic.

Method: Instead of a sudden surge, the attacker sends a moderate amount of malicious requests over an extended period.

Effect: The target system's resources are gradually consumed, leading to a slowdown or partial unresponsiveness.


## Differences:

Speed of Attack: Traditional DDoS attacks happen quickly with a sudden flood of traffic, while Slow DDoS attacks occur gradually over an extended period.

Intensity: Traditional DDoS focuses on overwhelming the target with a high volume of requests, while Slow DDoS aims to exhaust resources over time.

Detection: Slow DDoS attacks can be harder to detect since they mimic normal traffic patterns more closely compared to the sudden spikes associated with traditional DDoS attacks.


## Mitigation: 

Defending against Slow DDoS attacks may require different strategies than those used for traditional DDoS attacks. Traditional DDoS protection measures may not be as effective against slow and subtle attacks.
In essence, the main distinction lies in the pacing and approach: traditional DDoS attacks are like a sudden traffic jam, while Slow DDoS attacks are akin to a gradual increase in traffic that eventually leads to congestion.

## Test:

I will be using the terminal with super user (sudo su) rights.

First we pull the image from a pre built Docker Container (There are other ways but this is the quickest one).
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/DockerNope.png)

Shame on me, I forgot to install Docker into this VM let's do it ^ ^.

Good, now it's time to install our attack tool, SlowHttpTest and run it to see the parameters available.

```
docker pull frapsoft/slowhttptest
docker run frapsoft/slowhttptest
```

I just highlighted the important parameters here.
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/SlowHttpTestParams.png)

This is the command I will use, replace the IP with the Victim's IP address
```
slowhttptest -c 3000 -H -g -o ./output_file -i 10 -r 200 -t POST -u http://52.XXX.XXX.XXX/ -x 24 -p 2
```
I can't say much about this one, except is hosted in MS Azure.

Results:
![alt text](https://raw.githubusercontent.com/raulpz/raulpz.github.io/main/assets/images/Slowhttpresult.png)

## Conclusion:

Even though the server was not down, it experienced severe slowness, and apache logs where accepting all incoming fake connections.

We will need to inform our client about their load balance, no Slow DDOS packets should be hitting their HTTTP Server.

END.

raul@pinedo.xyz






