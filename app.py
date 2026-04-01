from flask import Flask, render_template, request, redirect, url_for, flash
import mysql.connector
from config import DB_CONFIG

app = Flask(__name__)
app.secret_key = "banking_secret_key"


def get_db():
    return mysql.connector.connect(**DB_CONFIG)


def query(sql, params=(), fetchone=False):
    conn = get_db()
    cur = conn.cursor(dictionary=True)
    cur.execute(sql, params)
    result = cur.fetchone() if fetchone else cur.fetchall()
    conn.close()
    return result


def execute(sql, params=()):
    conn = get_db()
    cur = conn.cursor()
    cur.execute(sql, params)
    conn.commit()
    conn.close()


# ─── Dashboard ────────────────────────────────────────────────────────────────

@app.route("/")
def dashboard():
    stats = {
        "customers":    query("SELECT COUNT(*) AS n FROM Customer",    fetchone=True)["n"],
        "accounts":     query("SELECT COUNT(*) AS n FROM Account",     fetchone=True)["n"],
        "transactions": query("SELECT COUNT(*) AS n FROM Transaction", fetchone=True)["n"],
        "loans":        query("SELECT COUNT(*) AS n FROM Loan",        fetchone=True)["n"],
    }
    recent_tx = query(
        "SELECT t.transaction_id, a.account_id, t.type, t.amount, t.date, t.currency_type "
        "FROM Transaction t JOIN Account a ON t.account_id = a.account_id "
        "ORDER BY t.date DESC LIMIT 5"
    )
    return render_template("index.html", stats=stats, recent_tx=recent_tx)


# ─── Customers ────────────────────────────────────────────────────────────────

@app.route("/customers")
def customers():
    rows = query("SELECT * FROM Customer ORDER BY customer_id DESC")
    return render_template("customers.html", customers=rows)


@app.route("/customers/add", methods=["GET", "POST"])
def add_customer():
    if request.method == "POST":
        f = request.form
        execute(
            "INSERT INTO Customer (first_name, last_name, email, phone_num, address, date_of_birth) "
            "VALUES (%s, %s, %s, %s, %s, %s)",
            (f["first_name"], f["last_name"], f["email"], f["phone_num"], f["address"], f["date_of_birth"] or None),
        )
        flash("Customer added successfully.", "success")
        return redirect(url_for("customers"))
    return render_template("customer_form.html", action="Add", customer=None)


@app.route("/customers/edit/<int:cid>", methods=["GET", "POST"])
def edit_customer(cid):
    customer = query("SELECT * FROM Customer WHERE customer_id = %s", (cid,), fetchone=True)
    if request.method == "POST":
        f = request.form
        execute(
            "UPDATE Customer SET first_name=%s, last_name=%s, email=%s, phone_num=%s, address=%s, date_of_birth=%s "
            "WHERE customer_id=%s",
            (f["first_name"], f["last_name"], f["email"], f["phone_num"], f["address"], f["date_of_birth"] or None, cid),
        )
        flash("Customer updated.", "success")
        return redirect(url_for("customers"))
    return render_template("customer_form.html", action="Edit", customer=customer)


@app.route("/customers/delete/<int:cid>", methods=["POST"])
def delete_customer(cid):
    execute("DELETE FROM Customer WHERE customer_id = %s", (cid,))
    flash("Customer deleted.", "info")
    return redirect(url_for("customers"))


# ─── Accounts ─────────────────────────────────────────────────────────────────

@app.route("/accounts")
def accounts():
    rows = query(
        "SELECT a.*, CONCAT(c.first_name,' ',c.last_name) AS customer_name, b.branch_name "
        "FROM Account a "
        "JOIN Customer c ON a.customer_id = c.customer_id "
        "JOIN Branch b ON a.branch_id = b.branch_id "
        "ORDER BY a.account_id DESC"
    )
    return render_template("accounts.html", accounts=rows)


