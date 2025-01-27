/*
  # Initial Schema for HR Performance Review System

  1. New Tables
    - users: Stores user information and roles
    - reviews: Main review records
    - self_assessments: Employee self-evaluation data
    - peer_reviews: Feedback from colleagues
    - manager_reviews: Manager evaluation and feedback
  
  2. Security
    - RLS enabled on all tables
    - Policies for data access based on user roles
*/

-- Users table
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  first_name text NOT NULL,
  last_name text NOT NULL,
  role text NOT NULL CHECK (role IN ('employee', 'manager', 'hr_admin')),
  department text NOT NULL,
  manager_id uuid REFERENCES users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Reviews table
CREATE TABLE reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id uuid REFERENCES users(id) NOT NULL,
  review_period text NOT NULL,
  status text NOT NULL CHECK (status IN ('draft', 'submitted', 'in_review', 'completed')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Self Assessments
CREATE TABLE self_assessments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id uuid REFERENCES reviews(id) NOT NULL,
  achievements text,
  challenges text,
  goals text,
  skills_assessment jsonb DEFAULT '{}',
  comments text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Peer Reviews
CREATE TABLE peer_reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id uuid REFERENCES reviews(id) NOT NULL,
  reviewer_id uuid REFERENCES users(id) NOT NULL,
  collaboration integer CHECK (collaboration BETWEEN 1 AND 5),
  communication integer CHECK (communication BETWEEN 1 AND 5),
  technical_skills integer CHECK (technical_skills BETWEEN 1 AND 5),
  feedback text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Manager Reviews
CREATE TABLE manager_reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id uuid REFERENCES reviews(id) NOT NULL,
  performance_rating integer CHECK (performance_rating BETWEEN 1 AND 5),
  strengths text,
  areas_for_improvement text,
  goals_assessment text,
  development_plan text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE self_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE peer_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE manager_reviews ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can read their own data"
  ON users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "HR admins can read all user data"
  ON users
  FOR SELECT
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM users WHERE id = auth.uid() AND role = 'hr_admin'
  ));

-- Reviews policies
CREATE POLICY "Users can read their own reviews"
  ON reviews
  FOR SELECT
  TO authenticated
  USING (employee_id = auth.uid());

CREATE POLICY "Managers can read their team's reviews"
  ON reviews
  FOR SELECT
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM users 
    WHERE users.manager_id = auth.uid() 
    AND users.id = reviews.employee_id
  ));

CREATE POLICY "HR admins can read all reviews"
  ON reviews
  FOR SELECT
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM users WHERE id = auth.uid() AND role = 'hr_admin'
  ));