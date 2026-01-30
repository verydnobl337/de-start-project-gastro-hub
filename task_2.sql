/*добавьте сюда запрос для решения задания 2*/
-- Задание 2. Создание материализованного представления:
CREATE MATERIALIZED VIEW cafe.avg_check_yearly_change AS
SELECT
    year,
    restaurant_name,
    restaurant_type,
    ROUND(avg_check, 2) AS avg_check_current_year,
    ROUND(
        LAG(avg_check) OVER (
            PARTITION BY restaurant_uuid
            ORDER BY year
        ),
        2
    ) AS avg_check_previous_year,
    ROUND(
        (avg_check - LAG(avg_check) OVER (
            PARTITION BY restaurant_uuid
            ORDER BY year
        ))
        / LAG(avg_check) OVER (
            PARTITION BY restaurant_uuid
            ORDER BY year
        ) * 100,
        2
    ) AS avg_check_change_percent
FROM (
    SELECT
        EXTRACT(YEAR FROM s.date) AS year,
        r.restaurant_uuid,
        r.name AS restaurant_name,
        r.restaurant_type,
        AVG(s.avg_check) AS avg_check
    FROM cafe.sales s
    JOIN cafe.restaurants r ON r.restaurant_uuid = s.restaurant_uuid
    WHERE EXTRACT(YEAR FROM s.date) <> 2023
    GROUP BY
        year,
        r.restaurant_uuid,
        r.name,
        r.restaurant_type
) t;
