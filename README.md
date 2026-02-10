OpenShift - Installation
==============================

This document provides guidance on Installing OpenShift 4.

- [OpenShift - Installation](#openshift---installation)
- [IMPORTANT](#important)
- [Prerequisites](#prerequisites)
- [Variables](#variables)
  - [`deploymentNumber` options:](#deploymentnumber-options)
- [Provisioning Supporting Infrastructure](#provisioning-supporting-infrastructure)
- [Deploy OpenShift Cluster](#deploy-openshift-cluster)
  - [Complete Installation](#complete-installation)
  - [Auxiliary Resource Deployment](#auxiliary-resource-deployment)
  - [Post Resource Deployment](#post-resource-deployment)
- [Appendix: Deploy All AWS OpenShift components from Bash Script](#appendix-deploy-all-aws-openshift-components-from-bash-script)

IMPORTANT
===============================

Before running the playbooks, ensure you've start a disconnected session by running the  `tmux` command before starting the deployment. This ensures the playbook doesn't break due to a disconnected session. For more details on leveraging screen, see https://linux.die.net/man/1/tmux.


Prerequisites
===============================
If Ansible is not already installed on the system, run the `installAnsible.sh` script in the `supportScripts` directory. The system will reboot after the script completes.

**Obtain a pull secret from Red Hat OpenShift Cluster Manager website**
at https://cloud.redhat.com/openshift/install/pull-secret.

Once obtained, use `ansible-vault` to encrypt the pull secret and place it in ./group_vars/secrets.yaml

Ensure the ansible vault password is stored in `~/.ansible_vault_password` prior.

```bash
ansible-vault encrypt_string '{"auths":{"cloud.openshift.com":{"auth":"...' --name 'pull_secret' > ./group_vars/secrets.yaml
```

Ensure the OpenShift version information in /etc/ansible/group_vars/ocp4.yml are correct.

Ensure the config file exists in '~/.aws/config' and that there is a region for the 'default' profile.

```bash
[default]
region = {{ aws_region }}
```

Variables
==============================

## `deploymentNumber` options:

- 0
- 1
- 2
- 3
- 4
- 5
- 6
- 7
- 8
- 9

*Subject to grow as more infrastructure is provisioned*


Provisioning Supporting Infrastructure
==============================
Prior to deployment, ensure the Cloud Formation Stack for the $deploymentNumber has been deployed. See the sample-cloudformation-sample repository for details.



Deploy OpenShift Cluster
==============================

This playbook runs through all of the necessary roles to complete the install.

```bash
$ ansible-playbook playbooks/ocp-install/site.yml -e "deployment_number=$deploymentNumber" -i inventory_files/all.inv
```


Complete Installation
---------------------

Check status of installation. This can probably be done after the
the infra-nodes are added, but it doesn't hurt to do it here. It has
been observed that the wait-for may take a significant amount of time
and appear to report extraneous errors if you don't wait long enough.

```bash
$ openshift-install wait-for install-complete --dir=/opt/ocp/cluster$deploymentNumber/cluster/
```

Verify that oc commands work. For example:

```bash
$ oc get pods -n openshift-ingress
NAME                              READY   STATUS    RESTARTS   AGE
router-default-66bd94dd4f-j4sjw   1/1     Running   0          117m
router-default-66bd94dd4f-nbhzp   1/1     Running   0          117m
```

Congratulations, your OpenShift cluster is up and running!


Auxiliary Resource Deployment
---------------------
After the OpenShift cluster has been deployed. Run the ocp-aux playbook to deploy the auxiliary components.


If it is an AWS deployed cluster, run this playbook.

```bash
$ ansible-playbook playbooks/ocp-aux/site.yml -e "deployment_number=$deploymentNumber" -i inventory_files/all.inv
```

Otherwise, run this playbook.


```bash
$ ansible-playbook playbooks/ocp-aux/site.yml
```


Post Resource Deployment
---------------------
After the OpenShift cluster has been deployed. Run the ocp-post playbook to deploy the post-installation configurations to OpenShift.


If it is an AWS deployed cluster, run this playbook.

```bash
$ ansible-playbook playbooks/ocp-post/site.yml -e "deployment_number=$deploymentNumber" -i inventory_files/all.inv
```


Once the playbook has completed. The cluster is ready to install Application sample on.


Appendix: Deploy All AWS OpenShift components from Bash Script
==============================
Run the following script

```bash
$ bash supportScripts/deployAWSOpenshift.sh $deploymentNumber
```