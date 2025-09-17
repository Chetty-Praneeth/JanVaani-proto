-- Enable RLS
alter table profiles enable row level security;
alter table issues enable row level security;

-- Profiles policies
create policy "Citizen can view own profile" on profiles
for select using (auth.uid() = id);

create policy "Admin can view all profiles" on profiles
for select using (exists (select 1 from profiles where id = auth.uid() and role = 'admin'));

-- Issues policies
create policy "Citizen can insert own issues" on issues
for insert with check (created_by = auth.uid());

create policy "Citizen can view own issues" on issues
for select using (created_by = auth.uid());

create policy "Staff can view assigned issues" on issues
for select using (assigned_to = auth.uid());

create policy "Staff can update status/proof" on issues
for update using (assigned_to = auth.uid()) with check (assigned_to = auth.uid());

create policy "Admin can view all issues" on issues
for select using (exists (select 1 from profiles where id = auth.uid() and role = 'admin'));

create policy "Admin can assign staff" on issues
for update using (exists (select 1 from profiles where id = auth.uid() and role = 'admin'));
