FROM shoothzj/base:go AS build
ENV CERT_MANAGER_HOME=/opt/cert-manager
WORKDIR /opt/cert-manager
RUN mkdir /opt/compile && \
    mkdir /opt/cert-manager && \
    cd /opt/compile && \
    git clone https://github.com/cert-manager/cert-manager.git -b v1.12.2 --depth=1 && \
    go mod tidy && \
    cd /opt/compile/cert-manager/cmd/webhook && \
    go mod tidy && \
    go build -o /opt/cert-manager/webhook . && \
    cd /opt/compile/cert-manager/cmd/ctl && \
    go mod tidy && \
    go build -o /opt/cert-manager/ctl && \
    cd /opt/compile/cert-manager/cmd/controller && \
    go mod tidy && \
    go build -o /opt/cert-manager/controller && \
    cd /opt/compile/cert-manager/cmd/cainjector && \
    go mod tidy && \
    go build -o /opt/cert-manager/cainjector && \
    cd /opt/compile/cert-manager/cmd/acmesolver && \
    go mod tidy && \
    go build -o /opt/cert-manager/acmesolver && \
    rm -rf /opt/compile

COPY docker-build /opt/cert-manager/mate

CMD ["/usr/bin/dumb-init", "bash", "-vx", "/opt/kafka/mate/scripts/start.sh"]
