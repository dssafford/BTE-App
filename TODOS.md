# TODOS

Captured during /plan-eng-review on 2026-04-24.

---

## 1. `.apkg` import via anki-apkg-parse

**What:** Add `.apkg` import path alongside the generic JSON importer.

**Why:** Unlocks the massive library of existing Anki decks without manual authoring. Becomes a serious proof point that the app is not a toy.

**Pros:** Instant content library, social proof ("works with Anki decks" = credible SRS tool), enables sharing with friends who already use Anki.

**Cons:** Anki's `.apkg` format has peculiarities — media files, image-occlusion card types, nested decks. Some edge cases will need careful handling.

**Context:** Mentioned in the design doc's Cross-Model Perspective section (subagent's 50% foundation suggestion). Deferred from Phase 1 scope because not load-bearing for personal dogfooding.

**Depends on:** Generic JSON importer (Step 0 Issue 0B). Alembic cards/decks schema (Phase 1).

**Trigger:** Post-Phase 3 validation, or when you want to share the app with a friend who has Anki decks.

---

## 2. FSRS per-deck retention tuning

**What:** Expose `ts-fsrs` retention target and difficulty weight as per-deck (or per-user) settings.

**Why:** Different subjects deserve different retention. Behavioral profiles might want 95% retention (precision matters). Spanish conversational might be fine at 85% (fluency is partial anyway). Defaults are reasonable but not universally right.

**Pros:** Personalization. Respects the "cognitive fitness" framing — you're tuning your own practice, not accepting a one-size-fits-all algorithm.

**Cons:** One more settings surface. Users may tweak to feel in control without understanding the tradeoffs.

**Context:** Design doc Open Question #3. `ts-fsrs` supports this natively via constructor options.

**Depends on:** Phase 1 FSRS wrapper ships with defaults first.

**Trigger:** After 30+ days of real use, when you have opinions about specific decks needing different review cadence.

---

## 3. Event log snapshot / incremental FSRS state

**What:** When `review_events` grows past ~5000 entries OR page load exceeds 1 second, implement client-side FSRS state snapshot in IndexedDB. Incremental recompute from last snapshot + new events only.

**Why:** The current "fetch-and-recompute on every page load" (Issue 1B decision) is correct for current scale but will slow down as the event log grows over years. This is a multi-year cognitive practice app — the data grows monotonically forever.

**Pros:** Keeps page load fast. Enables offline mode as a side-effect (snapshot is local).

**Cons:** Cache invalidation is the classic hard problem. Adds complexity to a currently simple client.

**Context:** Outside voice (plan review subagent) flagged this as "a cost bomb the eng review waved through." Deferred deliberately — YAGNI for now.

**Depends on:** Phase 1 FSRS wrapper shipped with fetch-and-recompute.

**Trigger:** `review_events` row count > 5000 OR measured page load > 1s. Worth instrumenting a simple row count check in the weekly digest so you notice when the trigger fires.

---

## 4. Self-rated match strategy

**What:** Add `'self_rated'` as a fourth value in the `decks.match_strategy` enum. Cards with this strategy skip typed-answer matching entirely — the UI shows the prompt, the user thinks their answer silently, taps "reveal," then self-rates with Rating.Good / Rating.Again (same model as `/walk` mode).

**Why:** Some content doesn't fit one-line fuzzy matching. SEAL leadership frameworks (e.g., "What are the 4 Laws of Combat?" — answer is an ordered list with commentary) lose their meaning when forced into a one-line string. Anki's whole model is self-rating; it works for long-form content because the user is the judge, not a string comparator.

**Pros:** Unlocks long-form answers. Matches how people actually review complex frameworks. Same rating model already exists in `/walk`, so the code reuse is real.

**Cons:** Self-rating is less objective than fuzzy matching — users can rationalize "I basically knew it" for answers they actually didn't. Less honest signal in the cognitive-fitness data.

**Context:** Deck #2 (Navy SEAL Leadership Principles) ships with match_strategy='fuzzy' + one-line answers for v1. Some content WILL be awkwardly compressed. When the builder starts wishing for richer answers, this is the feature.

**Depends on:** Phase 1 ships with exact/fuzzy/multi_choice. Adding 'self_rated' is schema extension + new UI flow in /study/[deckId].

**Trigger:** Post-Phase 3 validation, OR any moment builder opens a SEAL card and thinks "this answer is wrong because my real answer is longer."

---

## 5. In-app "archive this card" action

**What:** Add an archive action in `/study/[deckId]` (and `/walk/[deckId]`). Archived cards are filtered out of future scheduling. Schema: `cards.archived_at DATETIME NULL` — filter WHERE archived_at IS NULL in due-card queries. Unarchive action to restore.

**Why:** Decided 2026-04-24 to skip pre-import JSON curation in favor of running all 187 SEAL cards + ~300 behavioral profiles through FSRS naturally. FSRS handles load, but some cards will prove unwanted even after a few reviews (repetitive, obvious, too narrow). Archiving is the right curation mechanism once cards are in context, not in a text editor.

**Pros:** Real judgment replaces pre-imported guesswork. Keeps total deck growing without crowding daily load. Undoable (unlike JSON deletion).

**Cons:** Another UI surface. Also a card_face decision: show archive action on every review, or only after N rate-downs? TBD in design.

**Context:** Design doc The Assignment section 2026-04-24 revision. Currently relying on FSRS rate-down ("Again") as the only curation mechanism.

**Depends on:** Phase 1 schema + `/study/[deckId]` basic flow. Minimal addition to the schema (one column) + one UI button + filter in due-card queries.

**Trigger:** After 2-3 weeks of real use, when you're reaching "Again" on a card just to make it appear less. That's the UX signal you need a real archive.

---
