/*добавьте сюда запрос для решения задания 5*/
-- Задание 5. Нахождение самой дорогой пиццы для каждой пиццерии:
WITH menu_cte AS (
    SELECT
        r.name AS restaurant_name,
        'Пицца' AS dish_type,
        p.key AS pizza_name,
        p.value::INT AS price
    FROM cafe.restaurants r,
         jsonb_each_text(r.menu -> 'Пицца') AS p(key, value)
    WHERE r.restaurant_type = 'pizzeria'
),
menu_with_rank AS (
    SELECT
        restaurant_name,
        dish_type,
        pizza_name,
        price,
        ROW_NUMBER() OVER (
            PARTITION BY restaurant_name
            ORDER BY price DESC
        ) AS rn
    FROM menu_cte
)
SELECT
    restaurant_name,
    dish_type,
    pizza_name,
    price
FROM menu_with_rank
WHERE rn = 1
ORDER BY restaurant_name;
