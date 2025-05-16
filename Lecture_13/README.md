# Lecture 13
1. Створення бази даних
```sql
CREATE DATABASE SchoolDB;
```
![Screenshot 2025-05-16 at 09.24.22.png](assets/Screenshot%202025-05-16%20at%2009.24.22.png)
2. Таблиця Institutions
```sql
CREATE TABLE Institutions (
    institution_id INT AUTO_INCREMENT PRIMARY KEY,
    institution_name VARCHAR(255) NOT NULL,
    institution_type ENUM('School', 'Kindergarten') NOT NULL,
    address VARCHAR(255) NOT NULL
);
```
![Screenshot 2025-05-16 at 09.26.16.png](assets/Screenshot%202025-05-16%20at%2009.26.16.png)
![Screenshot 2025-05-16 at 09.26.54.png](assets/Screenshot%202025-05-16%20at%2009.26.54.png)
3. Таблиця Classes
```sql
CREATE TABLE Classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL,
    institution_id INT,
    direction ENUM('Mathematics', 'Biology and Chemistry', 'Language Studies'),
    CONSTRAINT FK_Classes_InstitutionId FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id)
);
```
![Screenshot 2025-05-16 at 09.36.45.png](assets/Screenshot%202025-05-16%20at%2009.36.45.png)
![Screenshot 2025-05-16 at 09.36.31.png](assets/Screenshot%202025-05-16%20at%2009.36.31.png)
4. Таблиця Children
```sql
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
```
![Screenshot 2025-05-16 at 09.38.15.png](assets/Screenshot%202025-05-16%20at%2009.38.15.png)
![Screenshot 2025-05-16 at 09.39.38.png](assets/Screenshot%202025-05-16%20at%2009.39.38.png)
5. Таблиця Parents:
```sql
CREATE TABLE Parents (
    parent_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    child_id INT,
    tuition_fee DECIMAL(10,2),
    CONSTRAINT FK_Parents_ChildId FOREIGN KEY (child_id) REFERENCES Children(child_id)
);
```
![Screenshot 2025-05-16 at 09.45.13.png](assets/Screenshot%202025-05-16%20at%2009.45.13.png)
![Screenshot 2025-05-16 at 09.46.18.png](assets/Screenshot%202025-05-16%20at%2009.46.18.png)
6. Вставка імітованих даних
```sql
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
```
![Screenshot 2025-05-16 at 09.47.07.png](assets/Screenshot%202025-05-16%20at%2009.47.07.png)
![Screenshot 2025-05-16 at 09.48.15.png](assets/Screenshot%202025-05-16%20at%2009.48.15.png)
![Screenshot 2025-05-16 at 09.47.56.png](assets/Screenshot%202025-05-16%20at%2009.47.56.png)
![Screenshot 2025-05-16 at 09.47.39.png](assets/Screenshot%202025-05-16%20at%2009.47.39.png)
![Screenshot 2025-05-16 at 09.48.37.png](assets/Screenshot%202025-05-16%20at%2009.48.37.png)
7. Отримання списку всіх дітей разом із закладом, в якому вони навчаються, та напрямом навчання в класі
```sql
SELECT 
    ch.first_name, ch.last_name, i.institution_name, cl.direction
FROM 
    Children ch
JOIN 
    Institutions i ON ch.institution_id = i.institution_id
JOIN 
    Classes cl ON ch.class_id = cl.class_id;
```
![Screenshot 2025-05-16 at 09.50.31.png](assets/Screenshot%202025-05-16%20at%2009.50.31.png)
8. Отримання інформації про батьків і їхніх дітей разом із вартістю навчання
```sql
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
```
![Screenshot 2025-05-16 at 09.52.35.png](assets/Screenshot%202025-05-16%20at%2009.52.35.png)
9. Отримання списку всіх закладів з адресами та кількістю дітей, які навчаються в кожному закладі
```sql
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
```
![Screenshot 2025-05-16 at 09.53.19.png](assets/Screenshot%202025-05-16%20at%2009.53.19.png)
10. Бекапування даних

Експорт:
```shell
mysqldump -u root -p SchoolDB > SchoolDB_backup.sql
```

Імпорт:
```shell
mysql -u root -p -e "CREATE DATABASE SchoolDB_Copy;"
mysql -u root -p SchoolDB_Copy < SchoolDB_backup.sql
```

Під час імпорту даних отримав помилку, які вирішив змінивши параметри привілеїв
ERROR 3546 (HY000) at line 24: @@GLOBAL.GTID_PURGED cannot be changed: the added gtid set must not overlap with @@GLOBAL.GTID_EXECUTED
![Screenshot 2025-05-16 at 10.28.29.png](assets/Screenshot%202025-05-16%20at%2010.28.29.png)
![Screenshot 2025-05-16 at 10.44.48.png](assets/Screenshot%202025-05-16%20at%2010.44.48.png)
![Screenshot 2025-05-16 at 10.45.58.png](assets/Screenshot%202025-05-16%20at%2010.45.58.png)

12. Анонімізація даних
```sql
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
```
![Screenshot 2025-05-16 at 11.05.08.png](assets/Screenshot%202025-05-16%20at%2011.05.08.png)
Unsafe query: 'Update' 🙈 але нам так і треба
![Screenshot 2025-05-16 at 11.05.52.png](assets/Screenshot%202025-05-16%20at%2011.05.52.png)
![Screenshot 2025-05-16 at 11.08.08.png](assets/Screenshot%202025-05-16%20at%2011.08.08.png)
![Screenshot 2025-05-16 at 11.09.04.png](assets/Screenshot%202025-05-16%20at%2011.09.04.png)
![Screenshot 2025-05-16 at 11.11.16.png](assets/Screenshot%202025-05-16%20at%2011.11.16.png)
![Screenshot 2025-05-16 at 11.12.13.png](assets/Screenshot%202025-05-16%20at%2011.12.13.png)
![Screenshot 2025-05-16 at 11.13.02.png](assets/Screenshot%202025-05-16%20at%2011.13.02.png)
![Screenshot 2025-05-16 at 11.13.34.png](assets/Screenshot%202025-05-16%20at%2011.13.34.png)

Перевірка анонімізації:
```sql
SELECT * FROM Children;
SELECT * FROM Parents;
SELECT * FROM Institutions;
```