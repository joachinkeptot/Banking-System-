-- Banking System Seed Data

-- ─────────────────────────────────────────────
-- EMPLOYEE (insert top-level managers first, then reports)
-- ─────────────────────────────────────────────
INSERT IGNORE INTO Employee (first_name, last_name, phone_num, address, email, date_of_birth, manager_id) VALUES
('James',   'Carter',   '555-0101', '10 Elm St, New York, NY',      'james.carter@bank.com',   '1968-03-14', NULL),
('Sandra',  'Mitchell', '555-0102', '22 Oak Ave, Los Angeles, CA',   'sandra.mitchell@bank.com','1972-07-29', NULL),
('Robert',  'Hayes',    '555-0103', '5 Pine Rd, Chicago, IL',        'robert.hayes@bank.com',   '1975-11-05', 1),
('Linda',   'Torres',   '555-0104', '88 Maple Dr, Houston, TX',      'linda.torres@bank.com',   '1980-02-18', 2),
('Michael', 'Brooks',   '555-0105', '34 Cedar Ln, Phoenix, AZ',      'michael.brooks@bank.com', '1983-09-22', 1),
('Jessica', 'Nguyen',   '555-0106', '71 Birch Blvd, Philadelphia, PA','jessica.nguyen@bank.com','1990-05-11', 3),
('Daniel',  'Kim',      '555-0107', '19 Walnut St, San Antonio, TX', 'daniel.kim@bank.com',     '1988-12-30', 4),
('Emily',   'Robinson', '555-0108', '62 Spruce Ave, San Diego, CA',  'emily.robinson@bank.com', '1993-08-04', 2);

-- ─────────────────────────────────────────────
-- BRANCH
-- ─────────────────────────────────────────────
INSERT IGNORE INTO Branch (branch_name, address, phone_num, manager_id) VALUES
('Downtown New York',    '1 Wall St, New York, NY 10005',          '212-555-0200', 1),
('West LA',              '3500 Wilshire Blvd, Los Angeles, CA 90010','310-555-0201', 2),
('Chicago Loop',         '200 S Michigan Ave, Chicago, IL 60604',   '312-555-0202', 3),
('Houston Central',      '500 Main St, Houston, TX 77002',          '713-555-0203', 4),
('Phoenix Midtown',      '2100 N Central Ave, Phoenix, AZ 85004',   '602-555-0204', 5);

-- ─────────────────────────────────────────────
-- CUSTOMER
-- ─────────────────────────────────────────────
INSERT IGNORE INTO Customer (first_name, last_name, email, phone_num, address, date_of_birth) VALUES
('Alice',   'Johnson',  'alice.johnson@email.com',  '555-1001', '45 Broadway, New York, NY',        '1985-04-12'),
('Bob',     'Williams', 'bob.williams@email.com',   '555-1002', '810 Sunset Blvd, Los Angeles, CA', '1990-08-23'),
('Carol',   'Davis',    'carol.davis@email.com',    '555-1003', '333 Lake Shore Dr, Chicago, IL',   '1978-01-30'),
('David',   'Martinez', 'david.martinez@email.com', '555-1004', '900 Travis St, Houston, TX',       '1995-06-15'),
('Eva',     'Wilson',   'eva.wilson@email.com',     '555-1005', '1400 E Camelback Rd, Phoenix, AZ', '1988-11-07'),
('Frank',   'Anderson', 'frank.anderson@email.com', '555-1006', '240 Vesey St, New York, NY',       '1972-03-22'),
('Grace',   'Thomas',   'grace.thomas@email.com',   '555-1007', '600 Hollywood Blvd, Los Angeles, CA','1999-09-01'),
('Henry',   'Jackson',  'henry.jackson@email.com',  '555-1008', '55 E Monroe St, Chicago, IL',      '1982-07-14'),
('Isabella','White',    'isabella.white@email.com', '555-1009', '2200 Post Oak Blvd, Houston, TX',  '1993-02-28'),
('James',   'Harris',   'james.harris@email.com',   '555-1010', '300 W Van Buren St, Phoenix, AZ',  '1967-05-19');

-- ─────────────────────────────────────────────
-- ACCOUNT
-- ─────────────────────────────────────────────
INSERT IGNORE INTO Account (customer_id, branch_id, account_type, status, balance, open_date) VALUES
(1,  1, 'Checking', 'Active',   12500.00, '2019-03-10'),
(1,  1, 'Savings',  'Active',   45000.00, '2019-03-10'),
(2,  2, 'Checking', 'Active',    8300.50, '2020-06-15'),
(3,  3, 'Savings',  'Active',   62000.00, '2018-11-22'),
(3,  3, 'Business', 'Active',  130000.00, '2021-01-05'),
(4,  4, 'Checking', 'Active',    3200.75, '2022-04-18'),
(5,  5, 'Savings',  'Active',   27500.00, '2017-09-30'),
(6,  1, 'Business', 'Active',  250000.00, '2015-07-08'),
(7,  2, 'Checking', 'Inactive',  1100.00, '2023-02-14'),
(8,  3, 'Savings',  'Active',   18900.00, '2020-10-01'),
(9,  4, 'Checking', 'Active',    5640.25, '2021-08-19'),
(10, 5, 'Business', 'Closed',       0.00, '2016-03-27');

