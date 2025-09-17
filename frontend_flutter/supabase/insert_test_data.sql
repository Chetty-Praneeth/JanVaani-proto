-- Test profiles
insert into profiles (id, name, role) values
('ADMIN_UUID', 'Admin User', 'admin'),
('STAFF_UUID', 'Staff User', 'staff'),
('CITIZEN_UUID', 'Citizen User', 'citizen');

-- Test issues
insert into issues (title, description, location, status, created_by, assigned_to, image_url, proof_url) values
(
  'Broken Streetlight',    -- unassigned
  'The streetlight near park is broken.',
  'Park Street',
  'open',
  'CITIZEN_UUID',
  NULL,
  'https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png',
  NULL
),
(
  'Pothole on Main Road',  -- assigned
  'Large pothole causing traffic issues.',
  'Main Road',
  'open',
  'CITIZEN_UUID',
  'STAFF_UUID',
  'https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png',
  NULL
);
