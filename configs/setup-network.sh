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
ip link add name public-br type bridge
ip link add name private-br type bridge

# 2. Assign IP Addresses to Gateway Interfaces
echo "🌐 Assigning IP addresses to subnet gateways..."
ip addr add 10.0.1.1/24 dev public-br
ip addr add 10.0.2.1/24 dev private-br

# 3. Bring Interfaces UP
echo "🟢 Activating network interfaces..."
ip link set dev public-br up
ip link set dev private-br up

echo "✅ Network initialization complete!"
echo "--------------------------------------------------"
echo "📊 Current Bridge Status:"
ip addr show type bridge | grep -E '^\s*inet\s|\s[a-z0-9-]+-br:'
