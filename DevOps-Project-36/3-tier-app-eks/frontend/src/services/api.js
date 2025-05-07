// src/services/api.js
import API_URL from '../config/api';

export const fetchTopics = async () => {
  try {
    const response = await fetch(`${API_URL}/topics`);
    if (!response.ok) {
      throw new Error(`Error: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('Error fetching topics:', error);
    throw error;
  }
};

// Add other API calls as needed
export const createTopic = async (topicData) => {
  try {
    const response = await fetch(`${API_URL}/topics`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(topicData),
    });
    if (!response.ok) {
      throw new Error(`Error: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('Error creating topic:', error);
    throw error;
  }
};