# ssr_server_client

> shadowsocks源码来源于https://github.com/shadowsocksrr/shadowsocksr shadowsocksr-3.2.2

使用步骤
1. 拉取代码
```shell script
git clone https://github.com/V7hinc/ssr_server_client.git
```
2.想要使用服务端(server)功能
> 修改[conf/ssr_server_config_sample.json](conf/ssr_server_config_sample.json)配置文件
```
"port_password":{
    "9999":"xxx",
    "8989":"xxx",
    "8080":"xxx"
},
# 键值对是  端口：密码
# 想开放多个端口就写多条
# 其他关于加密混淆方式的修改可以自行了解修改
```
3.想要使用客户端(client)功能
> 修改[conf/ssr_client_config_sample.json](conf/ssr_client_config_sample.json)配置文件
```
{
  "server": "你的ssr服务器ip",  # 填写你的ssr服务器ip
  "server_ipv6": "::",
  "local_address": "0.0.0.0",
  "local_port": 1080,         # 本地使用的端口，可不修改
  "server_port": 8989,        # 填写ssr服务端开放的端口
  "password": "xxx",          # 填写ssr服务端开放的端口对应的密码
# 需设置与ssr服务端相匹配的配置
# 加密方式需与服务端相匹配，否则将不能用
# 其他关于加密混淆方式的修改可以自行了解修改
```
4. 构建docker镜像
```shell script
docker build -t V7hinc/ssr_server_client .
# docker仓库https://hub.docker.com/r/v7hinc/ssr_server_client
```
4. 启动server端
```shell script
# 这里映射的端口需跟配置文件配置的端口相对应
docker run -p 9999:9999 -p 8989:8989 -p 8080:8080 --name ssr_server --restart=always -v /usr/local/shadowsocksr/conf -dit v7hinc/ssr_server_client server
```

5. 启动client端
```shell script
# 这里映射的端口需跟配置文件配置的端口相对应
docker run -p 1080:1080 --name ssr_client --restart=always -v /usr/local/shadowsocksr/conf -dit v7hinc/ssr_server_client client
```

6. 客户端测试
```shell script
curl ifconfig.me --socks 127.0.0.1:1080
# 如成功将显示服务端出口ip
```