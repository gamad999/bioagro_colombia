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