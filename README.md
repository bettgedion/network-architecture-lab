# 🌐 Automated Tri-Subnet DMZ & Secure Gateway Laboratory

An enterprise-ready, automated infrastructure environment deployed natively within Linux. This lab provisions fully isolated networking zones utilizing software bridges, configures stateful kernel firewalls via `iptables`, and provides built-in automated test suites using `netcat` to mathematically validate security boundary policies across a Public, Private, and DMZ segment layout.

---

## 🗺️ Architectural Topology

Our advanced topology splits network zones into distinct operational tiers to protect the internal data pipeline:

### Network Segment Matrix

| Zone Name | Network Address Space | Assigned Subnet Gateway | Configured Network Nodes |
| :--- | :--- | :--- | :--- |
| **🌐 Public Subnet** | `10.0.1.0/24` | `10.0.1.1` (`eth1`) | Web/Gateway Node (`10.0.1.10`) |
| **🔒 Private Subnet** | `10.0.2.0/24` | `10.0.2.1` (`eth2`) | Database Server (`10.0.2.50`) |
| **🛡️ DMZ Subnet** | `10.0.3.0/24` | `10.0.3.1` (`eth3`) | Reverse Proxy Server (`10.0.3.10`) |

---

## ⚙️ Core Infrastructure Automation

The entire environment is orchestrated dynamically via a single shell utility. 

### Provisioning Framework
The script **`configs/setup-network.sh`** automates our deployment tasks:
1. **Virtual Switches:** Allocates software bridge points (`public-br`, `private-br`, and `dmz-br`).
2. **Interface Identities:** Binds explicit CIDR-compliant gateway values to each switch.
3. **Boundary Firewall:** Enforces strict isolation rules—preventing both the Public space and the DMZ space from initiating unsolicited handshakes into the Private cluster.

```bash
sudo ./configs/setup-network.sh
```

---

## 🧪 Automated Testing & Verification

To confirm structural security policies, the test engine **`tests/verify-isolation.sh`** executes simulated packet injections using Netcat (`nc`) and records validation logs directly into the project workspace.

```bash
sudo ./tests/verify-isolation.sh
```

### Verified System Report Output
```text
🔍 Starting automated tri-subnet isolation tests...
--------------------------------------------------
📡 Test 1: Checking if Public Gateway (10.0.1.1) is online...
🟢 SUCCESS: Public subnet gateway is reachable.

🛡️ Test 2: Simulating unauthorized crossover from Public Subnet...
🔒 FIREWALL SECURE: Connection from public-br blocked cleanly by isolation policy.

🔒 Test 3: Simulating unauthorized crossover from DMZ Subnet...
👉 Attempting to connect from DMZ switch interface to private network...
🔒 FIREWALL SECURE: Connection from dmz-br blocked cleanly by kernel isolation policy.
🟢 TEST PASSED: DMZ segmentation is operating exactly as designed!
--------------------------------------------------
✅ Tri-Subnet verification complete.
```
