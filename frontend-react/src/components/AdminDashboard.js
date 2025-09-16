// src/components/AdminDashboard.js
import React, { useEffect, useState } from "react";
import { supabase } from "../supabaseClient";
import { useNavigate } from "react-router-dom";

export default function AdminDashboard() {
  const [issues, setIssues] = useState([]);
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    total: 0,
    unassigned: 0,
    assigned: 0,
    resolved: 0,
  });
  const navigate = useNavigate();

  // Fetch all issues for summary + list
  const fetchAllIssues = async () => {
    setLoading(true);
    const { data, error } = await supabase.from("issues").select("*");

    if (error) {
      console.error("Error fetching issues:", error);
    } else {
      setIssues(data);

      // calculate stats
      const unassigned = data.filter((i) => !i.assigned_to).length;
      const assigned = data.filter((i) => i.assigned_to && i.status !== "resolved").length;
      const resolved = data.filter((i) => i.status === "resolved").length;

      setStats({
        total: data.length,
        unassigned,
        assigned,
        resolved,
      });
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchAllIssues();
  }, []);

  if (loading) return <p>Loading dashboard...</p>;

  return (
    <div style={{ padding: "20px" }}>
      <h1>Admin Dashboard</h1>

      {/* Quick stats */}
      <div style={{ marginBottom: "20px" }}>
        <h3>Summary</h3>
        <p>Total Issues: {stats.total}</p>
        <p>Unassigned Issues: {stats.unassigned}</p>
        <p>Assigned Issues: {stats.assigned}</p>
        <p>Resolved Issues: {stats.resolved}</p>
      </div>

      {/* Buttons */}
      <div style={{ marginBottom: "20px" }}>
        <button
          style={{ padding: "10px", cursor: "pointer", marginRight: "10px" }}
          onClick={() => navigate("/new-issues")}
        >
          View New Issues
        </button>
        <button
          style={{ padding: "10px", cursor: "pointer", marginRight: "10px" }}
          onClick={() => navigate("/review")}
        >
          Review Resolved Issues
        </button>
        <button
          style={{ padding: "10px", cursor: "pointer" }}
          onClick={() => navigate("/feedback")}
        >
          User Feedback
        </button>
      </div>

      {/* List all issues */}
      <h2>All Issues</h2>
      {issues.length === 0 ? (
        <p>No issues found.</p>
      ) : (
        <ul>
          {issues.map((issue) => (
            <li
              key={issue.id}
              style={{
                border: "1px solid gray",
                padding: "10px",
                margin: "10px 0",
                cursor: "pointer",
              }}
              onClick={() => navigate(`/issues/${issue.id}`)}
            >
              <h3>{issue.title}</h3>
              {issue.image_url && (
                <img
                  src={issue.image_url}
                  alt="issue proof"
                  width={400}
                  style={{ display: "block", marginTop: "10px" }}
                />
              )}
              <p>{issue.description}</p>
              <p>Location: {issue.location}</p>
              <p>Status: {issue.status}</p>
              <p>
                Assigned To:{" "}
                {issue.assigned_to ? issue.assigned_to : "Not assigned"}
              </p>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