@app.route("/accounts/add", methods=["GET", "POST"])
def add_account():
    customers = query("SELECT customer_id, CONCAT(first_name,' ',last_name) AS name FROM Customer")
    branches  = query("SELECT branch_id, branch_name FROM Branch")
    if request.method == "POST":
        f = request.form
        execute(
            "INSERT INTO Account (customer_id, branch_id, account_type, status, balance, open_date) "
            "VALUES (%s, %s, %s, %s, %s, %s)",
            (f["customer_id"], f["branch_id"], f["account_type"], f["status"], f["balance"], f["open_date"]),
        )
        flash("Account created.", "success")
        return redirect(url_for("accounts"))
    return render_template("account_form.html", customers=customers, branches=branches)


# ─── Transactions ─────────────────────────────────────────────────────────────

@app.route("/transactions")
def transactions():
    rows = query(
        "SELECT t.*, a.account_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name "
        "FROM Transaction t "
        "JOIN Account a ON t.account_id = a.account_id "
        "JOIN Customer c ON a.customer_id = c.customer_id "
        "ORDER BY t.date DESC LIMIT 100"
    )
    return render_template("transactions.html", transactions=rows)


@app.route("/transactions/add", methods=["GET", "POST"])
def add_transaction():
    accounts = query(
        "SELECT a.account_id, CONCAT(c.first_name,' ',c.last_name,' (Acc #',a.account_id,')') AS label "
        "FROM Account a JOIN Customer c ON a.customer_id = c.customer_id"
    )
    if request.method == "POST":
        f = request.form
        execute(
            "INSERT INTO Transaction (account_id, type, amount, date, description, currency_type) "
            "VALUES (%s, %s, %s, %s, %s, %s)",
            (f["account_id"], f["type"], f["amount"], f["date"], f["description"], f["currency_type"]),
        )
        # Update account balance for deposits/withdrawals
        if f["type"] == "Deposit":
            execute("UPDATE Account SET balance = balance + %s WHERE account_id = %s", (f["amount"], f["account_id"]))
        elif f["type"] == "Withdrawal":
            execute("UPDATE Account SET balance = balance - %s WHERE account_id = %s", (f["amount"], f["account_id"]))
        flash("Transaction recorded.", "success")
        return redirect(url_for("transactions"))
    return render_template("transaction_form.html", accounts=accounts)


# ─── Loans ────────────────────────────────────────────────────────────────────

@app.route("/loans")
def loans():
    rows = query(
        "SELECT l.*, CONCAT(c.first_name,' ',c.last_name) AS customer_name "
        "FROM Loan l "
        "JOIN Account a ON l.account_id = a.account_id "
        "JOIN Customer c ON a.customer_id = c.customer_id "
        "ORDER BY l.loan_id DESC"
    )
    return render_template("loans.html", loans=rows)


@app.route("/loans/add", methods=["GET", "POST"])
def add_loan():
    accounts = query(
        "SELECT a.account_id, CONCAT(c.first_name,' ',c.last_name,' (Acc #',a.account_id,')') AS label "
        "FROM Account a JOIN Customer c ON a.customer_id = c.customer_id"
    )
    if request.method == "POST":
        f = request.form
        execute(
            "INSERT INTO Loan (account_id, loan_type, amount, interest_rate, start_date, end_date, status) "
            "VALUES (%s, %s, %s, %s, %s, %s, %s)",
            (f["account_id"], f["loan_type"], f["amount"], f["interest_rate"], f["start_date"], f["end_date"], f["status"]),
        )
        flash("Loan created.", "success")
        return redirect(url_for("loans"))
    return render_template("loan_form.html", accounts=accounts)


@app.route("/loans/<int:lid>/payments", methods=["GET", "POST"])
def loan_payments(lid):
    loan = query("SELECT * FROM Loan WHERE loan_id = %s", (lid,), fetchone=True)
    payments = query("SELECT * FROM Loan_payment WHERE loan_id = %s ORDER BY payment_date DESC", (lid,))
    if request.method == "POST":
        f = request.form
        execute(
            "INSERT INTO Loan_payment (loan_id, amount_paid, payment_date, remaining_balance) VALUES (%s, %s, %s, %s)",
            (lid, f["amount_paid"], f["payment_date"], f["remaining_balance"]),
        )
        flash("Payment recorded.", "success")
        return redirect(url_for("loan_payments", lid=lid))
    return render_template("loan_payments.html", loan=loan, payments=payments)


if __name__ == "__main__":
    app.run(debug=True)
