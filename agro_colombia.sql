-- Inicio del Proyecto Bio Agro Colombia

-- Creación de extension PostGIS en la base de datos Agro Colombia

CREATE EXTENSION postgis;

--- Calculo de areas de Municipios en hectareas -----

ALTER TABLE municipios_valle ADD COLUMN area_has double precision;

UPDATE municipios_valle SET area_has = (ST_Area(municipios_valle.geom) / 10000);

--- Segmentacion de Municipios por zona de UGT Valle ---

ALTER TABLE municipios_valle ADD COLUMN zona varchar(40);

UPDATE municipios_valle SET zona = 'Sur' WHERE mpio_cnmbr = 'PALMIRA'

--- Cálculo de areas en hectareas para unidades cartográficas de suelo (ecosistema suelo resumido) ----

ALTER TABLE ecosistema_suelos_resumido ADD COLUMN area_has double precision;

UPDATE ecosistema_suelos_resumido SET area_has = (ST_Area(ecosistema_suelos_resumido.geom) / 10000);

--- Cálculo de estadísticas de fertilidad de suelos por Municipio medidas en hectareas y porcentaje del total municipal ---
--- Prueba de calculo con las funciones ST_Area, ST_Intersection y  ST_Intersects para el cálculo de areas---
--- con fertilidad muy alta por municipio

ALTER TABLE municipios_valle ADD COLUMN fert_muyalta_has double precision,
ADD COLUMN fert_muyalta_porcent double precision, ADD COLUMN fert_alta_has double precision,
ADD COLUMN fert_alta_porcent double precision, ADD COLUMN fert_moder_has double precision,
ADD COLUMN fert_moder_porcent double precision, ADD COLUMN fert_baja_has double precision,
ADD COLUMN fert_baja_porcent double precision, ADD COLUMN fert_muybaja_has double precision,
ADD COLUMN fert_muybaja_porcent double precision;

-- Cálculo de area en hectareas de suelos con fertilidad muy alta por Municipio
UPDATE municipios_valle SET fert_muyalta_has = (SELECT SUM(ST_Area(ST_Intersection(ecosistema_suelos_resumido.geom, municipios_valle.geom))) / 10000
from ecosistema_suelos_resumido WHERE ST_Intersects(ecosistema_suelos_resumido.geom, municipios_valle.geom) AND
ecosistema_suelos_resumido.fertilidad = 'MA');

-- Cálculo de porcentaje de áreas con fertilidad muy alta con respecto a total de cada Municipio

UPDATE municipios_valle SET fert_muyalta_porcent = (fert_muyalta_has / area_has) * 100;

-- Ajuste de valores nulos a cero (0) hectareas ---

UPDATE municipios_valle SET fert_muyalta_has = 0 WHERE fert_muyalta_has IS NULL;
UPDATE municipios_valle SET fert_muyalta_porcent = 0 WHERE fert_muyalta_has = 0;

-- Cálculo de área en hectareas de suelos con fertilidad alta por Municipio ----

UPDATE municipios_valle SET fert_alta_has = (SELECT SUM(ST_Area(ST_Intersection(ecosistema_suelos_resumido.geom, municipios_valle.geom))) / 10000
FROM ecosistema_suelos_resumido WHERE ST_Intersects(ecosistema_suelos_resumido.geom, municipios_valle.geom) AND
ecosistema_suelos_resumido.fertilidad = 'A');

-- Cálculo de porcentaje de áreas de suelo con fertilidad alta con respecto a total de cada Municipio

UPDATE municipios_valle SET fert_alta_porcent = (fert_alta_has / area_has) * 100;

-- Ajuste de valores nulos a cero (0) hectareas ---

UPDATE municipios_valle SET fert_alta_has = 0 WHERE fert_alta_has IS NULL;
UPDATE municipios_valle SET fert_alta_porcent = 0 WHERE fert_alta_has = 0;

-- Cálculo de área en hectareas de suelo con fertilidad moderada por Municipio ----

UPDATE municipios_valle SET fert_moder_has = (SELECT SUM(ST_Area(ST_Intersection(ecosistema_suelos_resumido.geom, municipios_valle.geom))) / 10000
FROM ecosistema_suelos_resumido WHERE ST_Intersects(ecosistema_suelos_resumido.geom, municipios_valle.geom) AND
ecosistema_suelos_resumido.fertilidad = 'M');

-- Cálculo de porcentaje de áreas de suelo con fertilidad moderada con respecto a total de cada Municipio

UPDATE municipios_valle SET fert_moder_porcent = (fert_moder_has / area_has) * 100;

-- Cálculo de áreas en hectareas de suelo con fertilidad baja por Municipio ----

UPDATE municipios_valle SET fert_baja_has = (SELECT SUM(ST_Area(ST_Intersection(ecosistema_suelos_resumido.geom, municipios_valle.geom))) / 10000
FROM ecosistema_suelos_resumido WHERE ST_Intersects(ecosistema_suelos_resumido.geom, municipios_valle.geom) AND
ecosistema_suelos_resumido.fertilidad = 'B');

-- Cálculo de porcentaje en hectareas de suelo con fertilidad baja con respecto a total de cada Municipio

UPDATE municipios_valle SET fert_baja_porcent = (fert_baja_has / area_has) * 100;

-- Ajuste de valores nulos a cero (0) hectareas ---

UPDATE municipios_valle SET fert_baja_has = 0 WHERE fert_baja_has IS NULL;
UPDATE municipios_valle SET fert_baja_porcent = 0 WHERE fert_baja_has = 0;

-- Cálculo de áreas en hectareas de suelo con fertilidad muy baja por Municipio ---

UPDATE municipios_valle SET fert_muybaja_has = (SELECT SUM(ST_Area(ST_Intersection(ecosistema_suelos_resumido.geom, municipios_valle.geom))) / 10000
FROM ecosistema_suelos_resumido WHERE ST_Intersects(ecosistema_suelos_resumido.geom, municipios_valle.geom) AND
ecosistema_suelos_resumido.fertilidad = 'MB');

-- Cálculo de porcentaje en hectareas de suelo con fertilidad muy baja con respecto a total de cada Municipio

UPDATE municipios_valle SET fert_muybaja_porcent = (fert_muybaja_has / area_has) * 100;

-- Ajuste de valores nulos a cero (0) hectareas ---

UPDATE municipios_valle SET fert_muybaja_has = 0 WHERE fert_muybaja_has IS NULL;
UPDATE municipios_valle SET fert_muybaja_porcent = 0 WHERE fert_muybaja_has = 0;

-- Construcción de tabla de resultados de area de suelos en hectareas clasificadas por fertilidad para cada Municipio

SELECT mpio_cnmbr AS municipio, area_has AS area_total, fert_muyalta_has, fert_muyalta_porcent, fert_alta_has, fert_alta_porcent,
fert_moder_has, fert_moder_porcent, fert_baja_has, fert_baja_porcent, fert_muybaja_has, fert_muybaja_porcent
FROM municipios_valle;
