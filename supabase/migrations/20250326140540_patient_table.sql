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

-- Create the patient table
CREATE TABLE patient (
    patient_id UUID PRIMARY KEY REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    patient_name TEXT NOT NULL,
    age INT2,
    is_adult BOOLEAN NOT NULL,
    guardian_name TEXT,
    phone_no TEXT NOT NULL,
    email TEXT NOT NULL,
    guardian_relation TEXT,
    autism_level INT2,
    onboarded_on TIMESTAMPTZ,
    therapist_id UUID REFERENCES therapist(id),
    gender TEXT,
    country TEXT
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
    patient_id UUID REFERENCES patient(patient_id),     -- Fixed to reference patient.id
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
    goals JSONB,
    observations JSONB,
    regressions JSONB,
    activities JSONB,
    patient_id UUID REFERENCES patient(patient_id),     -- Fixed to reference patient.id
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

-- Insert Autism Quotient (AQ) assessment with questions
INSERT INTO assessments (name, description, category, cutoff_score, image_url, questions)
VALUES (
    'Autism Quotient(AQ)', 
    'A quick referral guide to adults with suspected autism',
    'Autism',
    32, -- Example cutoff score
    'assets/illustrations/i9n_autism.png',
    '[
        {
            "question_id": "aq_1",
            "text": "S/he often notices small sounds when others do not",
            "options": [
                {"option_id": "aq_1_1", "text": "Definitely Agree", "score": 1},
                {"option_id": "aq_1_2", "text": "Slightly Agree", "score": 1},
                {"option_id": "aq_1_3", "text": "Slightly Disagree", "score": 0},
                {"option_id": "aq_1_4", "text": "Definitely Disagree", "score": 0}
            ]
        },
        {
            "question_id": "aq_2",
            "text": "S/he usually concentrates more on the whole picture, rather than the small details",
            "options": [
                {"option_id": "aq_2_1", "text": "Definitely Agree", "score": 0},
                {"option_id": "aq_2_2", "text": "Slightly Agree", "score": 0},
                {"option_id": "aq_2_3", "text": "Slightly Disagree", "score": 1},
                {"option_id": "aq_2_4", "text": "Definitely Disagree", "score": 1}
            ]
        },
        {
            "question_id": "aq_3",
            "text": "S/he finds it easy to do more than one thing at once",
            "options": [
                {"option_id": "aq_3_1", "text": "Definitely Agree", "score": 0},
                {"option_id": "aq_3_2", "text": "Slightly Agree", "score": 0},
                {"option_id": "aq_3_3", "text": "Slightly Disagree", "score": 1},
                {"option_id": "aq_3_4", "text": "Definitely Disagree", "score": 1}
            ]
        },
        {
            "question_id": "aq_4",
            "text": "If there is an interruption, s/he can switch back to what s/he was doing very quickly",
            "options": [
                {"option_id": "aq_4_1", "text": "Definitely Agree", "score": 0},
                {"option_id": "aq_4_2", "text": "Slightly Agree", "score": 0},
                {"option_id": "aq_4_3", "text": "Slightly Disagree", "score": 1},
                {"option_id": "aq_4_4", "text": "Definitely Disagree", "score": 1}
            ]
        },
        {
            "question_id": "aq_5",
            "text": "S/he finds it easy to read between the lines when someone is talking to them",
            "options": [
                {"option_id": "aq_5_1", "text": "Definitely Agree", "score": 0},
                {"option_id": "aq_5_2", "text": "Slightly Agree", "score": 0},
                {"option_id": "aq_5_3", "text": "Slightly Disagree", "score": 1},
                {"option_id": "aq_5_4", "text": "Definitely Disagree", "score": 1}
            ]
        }
    ]'::jsonb
);

