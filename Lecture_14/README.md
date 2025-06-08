1. Підготуємо БД
```yaml
services:

  mongo:
    image: mongo
    restart: always
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: somepassword

  mongo-express:
    image: mongo-express
    restart: always
    ports:
      - 8081:8081
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: root
      ME_CONFIG_MONGODB_ADMINPASSWORD: somepassword
      ME_CONFIG_MONGODB_URL: mongodb://root:somepassword@mongo:27017/
      ME_CONFIG_BASICAUTH: false
```
2. Створення бази даних та колекцій:
```
use gymDatabase
```
![Screenshot 2025-06-08 at 14.51.50.png](assets/Screenshot%202025-06-08%20at%2014.51.50.png)
![Screenshot 2025-06-08 at 14.55.11.png](assets/Screenshot%202025-06-08%20at%2014.55.11.png)
3. Визначення схеми документів:
```js
db.createCollection("clients", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["client_id", "name", "age", "email"],
            properties: {
                client_id: { bsonType: "int", description: "must be an integer and is required" },
                name: { bsonType: "string", description: "must be a string and is required" },
                age: { bsonType: "int", minimum: 0, description: "must be an integer >= 0 and is required" },
                email: { bsonType: "string", pattern: "^.+@.+$", description: "must be a valid email address" }
            }
        }
    }
})

db.createCollection("memberships", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["membership_id", "client_id", "start_date", "end_date", "type"],
            properties: {
                membership_id: { bsonType: "int" },
                client_id: { bsonType: "int" },
                start_date: { bsonType: "date" },
                end_date: { bsonType: "date" },
                type: {
                    bsonType: "object",
                    required: ["name", "monthly_price", "includes_pool"],
                    properties: {
                        name: { bsonType: "string" },
                        monthly_price: { bsonType: "int" },
                        includes_pool: { bsonType: "bool" }
                    }
                }
            }
        }
    }
})

db.createCollection("workouts", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["workout_id", "description", "difficulty", "trainer"],
            properties: {
                workout_id: { bsonType: "int" },
                description: { bsonType: "string" },
                difficulty: { bsonType: "string", enum: ["Easy", "Medium", "Hard"] },
                trainer: {
                    bsonType: "object",
                    required: ["trainer_id", "name"],
                    properties: {
                        trainer_id: { bsonType: "int" },
                        name: { bsonType: "string" }
                    }
                }
            }
        }
    }
})

db.createCollection("trainers", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["trainer_id", "name", "specialization", "contact"],
            properties: {
                trainer_id: { bsonType: "int" },
                name: { bsonType: "string" },
                specialization: { bsonType: "string" },
                contact: {
                    bsonType: "object",
                    required: ["phone", "email"],
                    properties: {
                        phone: { bsonType: "string", pattern: "^\\+?[0-9]{10,15}$" },
                        email: { bsonType: "string", pattern: "^.+@.+$" }
                    }
                }
            }
        }
    }
})
```
![Screenshot 2025-06-08 at 15.08.29.png](assets/Screenshot%202025-06-08%20at%2015.08.29.png)
![Screenshot 2025-06-08 at 15.08.51.png](assets/Screenshot%202025-06-08%20at%2015.08.51.png)
![Screenshot 2025-06-08 at 15.09.17.png](assets/Screenshot%202025-06-08%20at%2015.09.17.png)
![Screenshot 2025-06-08 at 15.09.27.png](assets/Screenshot%202025-06-08%20at%2015.09.27.png)
![Screenshot 2025-06-08 at 15.12.51.png](assets/Screenshot%202025-06-08%20at%2015.12.51.png)

