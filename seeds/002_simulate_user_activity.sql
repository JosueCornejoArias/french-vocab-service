-- ============================================================================
-- SEED 002: Synthetic User Simulation (Copy-on-Write Fork & Atomic Review)
-- ============================================================================

-- 1. Ensure test user exists
INSERT INTO users (username, daily_goal) 
VALUES ('josuetest1', 5)
ON CONFLICT (username) DO NOTHING;

-- 2. Atomic Copy-on-Write Fork (Deep-copy template deck and words)
WITH source_cat AS (
    SELECT id, title, description 
    FROM catalogs 
    WHERE is_template = TRUE 
    LIMIT 1
),
user_target AS (
    SELECT id FROM users WHERE username = 'josuetest1'
),
new_cat AS (
    INSERT INTO catalogs (user_id, title, description, is_template, source_catalog_id)
    SELECT 
        u.id, 
        s.title || ' (My Deck)', 
        s.description, 
        FALSE, 
        s.id
    FROM user_target u, source_cat s
    RETURNING id, source_catalog_id
)
INSERT INTO words (catalog_id, term, definition, part_of_speech, example_sentence, source_word_id)
SELECT 
    nc.id, 
    w.term, 
    w.definition, 
    w.part_of_speech, 
    w.example_sentence, 
    w.id
FROM new_cat nc
JOIN words w ON w.catalog_id = nc.source_catalog_id;

-- 3. Atomic Practice Event & State Upsert
BEGIN;

WITH context AS (
    SELECT u.id AS uid, w.id AS wid
    FROM users u
    JOIN catalogs c ON c.user_id = u.id
    JOIN words w ON w.catalog_id = c.id
    WHERE u.username = 'josuetest1' 
      AND w.term = 'bonsoir'
    LIMIT 1
)
INSERT INTO practice_events (user_id, word_id, action, reviewed_at)
SELECT uid, wid, 'unknown', CURRENT_TIMESTAMP
FROM context;

WITH context AS (
    SELECT u.id AS uid, w.id AS wid
    FROM users u
    JOIN catalogs c ON c.user_id = u.id
    JOIN words w ON w.catalog_id = c.id
    WHERE u.username = 'josuetest1' 
      AND w.term = 'bonsoir'
    LIMIT 1
)
INSERT INTO user_word_reviews (
    user_id, 
    word_id, 
    practice_count, 
    mastery_status, 
    is_flagged, 
    last_reviewed_at
)
SELECT 
    uid, 
    wid, 
    1, 
    'unknown', 
    FALSE, 
    CURRENT_TIMESTAMP
FROM context
ON CONFLICT (user_id, word_id) 
DO UPDATE SET
    practice_count   = user_word_reviews.practice_count + 1,
    mastery_status   = EXCLUDED.mastery_status,
    last_reviewed_at = CURRENT_TIMESTAMP;

COMMIT;