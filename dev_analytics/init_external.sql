CREATE ROLE lfda_dbo WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION;
GRANT lfda_dbo to USR;
CREATE DATABASE dev_analytics WITH OWNER lfda_dbo;
CREATE ROLE lfda_readonly_role WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
GRANT USAGE ON SCHEMA public TO lfda_readonly_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO lfda_readonly_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO lfda_readonly_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES to lfda_readonly_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES to lfda_readonly_role;
CREATE ROLE lfda_service_base_role WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
GRANT lfda_readonly_role TO lfda_service_base_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO lfda_service_base_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO lfda_service_base_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES to lfda_service_base_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES to lfda_service_base_role;
CREATE ROLE lfda_service_api_role WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
GRANT lfda_service_base_role TO lfda_service_api_role;
CREATE ROLE lfda_api_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'PWD';
GRANT lfda_service_api_role TO lfda_api_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO lfda_readonly_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO lfda_readonly_role;
CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA public;
