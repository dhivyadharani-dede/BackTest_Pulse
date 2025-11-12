-- Table: public.strategy_all_results

-- DROP TABLE IF EXISTS public.strategy_all_results;

CREATE TABLE IF NOT EXISTS public.strategy_all_results
(
    run_id integer NOT NULL DEFAULT nextval('strategy_all_results_run_id_seq'::regclass),
    strategy_name text COLLATE pg_catalog."default",
    trade_date date,
    expiry_date date,
    breakout_time time without time zone,
    entry_time time without time zone,
    spot_price numeric,
    option_type text COLLATE pg_catalog."default",
    strike numeric,
    entry_price numeric,
    sl_level numeric,
    entry_round integer,
    leg_type text COLLATE pg_catalog."default",
    transaction_type text COLLATE pg_catalog."default",
    exit_time time without time zone,
    exit_price numeric,
    exit_reason text COLLATE pg_catalog."default",
    pnl_amount numeric,
    total_pnl_per_day numeric,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT strategy_all_results_pkey PRIMARY KEY (run_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.strategy_all_results
    OWNER to postgres;