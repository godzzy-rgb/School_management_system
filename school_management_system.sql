

CREATE DATABASE IF NOT EXISTS school_management_system;
USE school_management_system;

--CLASSES TABLE
CREATE TABLE classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(50) NOT NULL UNIQUE,
    grade_level INT NOT NULL,
    section CHAR(1) NOT NULL,
    capacity INT DEFAULT 50,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- STUDENTS TABLE
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    roll_no VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    class_id INT NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    parent_name VARCHAR(100),
    parent_phone VARCHAR(15),
    parent_email VARCHAR(100),
    admission_date DATE NOT NULL,
    status ENUM('Active', 'Inactive', 'Graduated') DEFAULT 'Active',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);


-- . TEACHERS TABLE
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    qualification VARCHAR(100),
    specialization VARCHAR(100),
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    status ENUM('Active', 'Inactive', 'Leave') DEFAULT 'Active',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--SUBJECTS TABLE
CREATE TABLE subjects (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(100) NOT NULL,
    subject_code VARCHAR(20) NOT NULL UNIQUE,
    description TEXT,
    credit_hours INT DEFAULT 3,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--CLASS SUBJECT MAPPING TABLE
CREATE TABLE class_subject_mapping (
    mapping_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL,
    subject_id INT NOT NULL,
    teacher_id INT NOT NULL,
    total_periods INT DEFAULT 30,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    UNIQUE KEY unique_class_subject (class_id, subject_id)
);

--GRADES TABLE
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    exam_type VARCHAR(50) NOT NULL,
    marks_obtained DECIMAL(5, 2) NOT NULL,
    total_marks DECIMAL(5, 2) DEFAULT 100,
    grade_letter CHAR(2),
    percentage DECIMAL(5, 2),
    exam_date DATE,
    remarks TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

--ATTENDANCE TABLE
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Leave', 'Half-Day') DEFAULT 'Present',
    remarks TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    UNIQUE KEY unique_attendance (student_id, attendance_date)
);

--FEE STRUCTURE TABLE
CREATE TABLE fee_structure (
    fee_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL,
    tuition_fee DECIMAL(10, 2),
    lab_fee DECIMAL(10, 2) DEFAULT 0,
    sports_fee DECIMAL(10, 2) DEFAULT 0,
    transport_fee DECIMAL(10, 2) DEFAULT 0,
    other_charges DECIMAL(10, 2) DEFAULT 0,
    total_fee DECIMAL(10, 2),
    due_date DATE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

--FEE PAYMENT TABLE
CREATE TABLE fee_payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    fee_id INT NOT NULL,
    amount_paid DECIMAL(10, 2),
    payment_date DATE NOT NULL,
    payment_method ENUM('Cash', 'Check', 'Online', 'Bank Transfer') DEFAULT 'Cash',
    transaction_id VARCHAR(50),
    status ENUM('Paid', 'Partial', 'Pending', 'Late') DEFAULT 'Paid',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (fee_id) REFERENCES fee_structure(fee_id)
);

--ACTIVITIES TABLE
CREATE TABLE activities (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    activity_name VARCHAR(100) NOT NULL,
    activity_type ENUM('Sports', 'Cultural', 'Academic', 'Social') NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    location VARCHAR(100),
    coordinator_id INT,
    status ENUM('Planned', 'Ongoing', 'Completed', 'Cancelled') DEFAULT 'Planned',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coordinator_id) REFERENCES teachers(teacher_id)
);

--STUDENT ACTIVITY PARTICIPATION TABLE
CREATE TABLE student_activity_participation (
    participation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    activity_id INT NOT NULL,
    participation_level VARCHAR(50),
    achievement TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (activity_id) REFERENCES activities(activity_id)
);


-- 12. EXAMS TABLE

CREATE TABLE exams (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_name VARCHAR(100) NOT NULL,
    exam_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_marks INT DEFAULT 100,
    passing_marks INT DEFAULT 40,
    status ENUM('Scheduled', 'Ongoing', 'Completed') DEFAULT 'Scheduled',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


--  EXAM_SCHEDULE TABLE

CREATE TABLE exam_schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT NOT NULL,
    subject_id INT NOT NULL,
    exam_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room_number VARCHAR(20),
    invigilator_id INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (invigilator_id) REFERENCES teachers(teacher_id)
);


-- ADMIN TABLE

CREATE TABLE admin_users (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    role ENUM('Super Admin', 'Admin', 'Staff') DEFAULT 'Admin',
    phone_number VARCHAR(15),
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    last_login TIMESTAMP,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--notifications table
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    recipient_type ENUM('Student', 'Teacher', 'Parent', 'Admin') NOT NULL,
    recipient_id INT,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50),
    is_read BOOLEAN DEFAULT FALSE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



