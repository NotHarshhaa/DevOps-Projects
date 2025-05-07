import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './components/Home';
import Quiz from './components/Quiz';
import QuestionManager from './components/QuestionManager';

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gray-100">
        <Navbar />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/quiz/:topic" element={<Quiz />} />
          <Route path="/manage-questions" element={<QuestionManager />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;