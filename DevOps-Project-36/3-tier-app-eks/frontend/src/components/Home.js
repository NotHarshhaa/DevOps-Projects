import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import API_URL from '../config/api';

function Home() {
  const [topics, setTopics] = useState([]);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTopics = async () => {
      try {
        setLoading(true);
        const response = await fetch(`${API_URL}/topics`, {
          method: 'GET',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        console.log('Fetched topics:', data);
        setTopics(data);
      } catch (err) {
        console.error('Error fetching topics:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchTopics();
  }, []);

  if (loading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <p className="text-center">Loading...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
          <p>Error loading topics: {error}</p>
          <p>Please make sure the backend server is running and accessible</p>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-8 text-center">Welcome to DevOps Learning Platform</h1>
      <p className="text-lg mb-8 text-center">
        Master DevOps concepts through interactive learning and quizzes.
      </p>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {topics.map(topic => (
          <div key={topic.id} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow">
            <h2 className="text-2xl font-bold mb-2 text-gray-800">{topic.title}</h2>
            <p className="text-gray-600 mb-4">{topic.description}</p>
            <Link
              to={`/quiz/${topic.id}`}
              className="inline-block bg-blue-500 text-white px-6 py-2 rounded-lg hover:bg-blue-600 transition-colors"
            >
              Take Quiz
            </Link>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Home;