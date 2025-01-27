/*
  # Create test user properly

  1. Changes
    - Create test user in auth.users if not exists
    - Create corresponding user profile in public.users
    - Ensure proper role and department assignment
*/

DO $$
DECLARE
  auth_uid uuid;
BEGIN
  -- First, check if the user already exists in auth.users
  SELECT id INTO auth_uid
  FROM auth.users
  WHERE email = 'test@example.com';

  -- If user doesn't exist in auth.users, create them
  IF auth_uid IS NULL THEN
    INSERT INTO auth.users (
      id,
      instance_id,
      email,
      encrypted_password,
      email_confirmed_at,
      raw_app_meta_data,
      raw_user_meta_data,
      created_at,
      updated_at,
      aud,
      role
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
      now(),
      'authenticated',
      'authenticated'
    )
    RETURNING id INTO auth_uid;
  END IF;

  -- Now ensure the user exists in public.users
  INSERT INTO public.users (
    id,
    email,
    first_name,
    last_name,
    role,
    department
  )
  VALUES (
    auth_uid,
    'test@example.com',
    'Test',
    'User',
    'employee',
    'Engineering'
  )
  ON CONFLICT (id) DO UPDATE
  SET
    email = EXCLUDED.email,
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    role = EXCLUDED.role,
    department = EXCLUDED.department;
END $$;