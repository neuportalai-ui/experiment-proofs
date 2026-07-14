# NeuPortal Experiment — Public Proofs

Raw, verifiable evidence for the [NeuPortal forecast experiment](https://neuportal.ai/experiment): our AI's football probabilities are **locked before every match, hashed into Bitcoin via [OpenTimestamps](https://opentimestamps.org), and Brier-scored against the prediction-market price** frozen at the same instant. Wins and losses both stay on the board.

This repo exists so you can check us **without trusting us**.

## What's in here

```
forecasts/
  call-<match>-<locked-at>.json       ← the forecast exactly as locked (probabilities + timestamp)
  call-<match>-<locked-at>.json.ots   ← OpenTimestamps proof anchoring that file into Bitcoin
  baseline-2026-07-03.json(.ots)      ← first batch of calls (matches of Jul 2–4), stamped together
verify.sh                             ← loops over every proof and verifies it
```

Each `.json` is the original stamped artifact — byte-for-byte. Modifying a single character breaks its proof. The `.ots` files are **upgraded** (Bitcoin block attestations embedded), so verification does not depend on any server being online — only on the Bitcoin blockchain.

## Verify it yourself

**Option A — no install (30 seconds):** go to [opentimestamps.org](https://opentimestamps.org), drag in any `.json` file and its `.ots` file. You'll get: *"Bitcoin attests data existed as of block N"* — with the block's date. Compare that date to the match kickoff.

**Option B — command line:**

```bash
pip install opentimestamps-client
ots info forecasts/call-paraguay-france-2026-07-04T093933089Z.json.ots
# → verify BitcoinBlockHeaderAttestation(956639)  ← the Bitcoin block that anchors this forecast
```

`ots info` shows the attested block height and the exact hash path. For fully trustless verification (`ots verify`), point the client at any Bitcoin node you trust — the attestation is an ordinary Merkle path into a block header.

**What you are checking:** the file containing our probabilities existed **before** the block timestamp — and therefore before kickoff. Nobody, including us, can backdate into Bitcoin.

## The scoring rules (committed before the first result)

- One forecast per match, locked pre-kickoff. Revisions are allowed but never hidden — every earlier call keeps its own stamp and the public board shows the revision count. **Current revision count: 0.**
- Benchmark = Polymarket price snapshot taken at (or immediately before) the moment our call locked — never after.
- Metric = 3-outcome Brier score (home/draw/away), lower is better. Scored only when the market resolves.
- Every result is published — there is no delete button.

## Scoreboard as of 2026-07-14 (15 matches)

| Date | Match | Model H/D/A % | Market H/D/A % | Result | Brier model | Brier market |
|---|---|---|---|---|---|---|
| 2026-07-02 | Spain – Austria | 64 / 22 / 14 | 76 / 17 / 7 | home | 0.201 | 0.089 |
| 2026-07-03 | Australia – Egypt | 37 / 30 / 34 | 26 / 33 / 40 | draw | 0.746 | 0.676 |
| 2026-07-03 | Argentina – Cabo Verde | 68 / 22 / 9 | 86 / 10 / 4 | draw | 1.077 | 1.540 |
| 2026-07-04 | Canada – Morocco | 25 / 29 / 46 | 18 / 29 / 54 | away | 0.445 | 0.327 |
| 2026-07-04 | Paraguay – France | 11 / 22 / 68 | 4 / 12 / 83 | away | 0.162 | 0.046 |
| 2026-07-05 | Brazil – Norway | 49 / 27 / 25 | 54 / 26 / 19 | away | 0.875 | 1.013 |
| 2026-07-06 | Mexico – England | 37 / 31 / 32 | 30 / 31 / 40 | away | 0.696 | 0.545 |
| 2026-07-06 | Portugal – Spain | 22 / 27 / 51 | 22 / 26 / 51 | away | 0.358 | 0.357 |
| 2026-07-07 | United States – Belgium | 32 / 28 / 40 | 38 / 27 / 34 | away | 0.546 | 0.653 |
| 2026-07-07 | Argentina – Egypt | 60 / 24 / 16 | 72 / 19 / 8 | home | 0.241 | 0.122 |
| 2026-07-07 | Switzerland – Colombia | 30 / 32 / 38 | 26 / 31 / 42 | draw | 0.693 | 0.720 |
| 2026-07-09 | France – Morocco | 56 / 25 / 19 | 62 / 25 / 14 | home | 0.288 | 0.225 |
| 2026-07-10 | Spain – Belgium | 55 / 24 / 21 | 59 / 24 / 17 | home | 0.304 | 0.250 |
| 2026-07-11 | Norway – England | 29 / 22 / 49 | 24 / 25 / 50 | draw | 0.935 | 0.866 |
| 2026-07-12 | Argentina – Switzerland | 54 / 25 / 22 | 57 / 27 / 16 | draw | 0.906 | 0.893 |

**Running result: the market is ahead 11–4 on head-to-head Brier, and ahead on average Brier too — 0.555 vs 0.565.** The model's four wins all came on nights the consensus favourite failed (two draws, two upsets); the market took the other eleven when the script held. We are behind on both counts, and it stays on the board — the point isn't to claim we beat an efficient market, it's to make exactly how often we don't impossible to hide. Live board: [neuportal.ai/experiment](https://neuportal.ai/experiment)

## Proof layers beyond this repo

1. **Platform timestamps** — every call is also posted to X and Telegram before kickoff (links on the live board).
2. **Wayback Machine** — the public board is archived after each update.
3. **Bitcoin** — the stamps in this repo.

Found a hole in the protocol? Open an issue. That's what this repo is for.

---

*NeuPortal is an educational transparency project about forecasting and prediction markets — not betting advice, not financial advice.*
