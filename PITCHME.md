### DevSecOps Lausanne meetup   
##### 13.06.2017
A journey to DevSecOps

![Masked Cucumber](assets/masked_cucumber_90px.jpg)


---
<span style="color:gray">Embracing DevOps at KS</span>

- Re-org 
- New management
- **Engineering tech leads empowered**

+++

<span style="display: block; text-align: center">![ITIL is evil](assets/ITILisevil_avg.png)</span>

- Knock walls down (literally) |
- Empower engineering leads |
- Always-on "Designated ops" in "solutions" team |
- Still in the early days of rolling out DevSecOps |


---
<span style="color:gray">Will your DevOps team embrace security?</span>
* You've been telling your teams...
  * Build & run!
  * You own it, you're responsible for it!
  * You're on-call! 

* Now, you're going to tell them to do security too.

You *need* the right people.


---
<span style="color:gray">A few challenges</span>

+++

<span style="color:gray">Security design</span>
* Code over documentation 
  * Hence over security design documentation -- likely no documentation
* The fast iterations prohibits it

+++

<span style="color:gray">Security effort</span>

How much effort to put in security
  
<span style="display:block; text-align:right">... to possibly just throw things away?</span>

Note:
When doing MVP

+++

<span style="color:gray">Complexity</span>

Does everyone understand the complexity of 
  ... micro-services
  ... containers 
  ... cloud

Note:
* Vuln in containers
* or in underlying stacks used
* Secrets
* Bad security group in clouds
* floating IP on backend services
* No VPN?

+++

<span style="color:gray">How do you handle change?</span>

Note:
Many small automated deployments Vs few big controlled ones

+++

<span style="color:gray">Separation of Duties</span>

What? Devs have access to prod?


---
<span style="color:gray">Meanwhile, in the land of reality</span>
* Separation of duties
  * i.e., iso27001
* Most are still under the impression that there should be few (and big) controlled changes
* Most say do not touch unless it is broken
* Most don't care much about technical debt
* Security still at the perimeter
  * InfoSec often lacks pure engineering skills 
  
> Talk is cheap, show me the code
> -- Linus Torvalds


---
DevOps and Security are no enemy 
* Frequent changes and software updates is good for security
  * How long do you think it takes to prepare an attack?
  * Most exploits are against legacy code

---

# Secret management
* Hashicorp vault
* Keywhiz

Threat modeling
* JWT

---
# Hush your ego, leverage your teammates
* Ask your Ops guys
  * [Good] network guys usually have some security skills under the belt
  * [Good] systems engineers usually know how to secure an O/S or a middleware component

* Code reviews
  * Not only between Devs
  * Can also happen with Ops or Secs guys

---
# Automate security into your CI/CD

* i.e. Static analysis (i.e. sonarqube + OWASP plugin)
* CoreOS clair for static image analysis (avoid poisoned image attacks)
* Use docker-bench-security to spot `[WARN]` or higher
* NetFlow your firewalls and see if your zones are still as trusted as it should

---
# Experiment
* Capture the Flag
* Read/Blue teams
  * (Not talking about NERFs battles here)
* Bounty programs (i.e. hackerone.com, github security)
* Pen testing

---
# Automate
## Infra as code
Puppet

## Scans
* Trigger a scan as part of your integration workflow

---
# Measure
---
# What can you do?
* Adopt a software security engineer / infra security engineer
* Have someone volunteer to wear that hat

## Secure your code repo
* Wealth of info not to fall in the wrong hands

## Adapt your monitoring
* Dynamic monitoring for containers and cloud workloads
* Constant redployment

---
# References
- Veracode : The Developer's Guide to the DevSecOps galaxy
- DevOps and Security: From the Trenches to Command Centers: https://blog.xebialabs.com/2017/05/04/devops-security-trenches-command-centers
- How Etsy makes Devops work: http://www.networkworld.com/article/2886672/software/how-etsy-makes-devops-work.html
- DevSecOps : http://www.oreilly.com/webops-perf/free/files/devopssec.pdf
- The treacherous 12: https://downloads.cloudsecurityalliance.org/assets/research/top-threats/Treacherous-12_Cloud-Computing_Top-Threats.pdf
