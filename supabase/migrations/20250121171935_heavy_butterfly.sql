/*
  # Create test user

  1. Changes
    - Insert a test user with basic employee role
    - Email: test@example.com
    - Password: test123 (will be hashed by Supabase Auth)
*/

-- First, create the user in auth.users (this is a safe operation as it's additive)
INSERT INTO auth.users (
  id,
  instance_id,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
VALUES (
  gen_random_uuid(),
  '00000000-0000-0000-0000-000000000000',
  'test@example.com',
  crypt('test123', gen_salt('bf')),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{}',
  now(),
  now()
);

-- Then create the corresponding user profile
INSERT INTO users (
  id,
  email,
  first_name,
  last_name,
  role,
  department
)
SELECT 
  id,
  email,
  'Test',
  'User',
  'employee',
  'Engineering'
FROM auth.users
WHERE email = 'test@example.com';