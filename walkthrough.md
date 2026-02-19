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
```
Expected:
PermitRootLogin no
PasswordAuthentication yes

## 2️⃣ Baseline Observation
Before attacking, check baseline failed logins:
```bash
grep "Failed password" /var/log/auth.log | wc -l
```
## 3️⃣ Clear Logs (Clean Slate)
Backup current logs:
```bash
sudo cp /var/log/auth.log /var/log/auth.log.bak
sudo cp /var/log/auth.log.1 /var/log/auth.log.1.bak
```
Clear current logs:
```bash
sudo truncate -s 0 /var/log/auth.log
sudo systemctl restart ssh
```
## 4️⃣ Run Controlled Brute Force
From attacker VM using Hydra:
```bash
hydra -l <target_user> -P <password_list.txt> ssh://<target_ip>
```
Capture:
First failed login timestamp
Last failed login timestamp
Successful login timestamp
Total failed attempts
Duration (seconds)
Average attempts per second
Store results in attack-analysis/attack-metrics.md and timeline.md.
## 5️⃣ Analyze Logs
Extract failed attempts:
```bash
grep "Failed password" /var/log/auth.log
```
Extract successful login:
```bash
grep "Accepted password" /var/log/auth.log
```
Compute metrics:
# Total failed attempts
```bash
grep "Failed password" /var/log/auth.log | wc -l
# Attempts per IP
grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -nr
```
Fill in attack-metrics.md and timeline.md with exact numbers.

## 6️⃣ Detection Script
Threshold-based detection:
```bash
#!/bin/bash
LOG="/var/log/auth.log"
THRESHOLD=10

grep "Failed password" $LOG | awk '{print $11}' | sort | uniq -c | while read count ip
do
    if [ $count -ge $THRESHOLD ]; then
        echo "[ALERT] Possible brute force from $ip ($count attempts)"
    fi
done
```
Adjust THRESHOLD based on your experiment
Test script to ensure alert triggers before successful login
Document logic in detection/detection-logic.md.

## 7️⃣ MITRE Mapping
T1110.001 – Password Guessing (attack method)
T1078 – Valid Accounts (successful login)
Write brief explanations in detection/detection-logic.md.


## 8️⃣ Mitigation With Fail2Ban

Install:
```bash
sudo apt update
sudo apt install fail2ban -y
```
Configure /etc/fail2ban/jail.local:
```
[sshd]
enabled = true
maxretry = 5
findtime = 600
bantime = 3600
```
Restart Fail2Ban:
```
sudo systemctl restart fail2ban
```
Re-run Hydra attack and document:
```
Number of attempts before IP banned
```
Whether successful login occurred
Fill in fail2ban-implementation.md.

## 9️⃣ SSH Hardening 
Disable password authentication:
```bash
sudo nano /etc/ssh/sshd_config
# PasswordAuthentication no
sudo systemctl restart ssh
```
Enforce SSH key login
Disable root login (already done)
Optional: change SSH port
Document outcomes in hardening-analysis.md.

## 10️⃣ Screenshots
Include:
Attack running in Hydra
Auth.log outputs
Detection script alert
Fail2Ban banning logs
Place screenshots in screenshots/ folder.

