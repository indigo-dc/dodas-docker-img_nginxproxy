#!/bin/sh

export TARGET_HOST_VAR="${PROXY_NAME}_TARGET_HOST"
TARGET_HOST=`dodas_get_target_ip $(dodas_cache --wait-for true zookeeper $TARGET_HOST_VAR)`
LOCAL_TARGET_HOST=$(cat /opt/dodas/proxy/target_ip)

if [ "$LOCAL_TARGET_HOST" == "$TARGET_HOST" ];
then
    exit 0 ;
else
    exit 1 ;
fi