/*добавьте сюда запросы для решения задания 7*/
-- Задание 7. Транзакыии и блокировки:
BEGIN;
/* Блокируем таблицу managers в режиме SHARE:
другие транзакции могут читать данные,
но не могут изменять или удалять строки */
LOCK TABLE cafe.managers IN SHARE MODE;
-- Добавляем новое поле для хранения массива телефонов:
ALTER TABLE cafe.managers
ADD COLUMN phones TEXT[];
/*  Рассчитываем новый номер телефона для каждого менеджера,
порядковый номер определяется по алфавиту имени менеджера */
WITH ranked_managers AS (
    SELECT
        manager_uuid,
        phone AS old_phone,
        CONCAT(
            '8-800-2500-',
            99 + ROW_NUMBER() OVER (ORDER BY name)
        ) AS new_phone
    FROM cafe.managers
)
-- Обновляем таблицу, сохраняем новый и старый номер в массиве:
UPDATE cafe.managers m
SET phones = ARRAY[r.new_phone, r.old_phone]
FROM ranked_managers r
WHERE m.manager_uuid = r.manager_uuid;
-- Удаляем старое поле с телефоном, так как теперь номера хранятся в массиве:
ALTER TABLE cafe.managers
DROP COLUMN phone;

COMMIT;

--КОММЕНТ--
/* Использую табличную блокировку, чтобы запретить измнения
 * данных другими пользователями и сохранить возможность 
 * чтения таблиц */
