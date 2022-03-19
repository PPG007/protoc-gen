#!/bin/bash

protoc -I ./proto/ --go_out=proto \
        --go-grpc_out=proto \
        --go_opt paths=source_relative \
        --go-grpc_opt paths=source_relative proto/*.proto
protoc-go-inject-tag -input="proto/*.pb.go"

if test -f proto/service.yml
then
    protoc -I ./proto/ --go_out=proto \
    --go-grpc_out=proto \
    --go_opt paths=source_relative \
    --go-grpc_opt paths=source_relative \
    --grpc-gateway_out=proto \
    --grpc-gateway_opt logtostderr=true \
    --grpc-gateway_opt paths=source_relative \
    --grpc-gateway_opt grpc_api_configuration=proto/service.yml \
    --openapiv2_opt grpc_api_configuration=proto/service.yml \
    --openapiv2_out=proto proto/*.proto
    protoc-go-inject-tag -input="proto/*.pb.go"
fi

for file in proto/*
do
    if test -f $file
    then
        echo skip $file
    else
        protoc -I ./proto/ --go_out=proto \
        --go-grpc_out=proto \
        --go_opt paths=source_relative \
        --go-grpc_opt paths=source_relative $file/*.proto

        if test -f $file/service.yml
        then
            protoc -I ./proto/ --go_out=proto \
            --go-grpc_out=proto \
            --go_opt paths=source_relative \
            --go-grpc_opt paths=source_relative \
            --grpc-gateway_out=proto \
            --grpc-gateway_opt logtostderr=true \
            --grpc-gateway_opt paths=source_relative \
            --grpc-gateway_opt grpc_api_configuration=$file/service.yml \
            --openapiv2_opt grpc_api_configuration=$file/service.yml \
            --openapiv2_out=proto $file/*.proto
        fi
        protoc-go-inject-tag -input="$file/*.pb.go"
    fi
done

echo "generated all stubs"
