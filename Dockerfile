# 使用较小的基础镜像
FROM ubuntu:22.04

# 设置环境变量，避免交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 更新系统并安装必要的软件包
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    vim supervisor sudo openssh-server iputils-ping net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 创建club用户并设置密码，同时将其加入sudo组
RUN useradd -m -s /bin/bash club \
    && echo "club:123456" | chpasswd \
    && usermod -aG sudo club

# 将当前目录的所有文件复制到容器的 /club 目录下
COPY ./club/bin /bin
COPY ./club/configs /club/configs
COPY ./club/entrypoint.sh /club/entrypoint.sh

# 设置工作目录
WORKDIR /root

# 设置执行权限
RUN chmod +x /club/entrypoint.sh

# 设置入口点
ENTRYPOINT ["/club/entrypoint.sh"]

# 设置默认命令
CMD ["/usr/bin/supervisord", "-n", "-c", "/root/supervisord/supervisord.conf"]
