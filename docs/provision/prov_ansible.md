sample OpenShift 4 - Provisioning an Ansible Control Node
======================================================

This document provides guidance on provisioning the Ansible control
node that supports the OpenShift 4 installation.


Provisioning the Ansible Control Node
-------------------------------------

Provision an EC2 instance using the following launch specifications.

AMI: RHEL-7.9_HVM_GA-20200917-x86_64-0-Hourly2-GP2 - ami-e9d5ec88
Instance type: t3.small (2 vCPU/2 GiB)
Storage: 40GB gp2

Tags:
  - Owner: sample
  - Creator: {name of server creator}
  - Purpose: ocp4

Security Group:
  - default

In the AWS management console, set the machine's name to
sample-mgmt.{cluster name}.sample.sd.sample.sample.mil


Pre-configuring the Ansible Control Node
----------------------------------------

Log in.

> Note: It may take an hour or more for sample's "CloudSync" tool to
> automatically register the instance and generate DNS records for
> it. In the meantime, log in using the machine's IP address.

```
$ ssh ec2-user@<IP address>
```

Set the hostname.

```
$ sudo hostnamectl set-hostname --static sample-mgmt.{cluster name}.sample.sd.sample.sample.mil
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
$ ssh ec2-user@sample-mgmt.{cluster name}.sample.sd.sample.sample.mil
```

Confirm that kernel has been updated.

```
$ uname -a
```

Logout.

```
$ exit
```
