import React, { useEffect, useState } from "react";
import { supabase } from "../supabaseClient";

export default function StaffResolvedIssues() {
  const [issues, setIssues] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchResolved = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      const { data, error } = await supabase
        .from("issues")
        .select("*")
        .eq("assigned_to", user.id)
        .eq("status", "Resolved");

      if (error) console.error(error);
      else setIssues(data);

      setLoading(false);
    };

    fetchResolved();
  }, []);

  if (loading) return <p>Loading resolved issues...</p>;
  if (!issues.length) return <p>No resolved issues yet.</p>;

  return (
    <div style={{ padding: "20px" }}>
      <h2>Resolved Issues</h2>
      <ul>
        {issues.map((issue) => (
          <li key={issue.id} style={{ border: "1px solid gray", padding: "10px", margin: "10px 0" }}>
            <h3>{issue.title}</h3>
            <p>{issue.description}</p>
            {issue.resolved_image_url && <img src={issue.resolved_image_url} alt="resolved proof" width={400} />}
          </li>
        ))}
      </ul>
    </div>
  );
}
