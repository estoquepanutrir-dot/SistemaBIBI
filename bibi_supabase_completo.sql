-- =============================================
-- Sistema Bibi Papelaria - Banco de Dados Completo
-- Cole este código no SQL Editor do Supabase
-- e clique em RUN
-- =============================================


-- ============
-- PRODUTOS
-- ============
CREATE TABLE produtos (
  id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome          TEXT NOT NULL,
  codigo        TEXT UNIQUE NOT NULL,
  categoria     TEXT,
  preco         NUMERIC(10, 2) NOT NULL DEFAULT 0,
  quantidade    INTEGER NOT NULL DEFAULT 0,
  fornecedor    TEXT,
  criado_em     TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO produtos (nome, codigo, categoria, preco, quantidade) VALUES
  ('Xerox preto e branco',  'PRD-LYV9K1',  NULL, 1.00,  9968),
  ('Xerox colorido',        'PRD-3S8K10',  NULL, 1.50,  10000),
  ('Figurinha da copa',     'PRD-Y2438T',  NULL, 7.00,  0),
  ('Plastificação A4',      'PRD-0XZQFU',  NULL, 6.00,  10000),
  ('Plastificação Pequeno', 'PRD-7O2BVT',  NULL, 2.50,  10000),
  ('Clips',                 'PRD-65T8KC',  NULL, 5.00,  13);


-- ============
-- VENDAS
-- ============
CREATE TABLE vendas (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  data       DATE NOT NULL,
  hora       TIME NOT NULL,
  itens      TEXT NOT NULL,
  subtotal   NUMERIC(10, 2) NOT NULL DEFAULT 0,
  desconto   NUMERIC(10, 2) NOT NULL DEFAULT 0,
  total      NUMERIC(10, 2) NOT NULL DEFAULT 0,
  pagamento  TEXT NOT NULL,
  criado_em  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO vendas (data, hora, itens, subtotal, desconto, total, pagamento) VALUES
  ('2026-05-18', '08:17:47', 'Gloss(1)', 16.00, 0.00, 16.00, 'dinheiro'),
  ('2026-05-18', '08:39:31', 'Clips(1)', 5.00, 0.00, 5.00, 'dinheiro'),
  ('2026-05-18', '08:47:25', 'Papel Crepon(1)', 2.75, 0.00, 2.75, 'credito'),
  ('2026-05-18', '09:34:19', 'piranha de cabelo(2)', 10.00, 0.00, 10.00, 'dinheiro'),
  ('2026-05-18', '09:34:51', 'pacote trasp ziper (4)', 10.00, 0.00, 10.00, 'dinheiro'),
  ('2026-05-18', '09:42:08', 'xerox preto e branco(1)', 1.00, 0.00, 1.00, 'dinheiro'),
  ('2026-05-18', '12:59:37', 'xerox preto e branco(17)', 17.00, 0.00, 17.00, 'dinheiro'),
  ('2026-05-18', '13:03:18', 'doce de banana(3), impressao(1)', 10.00, 0.00, 10.00, 'pix'),
  ('2026-05-18', '13:16:51', 'kit canetinha(1), lapis(1), apontador(1), borracha(1), kit lapis de cor(1)', 70.00, 0.00, 70.00, 'pix'),
  ('2026-05-18', '13:18:57', 'Figurinha da copa(35)', 245.00, 0.00, 245.00, 'dinheiro'),
  ('2026-05-18', '13:19:32', 'Figurinhas da copa (1)', 5.00, 0.00, 5.00, 'dinheiro'),
  ('2026-05-18', '13:29:11', 'xerox preto e branco(2)', 2.00, 0.00, 2.00, 'dinheiro'),
  ('2026-05-18', '14:04:57', 'empacota iten(1)', 6.00, 0.00, 6.00, 'dinheiro'),
  ('2026-05-18', '14:10:09', 'Figurinha da copa(17)', 119.00, 0.00, 119.00, 'dinheiro'),
  ('2026-05-18', '14:15:26', 'PASTA(1)', 10.00, 0.00, 10.00, 'dinheiro'),
  ('2026-05-18', '14:23:36', 'MAQUETE(1)', 30.00, 0.00, 30.00, 'dinheiro'),
  ('2026-05-18', '14:53:43', 'etiqueta(1), sacola(1)', 18.00, 0.00, 18.00, 'pix'),
  ('2026-05-18', '14:53:54', 'xerox preto e branco(1)', 1.00, 0.00, 1.00, 'dinheiro'),
  ('2026-05-18', '15:32:27', 'Figurinha da copa(5)', 35.00, 0.00, 35.00, 'pix'),
  ('2026-05-18', '15:39:26', 'Figurinha da copa(2)', 14.00, 0.00, 14.00, 'dinheiro'),
  ('2026-05-18', '16:09:48', 'crepon(1), eva(1), color set(2), pacote sulfite(1), garrafa(1), etiqueta(1), pasta com elastico(1), Mochila(1)', 89.75, 0.00, 89.75, 'pix'),
  ('2026-05-18', '16:34:14', 'chaveiro (1)', 7.00, 0.00, 7.00, 'dinheiro'),
  ('2026-05-18', '16:42:21', 'Figurinha da copa(4), seda(10), quish(2), aneis(2), cartinhas(10)', 46.50, 1.50, 45.00, 'pix'),
  ('2026-05-18', '17:05:15', 'Figurinha da copa(15)', 105.00, 0.00, 105.00, 'dinheiro'),
  ('2026-05-18', '17:14:30', 'Figurinha da copa(2)', 14.00, 0.00, 14.00, 'pix'),
  ('2026-05-18', '17:16:43', 'Figurinha da copa(2)', 14.00, 0.00, 14.00, 'dinheiro'),
  ('2026-05-18', '17:17:05', 'xerox preto e branco(1)', 1.00, 0.00, 1.00, 'pix'),
  ('2026-05-18', '22:23:09', 'Xerox(1)', 1.50, 0.00, 1.50, 'dinheiro'),
  ('2026-05-19', '09:59:11', 'Figurinha da copa(1)', 7.00, 0.00, 7.00, 'dinheiro'),
  ('2026-05-19', '09:59:37', 'empacotar(1)', 3.00, 0.00, 3.00, 'dinheiro'),
  ('2026-05-19', '10:57:50', 'figurinha da copa(1)', 3.00, 0.00, 3.00, 'dinheiro'),
  ('2026-05-19', '10:58:02', 'figurinha da copa(1)', 32.00, 0.00, 32.00, 'pix'),
  ('2026-05-19', '10:58:23', 'Figurinha da copa(10)', 70.00, 0.00, 70.00, 'pix'),
  ('2026-05-19', '10:58:39', 'xerox preto e branco(3)', 3.00, 0.00, 3.00, 'pix'),
  ('2026-05-19', '10:58:59', 'caneta permanente(1)', 8.25, 0.00, 8.25, 'pix'),
  ('2026-05-19', '10:59:43', 'xerox(3), envelope(1)', 3.75, 0.00, 3.75, 'pix'),
  ('2026-05-19', '11:00:08', 'figurinha(10)', 75.00, 0.00, 75.00, 'debito'),
  ('2026-05-19', '11:01:00', 'empacotar(1)', 3.00, 0.00, 3.00, 'dinheiro'),
  ('2026-05-19', '11:02:56', 'plastificação(1)', 4.50, 0.00, 4.50, 'dinheiro'),
  ('2026-05-19', '11:03:40', 'empacota(1)', 7.00, 0.00, 7.00, 'dinheiro'),
  ('2026-05-19', '11:03:55', 'plastificação (2)', 5.00, 0.00, 5.00, 'dinheiro'),
  ('2026-05-19', '11:04:13', 'PDF(1)', 5.00, 0.00, 5.00, 'pix'),
  ('2026-05-19', '11:04:26', 'XEROX(1)', 1.00, 0.00, 1.00, 'dinheiro'),
  ('2026-05-19', '11:04:45', 'Figurinha da copa(3)', 21.00, 0.00, 21.00, 'pix'),
  ('2026-05-19', '12:01:51', 'pacote trasp(16)', 12.00, 0.00, 12.00, 'debito'),
  ('2026-05-19', '12:07:57', 'massinha(1), fini(1)', 19.00, 0.00, 19.00, 'debito'),
  ('2026-05-19', '12:17:21', 'Figurinha da copa(1)', 7.00, 0.00, 7.00, 'dinheiro'),
  ('2026-05-19', '13:50:51', 'inss(1)', 7.50, 0.00, 7.50, 'dinheiro'),
  ('2026-05-19', '14:01:15', 'seda(22), cola(2)', 17.00, 0.00, 17.00, 'dinheiro'),
  ('2026-05-19', '17:34:35', 'Figurinha da copa(4)', 28.00, 0.00, 28.00, 'pix'),
  ('2026-05-19', '17:35:00', 'Figurinha da copa(1)', 7.00, 0.00, 7.00, 'dinheiro'),
  ('2026-05-19', '17:35:10', 'Figurinha da copa(3)', 21.00, 0.00, 21.00, 'dinheiro'),
  ('2026-05-19', '17:35:33', 'xerox preto e branco(7)', 7.00, 0.00, 7.00, 'dinheiro'),
  ('2026-05-19', '17:35:50', 'Figurinha da copa(14)', 98.00, 0.00, 98.00, 'dinheiro'),
  ('2026-05-19', '17:36:11', 'bolsa(1)', 45.00, 0.00, 45.00, 'dinheiro'),
  ('2026-05-19', '17:36:25', 'fita(1)', 0.85, 0.00, 0.85, 'pix'),
  ('2026-05-19', '17:37:01', 'kit perfume(1)', 164.90, 0.00, 164.90, 'credito'),
  ('2026-05-19', '17:37:20', 'Figurinha da copa(1)', 7.00, 0.00, 7.00, 'credito'),
  ('2026-05-19', '17:38:06', 'brinco(1), pente(1)', 25.00, 0.00, 25.00, 'pix'),
  ('2026-05-19', '17:38:25', 'grafite(1)', 7.50, 0.00, 7.50, 'debito');


-- ============
-- SAIDAS DE CAIXA
-- ============
CREATE TABLE saidas_caixa (
  id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  data      DATE NOT NULL,
  hora      TIME NOT NULL,
  valor     NUMERIC(10, 2) NOT NULL DEFAULT 0,
  motivo    TEXT,
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO saidas_caixa (data, hora, valor, motivo) VALUES
  ('2026-05-18', '14:45:08', 20.00,  'Gabriely cagou nas calças'),
  ('2026-05-18', '14:45:23', 150.00, 'Vale da Milena'),
  ('2026-05-19', '11:05:40', 699.16, 'BOLETO'),
  ('2026-05-19', '17:43:52', 60.50,  'Mercado loja'),
  ('2026-05-19', '19:25:03', 10.00,  'Adicional Mercado');


-- ============
-- CAIXA (abertura por dia)
-- ============
CREATE TABLE caixa (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  data         DATE NOT NULL,
  hora         TIME NOT NULL,
  valorinicial NUMERIC(10, 2) NOT NULL DEFAULT 0,
  usuario      TEXT NOT NULL DEFAULT 'admin',
  criado_em    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO caixa (data, hora, valorinicial, usuario) VALUES
  ('2026-05-18', '08:25:27', 583.35, 'admin'),
  ('2026-05-19', '08:55:40', 983.25, 'admin');


-- ============
-- ATUALIZAÇÃO AUTOMÁTICA DE TIMESTAMP
-- ============
CREATE OR REPLACE FUNCTION atualizar_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.atualizado_em = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_produtos
BEFORE UPDATE ON produtos
FOR EACH ROW
EXECUTE FUNCTION atualizar_timestamp();