-- Insert ASRS-5 assessment
INSERT INTO assessments (name, description, category, cutoff_score, image_url, questions)
VALUES (
    'ASRS-5', 
    'The Adult ADHD Self-Report Scale for DSM-5 (ASRS-5) is a self-report screening scale for ADHD in adults',
    'ADHD',
    14, -- Example cutoff score
    'assets/illustrations/i9n_adhd.png',
    '[
        {
            "question_id": "asrs_1",
            "text": "How often do you have difficulty concentrating on what people say to you, even when they are speaking to you directly?",
            "options": [
                {"option_id": "asrs_1_0", "text": "Never", "score": 0},
                {"option_id": "asrs_1_1", "text": "Rarely", "score": 1},
                {"option_id": "asrs_1_2", "text": "Sometimes", "score": 2},
                {"option_id": "asrs_1_3", "text": "Often", "score": 3},
                {"option_id": "asrs_1_4", "text": "Very Often", "score": 4}
            ]
        },
        {
            "question_id": "asrs_2",
            "text": "How often do you leave your seat in meetings or other situations in which you are expected to remain seated?",
            "options": [
                {"option_id": "asrs_2_0", "text": "Never", "score": 0},
                {"option_id": "asrs_2_1", "text": "Rarely", "score": 1},
                {"option_id": "asrs_2_2", "text": "Sometimes", "score": 2},
                {"option_id": "asrs_2_3", "text": "Often", "score": 3},
                {"option_id": "asrs_2_4", "text": "Very Often", "score": 4}
            ]
        },
        {
            "question_id": "asrs_3",
            "text": "How often do you have difficulty waiting your turn in situations when turn-taking is required?",
            "options": [
                {"option_id": "asrs_3_0", "text": "Never", "score": 0},
                {"option_id": "asrs_3_1", "text": "Rarely", "score": 1},
                {"option_id": "asrs_3_2", "text": "Sometimes", "score": 2},
                {"option_id": "asrs_3_3", "text": "Often", "score": 3},
                {"option_id": "asrs_3_4", "text": "Very Often", "score": 4}
            ]
        }
    ]'::jsonb
);

-- Insert AQ-10 assessment
INSERT INTO assessments (name, description, category, cutoff_score, image_url, questions)
VALUES (
    'AQ-10', 
    'The AQ-10 is a quick questionnaire that primary care practitioners can use to see if a person should be referred for an autism assessment.',
    'Autism',
    6, -- Example cutoff score
    'assets/illustrations/i9n_aq10.png',
    '[
        {
            "question_id": "aq10_1",
            "text": "I often notice small sounds when others do not",
            "options": [
                {"option_id": "aq10_1_1", "text": "Definitely Agree", "score": 1},
                {"option_id": "aq10_1_2", "text": "Slightly Agree", "score": 0},
                {"option_id": "aq10_1_3", "text": "Slightly Disagree", "score": 0},
                {"option_id": "aq10_1_4", "text": "Definitely Disagree", "score": 0}
            ]
        },
        {
            "question_id": "aq10_2",
            "text": "I usually concentrate more on the whole picture, rather than the small details",
            "options": [
                {"option_id": "aq10_2_1", "text": "Definitely Agree", "score": 0},
                {"option_id": "aq10_2_2", "text": "Slightly Agree", "score": 0},
                {"option_id": "aq10_2_3", "text": "Slightly Disagree", "score": 0},
                {"option_id": "aq10_2_4", "text": "Definitely Disagree", "score": 1}
            ]
        },
        {
            "question_id": "aq10_3",
            "text": "I find it difficult to work out peoples intentions",
            "options": [
                {"option_id": "aq10_3_1", "text": "Definitely Agree", "score": 1},
                {"option_id": "aq10_3_2", "text": "Slightly Agree", "score": 0},
                {"option_id": "aq10_3_3", "text": "Slightly Disagree", "score": 0},
                {"option_id": "aq10_3_4", "text": "Definitely Disagree", "score": 0}
            ]
        }
    ]'::jsonb
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

-- Indexes on foreign keys for better performance
CREATE INDEX idx_patient_therapist_id ON patient(therapist_id);
CREATE INDEX idx_session_therapist_id ON session(therapist_id);
CREATE INDEX idx_session_patient_id ON session(patient_id);
CREATE INDEX idx_therapy_goal_therapist_id ON therapy_goal(therapist_id);
CREATE INDEX idx_therapy_goal_patient_id ON therapy_goal(patient_id);
