USE transactions;
/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 1
En esta consulta se listan las operaciones realizadas por empresas en Alemania, se han tenido en cuenta todas las transacciones tanto efectivas como no.
La consulta genera una tabla con 118 registros (transacciones)*/
SELECT c.company_name AS Company, t.id AS Transaction_ID, t.Amount, t.timestamp AS Date, t.Declined, c.Country 
FROM transaction t
JOIN company c on t.company_id = c.id
WHERE country IN ('Germany');

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 2
Se solicita un listado de empresas que han realizado transacciones por encima de la media general, 
se han tenido en cuenta solo las transacciones efectivamente realizadas, se genera una tabla con 50 registros (empresas).*/
SELECT DISTINCT c.company_name
FROM  transaction t
JOIN  company c ON c.id = t.company_id
WHERE (SELECT AVG(t.amount)
		FROM transaction t) < t.amount AND t.Declined in ("0")
ORDER BY c.company_name;

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 3
Atendiendo al requerimiento y teniendo en cuenta la única pista dada, 
se listan solo las transacciones realizadas por empresas cuyo nombre comienza con la letra "C",
se han tenido en cuenta todas las transacciones, y se muestran en la tabla la fecha de dichas operaciones, 
el monto de las mismas y el id de la operación, datos estos que se consideran relevantes para determinar 
cuáles son los registros faltantes.*/
SELECT c.company_name AS Company_Name, t.id, 
t.Amount, t.timestamp AS Date, t.Declined 
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE Company_Name LIKE "C%";

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 4
Se nos ha solicitado un listado de las empresas que no tienen operaciones registradas para proceder a su eliminación, 
el script de la consulta está diseñado para generar un listado con el nombre de dichas empresas,
sin embargo, se debe resaltar que en la actualidad en la base de datos no existen empresas que cumplan con dicha condición por lo cual
el resultado es un listado sin registros, se ha ordenado para que en caso de generarse registros en el futuro se muestren alfabéticamente.*/
SELECT c.company_name AS COMPANY 
From company c
LEFT JOIN (select t.company_id
			from transaction t) AS t1 on c.id = t1.company_id
WHERE IFNULL(t1.company_id, 0) != c.id
ORDER BY COMPANY;


/*Tarea S2.01. Subconsultas - MySQL
NIVEL 2
EJERCICIO 1
Se nos solicita un listado de transacciones realizadas en el mismo país de origen de la empresa "Non Institute", 
al efecto se ha creado un script que genera dicho listado prescindiendo de las operaciones realizadas por la empresa de referencia
a fin de mostrar solo los datos relevantes.*/
SELECT t.id AS OP_ID, c.company_name AS COMPANY, 
c.Phone, c.Email, c.Website, t.Amount
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE c.country IN (SELECT c.country
					FROM company c
					WHERE c.company_name IN ("Non Institute")) 
	AND c.company_name NOT IN ("Non Institute");


/*Tarea S2.01. Subconsultas - MySQL
NIVEL 2
EJERCICIO 2
Se nos ha solicitado informar el nombre de la empresa que ha realizado la operación con mayor valor en la base de datos,
se ha tenido en cuenta solo las operaciones efectivamente realizadas y como resultado se genera una tabla con un único registro.*/
SELECT c.company_name AS Company, t.Amount
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE t.amount = (SELECT MAX(t.Amount) 
					FROM transaction t 
					WHERE t.declined IN ("0")) 
	AND t.declined IN ("0");


/*Tarea S2.01. Subconsultas - MySQL
NIVEL 3
EJERCICIO 1
Se solicita un listado que informe las ventas medias por país, cuando dicha media sea superior a la media global, 
se han tenido en cuenta solo las operaciones efectivamente realizadas
y como resultado se genera una tabla con 13 registros.*/
SELECT c.Country, format(avg(t.Amount), 2) AS Media
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE t.Amount > (SELECT AVG(t.Amount) 
					FROM transaction t 
					WHERE t.declined IN ("0")) 
	AND t.declined IN ("0")
GROUP BY c.Country
ORDER BY Media;

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 3
EJERCICIO 2
Se solicita un listado donde se especifique las empresas que han realizado mas de 4 transacciones 
y cuales han realizado menos de 4 transacciones, en el script se han tenido en cuenta solo las operaciones efectivamente realizadas,
y se muestran 100 registros.*/
SELECT c.company_name AS Company, 
CASE WHEN count(t.id) >= 4 THEN '4 or more'
ELSE 'Less than 4'
END AS Operations
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE t.declined IN ("0")
GROUP BY Company
ORDER BY Operations;