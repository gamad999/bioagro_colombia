--- Inicio rama catastral ------

--- Cálculo de área en hectareas para cada predio reportado por el IGAC

ALTER TABLE catastro_rural_valle ADD COLUMN area_has double precision;

UPDATE catastro_rural_valle SET area_has = (ST_Area(catastro_rural_valle.geom)/10000.0);

-- Segmentación por Municipio de los predios rurales reportados por el IGAC ----

ALTER TABLE catastro_rural_valle ADD COLUMN nomb_municipio varchar(80);

UPDATE catastro_rural_valle SET nomb_municipio = municipios_valle.mpio_cnmbr FROM municipios_valle
WHERE catastro_rural_valle.codigo_mun = municipios_valle.mpio_ccdgo;