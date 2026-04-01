# Banking System

A relational database-backed banking system built as a school project.

## Overview

This system models a bank with multiple branches, customers, accounts, transactions, and loans. It is designed using a normalized relational schema and implemented in SQL (MySQL/MariaDB compatible).

---

## Quick Start (Recommended)

Clone the repo and run the start script — it handles everything automatically:

```bash
git clone https://github.com/your-username/Banking-System-.git
cd Banking-System-
./start.sh
```

The script will:
- Install Python dependencies
- Create the `.env` config file
- Set up the database and load the schema
- Open the app in your browser at **http://localhost:5000**

---

## Manual Setup

Follow these steps if you prefer to set things up yourself.

### Prerequisites

- [Python 3.9+](https://www.python.org/downloads/)
- [MySQL 8.0+](https://dev.mysql.com/downloads/) — on Mac, install with `brew install mysql`
- pip (comes with Python)

### Step 1 — Clone the repository

```bash
git clone https://github.com/your-username/Banking-System-.git
cd Banking-System-
```

### Step 2 — Install Python dependencies

```bash
pip install -r requirements.txt
```

### Step 3 — Set up the database

Open MySQL (use your username, leave password blank if you have none):

```bash
mysql -u root
```

Inside MySQL, run:

```sql
CREATE DATABASE banking_system;
USE banking_system;
```

Then exit MySQL (`exit;`) and load the schema from your terminal:

```bash
mysql -u root banking_system < schema.sql
```

### Step 4 — Configure environment variables

```bash
cp .env.example .env
```

Open `.env` and fill in your credentials. If you have no MySQL password, leave `DB_PASSWORD` blank:

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=banking_system
```

### Step 5 — Start the app

```bash
python3 app.py
```

Open your browser and go to: **http://localhost:5000**

---

## Pages

| Page | URL | Description |
|---|---|---|
| Dashboard | `/` | Summary stats + recent transactions |
| Customers | `/customers` | View, add, edit, delete customers |
| Accounts | `/accounts` | View and open accounts |
| Transactions | `/transactions` | Record deposits, withdrawals, transfers |
| Loans | `/loans` | Create loans and record payments |

---

## Database Schema

### Tables

| Table | Description |
|---|---|
| `Employee` | Bank staff, with optional self-referencing manager relationship |
| `Branch` | Physical bank branches, each managed by an employee |
| `Customer` | Bank customers |
| `Account` | Customer accounts linked to a branch (Checking, Savings, Business) |
| `Transaction` | All account transactions (Deposit, Withdrawal, Transfer, Payment) |
| `Loan` | Loans tied to an account (Personal, Mortgage, Auto, Student, Business) |
| `Loan_payment` | Individual payments made against a loan |

### Entity Relationships

```
Employee ──< Branch          (one employee manages many branches)
Employee ──< Employee        (self-referencing: employee has a manager)
Customer ──< Account         (one customer can have many accounts)
Branch   ──< Account         (one branch can hold many accounts)
Account  ──< Transaction     (one account can have many transactions)
Account  ──< Loan            (one account can have many loans)
Loan     ──< Loan_payment    (one loan can have many payments)
```

### ERD Entities & Attributes

- **Employee**: employee_id, first_name, last_name, phone_num, address, email, date_of_birth, manager_id
- **Branch**: branch_id, branch_name, address, phone_num, manager_id
- **Customer**: customer_id, first_name, last_name, email, phone_num, address, date_of_birth
- **Account**: account_id, customer_id, branch_id, account_type, status, balance, open_date
- **Transaction**: transaction_id, account_id, type, amount, date, description, currency_type
- **Loan**: loan_id, account_id, loan_type, amount, interest_rate, start_date, end_date, status
- **Loan_payment**: payment_id, loan_id, amount_paid, payment_date, remaining_balance

---

## Project Structure

```
Banking-System-/
├── start.sh            # One-command setup & launch script
├── app.py              # Flask web application
├── config.py           # Database connection config
├── schema.sql          # Full database schema (DDL)
├── requirements.txt    # Python dependencies
├── .env.example        # Environment variable template
├── static/
│   └── style.css       # UI styles
├── templates/
│   ├── base.html           # Shared layout with sidebar
│   ├── index.html          # Dashboard
│   ├── customers.html      # Customer list
│   ├── customer_form.html  # Add/edit customer
│   ├── accounts.html       # Account list
│   ├── account_form.html   # Open account
│   ├── transactions.html   # Transaction list
│   ├── transaction_form.html
│   ├── loans.html          # Loan list
│   ├── loan_form.html      # Create loan
│   └── loan_payments.html  # Loan payment history
└── README.md
```
