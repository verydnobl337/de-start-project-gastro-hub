/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме cafe данными*/
-- Наполнение таблиц данными:
INSERT INTO cafe.restaurants (name, restaurant_type, menu)
SELECT DISTINCT
    s.cafe_name,
    s.type::cafe.restaurant_type,
    m.menu
FROM raw_data.sales s
JOIN raw_data.menu m ON m.cafe_name = s.cafe_name;

INSERT INTO cafe.managers (name, phone)
SELECT DISTINCT
    manager,
    manager_phone
FROM raw_data.sales
WHERE manager IS NOT NULL;

INSERT INTO cafe.restaurant_manager_work_dates (
    restaurant_uuid,
    manager_uuid,
    start_date,
    end_date
)
SELECT
    r.restaurant_uuid,
    m.manager_uuid,
    MIN(s.report_date),
    MAX(s.report_date)
FROM raw_data.sales s
JOIN cafe.restaurants r ON r.name = s.cafe_name
JOIN cafe.managers m ON m.name = s.manager
GROUP BY
    r.restaurant_uuid,
    m.manager_uuid;

INSERT INTO cafe.sales (date, restaurant_uuid, avg_check)
SELECT
    s.report_date,
    r.restaurant_uuid,
    s.avg_check
FROM raw_data.sales s
JOIN cafe.restaurants r ON r.name = s.cafe_name;
