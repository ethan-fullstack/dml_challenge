# Canvas de Retos SQL – Esquema de Data Warehouse de Ventas

Tablas disponibles:

- `payment_dim(payment_key, trans_type, bank_name)`
- `customer_dim(customer_key, name, contact_no, nid)`
- `item_dim(item_key, item_name, description, unit_price, man_country, supplier, unit)`
- `store_dim(store_key, division, district, upazila)`
- `time_dim(time_key, date, hour, day, week, month, quarter, year)`
- `fact_table(payment_key, customer_key, time_key, item_key, store_key, quantity, unit, unit_price, total_price)`

---

## 1. SELECT

1. Muestra todos los campos de la tabla `customer_dim` para revisar el catálogo completo de clientes.
2. Lista solo `customer_key`, `name` y `contact_no` de todos los clientes.
3. Obtén todas las filas de `item_dim`, pero mostrando únicamente `item_name`, `unit_price` y `supplier`.
4. Consulta todas las transacciones de `fact_table` mostrando únicamente `payment_key`, `customer_key`, `item_key`, `quantity` y `total_price`.
5. Muestra las transacciones de `fact_table` junto con el nombre del producto, combinando `fact_table` con `item_dim`.
6. Selecciona las ventas de `fact_table` junto con el nombre del cliente y la fecha de la venta, uniendo `fact_table`, `customer_dim` y `time_dim`.
7. Construye una consulta que muestre por cada fila: nombre del cliente, nombre del producto, nombre del banco y `total_price`, uniendo `fact_table` con `customer_dim`, `item_dim` y `payment_dim`.
8. Diseña una consulta que muestre por cada transacción: nombre del cliente, producto, banco, ubicación completa de la tienda (division, district, upazila) y fecha/hora de la venta, integrando todas las dimensiones con `fact_table`.

---

## 2. INSERT

1. Inserta un nuevo cliente en `customer_dim` con datos completos básicos (clave, nombre, teléfono, nid).
2. Registra un nuevo producto en `item_dim` con nombre, descripción, precio unitario, país de fabricación y proveedor.
3. Inserta un nuevo método de pago en `payment_dim` para pagos con billetera digital, incluyendo tipo de transacción y banco.
4. Agrega una nueva tienda en `store_dim` en una combinación de `division`, `district` y `upazila` que todavía no exista.
5. Crea un nuevo registro en `time_dim` que represente una fecha y hora específicas del año actual, con todos los campos derivados (day, week, month, quarter, year).
6. Registra en `fact_table` una transacción simple (una fila) en la que un cliente existente compra un producto existente en una tienda existente en una fecha/hora existente, usando un método de pago existente y calculando el `total_price` a partir de `quantity` y `unit_price`.
7. Inserta en `fact_table` varias transacciones (batch lógico) que representen una compra de varios productos diferentes por el mismo cliente, en la misma fecha, pero con cantidades distintas.
8. Registra un conjunto de transacciones de prueba para un nuevo día de ventas, creando primero los registros necesarios en `time_dim`, `store_dim` o `payment_dim` si no existen, y luego insertando varias filas coherentes en `fact_table` que permitan futuros análisis.

---

## 3. UPDATE

1. Actualiza el número de teléfono (`contact_no`) de un cliente específico en `customer_dim`, identificado por su `customer_key`.
2. Modifica el `unit_price` de un producto concreto en `item_dim` para reflejar un nuevo precio de lista.
3. Incrementa el `unit_price` de todos los productos de un proveedor determinado en un porcentaje fijo.
4. Actualiza el `bank_name` en `payment_dim` para todos los registros que usen el nombre antiguo del banco que cambió de marca.
5. Corrige en `store_dim` el `district` de todas las tiendas de una `division` que ha sido reorganizada administrativamente.
6. Ajusta en `fact_table` el `quantity` y el `total_price` de una transacción específica donde hubo un error en la cantidad vendida.
7. Actualiza las filas de `fact_table` de un rango de fechas determinado para reflejar un nuevo `unit_price` de un producto, recalculando el `total_price` solo en esas filas.
8. Realiza una actualización masiva donde, para todos los clientes de un conjunto de divisiones de tienda y en un rango de fechas específico, se incremente el `total_price` en un porcentaje que represente un impuesto adicional o ajuste de cambio.

---

## 4. DELETE