-- Classes
INSERT INTO classes (class_name, grade_level, section) VALUES
('Class 1-A', 1, 'A'),
('Class 1-B', 1, 'B'),
('Class 2-A', 2, 'A'),
('Class 2-B', 2, 'B'),
('Class 3-A', 3, 'A'),
('Class 4-A', 4, 'A'),
('Class 5-A', 5, 'A'),
('Class 8-A', 8, 'A'),
('Class 9-A', 9, 'A'),
('Class 10-A', 10, 'A');

-- Students
INSERT INTO students (roll_no, first_name, last_name, date_of_birth, gender, class_id, email, phone_number, address, city, country, parent_name, parent_phone, parent_email, admission_date, status) VALUES
('2024-0001', 'Ahmad', 'Khan', '2015-03-15', 'Male', 1, 'ahmad.khan@school.com', '03001234567', '123 Main Street', 'Islamabad', 'Pakistan', 'Ali Khan', '03008888888', 'ali.khan@email.com', '2023-04-01', 'Active'),
('2024-0002', 'Fatima', 'Ahmed', '2015-05-22', 'Female', 1, 'fatima.ahmed@school.com', '03002345678', '456 Oak Avenue', 'Islamabad', 'Pakistan', 'Ahmed Hassan', '03009999999', 'ahmed.hassan@email.com', '2023-04-01', 'Active'),
('2024-0003', 'Hassan', 'Ali', '2015-07-10', 'Male', 1, 'hassan.ali@school.com', '03003456789', '789 Pine Road', 'Islamabad', 'Pakistan', 'Ali Hassan', '03007777777', 'ali.hassan@email.com', '2023-04-01', 'Active'),
('2024-0004', 'Aisha', 'Muhammad', '2015-09-18', 'Female', 1, 'aisha.muhammad@school.com', '03004567890', '321 Elm Street', 'Islamabad', 'Pakistan', 'Muhammad Hassan', '03006666666', 'muhammad.hassan@email.com', '2023-04-01', 'Active'),
('2024-0005', 'Usman', 'Malik', '2015-11-25', 'Male', 1, 'usman.malik@school.com', '03005678901', '654 Birch Lane', 'Islamabad', 'Pakistan', 'Malik Usman', '03005555555', 'malik.usman@email.com', '2023-04-01', 'Active'),

('2024-0006', 'Zainab', 'Khan', '2014-02-14', 'Female', 2, 'zainab.khan@school.com', '03006789012', '987 Cedar Drive', 'Islamabad', 'Pakistan', 'Khan Tariq', '03004444444', 'khan.tariq@email.com', '2023-04-01', 'Active'),
('2024-0007', 'Muhammad', 'Hassan', '2014-04-20', 'Male', 2, 'muhammad.hassan@school.com', '03007890123', '159 Maple Court', 'Islamabad', 'Pakistan', 'Hassan Ahmed', '03003333333', 'hassan.ahmed@email.com', '2023-04-01', 'Active'),
('2024-0008', 'Ayesha', 'Ali', '2014-06-30', 'Female', 2, 'ayesha.ali@school.com', '03008901234', '753 Spruce Way', 'Islamabad', 'Pakistan', 'Ali Rashid', '03002222222', 'ali.rashid@email.com', '2023-04-01', 'Active'),

('2024-0009', 'Ali', 'Raza', '2013-01-12', 'Male', 3, 'ali.raza@school.com', '03009012345', '852 Walnut Street', 'Islamabad', 'Pakistan', 'Raza Khan', '03001111111', 'raza.khan@email.com', '2023-04-01', 'Active'),
('2024-0010', 'Hira', 'Nasir', '2013-03-25', 'Female', 3, 'hira.nasir@school.com', '03000123456', '741 Ash Lane', 'Islamabad', 'Pakistan', 'Nasir Ahmed', '03000000000', 'nasir.ahmed@email.com', '2023-04-01', 'Active');

