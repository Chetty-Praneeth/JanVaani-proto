// src/components/Navbar.js
import React from 'react';
import { Link } from 'react-router-dom';

const Navbar = () => {
  return (
    <nav style={{ padding: '1rem', background: '#f2f2f2' }}>
      <Link to="/" style={{ marginRight: '1rem' }}>Home</Link>
      <Link to="/new-issues" style={{ marginRight: '1rem' }}>New Issues</Link>
      <Link to="/reviews" style={{ marginRight: '1rem' }}>Reviews</Link>
      <Link to="/feedback">Feedback</Link>
    </nav>
  );
};

export default Navbar;
