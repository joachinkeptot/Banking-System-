# Banking System — Live Demo Script (3–5 min)

---

## 0. Before You Present
- Run `./start.sh` — app opens at http://localhost:5000
- Have a MySQL client ready (Terminal or TablePlus/MySQL Workbench) connected to `banking_system`
- Keep both the browser and DB terminal visible side-by-side if possible

---

## 1. The Database (~ 1 min)

**Say:**
> "Before we look at the app, here's what's powering it — a MySQL database with 7 related tables."

**In your MySQL terminal, run:**
```sql
SHOW TABLES;
```
> "We have Customers, Accounts, Transactions, Loans, Loan Payments, Branches, and Employees — all linked by foreign keys."

```sql
SELECT first_name, last_name, email FROM Customer LIMIT 5;
```
> "The database comes pre-loaded with 10 customers, 12 accounts, 20 transactions, and 10 loans across 5 branches."

```sql
SELECT a.account_type, a.balance, a.status, b.branch_name
FROM Account a
JOIN Branch b ON a.branch_id = b.branch_id
WHERE a.customer_id = 1;
```
> "Here's Alice Johnson — she has a Checking and a Savings account at the Downtown New York branch."

---

## 2. The Dashboard (~ 30 sec)

**Switch to browser → http://localhost:5000**

**Say:**
> "This is the dashboard. It pulls live counts from the database — 10 customers, 12 accounts, 20 transactions, 10 loans — and shows the 5 most recent transactions."

---

## 3. Customers (~ 30 sec)

**Click Customers in the nav**

**Say:**
> "All customers are listed here. We can add, edit, or delete any record."

**Click "Add Customer", fill in a quick fake person, submit.**

> "Customer saved — and if we check the database right now..."

```sql
SELECT * FROM Customer ORDER BY customer_id DESC LIMIT 1;
```
> "There they are. The UI and the DB are in sync."

---

## 4. Accounts & Transactions (~ 1 min)

**Click Accounts in the nav**

**Say:**
> "Accounts are linked to both a customer and a branch. You can see the type — Checking, Savings, or Business — and the live balance."

**Click Transactions → "Add Transaction"**
- Pick Alice Johnson's Checking account
- Type: Deposit, Amount: 1000, fill date and description

**Say:**
> "Watch Alice's balance before I submit... and after."

**Submit, then go back to Accounts and find Alice's Checking account.**

> "Balance updated automatically. The app adjusts it on every Deposit or Withdrawal."

---

## 5. Loans & Payments (~ 1 min)

**Click Loans in the nav**

**Say:**
> "We also track loans — Personal, Mortgage, Auto, Student, Business — with interest rates, dates, and status."

**Click the Payments button on Alice's Personal Loan (Loan #1)**

> "Alice has a $15,000 personal loan at 7.5%. You can see her payment history and the remaining balance dropping with each payment."

**Click "Record Payment", fill in amount and remaining balance, submit.**

> "Payment logged. In a real system this would trigger interest recalculation — here it tracks the balance the user provides."

---

## 6. Close (~ 15 sec)

> "So in summary — a fully functional banking management system: relational MySQL database, Python Flask backend, and a clean web UI. Create customers, open accounts, move money, and manage loans — all in one app."

---

## Quick Reference — Useful SQL for the Demo

```sql
-- See all tables
SHOW TABLES;

-- Customer + their accounts
SELECT c.first_name, c.last_name, a.account_type, a.balance
FROM Customer c JOIN Account a ON c.customer_id = a.customer_id
WHERE c.first_name = 'Alice';

-- Recent transactions
SELECT t.type, t.amount, t.description, t.date
FROM Transaction t ORDER BY t.date DESC LIMIT 5;

-- Active loans
SELECT l.loan_type, l.amount, l.interest_rate, l.status
FROM Loan l WHERE l.status = 'Active';
```
