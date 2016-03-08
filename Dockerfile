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
COPY go1.6.tar.gz /root/go1.6.tar.gz
  

# Set environment variables.
ENV HOME /root
ENV GOROOT /root/goroot
ENV GOPATH /root/gopath
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH

# Define working directory.
WORKDIR /root

RUN tar -xvf leanote.tar.gz && \
    tar -xvf mongodb.tgz && \
    tar -xvf go1.6.tar.gz -o /root/goroot
RUN ["/bin/bash", "-c", "mv /root/mongodb-linux-x86_64-ubuntu1404-2.7.8/bin/* /usr/local/bin/"]

# Clean
RUN rm leanote.tar.gz && \
    rm mongodb.tgz && \
    rm -rf mongodb*

# Run leanote.
CMD ["/bin/bash","/root/start.sh"]
# CMD ["bash"]
EXPOSE 9000
VOLUME ["/root/notedata","/var/log","/root/leanote/conf"]
