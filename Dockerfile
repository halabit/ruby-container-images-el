# syntax=docker/dockerfile:1.4
ARG IMAGE
FROM $IMAGE as build
ARG RUBY_VERSION=2.6.8
WORKDIR /tmp
RUN set -x; \
    yum install -y yum-utils && \
    (for r in powertools crb; do yum config-manager --enable $r; done || true) && \
    yum install -y git-core patch bzip2 openssl-devel jemalloc-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel wget tar gzip perl gcc gcc-c++ cmake && \
    yum clean all
RUN git clone https://github.com/rbenv/ruby-build.git && \
    ./ruby-build/install.sh && \
    RUBY_CONFIGURE_OPTS=--with-jemalloc ruby-build --verbose $RUBY_VERSION /usr/local/ruby && \
    ln -sfv /usr/local/ruby/bin/ruby /usr/bin/ruby


ARG IMAGE
FROM $IMAGE
COPY --from=build --link /usr/local/ruby/ /usr/local/ruby/
ENV PATH="/usr/local/ruby/bin:${PATH}"
RUN ln -sfv /usr/local/ruby/bin/ruby /usr/bin/ruby && \
    echo "/usr/local/ruby/openssl/lib/" > /etc/ld.so.conf.d/ruby.conf && \
    ldconfig -v && \
    ruby -v
