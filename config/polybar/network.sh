#!/bin/sh

get_ip() {
    /usr/sbin/ifconfig $1 | grep "inet " | awk '{print $2}'
}

IFACE=$(ifconfig | grep -E '^(tun0)' | awk '{print $1}' | tr -d ':')

if [ "$IFACE" = "tun0" ]; then
    IP=$(get_ip tun0)
    echo "%{F#9ccfd8}󰆧 %{F#e0def4}$IP"
else
    IFACE=$(ifconfig | grep -E '^(e|en|eth|w|wl|wlan)' | awk '{print $1}' | tr -d ':' | head -n 1)
    if [ -n "$IFACE" ]; then
        IP=$(get_ip $IFACE)
        echo "%{F#9ccfd8}  %{F#e0def4}$IP"
    else
        echo "%{F#9ccfd8}  %{u-}%{F#e0def4}Disconnected"
    fi
fi

