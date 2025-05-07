from app import create_app
from app.models import db
from app.models.models import Topic, Question

def seed_data():
    # Create topics
    docker_topic = Topic(
        name='Docker',
        description='Learn Docker containerization from basics to advanced concepts',
        slug='docker'
    )

    kubernetes_topic = Topic(
        name='Kubernetes',
        description='Master container orchestration with Kubernetes',
        slug='kubernetes'
    )

    jenkins_topic = Topic(
        name='Jenkins',
        description='Continuous Integration/Continuous Deployment with Jenkins',
        slug='jenkins'
    )

    # Docker questions
    docker_questions = [
        Question(
            topic=docker_topic,
            question_text='What command is used to list all Docker containers?',
            options=['docker ps -a', 'docker list', 'docker containers', 'docker show all'],
            correct_answer=0
        ),
        Question(
            topic=docker_topic,
            question_text='Which file is used to define a Docker container?',
            options=['Container.json', 'Docker.json', 'Dockerfile', 'DockerContainer.yaml'],
            correct_answer=2
        ),
        Question(
            topic=docker_topic,
            question_text='Which command is used to build a Docker image?',
            options=['docker create', 'docker build', 'docker make', 'docker compile'],
            correct_answer=1
        )
    ]

    # Kubernetes questions
    kubernetes_questions = [
        Question(
            topic=kubernetes_topic,
            question_text='What is the smallest deployable unit in Kubernetes?',
            options=['Container', 'Pod', 'Node', 'Service'],
            correct_answer=1
        ),
        Question(
            topic=kubernetes_topic,
            question_text='Which command is used to get all pods in a namespace?',
            options=['kubectl get pods', 'kubernetes pods list', 'k8s pods all', 'kube list pods'],
            correct_answer=0
        ),
        Question(
            topic=kubernetes_topic,
            question_text='What is used to define the desired state of a Kubernetes object?',
            options=['JSON', 'XML', 'YAML', 'INI'],
            correct_answer=2
        )
    ]

    # Jenkins questions
    jenkins_questions = [
        Question(
            topic=jenkins_topic,
            question_text='What is a Jenkins Pipeline?',
            options=[
                'A series of events or jobs which are linked to each other',
                'A plugin for Docker integration',
                'A monitoring tool',
                'A deployment strategy'
            ],
            correct_answer=0
        ),
        Question(
            topic=jenkins_topic,
            question_text='Which file is used to define a Jenkins Pipeline?',
            options=['jenkins.xml', 'pipeline.conf', 'Jenkinsfile', 'jenkins.yaml'],
            correct_answer=2
        ),
        Question(
            topic=jenkins_topic,
            question_text='What is the purpose of Jenkins agents?',
            options=[
                'To monitor Jenkins server',
                'To run Jenkins builds on different machines',
                'To store build artifacts',
                'To manage user permissions'
            ],
            correct_answer=1
        )
    ]

    try:
        # Add topics
        db.session.add(docker_topic)
        db.session.add(kubernetes_topic)
        db.session.add(jenkins_topic)
        
        # Add questions
        for question in docker_questions + kubernetes_questions + jenkins_questions:
            db.session.add(question)
        
        # Commit all changes
        db.session.commit()
        print("Data seeded successfully!")
        
    except Exception as e:
        db.session.rollback()
        print(f"Error seeding data: {str(e)}")
        raise

if __name__ == '__main__':
    app = create_app()
    with app.app_context():
        seed_data()