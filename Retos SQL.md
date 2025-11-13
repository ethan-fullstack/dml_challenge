# Retos SQL basados en el esquema de Data Warehouse (ventas)

Tablas disponibles:

- `payment_dim(payment_key, trans_type, bank_name)`
- `customer_dim(customer_key, name, contact_no, nid)`
- `item_dim(item_key, item_name, description, unit_price, man_country, supplier, unit)`
- `store_dim(store_key, division, district, upazila)`
- `time_dim(time_key, date, hour, day, week, month, quarter, year)`
- `fact_table(payment_key, customer_key, time_key, item_key, store_key, quantity, unit, unit_price, total_price)`

---

## INSERT (8 retos)

1. Registra un nuevo método de pago en `payment_dim` para pagos con billetera digital, incluyendo tipo de transacción y banco asociado.
2. Agrega un nuevo cliente en `customer_dim` con nombre, teléfono y documento de identidad, asegurando que el `customer_key` no esté repetido.
3. Crea un nuevo producto en `item_dim` representando un “Smartphone 5G”, con descripción, país de fabricación, proveedor, precio unitario y unidad “unit”.
4. Inserta una nueva tienda en `store_dim` ubicada en una nueva combinación de `division`, `district` y `upazila` que no existan aún en la tabla.
5. Registra una nueva fila en `time_dim` que represente una fecha y hora específicas de este año, rellenando los campos `hour`, `day`, `week`, `month`, `quarter` y `year` coherentes.
6. Inserta en `fact_table` una transacción que refleje la compra de 5 unidades de un producto existente, por un cliente existente, en una tienda existente y en una fecha/hora existente, calculando el `total_price` correctamente.
7. Crea una transacción en `fact_table` que represente una venta con un nuevo método de pago que acabas de crear en `payment_dim`, manteniendo la integridad referencial.
8. Registra varias ventas en `fact_table` para el mismo cliente, mismo día y diferentes productos, de forma que luego puedas analizarlas por cliente y fecha.

---

## UPDATE (8 retos)

1. Actualiza en `customer_dim` el número de teléfono de un cliente específico identificado por su `nid`, dejando constancia solo del nuevo número.
2. Modifica en `item_dim` el `unit_price` de todos los productos de un proveedor determinado, aumentando el precio un porcentaje fijo.
3. Cambia el `bank_name` de todos los registros en `payment_dim` donde el banco antiguo ha pasado a fusionarse bajo un nuevo nombre.
4. Actualiza en `store_dim` el `district` de todas las tiendas que han sido reasignadas a una nueva división administrativa.
5. Corrige en `time_dim` el campo `week` para las fechas que hayan quedado con un número de semana incorrecto según su `date`.
6. Ajusta en `fact_table` el `quantity` y `total_price` de una venta específica en la que se detectó un error de digitación en la cantidad.
7. Actualiza el `unit` en `item_dim` y en todas las filas correspondientes de `fact_table` para un producto que cambiará su unidad de “kg” a “g”.
8. Cambia el tipo de transacción (`trans_type`) en `payment_dim` y asocia todas las ventas correspondientes en `fact_table` a ese nuevo tipo, solo cuando el cambio aplique a transacciones de un rango de fechas determinado.

---

## DELETE (8 retos)

1. Elimina de `payment_dim` un método de pago que ya no se utilizará, asegurándote de no romper la integridad referencial con `fact_table`.
2. Borra de `customer_dim` los clientes de prueba que se crearon con nombres claramente ficticios usados en ambiente de desarrollo.
3. Elimina de `item_dim` un producto que nunca ha sido vendido, verificando primero que no existan filas en `fact_table` que lo referencien.
4. Borra de `store_dim` una tienda que cerró definitivamente y que no tiene transacciones registradas en `fact_table`.
5. Elimina de `time_dim` filas duplicadas que representen exactamente la misma fecha y hora (`date`) y que tengan el mismo `time_key`.
6. Elimina de `fact_table` todas las transacciones de pruebas realizadas en un día específico marcado como “día de pruebas” en `time_dim`.
7. Borra de `fact_table` las ventas que tengan `quantity` o `total_price` con valores claramente inválidos (por ejemplo, negativos) para limpiar datos.
8. Elimina de `fact_table` todas las transacciones asociadas a un cliente que ejerció su derecho a eliminación de datos (derecho al olvido), preparando luego la eliminación segura del cliente.

