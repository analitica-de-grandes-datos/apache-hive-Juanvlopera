/*

Pregunta
===========================================================================

Escriba una consulta que compute la cantidad de registros por letra de la 
columna 2 y clave de la columna 3 esto es, por ejemplo, la cantidad de 
registros en tienen la letra `a` en la columna 2 y la clave `aaa` en la 
columna 3 es:

    a    aaa    5

Apache Hive se ejecutará en modo local (sin HDFS).

Escriba el resultado a la carpeta `output` de directorio de trabajo.

*/

DROP TABLE IF EXISTS t0;
CREATE TABLE t0 (
    c1 STRING,
    c2 ARRAY<CHAR(1)>, 
    c3 MAP<STRING, INT>
    )
    ROW FORMAT DELIMITED 
        FIELDS TERMINATED BY '\t'
        COLLECTION ITEMS TERMINATED BY ','
        MAP KEYS TERMINATED BY '#'
        LINES TERMINATED BY '\n';
LOAD DATA LOCAL INPATH 'data.tsv' INTO TABLE t0;

/*
    >>> Escriba su respuesta a partir de este punto <<<
*/

DROP TABLE IF EXISTS solution;
CREATE TABLE solution
AS SELECT letra,letras FROM (SELECT c2,letras FROM t0 LATERAL VIEW explode(map_keys(c3)) t0 AS letras) t1 LATERAL VIEW explode(c2) t1 AS letra;
INSERT OVERWRITE LOCAL DIRECTORY 'output' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' SELECT letra,letras,count(letras) FROM solution GROUP BY letra,letras;