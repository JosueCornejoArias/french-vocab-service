# French Vocabulary Service (`french-vocab-service`)

A high-integrity PostgreSQL data architecture designed for a spaced-repetition vocabulary learning platform. Built with a focus on auditability, non-destructive user personalization, and resilient query performance.

---

## 1. Architectural Patterns & Engineering Trade-Offs

### A. Copy-on-Write (Forking) vs. Shared Catalog Mutation
* **The Problem:** Modifying shared template decks directly risks corrupting default vocabulary for all users or cascading unintended edits across existing study histories.
* **The Solution:** Platform templates are immutable system catalogs (`user_id IS NULL`, `is_template = TRUE`). When a user adds a template, an atomic Data-Modifying CTE deep-copies the catalog metadata and its associated words into a user-owned catalog referencing `source_catalog_id`. 
* **Trade-off:** Increases row volume in `words`, but eliminates lock contention on global records and allows complete user customization without data pollution.

### B. Immutable Audit Ledger vs. Materialized Review State
* **Dual-Write Event Sourcing:** Flashcard reviews execute as atomic transactions updating two distinct models:
  1. `practice_events`: An append-only ledger recording every user interaction (`user_id`, `word_id`, `action`, `reviewed_at`) for streak calculations and historical analytics.
  2. `user_word_reviews`: A materialized state table (`practice_count`, `mastery_status`, `is_flagged`) using PostgreSQL `UPSERT` (`ON CONFLICT (user_id, word_id) DO UPDATE`) for $O(1)$ study-queue retrieval.
* **Trade-off:** Requires atomic transaction management (`BEGIN ... COMMIT`), but prevents costly aggregate recomputations over millions of audit rows.

### C. Referential Integrity & Deletion Cascades
* **Strict Parent-Child:** `catalogs` to `words` enforces `ON DELETE CASCADE` to prevent orphaned flashcards.
* **Preserved Clones:** `source_catalog_id` and `source_word_id` enforce `ON DELETE SET NULL`. If a global platform template is decommissioned, user copies remain fully operational.

---

## 2. Database Schema & Indexing Strategy