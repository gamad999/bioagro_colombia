-- Inicio del Proyecto Bio Agro Colombia

-- Creación de extension PostGIS en la base de datos Agro Colombia

CREATE EXTENSION postgis;

--- Enlace espacial entre capas de municipios y municipios clase para migrar nombres de entidades territoriales 
--- a capa de municipios clase

ALTER TABLE municipios_clase_valle ADD COLUMN nombre_munic varchar(80);

UPDATE municipios_clase_valle SET nombre_munic = municipios_valle.mpio_cnmbr FROM municipios_valle
WHERE ST_Intersects(municipios_clase_valle.geom, municipios_valle.geom);

--- Geoprocesamiento de capa de ecosistema suelos del Valle del Cauca ---


								  




