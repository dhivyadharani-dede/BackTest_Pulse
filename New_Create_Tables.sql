-- Table: public.strategy_conditions

-- DROP TABLE IF EXISTS public.strategy_conditions;

CREATE TABLE IF NOT EXISTS public.strategy_conditions
(
    strategy_name text COLLATE pg_catalog."default" NOT NULL,
    big_candle_tf numeric DEFAULT 15,
    small_candle_tf numeric DEFAULT 5,
    preferred_breakout_type text COLLATE pg_catalog."default" DEFAULT 'full_candle_breakout'::text,
    breakout_threshold_pct numeric DEFAULT 60,
    option_entry_price_cap numeric DEFAULT 80,
    hedge_entry_price_cap numeric DEFAULT 50,
    num_entry_legs integer DEFAULT 4,
    num_hedge_legs integer DEFAULT 1,
    sl_percentage numeric DEFAULT 20,
    eod_time time without time zone DEFAULT '15:20:00'::time without time zone,
    no_of_lots integer DEFAULT 1,
    lot_size integer DEFAULT 75,
    hedge_exit_entry_ratio numeric DEFAULT 50,
    hedge_exit_multiplier numeric DEFAULT 3,
    leg_profit_pct numeric DEFAULT 84,
    portfolio_profit_target_pct numeric DEFAULT 2,
    portfolio_stop_loss_pct numeric DEFAULT 2,
    portfolio_capital numeric DEFAULT 900000,
    max_reentry_rounds numeric DEFAULT 1,
    sl_type text COLLATE pg_catalog."default" DEFAULT 'regular_system_sl'::text,
    box_sl_trigger_pct numeric DEFAULT 2,
    box_sl_hard_pct numeric DEFAULT 2,
    reentry_breakout_type text COLLATE pg_catalog."default" DEFAULT 'full_candle_breakout'::text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT strategy_conditions_pkey PRIMARY KEY (strategy_name),
    CONSTRAINT strategy_conditions_preferred_breakout_type_check CHECK (preferred_breakout_type = ANY (ARRAY['full_candle_breakout'::text, 'pct_based_breakout'::text])),
    CONSTRAINT strategy_conditions_sl_type_check CHECK (sl_type = ANY (ARRAY['regular_system_sl'::text, 'box_with_buffer_sl'::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.strategy_conditions
    OWNER to postgres;
	
--------------------------------------
-- Table: public.strategy_daily_summary

-- DROP TABLE IF EXISTS public.strategy_daily_summary;

CREATE TABLE IF NOT EXISTS public.strategy_daily_summary
(
    id integer NOT NULL DEFAULT nextval('strategy_daily_summary_id_seq'::regclass),
    strategy_name text COLLATE pg_catalog."default",
    trade_date date,
    total_daily_pnl numeric,
    num_trades integer,
    avg_trade_pnl numeric,
    max_trade_win numeric,
    max_trade_loss numeric,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT strategy_daily_summary_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.strategy_daily_summary
    OWNER to postgres;
--------------------------------------------------
-- Table: public.strategy_leg_book

-- DROP TABLE IF EXISTS public.strategy_leg_book;

CREATE TABLE IF NOT EXISTS public.strategy_leg_book
(
    trade_date date NOT NULL,
    expiry_date date NOT NULL,
    breakout_time time without time zone,
    entry_time time without time zone NOT NULL,
    exit_time time without time zone,
    option_type text COLLATE pg_catalog."default" NOT NULL,
    strike numeric NOT NULL,
    entry_price numeric NOT NULL,
    exit_price numeric,
    transaction_type text COLLATE pg_catalog."default" NOT NULL,
    leg_type text COLLATE pg_catalog."default" NOT NULL,
    entry_round integer NOT NULL DEFAULT 1,
    exit_reason text COLLATE pg_catalog."default",
    CONSTRAINT strategy_leg_book_pkey PRIMARY KEY (trade_date, expiry_date, strike, option_type, entry_round, leg_type),
    CONSTRAINT strategy_leg_book_option_type_check CHECK (option_type = ANY (ARRAY['C'::text, 'P'::text])),
    CONSTRAINT strategy_leg_book_transaction_type_check CHECK (transaction_type = ANY (ARRAY['BUY'::text, 'SELL'::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.strategy_leg_book
    OWNER to postgres;
-- Index: idx_legbook_rounds

-- DROP INDEX IF EXISTS public.idx_legbook_rounds;

CREATE INDEX IF NOT EXISTS idx_legbook_rounds
    ON public.strategy_leg_book USING btree
    (trade_date ASC NULLS LAST, entry_round ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_legbook_status

-- DROP INDEX IF EXISTS public.idx_legbook_status;

CREATE INDEX IF NOT EXISTS idx_legbook_status
    ON public.strategy_leg_book USING btree
    (exit_time ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_legbook_trade_entry

-- DROP INDEX IF EXISTS public.idx_legbook_trade_entry;

CREATE INDEX IF NOT EXISTS idx_legbook_trade_entry
    ON public.strategy_leg_book USING btree
    (trade_date ASC NULLS LAST, entry_time ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_legbook_trade_exit

-- DROP INDEX IF EXISTS public.idx_legbook_trade_exit;

CREATE INDEX IF NOT EXISTS idx_legbook_trade_exit
    ON public.strategy_leg_book USING btree
    (trade_date ASC NULLS LAST, exit_time ASC NULLS LAST)
    TABLESPACE pg_default;
-----------------------------------------------
-- Table: public.strategy_run_log

-- DROP TABLE IF EXISTS public.strategy_run_log;

CREATE TABLE IF NOT EXISTS public.strategy_run_log
(
    run_id integer NOT NULL DEFAULT nextval('strategy_run_log_run_id_seq'::regclass),
    strategy_name text COLLATE pg_catalog."default",
    start_date date,
    end_date date,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    total_duration_sec numeric,
    CONSTRAINT strategy_run_log_pkey PRIMARY KEY (run_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.strategy_run_log
    OWNER to postgres;
------------------------------
-- Table: public.temp_strategy_conditions

-- DROP TABLE IF EXISTS public.temp_strategy_conditions;

CREATE TABLE IF NOT EXISTS public.temp_strategy_conditions
(
    strategy_name text COLLATE pg_catalog."default",
    big_candle_tf text COLLATE pg_catalog."default",
    small_candle_tf text COLLATE pg_catalog."default",
    preferred_breakout_type text COLLATE pg_catalog."default",
    breakout_threshold_pct text COLLATE pg_catalog."default",
    option_entry_price_cap text COLLATE pg_catalog."default",
    hedge_entry_price_cap text COLLATE pg_catalog."default",
    num_entry_legs text COLLATE pg_catalog."default",
    num_hedge_legs text COLLATE pg_catalog."default",
    sl_percentage text COLLATE pg_catalog."default",
    eod_time text COLLATE pg_catalog."default",
    lot_size text COLLATE pg_catalog."default",
    hedge_exit_entry_ratio text COLLATE pg_catalog."default",
    hedge_exit_multiplier text COLLATE pg_catalog."default",
    leg_profit_pct text COLLATE pg_catalog."default",
    portfolio_profit_target_pct text COLLATE pg_catalog."default",
    portfolio_stop_loss_pct text COLLATE pg_catalog."default",
    portfolio_capital text COLLATE pg_catalog."default",
    max_reentry_rounds text COLLATE pg_catalog."default",
    sl_type text COLLATE pg_catalog."default",
    box_sl_trigger_pct text COLLATE pg_catalog."default",
    box_sl_hard_pct text COLLATE pg_catalog."default",
    reentry_breakout_type text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.temp_strategy_conditions
    OWNER to postgres;
	