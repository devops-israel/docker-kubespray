FROM alpine:3.7

RUN apk --no-cache --update-cache add \
      libssl1.0 openssh-client \
      python3 ca-certificates git \
 && pip3 install -U pip boto boto3 botocore

ENV KUBESPRAY_VERSION master
# KUBESPRAY_VERSION v2.7.0 does not include Kubernetes v1.12.2 ATM
ENV ANSIBLE_VERSION v2.7.1

RUN git clone -b $KUBESPRAY_VERSION --single-branch --depth 1 \
      https://github.com/kubernetes-incubator/kubespray.git \
      /usr/local/share/kubespray
WORKDIR /usr/local/share/kubespray

RUN apk --no-cache --update-cache --virtual .build-deps add \
      gcc make python3-dev linux-headers musl-dev libffi-dev openssl-dev \
 && pip3 install git+https://github.com/ansible/ansible.git@$ANSIBLE_VERSION \
 && pip3 install -r requirements.txt \
 && apk del .build-deps
