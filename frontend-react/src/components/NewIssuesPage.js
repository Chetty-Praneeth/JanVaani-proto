import React, { useEffect, useState } from 'react';
import { supabase } from '../supabaseClient';
import { useNavigate } from 'react-router-dom';

export default function NewIssuesPage() {
  const [issues, setIssues] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  // Fetch unassigned issues
  const fetchUnassignedIssues = async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from('issues')
      .select('*')
      .is('assigned_to', null); // only unassigned

    if (error) {
      console.error('Error fetching issues:', error);
    } else {
      setIssues(data);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchUnassignedIssues();
  }, []);

  if (loading) return <p>Loading issues...</p>;
  if (!issues.length) return <p>No unassigned issues found.</p>;

  return (
    <div>
      <h2>New Unassigned Issues</h2>
      <ul>
        {issues.map(issue => (
          <li
            key={issue.id}
            style={{
              border: '1px solid gray',
              padding: '10px',
              margin: '10px 0',
              cursor: 'pointer'
            }}
            onClick={() => navigate(`/issues/${issue.id}`)}
          >
            <h3>{issue.title}</h3>
            {issue.image_url && (
                <img
                    src={issue.image_url}
                    alt="issue proof"
                    width={500}
                />
            )}

            <p>{issue.description}</p>
            <p>Location: {issue.location}</p>
            <p>Status: {issue.status}</p>
          </li>
        ))}
      </ul>
    </div>
  );
}
