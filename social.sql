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

--- Asignación de nombres de facil interpretación a campos de capa de secciones rurales ---

UPDATE seccion_rural SET viviendas = stvivienda; 
UPDATE seccion_rural SET hogaress = tsp16_hog;
UPDATE seccion_rural SET pob_total = stp27_pers;
UPDATE seccion_rural SET pob_homb = stp32_1_se;
UPDATE seccion_rural SET pob_mujr = stp32_2_se;
UPDATE seccion_rural SET pb_ed0_9 = stp34_1_ed;
UPDATE seccion_rural SET pb_ed10_19 = stp34_2_ed;
UPDATE seccion_rural SET pb_ed20_29 = stp34_3_ed;
UPDATE seccion_rural SET pb_ed30_39 = stp34_4_ed;
UPDATE seccion_rural SET pb_ed40_49 = stp34_5_ed;
UPDATE seccion_rural SET pb_ed50_59 = stp34_6_ed;
UPDATE seccion_rural SET pb_ed60_69 = stp34_7_ed;
UPDATE seccion_rural SET pb_ed70_79 = stp34_8_ed;
UPDATE seccion_rural SET pb_ed80 = stp34_9_ed;
UPDATE seccion_rural SET nv_prim = stp51_prim;
UPDATE seccion_rural SET nv_secund = stp51_secu;
UPDATE seccion_rural SET nv_profes = stp51_supe;
UPDATE seccion_rural SET nv_postgrd = stp51_post;
UPDATE seccion_rural SET nv_ninguno = stp51_13_e;
UPDATE seccion_rural SET undmx_agro = stp9_2_4_m;
UPDATE seccion_rural SET unid_agro = stp9_3_4_n;
UPDATE seccion_rural SET vvsn_acue = stp19_acu2;
UPDATE seccion_rural SET vvsn_alct = stp19_alc2;
UPDATE seccion_rural SET vvsn_gas = stp19_gas2;
UPDATE seccion_rural SET vvsn_rcbas = stp19_rec2;
UPDATE seccion_rural SET vvsn_inter = stp19_int2;


















