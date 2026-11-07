#!/usr/bin/env bash
# CCDC pitlane read-only audit. Review and test before use.
set -u
OUT="${HOME}/pitlane-audit-$(date +%Y%m%d-%H%M%S).txt"
{
echo '=== HOST ==='; date -Is; hostname; id; ip -br addr
 echo '=== SSH ==='; systemctl status ssh --no-pager || true; ss -tlnp || true; sshd -t 2>&1 || true
 echo '=== ACCOUNTS ==='; getent passwd; getent group sudo; who; w; last -n 15 || true
 echo '=== PROCESSES AND CONNECTIONS ==='; ps auxf; ss -tunap || true
 echo '=== PERSISTENCE ==='; systemctl --failed; systemctl list-timers --all; ls -la /etc/cron.d /etc/cron.daily 2>&1
 echo '=== FIREWALL ==='; command -v ufw >/dev/null && ufw status verbose; command -v nft >/dev/null && nft list ruleset; command -v iptables >/dev/null && iptables -S
 echo '=== RECENT SSH LOGS ==='; journalctl -u ssh -n 80 --no-pager || true
} > "$OUT" 2>&1
chmod 600 "$OUT"
echo "Audit saved: $OUT (may contain sensitive system information; keep on authorized infrastructure)"
