// src/components/StaffResolvedIssueDetails.js
import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { supabase } from '../supabaseClient';

export default function StaffResolvedIssueDetails() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [issue, setIssue] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchIssue = async () => {
      setLoading(true);
      try {
        const { data, error } = await supabase
          .from('issues')
          .select('*')
          .eq('id', id)
          .single();

        if (error) {
          console.error('Error fetching issue:', error);
          setLoading(false);
          return;
        }

        setIssue(data);
      } catch (err) {
        console.error('Unexpected error:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchIssue();
  }, [id]);

  if (loading) return <p>Loading issue details...</p>;
  if (!issue) return <p>Issue not found or you don’t have permission to view it.</p>;

  return (
    <div style={{ padding: 20 }}>
      <button
        onClick={() => navigate('/staff/resolved-issues')}
        style={{
          marginBottom: 20,
          padding: 10,
          backgroundColor: 'grey',
          color: 'white',
          border: 'none',
          borderRadius: 5,
          cursor: 'pointer'
        }}
      >
        Back to Resolved Issues
      </button>

      <h2>{issue.title}</h2>
      <p><strong>ID:</strong> {issue.id}</p>
      <p><strong>Description:</strong> {issue.description}</p>
      <p><strong>Location:</strong> {issue.location}</p>
      <p><strong>Status:</strong> {issue.status}</p>
      <p><strong>Assigned To:</strong> {issue.assigned_to}</p>
      <p><strong>Created At:</strong> {new Date(issue.created_at).toLocaleString()}</p>
      <p><strong>Updated At:</strong> {new Date(issue.updated_at).toLocaleString()}</p>

      {issue.image_url && (
        <div style={{ marginTop: 10 }}>
          <p><strong>Reported Image:</strong></p>
          <img src={issue.image_url} alt="Issue" style={{ maxWidth: 500, borderRadius: 5 }} />
        </div>
      )}

      {issue.proof_url && (
        <div style={{ marginTop: 10 }}>
          <p><strong>Proof of Completion:</strong></p>
          <img src={issue.proof_url} alt="Proof" style={{ maxWidth: 500, borderRadius: 5 }} />
        </div>
      )}

      {/* Add any other columns that staff are allowed to view */}
      {issue.comments && (
        <p><strong>Comments:</strong> {issue.comments}</p>
      )}
    </div>
  );
}
