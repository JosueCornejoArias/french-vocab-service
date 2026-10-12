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
┌──────────┐         ┌──────────────┐         ┌─────────────────────┐
│  users   │────┬───<│   catalogs   │────┬───<│        words        │
└──────────┘    │    └──────────────┘    │    └─────────────────────┘
│          │           │            │               │
│          │           │            │               │
▼          │           ▼            │               ▼
┌───────────────────────┐  ┌────────────────────────────────────────┐
│    practice_events    │  │           user_word_reviews            │
│ (Immutable Event Log) │  │          (Materialized State)          │
└───────────────────────┘  └────────────────────────────────────────┘
### Performance Indexes
Foreign keys in PostgreSQL do not automatically create indexes. The following B-Tree indexes prevent full table sequential scans during high-frequency joins and queue filtering:
* `idx_catalogs_user_id`: Accelerates user library lookups.
* `idx_words_catalog_id`: Speeds up deck-loading joins.
* `idx_reviews_user_status`: Composite index on `(user_id, mastery_status)` for card-queue generation.
* `idx_practice_events_user_time`: B-Tree index on `(user_id, reviewed_at DESC)` for

---

## 3. Directory Layout

```text
├── migrations/
│   ├── 001_initial_schema.sql     # DDL for core tables and constraints
│   └── 002_add_indexes.sql        # Performance indexes for foreign keys & queues
├── seeds/
│   ├── 001_seed_french_a1.sql     # Reference fixture: 100 foundational A1 words
│   └── 002_simulate_user_activity.sql # Synthetic test: Copy-on-Write & review transactions
├── .env.example                   # Sanitized database connection string template
├── .gitignore                     # Git secret isolation (.env, OS cache)
└── README.md                      # Architecture documentation