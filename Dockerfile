# hadolint ignore=DL3007
FROM alpine:latest

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3018
RUN apk add --no-cache bash squid openssl \
    && ln -sf /dev/stdout /var/log/squid/access.log \
    && ln -sf /dev/stdout /var/log/squid/store.log \
    && ln -sf /dev/stdout /var/log/squid/cache.log

COPY --chown=squid:squid squid-deb-proxy.conf /etc/squid/squid.conf
COPY --chown=squid:squid extra-sources.acl /etc/squid/mirror-dstdomain.acl.d/20-extra-sources.acl
COPY entrypoint.sh /usr/local/bin/start-squid.sh

LABEL SERVICE_NAME="squid-deb-proxy"
LABEL SERVICE_TAGS="apt-proxy,apt-cache"

EXPOSE 8000/tcp

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/start-squid.sh"]