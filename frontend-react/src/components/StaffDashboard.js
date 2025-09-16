// src/components/StaffDashboard.js
import React, { useEffect, useState } from "react";
import { supabase } from "../supabaseClient";

export default function StaffDashboard() {
  const [issues, setIssues] = useState([]);
  const [loading, setLoading] = useState(true);

  const fetchAssignedIssues = async () => {
    setLoading(true);
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) return;

    const { data, error } = await supabase
      .from("issues")
      .select("*")
      .eq("assigned_to", user.id);

    if (error) {
      console.error("Error fetching staff issues:", error);
    } else {
      setIssues(data);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchAssignedIssues();
  }, []);

  if (loading) return <p>Loading your assigned issues...</p>;
  if (!issues.length) return <p>No new issues assigned to you.</p>;

  return (
    <div style={{ padding: "20px" }}>
      <h2>My Assigned Issues</h2>
      <ul>
        {issues.map((issue) => (
          <li key={issue.id} style={{ border: "1px solid gray", padding: "10px", margin: "10px 0" }}>
            <h3>{issue.title}</h3>
            <p>{issue.description}</p>
            <p>Location: {issue.location}</p>
            <p>Status: {issue.status}</p>
          </li>
        ))}
      </ul>
    </div>
  );
}
