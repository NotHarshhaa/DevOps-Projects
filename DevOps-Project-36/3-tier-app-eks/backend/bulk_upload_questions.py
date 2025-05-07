import csv
from app import create_app
from app.models import db, Topic, Question
from sqlalchemy.exc import IntegrityError

def bulk_upload_questions(csv_file_path, batch_size=100):
    app = create_app()
    
    with app.app_context():
        with open(csv_file_path, 'r') as file:
            csv_reader = csv.DictReader(file)
            questions_batch = []
            total_processed = 0
            total_success = 0
            total_failed = 0
            
            for row in csv_reader:
                try:
                    # Find the topic
                    topic = Topic.query.filter_by(slug=row['topic_slug']).first()
                    if not topic:
                        print(f"Topic not found: {row['topic_slug']}")
                        total_failed += 1
                        continue
                    
                    # Create question object
                    question = Question(
                        topic_id=topic.id,
                        question_text=row['question_text'],
                        options=[
                            row['option1'],
                            row['option2'],
                            row['option3'],
                            row['option4']
                        ],
                        correct_answer=int(row['correct_answer'])
                    )
                    
                    questions_batch.append(question)
                    total_processed += 1
                    
                    # Commit in batches
                    if len(questions_batch) >= batch_size:
                        try:
                            db.session.bulk_save_objects(questions_batch)
                            db.session.commit()
                            total_success += len(questions_batch)
                            print(f"Committed batch of {len(questions_batch)} questions")
                            questions_batch = []
                        except IntegrityError as e:
                            db.session.rollback()
                            print(f"Error in batch: {str(e)}")
                            total_failed += len(questions_batch)
                            questions_batch = []
                
                except Exception as e:
                    print(f"Error processing row: {str(e)}")
                    total_failed += 1
            
            # Commit any remaining questions
            if questions_batch:
                try:
                    db.session.bulk_save_objects(questions_batch)
                    db.session.commit()
                    total_success += len(questions_batch)
                except IntegrityError as e:
                    db.session.rollback()
                    print(f"Error in final batch: {str(e)}")
                    total_failed += len(questions_batch)
            
            print(f"\nUpload Summary:")
            print(f"Total Processed: {total_processed}")
            print(f"Successfully Uploaded: {total_success}")
            print(f"Failed: {total_failed}")

if __name__ == '__main__':
    import sys
    if len(sys.argv) != 2:
        print("Usage: python bulk_upload_questions.py <csv_file_path>")
        sys.exit(1)
    
    bulk_upload_questions(sys.argv[1])