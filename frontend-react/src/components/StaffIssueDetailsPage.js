import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { supabase } from '../supabaseClient';

export default function StaffIssueDetailsPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [issue, setIssue] = useState(null);
  const [file, setFile] = useState(null);
  const [previewUrl, setPreviewUrl] = useState(null);
  const [uploading, setUploading] = useState(false);

  // Fetch issue details
  useEffect(() => {
    const fetchIssue = async () => {
      const { data, error } = await supabase
        .from('issues')
        .select('*')
        .eq('id', id)
        .single();
      if (error) console.error(error);
      else setIssue(data);
    };
    fetchIssue();
  }, [id]);

  // File change handler
  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];
    setFile(selectedFile);
    if (selectedFile) setPreviewUrl(URL.createObjectURL(selectedFile));
    else setPreviewUrl(null);
  };

  // Submit handler
  // Submit handler
const handleSubmit = async () => {
  if (!file) return alert('Please select an image!');
  setUploading(true);

  try {
    // Get logged-in user
    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) throw new Error('User not logged in');
    console.log('Logged-in user:', user);

    // Create numeric-only file name
    const fileExt = file.name.split('.').pop();
    const fileName = `${id}-${Date.now()}.${fileExt}`;
    console.log('Uploading file to path:', fileName);

    // Upload file to Supabase Storage
    const { data: uploadData, error: uploadError } = await supabase.storage
      .from('proofs')
      .upload(fileName, file, { upsert: true });

    if (uploadError) throw uploadError;
    console.log('Upload response:', uploadData);

    // Get public URL
    const { data: publicUrlData, error: urlError } = await supabase.storage
      .from('proofs')
      .getPublicUrl(fileName);

    if (urlError) throw urlError;
    const proofUrl = publicUrlData.publicUrl;
    console.log('Proof URL:', proofUrl);

    // Update issue with proof URL, preserve other details
    const { data: updateData, error: updateError } = await supabase
      .from('issues')
      .update({
        proof_url: proofUrl,
        status: 'resolved',
        updated_at: new Date().toISOString()
      })
      .eq('id', id)
      .eq('assigned_to', user.id);

    if (updateError) throw updateError;
    console.log('Update response:', updateData);

    alert('Issue marked as resolved!');
    navigate('/staff');
  } catch (err) {
    console.error('Detailed error:', err);
    alert('Failed to upload or update. Check console.');
  } finally {
    setUploading(false);
  }
};


  if (!issue) return <p>Loading issue details...</p>;

  return (
    <div style={{ padding: '20px' }}>
      <h2>{issue.title}</h2>
      {issue.image_url && (
        <img src={issue.image_url} alt="issue" style={{ maxWidth: 500, marginBottom: 10 }} />
      )}
      <p><strong>Description:</strong> {issue.description}</p>
      <p><strong>Location:</strong> {issue.location}</p>
      <p><strong>Status:</strong> {issue.status}</p>

      <div style={{ marginTop: 20 }}>
        <label>
          Upload completion proof:{' '}
          <input type="file" accept="image/*" onChange={handleFileChange} />
        </label>

        {previewUrl && (
          <div style={{ marginTop: 15 }}>
            <p><strong>Preview:</strong></p>
            <img src={previewUrl} alt="proof preview" style={{ maxWidth: 400, border: '1px solid #ccc', borderRadius: 8 }} />
          </div>
        )}

        <button
          onClick={handleSubmit}
          disabled={uploading}
          style={{ marginTop: 15, marginLeft: 10 }}
        >
          {uploading ? 'Uploading...' : 'Submit'}
        </button>
      </div>
    </div>
  );
}
