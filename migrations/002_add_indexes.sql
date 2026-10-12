CREATE INDEX idx_catalogs_user_id ON catalogs(user_id);
CREATE INDEX idx_words_catalog_id ON words(catalog_id);
CREATE INDEX idx_reviews_user_status ON user_word_reviews(user_id, mastery_status);
CREATE INDEX idx_practice_events_user_time ON practice_events(user_id, reviewed_at DESC);