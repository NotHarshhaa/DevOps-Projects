import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Papa from 'papaparse';
import API_URL from '../config/api';

function QuestionManager() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    topic_slug: '',
    question_text: '',
    options: ['', '', '', ''],
    correct_answer: 0
  });
  const [csvFile, setCsvFile] = useState(null);
  const [message, setMessage] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleOptionChange = (index, value) => {
    const newOptions = [...formData.options];
    newOptions[index] = value;
    setFormData(prev => ({
      ...prev,
      options: newOptions
    }));
  };

  const handleSingleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      const response = await fetch(`${API_URL}/quiz/questions`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      const data = await response.json();

      if (response.ok) {
        setMessage({ type: 'success', text: 'Question added successfully!' });
        setFormData({
          topic_slug: '',
          question_text: '',
          options: ['', '', '', ''],
          correct_answer: 0
        });
      } else {
        setMessage({ type: 'error', text: data.error || 'Failed to add question' });
      }
    } catch (error) {
      setMessage({ type: 'error', text: 'Error adding question' });
    } finally {
      setLoading(false);
    }
  };

  const handleCsvUpload = (e) => {
    const file = e.target.files[0];
    setCsvFile(file);
  };

  const handleBulkUpload = async (e) => {
    e.preventDefault();
    if (!csvFile) {
      setMessage({ type: 'error', text: 'Please select a CSV file' });
      return;
    }

    setLoading(true);
    try {
      Papa.parse(csvFile, {
        header: true,
        skipEmptyLines: true,
        complete: async (results) => {
          console.log('Parsed CSV:', results.data);
          
          const questions = results.data
            .filter(row => row.topic_slug && row.question_text) // Filter out empty rows
            .map(row => ({
              topic_slug: row.topic_slug.trim(),
              question_text: row.question_text.trim(),
              options: [
                row.option1 ? row.option1.trim() : '',
                row.option2 ? row.option2.trim() : '',
                row.option3 ? row.option3.trim() : '',
                row.option4 ? row.option4.trim() : ''
              ],
              correct_answer: parseInt(row.correct_answer)
            }));

          if (questions.length === 0) {
            setMessage({
              type: 'error',
              text: 'No valid questions found in CSV file'
            });
            setLoading(false);
            return;
          }

          try {
            const response = await fetch(`${API_URL}/quiz/questions/bulk`, {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify(questions)
            });

            const data = await response.json();

            if (response.ok) {
              setMessage({
                type: 'success',
                text: `Successfully added ${data.success} questions. Failed: ${data.failed}${
                  data.errors ? '\n\nErrors:\n' + data.errors.join('\n') : ''
                }`
              });
            } else {
              setMessage({
                type: 'error',
                text: `Upload failed: ${data.error}${
                  data.errors ? '\n\nErrors:\n' + data.errors.join('\n') : ''
                }`
              });
            }
          } catch (error) {
            setMessage({
              type: 'error',
              text: 'Error uploading questions: ' + error.message
            });
          }
        },
        error: (error) => {
          setMessage({
            type: 'error',
            text: 'Error parsing CSV: ' + error.message
          });
        }
      });
    } catch (error) {
      setMessage({
        type: 'error',
        text: 'Error processing file: ' + error.message
      });
    } finally {
      setLoading(false);
      setCsvFile(null);
      // Reset the file input
      document.querySelector('input[type="file"]').value = '';
    }
  };

  return (
    <div className="container mx-auto px-4 py-8 max-w-4xl">
      <h1 className="text-3xl font-bold mb-8">Question Management</h1>

      {message && (
        <div className={`p-4 mb-6 rounded ${
          message.type === 'success' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
        }`}>
          {message.text}
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        {/* Single Question Form */}
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-bold mb-4">Add Single Question</h2>
          <form onSubmit={handleSingleSubmit} className="space-y-4">
            <div>
              <label className="block mb-1">Topic Slug:</label>
              <input
                type="text"
                name="topic_slug"
                value={formData.topic_slug}
                onChange={handleInputChange}
                className="w-full p-2 border rounded"
                required
              />
            </div>

            <div>
              <label className="block mb-1">Question:</label>
              <textarea
                name="question_text"
                value={formData.question_text}
                onChange={handleInputChange}
                className="w-full p-2 border rounded"
                rows="3"
                required
              />
            </div>

            <div>
              <label className="block mb-1">Options:</label>
              {formData.options.map((option, index) => (
                <input
                  key={index}
                  type="text"
                  value={option}
                  onChange={(e) => handleOptionChange(index, e.target.value)}
                  className="w-full p-2 border rounded mb-2"
                  placeholder={`Option ${index + 1}`}
                  required
                />
              ))}
            </div>

            <div>
              <label className="block mb-1">Correct Answer (0-3):</label>
              <input
                type="number"
                name="correct_answer"
                value={formData.correct_answer}
                onChange={handleInputChange}
                min="0"
                max="3"
                className="w-full p-2 border rounded"
                required
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 disabled:bg-blue-300"
            >
              {loading ? 'Adding...' : 'Add Question'}
            </button>
          </form>
        </div>

        {/* Bulk Upload Form */}
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-bold mb-4">Bulk Upload Questions</h2>
          <form onSubmit={handleBulkUpload} className="space-y-4">
            <div>
              <label className="block mb-1">Upload CSV File:</label>
              <p className="text-sm text-gray-600 mb-2">
                Format: topic_slug,question_text,option1,option2,option3,option4,correct_answer
              </p>
              <input
                type="file"
                accept=".csv"
                onChange={handleCsvUpload}
                className="w-full p-2 border rounded"
                required
              />
            </div>

            <button
              type="submit"
              disabled={loading || !csvFile}
              className="w-full bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 disabled:bg-green-300"
            >
              {loading ? 'Uploading...' : 'Upload CSV'}
            </button>
          </form>

          {/* CSV Template Download */}
          <div className="mt-4">
            <h3 className="font-bold mb-2">CSV Template:</h3>
            <pre className="bg-gray-100 p-2 rounded text-sm overflow-x-auto">
              topic_slug,question_text,option1,option2,option3,option4,correct_answer{'\n'}
              docker,What is Docker?,A containerization platform,A database,A language,An OS,0
            </pre>
          </div>
        </div>
      </div>

      <button
        onClick={() => navigate('/')}
        className="mt-6 bg-gray-500 text-white px-6 py-2 rounded hover:bg-gray-600"
      >
        Back to Home
      </button>
    </div>
  );
}

export default QuestionManager;