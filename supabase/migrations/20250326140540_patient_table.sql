-- Create patient table if it does not exist
CREATE TABLE IF NOT EXISTS public.patient (
  patient_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_name TEXT NOT NULL,
  age INT NOT NULL,
  is_adult BOOLEAN NOT NULL,
  phone_no TEXT NOT NULL,
  email TEXT NOT NULL,
  guardian_name TEXT,
  guardian_relation TEXT,
  gender TEXT,
  country TEXT,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Enable Row-Level Security (RLS) AFTER the table exists
ALTER TABLE public.patient ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to read their own data
CREATE POLICY "Allow authenticated users to read"
ON public.patient FOR SELECT
USING (auth.uid() IS NOT NULL);

-- Allow authenticated users to insert their own data
CREATE POLICY "Allow authenticated users to insert"
ON public.patient FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL);

-- Allow users to update only their own data
CREATE POLICY "Allow users to update their own data"
ON public.patient FOR UPDATE
USING (auth.uid() = user_id);

-- Allow users to delete only their own data
CREATE POLICY "Allow users to delete their own data"
ON public.patient FOR DELETE
USING (auth.uid() = user_id);