---

## SELECT (básico) (8 retos)

1. Consulta todos los clientes de `customer_dim` mostrando solo `customer_key`, `name` y `contact_no`.
2. Lista todos los productos de `item_dim` mostrando su nombre, proveedor y precio unitario.
3. Obtén todas las tiendas de `store_dim` junto con su `division`, `district` y `upazila`.
4. Muestra todas las filas de `time_dim` correspondientes al año actual usando el campo `year`.
5. Consulta todas las transacciones de `fact_table` sin filtrar, para ver su estructura completa.
6. Extrae de `payment_dim` todos los tipos de transacción (`trans_type`) junto con el banco asociado.
7. Muestra las filas de `fact_table` para un solo cliente, filtrando por su `customer_key` explícito.
8. Visualiza las transacciones de `fact_table` para un producto concreto, mostrando `quantity`, `unit`, `unit_price` y `total_price`.

---

## FROM, WHERE, GROUP BY, HAVING, ORDER BY, LIMIT, OFFSET, DISTINCT, WITH (4 retos)

1. Construye una consulta que obtenga el total de ventas por `customer_key` usando agregaciones, agrupando por cliente (`GROUP BY`) y mostrando solo aquellos clientes cuyo total de ventas supere un valor mínimo (`HAVING`).
2. Diseña una consulta que liste los 10 productos más vendidos según `quantity` total, ordenados de mayor a menor (`ORDER BY`), limitando el resultado (`LIMIT`) y saltando los primeros 5 (`OFFSET`).
3. Crea una consulta que muestre los distintos (`DISTINCT`) tipos de transacción (`trans_type`) usados en las ventas registradas en `fact_table`, combinando `FROM`, `WHERE` y `JOIN` con `payment_dim`.
4. Especifica una consulta usando una expresión común (`WITH`) para calcular primero el total de ventas por tienda y luego, en la consulta principal, seleccionar solo las tiendas cuyo total supera un umbral.

---

## INNER, LEFT, RIGHT, FULL, CROSS, SELF, NATURAL (4 retos)

1. Diseña una consulta que use `INNER JOIN` entre `fact_table`, `customer_dim` e `item_dim` para mostrar ventas por cliente y nombre de producto.
2. Crea una consulta con `LEFT JOIN` donde aparezcan todas las tiendas de `store_dim` y, si existen, sus ventas correspondientes en `fact_table`, permitiendo ver tiendas sin ventas.
3. Especifica una consulta que utilice `FULL JOIN` entre `customer_dim` y `fact_table` para identificar tanto clientes sin ventas como ventas que pudieran referenciar clientes inconsistentes.
4. Diseña una consulta de tipo `CROSS JOIN` entre `store_dim` y `item_dim` para simular todas las combinaciones posibles de tienda y producto, por ejemplo, para un análisis de catálogo.

---

## COUNT, SUM, AVG, MIN, MAX, STRING_AGG (4 retos)

1. Calcula el número total de transacciones registradas en `fact_table` usando una función de conteo.
2. Obtén el total de ingresos (`SUM` de `total_price`) por año usando `time_dim` y `fact_table` unidos por `time_key`.
3. Calcula el precio promedio (`AVG` de `unit_price`) por proveedor a partir de `item_dim`.
4. Genera una consulta que agrupe productos por proveedor y concatene (`STRING_AGG`) los nombres de productos en una sola cadena por cada proveedor.

---

## Fechas y tiempos: NOW(), CURRENT_DATE, AGE(), DATE_PART(), EXTRACT(), DATE_ADD(), DATE_SUB() (4 retos)

