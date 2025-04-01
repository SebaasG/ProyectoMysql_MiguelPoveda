## 📂 Categorías  

📌 **Campers** → [Ver consultas](../campers/)  
📌 **Evaluaciones** → [Ver consultas](../evaluaciones/)  
📌 **Funciones** → [Ver consultas](../funciones/)  
📌 **Joins** → [Ver consultas](../joins/)  
📌 **Procedimientos** → [Ver consultas](../procedimientos/)  
📌 **Rutas y Áreas** → [Ver consultas](../rutas_areas/)  
📌 **Trainers** → [Ver consultas](../trainers/)  
📌 **Triggers** → [Ver consultas](../triggers/)  

### 1️⃣ Obtener todos los campers inscritos actualmente
```sql
SELECT * FROM campers WHERE estado = 'Inscrito';
```

### 2️⃣ Listar los campers con estado "Aprobado"
```sql
SELECT * FROM campers WHERE estado = 'Aprobado';
```

### 3️⃣ Mostrar los campers que ya están cursando alguna ruta
```sql
SELECT c.* FROM campers c
JOIN rutas r ON c.id_ruta = r.id
WHERE r.estado = 'En curso';
```

### 4️⃣ Consultar los campers graduados por cada ruta
```sql
SELECT r.nombre AS ruta, COUNT(c.id) AS total_graduados
FROM campers c
JOIN rutas r ON c.id_ruta = r.id
WHERE c.estado = 'Graduado'
GROUP BY r.nombre;
```

### 5️⃣ Obtener los campers en estado "Expulsado" o "Retirado"
```sql
SELECT * FROM campers WHERE estado IN ('Expulsado', 'Retirado');
```

### 6️⃣ Listar campers con nivel de riesgo “Alto”
```sql
SELECT * FROM campers WHERE nivel_riesgo = 'Alto';
```

### 7️⃣ Mostrar el total de campers por cada nivel de riesgo
```sql
SELECT nivel_riesgo, COUNT(*) AS total
FROM campers
GROUP BY nivel_riesgo;
```

### 8️⃣ Obtener campers con más de un número telefónico registrado
```sql
SELECT c.id, c.nombre, COUNT(t.numero) AS total_telefonos
FROM campers c
JOIN telefonos t ON c.id = t.id_camper
GROUP BY c.id, c.nombre
HAVING COUNT(t.numero) > 1;
```

### 9️⃣ Listar los campers y sus respectivos acudientes y teléfonos
```sql
SELECT c.nombre AS camper, a.nombre AS acudiente, t.numero AS telefono
FROM campers c
LEFT JOIN acudientes a ON c.id_acudiente = a.id
LEFT JOIN telefonos t ON c.id = t.id_camper;
```

### 🔟 Mostrar campers que aún no han sido asignados a una ruta
```sql
SELECT * FROM campers WHERE id_ruta IS NULL;
```

