-- Banking System Database Schema
-- Based on ERD: Employee, Branch, Customer, Account, Transaction, Loan, Loan_payment

-- ─────────────────────────────────────────────
-- EMPLOYEE
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Employee (
    employee_id   INT           PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50)   NOT NULL,
    last_name     VARCHAR(50)   NOT NULL,
    phone_num     VARCHAR(20),
    address       VARCHAR(255),
    email         VARCHAR(100)  UNIQUE,
    date_of_birth DATE,
    -- Self-referencing FK for manager (optional, based on ERD arrow)
    manager_id    INT,
    CONSTRAINT fk_employee_manager FOREIGN KEY (manager_id) REFERENCES Employee(employee_id)
);

-- ─────────────────────────────────────────────
-- BRANCH
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Branch (
    branch_id    INT          PRIMARY KEY AUTO_INCREMENT,
    branch_name  VARCHAR(100) NOT NULL,
    address      VARCHAR(255),
    phone_num    VARCHAR(20),
    -- Branch is managed by an employee
    manager_id   INT,
    CONSTRAINT fk_branch_manager FOREIGN KEY (manager_id) REFERENCES Employee(employee_id)
);

-- ─────────────────────────────────────────────
-- CUSTOMER
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Customer (
    customer_id   INT          PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) UNIQUE,
    phone_num     VARCHAR(20),
    address       VARCHAR(255),
    date_of_birth DATE
);

-- ─────────────────────────────────────────────
-- ACCOUNT
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Account (
    account_id    INT             PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT             NOT NULL,
    branch_id     INT             NOT NULL,
    account_type  ENUM('Checking', 'Savings', 'Business') NOT NULL,
    status        ENUM('Active', 'Inactive', 'Closed')    NOT NULL DEFAULT 'Active',
    balance       DECIMAL(15, 2)  NOT NULL DEFAULT 0.00,
    open_date     DATE            NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_account_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT fk_account_branch   FOREIGN KEY (branch_id)   REFERENCES Branch(branch_id)
);

-- ─────────────────────────────────────────────
-- TRANSACTION
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Transaction (
    transaction_id  INT             PRIMARY KEY AUTO_INCREMENT,
    account_id      INT             NOT NULL,
    type            ENUM('Deposit', 'Withdrawal', 'Transfer', 'Payment') NOT NULL,
    amount          DECIMAL(15, 2)  NOT NULL,
    date            DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description     VARCHAR(255),
    currency_type   VARCHAR(10)     NOT NULL DEFAULT 'USD',
    CONSTRAINT fk_transaction_account FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

-- ─────────────────────────────────────────────
-- LOAN
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Loan (
    loan_id        INT             PRIMARY KEY AUTO_INCREMENT,
    account_id     INT             NOT NULL,
    loan_type      ENUM('Personal', 'Mortgage', 'Auto', 'Student', 'Business') NOT NULL,
    amount         DECIMAL(15, 2)  NOT NULL,
    interest_rate  DECIMAL(5, 2)   NOT NULL,  -- percentage, e.g. 5.25
    start_date     DATE            NOT NULL,
    end_date       DATE            NOT NULL,
    status         ENUM('Active', 'Paid', 'Defaulted') NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_loan_account FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

-- ─────────────────────────────────────────────
-- LOAN_PAYMENT
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Loan_payment (
    payment_id         INT             PRIMARY KEY AUTO_INCREMENT,
    loan_id            INT             NOT NULL,
    amount_paid        DECIMAL(15, 2)  NOT NULL,
    payment_date       DATE            NOT NULL DEFAULT (CURRENT_DATE),
    remaining_balance  DECIMAL(15, 2)  NOT NULL,
    CONSTRAINT fk_loanpayment_loan FOREIGN KEY (loan_id) REFERENCES Loan(loan_id)
);
