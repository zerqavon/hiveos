#!/usr/bin/env bash

log_base="${CUSTOM_LOG_BASENAME:-/var/log/miner/custom/zerqavon-miner}"
log_file="${log_base}.log"
status_line="$(grep -a '\[status\]' "$log_file" 2>/dev/null | tail -n 1 || true)"

hashrate="$(sed -n 's/.*\[status\] \([0-9.]*\) H\/s.*/\1/p' <<< "$status_line")"
accepted="$(sed -n 's/.*accepted \([0-9][0-9]*\).*/\1/p' <<< "$status_line")"
rejected="$(sed -n 's/.*rejected \([0-9][0-9]*\).*/\1/p' <<< "$status_line")"

[[ -z "$hashrate" ]] && hashrate=0
[[ -z "$accepted" ]] && accepted=0
[[ -z "$rejected" ]] && rejected=0

pid="$(pgrep -o -f '/zerqavon-miner([[:space:]]|$)' 2>/dev/null || true)"
uptime=0
[[ -n "$pid" ]] && uptime="$(ps -o etimes= -p "$pid" 2>/dev/null | tr -d ' ')"
[[ -z "$uptime" ]] && uptime=0

temperature="$(cpu-temp 2>/dev/null | head -n 1 | tr -dc '0-9.' || true)"
[[ -z "$temperature" ]] && temperature=null

khs="$(awk -v hs="$hashrate" 'BEGIN { printf "%.6f", hs / 1000 }')"
stats="$(printf \
    '{"hs":[%s],"hs_units":"hs","temp":[%s],"fan":[null],"uptime":%s,"ar":[%s,%s],"algo":"zqvxpow","ver":"1.0.5"}' \
    "$hashrate" "$temperature" "$uptime" "$accepted" "$rejected")"
