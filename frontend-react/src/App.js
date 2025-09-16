import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, useNavigate } from 'react-router-dom';
import Login from './pages/Login';
import NewIssuesPage from './components/NewIssuesPage';
import ReviewPage from './components/ReviewPage';
import FeedbackPage from './components/FeedbackPage';
import Navbar from './components/Navbar';
import IssueDetailsPage from './components/IssueDetailsPage';
import AdminDashboard from "./components/AdminDashboard";
import StaffDashboard from "./components/StaffDashboard";

function AppWrapper() {
  const [user, setUser] = useState(null);
  const [role, setRole] = useState(null); // track role too
  const [welcomeShown, setWelcomeShown] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    if (user && role && !welcomeShown) {
      alert(`Welcome ${user.email}, you are logged in as ${role}`);

      if (role === 'admin') {
        navigate('/admin');
      } else if (role === 'staff') {
        navigate('/staff');
      } else {
        navigate('/'); // fallback for citizens/others
      }

      setWelcomeShown(true);
    }
  }, [user, role, welcomeShown, navigate]);

  if (!user) {
    // Pass role setter into Login so it can update role after login
    return <Login onLogin={(u, r) => { setUser(u); setRole(r); }} />;
  }

  return (
    <>
      {/* Show navbar only for admins, hide for staff */}
      {role === 'admin' && <Navbar />}

      <Routes>
        <Route path="/" element={<NewIssuesPage />} />
        <Route path="/new-issues" element={<NewIssuesPage />} />
        <Route path="/reviews" element={<ReviewPage />} />
        <Route path="/feedback" element={<FeedbackPage />} />
        <Route path="/issues/:id" element={<IssueDetailsPage />} />
        <Route path="/admin" element={<AdminDashboard />} />
        <Route path="/staff" element={<StaffDashboard />} />
        <Route path="/new-issues" element={<NewIssuesPage />} />
        <Route path="/review" element={<ReviewPage />} />
        <Route path="/feedback" element={<FeedbackPage />} />

      </Routes>
    </>
  );
}

export default function App() {
  return (
    <Router>
      <AppWrapper />
    </Router>
  );
}
