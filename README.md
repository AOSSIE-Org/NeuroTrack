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

# Neurotrack Project Setup

This README provides instructions for setting up and running the Neurotrack patient and therapist apps, as well as configuring Supabase.


## 🧠 Backend Setup

### Prerequisites
- A Supabase account and project at [supabase.com](https://supabase.com)
- Node.js v18+ installed
- Supabase CLI installed (see below)

### 1. Install Supabase CLI

**Windows:**
```powershell
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase
```
Or use: `winget install Supabase.cli`

**Linux/macOS:**
```bash
brew install supabase/tap/supabase
```

Verify: `supabase --version`

### 2. Configure Environment

Create `.env` in `supabase/scripts/`:
```env
SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co
SUPABASE_KEY=YOUR_SERVICE_ROLE_KEY
```
> Find these in: Supabase Dashboard → Project Settings → API

### 3. Setup Database

**Option A - SQL Editor (Recommended):**
1. Open Supabase Dashboard → SQL Editor
2. Copy contents of `supabase/schemas/schema.sql`
3. Paste and click **Run**

**Option B - CLI:**
```bash
supabase db push
```

### 4. Seed Data

```bash
cd supabase/scripts
npm install
node seed_assessments.js
```

This adds autism assessment questionnaires (AQ-10 and CAT-Q).

### 5. Deploy Edge Function

```bash
cd supabase/functions
supabase functions deploy evaluate-assessments
```

This deploys the assessment evaluation function that calculates scores and stores results.

---

**Troubleshooting:**
- "Invalid API key" → Use `service_role` key, not `anon` key
- "supabaseKey is required" → Check `.env` file location and format

## Patient App Setup

Navigate to the patient app directory:

```sh
cd patient
```

Install dependencies:

```sh
flutter pub get
```

Run the app:

```sh
flutter run
```

## Therapist App Setup

Navigate to the therapist app directory:

```sh
cd therapist
```

Install dependencies:

```sh
flutter pub get
```

Run the app:

```sh
flutter run
```

## **Supabase and Google Cloud Console Setup Guide**  

Follow these steps to set up **Supabase** and **Google Cloud Console** for authentication.  

---

### **1. Supabase Setup**  

#### **Step 1: Sign Up & Create a Project**  
- Go to [Supabase](https://supabase.com), sign up/log in, and create a **New Project**.  
- Set a **Project Name** and **Database Password** (store it securely).  

#### **Step 2: Retrieve API Keys**  
- In **Project Settings > API**, find:  
  - **SUPABASE_URL** (Project URL)  
  - **SUPABASE_ANON_KEY** (use the anon public key)  

---

### **2. Google Cloud Console Setup**  

#### **Step 1: Sign Up & Create a Project**  
- Visit [Google Cloud Console](https://console.cloud.google.com/), sign in, and create a **New Project**.  

#### **Step 2: Enable Google OAuth**  
1. Go to **APIs & Services > Credentials > + CREATE CREDENTIALS > OAuth Client ID**.  
2. Configure **OAuth Consent Screen** (set App Name, Email, and add scopes: `email`, `profile`, `openid`).  
3. Choose **Web Application**, and under:  
   - **Authorized JavaScript Origins**, enter your **Supabase URL**.
     
     ```
     https://your-project-id.supabase.co
     ```  
   - **Authorized Redirect URIs**, add:  

     ```
     https://your-project-id.supabase.co/auth/v1/callback
     ```  
4. Click **Create** to get the **Client ID** and **Client Secret**.  
5. Go to **OAuth Consent Screen > Test Users** and **add your email**.  

#### Note: Replace your-project-id with your project id from Supabase: Project Settings (Left panel) -> Project Id

---

### **3. Connect Supabase & Google OAuth**  

- In **Supabase Dashboard > Authentication > Providers**, enable **Google**.  
- Enter **Client ID** and **Client Secret** from Google Cloud Console.  
- Click **Save**.  

---

### **4. Environment Variables Setup**  

Create a `.env` file in your project root and add:  

```sh
# Supabase Credentials
SUPABASE_URL=your_project_url
SUPABASE_ANON_KEY=your_anon_key

# Google OAuth Credentials
GOOGLE_WEB_CLIENT_ID=your_web_client_id
GOOGLE_SECRET_KEY=your_secret_key
```

Replace placeholders with actual values from **Supabase** and **Google Cloud Console**.  

---

## **5. Testing the Setup**  

- Start your app and test Google authentication.  
- Check **Supabase > Authentication > Users** to verify logins.


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

