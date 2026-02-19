# SSH Brute Force Detection Walkthrough

This walkthrough demonstrates a controlled SSH brute force attack, log analysis, detection, and mitigation on Ubuntu Server. Follow each step carefully.

---

## 1️⃣ Environment Setup

1. **Ubuntu Server** (target)
2. **Attacker VM** (Hydra installed)
3. **Fail2Ban** (for mitigation)

Check SSH configuration:

```bash
sudo cat /etc/ssh/sshd_config | grep -E 'PermitRootLogin|PasswordAuthentication'
