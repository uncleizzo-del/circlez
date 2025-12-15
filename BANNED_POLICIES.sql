-- RLS Policies for Banned Users
-- Run these in Supabase SQL Editor to enforce banned user restrictions

-- 1. Prevent banned users from posting
CREATE POLICY "No posting if banned"
ON posts FOR INSERT
WITH CHECK (
  NOT (auth.uid() IN (SELECT id FROM profiles WHERE banned = true))
);

-- 2. Prevent banned users from sending messages
CREATE POLICY "No messaging if banned"
ON messages FOR INSERT
WITH CHECK (
  NOT (auth.uid() IN (SELECT id FROM profiles WHERE banned = true))
);

-- 3. Prevent banned users from creating comments
CREATE POLICY "No comments if banned"
ON comments FOR INSERT
WITH CHECK (
  NOT (auth.uid() IN (SELECT id FROM profiles WHERE banned = true))
);

-- 4. Prevent banned users from creating reactions
CREATE POLICY "No reactions if banned"
ON reactions FOR INSERT
WITH CHECK (
  NOT (auth.uid() IN (SELECT id FROM profiles WHERE banned = true))
);

-- 5. Prevent banned users from uploading to storage
-- (This is handled by the app-level checks, storage policies would be similar)

-- 6. Prevent banned users from updating their profile
CREATE POLICY "Cannot update profile if banned"
ON profiles FOR UPDATE
USING (auth.uid() = id AND NOT (banned = true))
WITH CHECK (auth.uid() = id AND NOT (banned = true));

-- Optional: Allow admins to read and update banned status
-- (if your admin role is defined)
-- Example for uncleizzo@gmail.com:
-- CREATE POLICY "Admin can manage banned status"
-- ON profiles FOR UPDATE
-- USING (auth.jwt() ->> 'email' = 'uncleizzo@gmail.com')
-- WITH CHECK (auth.jwt() ->> 'email' = 'uncleizzo@gmail.com');

-- 7. Hide banned users from being visible to others (optional)
-- Restrict reading banned users' profiles
CREATE POLICY "Cannot read banned users' profiles"
ON profiles FOR SELECT
USING (
  NOT banned OR auth.uid() = id OR auth.jwt() ->> 'email' = 'uncleizzo@gmail.com'
);

-- 8. Prevent banned users from modifying relationships
CREATE POLICY "Banned users cannot create relationships"
ON relationships FOR INSERT
WITH CHECK (
  NOT (auth.uid() IN (SELECT id FROM profiles WHERE banned = true))
);

CREATE POLICY "Banned users cannot modify relationships"
ON relationships FOR UPDATE
USING (auth.uid() = owner_id AND NOT (auth.uid() IN (SELECT id FROM profiles WHERE banned = true)))
WITH CHECK (auth.uid() = owner_id AND NOT (auth.uid() IN (SELECT id FROM profiles WHERE banned = true)));

-- Notes:
-- - Replace 'uncleizzo@gmail.com' with your actual admin email if needed
-- - Make sure the 'banned' column exists on the profiles table:
--   ALTER TABLE profiles ADD COLUMN banned BOOLEAN DEFAULT false;
-- - These policies assume auth.uid() returns the user's ID
-- - Test policies after creation to ensure they work correctly
