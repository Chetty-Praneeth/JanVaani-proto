// src/components/ReviewResolvedIssues.js
import React, { useEffect, useState } from 'react';
import { supabase } from '../supabaseClient';

export default function ReviewResolvedIssues() {
  const [issues, setIssues] = useState([]);
  const [loading, setLoading] = useState(true);

  // Fetch all resolved issues
  const fetchResolvedIssues = async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from('issues')
      .select('*') // fetch all columns including image_url and proof_url
      .eq('status', 'resolved')
      .order('updated_at', { ascending: false });

    if (error) console.error('Error fetching resolved issues:', error);
    else setIssues(data);

    setLoading(false);
  };

  useEffect(() => {
    fetchResolvedIssues();
  }, []);

  // Function to mark the issue as verified
  const handleMarkVerified = async (issueId) => {
    const { error } = await supabase
      .from('issues')
      .update({ status: 'verified' }) // change status to 'verified'
      .eq('id', issueId);

    if (error) {
      console.error('Failed to mark issue as verified:', error);
      alert('Failed to mark issue. Try again.');
    } else {
      alert('Issue marked as verified!');
      fetchResolvedIssues(); // refresh the list after update
    }
  };

  if (loading) return <p>Loading resolved issues for review...</p>;
  if (!issues.length) return <p>No resolved issues pending review.</p>;

  return (
    <div style={{ padding: 20 }}>
      <h2>Review Resolved Issues</h2>
      <ul>
        {issues.map(issue => (
          <li key={issue.id} style={{ marginBottom: 20, borderBottom: '1px solid #ccc', paddingBottom: 10 }}>
            <strong>{issue.title}</strong> - {issue.location}
            <p>Description: {issue.description}</p>
            <p>Status: {issue.status}</p>
            <p>Assigned To: {issue.assigned_to ? issue.assigned_to : 'Not assigned'}</p>

            {/* Original issue image */}
            {issue.image_url && (
              <div>
                <p>Issue Image:</p>
                <img src={issue.image_url} alt="issue" style={{ maxWidth: 300, marginTop: 5, borderRadius: 5 }} />
              </div>
            )}

            {/* Proof submitted by staff */}
            {issue.proof_url && (
              <div>
                <p>Proof Submitted:</p>
                <img src={issue.proof_url} alt="proof" style={{ maxWidth: 300, marginTop: 5, borderRadius: 5 }} />
              </div>
            )}

            <button 
              style={{ marginTop: 10, padding: '8px 12px', cursor: 'pointer' }}
              onClick={() => handleMarkVerified(issue.id)}
            >
              Mark as Verified
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}
