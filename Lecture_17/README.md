Завдання 1: Встановлення Docker
![Screenshot 2025-06-08 at 15.48.29.png](assets/Screenshot%202025-06-08%20at%2015.48.29.png)
Завдання 2: Створення файлу docker-compose.yml
```
multi-container-app/
├── docker-compose.yml
├── web/
│   └── index.html
└── README.md
```

```yaml
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./web:/usr/share/nginx/html
    networks:
      - appnet

  db:
    image: postgres:14
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - appnet

  cache:
    image: redis:7
    networks:
      - appnet

volumes:
  db-data:

networks:
  appnet:
    driver: bridge

```
Завдання 3: Запуск багатоконтейнерного застосунку
```yaml
docker compose -p multi-container-app up -d
```
![Screenshot 2025-06-08 at 16.00.12.png](assets/Screenshot%202025-06-08%20at%2016.00.12.png)
(видалив version: '3.8' з початку файлу)

Перевірка роботи застосунку
![Screenshot 2025-06-08 at 15.59.05.png](assets/Screenshot%202025-06-08%20at%2015.59.05.png)
```yaml
docker-compose ps
```
![Screenshot 2025-06-08 at 16.02.33.png](assets/Screenshot%202025-06-08%20at%2016.02.33.png)
```
GET http://localhost:8080
```
![Screenshot 2025-06-08 at 16.03.13.png](assets/Screenshot%202025-06-08%20at%2016.03.13.png)

Завдання 4: Налаштування мережі й томів
```yaml
docker network ls
```
![Screenshot 2025-06-08 at 16.03.45.png](assets/Screenshot%202025-06-08%20at%2016.03.45.png)
```yaml
docker volume ls
```
![Screenshot 2025-06-08 at 16.07.10.png](assets/Screenshot%202025-06-08%20at%2016.07.10.png)

Підключення до БД:
```yaml
docker exec -it multi-container-app-db-1 psql -U user -d mydb
```
![Screenshot 2025-06-08 at 16.11.48.png](assets/Screenshot%202025-06-08%20at%2016.11.48.png)

Завдання 5: Масштабування сервісів
```yaml
docker compose -p multi-container-app up -d --scale web=3
```
![Screenshot 2025-06-08 at 16.14.44.png](assets/Screenshot%202025-06-08%20at%2016.14.44.png)
(логічно, що порт 8080 не може бути забіндений на три контейнера одночасно, тому отримав помилку)

Заміню
```yaml
    ports:
      - "8080:80"
```
на
```yaml
    expose:
      - "80"
```
Також можемо використати рандомний порт на хості:
```yaml
    ports:
      - "8080"
```
![Screenshot 2025-06-08 at 16.19.06.png](assets/Screenshot%202025-06-08%20at%2016.19.06.png)
![Screenshot 2025-06-08 at 16.19.51.png](assets/Screenshot%202025-06-08%20at%2016.19.51.png)
![Screenshot 2025-06-08 at 16.24.34.png](assets/Screenshot%202025-06-08%20at%2016.24.34.png)
(маємо три контейнери веб-сервісу у внутрішній мережі)

Спробуємо зробити запит до одного з веб-сервісів з контейнера БД:
```yaml
docker exec -it multi-container-app-db-1 sh
```
![Screenshot 2025-06-08 at 16.27.44.png](assets/Screenshot%202025-06-08%20at%2016.27.44.png)
![Screenshot 2025-06-08 at 16.28.56.png](assets/Screenshot%202025-06-08%20at%2016.28.56.png)
(this is fine)

Використовую взагалом активно docker-compose в пет проектах задля infrastructure as code, але не використовую масштабування, оскільки не було прямої потреби в цьому.
Дуже подобається, що на docker-compose можна швидко розгорнути застосунок та залежності і сам функціонал інструменту дуже насичений.
Це все в ізольованомму середовищі (звісно це вже не докер компоуз, але взагалом про Docker + Docker Composer) і описано в коді, що дозволяє легко відтворити середовище на іншій машині та підтримувати конфігурацію в історії git. 
Купа готових образів на Docker Hub та можливість створювати свої образи, що дозволяє легко налаштовувати середовище під свої потреби