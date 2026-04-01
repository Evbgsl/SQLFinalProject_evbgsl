-- ======================
-- Задача 1
-- ======================
WITH car_stats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(*) AS race_count
    FROM Cars c
    JOIN Results r ON r.car = c.name
    GROUP BY c.name, c.class
),
min_class_avg AS (
    SELECT
        car_class,
        MIN(average_position) AS min_average_position
    FROM car_stats
    GROUP BY car_class
)
SELECT
    cs.car_name,
    cs.car_class,
    ROUND(cs.average_position, 4) AS average_position,
    cs.race_count
FROM car_stats cs
JOIN min_class_avg mca
    ON cs.car_class = mca.car_class
   AND cs.average_position = mca.min_average_position
ORDER BY cs.average_position ASC, cs.car_name ASC;

-- ======================
-- Задача 2
-- ======================
WITH car_stats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(*) AS race_count,
        cl.country AS car_country
    FROM Cars c
    JOIN Results r ON r.car = c.name
    JOIN Classes cl ON cl.class = c.class
    GROUP BY c.name, c.class, cl.country
)
SELECT
    car_name,
    car_class,
    ROUND(average_position, 4) AS average_position,
    race_count,
    car_country
FROM car_stats
ORDER BY average_position ASC, car_name ASC
LIMIT 1;

-- ======================
-- Задача 3
-- ======================
WITH car_stats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(*) AS race_count,
        cl.country AS car_country
    FROM Cars c
    JOIN Results r ON r.car = c.name
    JOIN Classes cl ON cl.class = c.class
    GROUP BY c.name, c.class, cl.country
),
class_stats AS (
    SELECT
        c.class AS car_class,
        AVG(r.position) AS class_average_position,
        COUNT(*) AS total_races
    FROM Cars c
    JOIN Results r ON r.car = c.name
    GROUP BY c.class
),
best_classes AS (
    SELECT car_class
    FROM class_stats
    WHERE class_average_position = (
        SELECT MIN(class_average_position)
        FROM class_stats
    )
)
SELECT
    cs.car_name,
    cs.car_class,
    ROUND(cs.average_position, 4) AS average_position,
    cs.race_count,
    cs.car_country,
    cls.total_races
FROM car_stats cs
JOIN class_stats cls ON cs.car_class = cls.car_class
JOIN best_classes bc ON cs.car_class = bc.car_class
ORDER BY cs.car_name ASC;

-- ======================
-- Задача 4
-- ======================
WITH car_stats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(*) AS race_count,
        cl.country AS car_country
    FROM Cars c
    JOIN Results r ON r.car = c.name
    JOIN Classes cl ON cl.class = c.class
    GROUP BY c.name, c.class, cl.country
),
class_avg AS (
    SELECT
        car_class,
        AVG(average_position) AS class_average_position,
        COUNT(*) AS car_count
    FROM car_stats
    GROUP BY car_class
)
SELECT
    cs.car_name,
    cs.car_class,
    ROUND(cs.average_position, 4) AS average_position,
    cs.race_count,
    cs.car_country
FROM car_stats cs
JOIN class_avg ca ON cs.car_class = ca.car_class
WHERE ca.car_count >= 2
  AND cs.average_position < ca.class_average_position
ORDER BY cs.car_class ASC, cs.average_position ASC;

-- ======================
-- Задача 5
-- ======================
WITH car_stats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(*) AS race_count,
        cl.country AS car_country
    FROM Cars c
    JOIN Results r ON r.car = c.name
    JOIN Classes cl ON cl.class = c.class
    GROUP BY c.name, c.class, cl.country
),
class_totals AS (
    SELECT
        c.class AS car_class,
        COUNT(*) AS total_races
    FROM Cars c
    JOIN Results r ON r.car = c.name
    GROUP BY c.class
),
low_classes AS (
    SELECT DISTINCT car_class
    FROM car_stats
    WHERE average_position > 3.0
),
low_position_counts AS (
    SELECT
        cs.car_class,
        COUNT(*) AS low_position_count
    FROM car_stats cs
    JOIN low_classes lc ON cs.car_class = lc.car_class
    GROUP BY cs.car_class
)
SELECT
    cs.car_name,
    cs.car_class,
    ROUND(cs.average_position, 4) AS average_position,
    cs.race_count,
    cs.car_country,
    ct.total_races,
    lpc.low_position_count
FROM car_stats cs
JOIN class_totals ct ON cs.car_class = ct.car_class
JOIN low_position_counts lpc ON cs.car_class = lpc.car_class
WHERE cs.average_position > 3.0
ORDER BY lpc.low_position_count DESC, cs.car_class, cs.car_name;