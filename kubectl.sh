#!/bin/sh

if [ -n "$CLUSTER" ]; then

  # Write a ~/.kube/config file, using the AWS CLI to fetch the necessary parameters
  mkdir -p ~/.kube
  (cat > ~/.kube/config) <<EOF
apiVersion: v1
clusters:
- cluster:
    server: $(aws eks describe-cluster --name ${CLUSTER} | jq -r .cluster.endpoint) 
    certificate-authority-data: $(aws eks describe-cluster --name ${CLUSTER} | jq -r .cluster.certificateAuthority.data) 
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - ${CLUSTER}
EOF

fi

exec "$@"
