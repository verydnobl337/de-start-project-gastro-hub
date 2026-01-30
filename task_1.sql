/*добавьте сюда запрос для решения задания 1*/
-- Задание 1. Топ-3 заведения по среднему чеку:
CREATE OR REPLACE VIEW cafe.top_3_restaurants AS
SELECT
    restaurant_name,
    restaurant_type,
    ROUND(avg_check, 2) AS avg_check
FROM (
    SELECT
        r.name AS restaurant_name,
        r.restaurant_type,
        AVG(s.avg_check) AS avg_check,
        ROW_NUMBER() OVER (
            PARTITION BY r.restaurant_type
            ORDER BY AVG(s.avg_check) DESC
        ) AS rn
    FROM cafe.sales s
    JOIN cafe.restaurants r ON r.restaurant_uuid = s.restaurant_uuid
    GROUP BY
        r.name,
        r.restaurant_type
) t
WHERE rn <= 3;
