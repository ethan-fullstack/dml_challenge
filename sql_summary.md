# Semana 4 – DQL/DML Cheat Sheet (PostgreSQL 17 / MySQL 8.4)

> **Propósito**: Guía rápida en **Markdown** para practicar DML/DQL en PostgreSQL y MySQL, con sintaxis, notas de compatibilidad y ejemplos breves.

---

## 1) DML Commands

### INSERT
**Uso**: insertar filas nuevas.
```sql
-- PostgreSQL / MySQL
INSERT INTO table_name (col1, col2, col3)
VALUES (val1, val2, val3), (val4, val5, val6);
```

### UPDATE
**Uso**: modificar filas existentes.
```sql
-- PostgreSQL / MySQL
UPDATE table_name
SET col1 = new_val, col2 = col2 + 1
WHERE condition;
```

### DELETE
**Uso**: eliminar filas.
```sql
-- PostgreSQL / MySQL
DELETE FROM table_name
WHERE condition;
```

### SELECT
**Uso**: consultar datos.
```sql
-- PostgreSQL / MySQL
SELECT col1, col2
FROM table_name
WHERE condition;
```

> **Tip**: En operaciones masivas de INSERT/UPDATE/DELETE, usar transacciones (`BEGIN; ... COMMIT;`) y validar con `ROLLBACK;` si es necesario.

---

## 2) Cláusulas de SELECT

### FROM
```sql
SELECT *
FROM table_name;
```

### WHERE
```sql
SELECT *
FROM table_name
WHERE col > 100 AND status = 'active';
```

### GROUP BY + HAVING
```sql
SELECT category, COUNT(*) AS n
FROM items
GROUP BY category
HAVING COUNT(*) >= 10;
```

### ORDER BY
```sql
SELECT id, created_at
FROM orders
ORDER BY created_at DESC;
```

### LIMIT / OFFSET
```sql
-- PostgreSQL / MySQL
SELECT * FROM items
ORDER BY id
LIMIT 20 OFFSET 40; -- página 3 de 20 por página
```

### DISTINCT
```sql
SELECT DISTINCT country
FROM customers;
```

### WITH (CTE)
```sql
WITH top_orders AS (
  SELECT customer_id, SUM(total_amount) AS spent
  FROM orders
  GROUP BY customer_id
  ORDER BY spent DESC
  LIMIT 10
)
SELECT c.customer_name, t.spent
FROM top_orders t
JOIN customers c ON c.customer_id = t.customer_id;
```

---

## 3) JOINs

### INNER JOIN
```sql
SELECT o.id, c.customer_name
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id;
```

### LEFT JOIN
```sql
SELECT p.id, p.name, COALESCE(SUM(oi.qty), 0) AS units
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.id, p.name;
```

### RIGHT JOIN
```sql
SELECT *
FROM a
RIGHT JOIN b ON a.id = b.a_id;
```

### FULL OUTER JOIN
```sql
-- PostgreSQL soporta FULL OUTER JOIN
SELECT *
FROM a
FULL OUTER JOIN b ON a.id = b.a_id;
-- MySQL: no soporta FULL OUTER JOIN; emular con UNION de LEFT y RIGHT
```

### CROSS JOIN
```sql
SELECT *
FROM a
CROSS JOIN b; -- producto cartesiano
```

### SELF JOIN
```sql
SELECT e.emp_id, e.name, m.name AS manager
FROM employees e
LEFT JOIN employees m ON m.emp_id = e.manager_id;
```

### NATURAL JOIN (uso profesional limitado)
```sql
SELECT *
FROM a
NATURAL JOIN b; -- une por columnas con el mismo nombre
```

---

## 4) Funciones Agregadas
```sql
SELECT
  COUNT(*)        AS total_rows,
  SUM(amount)     AS total_amount,
  AVG(amount)     AS avg_amount,
  MIN(amount)     AS min_amount,
  MAX(amount)     AS max_amount
FROM payments;
```

### Concatenación por grupo
```sql
-- PostgreSQL
SELECT department, STRING_AGG(employee_name, ', ' ORDER BY employee_name) AS names
FROM employees
GROUP BY department;

-- MySQL (equivalente)
SELECT department, GROUP_CONCAT(employee_name ORDER BY employee_name SEPARATOR ', ') AS names
FROM employees
GROUP BY department;
```

---

## 5) Funciones de Fecha y Hora

> **Compatibilidad**:
> - **PostgreSQL**: `NOW()`, `CURRENT_DATE`, `AGE()`, `DATE_PART()`, `EXTRACT()`.
> - **MySQL**: `NOW()`, `CURRENT_DATE`, `EXTRACT()`, `DATE_ADD()`, `DATE_SUB()` (en PostgreSQL se usan intervalos en lugar de `DATE_ADD/SUB`).

