// src/components/StaffDashboard.js
import React, { useEffect, useState } from "react";
import { supabase } from "../supabaseClient";
import { useNavigate } from "react-router-dom";

export default function StaffDashboard() {
  const [issues, setIssues] = useState([]);
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchUserAndIssues = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        navigate("/"); // go to login if not logged in
        return;
      }
      setUser(user);

      const { data, error } = await supabase
        .from("issues")
        .select("*")
        .eq("assigned_to", user.id)
        .is("proof_url", null); // only uncompleted

      if (error) console.error("Error fetching staff issues:", error);
      else setIssues(data);

      setLoading(false);
    };

    fetchUserAndIssues();
  }, [navigate]);

  const handleLogout = async () => {
    await supabase.auth.signOut();
    navigate("/"); // redirect to login
  };

  if (!user) return null; // render nothing while checking auth
  if (loading) return <p>Loading your assigned issues...</p>;

  return (
    <div style={{ display: "flex", minHeight: "100vh" }}>
      {/* Side Nav */}
      <div
        style={{
          width: "200px",
          backgroundColor: "#f0f0f0",
          padding: "20px",
          display: "flex",
          flexDirection: "column",
          gap: "15px"
        }}
      >
        <button
          onClick={() => navigate("/staff/resolved-issues")}
          style={{
            padding: "10px",
            backgroundColor: "grey",
            color: "white",
            border: "none",
            borderRadius: "5px",
            cursor: "pointer"
          }}
        >
          View My Resolved Issues
        </button>

        <button
          onClick={async () => {
          await supabase.auth.signOut();
          navigate("/login"); // go to login page
        }}
        style={{
          padding: "10px",
          backgroundColor: "grey",
          color: "white",
          border: "none",
          borderRadius: "5px",
          cursor: "pointer"
        }}
      >
        Logout
      </button>

      </div>

      {/* Main Content */}
      <div style={{ flex: 1, padding: "20px" }}>
        <h2>My Assigned Issues</h2>
        {issues.length === 0 ? (
          <p>No new issues assigned to you.</p>
        ) : (
          <ul>
            {issues.map((issue) => (
              <li
                key={issue.id}
                style={{
                  border: "1px solid gray",
                  padding: "10px",
                  margin: "10px 0",
                  cursor: "pointer"
                }}
                onClick={() => navigate(`/staff/issues/${issue.id}`)}
              >
                {issue.image_url && (
                  <img
                    src={issue.image_url}
                    alt="issue proof"
                    style={{ maxWidth: "500px", height: "auto", marginBottom: "10px" }}
                  />
                )}
                <h3>{issue.title}</h3>
                <p>{issue.description}</p>
                <p>Location: {issue.location}</p>
                <p>Status: {issue.status}</p>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}
