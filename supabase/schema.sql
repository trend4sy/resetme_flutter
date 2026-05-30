-- ResetMe Database Schema for Supabase

-- Profiles table (extends Supabase Auth)
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  email text,
  is_premium boolean default false,
  onboarding_completed boolean default false,
  primary_goal text,
  worst_time text,
  daily_commitment_minutes int default 5,
  top_stress_cause text,
  bedtime text,
  preferred_style text,
  dark_mode boolean default false,
  language text default 'ar',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can insert own profile"
  on public.profiles for insert
  with check (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Mood entries table
create table public.mood_entries (
  id text primary key,
  user_id uuid references auth.users on delete cascade not null,
  date_time timestamptz not null,
  mood_level int not null check (mood_level between 1 and 5),
  stress_level int not null check (stress_level between 1 and 10),
  sleep_quality int check (sleep_quality between 1 and 10),
  cause text default 'غير معروف',
  note text,
  created_at timestamptz default now()
);

alter table public.mood_entries enable row level security;

create policy "Users can view own mood entries"
  on public.mood_entries for select
  using (auth.uid() = user_id);

create policy "Users can insert own mood entries"
  on public.mood_entries for insert
  with check (auth.uid() = user_id);

create policy "Users can update own mood entries"
  on public.mood_entries for update
  using (auth.uid() = user_id);

create index mood_entries_user_date_idx on public.mood_entries(user_id, date_time desc);

-- Journal entries table
create table public.journal_entries (
  id text primary key,
  user_id uuid references auth.users on delete cascade not null,
  date_time timestamptz not null,
  type text not null check (type in ('venting', 'gratitude')),
  content text not null,
  created_at timestamptz default now()
);

alter table public.journal_entries enable row level security;

create policy "Users can view own journal entries"
  on public.journal_entries for select
  using (auth.uid() = user_id);

create policy "Users can insert own journal entries"
  on public.journal_entries for insert
  with check (auth.uid() = user_id);

create policy "Users can update own journal entries"
  on public.journal_entries for update
  using (auth.uid() = user_id);

create index journal_entries_user_date_idx on public.journal_entries(user_id, date_time desc);

-- Subscriptions table
create table public.subscriptions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null unique,
  plan text not null check (plan in ('monthly', 'yearly', 'family')),
  status text not null default 'active' check (status in ('active', 'cancelled', 'expired')),
  started_at timestamptz not null default now(),
  expires_at timestamptz,
  revenuecat_id text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.subscriptions enable row level security;

create policy "Users can view own subscription"
  on public.subscriptions for select
  using (auth.uid() = user_id);

-- App config table (remote feature flags)
create table public.app_config (
  id serial primary key,
  key text unique not null,
  value jsonb not null,
  updated_at timestamptz default now()
);

insert into public.app_config (key, value) values
  ('feature_flags', '{
    "journal_gratitude": false,
    "weekly_analytics_advanced": false,
    "ai_assistant": false,
    "ai_insights": false,
    "ai_reframe": false,
    "premium_sounds": false
  }'::jsonb),
  ('app_settings', '{
    "max_free_meditations": 4,
    "max_free_sounds": 1,
    "free_venting_enabled": true
  }'::jsonb);

-- Auth trigger: create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email);
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Function to get weekly analytics
create or replace function public.get_weekly_analysis(p_user_id uuid, p_week_start date)
returns jsonb as $$
declare
  result jsonb;
begin
  select jsonb_build_object(
    'avg_stress', round(avg(m.stress_level)::numeric, 1),
    'avg_mood', round(avg(m.mood_level)::numeric, 1),
    'avg_sleep_quality', round(avg(m.sleep_quality)::numeric, 1),
    'most_common_cause', (
      select cause from public.mood_entries m2
      where m2.user_id = p_user_id
        and m2.date_time >= p_week_start
        and m2.date_time < p_week_start + interval '7 days'
      group by cause
      order by count(*) desc
      limit 1
    ),
    'entry_count', count(*)
  )
  into result
  from public.mood_entries m
  where m.user_id = p_user_id
    and m.date_time >= p_week_start
    and m.date_time < p_week_start + interval '7 days';

  return result;
end;
$$ language plpgsql security definer;
