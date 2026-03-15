-- Create the patient table
CREATE TABLE patient (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    patient_name TEXT NOT NULL,
    age INT2,
    is_adult BOOLEAN NOT NULL,
    guardian_name TEXT,
    phone TEXT NOT NULL,
    email TEXT NOT NULL,
    guardian_relation TEXT,
    autism_level INT2,
    onboarded_on TIMESTAMPTZ,
    therapist_id UUID REFERENCES therapist(id),
    gender TEXT,
    country TEXT
);

-- Create the therapist table
CREATE TABLE therapist (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    clinic_id UUID,
    license TEXT,
    approved BOOLEAN DEFAULT FALSE,
    specialisation TEXT,
    gender TEXT,
    offered_therapies TEXT[],
    age INT2,
    regulatory_body TEXT,
    start_availability_time TEXT,
    end_availability_time TEXT,
    license_number TEXT,
);

-- Create the package table
CREATE TABLE package (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    name TEXT NOT NULL,
    duration INT4 NOT NULL
);

-- Create the session table
CREATE TABLE session (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    timestamp TIMESTAMPTZ NOT NULL,
    therapist_id UUID REFERENCES therapist(id),
    patient_id UUID REFERENCES patient(id),
    is_consultation BOOLEAN DEFAULT FALSE,
    mode INT2,
    duration INT4,
    name TEXT,
    status TEXT NOT NULL CHECK (status IN ('accepted', 'declined', 'pending')) DEFAULT 'pending',
    declined_reason TEXT,
);

-- Create the therapy_goal table
CREATE TABLE therapy_goal (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    performed_on TIMESTAMPTZ,
    therapist_id UUID REFERENCES therapist(id), 
    therapy_mode INT2,
    duration INT4,
    therapy_type INT2,
    therapy_type_id UUID REFERENCES therapy_type(id),
    goals JSONB,
    observations JSONB,
    regressions JSONB,
    activities JSONB,
    patient_id UUID REFERENCES patient(id)
);

-- Create the assessments table
CREATE TABLE assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  cutoff_score INT2,
  image_url TEXT,
  questions JSONB NOT NULL
);

-- Create the assessment_results table

CREATE TABLE assessment_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  assessment_id UUID REFERENCES assessments(id),
  patient_id UUID REFERENCES auth.users(id),
  submission JSONB,
  result JSONB
);

-- Therapy Table 
CREATE TABLE therapy (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

-- Therapy Goals Master Table
CREATE TABLE goal_master (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    goal_text TEXT NOT NULL,
    applicable_therapies UUID[] NOT NULL
);

-- Observations Master Table
CREATE TABLE observation_master (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    observation_text TEXT NOT NULL,
    applicable_therapies UUID[] NOT NULL,
);

-- Regressions Master Table
CREATE TABLE regression_master (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    regression_text TEXT NOT NULL,
    applicable_therapies UUID[] NOT NULL
);

-- Activities Master Table
CREATE TABLE activity_master (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    activity_text TEXT NOT NULL,
    applicable_therapies UUID[] NOT NULL,
);

-- Daily Activities Table
CREATE TABLE daily_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    activity_name TEXT NOT NULL,
    activity_list JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    therapist_id UUID REFERENCES therapist(id),
    patient_id UUID REFERENCES patient(id),
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    days_of_week INT2[],
);

CREATE TABLE daily_activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_id UUID REFERENCES daily_activities(id) ON DELETE CASCADE,
    date TIMESTAMPTZ NOT NULL,
    activity_items JSONB NOT NULL
    patient_id UUID REFERENCES patient(id) ON DELETE CASCADE,
);

-- Indexes on foreign keys for better performance
CREATE INDEX idx_patient_therapist_id ON patient(therapist_id);
CREATE INDEX idx_session_therapist_id ON session(therapist_id);
CREATE INDEX idx_session_patient_id ON session(patient_id);
CREATE INDEX idx_therapy_goal_therapist_id ON therapy_goal(therapist_id);
CREATE INDEX idx_therapy_goal_patient_id ON therapy_goal(patient_id);

-- ==========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================

-- Enable RLS on all tables
ALTER TABLE patient ENABLE ROW LEVEL SECURITY;
ALTER TABLE therapist ENABLE ROW LEVEL SECURITY;
ALTER TABLE package ENABLE ROW LEVEL SECURITY;
ALTER TABLE session ENABLE ROW LEVEL SECURITY;
ALTER TABLE therapy_goal ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE therapy ENABLE ROW LEVEL SECURITY;
ALTER TABLE goal_master ENABLE ROW LEVEL SECURITY;
ALTER TABLE observation_master ENABLE ROW LEVEL SECURITY;
ALTER TABLE regression_master ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_master ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_activity_logs ENABLE ROW LEVEL SECURITY;

-- PATIENT POLICIES
-- Patients can view and update their own data. Therapists can view their assigned patients.
CREATE POLICY "Patients can view own data" ON patient FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Patients can update own data" ON patient FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Therapists can view assigned patients" ON patient FOR SELECT USING (auth.uid() = therapist_id);

-- THERAPIST POLICIES
-- Therapists can view and update their own data. Patients can view therapist profiles.
CREATE POLICY "Therapists can view own data" ON therapist FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Therapists can update own data" ON therapist FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Patients can view therapist profiles" ON therapist FOR SELECT USING (true);

-- SESSION POLICIES
-- Users can read, insert, and update their own sessions (as patient or therapist)
CREATE POLICY "Users can manage their own sessions" ON session FOR ALL USING (auth.uid() = patient_id OR auth.uid() = therapist_id);

-- THERAPY GOAL POLICIES
-- Users can read and update their own therapy goals
CREATE POLICY "Users can manage their therapy goals" ON therapy_goal FOR ALL USING (auth.uid() = patient_id OR auth.uid() = therapist_id);

-- ASSESSMENT RESULTS POLICIES
-- Patients can read and insert their own assessment results.
CREATE POLICY "Patients can read own assessment results" ON assessment_results FOR SELECT USING (auth.uid() = patient_id);
CREATE POLICY "Patients can insert own assessment results" ON assessment_results FOR INSERT WITH CHECK (auth.uid() = patient_id);
CREATE POLICY "Therapists can view assessment results of their patients" ON assessment_results FOR SELECT USING (
  EXISTS (SELECT 1 FROM patient WHERE patient.id = assessment_results.patient_id AND patient.therapist_id = auth.uid())
);

-- DAILY ACTIVITIES POLICIES
CREATE POLICY "Users can manage daily activities" ON daily_activities FOR ALL USING (auth.uid() = patient_id OR auth.uid() = therapist_id);
CREATE POLICY "Users can manage daily activity logs" ON daily_activity_logs FOR ALL USING (auth.uid() = patient_id);

-- PUBLIC READ-ONLY MASTER TABLES (Assessments, Therapies, Goals, etc.)
CREATE POLICY "Anyone can view assessments" ON assessments FOR SELECT USING (true);
CREATE POLICY "Anyone can view therapies" ON therapy FOR SELECT USING (true);
CREATE POLICY "Anyone can view goal_master" ON goal_master FOR SELECT USING (true);
CREATE POLICY "Anyone can view observation_master" ON observation_master FOR SELECT USING (true);
CREATE POLICY "Anyone can view regression_master" ON regression_master FOR SELECT USING (true);
CREATE POLICY "Anyone can view activity_master" ON activity_master FOR SELECT USING (true);
CREATE POLICY "Anyone can view packages" ON package FOR SELECT USING (true);