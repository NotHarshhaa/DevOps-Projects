import React from 'react';
import { Link } from 'react-router-dom';

function Navbar() {
  return (
    <nav className="bg-gray-800 p-4">
      <div className="container mx-auto">
        <div className="flex justify-between items-center">
          <Link to="/" className="text-white text-xl font-bold">
            DevOps Learning Platform
          </Link>
          <div className="space-x-6">
            <Link to="/" className="text-white hover:text-gray-300">
              Home
            </Link>
            <Link to="/manage-questions" className="text-white hover:text-gray-300">
              Manage Questions
            </Link>
          </div>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;