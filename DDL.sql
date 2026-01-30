/*Добавьте в этот файл все запросы, для создания схемы сafe и
 таблиц в ней в нужном порядке*/
-- Этап 1. Создание схемы и таблиц:
CREATE SCHEMA IF NOT EXISTS cafe;

CREATE TYPE cafe.restaurant_type AS ENUM (
    'coffee_shop',
    'restaurant',
    'bar',
    'pizzeria'
);

CREATE TABLE cafe.restaurants (
    restaurant_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR NOT NULL,
    restaurant_type cafe.restaurant_type NOT NULL,
    menu JSONB
);

CREATE TABLE cafe.managers (
    manager_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR NOT NULL,
    phone VARCHAR
);

CREATE TABLE cafe.restaurant_manager_work_dates (
    restaurant_uuid UUID REFERENCES cafe.restaurants(restaurant_uuid),
    manager_uuid UUID REFERENCES cafe.managers(manager_uuid),
    start_date DATE NOT NULL,
    end_date DATE,
    PRIMARY KEY (restaurant_uuid, manager_uuid)
);

CREATE TABLE cafe.sales (
    date DATE NOT NULL,
    restaurant_uuid UUID REFERENCES cafe.restaurants(restaurant_uuid),
    avg_check NUMERIC(6,2),
    PRIMARY KEY (date, restaurant_uuid)
);
