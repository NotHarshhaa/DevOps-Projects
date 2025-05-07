import React, { useState, useEffect, useCallback } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import API_URL from '../config/api';

function Quiz() {
  const { topic } = useParams();
  const navigate = useNavigate();
  const [quiz, setQuiz] = useState(null);
  const [answers, setAnswers] = useState({});
  const [result, setResult] = useState(null);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(true);

  const fetchQuiz = useCallback(async () => {
    try {
      setLoading(true);
      const response = await fetch(`${API_URL}/quiz/${topic}`);
      if (!response.ok) {
        throw new Error('Failed to fetch quiz');
      }
      const data = await response.json();
      console.log('Fetched quiz:', data);
      setQuiz(data);
      setAnswers({}); // Reset answers when getting new questions
      setError(null);
    } catch (err) {
      console.error('Error fetching quiz:', err);
      setError('Failed to load quiz. Please try again.');
    } finally {
      setLoading(false);
    }
  }, [topic]);

  useEffect(() => {
    fetchQuiz();
  }, [fetchQuiz]);

  const handleAnswerSelect = (questionId, answerIndex) => {
    setAnswers(prev => ({
      ...prev,
      [questionId]: answerIndex
    }));
  };

  const handleSubmit = async () => {
    try {
      // Check if all questions are answered
      const answeredQuestions = Object.keys(answers).length;
      const totalQuestions = quiz.questions.length;

      if (answeredQuestions < totalQuestions) {
        alert(`Please answer all questions (${answeredQuestions}/${totalQuestions} answered)`);
        return;
      }

      // Debug log
      console.log('Submitting answers:', {
        topic,
        answers
      });

      const response = await fetch(`${API_URL}/quiz/submit`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          topic: topic,
          answers: answers
        })
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'Failed to submit quiz');
      }

      const data = await response.json();
      console.log('Quiz result received:', data);  // Debug log
      setResult(data);
    } catch (err) {
      console.error('Error submitting quiz:', err);
      setError('Failed to submit quiz. Please try again.');
    }
  };

  const handleTryAgain = async () => {
    setResult(null);
    setAnswers({});
    await fetchQuiz();
  };

  if (loading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="text-center">Loading quiz...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
          <p>{error}</p>
          <button
            onClick={() => navigate('/')}
            className="mt-4 bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
          >
            Return to Home
          </button>
        </div>
      </div>
    );
  }

  if (!quiz) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="text-center">No quiz found.</div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8 max-w-3xl">
      <h1 className="text-3xl font-bold mb-6">{quiz.title}</h1>
      {quiz.total_questions > quiz.selected_questions && (
        <p className="mb-4 text-gray-600">
          Showing {quiz.selected_questions} questions from a pool of {quiz.total_questions} available questions.
        </p>
      )}
      
      {!result ? (
        <div className="space-y-8">
          {quiz.questions.map((question, index) => (
            <div key={question.id} className="bg-white rounded-lg shadow-md p-6">
              <p className="text-xl mb-4">
                {index + 1}. {question.question}
              </p>
              <div className="space-y-2">
                {question.options.map((option, optionIndex) => (
                  <label
                    key={optionIndex}
                    className={`flex items-center p-3 rounded-lg cursor-pointer transition-colors ${
                      answers[question.id] === optionIndex
                        ? 'bg-blue-50 border border-blue-200'
                        : 'hover:bg-gray-50 border border-transparent'
                    }`}
                  >
                    <input
                      type="radio"
                      name={`question-${question.id}`}
                      className="mr-3"
                      checked={answers[question.id] === optionIndex}
                      onChange={() => handleAnswerSelect(question.id, optionIndex)}
                    />
                    <span>{option}</span>
                  </label>
                ))}
              </div>
            </div>
          ))}
          
          <button
            onClick={handleSubmit}
            className="w-full bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-600 font-medium transition-colors"
          >
            Submit Quiz
          </button>
        </div>
      ) : (
        <div className="bg-white rounded-lg shadow-md p-8 text-center">
          <h2 className="text-2xl font-bold mb-4">Quiz Results</h2>
          <div className="bg-blue-50 p-6 rounded-lg mb-6">
            <p className="text-4xl font-bold text-blue-600 mb-2">
              {Math.round(result.score)}%
            </p>
            <p className="text-lg text-blue-800">
              You got {result.correct} out of {result.total} questions correct
            </p>
          </div>
          <div className="space-x-4">
            <button
              onClick={handleTryAgain}
              className="bg-blue-500 text-white px-6 py-2 rounded hover:bg-blue-600 transition-colors"
            >
              Try Another Quiz
            </button>
            <button
              onClick={() => navigate('/')}
              className="bg-gray-500 text-white px-6 py-2 rounded hover:bg-gray-600 transition-colors"
            >
              Back to Home
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

export default Quiz;