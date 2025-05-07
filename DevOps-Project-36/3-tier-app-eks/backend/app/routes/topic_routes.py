from flask import jsonify, request
from app.models.models import Topic
from app.models import db
from . import topic_bp

@topic_bp.route('', methods=['GET'])
def get_topics():
    topics = Topic.query.all()
    return jsonify([topic.to_dict() for topic in topics])

@topic_bp.route('', methods=['POST'])
def create_topic():
    data = request.get_json()
    
    if not all(k in data for k in ('name', 'description', 'slug')):
        return jsonify({'error': 'Missing required fields'}), 400
        
    topic = Topic(
        name=data['name'],
        description=data['description'],
        slug=data['slug']
    )
    
    try:
        db.session.add(topic)
        db.session.commit()
        return jsonify(topic.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400

@topic_bp.route('/<int:topic_id>', methods=['PUT'])
def update_topic(topic_id):
    topic = Topic.query.get_or_404(topic_id)
    data = request.get_json()
    
    if 'name' in data:
        topic.name = data['name']
    if 'description' in data:
        topic.description = data['description']
    if 'slug' in data:
        topic.slug = data['slug']
        
    try:
        db.session.commit()
        return jsonify(topic.to_dict())
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400

@topic_bp.route('/<int:topic_id>', methods=['DELETE'])
def delete_topic(topic_id):
    topic = Topic.query.get_or_404(topic_id)
    try:
        db.session.delete(topic)
        db.session.commit()
        return '', 204
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400