export type UserRole = 'employee' | 'manager' | 'hr_admin';

export interface User {
  id: string;
  email: string;
  first_name: string;
  last_name: string;
  role: UserRole;
  department: string;
  manager_id?: string;
  created_at: string;
}

export interface Review {
  id: string;
  employee_id: string;
  review_period: string;
  status: 'draft' | 'submitted' | 'in_review' | 'completed';
  self_assessment: SelfAssessment;
  peer_reviews: PeerReview[];
  manager_review: ManagerReview;
  created_at: string;
  updated_at: string;
}

export interface SelfAssessment {
  id: string;
  review_id: string;
  achievements: string;
  challenges: string;
  goals: string;
  skills_assessment: Record<string, number>;
  comments: string;
  created_at: string;
  updated_at: string;
}

export interface PeerReview {
  id: string;
  review_id: string;
  reviewer_id: string;
  collaboration: number;
  communication: number;
  technical_skills: number;
  feedback: string;
  created_at: string;
  updated_at: string;
}

export interface ManagerReview {
  id: string;
  review_id: string;
  performance_rating: number;
  strengths: string;
  areas_for_improvement: string;
  goals_assessment: string;
  development_plan: string;
  created_at: string;
  updated_at: string;
}