--
-- PostgreSQL database dump
--

-- Dumped from database version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: access_control_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_control_entries (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    scope text NOT NULL,
    subject text NOT NULL,
    resource text NOT NULL,
    action text NOT NULL,
    effect integer NOT NULL,
    extra jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.access_control_entries OWNER TO postgres;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: data_source_config_definitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_source_config_definitions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    data_source_id uuid,
    key_name character varying NOT NULL,
    definition_type integer NOT NULL,
    required boolean DEFAULT false NOT NULL,
    nature integer DEFAULT 0 NOT NULL,
    "default" character varying,
    description text NOT NULL,
    short_description text NOT NULL,
    display_name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.data_source_config_definitions OWNER TO postgres;

--
-- Name: data_source_hierarchies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_source_hierarchies (
    ancestor_id uuid NOT NULL,
    descendant_id uuid NOT NULL,
    generations integer NOT NULL
);


ALTER TABLE public.data_source_hierarchies OWNER TO postgres;

--
-- Name: data_source_instance_configs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_source_instance_configs (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    data_source_instance_id uuid,
    data_source_config_definition_id uuid,
    key character varying NOT NULL,
    value character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.data_source_instance_configs OWNER TO postgres;

--
-- Name: data_source_instance_endpoints; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_source_instance_endpoints (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    data_source_instance_id uuid,
    status integer DEFAULT 0 NOT NULL,
    name text NOT NULL,
    key_name text NOT NULL,
    group_name text,
    filter text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.data_source_instance_endpoints OWNER TO postgres;

--
-- Name: data_source_instances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_source_instances (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    data_source_id uuid NOT NULL,
    project_id uuid NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.data_source_instances OWNER TO postgres;

--
-- Name: data_source_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_source_tags (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    tag_type character varying,
    value character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.data_source_tags OWNER TO postgres;

--
-- Name: data_source_tags_sources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_source_tags_sources (
    data_source_id uuid NOT NULL,
    data_source_tag_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.data_source_tags_sources OWNER TO postgres;

--
-- Name: data_sources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_sources (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    source_type integer DEFAULT 0 NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    slug text NOT NULL,
    self_slug text NOT NULL,
    parent_id uuid,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.data_sources OWNER TO postgres;

--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.friendly_id_slugs (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp with time zone
);


ALTER TABLE public.friendly_id_slugs OWNER TO postgres;

--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.friendly_id_slugs_id_seq OWNER TO postgres;

--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.friendly_id_slugs_id_seq OWNED BY public.friendly_id_slugs.id;


--
-- Name: infrastructure_elastic_search_instances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.infrastructure_elastic_search_instances (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    url text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.infrastructure_elastic_search_instances OWNER TO postgres;

--
-- Name: infrastructure_redis_instances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.infrastructure_redis_instances (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    url text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.infrastructure_redis_instances OWNER TO postgres;

--
-- Name: infrastructure_sortinghat_instances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.infrastructure_sortinghat_instances (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    host text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    database_name text DEFAULT 'sortinghat'::text NOT NULL,
    realm text
);


ALTER TABLE public.infrastructure_sortinghat_instances OWNER TO postgres;

--
-- Name: project_hierarchies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_hierarchies (
    ancestor_id uuid NOT NULL,
    descendant_id uuid NOT NULL,
    generations integer NOT NULL
);


ALTER TABLE public.project_hierarchies OWNER TO postgres;

--
-- Name: project_infrastructure_elastic_search_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_infrastructure_elastic_search_assignments (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    infrastructure_elastic_search_instance_id uuid NOT NULL,
    space text NOT NULL,
    index_qualifier text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.project_infrastructure_elastic_search_assignments OWNER TO postgres;

--
-- Name: project_infrastructure_redis_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_infrastructure_redis_assignments (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    infrastructure_redis_instance_id uuid NOT NULL,
    database integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.project_infrastructure_redis_assignments OWNER TO postgres;

--
-- Name: project_infrastructure_sortinghat_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_infrastructure_sortinghat_assignments (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    infrastructure_sortinghat_instance_id uuid NOT NULL,
    database_name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    realm text
);


ALTER TABLE public.project_infrastructure_sortinghat_assignments OWNER TO postgres;

--
-- Name: project_salesforce_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_salesforce_data (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    project_id uuid,
    status text,
    product_code text,
    category text,
    salesforce_id text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.project_salesforce_data OWNER TO postgres;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    headline text,
    description text,
    slug text NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    parent_id uuid,
    sort_order integer DEFAULT 0 NOT NULL,
    project_type integer DEFAULT 0 NOT NULL,
    alias text,
    self_slug text NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: seq_infrastructure_redis_instance_database; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_infrastructure_redis_instance_database
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_infrastructure_redis_instance_database OWNER TO postgres;

--
-- Name: view_collection_hierarchies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_collection_hierarchies (
    ancestor_id uuid NOT NULL,
    descendant_id uuid NOT NULL,
    generations integer NOT NULL
);


ALTER TABLE public.view_collection_hierarchies OWNER TO postgres;

--
-- Name: view_collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_collections (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    self_slug text NOT NULL,
    parent_id uuid,
    collection_type integer NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.view_collections OWNER TO postgres;

--
-- Name: view_collections_containers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_collections_containers (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    view_collection_id uuid NOT NULL,
    view_container_id uuid NOT NULL
);


ALTER TABLE public.view_collections_containers OWNER TO postgres;

--
-- Name: view_containers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_containers (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    nature integer NOT NULL,
    container_type integer NOT NULL,
    provider integer NOT NULL,
    data jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.view_containers OWNER TO postgres;

--
-- Name: friendly_id_slugs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('public.friendly_id_slugs_id_seq'::regclass);


--
-- Name: access_control_entries access_control_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_control_entries
    ADD CONSTRAINT access_control_entries_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: data_source_config_definitions data_source_config_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_config_definitions
    ADD CONSTRAINT data_source_config_definitions_pkey PRIMARY KEY (id);


--
-- Name: data_source_instance_configs data_source_instance_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_instance_configs
    ADD CONSTRAINT data_source_instance_configs_pkey PRIMARY KEY (id);


--
-- Name: data_source_instance_endpoints data_source_instance_endpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_instance_endpoints
    ADD CONSTRAINT data_source_instance_endpoints_pkey PRIMARY KEY (id);


--
-- Name: data_source_instances data_source_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_instances
    ADD CONSTRAINT data_source_instances_pkey PRIMARY KEY (id);


--
-- Name: data_source_tags data_source_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_tags
    ADD CONSTRAINT data_source_tags_pkey PRIMARY KEY (id);


--
-- Name: data_sources data_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_sources
    ADD CONSTRAINT data_sources_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: infrastructure_elastic_search_instances infrastructure_elastic_search_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.infrastructure_elastic_search_instances
    ADD CONSTRAINT infrastructure_elastic_search_instances_pkey PRIMARY KEY (id);


--
-- Name: infrastructure_redis_instances infrastructure_redis_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.infrastructure_redis_instances
    ADD CONSTRAINT infrastructure_redis_instances_pkey PRIMARY KEY (id);


--
-- Name: infrastructure_sortinghat_instances infrastructure_sortinghat_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.infrastructure_sortinghat_instances
    ADD CONSTRAINT infrastructure_sortinghat_instances_pkey PRIMARY KEY (id);


--
-- Name: project_infrastructure_elastic_search_assignments project_infrastructure_elastic_search_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_infrastructure_elastic_search_assignments
    ADD CONSTRAINT project_infrastructure_elastic_search_assignments_pkey PRIMARY KEY (id);


--
-- Name: project_infrastructure_redis_assignments project_infrastructure_redis_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_infrastructure_redis_assignments
    ADD CONSTRAINT project_infrastructure_redis_assignments_pkey PRIMARY KEY (id);


--
-- Name: project_infrastructure_sortinghat_assignments project_infrastructure_sortinghat_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_infrastructure_sortinghat_assignments
    ADD CONSTRAINT project_infrastructure_sortinghat_assignments_pkey PRIMARY KEY (id);


--
-- Name: project_salesforce_data project_salesforce_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_salesforce_data
    ADD CONSTRAINT project_salesforce_data_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: view_collections_containers view_collections_containers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_collections_containers
    ADD CONSTRAINT view_collections_containers_pkey PRIMARY KEY (id);


--
-- Name: view_collections view_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_collections
    ADD CONSTRAINT view_collections_pkey PRIMARY KEY (id);


--
-- Name: view_containers view_containers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_containers
    ADD CONSTRAINT view_containers_pkey PRIMARY KEY (id);


--
-- Name: data_source_anc_desc_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX data_source_anc_desc_idx ON public.data_source_hierarchies USING btree (ancestor_id, descendant_id, generations);


--
-- Name: data_source_desc_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX data_source_desc_idx ON public.data_source_hierarchies USING btree (descendant_id);


--
-- Name: index_access_control_entries_on_subject_and_s_and_r_and_a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_access_control_entries_on_subject_and_s_and_r_and_a ON public.access_control_entries USING btree (subject, scope, resource, action);


--
-- Name: index_data_source_config_definitions_on_data_source_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_data_source_config_definitions_on_data_source_id ON public.data_source_config_definitions USING btree (data_source_id);


--
-- Name: index_data_source_instance_configs_on_d_s_config_definition_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_data_source_instance_configs_on_d_s_config_definition_id ON public.data_source_instance_configs USING btree (data_source_config_definition_id);


--
-- Name: index_data_source_instance_configs_on_data_source_instance_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_data_source_instance_configs_on_data_source_instance_id ON public.data_source_instance_configs USING btree (data_source_instance_id);


--
-- Name: index_data_source_instance_endpoints_on_data_source_instance_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_data_source_instance_endpoints_on_data_source_instance_id ON public.data_source_instance_endpoints USING btree (data_source_instance_id);


--
-- Name: index_data_source_tags_on_tag_type_and_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_data_source_tags_on_tag_type_and_value ON public.data_source_tags USING btree (tag_type, value);


--
-- Name: index_data_source_tags_sources_on_d_s_id_and_d_s_t_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_data_source_tags_sources_on_d_s_id_and_d_s_t_id ON public.data_source_tags_sources USING btree (data_source_id, data_source_tag_id);


--
-- Name: index_data_source_tags_sources_on_data_source_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_data_source_tags_sources_on_data_source_id ON public.data_source_tags_sources USING btree (data_source_id);


--
-- Name: index_data_source_tags_sources_on_data_source_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_data_source_tags_sources_on_data_source_tag_id ON public.data_source_tags_sources USING btree (data_source_tag_id);


--
-- Name: index_data_sources_on_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_data_sources_on_parent_id ON public.data_sources USING btree (parent_id);


--
-- Name: index_ds_config_definition_on_ds_instance_and_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_ds_config_definition_on_ds_instance_and_key ON public.data_source_config_definitions USING btree (data_source_id, key_name);


--
-- Name: index_ds_instance_config_on_i_k; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_ds_instance_config_on_i_k ON public.data_source_instance_configs USING btree (data_source_instance_id, key);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON public.friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON public.friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON public.friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON public.friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_project_infrastructure_e_a_i_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_project_infrastructure_e_a_i_id ON public.project_infrastructure_elastic_search_assignments USING btree (infrastructure_elastic_search_instance_id);


--
-- Name: index_project_infrastructure_e_a_i_index_qualifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_project_infrastructure_e_a_i_index_qualifier ON public.project_infrastructure_elastic_search_assignments USING btree (index_qualifier);


--
-- Name: index_project_infrastructure_e_a_i_uq; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_project_infrastructure_e_a_i_uq ON public.project_infrastructure_elastic_search_assignments USING btree (infrastructure_elastic_search_instance_id, space);


--
-- Name: index_project_infrastructure_e_a_p_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_project_infrastructure_e_a_p_id ON public.project_infrastructure_elastic_search_assignments USING btree (project_id);


--
-- Name: index_project_infrastructure_r_a_i_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_project_infrastructure_r_a_i_id ON public.project_infrastructure_redis_assignments USING btree (infrastructure_redis_instance_id);


--
-- Name: index_project_infrastructure_r_a_i_uq; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_project_infrastructure_r_a_i_uq ON public.project_infrastructure_redis_assignments USING btree (infrastructure_redis_instance_id, database);


--
-- Name: index_project_infrastructure_r_a_p_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_project_infrastructure_r_a_p_id ON public.project_infrastructure_redis_assignments USING btree (project_id);


--
-- Name: index_project_infrastructure_s_a_i_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_project_infrastructure_s_a_i_id ON public.project_infrastructure_sortinghat_assignments USING btree (infrastructure_sortinghat_instance_id);


--
-- Name: index_project_infrastructure_s_a_p_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_project_infrastructure_s_a_p_id ON public.project_infrastructure_sortinghat_assignments USING btree (project_id);


--
-- Name: index_project_salesforce_data_on_project_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_project_salesforce_data_on_project_id ON public.project_salesforce_data USING btree (project_id);


--
-- Name: index_projects_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_projects_on_slug ON public.projects USING btree (slug);


--
-- Name: index_projects_on_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_projects_on_status ON public.projects USING btree (status);


--
-- Name: index_view_collections_containers_covered; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_view_collections_containers_covered ON public.view_collections_containers USING btree (view_collection_id, view_container_id);


--
-- Name: index_view_collections_containers_on_view_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_view_collections_containers_on_view_collection_id ON public.view_collections_containers USING btree (view_collection_id);


--
-- Name: index_view_collections_containers_on_view_container_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_view_collections_containers_on_view_container_id ON public.view_collections_containers USING btree (view_container_id);


--
-- Name: index_view_collections_on_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_view_collections_on_parent_id ON public.view_collections USING btree (parent_id);


--
-- Name: index_view_collections_on_parent_id_and_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_view_collections_on_parent_id_and_name ON public.view_collections USING btree (parent_id, name);


--
-- Name: index_view_collections_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_view_collections_on_slug ON public.view_collections USING btree (slug);


--
-- Name: project_anc_desc_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX project_anc_desc_idx ON public.project_hierarchies USING btree (ancestor_id, descendant_id, generations);


--
-- Name: project_desc_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_desc_idx ON public.project_hierarchies USING btree (descendant_id);


--
-- Name: view_category_anc_desc_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX view_category_anc_desc_idx ON public.view_collection_hierarchies USING btree (ancestor_id, descendant_id, generations);


--
-- Name: view_category_desc_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX view_category_desc_idx ON public.view_collection_hierarchies USING btree (descendant_id);


--
-- Name: project_infrastructure_sortinghat_assignments fk_rails_0aad6a610e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_infrastructure_sortinghat_assignments
    ADD CONSTRAINT fk_rails_0aad6a610e FOREIGN KEY (infrastructure_sortinghat_instance_id) REFERENCES public.infrastructure_sortinghat_instances(id);


--
-- Name: data_source_config_definitions fk_rails_30bf3e5c64; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_config_definitions
    ADD CONSTRAINT fk_rails_30bf3e5c64 FOREIGN KEY (data_source_id) REFERENCES public.data_sources(id);


--
-- Name: data_sources fk_rails_34587d19ca; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_sources
    ADD CONSTRAINT fk_rails_34587d19ca FOREIGN KEY (parent_id) REFERENCES public.data_sources(id);


--
-- Name: project_infrastructure_redis_assignments fk_rails_4aec603582; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_infrastructure_redis_assignments
    ADD CONSTRAINT fk_rails_4aec603582 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: data_source_instance_endpoints fk_rails_5021f65320; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_instance_endpoints
    ADD CONSTRAINT fk_rails_5021f65320 FOREIGN KEY (data_source_instance_id) REFERENCES public.data_source_instances(id);


--
-- Name: project_infrastructure_elastic_search_assignments fk_rails_70718bbf43; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_infrastructure_elastic_search_assignments
    ADD CONSTRAINT fk_rails_70718bbf43 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: project_salesforce_data fk_rails_7749b047a1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_salesforce_data
    ADD CONSTRAINT fk_rails_7749b047a1 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: data_source_instance_configs fk_rails_854d81aa92; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_instance_configs
    ADD CONSTRAINT fk_rails_854d81aa92 FOREIGN KEY (data_source_config_definition_id) REFERENCES public.data_source_config_definitions(id);


--
-- Name: data_source_instance_configs fk_rails_8aefab1989; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_instance_configs
    ADD CONSTRAINT fk_rails_8aefab1989 FOREIGN KEY (data_source_instance_id) REFERENCES public.data_source_instances(id);


--
-- Name: project_infrastructure_redis_assignments fk_rails_b0f8332041; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_infrastructure_redis_assignments
    ADD CONSTRAINT fk_rails_b0f8332041 FOREIGN KEY (infrastructure_redis_instance_id) REFERENCES public.infrastructure_redis_instances(id);


--
-- Name: view_collections fk_rails_bdbea810fd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_collections
    ADD CONSTRAINT fk_rails_bdbea810fd FOREIGN KEY (parent_id) REFERENCES public.view_collections(id);


--
-- Name: data_source_instances fk_rails_cf2c5175c1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_instances
    ADD CONSTRAINT fk_rails_cf2c5175c1 FOREIGN KEY (data_source_id) REFERENCES public.data_sources(id);


--
-- Name: data_source_instances fk_rails_d7c4e52b5d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_instances
    ADD CONSTRAINT fk_rails_d7c4e52b5d FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: project_infrastructure_elastic_search_assignments fk_rails_d9dfca425d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_infrastructure_elastic_search_assignments
    ADD CONSTRAINT fk_rails_d9dfca425d FOREIGN KEY (infrastructure_elastic_search_instance_id) REFERENCES public.infrastructure_elastic_search_instances(id);


--
-- Name: project_infrastructure_sortinghat_assignments fk_rails_f3d2f98db1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_infrastructure_sortinghat_assignments
    ADD CONSTRAINT fk_rails_f3d2f98db1 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- PostgreSQL database dump complete
--

