# protoc-tool

```shell
docker run --rm --name protoc --mount type=bind,source=${your protofile abs path},target=/app/proto ppg007/protoc-gen:latest /sbin/my_init -- bash gen.sh
```
