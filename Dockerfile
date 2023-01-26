# syntax=docker/dockerfile:1.4
FROM amazonlinux:2022 as ruby
ARG RUBY_VERSION=2.6.8
WORKDIR /tmp
RUN set -x; 
RUN yum install -y patch bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel wget tar gzip perl gcc cmake
RUN  wget -O rb.tgz https://github.com/rbenv/ruby-build/archive/refs/tags/v20221225.tar.gz && \
  tar xvfz rb.tgz && PREFIX=/usr/local ./ruby-build-*/install.sh && \
  ruby-build $RUBY_VERSION /usr/local/ruby-${RUBY_VERSION} && \
  ln -sfv /usr/local/ruby-${RUBY_VERSION}/bin/ruby /usr/bin/ruby
