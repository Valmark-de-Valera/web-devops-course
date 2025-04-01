# Створення нової віртуальної машини

| Через відмінність архітектури останнього Ubuntu LTS білда від процесора компʼютера було активовано нестабільну ресурсозатратну фічу: VBoxInternal2/EnableX86OnArm |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|

1. Під час спроби встановлення Ubuntu 24.04.2 LTS AMD64 на віртуальну машину VirtualBox, виникли різні помилки при різних конфігах віртуальної машини.
    
    // Конфіг 1 (як по ТЗ)
    ![Screenshot 2025-03-25 at 16.07.19.png](assets/Screenshot%202025-03-25%20at%2016.07.19.png)
    ![Screenshot 2025-03-25 at 16.56.02.png](assets/Screenshot%202025-03-25%20at%2016.56.02.png)
    
    // Конфіг 2 (не вказуючи Тип та без підтримки EFI) але підвисає на завантаженні
    ![Screenshot 2025-03-25 at 17.01.15.png](assets/Screenshot%202025-03-25%20at%2017.01.15.png)
    ![Screenshot 2025-03-25 at 17.06.52.png](assets/Screenshot%202025-03-25%20at%2017.06.52.png)
    ![Screenshot 2025-03-25 at 16.55.24.png](assets/Screenshot%202025-03-25%20at%2016.55.24.png)
    
    // Конфіг 3 (не вказуючи Тип)
    ![Screenshot 2025-03-25 at 17.01.19.png](assets/Screenshot%202025-03-25%20at%2017.01.19.png)
    ![Screenshot 2025-03-25 at 16.55.40.png](assets/Screenshot%202025-03-25%20at%2016.55.40.png)
    
2. Так як сама фіча є нестабільною та деякі конфігурації взагалі недозволяли запустити з поточним імейджом, вирішено встановити Ubuntu 24.04.2 ARM DailyBuild https://cdimage.ubuntu.com/noble/daily-live/current/ під архітектуру ARM64
3. Створимо VM4 з автоналаштуваннями
    ![Screenshot 2025-03-25 at 17.11.51.png](assets/Screenshot%202025-03-25%20at%2017.11.51.png)
    ![Screenshot 2025-03-25 at 17.12.13.png](assets/Screenshot%202025-03-25%20at%2017.12.13.png)
    ![Screenshot 2025-03-25 at 17.12.28.png](assets/Screenshot%202025-03-25%20at%2017.12.28.png)
    ![Screenshot 2025-03-25 at 17.12.42.png](assets/Screenshot%202025-03-25%20at%2017.12.42.png)
    ![Screenshot 2025-03-25 at 17.13.26.png](assets/Screenshot%202025-03-25%20at%2017.13.26.png)
    ![Screenshot 2025-03-25 at 17.13.59.png](assets/Screenshot%202025-03-25%20at%2017.13.59.png)
    ![Screenshot 2025-03-25 at 17.14.56.png](assets/Screenshot%202025-03-25%20at%2017.14.56.png)
    ![Screenshot 2025-03-25 at 17.21.20.png](assets/Screenshot%202025-03-25%20at%2017.21.20.png)
    Тут побачив, що це таки LTS версія 🙈
    ![Screenshot 2025-03-25 at 17.21.39.png](assets/Screenshot%202025-03-25%20at%2017.21.39.png)
    ![Screenshot 2025-03-25 at 17.22.53.png](assets/Screenshot%202025-03-25%20at%2017.22.53.png)
    ![Screenshot 2025-03-25 at 17.23.37.png](assets/Screenshot%202025-03-25%20at%2017.23.37.png)
    ![Screenshot 2025-03-26 at 11.10.47.png](assets/Screenshot%202025-03-26%20at%2011.10.47.png)
4. Створимо VM5 без автоналаштуванння
    ![Screenshot 2025-03-25 at 17.24.16.png](assets/Screenshot%202025-03-25%20at%2017.24.16.png)
    ![Screenshot 2025-03-25 at 17.24.39.png](assets/Screenshot%202025-03-25%20at%2017.24.39.png)
    ![Screenshot 2025-03-25 at 17.34.24.png](assets/Screenshot%202025-03-25%20at%2017.34.24.png)
    ![Screenshot 2025-03-25 at 17.34.45.png](assets/Screenshot%202025-03-25%20at%2017.34.45.png)
    ![Screenshot 2025-03-25 at 17.35.08.png](assets/Screenshot%202025-03-25%20at%2017.35.08.png)
    ![Screenshot 2025-03-25 at 17.35.34.png](assets/Screenshot%202025-03-25%20at%2017.35.34.png)
    ![Screenshot 2025-03-25 at 17.35.42.png](assets/Screenshot%202025-03-25%20at%2017.35.42.png)
    ![Screenshot 2025-03-25 at 17.36.01.png](assets/Screenshot%202025-03-25%20at%2017.36.01.png)
    ![Screenshot 2025-03-26 at 09.54.20.png](assets/Screenshot%202025-03-26%20at%2009.54.20.png)
    ![Screenshot 2025-03-25 at 18.00.02.png](assets/Screenshot%202025-03-25%20at%2018.00.02.png)
    ![Screenshot 2025-03-26 at 10.05.09.png](assets/Screenshot%202025-03-26%20at%2010.05.09.png)
