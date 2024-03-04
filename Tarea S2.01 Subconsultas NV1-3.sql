/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 1
En esta consulta se listan las operaciones realizadas por empresas en Alemania, se han tenido en cuenta todas las transacciones tanto efectivas como no.
La consulta genera una tabla con 118 registros (transacciones)*/
SELECT company.company_name AS Company, transaction.id AS Transaction_ID, transaction.Amount, transaction.timestamp AS Date, transaction.Declined, company.Country 
FROM transactions.transaction
JOIN company on transaction.company_id = company.id
WHERE country IN ('Germany');

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 2
Se solicita un listado de empresas que han realizado transacciones por encima de la media general, 
se han tenido en cuenta solo las transacciones efectivamente realizadas, se genera una tabla con 256 registros (transacciones).*/
SELECT company.company_name AS Company, transaction.Amount, FORMAT((SELECT AVG(transactions.transaction.amount)
		FROM transactions.transaction), 2) as Media_Global
FROM  transactions.transaction
JOIN  company ON company.id = transaction.company_id
WHERE (SELECT AVG(transactions.transaction.amount)
		FROM transactions.transaction) < transaction.amount AND transactions.transaction.Declined in ("0")
GROUP BY company.company_name, transaction.amount
ORDER BY Amount;

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 3
Atendiendo al requerimiento y teniendo en cuenta la única pista dada, 
se listan solo las transacciones realizadas por empresas cuyo nombre comienza con la letra "C",
se han tenido en cuenta todas las transacciones, y se muestran en la tabla la fecha de dichas operaciones, el monto de las mismas y el id de la operación, 
datos estos que se consideran relevantes para determinar cuáles son los registros faltantes.*/
SELECT transactions.company.company_name AS COMPANY, transactions.transaction.id AS Op_ID, 
transactions.transaction.Amount, transactions.transaction.timestamp AS Date, transactions.transaction.Declined 
FROM transactions.company
JOIN transactions.transaction ON transactions.company.id = transactions.transaction.company_id
WHERE transactions.company.company_name LIKE "C%";

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 4
Se nos ha solicitado un listado de las empresas que no tienen operaciones registradas para proceder a su eliminación, 
el script de la consulta está diseñado para generar un listado con el nombre de dichas empresas,
sin embargo, se debe resaltar que en la actualidad en la base de datos no existen empresas que cumplan con dicha condición por lo cual
el resultado es un listado sin registros.*/
SELECT transactions.company.company_name AS COMPANY 
From transactions.company
LEFT JOIN (select transactions.transaction.company_id
			from transactions.transaction) AS t1 on transactions.company.id = t1.company_id
WHERE IFNULL(t1.company_id, 0) != transactions.company.id
GROUP BY COMPANY;


/*Tarea S2.01. Subconsultas - MySQL
NIVEL 2
EJERCICIO 1
Se nos solicita un listado de transacciones realizadas en el mismo país de origen de la empresa "Non Institute", 
al efecto se ha creado un script que genera dicho listado prescindiendo de las operaciones realizadas por la empresa de referencia
a fin de mostrar solo los datos relevantes.*/
SELECT transactions.transaction.id AS OP_ID, transactions.company.company_name AS COMPANY, 
transactions.company.Phone, transactions.company.Email, transactions.company.Website, transactions.transaction.Amount
FROM transactions.transaction
JOIN transactions.company ON transactions.transaction.company_id = transactions.company.id
WHERE transactions.company.country IN (SELECT transactions.company.country
										FROM transactions.company
										WHERE transactions.company.company_name IN ("Non Institute")) 
                                        AND transactions.company.company_name NOT IN ("Non Institute");


/*Tarea S2.01. Subconsultas - MySQL
NIVEL 2
EJERCICIO 2
Se nos ha solicitado informar el nombre de la empresa que ha realizado la operación con mayor valor en la base de datos,
se ha tenido en cuenta solo las operaciones efectivamente realizadas y como resultado se genera una tabla con un único registro.*/
SELECT transactions.company.company_name AS Company, transactions.transaction.Amount
FROM transactions.company
JOIN transactions.transaction ON transactions.company.id = transactions.transaction.company_id
WHERE transactions.transaction.amount = (SELECT MAX(transactions.transaction.Amount) 
	FROM transactions.transaction 
	WHERE transactions.transaction.declined IN ("0")) and transactions.transaction.declined IN ("0");


/*Tarea S2.01. Subconsultas - MySQL
NIVEL 3
EJERCICIO 1
Se solicita un listado que informe las ventas medias por país, cuando dicha media sea superior a la media global, 
se han tenido en cuenta solo las operaciones efectivamente realizadas
y como resultado se genera una tabla con 13 registros.*/
SELECT transactions.company.Country, format(avg(transactions.transaction.Amount), 2) AS Media
FROM transactions.company
JOIN transactions.transaction ON transactions.company.id = transactions.transaction.company_id
WHERE transactions.transaction.Amount > (SELECT AVG(transactions.transaction.Amount) 
	FROM transactions.transaction 
	WHERE transactions.transaction.declined IN ("0")) and transactions.transaction.declined IN ("0")
GROUP BY transactions.company.Country
ORDER BY Media;

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 3
EJERCICIO 2
Se solicita un listado donde se especifique las empresas que han realizado mas de 4 transacciones 
y cuales han realizado menos de 4 transacciones, en el script se han tenido en cuenta solo las operaciones efectivamente realizadas,
y se muestran 100 registros.*/
SELECT transactions.company.company_name AS Company, 
CASE WHEN count(transactions.transaction.id) >= 4 THEN '4 or more'
ELSE 'Less than 4'
END AS Operations
FROM transactions.company
JOIN transactions.transaction ON transactions.company.id = transactions.transaction.company_id
WHERE transactions.transaction.declined IN ("0")
GROUP BY transactions.company.company_name
ORDER BY Operations;