-- Profiles table for roles
create table if not exists profiles (
    id uuid references auth.users(id) primary key,
    name text,
    role text check (role in ('citizen', 'staff', 'admin')) not null default 'citizen',
    created_at timestamp default now()
);

-- Issues table
create table if not exists issues (
    id bigserial primary key,
    title text not null,
    description text,
    location text,
    status text check (status in ('open', 'in_process', 'resolved')) default 'open',
    created_by uuid references auth.users(id) not null,
    assigned_to uuid references auth.users(id),
    image_url text,       -- citizen uploaded image
    proof_url text,       -- staff uploaded proof
    created_at timestamp default now(),
    updated_at timestamp default now()
);
