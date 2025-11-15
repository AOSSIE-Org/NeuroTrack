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