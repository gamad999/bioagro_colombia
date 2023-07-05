-- Inicio de rama social

--- Calculo de áreas de secciones rurales en hectareas ----

ALTER TABLE seccion_rural ADD COLUMN area_has double precision;

UPDATE seccion_rural SET area_has = (ST_Area(seccion_rural.geom) / 10000);

--- Segmentación geografica de secciones rurales por Municipio ----

ALTER TABLE seccion_rural ADD COLUMN municipio varchar(40);

UPDATE seccion_rural SET municipio = municipios_valle.mpio_cnmbr FROM municipios_valle
WHERE ST_Intersects(seccion_rural.geom, municipios_valle.geom);

--- Construccion de tabla de población rural por Municipio de acuerdo a datos de secciones rurales Censo 2018 ---

SELECT municipio, SUM(stp27_pers) AS pob_rural FROM seccion_rural
GROUP BY municipio ORDER BY pob_rural DESC;

-- Construccion de tabla de numero de hogares comandados por mujeres por municipio ----

SELECT municipio, SUM(jef_mujr) AS HogJfMujr FROM seccion_rural
GROUP BY municipio ORDER BY HogJfMujr DESC;

--- Construcción de tabla de número de hogares rurales en loa cuales reside por lo menos una persona con limitaciones
--- físicas a nivel de Municipios 

SELECT municipio, SUM(persconlim) AS PersLimit FROM seccion_rural
GROUP BY municipio ORDER BY PersLimit DESC;