5. Збереження та відновлення стану VM
    ![Screenshot 2025-03-26 at 11.28.44.png](assets/Screenshot%202025-03-26%20at%2011.28.44.png)    
    ![Screenshot 2025-03-26 at 10.12.06.png](assets/Screenshot%202025-03-26%20at%2010.12.06.png)
    ![Screenshot 2025-03-26 at 11.29.16.png](assets/Screenshot%202025-03-26%20at%2011.29.16.png)
    ![Screenshot 2025-03-26 at 11.30.39.png](assets/Screenshot%202025-03-26%20at%2011.30.39.png)
    ![Screenshot 2025-03-26 at 11.32.02.png](assets/Screenshot%202025-03-26%20at%2011.32.02.png)
    ![Screenshot 2025-03-26 at 11.32.47.png](assets/Screenshot%202025-03-26%20at%2011.32.47.png)
6. Зміна параметрів віртуальної машини через графічний інтерфейс
    
    Збільшення розміру жорсткого диску
    ![Screenshot 2025-03-26 at 13.11.11.png](assets/Screenshot%202025-03-26%20at%2013.11.11.png)
    ![Screenshot 2025-03-26 at 13.15.40.png](assets/Screenshot%202025-03-26%20at%2013.15.40.png)
    ![Screenshot 2025-03-26 at 13.17.41.png](assets/Screenshot%202025-03-26%20at%2013.17.41.png)

    Упупу, будемо клонувати з новим розміром:
    ![Screenshot 2025-03-26 at 13.18.05.png](assets/Screenshot%202025-03-26%20at%2013.18.05.png)
    ![Screenshot 2025-03-26 at 13.18.27.png](assets/Screenshot%202025-03-26%20at%2013.18.27.png)
    ![Screenshot 2025-03-26 at 13.19.33.png](assets/Screenshot%202025-03-26%20at%2013.19.33.png)
    ![Screenshot 2025-03-26 at 13.20.00.png](assets/Screenshot%202025-03-26%20at%2013.20.00.png)
    Зміна кількості процесорних ядер та оперативної пам'яті
    ![Screenshot 2025-03-26 at 13.28.00.png](assets/Screenshot%202025-03-26%20at%2013.28.00.png)
    ![Screenshot 2025-03-26 at 13.28.16.png](assets/Screenshot%202025-03-26%20at%2013.28.16.png)
    ![Screenshot 2025-03-26 at 13.28.34.png](assets/Screenshot%202025-03-26%20at%2013.28.34.png)
    (Примітка: після зміни RAM віртуальна машина більше не піднімалась)
    VBoxEFIAArch64.fd FlashFile = "nvram" TestVM 4.nvram (EFI state) ніс в собі старий конфіг, що був несумісний, навіть після скидання snapshot система більше не запускалася до видалення цього файлу.
    ![Screenshot 2025-03-26 at 13.34.47.png](assets/Screenshot%202025-03-26%20at%2013.34.47.png)
    Після видалення файлу VM створила новий файл з новим конфігом.
    ![Screenshot 2025-03-26 at 14.43.26.png](assets/Screenshot%202025-03-26%20at%2014.43.26.png)
    
7.  Налаштувати спільні папки між основною машиною і VM
    ![Screenshot 2025-03-26 at 15.00.10.png](assets/Screenshot%202025-03-26%20at%2015.00.10.png)
    ![Screenshot 2025-03-26 at 15.00.48.png](assets/Screenshot%202025-03-26%20at%2015.00.48.png)
    ![Screenshot 2025-03-26 at 15.02.37.png](assets/Screenshot%202025-03-26%20at%2015.02.37.png)
    ![Screenshot 2025-03-26 at 15.04.04.png](assets/Screenshot%202025-03-26%20at%2015.04.04.png)
    Використав автомаунт, але там можливо і вручну замаунтити додавши користувача в групу vboxsf та прописавши mount
    ![Screenshot 2025-03-26 at 15.17.10.png](assets/Screenshot%202025-03-26%20at%2015.17.10.png)
    ![Screenshot 2025-03-26 at 15.17.48.png](assets/Screenshot%202025-03-26%20at%2015.17.48.png)
8. Видалення VM (delete all files)
    ![Screenshot 2025-03-26 at 15.22.02.png](assets/Screenshot%202025-03-26%20at%2015.22.02.png)
    ![Screenshot 2025-03-26 at 15.22.18.png](assets/Screenshot%202025-03-26%20at%2015.22.18.png)