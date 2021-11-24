#!/bin/bash
cd terraform

uri=$(terraform output | grep "k8s-master 1" | awk '{print $4;exit}')

kubectl=$(ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@$uri 'kubectl get nodes -o wide')

echo $kubectl

regex_master1='k8s-master-1.*?Ready'
regex_master2='k8s-master-2.*?Ready'
regex_master3='k8s-master-3.*?Ready'

regex_worker1='k8s-workers-1.*?Ready'
regex_worker2='k8s-workers-2.*?Ready'
regex_worker3='k8s-workers-3.*?Ready'

if [[$kubectl =~  $regex_master1 && $kubectl =~  $regex_master2 && $kubectl =~  $regex_master3 && $kubectl =~  $regex_worker1 && $kubectl =~  $regex_worker2 && $kubectl =~  $regex_worker3]]
then 
    echo "::::: Masters e workers no ar :::::"
    exit 0
else
    echo "::::: Masters e workers não estão no ar :::::"
    exit 1
fi