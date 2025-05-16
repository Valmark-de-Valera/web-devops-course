CREATE DATABASE SchoolDB;
USE SchoolDB;

CREATE TABLE Institutions (
    institution_id INT AUTO_INCREMENT PRIMARY KEY,
    institution_name VARCHAR(255) NOT NULL,
    institution_type ENUM('School', 'Kindergarten') NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE Classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL,
    institution_id INT,
    direction ENUM('Mathematics', 'Biology and Chemistry', 'Language Studies'),
    CONSTRAINT FK_Classes_InstitutionId FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id)
);

CREATE TABLE Children (
    child_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    birth_date DATE,
    year_of_entry YEAR,
    age INT,
    institution_id INT,
    class_id INT,
    CONSTRAINT FK_Children_InstitutionId FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id),
    CONSTRAINT FK_Children_ClassId FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

CREATE TABLE Parents (
    parent_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    child_id INT,
    tuition_fee DECIMAL(10,2),
    CONSTRAINT FK_Parents_ChildId FOREIGN KEY (child_id) REFERENCES Children(child_id)
);

INSERT INTO Institutions (institution_name, institution_type, address) VALUES
    ('Дитячий садок «Сонечко»', 'Kindergarten', 'вул. Кленова, 12'),
    ('Школа «Зелена Долина»', 'School', 'пр. Дубовий, 45'),
    ('Школа «Блакитне Небо»', 'School', 'вул. Соснова, 22');

INSERT INTO Classes (class_name, institution_id, direction) VALUES
    ('1-А Математика', 2, 'Mathematics'),
    ('2-Б Біо-Хімія', 3, 'Biology and Chemistry'),
    ('Підготовчий Мовний', 1, 'Language Studies');

INSERT INTO Children (first_name, last_name, birth_date, year_of_entry, age, institution_id, class_id) VALUES
    ('Аня', 'Петрова', '2015-03-12', 2022, 9, 2, 1),
    ('Богдан', 'Шевченко', '2014-07-21', 2021, 10, 3, 2),
    ('Оксана', 'Іваненко', '2018-11-05', 2024, 6, 1, 3);

INSERT INTO Parents (first_name, last_name, child_id, tuition_fee) VALUES
    ('Олена', 'Петрова', 1, 2000.00),
    ('Дмитро', 'Шевченко', 2, 2500.00),
    ('Надія', 'Іваненко', 3, 1800.00);

SELECT
    ch.first_name, ch.last_name, i.institution_name, cl.direction
FROM
    Children ch
        JOIN
    Institutions i ON ch.institution_id = i.institution_id
        JOIN
    Classes cl ON ch.class_id = cl.class_id;

SELECT
    p.first_name AS parent_first_name,
    p.last_name AS parent_last_name,
    ch.first_name AS child_first_name,
    ch.last_name AS child_last_name,
    p.tuition_fee
FROM
    Parents p
        JOIN
    Children ch ON p.child_id = ch.child_id;

SELECT
    i.institution_name,
    i.address,
    COUNT(ch.child_id) AS children_count
FROM
    Institutions i
        LEFT JOIN
    Children ch ON i.institution_id = ch.institution_id
GROUP BY
    i.institution_id;

-- Діти
UPDATE Children SET first_name = 'Child', last_name = 'Anonymous';

-- Батьки
UPDATE Parents
SET first_name = CONCAT('Parent', parent_id),
    last_name = CONCAT('Anon', parent_id);

-- Заклади
UPDATE Institutions
SET institution_name = CONCAT('Institution', institution_id);

-- Вартість навчання
UPDATE Parents
SET tuition_fee = ROUND(1800 + RAND() * 700); -- від 1800 до 2500

SELECT * FROM Children;
SELECT * FROM Parents;
SELECT * FROM Institutions;