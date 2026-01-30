/*добавьте сюда запрос для решения задания 3*/
-- Задание 3. Топ-3 заведения по смене менеджеров:
SELECT
    r.name AS restaurant_name,
    COUNT(*) AS manager_changes
FROM cafe.restaurant_manager_work_dates rmwd
JOIN cafe.restaurants r ON r.restaurant_uuid = rmwd.restaurant_uuid
GROUP BY r.name
ORDER BY manager_changes DESC
LIMIT 3;
