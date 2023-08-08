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
