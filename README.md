# Neurotrack

Neurotrack is an innovative platform that leverages artificial intelligence to support the detection, assessment, and management of neurodevelopmental conditions including Autism Spectrum Disorder (ASD), Attention Deficit Hyperactivity Disorder (ADHD), and various learning difficulties. The platform connects patients/clients with qualified therapists through two dedicated applications, streamlining the assessment, consultation, and therapy management process.

https://www.figma.com/design/bqKZn8UnfkyLbxaaWzSKtp/neurotrack?node-id=0-1&t=ipx4aQhq1BGIXsTb-1

## Core Purpose

Neurotrack aims to:

- Automate preliminary screening assessments for neurodevelopmental conditions
- Connect individuals with qualified therapists based on assessment results
- Facilitate personalized education and therapy plans
- Track therapy progress using data-driven approaches
- Empower patients/caregivers to actively participate in the therapy process

## Tech Stack
- Flutter (for both the Apps)
- Supabase (for backend)

## Patient Application Flow

### Authentication & Onboarding

- Users can sign up/sign in via Google/Apple authentication
- New users complete a profile setup specifying:
    - Whether they're accessing for themselves (18+) or as a caregiver for a child
    - Basic demographic information
    - Any existing diagnoses or concerns

### Assessment Process

- Users select from multiple evidence-based assessment options tailored to different conditions (ASD, ADHD, etc.)
- Assessments include interactive questionnaires, possibly video recording of behaviors (optional)
- AI analyzes responses against established clinical baselines
- Results are presented with:
    - Likelihood indicators for various conditions
    - Severity assessment where applicable
    - Clear disclaimer that results are preliminary and not diagnostic
    - Recommendation on whether professional consultation is advisable

### Consultation Connection

- If professional consultation is recommended, users can:
    - View profiles of available therapists with relevant specializations
    - Request consultation appointments
    - Share assessment results directly with selected therapists

### Therapy Management

- After consultation and formal onboarding by a therapist:
    - View personalized therapy plan
    - Access scheduled therapy sessions (in-person or telehealth)
    - Review session outcomes and progress reports
    - Schedule new therapy sessions

### Daily Activities Dashboard

- Access daily prescribed activities assigned by therapist
- Mark activities as completed
- Record observations or difficulties during activities
- View progress charts and achievement tracking
- Receive reminders for pending activities

## Therapist Application Flow

### Authentication & Verification

- Professional sign up with credential verification
    - License information
    - Specialization details
    - Professional certifications
    - Background verification
- Admin approval process before full platform access

### Patient Management

- Dashboard showing:
    - New assessment results and consultation requests
    - Current patient roster
    - Upcoming appointments
    - Pending reviews of therapy outcomes

### Assessment Review

- Review detailed assessment results from potential clients
- Accept or refer consultation requests
- Schedule initial consultations

### Client Onboarding

- After consultation, formal onboarding process:
    - Create personalized therapy plans
    - Set therapy goals and milestones
    - Schedule initial therapy sessions
    - Assign preliminary daily activities

### Therapy Session Management

- Schedule and manage therapy sessions
- Record detailed session outcomes including:
    - Goals addressed
    - Progress made
    - Techniques used
    - Observations
    - Next steps

### Daily Activity Assignment

- Create customized daily activities for each client
- Set duration and frequency
- Monitor completion rates and reported difficulties
- Adjust activities based on progress and feedback

### Progress Reporting

- Generate detailed progress reports
- Track long-term development across key domains
- Visualize improvement trends
- Document milestone achievements            