1. Elimina de `customer_dim` un cliente de prueba claramente identificado por su `name`.
2. Borra de `item_dim` un producto que nunca se llegó a utilizar en producción (por ejemplo, un producto de prueba).
3. Elimina de `store_dim` una tienda de prueba asegurándote de que no haya transacciones en `fact_table` asociadas a su `store_key`.
4. Borra de `time_dim` registros de fechas duplicadas o mal cargadas que se identifican por un rango de `date`.
5. Elimina de `fact_table` todas las transacciones que tengan `quantity` negativa o `total_price` negativo, ya que se consideran datos erróneos.
6. Borra las transacciones de `fact_table` que pertenezcan a un "día de pruebas" específico identificado en `time_dim`.
7. Elimina todas las transacciones asociadas a un cliente que solicitó borrado completo de sus datos, y luego elimina el cliente de `customer_dim`.
8. Diseña una eliminación basada en una subconsulta que elimine de `fact_table` todas las transacciones de productos que ya no existen en `item_dim` (referencias huérfanas detectadas).

---

## 5. WHERE

1. Consulta todas las ventas de `fact_table` donde `quantity` sea mayor que un valor mínimo específico.
2. Muestra las transacciones en las que el `total_price` esté dentro de un rango razonable (por ejemplo, mayor que 0 y menor que un límite alto definido).
3. Filtra las filas de `item_dim` para mostrar solo los productos de un proveedor concreto y de un país de fabricación específico.
4. Recupera las ventas de `fact_table` de un cliente concreto, en una tienda específica, durante un rango de fechas determinado usando condiciones múltiples en la cláusula `WHERE`.

---

## 6. GROUP BY

1. Calcula el total de ventas (`SUM(total_price)`) por cada `customer_key` agrupando las filas de `fact_table`.
2. Obtén el total de cantidades (`SUM(quantity)`) vendidas por producto (`item_key`) usando `GROUP BY`.
3. Calcula el total de ventas por tienda (`store_key`) y año, agrupando por tienda y año a partir de `fact_table` y `time_dim`.
4. Genera un resumen de ventas por combinación de tienda, año y método de pago (`store_key`, `year`, `payment_key`), mostrando total de ingresos y cantidad de transacciones.

---

## 7. HAVING

1. Muestra los clientes cuyo total de ventas supere una cantidad mínima, usando `GROUP BY` y `HAVING` sobre `fact_table`.
2. Obtén los productos cuya cantidad total vendida (`SUM(quantity)`) sea mayor que un umbral definido, filtrando con `HAVING`.
3. Calcula el total de ventas por tienda y muestra solo aquellas tiendas cuyo total de ventas por año sea superior a un valor dado, usando uniones con `time_dim`.
4. Construye un reporte por año y método de pago que muestre solo las combinaciones donde el número de transacciones (`COUNT(*)`) supere un mínimo y el total de ventas (`SUM(total_price)`) sea mayor a una cifra dada.

---

## 8. ORDER BY

1. Lista todos los productos ordenados por `unit_price` de menor a mayor.
2. Muestra todos los clientes ordenados alfabéticamente por `name`.
3. Ordena las transacciones de `fact_table` por `total_price` de mayor a menor para ver las ventas más grandes primero.
4. Genera una lista de productos con su total de ventas, ordenada primero por total de ventas descendente y, en caso de empate, por nombre de producto ascendente.

---

## 9. LIMIT

1. Muestra solo las primeras 5 filas de `customer_dim` para una vista rápida de ejemplo.
2. Obtén las 10 transacciones más recientes utilizando `LIMIT` después de ordenar por fecha.
3. Lista los 3 productos más caros con base en su `unit_price`.
4. Construye una consulta que muestre únicamente las 20 ventas con mayor `total_price`, combinando `ORDER BY` y `LIMIT`.

---

## 10. OFFSET

1. Muestra 5 clientes omitiendo los primeros 5 resultados, usando `LIMIT` y `OFFSET` para paginar.
2. Obtén las transacciones del "segundo bloque" de 10 filas, usando `LIMIT 10` y `OFFSET 10`.
3. Implementa una paginación que permita ver bloques de 20 productos, empezando desde el tercer bloque.
4. Simula una interfaz de reporte que muestre el bloque de ventas correspondiente a una página concreta calculando dinámicamente el `OFFSET` a partir del número de página y tamaño de página.

---

## 11. DISTINCT

