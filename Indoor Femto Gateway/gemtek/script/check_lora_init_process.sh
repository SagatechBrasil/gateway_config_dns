#!/bin/sh

do_main() {
        now_lora=`ps w | grep -v grep | grep "lora_pkt_fwd"`
        now_gateway_brige=`ps w | grep -v grep | grep "chirpstack-gateway-bridge"`

        if [ "$now_gateway_brige" = "" ] ; then
                /etc/init.d/chirpstack-gateway-bridge start
        fi

        if [ "$now_lora" = "" ] ; then
                /etc/init.d/gtk_spilora.service0 start
        fi

        return 0
}

do_main
