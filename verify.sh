#!/usr/bin/env bash
# Verifies the OpenTimestamps proofs in forecasts/.
# Requires: pip install opentimestamps-client  (provides `ots`)
#
# Usage:
#   ./verify.sh                 check every proof in forecasts/
#   ./verify.sh FILE.json ...   check only these files
#   ./verify.sh --node ...      also run the full `ots verify` against your own
#                               Bitcoin Core node (bitcoind with RPC access)
#
# What each check proves:
#   HASH OK   the .json file is byte-for-byte the file the proof commits to
#             (its sha256 equals the digest inside the .ots).
#   BLOCK n   the proof is anchored in Bitcoin block n (as stated in the .ots).
#   VERIFIED  (--node only) your Bitcoin node confirmed the attestation, i.e.
#             the file existed no later than that block. Without a node you can
#             do the same on https://opentimestamps.org (drop the .ots, then the .json).
set -euo pipefail
cd "$(dirname "$0")"

node=0
if [ "${1:-}" = "--node" ]; then node=1; shift; fi

if [ "$#" -gt 0 ]; then
  files=("$@")
else
  files=(forecasts/*.json)
fi

ok=0; bad=0; pending=0; missing=0
if [ "${#files[@]}" -gt 50 ]; then
  echo "Checking ${#files[@]} files (a few minutes). To check one: ./verify.sh forecasts/FILE.json" >&2
fi
for src in "${files[@]}"; do
  ots_file="$src.ots"
  if [ ! -f "$ots_file" ]; then
    echo "NO PROOF     $src"; missing=$((missing+1)); continue
  fi
  info="$(ots info "$ots_file")"
  want="$(printf '%s\n' "$info" | sed -n 's/^File sha256 hash: //p' | head -1)"
  have="$(shasum -a 256 "$src" | cut -d' ' -f1)"
  if [ "$want" != "$have" ]; then
    echo "MISMATCH     $src  (file $have, proof $want)"; bad=$((bad+1)); continue
  fi
  blocks="$(printf '%s\n' "$info" | sed -n 's/.*BitcoinBlockHeaderAttestation(\([0-9]*\)).*/\1/p' | sort -un | tr '\n' ' ')"
  if [ -z "$blocks" ]; then
    echo "HASH OK      $src  pending (not yet in Bitcoin; ots upgrade $ots_file)"; pending=$((pending+1)); continue
  fi
  line="HASH OK      $src  BLOCK ${blocks% }"
  if [ "$node" -eq 1 ]; then
    if ots verify "$ots_file" >/dev/null 2>&1; then line="$line  VERIFIED"; else line="$line  NODE CHECK FAILED"; bad=$((bad+1)); fi
  fi
  echo "$line"; ok=$((ok+1))
done

echo
echo "Anchored and hash-matched: $ok   pending: $pending   mismatched/failed: $bad   missing proof: $missing"
if [ "$node" -eq 0 ]; then
  echo "Hash binding checked locally. For the Bitcoin check run with --node (needs bitcoind),"
  echo "or drop a .ots and its .json on https://opentimestamps.org."
fi
[ "$bad" -eq 0 ]
