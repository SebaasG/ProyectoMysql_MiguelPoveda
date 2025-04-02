## 📂 Categorías  

📌 **Campers** → [Ver consultas](../../consultas-sql/1.campers/)  
📌 **Evaluaciones** → [Ver consultas](../../consultas-sql/2.evaluaciones/)  
📌 **Rutas y Áreas** → [Ver consultas](../../consultas-sql/3.rutas_Areas/)  
📌 **Trainers** → [Ver consultas](../../consultas-sql/4.trainers/)  
📌 **Subconsultas** → [Ver consultas](../../consultas-sql/5.SubConsultas/)  
📌 **Joins Específicos** → [Ver consultas](../../consultas-sql/7.Joins_específicos/)  
📌 **Joins Condiciones** → [Ver consultas](../../consultas-sql/8.joins_condiciones/)  
📌 **Procedimientos** → [Ver consultas](../../consultas-sql/9.procedimientos/)  
📌 **Funciones** → [Ver consultas](../../consultas-sql/10.funciones/)  
📌 **Triggers** → [Ver consultas](../../consultas-sql/11.triggers/)  

### 1️⃣ Obtener todos los campers inscritos actualmente
```sql
SELECT c.doc, c.nombres, c.apellidos 
FROM camper c
JOIN inscripciones i ON c.doc = i.docCamper;
```

### 2️⃣ Listar los campers con estado "Aprobado"
```sql
SELECT c.doc, c.nombres, c.apellidos 
FROM camper c
JOIN datosCamper dc ON c.doc = dc.docCamper
JOIN estados e ON dc.idEstado = e.id
WHERE e.estado = 'Aprobado';
```

### 3️⃣ Mostrar los campers que ya están cursando alguna ruta
```sql
SELECT c.doc, c.nombres, c.apellidos, r.nombre AS ruta 
FROM camper c
JOIN inscripciones i ON c.doc = i.docCamper
JOIN rutas r ON i.idRuta = r.id;
```

### 4️⃣ Consultar los campers graduados por cada ruta
```sql
SELECT c.nombres, c.apellidos, e.idRuta, r.nombre AS ruta, COUNT(e.docCamper) AS total_graduados 
FROM egresados e
JOIN rutas r ON e.idRuta = r.id
INNER JOIN camper c on e.docCamper = c.doc
GROUP BY e.idRuta, c.nombres, c.apellidos;
```

### 5️⃣ Obtener los campers en estado "Expulsado" o "Retirado"
```sql
SELECT c.doc, c.nombres, c.apellidos, e.estado
FROM camper c
JOIN datosCamper dc ON c.doc = dc.docCamper
JOIN estados e ON dc.idEstado = e.id
WHERE e.estado IN ('Expulsado', 'Retirado');
```

### 6️⃣ Listar campers con nivel de riesgo “Alto”
```sql
SELECT c.doc, c.nombres, c.apellidos, nr.nivel
FROM camper c
JOIN datosCamper dc ON c.doc = dc.docCamper
JOIN nivelRiesgo nr ON dc.idNivel = nr.id
WHERE nr.nivel = 'Alto';
```

### 7️⃣ Mostrar el total de campers por cada nivel de riesgo
```sql
SELECT nr.nivel, COUNT(dc.docCamper) AS total_campers 
FROM datosCamper dc
JOIN nivelRiesgo nr ON dc.idNivel = nr.id
GROUP BY nr.nivel;
```

### 8️⃣ Obtener campers con más de un número telefónico registrado
```sql
SELECT c.doc, c.nombres, c.apellidos, COUNT(ct.idTelefono) AS total_telefonos
FROM camper c
JOIN camperTelefonos ct ON c.doc = ct.docCamper
GROUP BY c.doc, c.nombres, c.apellidos
HAVING COUNT(ct.idTelefono) > 1;
```

### 9️⃣ Listar los campers y sus respectivos acudientes y teléfonos
```sql
SELECT c.doc, c.nombres, c.apellidos, 
       a.nombre AS acudiente, a.telefono, 
       t.numero AS telefono_campers
FROM camper c
JOIN datosCamper dc ON c.doc = dc.docCamper
JOIN acudientes a ON dc.docAcu = a.doc
LEFT JOIN camperTelefonos ct ON c.doc = ct.docCamper
LEFT JOIN telefonos t ON ct.idTelefono = t.id;
```

### 🔟 Mostrar campers que aún no han sido asignados a una ruta
```sql
SELECT c.doc, c.nombres, c.apellidos 
FROM camper c
LEFT JOIN inscripciones i ON c.doc = i.docCamper
WHERE i.idRuta IS NULL;
```

