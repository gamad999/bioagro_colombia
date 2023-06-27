SELECT scientific, COUNT(DISTINCT id) AS rec FROM orquideas_valle
GROUP BY scientific ORDER BY rec DESC;