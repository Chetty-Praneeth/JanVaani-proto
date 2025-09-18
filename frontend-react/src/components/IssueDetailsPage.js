import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { supabase } from '../supabaseClient';

export default function IssueDetailsPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [issue, setIssue] = useState(null);
  const [staff, setStaff] = useState(null); // single staff
  const [selectedStaff, setSelectedStaff] = useState(''); // start empty

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

  // Fetch the single staff
  useEffect(() => {
    const fetchStaff = async () => {
      const { data, error } = await supabase
        .from('profiles')
        .select('id, name')
        .eq('role', 'staff')
        .limit(1)
        .single();

      if (error) console.error('Error fetching staff:', error);
      else setStaff(data);
    };

    fetchStaff();
  }, []);

  const handleAssign = async () => {
    if (!selectedStaff) return alert("Please select a staff member");

    const { error } = await supabase
      .from('issues')
      .update({ assigned_to: selectedStaff })
      .eq('id', id);

    if (error) console.error('Failed to assign staff:', error);
    else {
      alert('Staff assigned successfully!');
      navigate('/admin'); // redirect back to admin dashboard
    }
  };

  if (!issue || !staff) return <p>Loading issue...</p>;

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
      <p><strong>Category:</strong> {issue.category || 'Not set'}</p>
      <p><strong>Additional Information:</strong> {issue.additional_information || 'None'}</p>
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
          <option value={staff.id}>{staff.name}</option>
        </select>
        <button onClick={handleAssign}>Assign</button>
      </div>
    </div>
  );
}
