FROM alpine:3.11.3

ADD https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl
ADD https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64 /usr/local/bin/aws-iam-authenticator
ADD https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.7/kustomize_v4.5.7_linux_amd64.tar.gz /usr/local/bin/
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
    tar xzf /usr/local/bin/kustomize_v4.5.7_linux_amd64.tar.gz -C /usr/local/bin && \
    rm /usr/local/bin/kustomize_v4.5.7_linux_amd64.tar.gz && \
    \
    # Install AWS CLI
    pip install --upgrade awscli && \
    # Basic check it works.
    aws --version && kubectl version --client && kustomize version --short

ENTRYPOINT [ "/usr/local/bin/kubectl.sh" ]
