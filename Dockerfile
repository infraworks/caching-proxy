FROM debian:11.3

ENV DEBIAN_FRONTEND noninteractive

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends squid-deb-proxy squid-deb-proxy-client avahi-daemon avahi-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && ln -sf /dev/stdout /var/log/squid-deb-proxy/access.log \
    && ln -sf /dev/stdout /var/log/squid-deb-proxy/store.log \
    && ln -sf /dev/stdout /var/log/squid-deb-proxy/cache.log

COPY --chown=proxy:proxy squid-deb-proxy.conf /etc/squid-deb-proxy/squid-deb-proxy.conf
COPY --chown=proxy:proxy extra-sources.acl /etc/squid-deb-proxy/mirror-dstdomain.acl.d/20-extra-sources.acl
COPY entrypoint.sh /

LABEL SERVICE_NAME="squid-deb-proxy"
LABEL SERVICE_TAGS="apt-proxy,apt-cache"

EXPOSE 8000/tcp

ENTRYPOINT ["bash", "/entrypoint.sh"]