1. Muestra los distintos valores de `trans_type` almacenados en `payment_dim`.
2. Lista las combinaciones distintas de `division` y `district` en `store_dim`.
3. Obtén los diferentes años (`year`) disponibles en `time_dim`.
4. Muestra los distintos pares de (`customer_key`, `item_key`) que aparecen en `fact_table` para conocer qué clientes han comprado qué productos al menos una vez.

---

## 12. WITH (CTE)

1. Crea una consulta con una CTE (`WITH`) que primero calcule el total de ventas por cliente y luego, en la consulta final, muestre solo esos totales.
2. Define una CTE que obtenga las ventas por producto en el último año y luego usa esa CTE para seleccionar solo los productos más vendidos.
3. Diseña una CTE que compute las ventas diarias (por `date`) y una consulta principal que muestre solo los días con ventas superiores a un umbral.
4. Construye una consulta que use dos CTE: una para calcular las ventas por cliente y otra para calcular las ventas por tienda, y en la consulta final combines o compares estos resultados.

---

## 13. INNER JOIN

1. Une `fact_table` con `customer_dim` usando `INNER JOIN` para mostrar el nombre del cliente y el `total_price` de cada transacción.
2. Combina `fact_table` con `item_dim` para mostrar el nombre del producto y la cantidad vendida.
3. Crea una consulta que una `fact_table`, `customer_dim` y `time_dim` para mostrar nombre del cliente, fecha de venta y `total_price`.
4. Diseña una consulta que una `fact_table` con todas las dimensiones (`customer_dim`, `item_dim`, `store_dim`, `time_dim`, `payment_dim`) mostrando una vista detallada de cada venta.

---

## 14. LEFT JOIN

1. Muestra todas las tiendas de `store_dim` y, si existen, sus ventas asociadas en `fact_table`, usando `LEFT JOIN`.
2. Lista todos los clientes y las ventas que hayan realizado, de modo que los clientes sin ventas también aparezcan.
3. Crea una consulta que muestre todos los productos y la cantidad total vendida, mostrando cero o nulo cuando un producto todavía no se haya vendido.
4. Diseña una consulta que muestre todas las combinaciones de tienda y año con sus ventas, pero en la que las tiendas sin ventas en algún año sigan apareciendo.

---

## 15. RIGHT JOIN

1. Usa `RIGHT JOIN` para obtener todas las ventas de `fact_table` junto con información de `store_dim`, garantizando que todas las filas de `fact_table` aparezcan.
2. Construye una consulta donde `item_dim` se una a `fact_table` con `RIGHT JOIN` para analizar qué filas de `fact_table` podrían no tener producto asociado (si las hubiera).
3. Diseña una consulta donde `customer_dim` se una con `fact_table` usando `RIGHT JOIN` para asegurarte de que no se pierdan registros de ventas.
4. Combina `time_dim` con `fact_table` mediante `RIGHT JOIN` para listar todas las transacciones y su información temporal, analizando posibles inconsistencias temporales.

---

## 16. FULL JOIN

1. Utiliza `FULL JOIN` entre `customer_dim` y `fact_table` para obtener tanto clientes sin ventas como ventas que puedan no tener cliente válido.
2. Haz un `FULL JOIN` entre `item_dim` y `fact_table` para identificar productos sin ventas y ventas con productos inexistentes.
3. Diseña una consulta que compare `store_dim` y `fact_table` con `FULL JOIN` para ver tiendas sin ventas y ventas con tiendas no registradas.
4. Construye una vista de calidad de datos usando `FULL JOIN` entre una dimensión (por ejemplo `item_dim`) y `fact_table`, clasificando las filas según si faltan datos en uno u otro lado.

---

## 17. CROSS JOIN

1. Crea una consulta que haga `CROSS JOIN` entre `store_dim` e `item_dim` para generar todas las combinaciones posibles de tienda y producto.
2. Genera un catálogo teórico de ventas potenciales combinando todas las tiendas con todos los métodos de pago mediante `CROSS JOIN`.
3. Utiliza `CROSS JOIN` entre una pequeña lista de parámetros (por ejemplo, años filtrados en `time_dim`) y los productos para simular escenarios de ventas por año.
4. Diseña una consulta que use `CROSS JOIN` y posteriormente `WHERE` para filtrar solo ciertas combinaciones útiles, por ejemplo, tiendas de una división específica con productos de un proveedor concreto.

---

