-- Создание последовательности для таблицы student
CREATE SEQUENCE student_id_seq;

-- Создание секционированной таблицы студентов
CREATE TABLE student (
    id INT NOT NULL DEFAULT nextval('student_id_seq'), -- Автоматическое увеличение id
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    PRIMARY KEY (id, birth_date) -- Первичный ключ включает birth_date
) PARTITION BY RANGE (birth_date);


-- Секции таблицы student
CREATE TABLE student_before_2000 PARTITION OF student
FOR VALUES FROM (MINVALUE) TO ('2000-01-01');
CREATE UNIQUE INDEX student_before_2000_id_idx ON student_before_2000 (id);

CREATE TABLE student_after_2000 PARTITION OF student
FOR VALUES FROM ('2000-01-01') TO (MAXVALUE);
CREATE UNIQUE INDEX student_after_2000_id_idx ON student_after_2000 (id);

-- Создание таблицы course
CREATE TABLE course (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    course_description TEXT
);

-- Создание таблицы enrollment (связь многие ко многим)
CREATE TABLE enrollment (
    student_id INT,
    student_birth_date DATE,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id, student_birth_date) REFERENCES student (id, birth_date),
    FOREIGN KEY (course_id) REFERENCES course (id)
);

-- Создание последовательности для таблицы student_by_last_name
CREATE SEQUENCE student_by_last_name_id_seq;

-- Секционирование таблицы student_by_last_name по фамилии (HASH)
CREATE TABLE student_by_last_name (
    id INT NOT NULL DEFAULT nextval('student_by_last_name_id_seq'),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
) PARTITION BY HASH (last_name);

-- Секции таблицы student_by_last_name
CREATE TABLE student_hash_1 PARTITION OF student_by_last_name
FOR VALUES WITH (MODULUS 2, REMAINDER 0);
CREATE UNIQUE INDEX student_hash_1_id_last_name_idx ON student_hash_1 (id, last_name);

CREATE TABLE student_hash_2 PARTITION OF student_by_last_name
FOR VALUES WITH (MODULUS 2, REMAINDER 1);
CREATE UNIQUE INDEX student_hash_2_id_last_name_idx ON student_hash_2 (id, last_name);

-- Создание таблицы студентов без секций для примера
CREATE TABLE student_flat (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
);