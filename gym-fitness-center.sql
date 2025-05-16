-- Create the database
CREATE DATABASE IF NOT EXISTS gym_fitness_center;
USE gym_fitness_center;

-- Table: Members
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    date_of_birth DATE,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT,
    membership_id INT,
    registration_date DATE DEFAULT CURRENT_DATE
);

-- Table: Trainers
CREATE TABLE Trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(100),
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    hire_date DATE DEFAULT CURRENT_DATE
);

-- Table: Membership_Plans
CREATE TABLE Membership_Plans (
    membership_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(50) NOT NULL UNIQUE,
    duration_months INT NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    description TEXT
);

-- Alter Members to set foreign key after Membership_Plans is created
ALTER TABLE Members
ADD CONSTRAINT fk_membership
FOREIGN KEY (membership_id) REFERENCES Membership_Plans(membership_id);

-- Table: Equipment
CREATE TABLE Equipment (
    equipment_id INT AUTO_INCREMENT PRIMARY KEY,
    equipment_name VARCHAR(100) NOT NULL,
    purchase_date DATE,
    status ENUM('Working', 'Under Maintenance', 'Out of Order') DEFAULT 'Working',
    quantity INT NOT NULL CHECK (quantity >= 0)
);

-- Table: Classes
CREATE TABLE Classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL,
    schedule_time TIME NOT NULL,
    day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
    trainer_id INT,
    max_capacity INT DEFAULT 20,
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id)
);

-- Table: Class_Enrollment (M-M between Members and Classes)
CREATE TABLE Class_Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    class_id INT NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id),
    UNIQUE(member_id, class_id) -- to prevent duplicate enrollments
);

-- Table: Payments
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    payment_date DATE DEFAULT CURRENT_DATE,
    method ENUM('Cash', 'Card', 'Online') NOT NULL,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Table: Attendance
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    check_in DATETIME DEFAULT CURRENT_TIMESTAMP,
    check_out DATETIME,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Table: Trainer_Assignments (M-M between Trainers and Members)
CREATE TABLE Trainer_Assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    trainer_id INT NOT NULL,
    member_id INT NOT NULL,
    assigned_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    UNIQUE(trainer_id, member_id) -- Prevent duplicate assignments
);
