### DevSecOps Lausanne meetup   
##### 13.06.2017
DevSecOps - thoughts from an infra guy


---
<span style="color:gray; display:block; text-align:center">Embracing DevOps at KS</span>

<!--- ![Masked Cucumber](assets/masked_cucumber_90px.jpg)  -->
![DevOps_SouthPark](assets/devops_southpark_400.png?style=centerimg)
<!--- ![ITIL is evil](assets/ITILisevil_avg.png?style=centerimg) -->

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

<span style="color:gray">Where is your security design documented?</span>
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
<span style="display:block; text-align:right; color:white">? micro-services <!-- .element: class="fragment" --></span>
<span style="display:block; text-align:right; color:white">? containers <!-- .element: class="fragment" --></span>
<span style="display:block; text-align:right; color:white">? cloud <!-- .element: class="fragment" --></span>

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
<span style="color:gray">What is still present in a lot of places</span>
* Separation of duties (i.e., iso27001)
* Many: 
  * are still in favor of few big "controlled" changes
  * say do not touch unless it is broken
  * don't care much about technical debt
* Security still mainly at the perimeter
* InfoSec often lacks pure engineering skills 

Linus Torvalds says:  
> "Talk is cheap, show me the code."

And I say "Word&copy; docs are expensive, show me the code."

Note:
Classic org separates IT production from R&D
CorpSec is yet another split

---
<span style="color:gray">Where to get started</span>
<span style="display:block; text-align:right; color:white">Make security a first class citizen</span>

+++

<span style="color:gray">Too few SecOps professionals are also coders or infra guys</span>

<span style="display:block; text-align:right; color:white">\+ Security obviously needs to be alive within the squad</span>
<span style="display:block; text-align:right; color:white">\+ Train your teams for security</span>
<span style="display:block; text-align:right; color:white">\+ Dedicate a champion</span>

Note:
OWASP provides good materials 

+++

<span style="color:gray">Hush your ego, leverage your teammates</span>

- Ask your Ops guys
  - [Good] network guys usually have some security skills under the belt
  - [Good] systems engineers usually know how to secure an O/S or a middleware component

- Security reviews
  - Not only between Devs as "code reviews"
  - Can also happen between Ops, Devs and Secs guys

<span style="display:block; text-align:right; color:white">Provoke the mindset change!</span>


---
<span style="color:gray">Where to get started</span>
<span style="display:block; text-align:right; color:white">Infrastructure</span>

+++

<span style="color:gray">Frequent changes and updates are good for security</span>
- How long do you think it takes to prepare an attack?
- Most exploits are against legacy code.
- It minimizes deployment risks over time.

+++

<span style="color:gray">Logs management</span>
- Normalize your logs across all your components
- Enable real-time search across all your log sources
- Leverage dashboards
- Leverage automated alerts
- Enable log archives for compliance
- Leverage netflow

<span style="display:block; text-align:right; color:white">[Graylog](https://www.graylog.org/) from Graylog </span>

Note:
May not be very DevSecOps specifics, but it is super important

+++

<span style="color:gray">Infra as code</span>

We use the combination of [Puppet/Foreman/Katello](https://theforeman.org/) and [Jenkins](https://www.cloudbees.com/jenkins/jenkins-2)

<span style="display:block; text-align:right; color:white">\+ Automate your deployment </span>
<span style="display:block; text-align:right; color:white">\+ Merge request your infra </span>
<span style="display:block; text-align:right; color:white">\+ Consistency </span>
<span style="display:block; text-align:right; color:white">\+ Reduce config error/drift </span>
<span style="display:block; text-align:right; color:white">\+ Automatically install security updates </span>


Other products such as [UpGuard](https://www.upguard.com) or [CloudPassage](https://www.cloudpassage.com) can help too.

Note:
Example of ssh deployment issue with another puppet master

+++

<span style="color:gray">Harden your O/S</span>

Leverage your configuration management tool to

- Harden your configuration management tool 
- Harden your systems 
- Harden your CI/CD infrastructure and your code repositories
- Shutdown unnecessary services, reduce the attack surface
- Enable SElinux / apparmor
- Make sure logs are shipped to your central log management system

<span style="display:block; text-align:right; color:white">\+ [puppet-os-hardening](https://github.com/dev-sec/puppet-os-hardening)</span>
<span style="display:block; text-align:right; color:white">\+ [OSSEC](https://ossec.github.io)</span>

+++

<span style="color:gray">Know about your cloud basics</span>

Include in your pipeline as much as possible

<span style="display:block; text-align:right; color:white">\+ Scan security groups for ingress 0.0.0.0/0</span>
<span style="display:block; text-align:right; color:white">\+ Make sure your images are always up-to-date</span>
<span style="display:block; text-align:right; color:white">\+ Perform regular perimater scans as well</span>

Note:
Cannot hurt to have regular scans if actually looking at results
Diff can be automated and possibly 

+++

<span style="color:gray">Introduce container scanning</span>

Containers you use most likely contain vulnerabilities.

<span style="display:block; text-align:right; color:white">\+ [Clair](https://github.com/coreos/clair "Clair") </span>
<span style="display:block; text-align:right; color:white">\+ [docker-bench-security](https://github.com/docker/docker-bench-security "docker-bench-security")</span>

Protect them with existing tech

<span style="display:block; text-align:right; color:white">\+ [Apparmor profiles](https://docs.docker.com/engine/security/apparmor/ "Apparmor profiles")</span>
<span style="display:block; text-align:right; color:white">\+ [Seccomp profiles](https://docs.docker.com/engine/security/seccomp/ "seccomp profiles")</span>

+++

<span style="color:gray">Secrets management</span>

Make sure your passwords, certificates or other keys are used in a safe manner.

<span style="display:block; text-align:right; color:white">\+ [Vault](https://www.vaultproject.io/ "Vault") from Hashicorp</span>
<span style="display:block; text-align:right; color:white">\+ [KeyWhiz](https://square.github.io/keywhiz/ "Keywhiz") from Square Engineering</span>

+++

<span style="color:gray">Assess</span>

If at all possible, get a second -- outside -- opinion.

<span style="display:block; text-align:right; color:white">\+ [hackerone](https://www.hackerone.com) Vuln &amp; bug bounty platform</span>
<span style="display:block; text-align:right; color:white">\+ [Github security](https://bounty.github.com)</span>
<span style="display:block; text-align:right; color:white">\+ Red Vs Blue teams</span>
<span style="display:block; text-align:right; color:white">\+ Pen testing</span>

---
# Measure
---

## Secure your code repo
* Wealth of info not to fall in the wrong hands

## Adapt your monitoring
* Dynamic monitoring for containers and cloud workloads
* Constant redployment

---
Questions? (and hopefully answers)

---
References

- Veracode: The Developer's Guide to the DevSecOps galaxy
- DevOps and Security: From the Trenches to Command Centers: https://blog.xebialabs.com/2017/05/04/devops-security-trenches-command-centers
- How Etsy makes Devops work: http://www.networkworld.com/article/2886672/software/how-etsy-makes-devops-work.html
- DevSecOps: http://www.oreilly.com/webops-perf/free/files/devopssec.pdf
- The treacherous 12: https://downloads.cloudsecurityalliance.org/assets/research/top-threats/Treacherous-12_Cloud-Computing_Top-Threats.pdf
- DevOps explained: https://www.niceideas.ch/roller2/badtrash/entry/devops-explained
