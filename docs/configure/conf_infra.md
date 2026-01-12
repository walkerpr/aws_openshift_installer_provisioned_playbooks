sample OpenShift 4 - Configuring Supporting Infrastructure
=======================================================

This document provides guidance on configuring infrastructure that
supports the OpenShift 4 installation.


Configuring Supporting Infrastructure
-------------------------------------

Log in to the Ansible control node.

```
$ ssh ec2-user@sample-mgmt.{cluster name}.sample.sd.sample.sample.mil
```

Run the following playbook to install some useful tools.

> Note: The -k option below isn't required when using SSH keys. We
> recommend using it anyways to get a confirmation prompt before
> running playbooks. This way, if you accidentally run an ansible
> playbook from your command history, then you have a chance to
> abort the operation before it starts. You can type any made-up
> password when prompted and it will still work.

```
$ ansible-playbook -vvkbu ec2-user playbooks/core/common.yml
```

Run the following playbook to install a host firewall.

```
$ ansible-playbook -vvkbu ec2-user playbooks/core/firewall.yml
```

Run the following playbook to configure the resource server.

```
$ ansible-playbook -vvkbu ec2-user playbooks/ocp-aux/web-server/web-server.yml
```

Verify httpd serves up test page.

```
$ curl http://resource.{cluster name}.sample.sd.sample.sample.mil
```

Run the following playbook to point the load balancers to the dnsmasq
server. This is only necessary if you built a dnsmasq server.

```
$ ansible-playbook -vvkbu ec2-user playbooks/core/dns-supersede.yml
```

Run the following playbooks to configure the load balancers.

```
$ ansible-playbook -vvkbu ec2-user playbooks/ocp-aux/api-int-lb/api-int-lb.yml
$ ansible-playbook -vvkbu ec2-user playbooks/ocp-aux/api-lb/api-ext-lb.yml
$ ansible-playbook -vvkbu ec2-user playbooks/ocp-aux/ingress-lb/ingress-lb.yml
```

Configuring AWS (This only needs to be done once, these IAM roles can be used on all sample dev clusters)
---------------

If the "platform" field in install-config.yaml is set to aws, then it
means the AWS cloud provider will be used. You must then create the
following IAM roles. They will be applied later on when he OCP nodes
are provisioned.

Create a sample_ocp4_master role and associate it with a new
sample_ocp4_master policy with the following allow rule.
  Action:
    - "ec2:AttachVolume"
    - "ec2:CreateTags"
    - "ec2:CreateVolume"
    - "ec2:DeleteVolume"
    - "ec2:Describe*"
    - "ec2:DetachVolume"
    - "ec2:ModifyInstanceAttribute"
    - "ec2:ModifyVolume"
    - "kms:DescribeKey"
  Resource: "*"

Create a sample_ocp4_worker role and associate it with a new
sample_ocp4_worker policy with the following allow rule.
  Action:
    - "ec2:DescribeInstances"
    - "ec2:DescribeRegions"
  Resource: "*"

> Note: If these roles are not applied to the OCP nodes properly then
> the kubelets will fail to start, and you will not be able to use
> EBS volumes for persistent storage.