1. Construye una consulta que compare la fecha actual (`CURRENT_DATE` o similar) con las fechas almacenadas en `time_dim` para obtener las ventas de los últimos 7 días.
2. Calcula la “edad” (`AGE`) de cada transacción en `fact_table` tomando la fecha en `time_dim` y comparándola con el momento actual (`NOW()`).
3. Diseña una consulta que use `DATE_PART` o `EXTRACT` para obtener el mes y el trimestre de cada fecha de `time_dim` y agrupar el total de ventas por trimestre.
4. Plantea una consulta que utilice una operación equivalente a `DATE_ADD` o `DATE_SUB` para proyectar una fecha futura o pasada a partir de `date` en `time_dim`, por ejemplo para ver cómo quedarían ventas si se desplazara una campaña promocional.

---

## Funciones numéricas: ROUND(), CEIL(), FLOOR(), ABS(), MOD(), POWER() (4 retos)

1. Crea una consulta que redondee (`ROUND`) el `unit_price` de los productos a 2 decimales y muestre el resultado junto con el precio original.
2. Diseña una consulta que aplique `CEIL` o `FLOOR` sobre un cálculo de descuento aplicado al `total_price` y compare los resultados.
3. Genera una consulta que use `ABS` para mostrar la magnitud de las diferencias entre un precio real y un precio objetivo (por ejemplo, entre `unit_price` y un precio estándar).
4. Plantea una consulta que use `MOD` para clasificar las transacciones de `fact_table` en grupos según el resto de dividir su `quantity` entre un número fijo (por ejemplo, 2 o 5), y otra que use `POWER` para hacer un cálculo de crecimiento hipotético sobre `total_price`.

---

## Funciones de texto: UPPER(), LOWER(), CONCAT(), SUBSTRING(), TRIM(), LENGTH(), REPLACE() (4 retos)

1. Diseña una consulta que muestre el nombre de los clientes en mayúsculas (`UPPER`) y minúsculas (`LOWER`) al mismo tiempo, para analizar uniformidad de datos.
2. Crea una consulta que concatene (`CONCAT`) el `division`, `district` y `upazila` de `store_dim` en una sola columna de dirección legible.
3. Construye una consulta que use `SUBSTRING` y `LENGTH` para extraer y validar una parte del `nid` de los clientes, verificando que cumpla con un formato específico.
4. Plantea una consulta que utilice `TRIM` y `REPLACE` para limpiar espacios en blanco y reemplazar abreviaturas en los nombres de productos de `item_dim`.

---

## COALESCE(), NULLIF(), CASE, GREATEST(), LEAST() (4 retos)

1. Crea una consulta que use `COALESCE` para mostrar un valor por defecto cuando ciertos campos de contacto (`contact_no`) de clientes son nulos.
2. Diseña una consulta que use `NULLIF` para evitar divisiones por cero al calcular ratios entre cantidades o totales de ventas.
3. Genera una consulta que utilice `CASE` para clasificar las tiendas en categorías como “Alta venta”, “Media venta” y “Baja venta” según su `total_price` acumulado.
4. Construye una consulta que use `GREATEST` y `LEAST` para comparar, por cada producto, el precio actual con algún precio mínimo y máximo esperado.

---

## Operadores (=, >, <, >=, <=, <>) (4 retos)

1. Especifica una consulta que traiga todas las ventas donde el `total_price` sea mayor que un umbral definido.
2. Diseña una consulta que liste los productos cuyo `unit_price` sea menor o igual a un valor máximo que definas.
3. Construye una consulta que muestre las transacciones en las que la `quantity` sea diferente (`<>`) de 1, para identificar ventas de múltiples unidades.
4. Crea una consulta que obtenga los clientes cuyo `name` sea exactamente igual a un valor proporcionado, usando el operador de igualdad.

---

## BETWEEN AND (4 retos)

1. Crea una consulta que obtenga todas las transacciones cuya fecha en `time_dim` esté entre dos fechas específicas (incluyéndolas) utilizando un rango.
2. Diseña una consulta que liste los productos cuyo `unit_price` se encuentre entre dos valores, por ejemplo, entre 100 y 500 unidades monetarias.
3. Plantea una consulta que muestre las tiendas cuya división administrativa (`division`) se encuentre entre dos valores alfabéticos, usando un rango textual.
4. Genera una consulta que filtre las cantidades de `fact_table` para quedar solo con `quantity` entre un mínimo y un máximo que definas.

