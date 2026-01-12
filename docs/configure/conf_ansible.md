sample OpenShift 4 - Configuring the Ansible Control Node
======================================================

This document provides guidance on configuring the Ansible control
node that supports the OpenShift 4 installation.


Configuring the Ansible Control Node
------------------------------------

Log in.

```
$ ssh ec2-user@sample-mgmt.{cluster name}.sample.sd.sample.sample.mil
```

Install bind-utils.

```
$ sudo dnf install bind-utils
```

Install tmux
```
$ sudo dnf install tmux
```


Install vim.

```
$ sudo dnf install vim
```

Enable EPEL dnf repository.

```
$ sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

Enable RHEL 7 extras and RHEL 7 optional dnf repositories.

```
$ sudo dnf-config-manager --enable rhel-7-server-rhui-extras-rpms
$ sudo dnf-config-manager --enable rhel-7-server-rhui-optional-rpms
```

Refresh list of enabled repositories.

```
$ sudo dnf repolist
```

Install ansible.

```
$ sudo dnf install -y ansible
```

Set the contents of /etc/ansible/hosts as follows:

```
# sample OpenShift 4 Inventory File

[basebox]
sample-mgmt.{deployment_number}.sample.sd.sample.sample.mil  ansible_connection=local

[ocp4:children]
basebox
resource
api_int_lb
api_ext_lb
ingress_lb

[resource]
resource.{deployment_number}.sample.sd.sample.sample.mil

[api_int_lb]
api-int.{deployment_number}.sample.sd.sample.sample.mil

[api_ext_lb]
api.{deployment_number}.sample.sd.sample.sample.mil

[ingress_lb]
ingress.{deployment_number}.sample.sd.sample.sample.mil

[master1]
ocp-master1.{deployment_number}.sample.sd.sample.sample.mil ansible_ssh_user=core
```

Set the contents of /etc/ansible/group_vars/all.yml as follows:

```
---

ansible_user: ec2-user

ansible_group: "{{ ansible_user }}"

# Only used with AWS cloud provider
private_domain: sd.sample.sample.mil

base_domain: sample.sd.sample.sample.mil

deployment_number: {cluster name}

master_node_ip: {master node IP address}

nfs_server_ip: {nfs server IP address}

domain: "{{ deployment_number }}.{{ cluster_domain }}"

dns_server: <IP address of dnsmasq server>

ntp_server: inssd.sample.sample.mil

```

Set the contents of /etc/ansible/group_vars/ocp4.yml as follows:

> Note: If you wish to use the AWS cloud provider then set the
> ocp_platform variable to "aws". AWS integration allows the use of
> EBS-based persistent storage.

```
---

kubeconfig_path: /opt/ocp/cluster/auth/kubeconfig

ocp_platform: aws

bootstrap_mode: true

ocp4_bootstrap_nodes:
  - ocp-bootstrap

ocp4_master_nodes:
  - ocp-master1

pull_secret: ''

ssh_key: ''

```

> Note: The private-DNS-name is the internal DNS name of the EC2
> instance (of the form "ip-xx-xx-xx-xx"). The need for this is an
> unfortunate consequence of the fact that the AWS cloud provider
> uses the names gathered from AWS metadata as the kubernetes node
> names and there is currently no way to override this behavior on
> AWS.

Generate a SSH key-pair.

```
$ ssh-keygen -t rsa
```

Append the public key found in ~/.ssh/id_rsa.pub to the
~/.ssh/authorized_keys file on all managed RHEL 7 machines.

Connect to each machine via SSH. When prompted with a host key
verification check, type "yes" and press Enter.

```
$ ssh ec2-user@<hostname>
```

Test the Ansible connection.

```
$ ansible -u ec2-user ingress_lb -m ping
```

Installing OpenShift Install Utility
------------------------------------

Obtain the OpenShift install utility from Red Hat. Extract the
utility and move it to the /usr/local/bin directory.

```
$ sudo tar -xzvf openshift-install-linux-<version>.tar.gz
$ sudo mv openshift-install /usr/local/bin
$ sudo rm README.md
```

Installing OpenShift CLI Tools
------------------------------

Obtain the OpenShift CLI (OC) Tools utility from Red Hat. Extract the
utility and move it to the /usr/local/bin directory.

```
$ sudo tar -xzvf oc-<version>-linux.tar.gz
$ sudo mv oc /usr/local/bin
$ sudo mv kubectl /usr/local/bin
$ sudo rm README.md
```

Create symbolic links to oc and kubectl for the root user.

```
$ sudo ln -s oc /usr/bin/oc
$ sudo ln -s /usr/local/bin/kubectl /usr/bin/kubectl
```

Install python2-openshift. This is necessary to use the k8s ansible
module, which will be used extensively to configure the OpenShift
cluster after it is built.

```
$ sudo dnf install -y python2-openshift
```
