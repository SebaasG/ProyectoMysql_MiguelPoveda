
# 📋 Consultas SQL - Rutas y Áreas  

## 📂 Otras Categorías  

📌 **Campers** → [Ver consultas](../../consultas-sql/consultas-sql/1.campers/)  
📌 **Evaluaciones** → [Ver consultas](../../consultas-sql/2.evaluaciones/)  
📌 **Rutas y Áreas** → [Ver consultas](../../consultas-sql/3.rutas_Areas/)  
📌 **Trainers** → [Ver consultas](../../consultas-sql/4.trainers/)  
📌 **Subconsultas** → [Ver consultas](../../consultas-sql/5.SubConsultas/)  
📌 **Joins Específicos** → [Ver consultas](../../consultas-sql/7.Joins_específicos/)  
📌 **Joins Condiciones** → [Ver consultas](../../consultas-sql/8.joins_condiciones/)  
📌 **Joins Funciones** → [Ver consultas](../../consultas-sql/9.joins_Funciones/)  
📌 **Procedimientos** → [Ver consultas](../../consultas-sql/10.procedimientos/)  
📌 **Funciones** → [Ver consultas](../../consultas-sql/11.funciones/)  
📌 **Triggers** → [Ver consultas](../../consultas-sql/12.triggers/) 

---  

## 📌 Consultas  

### 1️⃣ Mostrar todas las rutas de entrenamiento disponibles  
```sql  
SELECT id, nombre FROM rutas;
```  

### 2️⃣ Obtener las rutas con su SGDB principal y alternativo  
```sql  
SELECT r.nombre AS ruta, sgp.nombre AS sgdb_principal, sga.nombre AS sgdb_alternativo
FROM bdAsociadas b
JOIN rutas r ON b.idRuta = r.id
JOIN sgdb sgp ON b.idSgdbP = sgp.id
JOIN sgdb sga ON b.idSgdbA = sga.id;
```  

### 3️⃣ Listar los módulos asociados a cada ruta  
```sql  
SELECT r.nombre AS ruta, COUNT(i.docCamper) AS total_campers
FROM rutas r
LEFT JOIN inscripciones i ON r.id = i.idRuta
GROUP BY r.nombre;
```  

### 4️⃣ Consultar cuántos campers hay en cada ruta  
```sql  
SELECT nombre, capacidad FROM areas; 
```  

### 5️⃣ Mostrar las áreas de entrenamiento y su capacidad máxima  
```sql  
SELECT nombre, capacidad FROM areas;
```  

### 6️⃣ Obtener las áreas que están ocupadas al 100%  
```sql  
SELECT a.nombre AS area, a.capacidad, COUNT(gc.docCamper) AS ocupacion_actual
FROM areas a
JOIN usoArea ua ON a.id = ua.idArea
JOIN grupo g ON ua.idGrupo = g.id
JOIN grupoCamper gc ON g.id = gc.idGrupo
GROUP BY a.id
HAVING COUNT(gc.docCamper) >= a.capacidad;
```  

### 7️⃣ Verificar la ocupación actual de cada área  
```sql  
SELECT a.nombre AS area, COUNT(gc.docCamper) AS ocupacion_actual, a.capacidad
FROM areas a
LEFT JOIN usoArea ua ON a.id = ua.idArea
LEFT JOIN grupo g ON ua.idGrupo = g.id
LEFT JOIN grupoCamper gc ON g.id = gc.idGrupo
GROUP BY a.id;
```  

### 8️⃣ Consultar los horarios disponibles por cada área  
```sql  
SELECT h.id AS id_horario, h.horaInicio, h.horaFin, a.nombre AS area
FROM horarios h
LEFT JOIN usoArea ua ON h.id = ua.idHorario
LEFT JOIN areas a ON ua.idArea = a.id
WHERE ua.id IS NULL OR a.estado = 'Disponible';
```  

### 9️⃣ Mostrar las áreas con más campers asignados  
```sql  
SELECT a.nombre AS area, COUNT(gc.docCamper) AS total_campers
FROM areas a
JOIN usoArea ua ON a.id = ua.idArea
JOIN grupo g ON ua.idGrupo = g.id
JOIN grupoCamper gc ON g.id = gc.idGrupo
GROUP BY a.id
ORDER BY total_campers DESC
LIMIT 5;
```  

### 🔟 Listar las rutas con sus respectivos trainers y áreas asignadas  
```sql  
SELECT r.nombre AS ruta, t.nombres AS trainer, a.nombre AS area
FROM rutas r
JOIN rutasTrainer rt ON r.id = rt.idRuta
JOIN trainer t ON rt.docTrainer = t.doc
JOIN usoArea ua ON t.doc = ua.docTrainer
JOIN areas a ON ua.idArea = a.id;
```  
```  

