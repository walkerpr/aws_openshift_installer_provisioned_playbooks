#!/bin/bash
deploymentNumber=$1

if [ $(basename "$PWD") != "cosmos_openshift" ]; then
  echo "Current directory is this: $(basename "$PWD")"
  echo "Please run from this directory: ocp4"
  exit 1
fi

function deploy_openshift {
  ansible-playbook playbooks/ocp-install/site.yml -e "deployment_number=$deploymentNumber" -i inventory_files/all.inv
  if [ $? != 0 ]; then
    exit 1
  fi
}

function deploy_aux {
  ansible-playbook playbooks/ocp-aux/site.yml -e "deployment_number=$deploymentNumber" -i inventory_files/all.inv
  if [ $? != 0 ]; then
    exit 1
  fi
}

function deploy_post {
  ansible-playbook playbooks/ocp-post/site.yml -e "deployment_number=$deploymentNumber" -i inventory_files/all.inv
  if [ $? != 0 ]; then
    exit 1
  fi
}

deploy_openshift
deploy_aux
deploy_post