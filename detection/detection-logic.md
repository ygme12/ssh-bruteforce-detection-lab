# Detection Logic

### Goal
Detect SSH brute force attempts before account compromise.

### Log Source
/var/log/auth.log

### Detection Rule
- Alert if ≥ 10 failed attempts from same IP targeting same user within 8 seconds

### Justification
- Based on controlled experiment metrics: total failures and attack rate 7 attempts/sec

### MITRE ATT&CK Mapping
- T1110.001 – Password Guessing
- T1078 – Valid Accounts
