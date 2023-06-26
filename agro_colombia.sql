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