-- Teachers
INSERT INTO teachers (employee_id, first_name, last_name, date_of_birth, gender, email, phone_number, address, city, country, qualification, specialization, hire_date, salary, status) VALUES
('T001', 'Dr.', 'Iqbal', '1980-05-15', 'Male', 'iqbal.teacher@school.com', '03011111111', 'Teacher Colony', 'Islamabad', 'Pakistan', 'M.A., B.Ed', 'English', '2018-07-01', 75000.00, 'Active'),
('T002', 'Mrs.', 'Rabia', '1985-08-20', 'Female', 'rabia.teacher@school.com', '03022222222', 'Teacher Colony', 'Islamabad', 'Pakistan', 'M.Sc., B.Ed', 'Mathematics', '2019-06-15', 70000.00, 'Active'),
('T003', 'Mr.', 'Tariq', '1982-03-10', 'Male', 'tariq.teacher@school.com', '03033333333', 'Teacher Colony', 'Islamabad', 'Pakistan', 'M.A., B.Ed', 'Science', '2018-01-10', 72000.00, 'Active'),
('T004', 'Mrs.', 'Hina', '1987-11-05', 'Female', 'hina.teacher@school.com', '03044444444', 'Teacher Colony', 'Islamabad', 'Pakistan', 'B.A., B.Ed', 'Social Studies', '2019-09-01', 65000.00, 'Active'),
('T005', 'Mr.', 'Hamza', '1983-07-18', 'Male', 'hamza.teacher@school.com', '03055555555', 'Teacher Colony', 'Islamabad', 'Pakistan', 'B.Sc., B.Ed', 'Computer Science', '2020-03-15', 68000.00, 'Active'),
('T006', 'Mrs.', 'Amina', '1988-09-22', 'Female', 'amina.teacher@school.com', '03066666666', 'Teacher Colony', 'Islamabad', 'Pakistan', 'B.A., B.Ed', 'Urdu', '2020-08-01', 60000.00, 'Active');

-- Subjects
INSERT INTO subjects (subject_name, subject_code, description, credit_hours) VALUES
('English', 'ENG001', 'English Language and Literature', 3),
('Mathematics', 'MATH001', 'Basic Mathematics and Algebra', 3),
('Science', 'SCI001', 'General Science', 3),
('Social Studies', 'SS001', 'History, Geography, and Civics', 3),
('Computer Science', 'CS001', 'Introduction to Computers and Programming', 3),
('Urdu', 'URDU001', 'Urdu Language', 3),
('Physical Education', 'PE001', 'Sports and Fitness', 2),
('Islamic Studies', 'IS001', 'Islamic Studies', 2);

-- Class Subject Mapping (Teachers assigned to subjects in classes)
INSERT INTO class_subject_mapping (class_id, subject_id, teacher_id, total_periods) VALUES
(1, 1, 1, 30),  -- English in Class 1-A by Dr. Iqbal
(1, 2, 2, 30),  -- Math in Class 1-A by Mrs. Rabia
(1, 3, 3, 30),  -- Science in Class 1-A by Mr. Tariq
(1, 4, 4, 25),  -- Social Studies in Class 1-A by Mrs. Hina
(1, 6, 6, 25),  -- Urdu in Class 1-A by Mrs. Amina
(2, 1, 1, 30),  -- English in Class 2-A by Dr. Iqbal
(2, 2, 2, 30),  -- Math in Class 2-A by Mrs. Rabia
(2, 3, 3, 30),  -- Science in Class 2-A by Mr. Tariq
(3, 1, 1, 32),  -- English in Class 3-A by Dr. Iqbal
(3, 2, 2, 32),  -- Math in Class 3-A by Mrs. Rabia
(3, 5, 5, 28);  -- Computer Science in Class 3-A by Mr. Hamza

-- Grades/Marks
INSERT INTO grades (student_id, subject_id, exam_type, marks_obtained, total_marks, grade_letter, percentage, exam_date, remarks) VALUES
(1, 1, 'Mid Term', 75, 100, 'A-', 75.00, '2024-03-15', 'Good Performance'),
(1, 2, 'Mid Term', 82, 100, 'A', 82.00, '2024-03-20', 'Excellent'),
(1, 3, 'Mid Term', 70, 100, 'B+', 70.00, '2024-03-25', 'Good'),
(2, 1, 'Mid Term', 88, 100, 'A', 88.00, '2024-03-15', 'Excellent'),
(2, 2, 'Mid Term', 76, 100, 'A-', 76.00, '2024-03-20', 'Good'),
(2, 3, 'Mid Term', 85, 100, 'A', 85.00, '2024-03-25', 'Excellent'),
(3, 1, 'Mid Term', 65, 100, 'B', 65.00, '2024-03-15', 'Satisfactory'),
(3, 2, 'Mid Term', 72, 100, 'B+', 72.00, '2024-03-20', 'Good'),
(3, 3, 'Mid Term', 78, 100, 'A-', 78.00, '2024-03-25', 'Good'),
(4, 1, 'Mid Term', 92, 100, 'A+', 92.00, '2024-03-15', 'Outstanding'),
(4, 2, 'Mid Term', 87, 100, 'A', 87.00, '2024-03-20', 'Excellent'),
(5, 1, 'Mid Term', 68, 100, 'B', 68.00, '2024-03-15', 'Satisfactory'),
(5, 2, 'Mid Term', 74, 100, 'B+', 74.00, '2024-03-20', 'Good'),
(6, 1, 'Mid Term', 80, 100, 'A-', 80.00, '2024-03-15', 'Good'),
(6, 2, 'Mid Term', 77, 100, 'A-', 77.00, '2024-03-20', 'Good'),
(7, 1, 'Mid Term', 85, 100, 'A', 85.00, '2024-03-15', 'Excellent'),
(8, 2, 'Mid Term', 79, 100, 'A-', 79.00, '2024-03-20', 'Good'),
(9, 1, 'Mid Term', 71, 100, 'B+', 71.00, '2024-03-15', 'Good'),
(10, 2, 'Mid Term', 83, 100, 'A', 83.00, '2024-03-20', 'Excellent');

