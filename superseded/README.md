# Superseded locks

Forecast objects that were hashed and timestamped but **never published** —
a chart-rendering fix was applied and the engine was re-run minutes later, so the
run that actually went out is the later one for the same day.

Kept, not deleted: a lock is evidence, and evidence you delete when it stops being
convenient is not evidence. Moved out of `data/ots/` so scoring sees exactly one
lock per symbol per day.

- `crypto-2026-07-20T232438Z-{BTC,ETH}USDT` → superseded by `...T232952Z-*`
