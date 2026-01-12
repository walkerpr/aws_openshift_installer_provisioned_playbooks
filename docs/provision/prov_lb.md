sample OpenShift 4 - Provisioning Load Balancers
=============================================

This document provides guidance on building out supporting
infrastructure for OpenShift 4.


Provisioning Load Balancers
---------------------------

Provision three EC2 instances using the following launch specifications.

AMI: RHEL-7.9_HVM_GA-20200917-x86_64-0-Hourly2-GP2 - ami-e9d5ec88
Instance type: t3.small (2 vCPU/2 GiB)
Storage: 12GB gp2

Tags:
  - Owner: sample
  - Creator: {name of server creator}
  - Purpose: ocp4

Security Group:
  - default

In the AWS management console, set the machines' names as follows:
  - api-int.{cluster name}.sample.sd.sample.sample.mil
  - api.{cluster name}.sample.sd.sample.sample.mil
  - ingress.{cluster name}.sample.sd.sample.sample.mil


Pre-configuring Load Balancers
------------------------------

Log in.

```
$ ssh ec2-user@api-int.{cluster name}.sample.sd.sample.sample.mil
```

Set the hostname.

```
$ sudo hostnamectl set-hostname --static api-int.{cluster name}.sample.sd.sample.sample.mil
```

Update the system.

```
$ sudo dnf update-minimal --security
```

Reboot.

```
$ sudo reboot
```

Login again.

```
$ ssh ec2-user@api-int.{cluster name}.sample.sd.sample.sample.mil
```

Confirm that kernel has been updated.

```
$ uname -a
```

Logout.

```
$ exit
```

Repeat the above steps for the api and ingress load balancers. Make
sure to use the correct FQDN when logging in and setting the hostname
on each machine.
