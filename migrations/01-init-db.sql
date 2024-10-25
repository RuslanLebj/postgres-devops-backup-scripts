-- Создание таблицы student
CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
);

-- Создание таблицы course
CREATE TABLE course (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    course_description TEXT
);

-- Создание таблицы enrollment (связь многие ко многим)
CREATE TABLE enrollment (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (course_id) REFERENCES course(id)
);
