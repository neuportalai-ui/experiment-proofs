#!/usr/bin/env bash
# Verifies every OpenTimestamps proof in forecasts/.
# Requires: pip install opentimestamps-client
set -euo pipefail
cd "$(dirname "$0")/forecasts"

fail=0
for ots in *.ots; do
  src="${ots%.ots}"
  if [ ! -f "$src" ]; then
    echo "MISSING SOURCE: $src"; fail=1; continue
  fi
  echo "=== $src"
  # `ots info` prints the embedded Bitcoin block attestation(s); grep them out.
  if ots info "$ots" | grep -q "BitcoinBlockHeaderAttestation"; then
    ots info "$ots" | grep "BitcoinBlockHeaderAttestation" | sed 's/^ */  anchored: /'
  else
    echo "  NO BITCOIN ATTESTATION EMBEDDED (run: ots upgrade $ots)"; fail=1
  fi
done

echo
if [ "$fail" -eq 0 ]; then
  echo "All proofs carry embedded Bitcoin block attestations."
  echo "For trustless verification against your own node: ots verify <file>.ots"
  echo "No node? Drag the .json + .json.ots pair into https://opentimestamps.org"
else
  echo "Some proofs failed — see above."
  exit 1
fi
