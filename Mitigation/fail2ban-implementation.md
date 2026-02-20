# Mitigation with Fail2Ban

### Configuration
- maxretry = 5
- findtime = 10m
- bantime = 1h

### Validation
- Re-run controlled brute force
- Capture number of attempts before IP banned: 9
- Result: blocked
