sample OpenShift 4 - Provisioning a Web Server
===========================================

This document provides guidance on building a web server that
supports the OpenShift 4 installation.

OpenShift 4 uses a bootstrap process called Ignition. This process
requires that .ign files be retrieved from a web server. Instructions
for building a httpd server to perform that function are given below.


Provisioning the Web Server
---------------------------

Provision an EC2 instance using the following launch specifications.

> Note: You may combine the web server functionality with another
> machine if your security policies permit it. You can also use S3
> instead of a web server, but that option is not describe here.

AMI: RHEL-7.9_HVM_GA-20200917-x86_64-0-Hourly2-GP2 - ami-e9d5ec88
Instance type: t3.small (2 vCPU/2 GiB)
Storage: 20GB gp2

Tags:
  - Owner: sample
  - Creator: {name of server creator}
  - Purpose: ocp4

Security Group:
  - default

In the AWS management console, set the machine's name to
resource.{cluster name}.sample.sd.sample.sample.mil


Pre-configuring the Web Server
------------------------------

Log in.

> Note: It may take an hour or more for sample's "CloudSync" tool to
> automatically register the instance and generate DNS records for
> it. In the meantime, log in using the machine's IP address.

```
$ ssh ec2-user@<IP address>
```

Set the hostname.

```
$ sudo hostnamectl set-hostname --static resource.{cluster name}.sample.sd.sample.sample.mil
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
$ ssh ec2-user@resource.{cluster name}.sample.sd.sample.sample.mil
```

Confirm that kernel has been updated.

```
$ uname -a
```

Logout.

```
$ exit
```
