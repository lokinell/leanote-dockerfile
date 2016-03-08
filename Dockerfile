#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:14.04
## use docker.cn
#FROM docker.cn/docker/ubuntu:latest
MAINTAINER lokiluo <lokinell@gmail.com>

# Install.
## use cn source
RUN \
  sed -i 's%/archive.ubuntu.com%/cn.archive.ubuntu.com%g' /etc/apt/sources.list && \ 
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y wget && \
  rm -rf /var/lib/apt/lists/*

# Add files.
COPY addUser.js /root/addUser.js
COPY start.sh /root/start.sh

COPY leanote.tar.gz /root/leanote.tar.gz
COPY mongodb.tgz /root/mongodb.tgz

# Set environment variables.
ENV HOME /root
ENV GOPATH /root/leanote/bin

# Define working directory.
WORKDIR /root

# Download leanote and mongodb.
#RUN wget http://downloads.sourceforge.net/project/leanote-bin/1.4.2/leanote-linux-amd64-v1.4.2.bin.tar.gz -O leanote.tar.gz && \
#    wget http://downloads.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-2.7.8.tgz -O mongodb.tgz
# Extract them.
RUN tar -xvf leanote.tar.gz && \
    tar -xvf mongodb.tgz
RUN ["/bin/bash", "-c", "mv /root/mongodb-linux-x86_64-ubuntu1404-2.7.8/bin/* /usr/local/bin/"]

# Clean
RUN rm leanote.tar.gz && \
    rm mongodb.tgz && \
    rm -rf mongodb*

# Run leanote.
CMD ["/bin/bash","/root/start.sh"]
# CMD ["bash"]
EXPOSE 80
VOLUME ["/root/notedata","/var/log","/root/leanote/conf"]
