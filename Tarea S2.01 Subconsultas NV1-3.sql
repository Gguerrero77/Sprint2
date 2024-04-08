USE transactions;
/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 1
En esta consulta se listan las operaciones realizadas por empresas en Alemania, se han tenido en cuenta todas las transacciones tanto efectivas como no.
La consulta genera una tabla con 118 registros (transacciones)*/
SELECT (SELECT company_name FROM company WHERE id = t.company_id) AS Company, t.id AS Transaction_ID, t.Amount, t.timestamp AS Date, t.Declined
FROM transaction t
WHERE t.company_id IN (SELECT id FROM company WHERE Country = 'Germany');

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 2
Se solicita un listado de empresas que han realizado transacciones por encima de la media general, 
se han tenido en cuenta todas las transacciones, se genera una tabla con 70 registros (empresas).*/

SELECT DISTINCT c.company_name
FROM company c
WHERE c.id IN (SELECT t.company_id
			   FROM transaction t
			   WHERE (SELECT AVG(amount) FROM transaction) < t.amount)
ORDER BY c.company_name;

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 3
Atendiendo al requerimiento y teniendo en cuenta la única pista dada, 
se listan solo las transacciones realizadas por empresas cuyo nombre comienza con la letra "C",
se han tenido en cuenta todas las transacciones, y se muestran en la tabla la fecha de dichas operaciones, 
el monto de las mismas y el id de la operación, datos estos que se consideran relevantes para determinar 
cuáles son los registros faltantes.*/
SELECT (SELECT Company_Name FROM company WHERE id = t.company_id) AS Company, id AS Op_Id, Amount, timestamp AS Date, Declined
FROM transaction t
WHERE company_id in (SELECT id from company)
HAVING Company LIKE "C%";

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 1
EJERCICIO 4
Se nos ha solicitado un listado de las empresas que no tienen operaciones registradas para proceder a su eliminación, 
el script de la consulta está diseñado para generar un listado con el nombre de dichas empresas,
sin embargo, se debe resaltar que en la actualidad en la base de datos no existen empresas que cumplan con dicha condición por lo cual
el resultado es un listado sin registros, se ha ordenado para que en caso de generarse registros en el futuro se muestren alfabéticamente.*/
SELECT c.company_name AS COMPANY
FROM company c
WHERE c.id NOT IN ( SELECT t.company_id FROM transaction t)
ORDER BY COMPANY;


/*Tarea S2.01. Subconsultas - MySQL
NIVEL 2
EJERCICIO 1
Se nos solicita un listado de transacciones realizadas en el mismo país de origen de la empresa "Non Institute", 
al efecto se ha creado un script que genera dicho listado mostrando la informacion relevante.*/
SELECT id, company_id, (SELECT company_name from company WHERE id = t.company_id and country in (select country from company where company_name = ("Non Institute"))) AS Company_Name, amount 
FROM transaction t
Having Company_Name is not null
order by company_name;


/*Tarea S2.01. Subconsultas - MySQL
NIVEL 2
EJERCICIO 2
Se nos ha solicitado informar el nombre de la empresa que ha realizado la operación con mayor valor en la base de datos,
se ha tenido en cuenta solo las operaciones efectivamente realizadas y como resultado se genera una tabla con un único registro.*/
SELECT (SELECT company_name from company where id = t.company_id) AS Company, t.Amount
FROM transaction t 
WHERE amount = (SELECT MAX(Amount) 
					FROM transaction t);


/*Tarea S2.01. Subconsultas - MySQL
NIVEL 3
EJERCICIO 1
Se solicita un listado que informe las ventas medias por país, cuando dicha media sea superior a la media global, 
se han tenido en cuenta solo las operaciones efectivamente realizadas
y como resultado se genera una tabla con 13 registros.*/

SELECT (SELECT Country FROM company where id = t.company_id) AS Country, format(avg(t.Amount), 2) AS Media
FROM transaction t
GROUP BY Country
HAVING AVG(Amount) > (SELECT AVG(t.Amount) 
					FROM transaction t)
ORDER BY Media;

/*Tarea S2.01. Subconsultas - MySQL
NIVEL 3
EJERCICIO 2
Se solicita un listado donde se especifique las empresas que han realizado mas de 4 transacciones 
y cuales han realizado menos de 4 transacciones, en el script se han tenido en cuenta solo las operaciones efectivamente realizadas,
y se muestran 100 registros.*/
SELECT (SELECT company_name FROM Company where id = t.company_id) AS company, 
CASE WHEN count(t.id) >= 4 THEN '4 or more'
ELSE 'Less than 4'
END AS Operations 
FROM transaction t
GROUP BY Company
ORDER BY Operations;