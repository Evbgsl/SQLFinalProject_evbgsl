-- ======================
-- Задача 1
-- ======================
SELECT
    c.name,
    c.email,
    c.phone,
    COUNT(*) AS total_bookings,
    GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS hotels,
    ROUND(AVG(DATEDIFF(b.check_out_date, b.check_in_date)), 4) AS avg_stay_days
FROM Customer c
JOIN Booking b ON b.ID_customer = c.ID_customer
JOIN Room r ON r.ID_room = b.ID_room
JOIN Hotel h ON h.ID_hotel = r.ID_hotel
GROUP BY c.ID_customer, c.name, c.email, c.phone
HAVING COUNT(*) > 2
   AND COUNT(DISTINCT h.ID_hotel) > 1
ORDER BY total_bookings DESC, c.name;

-- ======================
-- Задача 2
-- ======================
WITH customer_stats AS (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(*) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        ROUND(SUM(r.price), 2) AS total_spent
    FROM Customer c
    JOIN Booking b ON b.ID_customer = c.ID_customer
    JOIN Room r ON r.ID_room = b.ID_room
    JOIN Hotel h ON h.ID_hotel = r.ID_hotel
    GROUP BY c.ID_customer, c.name
)
SELECT
    ID_customer,
    name,
    total_bookings,
    total_spent,
    unique_hotels
FROM customer_stats
WHERE total_bookings > 2
  AND unique_hotels > 1
  AND total_spent > 500
ORDER BY total_spent ASC;

-- ======================
-- Задача 3
-- ======================
WITH hotel_category AS (
    SELECT
        h.ID_hotel,
        h.name AS hotel_name,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) <= 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_type
    FROM Hotel h
    JOIN Room r ON r.ID_hotel = h.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
customer_pref AS (
    SELECT
        c.ID_customer,
        c.name,
        CASE
            WHEN MAX(CASE WHEN hc.hotel_type = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
            WHEN MAX(CASE WHEN hc.hotel_type = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type,
        GROUP_CONCAT(DISTINCT hc.hotel_name ORDER BY hc.hotel_name SEPARATOR ',') AS visited_hotels
    FROM Customer c
    JOIN Booking b ON b.ID_customer = c.ID_customer
    JOIN Room r ON r.ID_room = b.ID_room
    JOIN hotel_category hc ON hc.ID_hotel = r.ID_hotel
    GROUP BY c.ID_customer, c.name
)
SELECT
    ID_customer,
    name,
    preferred_hotel_type,
    visited_hotels
FROM customer_pref
ORDER BY
    CASE preferred_hotel_type
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        WHEN 'Дорогой' THEN 3
    END,
    ID_customer;
