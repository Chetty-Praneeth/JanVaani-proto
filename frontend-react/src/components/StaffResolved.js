// src/components/StaffResolved.js
import React, { useEffect, useState } from 'react';
import { supabase } from '../supabaseClient';
import { useNavigate } from 'react-router-dom';

export default function StaffResolved() {
  const [issues, setIssues] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchResolvedIssues = async () => {
      setLoading(true);
      try {
        const { data: { user }, error: userError } = await supabase.auth.getUser();
        if (userError || !user) {
          console.error('User not logged in or error fetching user:', userError);
          setLoading(false);
          return;
        }

        const { data, error } = await supabase
          .from('issues')
          .select('*')
          .eq('assigned_to', user.id)
          .not('proof_url', 'is', null) // only issues with proof
          .order('updated_at', { ascending: false });

        if (error) console.error('Error fetching resolved issues:', error);
        else setIssues(data);
      } catch (err) {
        console.error('Unexpected error:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchResolvedIssues();
  }, []);

  if (loading) return <p>Loading resolved issues...</p>;

  return (
    <div style={{ padding: 20 }}>
      <h2>Issues I Resolved</h2>
      {issues.length === 0 ? (
        <p>No resolved issues yet.</p>
      ) : (
        <ul>
          {issues.map(issue => (
            <li
              key={issue.id}
              style={{
                marginBottom: 20,
                borderBottom: '1px solid #ccc',
                paddingBottom: 10,
                cursor: 'pointer'
              }}
              onClick={() => navigate(`/staff/resolved-issues/${issue.id}`)} // navigate to details page
            >
              <strong>{issue.title}</strong> - {issue.location}
              <p>Status: {issue.status}</p>
              {issue.proof_url && (
                <div>
                  <img
                    src={issue.proof_url}
                    alt="proof"
                    style={{ maxWidth: 300, marginTop: 5, borderRadius: 5 }}
                  />
                </div>
              )}
              <p style={{ fontSize: 12, color: 'gray' }}>
                Updated at: {new Date(issue.updated_at).toLocaleString()}
              </p>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