## 18. SELF JOIN

1. Realiza un `SELF JOIN` en `store_dim` para comparar tiendas que estén en la misma `division`.
2. Usa un `SELF JOIN` en `customer_dim` para detectar clientes que compartan el mismo número de documento (`nid`).
3. Crea una consulta con `SELF JOIN` en `item_dim` para identificar pares de productos del mismo proveedor con precios diferentes.
4. Diseña una comparación de productos usando `SELF JOIN` en `item_dim` para encontrar productos cuyo `unit_price` sea mayor que el de otros productos del mismo proveedor.

---

## 19. NATURAL JOIN

1. Identifica dos tablas de tu esquema que compartan una columna con el mismo nombre y realiza un `NATURAL JOIN` simple entre ellas.
2. Usa `NATURAL JOIN` entre `fact_table` y una dimensión adecuada, analizando qué columnas en común se están usando para la unión.
3. Ajusta una consulta con `NATURAL JOIN` para validar si el resultado coincide con el de una consulta equivalente usando `INNER JOIN` explícito.
4. Diseña un ejemplo donde `NATURAL JOIN` produzca un resultado inesperado y explica por qué es más seguro usar uniones con columnas especificadas explícitamente.

---

## 20. COUNT, SUM, AVG, MIN, MAX, STRING_AGG

1. Cuenta cuántas transacciones hay registradas en `fact_table`.
2. Calcula la suma total de `total_price` en `fact_table` para conocer los ingresos globales.
3. Obtén, para cada proveedor, el precio promedio (`AVG(unit_price)`) de sus productos y el precio mínimo y máximo.
4. Construye una consulta que agrupe productos por proveedor y use `STRING_AGG` para concatenar en una sola cadena los nombres de productos de cada proveedor.

---

## 21. NOW(), CURRENT_DATE, AGE(), DATE_PART(), EXTRACT(), DATE_ADD(), DATE_SUB()

1. Calcula cuántos días han pasado desde cada venta registrada hasta la fecha actual usando `AGE` o una función equivalente.
2. Usa `DATE_PART` o `EXTRACT` para obtener el mes y el año desde el campo `date` de `time_dim` y mostrar estos valores junto a cada fecha.
3. Genera un resumen de ventas por mes y año utilizando los valores extraídos de `time_dim`.
4. Diseña una consulta que tome una fecha de `time_dim` y calcule una fecha futura (simulando `DATE_ADD`) y una pasada (simulando `DATE_SUB`), mostrando ambas columnas para análisis de escenarios.

---

## 22. ROUND(), CEIL(), FLOOR(), ABS(), MOD(), POWER()

1. Muestra el `unit_price` de los productos junto con su versión redondeada a 2 decimales usando una función de redondeo.
2. Calcula un descuento teórico sobre `total_price` y muestra el valor redondeado hacia arriba (`CEIL`) y hacia abajo (`FLOOR`).
3. Usa `ABS` para mostrar la diferencia absoluta entre el `unit_price` de cada producto y un precio de referencia que definas.
4. Diseña una consulta que clasifique las ventas de `fact_table` en grupos basados en `MOD(quantity, n)` y calcula un valor de crecimiento hipotético sobre `total_price` usando `POWER`.

---

## 23. UPPER(), LOWER(), CONCAT(), SUBSTRING(), TRIM(), LENGTH(), REPLACE()

1. Muestra los nombres de los clientes en mayúsculas y en minúsculas en columnas separadas.
2. Concatena `division`, `district` y `upazila` de `store_dim` en una sola columna de dirección legible.
3. Usa `SUBSTRING` y `LENGTH` para validar el formato del `nid` de los clientes, marcando cuáles no cumplen una longitud esperada.
4. Diseña una consulta que limpie espacios extras con `TRIM` y reemplace abreviaturas en los nombres de productos utilizando `REPLACE`.

---

## 24. COALESCE(), NULLIF(), CASE, GREATEST(), LEAST()

1. Usa `COALESCE` para mostrar un valor por defecto cuando `contact_no` de un cliente sea nulo.
2. Emplea `NULLIF` para evitar divisiones por cero al calcular un índice como `total_price / quantity`.
3. Diseña una clasificación de productos usando `CASE` para asignar etiquetas como "Barato", "Medio" y "Caro" según su `unit_price`.
4. Construye una consulta que use `GREATEST` y `LEAST` para comparar el `unit_price` de cada producto con valores mínimos y máximos de referencia, identificando si el precio está fuera de los límites.

