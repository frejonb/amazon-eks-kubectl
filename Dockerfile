FROM alpine:latest

ADD https://storage.googleapis.com/kubernetes-release/release/v1.15.2/bin/linux/amd64/kubectl /usr/local/bin/kubectl
ADD https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.4.0/aws-iam-authenticator_0.4.0_linux_amd64 /usr/local/bin/aws-iam-authenticator
ADD https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.5.4/kustomize_v3.5.4_linux_amd64.tar.gz /usr/local/bin/
ADD kubectl.sh /usr/local/bin/kubectl.sh

RUN set -x && \
    addgroup -g 2342 kubectl && \
    adduser -u 2342 -G kubectl -D kubectl && \
    \
    apk add --update --no-cache curl ca-certificates python py-pip jq tar && \
    chmod +x /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl.sh && \
    chmod +x /usr/local/bin/aws-iam-authenticator && \
    \
    # Install kustomize
    tar xzf /usr/local/bin/kustomize_v3.5.4_linux_amd64.tar.gz -C /usr/local/bin && \
    rm /usr/local/bin/kustomize_v3.5.4_linux_amd64.tar.gz && \
    \
    # Install AWS CLI
    pip install --upgrade awscli && \
    # Basic check it works.
    aws --version && kubectl version --client && kustomize version --short

ENTRYPOINT [ "/usr/local/bin/kubectl.sh" ]
