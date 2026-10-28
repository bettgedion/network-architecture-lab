#!/bin/bash
# ==============================================================================
# Phase 4: Expanded DMZ Tri-Subnet Environment Automation Script
# Project: network-architecture-lab
# ==============================================================================

set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Please run this script with sudo privileges."
  exit 1
fi

echo "🚀 Starting network environment initialization (Tri-Subnet DMZ Mode)..."

# 1. Create Linux Virtual Bridges (Our Subnet Switches)
echo "📦 Creating virtual bridge interfaces..."
ip link add name public-br type bridge || true
ip link add name private-br type bridge || true
ip link add name dmz-br type bridge || true

# 2. Assign IP Addresses to Gateway Interfaces
echo "🌐 Assigning IP addresses to subnet gateways..."
ip addr add 10.0.1.1/24 dev public-br || true
ip addr add 10.0.2.1/24 dev private-br || true
ip addr add 10.0.3.1/24 dev dmz-br || true

# 3. Bring Interfaces UP
echo "🟢 Activating network interfaces..."
ip link set dev public-br up
ip link set dev private-br up
ip link set dev dmz-br up

# 4. Implement Firewall & Security Isolation Rules
echo "🛡️ Configuring firewall isolation policies..."
iptables -F FORWARD

# Rule A: Allow packets that belong to already established connections
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Rule B: Explicitly block the Public Subnet from initiating new connections into Private
iptables -A FORWARD -i public-br -o private-br -m conntrack --ctstate NEW -j DROP

# Rule C: Explicitly block the DMZ Subnet from initiating new connections into Private
iptables -A FORWARD -i dmz-br -o private-br -m conntrack --ctstate NEW -j DROP

# Rule D: Permit outbound communication from internal segments if necessary
iptables -A FORWARD -i private-br -j ACCEPT
iptables -A FORWARD -i dmz-br -j ACCEPT

echo "✅ Network initialization complete!"
echo "--------------------------------------------------"
echo "📊 Current Bridge Status:"
ip addr show type bridge | grep -E '^\s*inet\s|\s[a-z0-9-]+-br:'