-- Attendance
INSERT INTO attendance (student_id, class_id, attendance_date, status, remarks) VALUES
(1, 1, '2024-06-01', 'Present', 'On time'),
(1, 1, '2024-06-02', 'Present', 'On time'),
(1, 1, '2024-06-03', 'Absent', 'Sick'),
(1, 1, '2024-06-04', 'Present', 'On time'),
(2, 1, '2024-06-01', 'Present', 'On time'),
(2, 1, '2024-06-02', 'Present', 'On time'),
(2, 1, '2024-06-03', 'Present', 'On time'),
(2, 1, '2024-06-04', 'Leave', 'Family event'),
(3, 1, '2024-06-01', 'Present', 'On time'),
(3, 1, '2024-06-02', 'Half-Day', 'Appointment'),
(3, 1, '2024-06-03', 'Present', 'On time'),
(3, 1, '2024-06-04', 'Present', 'On time'),
(4, 1, '2024-06-01', 'Present', 'On time'),
(4, 1, '2024-06-02', 'Present', 'On time'),
(4, 1, '2024-06-03', 'Present', 'On time'),
(4, 1, '2024-06-04', 'Present', 'On time'),
(5, 1, '2024-06-01', 'Present', 'On time'),
(5, 1, '2024-06-02', 'Absent', 'Not well'),
(5, 1, '2024-06-03', 'Present', 'On time'),
(5, 1, '2024-06-04', 'Present', 'On time');

-- Fee Structure
INSERT INTO fee_structure (class_id, tuition_fee, lab_fee, sports_fee, transport_fee, other_charges, total_fee, due_date) VALUES
(1, 15000.00, 2000.00, 3000.00, 5000.00, 2000.00, 27000.00, '2024-06-30'),
(2, 17000.00, 2500.00, 3000.00, 5000.00, 2000.00, 29500.00, '2024-06-30'),
(3, 18000.00, 3000.00, 3000.00, 5000.00, 2500.00, 31500.00, '2024-06-30'),
(4, 20000.00, 3500.00, 3500.00, 5000.00, 3000.00, 35000.00, '2024-06-30'),
(5, 22000.00, 4000.00, 4000.00, 5000.00, 3500.00, 38500.00, '2024-06-30');

-- Fee Payment
INSERT INTO fee_payment (student_id, fee_id, amount_paid, payment_date, payment_method, transaction_id, status) VALUES
(1, 1, 27000.00, '2024-05-15', 'Online', 'TXN123456', 'Paid'),
(2, 1, 27000.00, '2024-05-10', 'Bank Transfer', 'TXN123457', 'Paid'),
(3, 1, 13500.00, '2024-05-20', 'Cash', NULL, 'Partial'),
(4, 1, 27000.00, '2024-05-05', 'Check', 'CHK001', 'Paid'),
(5, 1, 0.00, '2024-06-15', 'Online', NULL, 'Pending'),
(6, 2, 29500.00, '2024-05-12', 'Online', 'TXN123458', 'Paid'),
(7, 2, 29500.00, '2024-05-18', 'Bank Transfer', 'TXN123459', 'Paid'),
(8, 2, 29500.00, '2024-05-25', 'Cash', NULL, 'Late');

