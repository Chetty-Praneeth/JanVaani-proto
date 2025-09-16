import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { supabase } from '../supabaseClient';

export default function IssueDetailsPage() {
  const { id } = useParams();
  const [issue, setIssue] = useState(null);
  const [staffList, setStaffList] = useState([]);
  const [selectedStaff, setSelectedStaff] = useState('');

  // Fetch issue
  useEffect(() => {
    const fetchIssue = async () => {
      const { data, error } = await supabase
        .from('issues')
        .select('*')
        .eq('id', id)
        .single();

      if (error) console.error('Error fetching issue:', error);
      else setIssue(data);
    };

    fetchIssue();
  }, [id]);

  // Fetch all staff from profiles table
  useEffect(() => {
  const fetchStaff = async () => {
    const { data, error } = await supabase
      .from('profiles')
      .select('id, name, area')
      .eq('role', 'staff');

    console.log('Fetched staff:', data, error);
    if (error) console.error('Error fetching staff:', error);
    else setStaffList(data);
  };

  fetchStaff();
}, []);


  const handleAssign = async () => {
    if (!selectedStaff) return alert('Select a staff member!');

    const { error } = await supabase
      .from('issues')
      .update({ assigned_to: selectedStaff, status: 'Acknowledged' })
      .eq('id', id);

    if (error) console.error('Error updating issue:', error);
    else alert('Staff assigned and status updated!');
  };

  if (!issue) return <p>Loading issue...</p>;

  return (
    <div style={{ padding: '20px' }}>
      <h2>{issue.title}</h2>
      {issue.image_url && (
        <img
          src={issue.image_url}
          alt="issue proof"
          style={{ maxWidth: 500, height: 'auto', marginBottom: '20px' }}
        />
      )}

      <p><strong>Description:</strong> {issue.description}</p>
      <p><strong>Location:</strong> {issue.location}</p>
      <p><strong>Status:</strong> {issue.status}</p>
      <p><strong>Created by:</strong> {issue.created_by}</p>

      <div style={{ marginTop: '20px' }}>
        <label>
          <strong>Assign to staff:</strong>{' '}
        </label>
        <select
          value={selectedStaff}
          onChange={(e) => setSelectedStaff(e.target.value)}
          style={{ marginRight: '10px' }}
        >
          <option value="">Select Staff</option>
          {staffList.map((staff) => (
            <option key={staff.id} value={staff.id}>
              {staff.name} ({staff.area})
            </option>
          ))}
        </select>
        <button onClick={handleAssign}>Assign & Acknowledge</button>
      </div>
    </div>
  );
}
