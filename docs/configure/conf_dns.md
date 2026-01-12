sample OpenShift 4 - Configuring the DNS Server
============================================

This document provides guidance on configuring the DNS server that
supports the OpenShift 4 installation.


Configuring the DNS Server
--------------------------

Log in.

```
$ ssh ec2-user@rx-neptune.{cluster name}.sample.sd.sample.sample.mil
```

Install bind-utils.

```
$ sudo dnf install bind-utils
```

Install vim.

```
$ sudo dnf install vim
```

Install firewalld.

```
$ sudo dnf install firewalld
```

Enable and start firewalld.

```
$ sudo systemctl enable firewalld
$ sudo systemctl start firewalld
```

Allow DNS traffic through host firewall.

```
$ sudo firewall-cmd --add-service=dns
$ sudo firewall-cmd --add-service=dns --permanent
```

Install dnsmasq.

```
$ sudo dnf install dnsmasq
```

Add the following entries to /etc/hosts. Replace the IP addresses
shown with the actual IP addresses of your pre-built EC2 network
interfaces.

```
{ip address}  ocp-bootstrap.{cluster name}.sample.sd.sample.sample.mil
{ip address}  ocp-master1.{cluster name}.sample.sd.sample.sample.mil
```

Enable and start dnsmasq.

```
$ sudo systemctl enable dnsmasq
$ sudo systemctl start dnsmasq
```

Verify dnsmasq service answers DNS search queries properly.

```
$ dig @localhost ocp-master1.{cluster name}.sample.sd.sample.sample.mil +short
$ dig @localhost -x {ip address} +short
```
