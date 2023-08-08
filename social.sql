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

--- Calculo de indicadores de población en edad productiva (20 a 49 años) ---
--- población menor de edad (0 a 19 años) y población adulto mayor (50 o mas años)

ALTER TABLE seccion_rural ADD COLUMN pob_ed_prod int, ADD COLUMN pob_menor int,
ADD COLUMN pob_adult_may int;

UPDATE seccion_rural SET pob_ed_prod = pb_ed20_29 + pb_ed30_39 + pb_ed40_49;
UPDATE seccion_rural SET pob_menor = pb_ed0_9 + pb_ed10_19;
UPDATE seccion_rural SET pob_adult_may = pb_ed50_59 + pb_ed60_69 + pb_ed70_79 + pb_ed80;

--- Construccion de tablas de indicadores estadisticos por municipios y secciones rurales
--- Estadisticas de población en edad productiva por municipio

SELECT municipio, SUM(pob_ed_prod) AS pob_ed_productiva, SUM(pob_total) AS pob_total, 
SUM(pob_ed_prod)*1.0/SUM(pob_total) * 100.0 AS porc
FROM seccion_rural GROUP BY municipio ORDER BY pob_ed_productiva DESC, pob_total, porc;

--- Estadísticas de nivel educativo de población rural por Municipio

SELECT municipio, SUM(nv_prim) AS primaria, SUM(nv_secund) AS secundaria, SUM(nv_profes) AS profesional,
SUM(nv_postgrd) AS postgrado, SUM(nv_ninguno) AS ninguno FROM seccion_rural
GROUP BY municipio ORDER BY primaria DESC, secundaria , profesional, postgrado, ninguno;

--- Estadisticas de unidades mixtas y predios con usos agropecuario, agroindustrial o forestal por Municipio

SELECT municipio, SUM(undmx_agro) AS unid_mx_agro, SUM(unid_agro) AS predios_agro
FROM seccion_rural GROUP BY municipio ORDER BY predios_agro DESC, unid_mx_agro;

--- Estadisticas de numero de viviendas rurales sin servicio de acueducto ---

SELECT municipio, SUM(vvsn_acue) AS vvsn_acue, SUM(viviendas) AS tot_viviendas, 
(SUM(vvsn_acue)*1.0/SUM(viviendas))*100.0 AS porc FROM seccion_rural
GROUP BY municipio ORDER BY vvsn_acue DESC, tot_viviendas, porc;

--- Estadísticas de número de viviendas rurales sin servicio de alcantarillado ----

SELECT municipio, SUM(vvsn_alct) AS vvsn_alct, SUM(viviendas) AS tot_viviendas,
(SUM(vvsn_alct)*1.0/SUM(viviendas))*100.0 AS porc FROM seccion_rural
GROUP BY municipio ORDER BY vvsn_alct DESC, tot_viviendas, porc;

--- Estadísticas de número de viviendas rurales sin servicio de gas natural conectado a la red pública ---













