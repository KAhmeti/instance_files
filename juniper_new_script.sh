#!/bin/bash
#Juniper 2 script

ROUTER_IP="35.243.211.165"
SSH_USER="kastriot"
SSH_PRIVATE_KEY="/home/kastriot/.ssh/id_rsa"
INTERFACE="st0.x"
CLIENT_NAME="FILAN_FISTEKI"
REMOTE_END="X.X.X.X"
LOCAL_END="34.148.113.148"
PRESHARED_KEY="X"
LAN="X.X.X.X/X"
NAT="X.X.X.X/X"
RULE_1="X"
RULE_2="FILAN_FISTEKI"


ssh -i $SSH_PRIVATE_KEY $SSH_USER@$ROUTER_IP << EOF
configure

set interface $INTERFACE family inet filter input allow
set interface $INTERFACE family inet filter output allow

set security zones security-zone $CLIENT_NAME address-book address lan $LAN
set security zones security-zone $CLIENT_NAME system-services all
set security zones security-zone $CLIENT_NAME host-inbound-traffic system-services all
set security zones security-zone $CLIENT_NAME host-inbound-traffic protocols all
set security zones security-zone $CLIENT_NAME protocols all
set security zones security-zone $CLIENT_NAME interfaces $INTERFACE host-inbound-traffic system-services all

set routing-instances $CLIENT_NAME instance-type virtual-router routing-options static route $LAN next-hop $INTERFACE
set routing-instances $CLIENT_NAME instance-type virtual-router interface $INTERFACE

set security policies from-zone primary to-zone $CLIENT_NAME policy allow-all match source-address any destination-address any
set security policies from-zone primary to-zone $CLIENT_NAME policy allow-all match application any
set security policies from-zone primary to-zone $CLIENT_NAME policy allow-all then permit
set security policies from-zone $CLIENT_NAME to-zone primary policy allow-all match source-address any destination-address any
set security policies from-zone $CLIENT_NAME to-zone primary policy allow-all match application any
set security policies from-zone $CLIENT_NAME to-zone primary policy allow-all then permit

set security nat static rule-set me-to-all-clients rule $RULE_1 match destination-address $NAT
set security nat static rule-set me-to-all-clients rule $RULE_1 then static-nat prefix $LAN routing-instance $CLIENT_NAME
set security nat source pool KODE address 100.64.0.5/32
set security nat source rule-set juniper-to-$CLIENT_NAME from zone primary
set security nat source rule-set juniper-to-$CLIENT_NAME to zone $CLIENT_NAME
set security nat source rule-set juniper-to-$CLIENT_NAME rule primary-to-$CLIENT_NAME match destination-address $LAN
set security nat source rule-set juniper-to-$CLIENT_NAME rule primary-to-$CLIENT_NAME then source-nat pool KODE

set security ike proposal juniper-to-$CLIENT_NAME authentication-method pre-shared-keys dh-group group14 encryption-algorithm aes-256-gcm lifetime-seconds 28800
set security ike policy juniper-to-$CLIENT_NAME reauth-frequency 0 proposals juniper-to-$CLIENT_NAME pre-shared-key ascii-text $PRESHARED_KEY
set security ike gateway juniper-to-$CLIENT_NAME ike-policy juniper-to-$CLIENT_NAME address $REMOTE_END dead-peer-detection optimized interval 10 threshold 5
set security ike gateway juniper-to-$CLIENT_NAME local-identity inet $LOCAL_END
set security ike gateway juniper-to-$CLIENT_NAME remote-identity inet $REMOTE_END
set security ike gateway juniper-to-$CLIENT_NAME external-interface ge-0/0/0 local-address 172.20.254.21 version v2-only fragmentation size 576

set security ipsec proposal juniper-to-$CLIENT_NAME protocol esp authentication-algorithm hmac-sha-256-128 encryption-algorithm aes-256-cbc lifetime-seconds 3600
set security ipsec policy juniper-to-$CLIENT_NAME perfect-forward-secrecy keys group14
set security ipsec policy juniper-to-$CLIENT_NAME proposals juniper-to-$CLIENT_NAME
set security ipsec vpn juniper-to-$CLIENT_NAME bind-interface $INTERFACE df-bit clear copy-outer-dscp ike gateway juniper-to-$CLIENT_NAME ipsec-policy juniper-to-$CLIENT_NAME
set security ipsec vpn juniper-to-$CLIENT_NAME establish-tunnels immediately

commit check
EOF
