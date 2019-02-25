#!/usr/bin/env sh

echo "==> Check proxy endpoints"
if [ "$PROXY_FROM" == "UNDEFINED" ] || [ -z "$PROXY_FROM" ];
then
    echo "Error! Variable PROXY_FROM is not defined..." 1>&2
    exit 1
fi
if [ "$PROXY_TO" == "UNDEFINED" ] || [ -z "$PROXY_TO" ];
then
    echo "Error! Variable PROXY_TO is not defined..." 1>&2
    exit 1
fi

export TARGET_HOST_VAR="${PROXY_NAME}_TARGET_HOST"
echo "==> Check target ip of $TARGET_HOST_VAR"
export TARGET_HOST=`dodas_get_target_ip $(dodas_cache --wait-for true zookeeper $TARGET_HOST_VAR)`
echo "$TARGET_HOST" > /opt/dodas/proxy/target_ip
chmod go-rw /opt/dodas/proxy/target_ip

echo "==> Generate nginx configuration"
j2 /opt/dodas/proxy/nginx_template.j2 > /etc/nginx/nginx.conf

echo "==> Start nginx: [$PROXY_FROM:$TARGET_HOST:$PROXY_TO]"
exec nginx -g 'daemon off;'
