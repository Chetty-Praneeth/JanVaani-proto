import React from 'react';
import { Link } from 'react-router-dom';

export default function Navbar() {
  return (
    <nav style={{ padding: '10px', backgroundColor: '#f0f0f0' }}>
      <Link to="/new-issues" style={{ marginRight: '10px' }}>New Issues</Link>
      <Link to="/reviews" style={{ marginRight: '10px' }}>Reviews</Link>
      <Link to="/feedback">Feedback</Link>
    </nav>
  );
}
