-- Inicio de rama social

--- Calculo de áreas de secciones rurales en hectareas ----

ALTER TABLE seccion_rural ADD COLUMN area_has double precision;

UPDATE seccion_rural SET area_has = (ST_Area(seccion_rural.geom) / 10000);

--- Segmentación geografica de secciones rurales por Municipio ----

ALTER TABLE seccion_rural ADD COLUMN municipio varchar(40);

UPDATE seccion_rural SET municipio = municipios_valle.mpio_cnmbr FROM municipios_valle
WHERE ST_Intersects(seccion_rural.geom, municipios_valle.geom);





