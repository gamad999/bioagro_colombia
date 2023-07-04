-- Inicio de rama social

--- Calculo de áreas de secciones rurales en hectareas ----

ALTER TABLE seccion_rural ADD COLUMN area_has double precision;

UPDATE seccion_rural SET area_has = (ST_Area(seccion_rural.geom) / 10000);