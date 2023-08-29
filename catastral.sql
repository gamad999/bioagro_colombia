--- Inicio rama catastral ------

--- Cálculo de área en hectareas para cada predio reportado por el IGAC

ALTER TABLE catastro_rural_valle ADD COLUMN area_has double precision;

UPDATE catastro_rural_valle SET area_has = (ST_Area(catastro_rural_valle.geom)/10000.0);