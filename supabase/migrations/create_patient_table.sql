-- Create patient table if it does not exist
CREATE TABLE IF NOT EXISTS public.patient (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT now(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Enable Row-Level Security (RLS) on the table
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