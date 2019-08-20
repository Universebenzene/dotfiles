#!/bin/bash
pkill pdnsd
iptables -t nat -F
iptables -t nat -X
