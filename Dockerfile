FROM alpine:latest

# Install NGINX
RUN apk add --no-cache nginx

# Python env for cache script
RUN apk add --no-cache python3 py3-requests py3-paramiko py3-psutil \
    && python3 -m ensurepip \
    && pip3 install --upgrade pip setuptools \
    && pip3 install j2cli kazoo

# Cache script
RUN mkdir -p /opt/dodas/cache \
    && mkdir -p /opt/dodas/health_checks \
    && mkdir -p /opt/dodas/proxy
COPY cache.py /opt/dodas/cache/
COPY get_target_ip.py /opt/dodas/cache/
COPY entrypoint.sh /opt/dodas/cache/
COPY nginx_template.j2 /opt/dodas/proxy/
COPY check_proxy_target_host.sh /opt/dodas/health_checks/
RUN ln -sf /opt/dodas/cache/cache.py /usr/local/bin/dodas_cache \
    && ln -sf /opt/dodas/cache/get_target_ip.py /usr/local/bin/dodas_get_target_ip \
    && ln -sf /opt/dodas/cache/entrypoint.sh /usr/local/bin/dodas_nginx_proxy \
    && ln -sf /opt/dodas/health_checks/check_proxy_target_host.sh /usr/local/bin/dodas_check_proxy_target_host

ENV PROXY_NAME="UNDEFINED"
ENV PROXY_FROM="UNDEFINED"
ENV PROXY_TO="UNDEFINED"

CMD ["/usr/local/bin/dodas_nginx_proxy"]
