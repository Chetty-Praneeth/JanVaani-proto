// src/components/StaffIssueDetailsPage.js
import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../supabaseClient";

export default function StaffIssueDetailsPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [issue, setIssue] = useState(null);
  const [imageFile, setImageFile] = useState(null);
  const [loading, setLoading] = useState(true);

  // Fetch issue
  useEffect(() => {
    const fetchIssue = async () => {
      const { data, error } = await supabase
        .from("issues")
        .select("*")
        .eq("id", id)
        .single();
      if (error) console.error(error);
      else setIssue(data);
      setLoading(false);
    };

    fetchIssue();
  }, [id]);

  const handleUpload = async () => {
    if (!imageFile) return alert("Please select an image!");

    const fileExt = imageFile.name.split(".").pop();
    const fileName = `${id}.${fileExt}`;
    const filePath = `staff_completed/${fileName}`;

    // Upload to Supabase Storage
    const { data, error: uploadError } = await supabase.storage
      .from("completed_issues")
      .upload(filePath, imageFile, { upsert: true });

    if (uploadError) return console.error(uploadError);

    // Get public URL
    const { data: { publicUrl } } = supabase
      .storage
      .from("completed_issues")
      .getPublicUrl(filePath);

    // Update issue as resolved
    const { error } = await supabase
      .from("issues")
      .update({ status: "Resolved", resolved_image_url: publicUrl })
      .eq("id", id);

    if (error) console.error(error);
    else {
      alert("Issue marked as resolved!");
      navigate("/staff/resolved-issues");
    }
  };

  if (loading) return <p>Loading issue...</p>;
  if (!issue) return <p>Issue not found.</p>;

  return (
    <div style={{ padding: "20px" }}>
      <h2>{issue.title}</h2>
      {issue.image_url && <img src={issue.image_url} alt="issue proof" width={400} />}
      <p><strong>Description:</strong> {issue.description}</p>
      <p><strong>Location:</strong> {issue.location}</p>
      <p><strong>Status:</strong> {issue.status}</p>

      <div style={{ marginTop: "20px" }}>
        <input type="file" accept="image/*" onChange={(e) => setImageFile(e.target.files[0])} />
        <button onClick={handleUpload} style={{ marginLeft: "10px" }}>Mark as Resolved</button>
      </div>
    </div>
  );
}
