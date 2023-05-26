-- Inicio del Proyecto Bio Agro Colombia

-- Creación de extension PostGIS en la base de datos Agro Colombia

CREATE EXTENSION postgis;

-- Creación de referencia a sistema de coordenadas con origen unico para Colombia CTM 12 en la base de datos

INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) 
values ( 9377, 'EPSG', 9377, '+proj=tmerc +lat_0=4 +lon_0=-73 +k=0.9992 +x_0=5000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs', 'PROJCS["MAGNA-SIRGAS / Origen-Nacional",GEOGCS["MAGNA-SIRGAS",DATUM["Marco_Geocentrico_Nacional_de_Referencia",SPHEROID["GRS 1980",6378137,298.257222101],TOWGS84[0,0,0,0,0,0,0]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4686"]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",4],PARAMETER["central_meridian",-73],PARAMETER["scale_factor",0.9992],PARAMETER["false_easting",5000000],PARAMETER["false_northing",2000000],UNIT["metre",1,AUTHORITY["EPSG","9001"]],AUTHORITY["EPSG","9377"]]');

--- Enlace espacial entre capas de municipios y municipios clase para migrar nombres de entidades territoriales 
--- a capa de municipios clase

ALTER TABLE municipios_clase_valle ADD COLUMN nombre_munic varchar(80);

UPDATE municipios_clase_valle SET nombre_munic = municipios_valle.mpio_cnmbr FROM municipios_valle
WHERE ST_Intersects(municipios_clase_valle.geom, municipios_valle.geom);

--- Geoprocesamiento de capa de ecosistema suelos del Valle del Cauca ---

---  Creación de tabla para realizar intersección entre las capas de suelos y municipios ---

CREATE TABLE ecosistema_suelos_valle(
id SERIAL PRIMARY KEY, cod_su2004 varchar(15), bioma1996 varchar(60), bioma2010 varchar(60), 
cod_ecosis varchar(7), nom_ecosis varchar(100), zona varchar(3), anno_eco_e int, anno_eco_a int,
anno_eco_g int, nom_su2004 varchar(60), taxo_2004 varchar(30), piso_ter_e varchar(1), prov_hum_e varchar(2),
cod_perfil varchar(10), clase_unid varchar(2), tipo_estud varchar(2), erosion_es varchar(3), 
pend_estud varchar(10), prof_efect varchar(3), limitante varchar(2), fertilidad varchar(2),
orden_suel varchar(2), gran_grupo varchar(6), subgrupo varchar(15), suborden varchar(3), por_domina int,
grupo_mane int, unidad_uso varchar(8), factor_k double precision, anno_sue_e int, anno_sue_a int,
mpio_cdpmp varchar(5), mpio_clase varchar(22), nombre_munic varchar(50), geom geometry(MultiPolygon, 3115));