#!/bin/bash
DNSPORT=5353
SSCONFIG=
SSSERVER=
/usr/sbin/pdnsd -d -mto -c /etc/pdnsd.conf
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports $DNSPORT

iptables -t nat -N SHADOWSOCKS

### IP for SS SERVER
iptables -t nat -A SHADOWSOCKS -d ${SSSERVER} -j RETURN ### IP for SS SERVER

iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN

iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/24 -j RETURN

iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports 1080
iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS

ss-redir -c ${SSCONFIG} -u