---

## 25. Operadores (=, >, <, >=, <=, <>)

1. Muestra todas las ventas donde `total_price` sea mayor que un valor definido.
2. Lista los productos cuyo `unit_price` sea menor o igual a un umbral máximo.
3. Obtén las transacciones donde `quantity` sea diferente (`<>`) de 1 para identificar ventas de múltiples unidades.
4. Filtra los clientes cuyo nombre sea exactamente igual a un texto dado y que además tengan `contact_no` no nulo.

---

## 26. BETWEEN AND

1. Obtén todas las ventas cuya fecha (en `time_dim`) esté entre dos fechas específicas.
2. Lista los productos cuyo `unit_price` esté entre dos valores límite.
3. Muestra las transacciones de `fact_table` donde `quantity` esté entre un mínimo y un máximo.
4. Genera un reporte de ventas por año donde el `year` esté entre dos valores definidos y el total de ventas también se encuentre dentro de un rango.

---

## 27. LIKE / ILIKE

1. Encuentra todos los clientes cuyo `name` comience por un prefijo específico.
2. Busca productos en `item_dim` cuya `description` contenga una palabra clave.
3. Lista las tiendas cuyo `district` contenga una subcadena concreta en cualquier posición.
4. Diseña una consulta que encuentre bancos en `payment_dim` cuyos nombres terminen en una palabra concreta, sin importar mayúsculas o minúsculas.

---

## 28. IN / NOT IN

1. Muestra las ventas cuyo `payment_key` pertenezca a un conjunto específico de métodos de pago.
2. Lista los productos cuyos proveedores estén dentro de una lista de proveedores seleccionados.
3. Obtén los clientes cuyo `customer_key` no esté en una lista de clientes bloqueados utilizando `NOT IN`.
4. Filtra las ventas de `fact_table` para incluir solo aquellas que se realizaron en tiendas pertenecientes a una lista de divisiones concretas.

---

## 29. EXISTS / NOT EXISTS

1. Lista los clientes para los que exista al menos una venta en `fact_table` usando `EXISTS`.
2. Muestra los productos que no tengan ninguna venta asociada en `fact_table` utilizando `NOT EXISTS`.
3. Diseña una consulta que obtenga tiendas que tengan al menos una venta en un rango de fechas específico mediante una subconsulta correlacionada con `EXISTS`.
4. Identifica las divisiones que no tienen ninguna tienda con ventas, utilizando `NOT EXISTS` sobre `store_dim` y `fact_table`.

---

## 30. ANY / ALL / SOME

1. Encuentra productos cuyo `unit_price` sea mayor que el precio de cualquier (`ANY`/`SOME`) producto de otro proveedor.
2. Busca transacciones cuyo `total_price` sea mayor que el `total_price` de cualquier (`ANY`) transacción de un cliente específico.
3. Diseña una consulta que verifique si la `quantity` de una venta es mayor que alguna de las cantidades en un subconjunto de ventas de referencia usando `ANY` o `SOME`.
4. Identifica productos cuyo `unit_price` sea mayor que el `unit_price` de todos (`ALL`) los productos de un proveedor determinado.

---

## 31. IS NULL / IS NOT NULL

1. Lista los clientes cuyo `contact_no` sea nulo para detectar datos incompletos.
2. Muestra los productos cuya `description` no sea nula, garantizando que estén documentados.
3. Obtén las transacciones donde algún campo opcional (defínelo en tu diseño) esté nulo para revisar calidad de datos.
4. Diseña una consulta que clasifique las tiendas en dos grupos: las que tienen todos sus campos de localización no nulos y las que tienen al menos uno nulo.

---

## 32. UNION, UNION ALL, INTERSECT, EXCEPT

1. Usa `UNION` para combinar dos listas de clientes filtradas por criterios distintos, eliminando duplicados.
2. Emplea `UNION ALL` para unir dos conjuntos de productos obtenidos con filtros diferentes, permitiendo duplicados para analizar frecuencias.
3. Utiliza `INTERSECT` para obtener los `customer_key` que aparecen en ventas de dos años diferentes (por ejemplo, clientes que compraron en ambos años).
4. Diseña una consulta con `EXCEPT` que devuelva las tiendas que están en `store_dim` pero que no tienen ninguna venta registrada en `fact_table`.
