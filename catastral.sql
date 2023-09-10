--- Inicio rama catastral ------

--- Cálculo de área en hectareas para cada predio reportado por el IGAC

ALTER TABLE catastro_rural_valle ADD COLUMN area_has double precision;

UPDATE catastro_rural_valle SET area_has = (ST_Area(catastro_rural_valle.geom)/10000.0);

-- Segmentación por Municipio de los predios rurales reportados por el IGAC ----

ALTER TABLE catastro_rural_valle ADD COLUMN nomb_municipio varchar(80);

UPDATE catastro_rural_valle SET nomb_municipio = municipios_valle.mpio_cnmbr FROM municipios_valle
WHERE catastro_rural_valle.codigo_mun = municipios_valle.mpio_ccdgo;

--- Cálculo de área total en hectareas por Municipio de predios rurales reportados por el IGAC --- 
SELECT nomb_municipio AS municipio, SUM(area_has) AS area_has, COUNT(DISTINCT id) AS num_predios,
MIN(area_has) AS area_minima_has, MAX(area_has) AS area_maxima_has
FROM catastro_rural_valle
GROUP BY nomb_municipio ORDER BY area_has DESC, num_predios, area_minima_has, area_maxima_has;

--- Cálculo de área total en hectareas de predios rurales por categoria de destinación económica ---

SELECT destino_ec, SUM(area_has) AS area_total_has, COUNT(DISTINCT id) AS num_predios
FROM catastro_rural_valle GROUP BY destino_ec ORDER BY area_total_has DESC, num_predios;

--- Cálculo de área total en hectáreas de predios rurales reportados con destinación económica Agropecuario
--- para cada municipio del departamento del Valle del Cauca. ---

SELECT nomb_municipio, SUM(area_has) AS area_has, COUNT(DISTINCT id) AS num_predios_agro,
MIN(area_has) AS area_minima_pred_agro, MAX(area_has) AS area_maxima_pred_agro
FROM catastro_rural_valle WHERE destino_ec = 'D' 
GROUP BY nomb_municipio ORDER BY area_has DESC, num_predios_agro, area_minima_pred_agro, area_maxima_pred_agro;

--- Cálculo de área total en hectáreas de predios rurales con destinación económica agropecuario 
--- por cada categoría de fertilidad de suelos definida por la Corporación Autónoma Regional del Valle del Cauca CVC 
--- para cada municipio del departamento.

--- Fertilidad de suelos Muy Alta, Alta, Moderada, Baja y Muy Baja ---
SELECT nomb_municipio, (SUM(ST_Area(ST_Intersection(ecosistema_suelos_resumido.geom, catastro_rural_valle.geom)))/10000.0)
AS area_pred_fert_muy_baja FROM ecosistema_suelos_resumido, catastro_rural_valle 
WHERE ST_Intersects(ecosistema_suelos_resumido.geom, catastro_rural_valle.geom) AND
catastro_rural_valle.destino_ec = 'D' AND ecosistema_suelos_resumido.fertilidad = 'MB'
GROUP BY nomb_municipio ORDER BY area_pred_fert_muy_baja DESC;

