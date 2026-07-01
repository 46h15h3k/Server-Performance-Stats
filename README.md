# Server Stats

A shell script to analyse basic Linux server performance statistics.

---

## Features

- **OS & System Info** — distro, kernel version, hostname, architecture
- **Uptime & Load Average** — system uptime and 1m/5m/15m load averages
- **Logged In Users** — active sessions and total session count
- **CPU Usage** — used and idle percentage, core count
- **Memory Usage** — RAM used/free with percentage, swap usage
- **Disk Usage** — all non-tmpfs filesystems with size, used, available, and use%
- **Top 5 Processes by CPU** — PID, user, CPU%, MEM%, command
- **Top 5 Processes by Memory** — PID, user, MEM%, CPU%, command
- **Failed Login Attempts** — count and recent entries from system auth logs

---

## Requirements

- A Linux system (tested on Ubuntu, Debian, CentOS/RHEL)
- Bash 4+
- Standard tools: `ps`, `top`, `free`, `df`, `uptime`, `who`, `lastb` (optional, for failed logins)
- Root/sudo is **not required**, but some stats (e.g. failed login count via `lastb`) may need elevated privileges

---

## How to Run

**1. Clone the repository**

```bash
git clone https://github.com/46h15h3k/Server-Performance-Stats.git
cd Server-Performance-Stats
```

**2. Make the script executable**

```bash
chmod +x server-stats.sh
```

**3. Run it**

```bash
./server-stats.sh
```

For full failed-login stats, run with sudo:

```bash
sudo ./server-stats.sh
```

---

## Sample Output

```
────────────────────────────────────────────────────────
       SERVER PERFORMANCE STATS REPORT
       Generated: 2026-06-29 08:12:15 UTC
────────────────────────────────────────────────────────
▸ OS & SYSTEM INFO
  OS Version    : Amazon Linux 2023.12.20260622
  Kernel        : 6.18.35-68.127.amzn2023.x86_64
  Hostname      : ip-public.ap-south-1.compute.internal
  Architecture  : x86_64
────────────────────────────────────────────────────────
▸ UPTIME & LOAD AVERAGE
  Uptime        : up 1 hour, 20 minutes
  Load Average  : 0.00, 0.00, 0.00  (1m / 5m / 15m)
────────────────────────────────────────────────────────
▸ LOGGED IN USERS
  ec2-user     pts/0    2026-06-29 07:26
  ec2-user     pts/1    2026-06-29 08:10
  Total Sessions: 2
────────────────────────────────────────────────────────
▸ CPU USAGE
  CPU Used      : 6.2%
  CPU Idle      : 93.8%
  CPU Cores     : 1
────────────────────────────────────────────────────────
▸ MEMORY USAGE (RAM)
  Total         : 957 MB
  Used          : 182 MB  (19.0%)
  Free          : 217 MB
  Swap          : Not configured
────────────────────────────────────────────────────────
▸ DISK USAGE
  Filesystem           Size     Used     Avail    Use%
  /dev/xvda1           8.0G     1.8G     6.2G     23%
  /dev/xvda128         10M      1.3M     8.7M     13%
────────────────────────────────────────────────────────
▸ TOP 5 PROCESSES BY CPU USAGE
  PID      USER       CPU%   MEM%   COMMAND
  root     1          0.0    1.8    /usr/lib/systemd/systemd
  root     2          0.0    0.0    [kthreadd]
  root     3          0.0    0.0    [pool_workqueue_release]
  root     4          0.0    0.0    [kworker/R-rcu_gp]
  root     5          0.0    0.0    [kworker/R-sync_wq]
────────────────────────────────────────────────────────
▸ TOP 5 PROCESSES BY MEMORY USAGE
  PID      USER       MEM%   CPU%   COMMAND
  root     2761       3.2    0.0    /usr/bin/ssm-agent-worker
  root     2718       2.1    0.0    /usr/bin/amazon-ssm-agent
  root     1          1.8    0.0    /usr/lib/systemd/systemd
  systemd+ 2058       1.5    0.0    /usr/lib/systemd/systemd-resolved
  root     1360       1.5    0.0    /usr/lib/systemd/systemd-journald
────────────────────────────────────────────────────────
▸ FAILED LOGIN ATTEMPTS
  Failed Logins : 0 (all time, from /var/log/btmp)
  Recent Fails  :
────────────────────────────────────────────────────────
  ✔ Report complete.
────────────────────────────────────────────────────────
