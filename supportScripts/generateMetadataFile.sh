export CLUSTER_NAME="$1"
export INFRA_ID="$2"
export AWS_REGION="us-gov-west-2"
cat <<EOF > metadata.json
{
"clusterName":"${CLUSTER_NAME}",
"clusterID":"",
"infraID":"${INFRA_ID}",
"aws":{
    "region":"${AWS_REGION}",
    "identifier":[
        {"kubernetes.io/cluster/${CLUSTER_NAME}-${INFRA_ID}":"owned"}
    ]
}
}
EOF

aws s3 cp metadata.json s3://sample-361925695366-openshift/deployment$1/cluster/ --region us-gov-west-1