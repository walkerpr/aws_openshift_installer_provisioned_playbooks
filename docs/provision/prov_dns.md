sample OpenShift 4 - Provisioning a DNS Server
===========================================

This document provides guidance on building a DNS server that
supports the OpenShift 4 installation.

OpenShift 4 requires DNS records to be populated before provisioning
any RHCOS machines. If you don't have access to a DNS server or your
organization's DNS service doesn't support creation of records before
provisioning machines, then you can use dnsmasq as a workaround. This
document shows how to build a dnsmasq server.

If already have a DNS server, then you can skip these instructions.
But you must create DNS records (A and PTR) for all of your machines
and make sure they resolve before provisioning any RHCOS machines.

Although you can configure the load balancers before these records
are populated, you must ensure they are present before attempting to
configure the load balancers. Otherwise the HAProxy service will fail
to start.


Provisioning the DNS Server
---------------------------

Provision an EC2 instance using the following launch specifications.

AMI: RHEL-7.9_HVM_GA-20200917-x86_64-0-Hourly2-GP2 - ami-e9d5ec88
Instance type: t3.small (2 vCPU/2 GiB)
Storage: 12GB gp2

Tags:
  - Owner: sample
  - Creator: {name of server creator}
  - Purpose: ocp4

Security Group:
  - default

In the AWS management console, set the machine's name to
rx-neptune.{cluster name}.sample.sd.sample.sample.mil


Pre-configuring the DNS Server
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
$ sudo hostnamectl set-hostname --static rx-neptune.{cluster name}.sample.sd.sample.sample.mil
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
$ ssh ec2-user@rx-neptune.{cluster name}.sample.sd.sample.sample.mil
```

Confirm that kernel has been updated.

```
$ uname -a
```

Logout.

```
$ exit
```