-- Activities
INSERT INTO activities (activity_name, activity_type, description, start_date, end_date, location, coordinator_id, status) VALUES
('Annual Sports Day', 'Sports', 'Inter-house sports competition', '2024-04-15', '2024-04-16', 'School Ground', 1, 'Completed'),
('Science Fair', 'Academic', 'Student science projects exhibition', '2024-05-10', '2024-05-12', 'School Auditorium', 3, 'Completed'),
('Urdu Poetry Recitation', 'Cultural', 'Poetry and literary event', '2024-04-23', '2024-04-23', 'School Auditorium', 6, 'Completed'),
('Math Olympiad', 'Academic', 'Mathematics competition', '2024-06-01', '2024-06-15', 'Classroom', 2, 'Ongoing'),
('Art Exhibition', 'Cultural', 'Student artwork display', '2024-06-20', '2024-06-22', 'School Hall', 4, 'Planned');

-- Student Activity Participation
INSERT INTO student_activity_participation (student_id, activity_id, participation_level, achievement) VALUES
(1, 1, 'Participant', 'Gold Medal in 100m Race'),
(2, 2, 'Participant', 'First Prize in Physics Project'),
(3, 3, 'Participant', 'Best Recitation Award'),
(4, 4, 'Participant', 'Qualified for Finals'),
(5, 1, 'Participant', 'Silver Medal in Relay Race'),
(6, 2, 'Participant', 'Participation Certificate'),
(7, 3, 'Participant', 'Participation Certificate'),
(8, 4, 'Participant', 'Participation Certificate'),
(9, 1, 'Participant', 'Bronze Medal in 200m Race'),
(10, 2, 'Participant', 'Second Prize in Chemistry Project');

-- Exams
INSERT INTO exams (exam_name, exam_type, start_date, end_date, total_marks, passing_marks, status) VALUES
('Mid Term Exam', 'Mid Term', '2024-03-15', '2024-03-30', 100, 40, 'Completed'),
('Final Term Exam', 'Final Term', '2024-05-20', '2024-06-10', 100, 40, 'Scheduled'),
('Annual Exam', 'Annual', '2024-05-01', '2024-06-30', 500, 180, 'Scheduled');

-- Exam Schedule
INSERT INTO exam_schedule (exam_id, subject_id, exam_date, start_time, end_time, room_number, invigilator_id) VALUES
(1, 1, '2024-03-15', '09:00:00', '11:00:00', 'Room 1', 1),
(1, 2, '2024-03-18', '09:00:00', '11:00:00', 'Room 2', 2),
(1, 3, '2024-03-21', '09:00:00', '11:00:00', 'Room 3', 3),
(2, 1, '2024-05-20', '09:00:00', '11:30:00', 'Room 1', 1),
(2, 2, '2024-05-23', '09:00:00', '11:30:00', 'Room 2', 2),
(2, 3, '2024-05-26', '09:00:00', '11:30:00', 'Room 3', 3),
(3, 1, '2024-05-01', '09:00:00', '12:00:00', 'Room 1', 1),
(3, 2, '2024-05-08', '09:00:00', '12:00:00', 'Room 2', 2);

-- Admin Users
INSERT INTO admin_users (username, password_hash, email, first_name, last_name, role, phone_number, status) VALUES
('admin1', 'hashed_password_123', 'admin1@school.com', 'Admin', 'User', 'Super Admin', '03101111111', 'Active'),
('admin2', 'hashed_password_456', 'admin2@school.com', 'Staff', 'Member', 'Admin', '03102222222', 'Active'),
('staff1', 'hashed_password_789', 'staff1@school.com', 'Support', 'Staff', 'Staff', '03103333333', 'Active');

-- Notifications
INSERT INTO notifications (recipient_type, recipient_id, title, message, notification_type, is_read) VALUES
('Student', 1, 'Exam Schedule', 'Your mid-term exam schedule is available', 'Exam', 0),
('Student', 2, 'Fee Reminder', 'Your fee is due on 30-06-2024', 'Fee', 0),
('Parent', 1, 'Progress Report', 'Your child has completed mid-term exams', 'Academic', 0),
('Teacher', 1, 'Class Assignment', 'Please submit class result entry', 'Administrative', 0),
('Student', 3, 'Activity Alert', 'You are selected for Science Fair', 'Activity', 1);


CREATE INDEX idx_student_class ON students(class_id);
CREATE INDEX idx_student_roll ON students(roll_no);
CREATE INDEX idx_grades_student ON grades(student_id);
CREATE INDEX idx_grades_subject ON grades(subject_id);
CREATE INDEX idx_attendance_student ON attendance(student_id);
CREATE INDEX idx_attendance_date ON attendance(attendance_date);
CREATE INDEX idx_fee_payment_student ON fee_payment(student_id);
CREATE INDEX idx_notifications_recipient ON notifications(recipient_type, recipient_id);
CREATE INDEX idx_teacher_email ON teachers(email);
CREATE INDEX idx_admin_username ON admin_users(username);


