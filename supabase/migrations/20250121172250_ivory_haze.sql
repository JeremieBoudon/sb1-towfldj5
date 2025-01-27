/*
  # Create test user if not exists
  
  1. Changes
    - Safely creates a test user only if it doesn't exist
    - Uses DO block for conditional logic
    - Maintains data integrity
  
  2. User Details
    - Email: test@example.com
    - Password: test123
    - Role: employee
    - Department: Engineering
*/

DO $$
DECLARE
  new_user_id uuid;
BEGIN
  -- Check if user already exists
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'test@example.com') THEN
    -- Create auth user
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
    RETURNING id INTO new_user_id;

    -- Create public user profile
    INSERT INTO public.users (
      id,
      email,
      first_name,
      last_name,
      role,
      department
    )
    VALUES (
      new_user_id,
      'test@example.com',
      'Test',
      'User',
      'employee',
      'Engineering'
    );
  END IF;
END $$;