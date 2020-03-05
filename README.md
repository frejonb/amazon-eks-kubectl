# Amazon EKS kubectl

This is a convenient docker image that contains:

 - kubectl (v1.15.0)
 - aws-iam-authenticator (v0.4.0)
 - kustomize (v3.5.4)
 - AWS CLI (v1.16.213)

The default entrypoint for this container, is a small wrapper script for `kubectl` that automatically populates a `~/.kube/config` with the correct EKS cluster details (endpoint, certificate authority).

## Usage
### With AWS credentials
You can provide AWS credentials directly by providing environment variables to docker and passing the cluster name
```bash
docker run -e CLUSTER=demo -e AWS_DEFAULT_REGION=<REGION> \
    -e AWS_ACCESS_KEY_ID=<ACCESS_KEY_ID> -e AWS_SECRET_ACCESS_KEY=<SECRET_KEY> \
    fernandorejonbarrera/eks-kubectl:v1.0.0 kubectl get pods
```

### Without credentials
In case the container is running in k8s and you're using a `serviceAccount` for the pod, then you don't need to pass the `CLUSTER` env variable nor the AWS secrets.
