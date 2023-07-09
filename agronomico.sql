--- Inicio rama agronómico ---

--- Constucción de tabla de generos de orquideas en el Valle del Cauca segun GBIF ----

SELECT genus AS genero, COUNT(DISTINCT species) AS especies, COUNT(DISTINCT id) AS registros
FROM orquideas_valle GROUP BY genero ORDER BY especies DESC, registros;

-- Construccion de tabla de especies de orquideas presentes en el Valle del Cauca segun GBIF

SELECT species AS especies, COUNT(DISTINCT id) AS registros, MIN(year) AS min_year,
MAX(year) AS max_year
FROM orquideas_valle GROUP BY especies ORDER BY registros DESC, min_year, max_year;