Індексація
```js
db.clients.createIndex({ age: 1 })
db.memberships.createIndex({ client_id: 1 })
db.workouts.createIndex({ difficulty: 1 })
db.trainers.createIndex({ specialization: 1 })
```
![Screenshot 2025-06-08 at 15.17.50.png](assets/Screenshot%202025-06-08%20at%2015.17.50.png)
4. Заповнення колекцій даними:
```js
db.clients.insertMany([
  { client_id: 1, name: "Anna Kovalenko", age: 28, email: "anna.kovalenko@example.com" },
  { client_id: 2, name: "Oleh Petrenko", age: 35, email: "oleh.petrenko@example.com" },
  { client_id: 3, name: "Svitlana Shevchenko", age: 42, email: "svitlana.shevchenko@example.com" },
  { client_id: 4, name: "Ivan Bondar", age: 25, email: "ivan.bondar@example.com" },
  { client_id: 5, name: "Kateryna Danylko", age: 33, email: "kateryna.danylko@example.com" }
])

db.memberships.insertMany([
    {
        membership_id: 1,
        client_id: 1,
        start_date: ISODate("2025-06-01"),
        end_date: ISODate("2025-12-01"),
        type: { name: "Standard", monthly_price: 50, includes_pool: false }
    },
    {
        membership_id: 2,
        client_id: 2,
        start_date: ISODate("2025-01-15"),
        end_date: ISODate("2025-07-15"),
        type: { name: "Premium", monthly_price: 80, includes_pool: true }
    },
    {
        membership_id: 3,
        client_id: 3,
        start_date: ISODate("2025-03-20"),
        end_date: ISODate("2025-09-20"),
        type: { name: "Standard", monthly_price: 50, includes_pool: false }
    },
    {
        membership_id: 4,
        client_id: 4,
        start_date: ISODate("2025-05-10"),
        end_date: ISODate("2025-11-10"),
        type: { name: "VIP", monthly_price: 120, includes_pool: true }
    },
    {
        membership_id: 5,
        client_id: 5,
        start_date: ISODate("2025-04-01"),
        end_date: ISODate("2025-10-01"),
        type: { name: "Premium", monthly_price: 80, includes_pool: true }
    }
])

db.trainers.insertMany([
    { trainer_id: 1, name: "Maria Levchenko", specialization: "Cardio", contact: { phone: "+380631234567", email: "maria.levchenko@gym.ua" } },
    { trainer_id: 2, name: "Andrii Tkachenko", specialization: "Strength", contact: { phone: "+380671234567", email: "andrii.tkachenko@gym.ua" } },
    { trainer_id: 3, name: "Olena Horbach", specialization: "Yoga", contact: { phone: "+380501234567", email: "olena.horbach@gym.ua" } }
])

db.workouts.insertMany([
    { workout_id: 1, description: "Cardio session", difficulty: "Easy", trainer: { trainer_id: 1, name: "Maria Levchenko" } },
    { workout_id: 2, description: "Strength training", difficulty: "Medium", trainer: { trainer_id: 2, name: "Andrii Tkachenko" } },
    { workout_id: 3, description: "HIIT workout", difficulty: "Hard", trainer: { trainer_id: 2, name: "Andrii Tkachenko" } },
    { workout_id: 4, description: "Yoga class", difficulty: "Medium", trainer: { trainer_id: 3, name: "Olena Horbach" } },
    { workout_id: 5, description: "BodyPump", difficulty: "Medium", trainer: { trainer_id: 2, name: "Andrii Tkachenko" } }
])

```
![Screenshot 2025-06-08 at 15.19.37.png](assets/Screenshot%202025-06-08%20at%2015.19.37.png)
![Screenshot 2025-06-08 at 15.19.52.png](assets/Screenshot%202025-06-08%20at%2015.19.52.png)
![Screenshot 2025-06-08 at 15.20.33.png](assets/Screenshot%202025-06-08%20at%2015.20.33.png)
![Screenshot 2025-06-08 at 15.24.15.png](assets/Screenshot%202025-06-08%20at%2015.24.15.png)
![Screenshot 2025-06-08 at 15.24.54.png](assets/Screenshot%202025-06-08%20at%2015.24.54.png)
![Screenshot 2025-06-08 at 15.25.13.png](assets/Screenshot%202025-06-08%20at%2015.25.13.png)
![Screenshot 2025-06-08 at 15.25.26.png](assets/Screenshot%202025-06-08%20at%2015.25.26.png)
![Screenshot 2025-06-08 at 15.25.57.png](assets/Screenshot%202025-06-08%20at%2015.25.57.png)
5. Запити:
Знайти клієнтів віком понад 30 років
```js
db.clients.find({ age: { $gt: 30 } })
```
![Screenshot 2025-06-08 at 15.28.57.png](assets/Screenshot%202025-06-08%20at%2015.28.57.png)
Знайти тренування середньої складності
```js
db.workouts.find({ difficulty: "Medium" })
```
![Screenshot 2025-06-08 at 15.29.49.png](assets/Screenshot%202025-06-08%20at%2015.29.49.png)
Показати членство клієнта з client_id = 2
```js
db.memberships.find({ client_id: 2 })
```
![Screenshot 2025-06-08 at 15.30.24.png](assets/Screenshot%202025-06-08%20at%2015.30.24.png)