#!/bin/bash

echo "================================"
echo "   Banking System - Starting    "
echo "================================"

# Check Python
if ! command -v python3 &>/dev/null; then
  echo "ERROR: Python 3 is not installed. Download it from https://www.python.org/downloads/"
  exit 1
fi

# Check MySQL
if ! command -v mysql &>/dev/null; then
  echo "ERROR: MySQL is not installed. Run: brew install mysql"
  exit 1
fi

# Install dependencies
echo ""
echo "Installing dependencies..."
pip install -r requirements.txt -q

# Set up .env if it doesn't exist
if [ ! -f .env ]; then
  echo ""
  echo "No .env file found. Creating one from .env.example..."
  cp .env.example .env
  echo "IMPORTANT: Open .env and set your DB_PASSWORD before continuing."
  echo "Press Enter once you've saved your .env file..."
  read
fi

# Create database and load schema
echo ""
echo "Setting up database..."
DB_NAME=$(grep DB_NAME .env | cut -d '=' -f2)
DB_USER=$(grep DB_USER .env | cut -d '=' -f2)
DB_PASS=$(grep DB_PASSWORD .env | cut -d '=' -f2)

if [ -z "$DB_PASS" ]; then
  mysql -u "$DB_USER" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;" 2>/dev/null
  mysql -u "$DB_USER" "$DB_NAME" < schema.sql 2>/dev/null
else
  mysql -u "$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;" 2>/dev/null
  mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < schema.sql 2>/dev/null
fi

echo "Database ready."

# Open browser after short delay
echo ""
echo "Starting app at http://localhost:5000 ..."
sleep 1
open http://localhost:5000 2>/dev/null &

# Run the app
python3 app.py
