--- Inicio rama agronómico ---

--- Constucción de tabla de generos de orquideas en el Valle del Cauca segun GBIF ----

SELECT genus AS genero, COUNT(DISTINCT species) AS especies, COUNT(DISTINCT id) AS registros
FROM orquideas_valle GROUP BY genero ORDER BY especies DESC, registros;

-- Construccion de tabla de especies de orquideas presentes en el Valle del Cauca segun GBIF

SELECT species AS especies, COUNT(DISTINCT id) AS registros, MIN(year) AS min_year,
MAX(year) AS max_year
FROM orquideas_valle GROUP BY especies ORDER BY registros DESC, min_year, max_year;


--- Construccion de indicadores preliminares de riqueza de especies de orquideas por biomas del bosque seco tropical --

SELECT bioma1996, COUNT(DISTINCT species) AS especies, COUNT(DISTINCT orquideas_valle.id) AS records 
FROM ecosistemas_valle, orquideas_valle WHERE ST_Intersects(ecosistemas_valle.geom, orquideas_valle.geom)
GROUP BY bioma1996 ORDER BY especies DESC, records;


SELECT nom_ecosistema, COUNT(DISTINCT species) AS especies, COUNT(DISTINCT orquideas_valle.id) AS records 
FROM ecosistemas_valle, orquideas_valle WHERE ST_Intersects(ecosistemas_valle.geom, orquideas_valle.geom)
GROUP BY nom_ecosistema ORDER BY especies DESC, records;

--- Inicio desarrollo consulta de biodiversidad forestal Valle del Cauca por secciones rurales ---

ALTER TABLE seccion_rural_forestal ADD COLUMN municipio varchar(80);

UPDATE seccion_rural_forestal SET municipio = seccion_rural.municipio FROM seccion_rural
WHERE seccion_rural_forestal.secr_ccnct = seccion_rural.secr_ccnct;

--- Riqueza de especies protectoras de aguas y riberas por seccion rural y Municipio---

ALTER TABLE seccion_rural_forestal ADD COLUMN riq_prot_agua int, ADD COLUMN rec_prot_agua int;
ALTER TABLE municipios_valle ADD COLUMN riq_prot_agua int, ADD COLUMN rec_prot_agua int;
-- Riqueza de especies ---
UPDATE seccion_rural_forestal SET riq_prot_agua = (SELECT COUNT(DISTINCT species) FROM especies_protectoras_aguas
WHERE ST_Intersects(seccion_rural_forestal.geom, especies_protectoras_aguas.geom));

UPDATE municipios_valle SET riq_prot_agua = (SELECT COUNT(DISTINCT species) FROM especies_protectoras_aguas
WHERE ST_Intersects(municipios_valle.geom, especies_protectoras_aguas.geom));
-- Numero de registros GBIF ---
UPDATE seccion_rural_forestal SET rec_prot_agua = (SELECT COUNT(DISTINCT id) FROM especies_protectoras_aguas
WHERE ST_Intersects(seccion_rural_forestal.geom, especies_protectoras_aguas.geom));

UPDATE municipios_valle SET rec_prot_agua = (SELECT COUNT(DISTINCT id) FROM especies_protectoras_aguas
WHERE ST_Intersects(municipios_valle.geom, especies_protectoras_aguas.geom));
--- Tabla de riqueza de especies y registros por Municipio
SELECT mpio_cnmbr AS municipio, riq_prot_agua AS especies_prot_aguas, rec_prot_agua AS reg_prot_aguas 
FROM municipios_valle ORDER BY riq_prot_agua DESC;
--- Tabla especies protectoras de aguas y riberas ---
SELECT species, COUNT(DISTINCT id) AS reg_gbif FROM especies_protectoras_aguas
GROUP BY species ORDER BY reg_gbif DESC;


