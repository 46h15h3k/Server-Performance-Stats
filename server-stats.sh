#!/bin/bash

# ============================================================
#  server-stats.sh — Linux Server Performance Analyser
#  Project: https://roadmap.sh/projects/server-stats
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

divider() {
  echo -e "${CYAN}────────────────────────────────────────────────────────${RESET}"
}

header() {
  echo -e "${BOLD}${YELLOW}$1${RESET}"
}

divider
echo -e "${BOLD}${GREEN}       SERVER PERFORMANCE STATS REPORT${RESET}"
echo -e "       Generated: $(date '+%Y-%m-%d %H:%M:%S %Z')"
divider

# ── 1. OS & SYSTEM INFO ─────────────────────────────────────
header "▸ OS & SYSTEM INFO"
echo -e "  OS Version    : $(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' || uname -o)"
echo -e "  Kernel        : $(uname -r)"
echo -e "  Hostname      : $(hostname)"
echo -e "  Architecture  : $(uname -m)"
divider

# ── 2. UPTIME & LOAD AVERAGE ────────────────────────────────
header "▸ UPTIME & LOAD AVERAGE"
UPTIME_PRETTY=$(uptime -p 2>/dev/null || uptime)
LOAD=$(uptime | awk -F'load average:' '{print $2}' | xargs)
echo -e "  Uptime        : $UPTIME_PRETTY"
echo -e "  Load Average  : $LOAD  (1m / 5m / 15m)"
divider

# ── 3. LOGGED IN USERS ──────────────────────────────────────
header "▸ LOGGED IN USERS"
WHO_OUT=$(who 2>/dev/null)
if [ -z "$WHO_OUT" ]; then
  echo -e "  No users currently logged in."
else
  echo "$WHO_OUT" | awk '{printf "  %-12s %-8s %s %s\n", $1, $2, $3, $4}'
fi
echo -e "  Total Sessions: $(who | wc -l)"
divider

# ── 4. CPU USAGE ─────────────────────────────────────────────
header "▸ CPU USAGE"
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | tr -d '%id,')
# Fallback for different top formats
if [ -z "$CPU_IDLE" ]; then
  CPU_IDLE=$(top -bn1 | grep -i "cpu" | head -1 | grep -oP '\d+\.\d+\s*id' | awk '{print $1}')
fi
CPU_USED=$(echo "100 - ${CPU_IDLE:-0}" | bc 2>/dev/null || echo "N/A")
echo -e "  CPU Used      : ${CPU_USED}%"
echo -e "  CPU Idle      : ${CPU_IDLE}%"
echo -e "  CPU Cores     : $(nproc)"
divider

# ── 5. MEMORY USAGE ─────────────────────────────────────────
header "▸ MEMORY USAGE (RAM)"
MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
MEM_USED=$(free -m  | awk '/^Mem:/{print $3}')
MEM_FREE=$(free -m  | awk '/^Mem:/{print $4}')
MEM_PCT=$(awk "BEGIN {printf \"%.1f\", ($MEM_USED/$MEM_TOTAL)*100}")
echo -e "  Total         : ${MEM_TOTAL} MB"
echo -e "  Used          : ${MEM_USED} MB  (${MEM_PCT}%)"
echo -e "  Free          : ${MEM_FREE} MB"

SWAP_TOTAL=$(free -m | awk '/^Swap:/{print $2}')
SWAP_USED=$(free -m  | awk '/^Swap:/{print $3}')
if [ "$SWAP_TOTAL" -gt 0 ] 2>/dev/null; then
  SWAP_PCT=$(awk "BEGIN {printf \"%.1f\", ($SWAP_USED/$SWAP_TOTAL)*100}")
  echo -e "  Swap Used     : ${SWAP_USED} MB / ${SWAP_TOTAL} MB  (${SWAP_PCT}%)"
else
  echo -e "  Swap          : Not configured"
fi
divider

# ── 6. DISK USAGE ───────────────────────────────────────────
header "▸ DISK USAGE"
printf "  %-20s %-8s %-8s %-8s %-6s\n" "Filesystem" "Size" "Used" "Avail" "Use%"
df -h --output=source,size,used,avail,pcent 2>/dev/null | grep -v tmpfs | grep -v Filesystem | \
  awk '{printf "  %-20s %-8s %-8s %-8s %-6s\n", $1, $2, $3, $4, $5}'
divider

# ── 7. TOP 5 PROCESSES BY CPU ───────────────────────────────
header "▸ TOP 5 PROCESSES BY CPU USAGE"
printf "  %-8s %-10s %-6s %-6s %s\n" "PID" "USER" "CPU%" "MEM%" "COMMAND"
ps aux --sort=-%cpu 2>/dev/null | awk 'NR>1{printf "  %-8s %-10s %-6s %-6s %s\n", $1, $2, $3, $4, $11}' | head -5
divider

# ── 8. TOP 5 PROCESSES BY MEMORY ────────────────────────────
header "▸ TOP 5 PROCESSES BY MEMORY USAGE"
printf "  %-8s %-10s %-6s %-6s %s\n" "PID" "USER" "MEM%" "CPU%" "COMMAND"
ps aux --sort=-%mem 2>/dev/null | awk 'NR>1{printf "  %-8s %-10s %-6s %-6s %s\n", $1, $2, $4, $3, $11}' | head -5
divider

# ── 9. FAILED LOGIN ATTEMPTS ────────────────────────────────
header "▸ FAILED LOGIN ATTEMPTS"
if command -v lastb &>/dev/null && [ -f /var/log/btmp ]; then
  FAILED=$(lastb 2>/dev/null | grep -v "btmp begins" | wc -l)
  echo -e "  Failed Logins : $FAILED (all time, from /var/log/btmp)"
  echo -e "  Recent Fails  :"
  lastb 2>/dev/null | head -5 | awk '{printf "    %-12s %-8s %-20s %s %s %s\n", $1, $2, $3, $5, $6, $7}'
elif [ -f /var/log/auth.log ]; then
  FAILED=$(grep -c "Failed password" /var/log/auth.log 2>/dev/null || echo 0)
  echo -e "  Failed Logins : $FAILED (from /var/log/auth.log)"
elif [ -f /var/log/secure ]; then
  FAILED=$(grep -c "Failed password" /var/log/secure 2>/dev/null || echo 0)
  echo -e "  Failed Logins : $FAILED (from /var/log/secure)"
else
  echo -e "  ${YELLOW}No accessible auth log found (may need root).${RESET}"
fi
divider

echo -e "${BOLD}${GREEN}  ✔ Report complete.${RESET}"
divider
