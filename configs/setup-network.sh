#!/bin/bash
# ==============================================================================
# Phase 2: Dual-Subnet Environment Automation Script
# Project: network-architecture-lab
# ==============================================================================

# Exit immediately if any command fails
set -e

# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Please run this script with sudo privileges."
  exit 1
fi

echo "🚀 Starting network environment initialization..."

# 1. Create Linux Virtual Bridges (Our Subnet Switches)
echo "📦 Creating virtual bridge interfaces..."
# The '|| true' statement tells Linux: "If this interface already exists, don't crash! Just skip and keep going."
ip link add name public-br type bridge || true
ip link add name private-br type bridge || true

# 2. Assign IP Addresses to Gateway Interfaces
echo "🌐 Assigning IP addresses to subnet gateways..."
# If the IP is already assigned, '|| true' prevents a crash
ip addr add 10.0.1.1/24 dev public-br || true
ip addr add 10.0.2.1/24 dev private-br || true

# 3. Bring Interfaces UP
echo "🟢 Activating network interfaces..."
ip link set dev public-br up
ip link set dev private-br up

# 4. Implement Firewall & Security Isolation Rules
echo "🛡️ Configuring firewall isolation policies..."
# Flush old forwarding rules to ensure a fresh, clean configuration slate
iptables -F FORWARD

# Rule A: Allow packets that belong to already established connections
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Rule B: Explicitly block the Public Subnet from initiating new connections into the Private Subnet
iptables -A FORWARD -i public-br -o private-br -m conntrack --ctstate NEW -j DROP

# Rule C: Permit the Private Subnet to communicate outward if necessary
iptables -A FORWARD -i private-br -j ACCEPT

echo "✅ Network initialization complete!"
echo "--------------------------------------------------"
echo "📊 Current Bridge Status:"
ip addr show type bridge | grep -E '^\s*inet\s|\s[a-z0-9-]+-br:'
