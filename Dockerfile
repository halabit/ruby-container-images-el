# syntax=docker/dockerfile:1.4
ARG IMAGE
FROM $IMAGE as build
ARG RUBY_VERSION
WORKDIR /tmp
RUN set -x; \
    yum install -y yum-utils && \
    (for r in powertools crb; do yum config-manager --enable $r; done || true) && \
    yum install -y git-core patch bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel wget tar gzip gcc gcc-c++ cmake epel-release perl && \
    yum install -y jemalloc-devel && \
    yum clean all
RUN git clone https://github.com/rbenv/ruby-build.git && \
    ./ruby-build/install.sh && \
    RUBY_CONFIGURE_OPTS="--enable-static --disable-shared --with-jemalloc --disable-install-doc" ruby-build --verbose $RUBY_VERSION /usr/local/ruby && \
    ln -sfv /usr/local/ruby/bin/ruby /usr/bin/ruby


ARG IMAGE
FROM $IMAGE
COPY --from=build --link /usr/lib64/libjemalloc.so.2 /usr/lib64/
COPY --from=build --link /usr/local/ruby/ /usr/local/ruby/
ENV PATH="/usr/local/ruby/bin:${PATH}"
RUN ln -sfv /usr/local/ruby/bin/ruby /usr/bin/ruby && \
    ldconfig -v && \
    ruby -v
