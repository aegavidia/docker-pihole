#!/bin/bash
IP_LOOKUP="$(ip route get 9.9.9.9 | awk '{ print $NF; exit }')"  # May not work for VPN / tun0
IPv6_LOOKUP="$(ip -6 route get 2001:4860:4860::8888 | awk '{ print $10; exit }')"  # May not work for VPN / tu$
IP="${IP:-$IP_LOOKUP}"  # use $IP, if set, otherwise IP_LOOKUP
IPv6="${IPv6:-$IPv6_LOOKUP}"  # use $IPv6, if set, otherwise IP_LOOKUP
DOCKER_CONFIGS="$(pwd)"  # Default of directory you run this from, update to where ever.

echo "IP: ${IP} - IPv6: ${IPv6}"

# Default ports + daemonized docker container
docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp -p 80:80 \
    --network devnet \
    -v "${DOCKER_CONFIGS}/pihole/pihole/:/etc/pihole/" \
    -v "${DOCKER_CONFIGS}/pihole/dnsmasq.d/:/etc/dnsmasq.d/" \
    -e ServerIP="${IP:-$(ip route get 9.9.9.9 | awk '{ print $NF; exit }')}" \
    -e ServerIPv6="${IPv6:-$(ip -6 route get 2001:4860:4860::8888 | awk '{ print $10; exit }')}" \
    -e TZ="america/new_york" \
    -e DNS1="9.9.9.9" \
    --restart=always \
    diginc/pi-hole-multiarch:debian_armhf
