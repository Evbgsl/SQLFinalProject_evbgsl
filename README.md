## Инструкция по запуску

1. Создать базы данных в MySQL (например):
    - vehicles_db
    - racing_db
    - hotel_db
    - organization_db

2. Подключиться к серверу MySQL через SQL-клиент (например, DBeaver или phpMyAdmin).

3. Выбрать нужную базу данных (через интерфейс SQL-клиента или командой USE <имя_базы>).

4. Выполнить скрипты для каждой предметной области:

### 01_vehicles
- выполнить `01_vehicles/create.sql` - создание таблиц;
- выполнить `01_vehicles/insert.sql` - заполнение тестовыми данными;
- выполнить запросы из `01_vehicles/solutions.sql`.

### 02_racing
- выполнить `02_racing/create.sql`;
- выполнить `02_racing/insert.sql`;
- выполнить запросы из `02_racing/solutions.sql`.

### 03_hotel
- выполнить `03_hotel/create.sql`;
- выполнить `03_hotel/insert.sql`;
- выполнить запросы из `03_hotel/solutions.sql`.

### 04_organization
- выполнить `04_organization/create.sql`;
- выполнить `04_organization/insert.sql`;
- выполнить запросы из `04_organization/solutions.sql`.

## Тестирование

Проверка корректности решений осуществляется путем выполнения SQL-запросов из файлов `solutions.sql` после создания таблиц и загрузки данных.

Полученные результаты необходимо сравнить с ожидаемыми результатами, указанными в задании.