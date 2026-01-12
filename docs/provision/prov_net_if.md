sample OpenShift 4 - Provisioning Network Interfaces
=================================================

This document provides guidance on building an OpenShift 4 cluster.

We must pre-create network interfaces for the RHCOS machines. This
will help reserve the IP addresses so that we can configure DNS with
the correct addresses before launching the machines. When the
RHCOS machines are launched they will be configured to point to a
our own DNS server and begin their bootstrap process. We cannot let
them point to sample DNS because the sample "CloudSync" has a long delay
before it registers the machines and generates DNS records for them.

Creating Network Interfaces
---------------------------

Log into the AWS management console.

Click *Services* >> *EC2*.

Click *Network Interfaces*.

Click *Create Network Interface*.

Create the following key-value tags:
  - Owner: sample
  - Creator: {name of server creator}
  - Purpose: ocp4

Repeat the above steps to create a total of eight network interfaces.
In the AWS management console, name them as follows:
  - ocp-boostrap
  - ocp-master1
