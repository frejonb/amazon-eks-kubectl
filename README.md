# Amazon EKS kubectl

This is a convenient docker image that contains:

 - kubectl (v1.13.0)
 - aws-iam-authenticator (v0.4.0)
 - AWS CLI (v1.16.212)

The default entrypoint for this container, is a small wrapper script for `kubectl` that automatically populates a `~/.kube/config` with the correct EKS cluster details (endpoint, certificate authority).

## Usage

```bash
$ docker run -e CLUSTER=demo fernandorejonbarrera/eks-kubectl:v1.0.0 kubectl version
Client Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.0", GitCommit:"ddf47ac13c1a9483ea035a79cd7c10005ff21a6d", GitTreeState:"clean", BuildDate:"2018-12-03T21:04:45Z", GoVersion:"go1.11.2", Compiler:"gc", Platform:"linux/amd64"}
```

You can also provide AWS credentials directly by providing environment variables to docker
```bash
docker run -e CLUSTER=demo -e AWS_DEFAULT_REGION=<REGION> \
    -e AWS_ACCESS_KEY_ID=<ACCESS_KEY_ID> -e AWS_SECRET_ACCESS_KEY=<SECRET_KEY> \
    fernandorejonbarrera/eks-kubectl:v1.0.0 kubectl get pods
```

## AWS Credentials

The kubectl wrapper script used by this container uses the AWS CLI to fetch the necessary cluster details for the kube config file (api endpoint, certificate authority etc). 

The AWS CLI will automatically pick up AWS credentials from environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_SESSION_TOKEN`), the AWS credentials file (`~/.aws/credentials`), container credentials (ECS role) or EC2 instance role (in that order).

If you already have AWS credentials configured in `~/.aws/credentials` you can pass these through by running:

```
$ docker run -v ~/.aws:/home/kubectl/.aws -e CLUSTER=demo maddox/kubectl get services
```

