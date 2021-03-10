# Basic exercises for best practices in Orion

**Login into orion** 

To log into Orin we need two things:
- Stablish a VPN connection
- Use a secure-shell command [ssh](https://en.wikipedia.org/wiki/SSH_(Secure_Shell))

*For loging just type something like this. Remember to change to your username bio326-21-x*
```bash
$ ssh bio326-21-0@login.nmbu.no
```
This will ask for your password. Type it

*Even you don't see anything the password is typed*

```bash
bio326-21-0@login.orion.nmbu.no's password: 
Last login: Tue Mar  2 11:18:13 2021 from 10.230.14.52

Welcome to the NMBU Orion compute cluster environment.

You are logged in to a machine that can be used to access your home directory,
edit your scripts, manage your files, and submit jobs to the cluster environment.
Do not run any jobs on this machine, as they might be automatically terminated.

IMPORTANT:
  - Orion introduction: https://orion.nmbu.no/
  - Orion can handle small-scale projects. Need more CPU hours? Please consider
    applying for national infrastructure resources: https://www.sigma2.no/
  - Please, PLEASE do compress your fastq, vcf and other non-compressed files
    using i.e. pigz.

For any Orion related enquiry: orion-support@nmbu.no
PS: We are on Teams: https://bit.ly/orion-teams

[bio326-21-0@login ~]$ 
```

**Now you are logged into the Orion login-node.**

### Orion main confifuration 

Let's take a look into this figure: 

![Cluster](https://github.com/avera1988/NMBU-Bio-326/blob/main/images/cluster.png)

**NEVER RUN A JOB IN THE LOGIN NODE!!! THE LOGIN NODE IS ONLY FOR LOOKING AND MANAGING FILES, INSTALL SOFTWARE AND WRITE SCRIPTS** 

How can I be sure of the number of CPUs and RAM of this "login" computer node and other nodes?

* CPUS: Use the command nproc

```Bash
[bio326-21-0@login ~]$ nproc 
6
```

* RAM: We need to look for the "Total memory". All this info is allocated in the meminfo file at /proc directory. So we can use the grep command to look for this into the file.

```
bio326-21-0@login ~]$ grep MemTotal /proc/meminfo
MemTotal:       32744196 kB
```
