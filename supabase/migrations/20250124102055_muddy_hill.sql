/*
  # Fix users table RLS policies

  1. Changes
    - Remove recursive policies that were causing infinite recursion
    - Simplify user access policies
    - Add proper manager access policies
  
  2. Security
    - Users can read their own data
    - Managers can read their team members' data
    - HR admins can read all user data
*/

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Users can read their own data" ON users;
DROP POLICY IF EXISTS "HR admins can read all user data" ON users;

-- Create new, simplified policies
CREATE POLICY "Users can read own data"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Managers can read team data"
  ON users FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users AS u
      WHERE u.id = auth.uid()
      AND u.role = 'manager'
      AND users.manager_id = u.id
    )
  );

CREATE POLICY "HR admins can read all data"
  ON users FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users AS u
      WHERE u.id = auth.uid()
      AND u.role = 'hr_admin'
    )
  );