/*добавьте сюда запрос для решения задания 4*/
-- Задание 4. Найти пиццерии с самым большим кол-ом пицц в меню:
WITH pizza_expanded AS (
    SELECT
        r.name AS restaurant_name,
        p.key AS pizza_name
    FROM cafe.restaurants r,
         jsonb_each_text(r.menu -> 'Пицца') AS p(key, value)
    WHERE r.restaurant_type = 'pizzeria'
),
pizza_count AS (
    SELECT
        restaurant_name,
        COUNT(pizza_name) AS pizza_count,
        DENSE_RANK() OVER (ORDER BY COUNT(pizza_name) DESC) AS rank
    FROM pizza_expanded
    GROUP BY restaurant_name
)
SELECT restaurant_name, pizza_count
FROM pizza_count
WHERE rank = 1;
