FROM phusion/baseimage:master

CMD ["/sbin/my_init"]

RUN apt-get update && \
  apt-get install -y git && \
  apt-get install -y protobuf-compiler && \
  apt-get install -y wget && \
  wget -q https://mirrors.ustc.edu.cn/golang/go1.16.5.linux-amd64.tar.gz -O golang.tar.gz && \
  tar -C /usr/local -xf golang.tar.gz && \
  rm golang.tar.gz

ENV GOPATH /app
ENV GOROOT /usr/local/go
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:$PATH
ENV GO111MODULE auto
ENV GOPROXY https://goproxy.cn,direct

WORKDIR ${GOPATH}

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin && \
    chmod -R 777 ${GOPATH} && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest && \
    go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest && \
    go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest && \
    go install github.com/favadi/protoc-go-inject-tag@latest

# 在基础镜像 /etc/my_init.d/ 中的脚本会在容器启动时执行
COPY gen.sh /etc/my_init.d/gen.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
