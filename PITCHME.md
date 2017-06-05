### DevSecOps Lausanne meetup   
##### 13.06.2017
A journey to DevSecOps

<!--- ![Masked Cucumber](assets/masked_cucumber_90px.jpg)  -->


---
<span style="color:gray">Embracing DevOps at KS</span>

![ITIL is evil](assets/ITILisevil_avg.png?style=centerimg)

- Re-org + new management |
- Knock walls down (literally) |
- Empower engineering leads |
- Always-on "Designated ops" in "solutions" team |
- Still in the early days of rolling out DevSecOps |


---
<span style="color:gray">Will your DevOps teams embrace security?</span>
* You've been telling your teams...
  * Build & run!
  * You own it, you're responsible for it!
  * You're on-call! 

* Now, you're going to tell them to do security too.

You <span style="color:white">*need*</span> the right people.


---
<span style="color:gray">A few challenges</span>

+++

<span style="color:gray">Hand over your security design</span>
<span style="display:block; text-align:right; color:white">... err, code over documentation my friend! <!-- .element: class="fragment" --></span>


Note:
Code over documentation 
Hence over security design documentation -- likely no documentation
The fast iterations prohibits it

+++

<span style="color:gray">How much effort to put in security</span>
<span style="display:block; text-align:right; color:white">... to possibly just throw things away? <!-- .element: class="fragment" --></span>

Note:
When doing MVP

+++

<span style="color:gray">Does everyone understand the complexity of</span>
<span style="display:block; text-align:right; color:white">... micro-services <!-- .element: class="fragment" --></span>
<span style="display:block; text-align:right; color:white">... containers <!-- .element: class="fragment" --></span>
<span style="display:block; text-align:right; color:white">... cloud <!-- .element: class="fragment" --></span>

Note:
* Vuln in containers
* or in underlying stacks used
* Secrets
* Bad security group in clouds
* floating IP on backend services
* No VPN?

+++

<span style="color:gray">How do you handle change</span>
<span style="display:block; text-align:right; color:white">... when you can deploy several times a day? <!-- .element: class="fragment" --></span>

Note:
Many small automated deployments Vs few big controlled ones
Remember the CAB once every 2 weeks to put a change through?

+++

<span style="color:gray">Separation of Duties</span>
<span style="display:block; text-align:right; color:white">What? Devs have access to prod? <!-- .element: class="fragment" --></span>

Note:
Replace manual checks and gates with automated counterparts

---
<span style="color:gray">Still present in a lot of places</span>
* Separation of duties (i.e., iso27001)
* Many: 
  * are still in favor of few big "controlled" changes
  * say do not touch unless it is broken
  * don't care much about technical debt
* Security still mainly at the perimeter
* InfoSec often lacks pure engineering skills 

Linus Torvalds says:  
> "Talk is cheap, show me the code"

And I say Word&copy; docs are expensive, and just nearly equally worthless.


---
<span style="color:gray">Where to get started</span>
<span style="display:block; text-align:right; color:white">Infrastructure</span>

+++

<span style="color:gray">Logs management</span>
- Normalize your logs across all your components and stacks
- Enable real-time search across all your log sources
- Leverage automated alerts
- Enable log archives for compliance

<span style="display:block; text-align:right; color:white">[Graylog](https://www.graylog.org/) from Graylog </span>

Note:
May not be very DevSecOps specifics, but it is super important

+++

<span style="color:gray">Infra as code</span>
- We use the combination of [pfk](https://theforeman.org/ "puppet/foreman/katello")

<span style="display:block; text-align:right; color:white">\+ Automate your deployment <!-- .element: class="fragment" --></span>
<span style="display:block; text-align:right; color:white">\+ Merge request your infra <!-- .element: class="fragment" --></span>
<span style="display:block; text-align:right; color:white">\+ Consistency <!-- .element: class="fragment" --></span>
<span style="display:block; text-align:right; color:white">\+ Reduce config error/drift <!-- .element: class="fragment" --></span>

Note:
Example of ssh deployment issue with another puppet master

+++

<span style="color:gray">Know about your cloud basics</span>
<span style="display:block; text-align:right; color:white">\+ Scan Security Groups for ingress 0.0.0.0/0</span>

+++

<span style="color:gray">Introduce container scanning</span>

Containers you use most likely contain vulnerabilities.

Know about them.

<span style="display:block; text-align:right; color:white">\+ [Clair](https://github.com/coreos/clair "Clair") from CoreOS <!-- .element: class="fragment" --></span>
<span style="display:block; text-align:right; color:white">\+ [docker-bench-security](https://github.com/docker/docker-bench-security "docker-bench-security")<!-- .element: class="fragment" --></span>

Act.
<span style="display:block; text-align:right; color:white">\+ [Apparmor profiles](https://docs.docker.com/engine/security/apparmor/ "Apparmor profiles")<!-- .element: class="fragment" --></span>
<span style="display:block; text-align:right; color:white">\+ [Seccomp profiles](https://docs.docker.com/engine/security/seccomp/ "seccomp profiles")<!-- .element: class="fragment" --></span>

+++

<span style="color:gray">Secrets management</span>
Make sure your passwords, certificates or other keys are used in a safe manner.

<span style="display:block; text-align:right; color:white">- [Vault](https://www.vaultproject.io/ "Vault") from Hashicorp <!-- .element: class="fragment" --></span>
<span style="display:block; text-align:right; color:white">- [KeyWhiz](https://square.github.io/keywhiz/ "Keywhiz") from Square Engineering <!-- .element: class="fragment" --></span>

 
DevOps and Security are no enemy 
* Frequent changes and software updates is good for security
  * How long do you think it takes to prepare an attack?
  * Most exploits are against legacy code
  * It minimizes risks


---

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
* NetFlow your firewalls and see if your zones are still as trusted as it should

---
# Experiment
* Capture the Flag
* Read/Blue teams
  * (Not talking about NERFs battles here)
* Bounty programs (i.e. hackerone.com, github security)
* Pen testing

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
