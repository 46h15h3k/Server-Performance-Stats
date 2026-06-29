# Server Stats

A shell script to analyse basic Linux server performance statistics.

> 📌 Project page: [https://roadmap.sh/projects/server-stats](https://roadmap.sh/projects/server-stats)

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
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
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
       Generated: 2025-06-29 10:45:00 UTC
────────────────────────────────────────────────────────
▸ OS & SYSTEM INFO
  OS Version    : Ubuntu 22.04.3 LTS
  Kernel        : 5.15.0-91-generic
  Hostname      : my-server
  Architecture  : x86_64
────────────────────────────────────────────────────────
▸ UPTIME & LOAD AVERAGE
  Uptime        : up 5 days, 3 hours, 12 minutes
  Load Average  : 0.45, 0.38, 0.32  (1m / 5m / 15m)
...
```

---

## License

MIT
