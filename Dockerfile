# syntax=docker/dockerfile:1.4
ARG IMAGE
FROM $IMAGE as ruby
ARG RUBY_VERSION=2.6.8
WORKDIR /tmp
RUN set -x; \
    yum install -y yum-utils && \
    (for r in powertools crb; do yum config-manager --enable $r; done || true) && \
    yum install -y patch bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel wget tar gzip perl gcc gcc-c++ cmake && \
    yum clean all
RUN  wget -O rb.tgz https://github.com/rbenv/ruby-build/archive/refs/tags/v20221225.tar.gz && \
  tar xvfz rb.tgz && PREFIX=/usr/local ./ruby-build-*/install.sh && \
  ruby-build --verbose $RUBY_VERSION /usr/local/ruby && \
  ln -sfv /usr/local/ruby/bin/ruby /usr/bin/ruby
