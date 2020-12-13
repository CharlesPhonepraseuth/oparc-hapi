-- Deploy oparc-hapi:01_tables to pg

BEGIN;

CREATE TABLE visitor (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ticket_number int UNIQUE,
    validity_start date,
    validity_end date,
    entered timestamp,
    "left" timestamp 
);

CREATE TABLE "event" (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "name" text UNIQUE,
    capacity int,
    opening time,
    closing time,
    duration interval
);

CREATE TABLE ride (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id int REFERENCES "event"(id),
    visitor_id int REFERENCES visitor(id),
    "time" timestamp DEFAULT now()
);

CREATE TABLE booking (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id int REFERENCES "event"(id),
    visitor_id int REFERENCES visitor(id),
    seats int DEFAULT 1,
    "time" timestamp
);

COMMIT;
