REVOKE ALL ON ALL TABLES IN SCHEMA public FROM "lfda_readonly_role";
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM "lfda_readonly_role";
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM "lfda_readonly_role";
GRANT "lfda_readonly_role" to "postgres";
REASSIGN OWNED BY "lfda_readonly_role" TO "postgres";
DROP OWNED BY "lfda_readonly_role";
DROP USER if exists "lfda_readonly_role";

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM "lfda_api_user";
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM "lfda_api_user";
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM "lfda_api_user";
GRANT "lfda_api_user" to "postgres";
REASSIGN OWNED BY "lfda_api_user" TO "postgres";
DROP OWNED BY "lfda_api_user";
DROP USER if exists "lfda_api_user";

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM "lfda_service_api_role";
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM "lfda_service_api_role";
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM "lfda_service_api_role";
GRANT "lfda_service_api_role" to "postgres";
REASSIGN OWNED BY "lfda_service_api_role" TO "postgres";
DROP OWNED BY "lfda_service_api_role";
DROP USER if exists "lfda_service_api_role";

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM "lfda_service_base_role";
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM "lfda_service_base_role";
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM "lfda_service_base_role";
GRANT "lfda_service_base_role" to "postgres";
REASSIGN OWNED BY "lfda_service_base_role" TO "postgres";
DROP OWNED BY "lfda_service_base_role";
DROP USER if exists "lfda_service_base_role";

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM "lfda_dbo";
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM "lfda_dbo";
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM "lfda_dbo";
GRANT "lfda_dbo" to "postgres";
REASSIGN OWNED BY "lfda_dbo" TO "postgres";
DROP OWNED BY "lfda_dbo";
DROP USER if exists "lfda_dbo";
