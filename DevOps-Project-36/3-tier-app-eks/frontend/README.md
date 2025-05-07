

# frontend 
## run the frontend

cd frontend
npm install
npm start

# To create a production build
 npm run build

 # DevOps Learning Platform - Frontend

A React-based frontend for the DevOps Learning Platform. This application provides an interactive interface for learning DevOps concepts and taking quizzes.

## Project Structure
```
frontend/
├── public/
├── src/
│   ├── components/
│   │   ├── Home.js
│   │   ├── Navbar.js
│   │   ├── Quiz.js
│   │   └── QuestionManager.js
│   ├── App.js
│   └── index.js
├── package.json
└── tailwind.config.js
```

## Prerequisites
- Node.js 14+
- npm (Node package manager)
- Backend server running on port 8000

## Setup Instructions

1. Install dependencies:
```bash
npm install
```

2. Create `.env` file in the root directory:
```env
REACT_APP_API_URL=http://localhost:8000/api
```

## Running the Application

Start the development server:
```bash
npm start
```

The application will start at `http://localhost:3000`

## Features

### Home Page
- Displays all available DevOps topics
- Each topic card shows:
  - Title
  - Description
  - Link to quiz

### Quiz Page
- Interactive quiz interface
- Multiple choice questions
- Immediate feedback
- Score calculation
- Option to retry

### Question Manager
- Interface for adding new questions
- Form validation
- Success/error feedback

## Available Scripts

- `npm start` - Runs the development server
- `npm test` - Runs tests
- `npm run build` - Creates production build
- `npm run eject` - Ejects from Create React App

## Component Overview

### Home.js
Main landing page component that displays all available topics.
```jsx
<Home />
```

### Quiz.js
Handles quiz logic and display.
```jsx
<Quiz topic="docker" />
```

### Navbar.js
Navigation component.
```jsx
<Navbar />
```

### QuestionManager.js
Interface for managing quiz questions.
```jsx
<QuestionManager />
```

## API Integration

The frontend communicates with the backend using fetch API. Example:
```javascript
const fetchTopics = async () => {
  const response = await fetch('http://localhost:8000/api/topics');
  const data = await response.json();
  return data;
};
```

## Styling

The project uses Tailwind CSS for styling. Key styling features:
- Responsive design
- Custom color scheme
- Consistent spacing
- Interactive elements

## Development

### Adding New Components
1. Create component file in `src/components/`
2. Import required dependencies
3. Define component
4. Export component
5. Update routing if necessary

### Making API Calls
1. Use fetch API
2. Handle loading states
3. Implement error handling
4. Update UI based on response

## Troubleshooting

### Common Issues

1. API connection errors:
   - Check if backend server is running
   - Verify API URL in .env file
   - Check browser console for CORS errors

2. Styling issues:
   - Verify Tailwind classes
   - Check for CSS conflicts
   - Ensure responsive design works

3. Component errors:
   - Check prop types
   - Verify component imports
   - Debug using React Developer Tools

## Building for Production

1. Create production build:
```bash
npm run build
```

2. Test the production build locally:
```bash
npx serve -s build
```

3. Deploy the contents of the `build` folder to your hosting service