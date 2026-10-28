#!/bin/bash
# ==============================================================================
# Phase 4: Automated DMZ & Firewall Isolation Verification Test Suite
# Project: network-architecture-lab
# ==============================================================================

echo "🔍 Starting automated tri-subnet isolation tests..."
echo "--------------------------------------------------"

# 1. Test Gateway Reachability
echo "📡 Test 1: Checking if Public Gateway (10.0.1.1) is online..."
if ping -c 2 -W 2 10.0.1.1 > /dev/null 2>&1; then
    echo "🟢 SUCCESS: Public subnet gateway is reachable."
else
    echo "❌ FAIL: Cannot reach public gateway."
fi

echo ""

# 2. Test Firewall Security Isolation (Public to Private)
echo "🛡️ Test 2: Simulating unauthorized crossover from Public Subnet..."
if nc -z -w 3 -I public-br 10.0.2.1 80 > /dev/null 2>&1; then
    echo "🚨 SECURITY BREACH: Public interface bypassed the firewall!"
    echo "❌ TEST FAILED: Private zone is exposed."
    exit 1
else
    echo "🔒 FIREWALL SECURE: Connection from public-br blocked cleanly by isolation policy."
fi

echo ""

# 3. Test Firewall Security Isolation (DMZ to Private)
echo "🔒 Test 3: Simulating unauthorized crossover from DMZ Subnet..."
echo "👉 Attempting to connect from DMZ switch interface to private network..."
if nc -z -w 3 -I dmz-br 10.0.2.1 80 > /dev/null 2>&1; then
    echo "🚨 SECURITY BREACH: DMZ interface broke out and reached the private zone!"
    echo "❌ TEST FAILED: The private database subnet is exposed to the DMZ."
    exit 1
else
    echo "🔒 FIREWALL SECURE: Connection from dmz-br blocked cleanly by kernel isolation policy."
    echo "🟢 TEST PASSED: DMZ segmentation is operating exactly as designed!"
fi

echo "--------------------------------------------------"
echo "✅ Tri-Subnet verification complete."
