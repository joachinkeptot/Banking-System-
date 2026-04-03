#!/bin/bash

set -e

echo "================================"
echo "   Banking System - Starting    "
echo "================================"

# Check Python
if ! command -v python3 &>/dev/null; then
  echo "ERROR: Python 3 is not installed."
  echo "  macOS:   brew install python3"
  echo "  Ubuntu:  sudo apt install python3 python3-venv"
  echo "  Windows: https://www.python.org/downloads/"
  exit 1
fi

# Check MySQL client
if ! command -v mysql &>/dev/null; then
  echo "ERROR: MySQL is not installed."
  echo "  macOS:   brew install mysql"
  echo "  Ubuntu:  sudo apt install mysql-server"
  exit 1
fi

# Check MySQL is running
if ! mysql -u root -e "SELECT 1;" &>/dev/null; then
  echo ""
  echo "MySQL is installed but not running. Attempting to start it..."
  if command -v brew &>/dev/null; then
    brew services start mysql
  elif command -v systemctl &>/dev/null; then
    sudo systemctl start mysql
  else
    echo "ERROR: Could not start MySQL automatically. Please start it manually and re-run this script."
    exit 1
  fi
  sleep 2
  if ! mysql -u root -e "SELECT 1;" &>/dev/null; then
    echo "ERROR: MySQL still not reachable. Please start it manually and re-run this script."
    exit 1
  fi
  echo "MySQL started."
fi

# Create and activate virtual environment
if [ ! -d "venv" ]; then
  echo ""
  echo "Creating virtual environment..."
  python3 -m venv venv
fi
echo "Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt -q

# Set up .env if it doesn't exist
if [ ! -f .env ]; then
  echo ""
  echo "No .env file found. Creating one from .env.example..."
  cp .env.example .env
  echo ""
  echo "Default .env created (root user, no password, database: banking_system)."
  echo "If your MySQL uses a password, edit .env now and press Enter."
  echo "Otherwise just press Enter to continue..."
  read
fi

# Read DB config from .env
DB_NAME=$(grep DB_NAME .env | cut -d '=' -f2)
DB_USER=$(grep DB_USER .env | cut -d '=' -f2)
DB_PASS=$(grep DB_PASSWORD .env | cut -d '=' -f2)

# Build mysql auth flags
MYSQL_AUTH="-u $DB_USER"
if [ -n "$DB_PASS" ]; then
  MYSQL_AUTH="$MYSQL_AUTH -p$DB_PASS"
fi

# Create database and load schema
echo ""
echo "Setting up database..."
if ! mysql $MYSQL_AUTH -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"; then
  echo "ERROR: Could not create database. Check your DB_USER and DB_PASSWORD in .env"
  exit 1
fi

if ! mysql $MYSQL_AUTH "$DB_NAME" < schema.sql; then
  echo "ERROR: Could not load schema. Check schema.sql for errors."
  exit 1
fi

echo "Database ready."

# Open browser after short delay
echo ""
echo "Starting app at http://localhost:5000 ..."
sleep 1
if command -v open &>/dev/null; then
  open http://localhost:5000 &
elif command -v xdg-open &>/dev/null; then
  xdg-open http://localhost:5000 &
fi

# Run the app
python3 app.py
