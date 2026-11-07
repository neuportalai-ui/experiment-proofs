# Void: duplicate crypto set of 24.10.2026 (08:21:33 UTC)

This set of 23 symbols × 3 horizons was sealed by mistake. The daily ledger run had already sealed
the day's official set at 08:15:52 UTC (`data/ots/crypto-2026-10-24T081552Z-*`), and that set is
the one published on the platform (69 forecasts at 08:15). While fixing the Polymarket data source,
the full ledger was run a second time by hand, which sealed this second set at 08:21:33 UTC. Its
publish step was stopped before it reached the platform.

The ledger exists so that no day can have two sealed sets to choose from afterwards. So this set
is **void**: it is not published, not scored and not used by any card or indicator. It is kept, not
deleted, with its OpenTimestamps receipts, so that anyone can verify both what happened and that
the official set was sealed first. Moved here on 24.10.2026.
