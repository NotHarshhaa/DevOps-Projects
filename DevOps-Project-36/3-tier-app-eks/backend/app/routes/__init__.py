from flask import Blueprint, jsonify

# Create blueprints
topic_bp = Blueprint('topics', __name__, url_prefix='/api/topics')
quiz_bp = Blueprint('quizzes', __name__, url_prefix='/api/quiz')

api_bp = Blueprint('api', __name__, url_prefix='/api')

# Add a simple health check route
@api_bp.route('', methods=['GET'])
def api_health_check():
    return jsonify({"status": "healthy", "message": "API is operational"}), 200

# Import routes after creating blueprints
from . import topic_routes, quiz_routes
