-- ============================================================
-- MIGRATION V2 – Bibi Papelaria
-- Execute no painel SQL do Supabase
-- ============================================================

-- 1. Preço de custo em produtos
ALTER TABLE produtos
  ADD COLUMN IF NOT EXISTS preco_custo NUMERIC(10,2) DEFAULT 0;

-- 2. Histórico de alterações de preço de custo
CREATE TABLE IF NOT EXISTS historico_preco_custo (
  id          BIGSERIAL PRIMARY KEY,
  produto_codigo TEXT NOT NULL,
  preco_custo_anterior NUMERIC(10,2),
  preco_custo_novo     NUMERIC(10,2) NOT NULL,
  usuario     TEXT NOT NULL,
  criado_em   TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Boletos de fornecedores
CREATE TABLE IF NOT EXISTS boletos (
  id              BIGSERIAL PRIMARY KEY,
  fornecedor      TEXT NOT NULL,
  valor           NUMERIC(10,2) NOT NULL,
  data_emissao    DATE NOT NULL,
  data_vencimento DATE NOT NULL,
  status          TEXT NOT NULL DEFAULT 'pendente',  -- pendente | pago
  observacoes     TEXT,
  criado_em       TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Clientes
CREATE TABLE IF NOT EXISTS clientes (
  id        BIGSERIAL PRIMARY KEY,
  nome      TEXT NOT NULL,
  telefone  TEXT,
  cpf       TEXT,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Fiado (registro de venda a prazo)
CREATE TABLE IF NOT EXISTS fiado (
  id          BIGSERIAL PRIMARY KEY,
  cliente_id  BIGINT REFERENCES clientes(id) ON DELETE CASCADE,
  descricao   TEXT,
  valor_total NUMERIC(10,2) NOT NULL,
  valor_pago  NUMERIC(10,2) NOT NULL DEFAULT 0,
  data        DATE NOT NULL,
  criado_em   TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Pagamentos de fiado
CREATE TABLE IF NOT EXISTS fiado_pagamentos (
  id          BIGSERIAL PRIMARY KEY,
  fiado_id    BIGINT REFERENCES fiado(id) ON DELETE CASCADE,
  valor       NUMERIC(10,2) NOT NULL,
  data        DATE NOT NULL,
  observacoes TEXT,
  criado_em   TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Datas comemorativas
CREATE TABLE IF NOT EXISTS datas_comemorativas (
  id         BIGSERIAL PRIMARY KEY,
  nome       TEXT NOT NULL,
  mes        INTEGER NOT NULL,  -- 1-12
  dia        INTEGER NOT NULL,  -- 1-31
  anotacao   TEXT,
  criado_em  TIMESTAMPTZ DEFAULT NOW()
);

-- Datas padrão
INSERT INTO datas_comemorativas (nome, mes, dia) VALUES
  ('Dia das Mães',      5,  11),
  ('Dia dos Pais',      8,  11),
  ('Dia das Crianças', 10,  12),
  ('Natal',            12,  25),
  ('Black Friday',     11,  28),
  ('Dia dos Namorados', 6,  12),
  ('Ano Novo',          1,   1),
  ('Carnaval',          2,  28),
  ('Páscoa',            4,  20),
  ('Dia do Professor', 10,  15)
ON CONFLICT DO NOTHING;

-- 8. Metas mensais
CREATE TABLE IF NOT EXISTS metas (
  id        BIGSERIAL PRIMARY KEY,
  mes       INTEGER NOT NULL,  -- 1-12
  ano       INTEGER NOT NULL,
  valor     NUMERIC(10,2) NOT NULL,
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(mes, ano)
);

-- 9. Coluna de fechamento no caixa (controle de caixa não fechado)
ALTER TABLE caixa ADD COLUMN IF NOT EXISTS fechado_em TIMESTAMPTZ;

-- RLS: desabilitar para uso simples (ajuste conforme sua política)
ALTER TABLE boletos             DISABLE ROW LEVEL SECURITY;
ALTER TABLE clientes            DISABLE ROW LEVEL SECURITY;
ALTER TABLE fiado               DISABLE ROW LEVEL SECURITY;
ALTER TABLE fiado_pagamentos    DISABLE ROW LEVEL SECURITY;
ALTER TABLE datas_comemorativas DISABLE ROW LEVEL SECURITY;
ALTER TABLE metas               DISABLE ROW LEVEL SECURITY;
ALTER TABLE historico_preco_custo DISABLE ROW LEVEL SECURITY;