-- ─────────────────────────────────────────────
-- TRANSACTION
-- ─────────────────────────────────────────────
INSERT IGNORE INTO Transaction (account_id, type, amount, date, description, currency_type) VALUES
(1,  'Deposit',    5000.00, '2024-01-05 09:15:00', 'Payroll deposit',           'USD'),
(1,  'Withdrawal', 1200.00, '2024-01-12 14:30:00', 'Rent payment',              'USD'),
(1,  'Transfer',    500.00, '2024-02-01 11:00:00', 'Transfer to savings',       'USD'),
(2,  'Deposit',    2000.00, '2024-02-01 11:01:00', 'Transfer from checking',    'USD'),
(3,  'Deposit',    8300.50, '2024-01-20 10:00:00', 'Initial deposit',           'USD'),
(3,  'Withdrawal',  250.00, '2024-02-10 16:45:00', 'ATM withdrawal',            'USD'),
(4,  'Deposit',   15000.00, '2024-01-08 09:00:00', 'Wire transfer received',    'USD'),
(5,  'Deposit',   50000.00, '2024-01-15 08:30:00', 'Business revenue',          'USD'),
(5,  'Payment',   12000.00, '2024-02-05 13:20:00', 'Supplier payment',          'USD'),
(6,  'Deposit',    1500.00, '2024-02-20 10:10:00', 'Payroll deposit',           'USD'),
(6,  'Withdrawal',  300.00, '2024-03-01 09:50:00', 'Grocery purchase',          'USD'),
(7,  'Deposit',   10000.00, '2023-12-01 12:00:00', 'Year-end bonus',            'USD'),
(8,  'Deposit',  100000.00, '2024-01-02 08:00:00', 'Business capital injection','USD'),
(8,  'Payment',   30000.00, '2024-02-15 14:00:00', 'Office lease payment',      'USD'),
(10, 'Deposit',    5000.00, '2024-01-10 11:30:00', 'Savings contribution',      'USD'),
(11, 'Deposit',    3000.00, '2024-02-01 09:00:00', 'Direct deposit',            'USD'),
(11, 'Withdrawal',  500.00, '2024-02-28 17:00:00', 'Bill payment',              'USD'),
(1,  'Deposit',    4500.00, '2024-03-05 09:15:00', 'Payroll deposit',           'USD'),
(4,  'Withdrawal', 2000.00, '2024-03-10 10:30:00', 'Equipment purchase',        'USD'),
(5,  'Transfer',   8000.00, '2024-03-15 14:00:00', 'Inter-account transfer',    'USD');

-- ─────────────────────────────────────────────
-- LOAN
-- ─────────────────────────────────────────────
INSERT IGNORE INTO Loan (account_id, loan_type, amount, interest_rate, start_date, end_date, status) VALUES
(1,  'Personal',  15000.00, 7.50, '2023-06-01', '2026-06-01', 'Active'),
(4,  'Mortgage',  320000.00, 4.25, '2021-03-15', '2051-03-15', 'Active'),
(5,  'Business',  100000.00, 6.00, '2022-01-10', '2027-01-10', 'Active'),
(7,  'Personal',  12000.00, 5.75, '2020-09-01', '2023-09-01', 'Paid'),
(3,  'Auto',      25000.00, 5.99, '2022-07-20', '2027-07-20', 'Active'),
(6,  'Personal',   8000.00, 8.00, '2023-11-01', '2025-11-01', 'Active'),
(8,  'Business',  500000.00, 5.50, '2020-01-15', '2030-01-15', 'Active'),
(10, 'Student',    18000.00, 3.75, '2021-08-01', '2031-08-01', 'Active'),
(2,  'Auto',       22000.00, 6.25, '2023-03-10', '2028-03-10', 'Active'),
(11, 'Personal',   5000.00, 9.00, '2024-01-01', '2026-01-01', 'Active');

-- ─────────────────────────────────────────────
-- LOAN_PAYMENT
-- ─────────────────────────────────────────────
INSERT IGNORE INTO Loan_payment (loan_id, amount_paid, payment_date, remaining_balance) VALUES
(1,  450.00, '2023-07-01', 14600.00),
(1,  450.00, '2023-08-01', 14150.00),
(1,  450.00, '2023-09-01', 13700.00),
(1,  450.00, '2023-10-01', 13250.00),
(1,  450.00, '2023-11-01', 12800.00),
(1,  450.00, '2023-12-01', 12350.00),
(1,  450.00, '2024-01-01', 11900.00),
(1,  450.00, '2024-02-01', 11450.00),
(2, 1450.00, '2021-04-15', 318600.00),
(2, 1450.00, '2021-05-15', 317150.00),
(2, 1450.00, '2021-06-15', 315700.00),
(2, 1450.00, '2024-01-15', 280000.00),
(3, 2000.00, '2022-02-10', 98100.00),
(3, 2000.00, '2022-03-10', 96200.00),
(3, 2000.00, '2024-01-10', 72000.00),
(4, 1200.00, '2020-10-01', 10800.00),
(4, 1200.00, '2021-04-01',  7200.00),
(4, 1200.00, '2021-10-01',  3600.00),
(4, 3600.00, '2023-09-01',     0.00),
(5,  500.00, '2022-08-20', 24550.00),
(5,  500.00, '2023-01-20', 22000.00),
(5,  500.00, '2024-01-20', 19500.00),
(6,  350.00, '2023-12-01',  7700.00),
(6,  350.00, '2024-01-01',  7350.00),
(6,  350.00, '2024-02-01',  7000.00),
(7, 5000.00, '2020-02-15', 495500.00),
(7, 5000.00, '2021-01-15', 470000.00),
(7, 5000.00, '2024-01-15', 390000.00),
(8,  200.00, '2021-09-01', 17830.00),
(8,  200.00, '2022-09-01', 15400.00),
(8,  200.00, '2024-01-01', 13000.00),
(9,  450.00, '2023-04-10', 21600.00),
(9,  450.00, '2023-10-10', 18900.00),
(9,  450.00, '2024-02-10', 16700.00),
(10, 250.00, '2024-02-01',  4780.00),
(10, 250.00, '2024-03-01',  4530.00);
