-- ============================================================
-- Cambio manual en EPSA_BI (192.168.2.7)
-- Vista: dbo.vw_Compras_DimArticuloEPSA
-- Motivo: exponer activo_cmp (Nodum ct_articulos) como atributo
--         del articulo para que Compras pueda filtrar articulos
--         inactivos para compras en el reporte Power BI.
-- Requiere: cuenta con ALTER sobre la vista (ejecutar en SSMS).
-- Fecha: 2026-08-18 | Hallazgo: validacion Rosana (opcion B)
-- ============================================================

-- ------------------------------------------------------------
-- PASO 0 (pre-check): situacion actual
-- Deberia dar 3371 articulos, 9 con activo_cmp = 'N'.
-- ------------------------------------------------------------
SELECT COUNT(*) AS total_vista FROM EPSA_BI.dbo.vw_Compras_DimArticuloEPSA;

SELECT ISNULL(a.activo_cmp, '?') AS activo_cmp, COUNT(*) AS cant
FROM EPSA_BI.dbo.vw_Compras_DimArticuloEPSA v
INNER JOIN Nodum.dbo.ct_articulos a
    ON RTRIM(v.cod_articulo) = RTRIM(a.cod_articulo)
GROUP BY a.activo_cmp;

-- ------------------------------------------------------------
-- PASO 1: obtener la definicion actual de la vista
-- En SSMS: Explorador de objetos > EPSA_BI > Vistas >
--   vw_Compras_DimArticuloEPSA > clic derecho >
--   "Modificar" (o Script View as > ALTER To > nueva consulta).
--
-- La vista ya referencia ct_articulos (usa activo_stk en su
-- filtro), por lo que activo_cmp esta al alcance del mismo alias.
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- PASO 2: agregar UNA columna al SELECT de la vista.
-- Buscar en el SELECT el campo activo_stk (del alias que
-- reference ct_articulos, p.ej. a) y agregar junto a el:
--
--     , a.activo_cmp
--
-- Ejecutar el ALTER VIEW.
-- APLICADO 2026-08-18: la vista quedo exponiendo el campo como
-- activo_cmp (mismo criterio de nombres que activo_stk).
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- PASO 3 (verificacion): la vista ya informa el nuevo campo.
-- Esperado: S = 3362, N = 9 (633007000000 entre los N).
-- ------------------------------------------------------------
SELECT ISNULL(activo_cmp, '?') AS activo_cmp, COUNT(*) AS cant
FROM EPSA_BI.dbo.vw_Compras_DimArticuloEPSA
GROUP BY activo_cmp;

SELECT cod_articulo, nom_articulo, activo_cmp
FROM EPSA_BI.dbo.vw_Compras_DimArticuloEPSA
WHERE activo_cmp = 'N';

-- ------------------------------------------------------------
-- PASO 4: avisar para continuar la cadena (staging > SSAS > PBI):
--   scripts/sql/ssas_staging/03b_dimArticulo_add_ActivoCompras.sql
-- ------------------------------------------------------------
