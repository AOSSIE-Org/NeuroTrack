require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');
const { v4: uuidv4 } = require('uuid');

// Validate required environment variables
const { SUPABASE_URL, SUPABASE_KEY } = process.env;
if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error('Missing required environment variables: SUPABASE_URL and SUPABASE_KEY');
  console.error('Please check your .env file and ensure these variables are set.');
  process.exit(1);
}

// Dev credentials - can be overridden via environment for security
const DEV_EMAIL = process.env.DEV_EMAIL || 'testdev@neurotrack.dev';
const DEV_PASSWORD = process.env.DEV_PASSWORD || 'TestDev123!';

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

function isoAtLocalMidday(date) {
  const d = new Date(date.getFullYear(), date.getMonth(), date.getDate(), 12, 0, 0);
  return d.toISOString();
}

async function getOrCreateDevUser() {
  const { data, error } = await supabase.auth.admin.listUsers();
  if (error) throw new Error(`listUsers failed: ${error.message}`);

  const existing = data.users.find((u) => u.email === DEV_EMAIL);
  if (existing) return existing;

  const { data: created, error: createError } = await supabase.auth.admin.createUser({
    email: DEV_EMAIL,
    password: DEV_PASSWORD,
    email_confirm: true,
  });
  if (createError) throw new Error(`createUser failed: ${createError.message}`);
  return created.user;
}

async function upsertPatient(user) {
  const payload = {
    id: user.id,
    patient_name: 'Dev User',
    age: 22,
    is_adult: true,
    phone: '9999999999',
    email: DEV_EMAIL,
    gender: 'other',
    country: 'India',
    onboarded_on: new Date().toISOString(),
  };

  const { error } = await supabase.from('patient').upsert(payload, { onConflict: 'id' });
  if (error) throw new Error(`upsert patient failed: ${error.message}`);
}

async function seedReportsForPatient(patientId) {
  // Reset only report-related demo rows for deterministic local tests.
  const { error: delLogsErr } = await supabase.from('daily_activity_logs').delete().eq('patient_id', patientId);
  if (delLogsErr) throw new Error(`delete daily_activity_logs failed: ${delLogsErr.message}`);

  const { error: delActErr } = await supabase.from('daily_activities').delete().eq('patient_id', patientId);
  if (delActErr) throw new Error(`delete daily_activities failed: ${delActErr.message}`);

  const { error: delGoalErr } = await supabase.from('therapy_goal').delete().eq('patient_id', patientId);
  if (delGoalErr) throw new Error(`delete therapy_goal failed: ${delGoalErr.message}`);

  const activityRows = [
    {
      id: uuidv4(),
      activity_name: 'Morning Communication Practice',
      activity_list: [
        { id: uuidv4(), activity: 'Eye contact for 10 seconds', is_completed: true },
        { id: uuidv4(), activity: 'Name response in 3 tries', is_completed: true },
      ],
      is_active: true,
      patient_id: patientId,
    },
    {
      id: uuidv4(),
      activity_name: 'Sensory Regulation Routine',
      activity_list: [
        { id: uuidv4(), activity: 'Breathing set', is_completed: true },
        { id: uuidv4(), activity: 'Weighted blanket 15 min', is_completed: false },
      ],
      is_active: true,
      patient_id: patientId,
    },
    {
      id: uuidv4(),
      activity_name: 'Social Story Review',
      activity_list: [
        { id: uuidv4(), activity: 'Read social story', is_completed: true },
        { id: uuidv4(), activity: 'Answer 3 follow-up questions', is_completed: true },
      ],
      is_active: true,
      patient_id: patientId,
    },
  ];

  const { error: activityError } = await supabase.from('daily_activities').insert(activityRows);
  if (activityError) throw new Error(`insert daily_activities failed: ${activityError.message}`);

  const today = new Date();
  // Dates spread across the month PLUS today so screens show data immediately
  const logDates = [
    new Date(today.getFullYear(), today.getMonth(), Math.max(1, today.getDate() - 6)),
    new Date(today.getFullYear(), today.getMonth(), Math.max(1, today.getDate() - 3)),
    new Date(today.getFullYear(), today.getMonth(), Math.max(1, today.getDate() - 1)),
    today, // always include today so getTodayActivities finds a log
  ];

  const logs = [
    {
      id: uuidv4(),
      activity_id: activityRows[0].id,
      patient_id: patientId,
      date: isoAtLocalMidday(logDates[0]),
      activity_items: activityRows[0].activity_list,
    },
    {
      id: uuidv4(),
      activity_id: activityRows[1].id,
      patient_id: patientId,
      date: isoAtLocalMidday(logDates[1]),
      activity_items: activityRows[1].activity_list,
    },
    {
      id: uuidv4(),
      activity_id: activityRows[2].id,
      patient_id: patientId,
      date: isoAtLocalMidday(logDates[2]),
      activity_items: activityRows[2].activity_list,
    },
    // Today's log — makes Daily Activities screen show data on first open
    {
      id: uuidv4(),
      activity_id: activityRows[0].id,
      patient_id: patientId,
      date: isoAtLocalMidday(logDates[3]),
      activity_items: activityRows[0].activity_list,
    },
  ];

  const { error: logsError } = await supabase.from('daily_activity_logs').insert(logs);
  if (logsError) throw new Error(`insert daily_activity_logs failed: ${logsError.message}`);

  // Therapy goals: one older entry + one for TODAY so getTherapyGoals(today) finds data
  const { error: oldGoalError } = await supabase.from('therapy_goal').insert({
    id: uuidv4(),
    patient_id: patientId,
    performed_on: isoAtLocalMidday(logDates[2]),
    regressions: [
      { id: uuidv4(), name: 'Eye contact dropped during transitions' },
      { id: uuidv4(), name: 'Delayed response to verbal cue' },
    ],
  });
  if (oldGoalError) throw new Error(`insert therapy_goal (old) failed: ${oldGoalError.message}`);

  const { error: goalError } = await supabase.from('therapy_goal').insert({
    id: uuidv4(),
    patient_id: patientId,
    performed_on: isoAtLocalMidday(today),
    goals: [
      { id: uuidv4(), name: 'Improve eye contact duration' },
      { id: uuidv4(), name: 'Respond to name within 2 tries' }
    ],
    observations: [
      { id: uuidv4(), name: 'Patient showed progress in structured settings' }
    ],
    regressions: [
      { id: uuidv4(), name: 'Distraction in noisy environments' },
    ],
    activities: activityRows.map(a => ({ id: uuidv4(), name: a.activity_name })),
  });
  if (goalError) throw new Error(`insert therapy_goal (today) failed: ${goalError.message}`);
}

(async () => {
  try {
    const user = await getOrCreateDevUser();
    await upsertPatient(user);
    await seedReportsForPatient(user.id);

    const [activities, logs, goals] = await Promise.all([
      supabase.from('daily_activities').select('id', { count: 'exact', head: true }).eq('patient_id', user.id),
      supabase.from('daily_activity_logs').select('id', { count: 'exact', head: true }).eq('patient_id', user.id),
      supabase.from('therapy_goal').select('id', { count: 'exact', head: true }).eq('patient_id', user.id),
    ]);

    console.log(JSON.stringify({
      email: DEV_EMAIL,
      userId: user.id,
      dailyActivities: activities.count ?? 0,
      dailyActivityLogs: logs.count ?? 0,
      therapyGoals: goals.count ?? 0,
    }, null, 2));
  } catch (error) {
    console.error(error.message || error);
    process.exit(1);
  }
})();
