import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, useNavigate } from 'react-router-dom';
import Login from './pages/Login';
import NewIssuesPage from './components/NewIssuesPage';
import ReviewPage from './components/ReviewPage';
import FeedbackPage from './components/FeedbackPage';
import Navbar from './components/Navbar';
import IssueDetailsPage from './components/IssueDetailsPage';

function AppWrapper() {
  const [user, setUser] = useState(null);
  const [welcomeShown, setWelcomeShown] = useState(false); // Track popup
  const navigate = useNavigate();

  useEffect(() => {
    if (user && !welcomeShown) {
      alert(`Welcome ${user.email}, you are logged in`);
      navigate('/new-issues');
      setWelcomeShown(true); // ensure it only runs once
    }
  }, [user, welcomeShown, navigate]);

  if (!user) {
    return <Login onLogin={setUser} />;
  }

  return (
    <>
      <Navbar />
      <Routes>
        <Route path="/" element={<NewIssuesPage />} />
        <Route path="/new-issues" element={<NewIssuesPage />} />
        <Route path="/reviews" element={<ReviewPage />} />
        <Route path="/feedback" element={<FeedbackPage />} />
        <Route path="/issues/:id" element={<IssueDetailsPage />} />
      </Routes>
    </>
  );
}

// Wrap AppWrapper in Router here
export default function App() {
  return (
    <Router>
      <AppWrapper />
    </Router>
  );
}
