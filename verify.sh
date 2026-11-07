#!/usr/bin/env bash
# Verifies every OpenTimestamps proof in forecasts/.
# Requires: pip install opentimestamps-client
set -euo pipefail
cd "$(dirname "$0")/forecasts"

fail=0
pending=0
for ots in *.ots; do
  src="${ots%.ots}"
  if [ ! -f "$src" ]; then
    echo "MISSING SOURCE: $src"; fail=1; continue
  fi
  echo "=== $src"
  # `ots info` prints the embedded Bitcoin block attestation(s); grep them out.
  blocks="$(ots info "$ots" | grep "BitcoinBlockHeaderAttestation" || true)"
  if [ -n "$blocks" ]; then
    echo "$blocks" | sed 's/^ */  anchored: /'
  else
    echo "  pending: not confirmed in Bitcoin yet (try: ots upgrade $ots)"; pending=$((pending+1))
  fi
done

echo
if [ "$fail" -eq 0 ]; then
  echo "Done. Proofs still pending Bitcoin confirmation: $pending"
  echo "For trustless verification against your own node: ots verify <file>.ots"
  echo "No node? On https://opentimestamps.org drop the .ots file first, then its .json"
else
  echo "Some proofs failed — see above."
  exit 1
fi
