SET check_function_bodies = false;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public."Condominium" (
    id integer NOT NULL,
    name text NOT NULL,
    cnpj text NOT NULL,
    zip text NOT NULL,
    address_l1 text NOT NULL,
    address_l2 text,
    address_l3 text,
    address_l4 text,
    city text NOT NULL,
    state text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
COMMENT ON TABLE public."Condominium" IS 'Should store the condominium list';
CREATE TABLE public."House" (
    id integer NOT NULL,
    number integer NOT NULL,
    block text NOT NULL,
    condominium_id integer NOT NULL,
    comments text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
COMMENT ON TABLE public."House" IS 'should store the houses of a condominium';
CREATE TABLE public."Vehicle" (
    id integer NOT NULL,
    type text NOT NULL,
    brand text NOT NULL,
    model text NOT NULL,
    color text NOT NULL,
    house_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
COMMENT ON TABLE public."Vehicle" IS 'Should Store Vehicle data';
CREATE SEQUENCE public."Vehicle_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public."Vehicle_id_seq" OWNED BY public."Vehicle".id;
CREATE TABLE public."Visitor" (
    id integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    rg text NOT NULL,
    cpf text NOT NULL,
    dob date NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
COMMENT ON TABLE public."Visitor" IS 'should store every visitor ';
CREATE SEQUENCE public.condominium_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.condominium_id_seq OWNED BY public."Condominium".id;
CREATE SEQUENCE public.house_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.house_id_seq OWNED BY public."House".id;
ALTER TABLE ONLY public."Condominium" ALTER COLUMN id SET DEFAULT nextval('public.condominium_id_seq'::regclass);
ALTER TABLE ONLY public."House" ALTER COLUMN id SET DEFAULT nextval('public.house_id_seq'::regclass);
ALTER TABLE ONLY public."Vehicle" ALTER COLUMN id SET DEFAULT nextval('public."Vehicle_id_seq"'::regclass);
ALTER TABLE ONLY public."Vehicle"
    ADD CONSTRAINT "Vehicle_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Condominium"
    ADD CONSTRAINT condominium_cnpj_key UNIQUE (cnpj);
ALTER TABLE ONLY public."Condominium"
    ADD CONSTRAINT condominium_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public."House"
    ADD CONSTRAINT house_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public."Visitor"
    ADD CONSTRAINT visitors_cpf_key UNIQUE (cpf);
ALTER TABLE ONLY public."Visitor"
    ADD CONSTRAINT visitors_pkey PRIMARY KEY (id);
CREATE TRIGGER "set_public_Vehicle_updated_at" BEFORE UPDATE ON public."Vehicle" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_public_Vehicle_updated_at" ON public."Vehicle" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_condominium_updated_at BEFORE UPDATE ON public."Condominium" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_condominium_updated_at ON public."Condominium" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_house_updated_at BEFORE UPDATE ON public."House" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_house_updated_at ON public."House" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_visitors_updated_at BEFORE UPDATE ON public."Visitor" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_visitors_updated_at ON public."Visitor" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public."Vehicle"
    ADD CONSTRAINT "Vehicle_house_id_fkey" FOREIGN KEY (house_id) REFERENCES public."House"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public."House"
    ADD CONSTRAINT house_condominium_id_fkey FOREIGN KEY (condominium_id) REFERENCES public."Condominium"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
