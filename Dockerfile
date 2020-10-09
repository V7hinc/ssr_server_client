# Dockerfile for ShadowsocksR based alpine
# Reference URL: https://github.com/shadowsocksrr/shadowsocksr shadowsocksr-3.2.2
# repositories URL: https://github.com/V7hinc/ssr_server_client

FROM python:3.7-alpine
MAINTAINER V7hinc

ENV INSTALL_PATH=/usr/local/shadowsocksr
ENV ssr_config_path=$INSTALL_PATH/conf
ENV autostart_shell=/autostart.sh

# 安装必要插件
RUN set -ex;\
apk add --no-cache jq;

COPY conf/ssr_client_config_sample.json $ssr_config_path/ssr_client_config.json
COPY conf/ssr_server_config_sample.json $ssr_config_path/ssr_server_config.json
COPY shadowsocks $INSTALL_PATH/shadowsocks


# 编写开机启动脚本
RUN set -x;\
echo "#!/bin/sh" >> $autostart_shell;\
# 开机选择开启server模式还是client模式
echo "ssr_client() {" >> $autostart_shell;\
echo "python $INSTALL_PATH/shadowsocks/local.py -d start -c $ssr_config_path/ssr_client_config.json --pid-file=$INSTALL_PATH/ssr.pid --log-file=$INSTALL_PATH/ssr.log" >> $autostart_shell;\
echo "}" >> $autostart_shell;\
echo "ssr_server() {" >> $autostart_shell;\
echo "python $INSTALL_PATH/shadowsocks/server.py -c $ssr_config_path/ssr_server_config.json" >> $autostart_shell;\
echo "}" >> $autostart_shell;\
echo "case \$1 in" >> $autostart_shell;\
echo "client) ssr_client ;;" >> $autostart_shell;\
echo "server) ssr_server ;;" >> $autostart_shell;\
echo "esac" >> $autostart_shell;\
# 保持前台
echo "/bin/sh;" >> $autostart_shell;\
chmod 755 $autostart_shell;

WORKDIR $ssr_config_path
VOLUME $ssr_config_path

EXPOSE 1080

ENTRYPOINT ["/autostart.sh"]
CMD ["server"]
