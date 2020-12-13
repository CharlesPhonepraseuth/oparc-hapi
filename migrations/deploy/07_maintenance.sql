-- Deploy oparc-hapi:07_maintenance to pg

BEGIN;

CREATE SCHEMA maintenance;

CREATE TYPE maintenance.incident_progress AS ENUM (
    'constaté',
    'pris en charge',
    'en attente',
    'en vérification',
    'terminé'
);

CREATE TABLE maintenance.incident (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nature text NOT NULL,
    progress maintenance.incident_progress NOT NULL DEFAULT 'constaté',
    technician text,
    happening_time timestamptz NOT NULL,
    resolved_time timestamptz,
    event_id int NOT NULL REFERENCES public.event(id)
);

CREATE DOMAIN "url" AS text
CHECK (VALUE ~* '^https?://');

CREATE TABLE maintenance.model (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "name" text NOT NULL UNIQUE,
    pdf_link "url"
);

ALTER TABLE "event" ADD COLUMN model_id int REFERENCES maintenance.model(id);


COMMIT;
