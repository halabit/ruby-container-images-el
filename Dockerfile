# syntax=docker/dockerfile:1.4
ARG IMAGE
FROM $IMAGE as build
ARG RUBY_VERSION
ARG RUBY_CONFIGURE_OPTS="--with-jemalloc --disable-install-doc"
WORKDIR /tmp
RUN set -x; \
    yum install -y yum-utils epel-release && \
    (for r in powertools crb; do yum config-manager --enable $r; done || true) && \
    yum install -y git-core patch bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel wget tar gzip gcc gcc-c++ cmake perl rust jemalloc-devel && \
    yum clean all
RUN git clone https://github.com/rbenv/ruby-build.git && \
    ./ruby-build/install.sh && \
    ruby-build --verbose $RUBY_VERSION /usr/local/ruby && \
    ln -sfv /usr/local/ruby/bin/ruby /usr/bin/ruby


ARG IMAGE
FROM $IMAGE
COPY --from=build --link /usr/lib64/libjemalloc.so.2 /usr/lib64/
COPY --from=build --link /usr/local/ruby/ /usr/local/ruby/
ENV PATH="/usr/local/ruby/bin:${PATH}"
RUN ln -sfv /usr/local/ruby/bin/ruby /usr/bin/ruby && \
    (test -d /usr/local/ruby/openssl/lib/ && echo "/usr/local/ruby/openssl/lib/" > /etc/ld.so.conf.d/ruby.conf); \
    ldconfig -v && \
    ruby -v
