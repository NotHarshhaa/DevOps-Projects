
[ec2-user@ip-10-0-1-203 ~]$ aws configure

[ec2-user@ip-10-0-1-203 ~]$ aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster
Added new context arn:aws:eks:us-east-1:503382476502:cluster/my-eks-cluster to /home/ec2-user/.kube/config

[ec2-user@ip-10-0-1-203 ~]$ kubectl get namespace
NAME              STATUS   AGE
default           Active   3h42m
kube-node-lease   Active   3h42m
kube-public       Active   3h42m
kube-system       Active   3h42m

[ec2-user@ip-10-0-1-203 ~]$ 
[ec2-user@ip-10-0-1-203 ~]$ kubectl get namespace
NAME              STATUS   AGE
default           Active   3h43m
eks-nginx-app     Active   11s
kube-node-lease   Active   3h43m
kube-public       Active   3h43m
kube-system       Active   3h43m
[ec2-user@ip-10-0-1-203 ~]$ 
[ec2-user@ip-10-0-1-203 ~]$ 
[ec2-user@ip-10-0-1-203 ~]$ kubectl get all -n eks-nginx-app
NAME                         READY   STATUS    RESTARTS   AGE
pod/nginx-7c5ddbdf54-jz5xh   1/1     Running   0          28s

NAME            TYPE           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)        AGE
service/nginx   LoadBalancer   10.100.146.242   ababb1d14ffe64d6e9ee1d7a7da9c92c-711131747.us-east-1.elb.amazonaws.com   80:30287/TCP   27s

NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   1/1     1            1           28s

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-7c5ddbdf54   1         1         1       28s
[ec2-user@ip-10-0-1-203 ~]$ 
