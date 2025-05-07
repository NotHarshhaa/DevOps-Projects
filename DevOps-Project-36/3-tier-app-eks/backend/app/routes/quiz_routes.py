from flask import jsonify, request
from app.models.models import Topic, Question
from app.models import db
from . import quiz_bp
import random

MAX_QUIZ_QUESTIONS = 15

@quiz_bp.route('/<topic_slug>', methods=['GET'])
def get_quiz(topic_slug):
    topic = Topic.query.filter_by(slug=topic_slug).first_or_404()
    
    # Get all questions for the topic
    all_questions = Question.query.filter_by(topic_id=topic.id).all()
    
    if not all_questions:
        return jsonify({
            'title': topic.name,
            'questions': [],
            'total_questions': 0,
            'selected_questions': 0
        })
    
    # Shuffle and limit questions
    selected_questions = random.sample(
        all_questions, 
        min(MAX_QUIZ_QUESTIONS, len(all_questions))
    )
    
    return jsonify({
        'title': topic.name,
        'questions': [q.to_dict(shuffle=True) for q in selected_questions],
        'total_questions': len(all_questions),
        'selected_questions': len(selected_questions)
    })

@quiz_bp.route('/submit', methods=['POST'])
def submit_quiz():
    data = request.get_json()
    topic_slug = data.get('topic')
    answers = data.get('answers')
    
    if not topic_slug or not answers:
        return jsonify({'error': 'Invalid submission'}), 400
        
    topic = Topic.query.filter_by(slug=topic_slug).first()
    if not topic:
        return jsonify({'error': 'Topic not found'}), 404
    
    # Get all questions that were answered
    question_ids = [int(qid) for qid in answers.keys()]
    questions = Question.query.filter(Question.id.in_(question_ids)).all()
    
    correct_count = 0
    total_questions = len(questions)
    
    for question in questions:
        submitted_answer = answers.get(str(question.id))
        if submitted_answer == question.correct_answer:
            correct_count += 1
    
    score = (correct_count / total_questions * 100) if total_questions > 0 else 0
    
    return jsonify({
        'score': score,
        'correct': correct_count,
        'total': total_questions
    })

@quiz_bp.route('/questions', methods=['GET', 'POST'])
def manage_questions():
    if request.method == 'POST':
        data = request.get_json()
        print("Received question data:", data)
        
        if not all(k in data for k in ('topic_slug', 'question_text', 'options', 'correct_answer')):
            return jsonify({'error': 'Missing required fields'}), 400
            
        topic = Topic.query.filter_by(slug=data['topic_slug']).first()
        if not topic:
            return jsonify({'error': f'Topic not found: {data["topic_slug"]}'}), 404
            
        try:
            question = Question(
                topic_id=topic.id,
                question_text=data['question_text'],
                options=data['options'],
                correct_answer=data['correct_answer']
            )
            
            db.session.add(question)
            db.session.commit()
            return jsonify(question.to_dict(shuffle=False)), 201
            
        except Exception as e:
            db.session.rollback()
            print(f"Error adding question: {str(e)}")
            return jsonify({'error': str(e)}), 400
            
    questions = Question.query.all()
    return jsonify([q.to_dict(shuffle=False) for q in questions])

@quiz_bp.route('/questions/bulk', methods=['POST'])
def bulk_upload_questions():
    if not request.is_json:
        return jsonify({'error': 'Content-Type must be application/json'}), 400
        
    questions_data = request.get_json()
    if not isinstance(questions_data, list):
        return jsonify({'error': 'Expected a list of questions'}), 400
        
    success_count = 0
    failed_count = 0
    errors = []
    valid_questions = []
    
    # First pass: Validate all questions
    for index, question_data in enumerate(questions_data):
        try:
            # Skip empty rows
            if not question_data or not any(question_data.values()):
                continue

            # Validate required fields
            if not all(k in question_data for k in ('topic_slug', 'question_text', 'options', 'correct_answer')):
                failed_count += 1
                errors.append(f"Row {index + 1}: Missing required fields")
                continue

            # Validate content
            if not question_data['question_text'] or not question_data['question_text'].strip():
                failed_count += 1
                errors.append(f"Row {index + 1}: Empty question text")
                continue

            # Validate options
            if not isinstance(question_data['options'], list) or len(question_data['options']) != 4:
                failed_count += 1
                errors.append(f"Row {index + 1}: Invalid options format")
                continue

            if any(opt is None or str(opt).strip() == '' for opt in question_data['options']):
                failed_count += 1
                errors.append(f"Row {index + 1}: Empty options not allowed")
                continue

            # Validate correct_answer
            try:
                correct_answer = int(question_data['correct_answer'])
                if not 0 <= correct_answer <= 3:
                    raise ValueError("Correct answer must be between 0 and 3")
                question_data['correct_answer'] = correct_answer
            except (ValueError, TypeError):
                failed_count += 1
                errors.append(f"Row {index + 1}: Invalid correct_answer value")
                continue

            # Find topic
            topic = Topic.query.filter_by(slug=question_data['topic_slug']).first()
            if not topic:
                failed_count += 1
                errors.append(f"Row {index + 1}: Topic not found: {question_data['topic_slug']}")
                continue

            # If all validations pass, add to valid questions
            valid_questions.append({
                'topic_id': topic.id,
                'question_text': question_data['question_text'].strip(),
                'options': [str(opt).strip() for opt in question_data['options']],
                'correct_answer': correct_answer
            })
            
        except Exception as e:
            failed_count += 1
            errors.append(f"Row {index + 1}: {str(e)}")
            continue
    
    # Second pass: Add valid questions to database
    if valid_questions:
        try:
            for question_data in valid_questions:
                question = Question(**question_data)
                db.session.add(question)
                success_count += 1
            
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            return jsonify({
                'error': 'Failed to commit questions to database',
                'detail': str(e),
                'errors': errors
            }), 400
    
    return jsonify({
        'success': success_count,
        'failed': failed_count,
        'errors': errors if errors else None
    })