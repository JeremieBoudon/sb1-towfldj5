/*
  # Fix RLS policies for users table

  1. Changes
    - Drop existing policies
    - Add new policies for:
      - Insert: Allow authenticated users to create their own profile
      - Select: Allow authenticated users to read all user data
      - Update: Allow users to update their own profile
  
  2. Security
    - Maintains basic security while allowing necessary operations
    - Ensures users can create and manage their profiles
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON users;

-- Create new policies
CREATE POLICY "Allow users to create their own profile"
  ON users
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Allow authenticated users to read user data"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow users to update their own profile"
  ON users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);