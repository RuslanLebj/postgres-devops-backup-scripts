-- Генерация 50 случайных students
INSERT INTO student (first_name, last_name, birth_date)
SELECT 
    -- Случайный выбор имени из списка
    (ARRAY['John', 'Jane', 'Alice', 'Mark', 'Sophia', 'Michael', 'Emma', 'Liam', 'Olivia', 'Noah', 'Ava', 'Ethan', 'Isabella', 'Lucas', 'Mia', 'Henry', 'Amelia', 'James', 'Ella', 'Jack'])[floor(random() * 20 + 1)],

    -- Случайный выбор фамилии из списка
    (ARRAY['Doe', 'Smith', 'Johnson', 'Brown', 'Williams', 'Jones', 'Miller', 'Davis', 'Garcia', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin'])[floor(random() * 20 + 1)],

    -- Случайная дата рождения от 1980 до 2010 года
    date '1980-01-01' + (random() * (date '2010-12-31' - date '1980-01-01'))::int
FROM generate_series(1, 350);

-- Вставка 50 случайных courses
INSERT INTO course (course_name, course_description)
VALUES 
('Math 101', 'Introduction to Mathematics'),
('History 201', 'World History Overview'),
('Computer Science 101', 'Basics of Programming'),
('Art 303', 'Modern Art History'),
('Biology 101', 'Introduction to Biology'),
('Chemistry 102', 'Basics of Chemistry'),
('Physics 201', 'Mechanics and Electromagnetism'),
('Economics 101', 'Microeconomics Basics'),
('Philosophy 101', 'Introduction to Philosophy'),
('Psychology 101', 'Introduction to Psychology'),
('Sociology 101', 'Basics of Sociology'),
('Geography 101', 'Physical Geography Overview'),
('Political Science 201', 'Introduction to Political Systems'),
('Environmental Science 101', 'Environmental Issues and Solutions'),
('Business 101', 'Fundamentals of Business Administration'),
('Accounting 101', 'Basics of Accounting'),
('Marketing 101', 'Introduction to Marketing'),
('Finance 201', 'Corporate Finance Basics'),
('Engineering 101', 'Introduction to Engineering'),
('Anthropology 101', 'Introduction to Cultural Anthropology'),
('Astronomy 101', 'Basics of Astronomy'),
('Statistics 101', 'Introduction to Probability and Statistics'),
('Music 101', 'Music Theory Basics'),
('History of Art 102', 'Renaissance Art Overview'),
('Film Studies 101', 'Introduction to Film Theory'),
('Sports Science 101', 'Fundamentals of Sports Physiology'),
('Data Science 101', 'Introduction to Data Science'),
('Machine Learning 101', 'Basics of Machine Learning'),
('Artificial Intelligence 201', 'AI Algorithms and Applications'),
('Cybersecurity 101', 'Fundamentals of Cybersecurity'),
('Graphic Design 101', 'Introduction to Graphic Design'),
('Web Development 101', 'Basics of HTML, CSS, and JavaScript'),
('Database Systems 201', 'Relational Databases and SQL'),
('Cloud Computing 201', 'Introduction to Cloud Platforms'),
('Networking 101', 'Fundamentals of Computer Networks'),
('Game Design 101', 'Basics of Game Development'),
('Robotics 201', 'Introduction to Robotics'),
('Law 101', 'Basics of Civil Law'),
('Criminology 201', 'Introduction to Criminology'),
('Architecture 101', 'Fundamentals of Architecture'),
('Civil Engineering 201', 'Basics of Structural Engineering'),
('Electrical Engineering 201', 'Electronics and Circuits'),
('Mechanical Engineering 201', 'Introduction to Thermodynamics'),
('Ethics 101', 'Fundamentals of Ethics and Morality'),
('Literature 101', 'Introduction to Classical Literature'),
('Linguistics 201', 'Introduction to Linguistic Theory'),
('Education 101', 'Fundamentals of Teaching and Learning'),
('Culinary Arts 101', 'Introduction to Cooking and Food Science'),
('Theater 101', 'Basics of Acting and Performance'),
('Dance 101', 'Introduction to Dance Performance');

-- Генерация ~500 записей в таблицу enrollments
INSERT INTO enrollment (student_id, course_id, enrollment_date)
SELECT 
    FLOOR(1 + RANDOM() * 50)::INT,   -- случайный student_id от 1 до 50
    FLOOR(1 + RANDOM() * 50)::INT,   -- случайный course_id от 1 до 50
    '2023-01-01'::DATE + (RANDOM() * 365)::INT -- случайная дата от 2023-01-01 до 2023-12-31
FROM 
    generate_series(1, 500)
ON CONFLICT (student_id, course_id) DO NOTHING;


-- Генерация 50 случайных student в таблицу с секционировнием по hash
INSERT INTO student_by_last_name (first_name, last_name, birth_date)
SELECT 
    -- Случайный выбор имени из списка
    (ARRAY['John', 'Jane', 'Alice', 'Mark', 'Sophia', 'Michael', 'Emma', 'Liam', 'Olivia', 'Noah', 'Ava', 'Ethan', 'Isabella', 'Lucas', 'Mia', 'Henry', 'Amelia', 'James', 'Ella', 'Jack'])[floor(random() * 20 + 1)],

    -- Случайный выбор фамилии из списка
    (ARRAY['Doe', 'Smith', 'Johnson', 'Brown', 'Williams', 'Jones', 'Miller', 'Davis', 'Garcia', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin'])[floor(random() * 20 + 1)],

    -- Случайная дата рождения от 1980 до 2010 года
    date '1980-01-01' + (random() * (date '2010-12-31' - date '1980-01-01'))::int
FROM generate_series(1, 350);

-- Генерация 50 случайных students
INSERT INTO student_flat (first_name, last_name, birth_date)
SELECT 
    -- Случайный выбор имени из списка
    (ARRAY['John', 'Jane', 'Alice', 'Mark', 'Sophia', 'Michael', 'Emma', 'Liam', 'Olivia', 'Noah', 'Ava', 'Ethan', 'Isabella', 'Lucas', 'Mia', 'Henry', 'Amelia', 'James', 'Ella', 'Jack'])[floor(random() * 20 + 1)],

    -- Случайный выбор фамилии из списка
    (ARRAY['Doe', 'Smith', 'Johnson', 'Brown', 'Williams', 'Jones', 'Miller', 'Davis', 'Garcia', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin'])[floor(random() * 20 + 1)],

    -- Случайная дата рождения от 1980 до 2010 года
    date '1980-01-01' + (random() * (date '2010-12-31' - date '1980-01-01'))::int
FROM generate_series(1, 350);