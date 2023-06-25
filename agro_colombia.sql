-- Inicio del Proyecto Bio Agro Colombia

-- Creación de extension PostGIS en la base de datos Agro Colombia

--- Calculo de areas de Municipios en hectareas -----

ALTER TABLE municipios_valle ADD COLUMN area_has double precision;

UPDATE municipios_valle SET area_has = (ST_Area(municipios_valle.geom) / 10000);

--- Segmentacion de Municipios por zona de UGT Valle ---

ALTER TABLE municipios_valle ADD COLUMN zona varchar(40);

UPDATE municipios_valle SET zona = 'Sur' WHERE mpio_cnmbr = 'PALMIRA'

--- Cálculo de areas en hectareas para unidades cartográficas de suelo (ecosistema suelo resumido) ----

ALTER TABLE ecosistema_suelos_resumido ADD COLUMN area_has double precision;

UPDATE ecosistema_suelos_resumido SET area_has = (ST_Area(ecosistema_suelos_resumido.geom) / 10000);


--- Enlace espacial entre capas de municipios y municipios clase para migrar nombres de entidades territoriales 
--- a capa de municipios clase

ALTER TABLE municipios_clase_valle ADD COLUMN nombre_munic varchar(80);

UPDATE municipios_clase_valle SET nombre_munic = municipios_valle.mpio_cnmbr FROM municipios_valle
WHERE ST_Intersects(municipios_clase_valle.geom, municipios_valle.geom);

--- Geoprocesamiento de capa de ecosistema suelos del Valle del Cauca ---

--- Calculo de areas en hectareas ------

ALTER TABLE ecosistema_suelos_valle ADD COLUMN area_has double precision;

UPDATE ecosistema_suelos_valle SET area_has = (SELECT ST_Area(ecosistema_suelos_valle.geom)/10000.0);
								  




