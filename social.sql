-- Inicio de rama social

--- Calculo de áreas de secciones rurales en hectareas ----

ALTER TABLE seccion_rural ADD COLUMN area_has double precision;

UPDATE seccion_rural SET area_has = (ST_Area(seccion_rural.geom) / 10000);

--- Segmentación geografica de secciones rurales por Municipio ----

ALTER TABLE seccion_rural ADD COLUMN municipio varchar(40);

UPDATE seccion_rural SET municipio = municipios_valle.mpio_cnmbr FROM municipios_valle
WHERE seccion_rural.mpio_cdpmp = municipios_valle.mpio_ccdgo;

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

--- Ajuste de nombres de variables de la capa de secciones rurales para facilitar 
--- su interpretación por parte de los usuarios ----

--- Creación de campos con nombres estandar de facil interpretación ---

ALTER TABLE seccion_rural ADD COLUMN viviendas int, ADD COLUMN hogaress int,
ADD COLUMN pob_total int, ADD COLUMN pob_homb int, ADD COLUMN pob_mujr int,
ADD COLUMN pb_ed0_9 int, ADD COLUMN pb_ed10_19 int, ADD COLUMN pb_ed20_29 int,
ADD COLUMN pb_ed30_39 int, ADD COLUMN pb_ed40_49 int, ADD COLUMN pb_ed50_59 int,
ADD COLUMN pb_ed60_69 int, ADD COLUMN pb_ed70_79 int, ADD COLUMN pb_ed80 int, 
ADD COLUMN nv_prim int, ADD COLUMN nv_secund int, ADD COLUMN nv_profes int,
ADD COLUMN nv_postgrd int, ADD COLUMN nv_ninguno int, ADD COLUMN undmx_agro int,
ADD COLUMN unid_agro int, ADD COLUMN vvsn_acue int, ADD COLUMN vvsn_alct int,
ADD COLUMN vvsn_gas int, ADD COLUMN vvsn_rcbas int, ADD COLUMN vvsn_inter int;

