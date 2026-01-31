/*добавьте сюда запросы для решения задания 7*/
-- Задание 7. Транзакыии и блокировки:
BEGIN;
/* Явно блокирую таблицу managers.
 Далее будет выполняться ALTER TABLE,
 который требует ACCESS EXCLUSIVE,
 поэтому чтение другими транзакциями
 на время изменения схемы будет недоступно. */
LOCK TABLE cafe.managers IN ACCESS EXCLUSIVE MODE;
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