```sql
-- PostgreSQL
SELECT NOW() AS ts_now,
       CURRENT_DATE AS today,
       AGE(NOW(), TIMESTAMP '2025-01-01') AS age_diff,
       DATE_PART('year', NOW()) AS year_part,
       EXTRACT(MONTH FROM NOW()) AS month_part,
       (CURRENT_DATE + INTERVAL '7 days') AS plus_7_days;

-- MySQL
SELECT NOW() AS ts_now,
       CURRENT_DATE AS today,
       EXTRACT(YEAR FROM NOW()) AS year_part,
       DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) AS plus_7_days,
       DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) AS prev_month;
```

---

## 6) Funciones Numéricas
```sql
SELECT
  ROUND(123.456, 2) AS r1,
  CEIL(10.01)       AS c1,
  FLOOR(10.99)      AS f1,
  ABS(-42)          AS a1,
  MOD(10, 3)        AS m1,
  POWER(2, 10)      AS p1;
```

---

## 7) Funciones de Texto (Escalares)
```sql
SELECT
  UPPER(name)                        AS upper_name,
  LOWER(name)                        AS lower_name,
  CONCAT(first_name, ' ', last_name) AS full_name,
  SUBSTRING(code, 1, 3)              AS prefix,
  TRIM(' ' FROM note)                AS trimmed,
  LENGTH(description)                AS len,
  REPLACE(email, '@old.com', '@new.com') AS migrated;
```

---

## 8) Nulos y Condicionales
```sql
SELECT
  COALESCE(middle_name, '') AS middle_name_safe,
  NULLIF(col_a, col_b)      AS null_if_equal,
  CASE
    WHEN score >= 90 THEN 'A'
    WHEN score >= 80 THEN 'B'
    ELSE 'C'
  END AS grade,
  GREATEST(a, b, c) AS max_val,
  LEAST(a, b, c)    AS min_val
FROM t;
```

---

## 9) Operadores y Predicados

### Comparación
```sql
WHERE col = 10
  OR col > 10
  OR col < 10
  OR col >= 10
  OR col <= 10
  OR col <> 10;  -- distinto
```

### BETWEEN ... AND ...
```sql
WHERE created_at BETWEEN DATE '2025-01-01' AND DATE '2025-12-31';
```

### LIKE / ILIKE
```sql
-- PostgreSQL: ILIKE es case-insensitive
WHERE name LIKE 'Mac%';
WHERE name ILIKE '%pro%';

-- MySQL: usar COLLATE o LOWER() para case-insensitive según colación
```

### IN / NOT IN
```sql
WHERE status IN ('new', 'paid', 'shipped');
```

### EXISTS / NOT EXISTS
```sql
WHERE EXISTS (
  SELECT 1 FROM order_items oi WHERE oi.order_id = o.id
);
```

### ANY / ALL / SOME
```sql
WHERE price > ALL (SELECT price FROM products WHERE category = 'Accessories');
```

### IS NULL / IS NOT NULL
```sql
WHERE deleted_at IS NULL;
```

---

## 10) Set Operators (Combinación de resultados)

### UNION / UNION ALL
```sql
SELECT id, name FROM customers
UNION -- elimina duplicados
SELECT id, name FROM leads;

SELECT id, name FROM customers
UNION ALL -- conserva duplicados
SELECT id, name FROM leads;
```

### INTERSECT / EXCEPT
```sql
-- PostgreSQL soporta INTERSECT y EXCEPT
SELECT email FROM newsletter
INTERSECT
SELECT email FROM customers;

SELECT email FROM all_emails
EXCEPT
SELECT email FROM unsubscribed;

-- MySQL: no soporta INTERSECT/EXCEPT nativamente; usar JOINs o subconsultas equivalentes
```

---

## 11) Notas de Compatibilidad Clave
- **FULL OUTER JOIN**: disponible en PostgreSQL; **no** en MySQL (emular con `LEFT JOIN ... UNION ... RIGHT JOIN`).
- **ILIKE**: específico de PostgreSQL (case-insensitive). En MySQL depende de colación o usar `LOWER()`.
- **STRING_AGG** (PostgreSQL) vs **GROUP_CONCAT** (MySQL) para agregación de texto.
- **DATE_ADD / DATE_SUB**: nativos en MySQL; en PostgreSQL usar `+/- INTERVAL`.
- **INTERSECT / EXCEPT**: disponibles en PostgreSQL; **no** en MySQL.

---

## 12) Plantillas rápidas
```sql
-- Paginación típica
SELECT *
FROM t
ORDER BY id
LIMIT :page_size OFFSET (:page - 1) * :page_size;

-- Upsert (PostgreSQL)
INSERT INTO t (id, col)
VALUES (:id, :val)
ON CONFLICT (id) DO UPDATE
SET col = EXCLUDED.col;

-- Top-N por grupo (PostgreSQL y MySQL 8 con window functions)
SELECT * FROM (
  SELECT
    p.*,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS rn
  FROM products p
) x
WHERE rn <= 3;
```