---

## LIKE / ILIKE (4 retos)

1. Diseña una consulta que encuentre todos los clientes cuyo nombre comience por una letra o un prefijo determinado, usando coincidencia de patrón.
2. Crea una consulta que busque productos en `item_dim` cuyo `description` contenga una palabra clave, sin importar mayúsculas o minúsculas.
3. Construye una consulta que liste las tiendas cuyo `district` contenga una subcadena específica en cualquier posición.
4. Plantea una consulta que identifique bancos en `payment_dim` cuyos nombres terminen en una palabra concreta, por ejemplo “Bank” o “Banco”.

---

## IN / NOT IN (4 retos)

1. Crea una consulta que obtenga todas las transacciones cuyo `payment_key` pertenezca a un conjunto específico de métodos de pago.
2. Diseña una consulta que liste los productos cuyo proveedor esté dentro de una lista de proveedores “preferidos”.
3. Genera una consulta que muestre los clientes que no estén en una lista de `customer_key` bloqueados, usando una condición de exclusión.
4. Plantea una consulta que obtenga las ventas que ocurrieron en tiendas que pertenezcan a un conjunto concreto de divisiones.

---

## EXISTS / NOT EXISTS (4 retos)

1. Diseña una consulta que liste los clientes de `customer_dim` para los cuales existe al menos una venta en `fact_table`.
2. Crea una consulta que muestre los productos de `item_dim` que no tengan ninguna venta registrada en `fact_table`.
3. Construye una consulta que liste las tiendas que tengan al menos una venta durante un rango de fechas específico, usando una subconsulta correlacionada.
4. Plantea una consulta que obtenga las divisiones que no tengan ninguna tienda con ventas, utilizando `NOT EXISTS`.

---

## ANY / ALL / SOME (4 retos)

1. Crea una consulta que compare el `unit_price` de un producto con los precios de todos los productos de otro proveedor, utilizando una condición con `ALL`.
2. Diseña una consulta que busque transacciones cuyo `total_price` supere el `total_price` de cualquier (`ANY`) transacción de un determinado cliente.
3. Construye una consulta que use `ANY` o `SOME` para verificar si la `quantity` de una venta es mayor que alguna de las cantidades de un conjunto de ventas de referencia.
4. Plantea una consulta que compare el `unit_price` de cada producto con todos (`ALL`) los precios dentro de una categoría, para identificar productos que son siempre más caros.

---

## IS NULL / IS NOT NULL (4 retos)

1. Diseña una consulta que muestre los clientes cuyo `contact_no` sea nulo, para identificar datos incompletos.
2. Crea una consulta que liste las transacciones en `fact_table` donde algún campo opcional (si decides dejarlo nulo en tu diseño) no haya sido completado.
3. Construye una consulta que muestre todos los productos donde `description` no sea nula, garantizando que solo se visualicen productos bien documentados.
4. Plantea una consulta que identifique tiendas donde uno de los campos de localización (por ejemplo `upazila`) esté vacío (nulo) y necesite ser corregido.

---

## UNION, UNION ALL, INTERSECT, EXCEPT (4 retos)

1. Diseña una consulta que combine (`UNION`) dos conjuntos de clientes filtrados por criterios distintos, asegurando que no haya filas duplicadas en el resultado.
2. Crea una consulta que una (`UNION ALL`) listas de productos provenientes de dos criterios diferentes, permitiendo duplicados para analizar frecuencias.
3. Construye una consulta que obtenga (`INTERSECT`) los `customer_key` que aparecen en dos subconjuntos distintos de `fact_table`, por ejemplo, clientes que compraron en dos años diferentes.
4. Plantea una consulta que use (`EXCEPT`) para obtener las tiendas que están en una lista de referencia, pero que no tienen ninguna venta en `fact_table`.
