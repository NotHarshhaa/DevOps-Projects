# file structure
tree -I 'venv'

# Locally running the backend 

python3 -m venv venv 

source venv/bin/activate

pip install -r requirements.txt

# run db locally 
bash 
docker run --name flask_postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=password -e POSTGRES_DB=devops_learning -p 5432:5432 -d postgres

# On macOS/Linux:
export FLASK_APP=run.py
# On Windows:
<!-- set FLASK_APP=run.py -->

flask db init
flask db migrate -m "Initial migration"
flask db upgrade

# run the app
python run.py

# create seed data
python seed_data.py

# create bulk data 
python bulk_upload_questions.py questions-answers/kubernetes_questions.csv 

python bulk_upload_questions.py questions-answers/jenkins_questions.csv

python bulk_upload_questions.py questions-answers/docker_questions.csv



# DevOps Learning Platform - Backend

A Flask-based REST API backend for the DevOps Learning Platform. This application provides endpoints for managing DevOps topics and quizzes.

## Project Structure
```
backend/
├── app/
│   ├── __init__.py
│   ├── config.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── models.py
│   └── routes/
│       ├── __init__.py
│       ├── quiz_routes.py
│       └── topic_routes.py
├── migrations/
├── seed_data.py
├── requirements.txt
└── run.py
```

## Prerequisites
- Python 3.9+
- PostgreSQL
- pip (Python package manager)

## Setup Instructions

1. Create a virtual environment:
```bash
python -m venv venv
```

2. Activate the virtual environment:
```bash
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Create `.env` file in the root directory:
```env
FLASK_APP=run.py
FLASK_DEBUG=1
DATABASE_URL=postgresql://username:password@localhost:5432/devops_learning
SECRET_KEY=your-secret-key-here
```

5. Create PostgreSQL database:
```bash
psql -U postgres
CREATE DATABASE devops_learning;
```

6. Run database migrations:
```bash
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
```

7. Seed the database with initial data:
```bash
python seed_data.py
```

## Running the Application

Start the Flask server:
```bash
python run.py
```

The server will start at `http://localhost:8000`

## API Endpoints

### Topics
- `GET /api/topics` - Get all topics
- `POST /api/topics` - Create a new topic
- `PUT /api/topics/<id>` - Update a topic
- `DELETE /api/topics/<id>` - Delete a topic

### Quizzes
- `GET /api/quiz/<topic_slug>` - Get quiz questions for a topic
- `POST /api/quiz/questions` - Create a new question
- `POST /api/quiz/submit` - Submit quiz answers

## Example API Requests

### Get All Topics
```bash
curl http://localhost:8000/api/topics
```

### Create a New Topic
```bash
curl -X POST http://localhost:8000/api/topics \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Docker",
    "description": "Learn Docker containerization",
    "slug": "docker"
  }'
```

### Submit Quiz
```bash
curl -X POST http://localhost:8000/api/quiz/submit \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "docker",
    "answers": {
      "1": 0,
      "2": 2
    }
  }'
```

## Development

### Adding New Routes
1. Create a new route file in `app/routes/`
2. Register the blueprint in `app/__init__.py`
3. Update the models if necessary
4. Create and run new migrations

### Database Migrations
When changing models:
```bash
flask db migrate -m "Description of changes"
flask db upgrade
```

## Troubleshooting

### Common Issues
1. Database connection errors:
   - Check PostgreSQL is running
   - Verify database credentials in `.env`
   - Ensure database exists

2. Import errors:
   - Check virtual environment is activated
   - Verify all dependencies are installed
   - Check file structure matches project structure

3. Migration errors:
   - Remove the migrations folder and reinitialize
   - Check database connection
   - Ensure models are properly defined