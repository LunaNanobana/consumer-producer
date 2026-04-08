echo "Migrations are on the way..."
python manage.py migrate
echo "Starting server..."
python manage.py runserver 0.0.0.0:8000