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
    regulatory_body TEXT
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
    therapist_id UUID REFERENCES therapist(id), -- Fixed to reference therapist.id
    patient_id UUID REFERENCES patient(id),     -- Fixed to reference patient.id
    mode INT2,
    duration INT4,
    name TEXT,
    status TEXT NOT NULL CHECK (status IN ('accepted', 'declined', 'pending')) DEFAULT 'pending'
);

-- Create the therapy_goal table
CREATE TABLE therapy_goal (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    performed_on TIMESTAMPTZ,
    therapist_id UUID REFERENCES therapist(id), -- Fixed to reference therapist.id
    therapy_mode INT2,
    duration INT4,
    therapy_type INT2,
    therapy_id REFERENCES therapy(id)
    goals JSONB,
    observations JSONB,
    regressions JSONB,
    activities JSONB,
    patient_id UUID REFERENCES patient(id),     -- Fixed to reference patient.id
    therapy_date INT8
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

-- Indexes on foreign keys for better performance
CREATE INDEX idx_patient_therapist_id ON patient(therapist_id);
CREATE INDEX idx_session_therapist_id ON session(therapist_id);
CREATE INDEX idx_session_patient_id ON session(patient_id);
CREATE INDEX idx_therapy_goal_therapist_id ON therapy_goal(therapist_id);
CREATE INDEX idx_therapy_goal_patient_id ON therapy_goal(patient_id);