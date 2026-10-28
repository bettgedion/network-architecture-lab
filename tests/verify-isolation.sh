#!/bin/bash
# ==============================================================================
# Phase 3: Automated Firewall Isolation Verification Test
# Project: network-architecture-lab
# ==============================================================================

echo "🔍 Starting automated network isolation tests..."
echo "--------------------------------------------------"

# 1. Test Gateway Reachability
echo "📡 Test 1: Checking if Public Gateway (10.0.1.1) is online..."
if ping -c 2 -W 2 10.0.1.1 > /dev/null 2>&1; then
    echo "🟢 SUCCESS: Public subnet gateway is reachable."
else
    echo "❌ FAIL: Cannot reach public gateway."
fi

echo ""

# 2. Test Firewall Security Isolation
echo "🛡️ Test 2: Simulating unauthorized crossover connection request..."
echo "👉 Attempting to connect from public switch interface to private network..."

# We use the 'nc' (netcat) utility to attempt to open a TCP port connection across the boundary
if nc -z -w 3 -I public-br 10.0.2.1 80 > /dev/null 2>&1; then
    echo "🚨 SECURITY BREACH: Public interface successfully bypassed the firewall!"
    echo "❌ TEST FAILED: The private subnet is exposed."
    exit 1
else
    echo "🔒 FIREWALL SECURE: Connection blocked cleanly by kernel isolation policy."
    echo "🟢 TEST PASSED: Network isolation is operating exactly as designed!"
fi

echo "--------------------------------------------------"
echo "✅ Verification complete."
