-- ===================================================================
-- INSERT articulo_perfil_compra for profile PrdImport
-- Generated: 2026-05-27
-- Total articles: 1275
-- Criteria: Excel(310), Foreign(737), StockMin(729), Formula(101), RepStkMin(93), ConsuProd(31)
-- ===================================================================

BEGIN TRANSACTION;

-- Delete existing PrdImport assignments (clean reload)
DELETE FROM articulo_perfil_compra WHERE cod_emp = 'EPSA' AND perfil_compra_id = 'PrdImport';

INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '0400860', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '100001490102', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 2, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '100001490103', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 3, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '100001490104', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 4, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '101801300400', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 5, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '106501520000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 6, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '106501610000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 7, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '124001040192', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 8, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '124025060500', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 9, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '124029061000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 10, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '125030000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 11, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '125060000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 12, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '126400000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 13, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '126400100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 14, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12900100000000', 'PrdImport', 'S', 'Crit: Excel,Excel', 'FrmArtPrf', 'General', '', 15, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12900200000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 16, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12920000000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 17, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12920100000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 18, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12920200000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 19, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12920300000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 20, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12940060000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 21, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12940100000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 22, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12940200000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 23, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12940300000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 24, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12981010000000', 'PrdImport', 'S', 'Crit: Excel,Excel', 'FrmArtPrf', 'General', '', 25, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '12981020000000', 'PrdImport', 'S', 'Crit: Excel,Excel', 'FrmArtPrf', 'General', '', 26, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '130010000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 27, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '130020000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 28, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '130030000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 29, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '130060000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 30, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '130070000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 31, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '130080000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 32, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '130090000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 33, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '130100000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 34, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '130110000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 35, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140015000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 36, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140022000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 37, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140032000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 38, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140038000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 39, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140041000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 40, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140045000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 41, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140055000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 42, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140070000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 43, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140080000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 44, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140090002263', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 45, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140090003927', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 46, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140090055493', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 47, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140090060000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 48, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140090062000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 49, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140090070000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 50, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140090071000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 51, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '140090226698', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 52, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '150001000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 53, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '150003000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 54, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '152036000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 55, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '152045000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 56, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '153051000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 57, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '154019000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 58, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '155000000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 59, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '155015800000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 60, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '155044000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 61, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '156004500200', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 62, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '157040100000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 63, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '157040200000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 64, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '157040300000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 65, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '157040400000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 66, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '157040500000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 67, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '157040520000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 68, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158027000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 69, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158080001000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 70, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158081000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 71, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158090100000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 72, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158090200000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 73, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158090300000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 74, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158090400000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 75, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158090500000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 76, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158090600000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 77, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158090700000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 78, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158090800000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 79, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158090900000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 80, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158090910000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 81, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158091000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 82, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158200100000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 83, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158200200000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 84, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158200300000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 85, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158200400000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 86, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158200600000', 'PrdImport', 'S', 'Crit: Excel,StockMin,Formula', 'FrmArtPrf', 'General', '', 87, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158200800000', 'PrdImport', 'S', 'Crit: Excel,StockMin,Formula', 'FrmArtPrf', 'General', '', 88, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158200900000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 89, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '158201000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,Formula', 'FrmArtPrf', 'General', '', 90, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 91, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159082380000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 92, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236355020', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 93, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236355040', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 94, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236365000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 95, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236365020', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 96, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236365040', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 97, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236375020', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 98, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236380000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 99, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236380040', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 100, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236390000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 101, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236390020', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 102, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159236390040', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 103, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159240600000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 104, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '159251000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 105, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '161000000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 106, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164040040004', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 107, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164040040005', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 108, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164050040003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 109, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164050040004', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 110, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164050040005', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 111, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164050050003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 112, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164050050004', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 113, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164050050005', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 114, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164050060004', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 115, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164050060005', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 116, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164060040003', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 117, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164060040004', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 118, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164060040005', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 119, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164060050003', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 120, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164060050004', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 121, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164060050005', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 122, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164060060003', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 123, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164060060004', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 124, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164070004003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 125, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164070040004', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 126, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164070040005', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 127, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164070050003', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 128, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164070050004', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 129, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164070050005', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 130, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164080004004', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 131, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164080004005', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 132, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164080005004', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 133, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164080005005', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 134, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164090000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 135, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164090001800', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 136, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164090002200', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 137, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '164090002500', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 138, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '203019010000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 139, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '203046100003', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 140, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '21200500000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 141, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22400100000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 142, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '226002000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 143, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '227406000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 144, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '227410000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 145, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '227501000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 146, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '2275025000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 147, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '227502600000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 148, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '227507000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 149, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '227508000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 150, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800300000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 151, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800350000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 152, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800400000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 153, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800450000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 154, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800500000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 155, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800550000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 156, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800600000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 157, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800650000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 158, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800700000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 159, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800750000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 160, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800800000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 161, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800850000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 162, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800900000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 163, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22800950000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 164, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22801000000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 165, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22810100000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 166, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22810200000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 167, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22810300000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 168, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22815100000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 169, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22815200000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 170, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22815300000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 171, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22820700000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 172, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22820900000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 173, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22821000000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 174, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '22821100000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 175, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '230101000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 176, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '232001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 177, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '244060000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 178, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '245010000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 179, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '245012000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 180, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '245014000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 181, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '245015000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 182, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '245086003180', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 183, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '247002000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 184, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '247004000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 185, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '247009810000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 186, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '247552000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 187, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '247554000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 188, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '247555000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 189, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '247556000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 190, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '247557000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 191, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '247558000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 192, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '248980048501', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 193, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '248980048502', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 194, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '248980060100', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 195, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '248980097319', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 196, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '248980097323', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 197, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '249012000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 198, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '250302000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 199, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '250308000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 200, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '250309000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 201, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '250310000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 202, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '250311000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 203, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '250312000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 204, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '250313000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 205, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '250402000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 206, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '251001000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 207, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '251021000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 208, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '251024000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 209, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '251024100000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 210, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '251024200000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 211, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '251025000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 212, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255000000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 213, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255006000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 214, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255008000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 215, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255011000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 216, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255012000000', 'PrdImport', 'S', 'Crit: Excel,Formula', 'FrmArtPrf', 'General', '', 217, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255013000000', 'PrdImport', 'S', 'Crit: Excel,Formula', 'FrmArtPrf', 'General', '', 218, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255014000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 219, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255015000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 220, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255016000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 221, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255018000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 222, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255019000000', 'PrdImport', 'S', 'Crit: Excel,Formula', 'FrmArtPrf', 'General', '', 223, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255019010000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 224, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255020000000', 'PrdImport', 'S', 'Crit: Excel,Formula', 'FrmArtPrf', 'General', '', 225, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '255021000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 226, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '258011000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 227, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '258012000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 228, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '258013000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 229, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '259040000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 230, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '259052000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 231, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '260011100000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 232, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '260013000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 233, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '260014000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 234, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '260015000002', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 235, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '260016000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 236, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '260016000004', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 237, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '260017000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 238, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '260018000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 239, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '260060100000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 240, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '262011000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 241, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '262013000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 242, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '262015000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 243, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '262016000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,Formula', 'FrmArtPrf', 'General', '', 244, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '262017000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 245, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '262018000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 246, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '264067000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 247, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '264068000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 248, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '264070000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 249, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '264075000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 250, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '264079000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 251, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '264080000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 252, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '264081000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,Formula', 'FrmArtPrf', 'General', '', 253, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '266052000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 254, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '266060000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 255, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267000100370', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 256, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267000210850', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 257, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267003001001', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 258, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267003001002', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 259, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267003501110', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 260, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267004001000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 261, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267004001120', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 262, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267004501130', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 263, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267005001100', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 264, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267005001210', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 265, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267005501220', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 266, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267006001100', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 267, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267006001230', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 268, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267006501240', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 269, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267007001216', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 270, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267007001250', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 271, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267007041250', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 272, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267007041251', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 273, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267007501260', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 274, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267008001216', 'PrdImport', 'S', 'Crit: Excel,Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 275, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267008001270', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 276, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267008041360', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 277, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267008041361', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 278, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267008501280', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 279, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267009001470', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 280, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267009001490', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 281, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267009041570', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 282, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267009041571', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 283, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267009501411', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 284, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267010001412', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 285, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267010001500', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 286, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267010041880', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 287, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267010041881', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 288, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267010501413', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 289, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267011001414', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 290, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267021000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 291, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267022000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 292, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267025000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 293, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267031000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 294, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267051000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 295, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267056000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 296, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267062001000', 'PrdImport', 'S', 'Crit: Excel,Foreign,Formula', 'FrmArtPrf', 'General', '', 297, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267065001000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 298, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267070006000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 299, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267070006706', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 300, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092001988', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 301, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092001989', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 302, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092001990', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 303, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092001991', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 304, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092001995', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 305, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092002000', 'PrdImport', 'S', 'Crit: Excel,Foreign,Formula', 'FrmArtPrf', 'General', '', 306, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092002100', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 307, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092002200', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 308, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092002300', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 309, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092730005', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 310, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092730130', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 311, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092730140', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 312, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092770010', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 313, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092770020', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 314, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092770030', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 315, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267092770031', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 316, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267300050300', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 317, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267431005036', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 318, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267431005425', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 319, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267431040411', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 320, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267680102810', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 321, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267680103510', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 322, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267680103515', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 323, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267680103810', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 324, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267680103815', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 325, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267682102810', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 326, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267682103510', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 327, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267682103515', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 328, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267682103810', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 329, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267682103815', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 330, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267682128412', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 331, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267682128416', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 332, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267682135516', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 333, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267682202810', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 334, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267682302810', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 335, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700010000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 336, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700020000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 337, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700025000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 338, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700030000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 339, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700040000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 340, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700045000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 341, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700050000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 342, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700060000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 343, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700070000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 344, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700080000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 345, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700090000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 346, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 347, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267700110000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 348, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267927300150', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 349, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267999800001', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 350, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '267999800002', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 351, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '268005000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 352, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '268018100000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 353, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '268035150000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 354, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '268135100000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 355, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '270910000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 356, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '270912000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 357, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '293800020132', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 358, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '293800020148', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 359, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '500900000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 360, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '501014000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 361, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '501015000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 362, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '501018000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 363, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '502002100000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 364, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '502004000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 365, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '506006000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 366, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507002000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 367, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507008200000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 368, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507010000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 369, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507012000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 370, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507013000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 371, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507018000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 372, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507018020000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 373, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507019000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 374, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507019010000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 375, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507021000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 376, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507022020000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 377, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507023000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 378, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507023010000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 379, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507024000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 380, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507025000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 381, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507026000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 382, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507027000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 383, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '507028000000', 'PrdImport', 'S', 'Crit: Excel,Formula', 'FrmArtPrf', 'General', '', 384, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509004005001', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 385, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509007505002', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 386, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509007509002', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 387, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509008509003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 388, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '50901500240300', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 389, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '50901650580000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 390, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509022003103', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 391, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509022004003', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 392, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509028005003', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 393, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509035005003', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 394, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509035006003', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 395, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509037007503', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 396, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509050008009', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 397, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509080012504', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 398, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509081012504', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 399, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509095008003', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 400, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509104001002', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 401, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509104001702', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 402, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509104002002', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 403, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509104003702', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 404, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509104004901', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 405, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509107504803', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 406, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509107505804', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 407, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509108501903', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 408, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509111020003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 409, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '509115002403', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 410, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '51501250500300', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 411, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '530037000003', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 412, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '530040010003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 413, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '530070010003', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 414, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '530075010003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 415, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '530080010003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 416, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '530085000005', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 417, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '530110010003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 418, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '530125010003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 419, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '530165010003', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 420, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '545515002000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 421, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '54600000000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 422, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '555001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 423, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '556001000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 424, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '557002000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 425, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '557003000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 426, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '558001000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 427, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '558004000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 428, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '560002000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 429, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '560004000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 430, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '564001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 431, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '564004010000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 432, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '564006000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 433, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '564007000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 434, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '564009000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 435, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568000338400', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 436, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568000338430', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 437, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568010010000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 438, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568010020000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 439, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568010030000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 440, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568010040000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 441, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568010050000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 442, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568010060000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 443, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568010070000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 444, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568014000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 445, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568014100000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 446, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568015000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 447, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568016000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 448, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568017000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 449, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568026018000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 450, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568027001100', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 451, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568027001200', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 452, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568028000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 453, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568030011000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 454, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568030012000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 455, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568030030000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 456, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568030040000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 457, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568030050000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 458, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568030100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 459, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568030110000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 460, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568030120000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 461, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568035009000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 462, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568035010000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 463, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568035012000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 464, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568035013000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 465, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568040000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 466, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568043000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 467, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568044000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 468, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568045000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 469, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568047012000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 470, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568047014000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 471, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568047015000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 472, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568047016000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 473, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568047022000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 474, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568047026000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 475, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568047027000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 476, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568047028000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 477, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568048000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 478, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568048287005', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 479, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568048287006', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 480, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568048290100', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 481, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568048290110', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 482, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568048290120', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 483, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568070015000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 484, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568070021000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 485, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568070025000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 486, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568080000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 487, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568081000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 488, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568090000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 489, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568090010000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 490, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568090020000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 491, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568090030000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 492, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568090040000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 493, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568090050000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 494, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568090060000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 495, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568090100000', 'PrdImport', 'S', 'Crit: Foreign,ConsuProd', 'FrmArtPrf', 'General', '', 496, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568091000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 497, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568094000000', 'PrdImport', 'S', 'Crit: Foreign,ConsuProd', 'FrmArtPrf', 'General', '', 498, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568096000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 499, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568097000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 500, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568099000000', 'PrdImport', 'S', 'Crit: Foreign,ConsuProd', 'FrmArtPrf', 'General', '', 501, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568101000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 502, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568170000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 503, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568170100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 504, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568170200000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 505, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568170300000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 506, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568170400000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 507, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568180000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 508, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568180100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 509, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568180110000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 510, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568180120000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 511, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568180130000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 512, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568190000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 513, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568190100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 514, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568190200000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 515, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568190300000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 516, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568190400000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 517, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568190500000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 518, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568191000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 519, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568200000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 520, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568200100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 521, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568200110000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 522, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568300001000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 523, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568300001100', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 524, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568300001200', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 525, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568400150000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 526, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568400200000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 527, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568400260000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 528, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568400330000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 529, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568400430000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 530, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '568400560000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 531, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '572000000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 532, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '572010000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 533, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '572020000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 534, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '572041000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 535, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '572050010000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 536, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '572050020000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 537, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '573030000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 538, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '573041000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 539, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576030000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 540, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576035000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 541, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576040000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 542, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576050000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 543, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576070000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 544, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576071000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 545, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576080000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 546, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576081000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 547, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576090000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 548, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576091000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 549, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576092000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 550, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576100000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 551, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576110000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 552, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576111000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 553, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576130000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 554, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576160000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 555, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576170000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 556, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576181000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 557, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576190000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 558, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '576310000000', 'PrdImport', 'S', 'Crit: Formula', 'FrmArtPrf', 'General', '', 559, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '577011000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 560, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '590187034000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 561, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '592096476500', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 562, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '592096476600', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 563, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '592097262500', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 564, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '595006000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 565, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '595007000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 566, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '595013000000', 'PrdImport', 'S', 'Crit: StockMin,Formula', 'FrmArtPrf', 'General', '', 567, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '595014000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 568, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '595015000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 569, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '595017000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 570, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '595019000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 571, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '610002000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 572, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '610060000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 573, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '613001000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 574, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620008000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 575, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620011000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 576, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620013000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 577, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620014000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 578, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620016000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 579, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620017000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 580, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620018000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 581, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620023000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 582, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620024000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 583, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620027000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 584, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620031000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 585, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620038000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 586, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '620039000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 587, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '621005000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 588, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '621007000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 589, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '621009000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 590, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '622002000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 591, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '625003000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 592, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '625004000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 593, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '625006000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 594, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '625007000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 595, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '625010000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 596, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '625011000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 597, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '625012000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 598, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '625015000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 599, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '626027020000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 600, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '631031000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 601, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '633002100000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 602, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '633007000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 603, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '633008000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 604, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '633009000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 605, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '633013000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 606, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '633013000001', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 607, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '633030000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 608, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '635001310300', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 609, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '636004000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 610, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '636005100000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 611, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '636070035000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 612, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '636100052000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 613, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640000000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 614, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 615, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640003000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 616, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640009000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 617, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640011000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 618, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640012000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 619, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640013000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 620, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640015000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 621, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640016000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 622, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640016110000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 623, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640020000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 624, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '640021000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 625, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '650001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 626, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 627, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651002000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 628, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651003000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 629, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651004000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 630, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651005000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 631, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651008100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 632, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651008200000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 633, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651015010000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 634, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651015020000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 635, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651015040000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 636, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651018000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 637, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651019000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 638, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651019100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 639, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651020000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 640, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651021000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 641, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '651022000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 642, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '652001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 643, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '652002000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 644, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '652006000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 645, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '652006100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 646, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '652006200000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 647, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '653003000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 648, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '653004000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 649, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '653006000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 650, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '653008000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 651, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '653009000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 652, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '653013000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 653, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '653015000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 654, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '653017000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 655, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '655001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 656, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '655001010000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 657, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '655002000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 658, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '655002010000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 659, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '657400000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 660, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '661000000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 661, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '661001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 662, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '661012000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 663, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '661013000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 664, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '661014000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 665, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662003300000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 666, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662004000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 667, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662004100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 668, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662004200000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 669, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662004300000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 670, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662005000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 671, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662005100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 672, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662005200000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 673, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662005300000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 674, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662006000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 675, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662006100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 676, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662006200000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 677, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662006300000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 678, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662007000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 679, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662007300000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 680, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662008000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 681, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662009200000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 682, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '662009300000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 683, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '664008000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 684, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '670001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 685, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '670002000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 686, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '670010100000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 687, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '670015000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 688, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '670015060000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 689, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '670016100000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 690, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '680001000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 691, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '680003000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 692, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '685002000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 693, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '685008000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 694, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '685011000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 695, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '691003001000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 696, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '691003002000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 697, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '711460097401', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 698, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '711460135401', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 699, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '711460135402', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 700, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '711460138401', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 701, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '711460138402', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 702, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '711818650011', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 703, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '719009505305', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 704, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '719784402410', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 705, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '719785010000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 706, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '744366644010', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 707, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '744615104010', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 708, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '744615184019', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 709, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '747075814720', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 710, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '747142714720', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 711, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '748188634720', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 712, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '748197844720', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 713, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '748197854720', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 714, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '778301010200', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 715, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '779633207541', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 716, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '781861121032', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 717, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '781865000020', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 718, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '781865200020', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 719, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '781866101481', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 720, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '781881760000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 721, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '785461221000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 722, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 723, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000118', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 724, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000169', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 725, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000186', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 726, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000205', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 727, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000211', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 728, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000212', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 729, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000213', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 730, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000217', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 731, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000224', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 732, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000260', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 733, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000292', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 734, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000293', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 735, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000295', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 736, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000302', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 737, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000321', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 738, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000342', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 739, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000346', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 740, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000350', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 741, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000352', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 742, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000357', 'PrdImport', 'S', 'Crit: Excel,StockMin,Formula', 'FrmArtPrf', 'General', '', 743, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000407', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 744, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000408', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 745, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000409', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 746, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000411', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 747, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000412', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 748, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000414', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 749, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000415', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 750, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000417', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 751, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000418', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 752, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000419', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 753, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000420', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 754, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000421', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 755, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000422', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 756, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000423', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 757, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000424', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 758, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000426', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 759, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000427', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 760, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000428', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 761, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000430', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 762, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000431', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 763, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000432', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 764, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000433', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 765, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000434', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 766, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000435', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 767, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000436', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 768, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000437', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 769, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000438', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 770, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000439', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 771, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000463', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 772, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000480', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 773, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000519', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 774, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000556', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 775, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000611', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 776, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000614', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 777, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000617', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 778, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000620', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 779, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000657', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 780, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000668', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 781, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000669', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 782, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000675', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 783, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000676', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 784, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000677', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 785, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000679', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 786, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000683', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 787, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000684', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 788, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000754', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 789, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000784', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 790, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000785', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 791, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000812', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 792, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000813', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 793, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000814', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 794, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000816', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 795, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000841', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 796, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000848', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 797, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000853', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 798, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000900', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 799, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000901', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 800, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000903', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 801, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000906', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 802, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000907', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 803, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000908', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 804, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000909', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 805, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000910', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 806, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000911', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 807, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000912', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 808, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000913', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 809, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000914', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 810, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000915', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 811, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000916', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 812, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000918', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 813, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000919', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 814, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000978', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 815, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000982', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 816, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000988', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 817, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000996', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 818, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000000997', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 819, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001001', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 820, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001003', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 821, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001007', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 822, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001010', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 823, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001011', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 824, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001013', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 825, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001016', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 826, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001026', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 827, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001042', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 828, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001043', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 829, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001044', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 830, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001049', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 831, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001050', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 832, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001068', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 833, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001071', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 834, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001076', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 835, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001077', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 836, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001078', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 837, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001079', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 838, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001080', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 839, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001081', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 840, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001102', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 841, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001112', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 842, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001113', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 843, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001121', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 844, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001132', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 845, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001135', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 846, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001178', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 847, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001196', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 848, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001202', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 849, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001204', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 850, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001209', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 851, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001216', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 852, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001228', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 853, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001229', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 854, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001230', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 855, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001231', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 856, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001232', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 857, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001234', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 858, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001242', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 859, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001243', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 860, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001258', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 861, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001270', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 862, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001284', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 863, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001288', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 864, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001297', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 865, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001299', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 866, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001301', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 867, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001305', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 868, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001306', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 869, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001307', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 870, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001315', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 871, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001316', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 872, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001320', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 873, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001321', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 874, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001330', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 875, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001331', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 876, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001332', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 877, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001337', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 878, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001338', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 879, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001341', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 880, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001342', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 881, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001345', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 882, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001346', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 883, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001347', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 884, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001363', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 885, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001395', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 886, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001396', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 887, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001402', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 888, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001406', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 889, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001408', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 890, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001419', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 891, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001466', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 892, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001473', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 893, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001474', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 894, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001475', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 895, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001478', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 896, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001479', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 897, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001480', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 898, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001481', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 899, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001533', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 900, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001537', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 901, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001538', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 902, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001558', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 903, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001566', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 904, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001567', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 905, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001571', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 906, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001575', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 907, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001580', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 908, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001587', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 909, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001588', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 910, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001590', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 911, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001591', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 912, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001592', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 913, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001593', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 914, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001594', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 915, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001595', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 916, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001596', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 917, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001597', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 918, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001598', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 919, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001599', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 920, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001625', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 921, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001632', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 922, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001633', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 923, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001634', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 924, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001635', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 925, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001638', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 926, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001639', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 927, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001643', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 928, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001710', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 929, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001711', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 930, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001712', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 931, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001836', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 932, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001838', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 933, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001839', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 934, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001842', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 935, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001849', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 936, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001855', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 937, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001858', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 938, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001875', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 939, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001876', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 940, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001878', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 941, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001895', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 942, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001902', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 943, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001903', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 944, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001904', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 945, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000001905', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 946, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002120', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 947, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002122', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 948, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002123', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 949, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002124', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 950, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002135', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 951, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002137', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 952, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002138', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 953, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002180', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 954, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002182', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 955, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002185', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 956, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002190', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 957, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002193', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 958, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002194', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 959, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002195', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 960, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002196', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 961, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002198', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 962, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002199', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 963, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002200', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 964, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002202', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 965, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002203', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 966, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002204', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 967, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002205', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 968, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002206', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 969, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002207', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 970, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002208', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 971, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002209', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 972, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002210', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 973, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002211', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 974, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002213', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 975, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002215', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 976, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002217', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 977, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002219', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 978, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002221', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 979, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002222', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 980, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002223', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 981, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002224', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 982, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002225', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 983, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002226', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 984, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002227', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 985, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002228', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 986, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002229', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 987, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002230', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 988, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002231', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 989, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002232', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 990, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002233', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 991, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002234', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 992, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002235', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 993, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002236', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 994, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002237', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 995, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002238', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 996, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002239', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 997, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002240', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 998, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002241', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 999, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002242', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1000, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002243', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1001, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002244', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1002, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002245', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1003, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002246', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1004, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002247', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1005, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002248', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1006, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002250', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1007, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002265', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1008, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002267', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1009, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000002269', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1010, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000008995', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1011, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000010129', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1012, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000210129', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1013, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000901146', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1014, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000901575', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1015, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000901576', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1016, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000901620', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1017, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000901652', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1018, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000901658', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1019, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000901659', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1020, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000901779', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1021, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000901826', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1022, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000901827', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1023, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000903993', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1024, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000908957', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1025, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000908978', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1026, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000908981', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1027, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000908984', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1028, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000908988', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1029, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000908990', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1030, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000910624', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1031, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000910905', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1032, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800000910908', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1033, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800005206634', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1034, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800007705204', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1035, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800007705206', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1036, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800008711661', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1037, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800008714991', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1038, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800008718030', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1039, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800009921030', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 1040, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034501789', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1041, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034501797', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1042, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034501827', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1043, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034502351', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1044, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034502360', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1045, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034502440', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1046, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034503447', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1047, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034505415', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1048, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034505571', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1049, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034505784', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1050, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034505822', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1051, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034506349', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1052, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034506594', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1053, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034506608', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1054, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034506632', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1055, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034506667', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1056, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034506683', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1057, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034520872', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1058, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034520880', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1059, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034520910', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1060, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034520929', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1061, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034520937', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1062, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034520945', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1063, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034520988', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1064, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034520996', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1065, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521003', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1066, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521037', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1067, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521039', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1068, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521041', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1069, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521055', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1070, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521116', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1071, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521305', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1072, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521313', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1073, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521321', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1074, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521380', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1075, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521440', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1076, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521441', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1077, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521470', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1078, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521550', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1079, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521569', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1080, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034521593', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1081, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1082, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522004', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1083, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522011', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1084, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522013', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1085, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522014', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1086, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522015', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1087, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522017', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1088, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522018', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1089, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522101', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1090, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522103', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1091, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522104', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1092, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522105', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1093, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522106', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1094, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522108', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1095, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522110', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1096, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522113', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1097, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522114', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1098, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522122', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1099, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522166', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1100, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522204', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1101, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522207', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1102, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522208', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1103, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522210', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1104, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522280', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1105, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522281', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1106, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522282', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1107, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034522285', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1108, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523001', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1109, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523002', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1110, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523100', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1111, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523116', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1112, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523142', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1113, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523143', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1114, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523144', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1115, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523151', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1116, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523180', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1117, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523183', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1118, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523185', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1119, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523191', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1120, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034523292', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1121, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034770025', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1122, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034772302', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1123, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034772305', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1124, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034773103', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1125, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034773106', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1126, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774002', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1127, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774270', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1128, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774355', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1129, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774385', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1130, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774386', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1131, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774501', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1132, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774502', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1133, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774503', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1134, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774504', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1135, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774505', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1136, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774507', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1137, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774508', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1138, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774509', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1139, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800034774510', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1140, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800040024912', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1141, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800040024913', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1142, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '800054502424', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1143, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '80034520856A', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1144, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '801838000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin', 'FrmArtPrf', 'General', '', 1145, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '809110000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1146, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '809150000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1147, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '809220000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1148, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '810070000220', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1149, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '811300000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1150, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '811752000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1151, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '811753000000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 1152, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '811754000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1153, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '811754000200', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1154, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '811754018200', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 1155, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '812222000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1156, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '812222001000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 1157, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '824009000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1158, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '824011000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1159, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '824012000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1160, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '824013000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1161, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '824014000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1162, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '832206000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 1163, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '832207000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 1164, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '832248000000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 1165, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '84100160800000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 1166, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '84100160900000', 'PrdImport', 'S', 'Crit: Excel', 'FrmArtPrf', 'General', '', 1167, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '841167000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1168, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '841168000000', 'PrdImport', 'S', 'Crit: Excel,Foreign', 'FrmArtPrf', 'General', '', 1169, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '854020200000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 1170, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '854020300000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1171, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '859021000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1172, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '859051000000', 'PrdImport', 'S', 'Crit: Excel,Foreign,StockMin,Formula', 'FrmArtPrf', 'General', '', 1173, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '859300000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1174, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001100008', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1175, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001100010', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1176, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001100206', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1177, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001200012', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1178, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001200014', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1179, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001200016', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1180, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001200018', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1181, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001200020', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1182, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001200022', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1183, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001200024', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1184, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001300016', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1185, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001300018', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1186, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001300020', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1187, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001300022', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1188, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871001300024', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1189, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871004100012', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1190, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871004100014', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1191, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871004100016', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1192, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871004100018', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1193, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871004100020', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1194, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871004100022', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1195, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871004100024', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1196, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871005050008', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1197, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871006050010', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1198, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871007300016', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1199, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871007300018', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1200, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871007300020', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1201, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871007300022', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1202, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871007300024', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1203, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871008000800', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1204, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871008001000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1205, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871008001400', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1206, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871100220600', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1207, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '871100230600', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1208, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896502022500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1209, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896502023000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1210, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896502023500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1211, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896502024000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1212, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896502024500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1213, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896502025500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1214, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896502026000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1215, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896502026500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1216, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896502027000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1217, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896502027500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1218, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503003000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1219, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503103000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1220, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503104000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1221, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503104500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1222, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503105000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1223, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503105500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1224, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503106000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1225, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503106500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1226, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503107000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1227, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503107500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1228, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503108000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1229, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '896503108500', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1230, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '911060000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1231, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '919092200000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1232, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '919093200000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1233, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '919099120000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1234, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '919099130000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1235, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '919099280000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1236, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '920003000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1237, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '921011000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1238, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '921012000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1239, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '921022000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1240, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '921024000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1241, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '930001050000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1242, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '930007500000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1243, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931001010000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 1244, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931005000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1245, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931005100000', 'PrdImport', 'S', 'Crit: Excel,StockMin', 'FrmArtPrf', 'General', '', 1246, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931005800000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1247, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931005900000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1248, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931006000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1249, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931006100000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1250, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931007000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1251, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931012000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1252, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931013000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1253, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931014001000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1254, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931014002000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1255, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931014005000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1256, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931014008576', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1257, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931016000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1258, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931017000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1259, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931018000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1260, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '931019000000', 'PrdImport', 'S', 'Crit: StockMin', 'FrmArtPrf', 'General', '', 1261, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940003000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 1262, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940017000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1263, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940018000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 1264, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940019000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 1265, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940020000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 1266, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940021000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin', 'FrmArtPrf', 'General', '', 1267, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940022000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 1268, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940023000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 1269, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940024000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 1270, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940025000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 1271, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940026000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 1272, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '940027000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin,ConsuProd', 'FrmArtPrf', 'General', '', 1273, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '980003000000', 'PrdImport', 'S', 'Crit: Foreign,StockMin,RepStkMin', 'FrmArtPrf', 'General', '', 1274, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');
INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)
VALUES ('EPSA', '980004000000', 'PrdImport', 'S', 'Crit: Foreign', 'FrmArtPrf', 'General', '', 1275, 'batch', '2026-05-27', 'SRV', 'alta_batch', 'A');

COMMIT;

-- Verify
SELECT COUNT(*) AS TotalInserted FROM articulo_perfil_compra WHERE cod_emp = 'EPSA' AND perfil_compra_id = 'PrdImport' AND activo = 'S';