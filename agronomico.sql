--- Inicio rama agronómico ---

--- Constucción de tabla de generos de orquideas en el Valle del Cauca segun GBIF ----

SELECT genus AS genero, COUNT(DISTINCT species) AS especies, COUNT(DISTINCT id) AS registros
FROM orquideas_valle GROUP BY genero ORDER BY especies DESC, registros;