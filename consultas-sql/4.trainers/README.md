
# 📋 Consultas SQL - Trainers  

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

### 1️⃣ Listar todos los entrenadores registrados  
```sql  
SELECT doc, nombres, apellidos FROM trainer;
```  

### 2️⃣ Mostrar los trainers con sus horarios asignados  
```sql  
SELECT t.doc, t.nombres, t.apellidos, h.horaInicio, h.horaFin 
FROM usoArea ua
JOIN trainer t ON ua.docTrainer = t.doc
JOIN horarios h ON ua.idHorario = h.id;
```  

### 3️⃣ Consultar los trainers asignados a más de una ruta  
```sql  
SELECT t.doc, t.nombres, t.apellidos, COUNT(rt.idRuta) AS rutas_asignadas
FROM rutasTrainer rt
JOIN trainer t ON rt.docTrainer = t.doc
GROUP BY t.doc, t.nombres, t.apellidos
HAVING COUNT(rt.idRuta) > 1;
```  

### 4️⃣ Obtener el número de campers por trainer  
```sql  
SELECT t.doc, t.nombres, t.apellidos, COUNT(gc.docCamper) AS total_campers
FROM trainer t
LEFT JOIN usoArea ua ON t.doc = ua.docTrainer
LEFT JOIN grupoCamper gc ON ua.idGrupo = gc.idGrupo
GROUP BY t.doc, t.nombres, t.apellidos;
```  

### 5️⃣ Mostrar las áreas en las que trabaja cada trainer  
```sql  
SELECT t.doc, t.nombres, t.apellidos, a.nombre AS area
FROM usoArea ua
JOIN trainer t ON ua.docTrainer = t.doc
JOIN areas a ON ua.idArea = a.id
GROUP BY t.doc, t.nombres, t.apellidos, a.nombre; 
```  

### 6️⃣ Listar los trainers sin asignación de área o ruta  
```sql  
SELECT t.doc, t.nombres, t.apellidos
FROM trainer t
LEFT JOIN rutasTrainer rt ON t.doc = rt.docTrainer
LEFT JOIN usoArea ua ON t.doc = ua.docTrainer
WHERE rt.idRuta IS NULL AND ua.idArea IS NULL;
```  

### 7️⃣ Mostrar cuántos módulos están a cargo de cada trainer  
```sql  
SELECT t.doc, t.nombres, t.apellidos, COUNT(m.id) AS total_modulos
FROM trainer t
JOIN usoArea ua ON t.doc = ua.docTrainer
JOIN grupo g ON ua.idGrupo = g.id
JOIN rutas r ON g.idRuta = r.id
JOIN skills s ON r.id = s.idRuta
JOIN modulos m ON s.id = m.idSkill
GROUP BY t.doc, t.nombres, t.apellidos;
```  

### 8️⃣ Obtener el trainer con mejor rendimiento promedio de campers  
```sql  
SELECT t.doc, t.nombres, t.apellidos, AVG((e.proyecto + e.examen + e.actividades) / 3) AS promedio_rendimiento
FROM trainer t
JOIN usoArea ua ON t.doc = ua.docTrainer
JOIN grupoCamper gc ON ua.idGrupo = gc.idGrupo
JOIN evaluaciones e ON gc.docCamper = e.docCamper
GROUP BY t.doc, t.nombres, t.apellidos
ORDER BY promedio_rendimiento DESC
LIMIT 1;
```  

### 9️⃣ Consultar los horarios ocupados por cada trainer  
```sql  
SELECT t.doc, t.nombres, t.apellidos, h.horaInicio, h.horaFin, ua.fechaUso
FROM usoArea ua
JOIN trainer t ON ua.docTrainer = t.doc
JOIN horarios h ON ua.idHorario = h.id
ORDER BY t.doc, ua.fechaUso, h.horaInicio;
```  

### 🔟 Mostrar la disponibilidad semanal de cada trainer  
```sql  
SELECT t.doc, t.nombres, t.apellidos, 
    (SELECT COUNT(*) FROM horarios) - COUNT(ua.idHorario) AS disponibilidad
FROM trainer t
LEFT JOIN usoArea ua ON t.doc = ua.docTrainer
GROUP BY t.doc, t.nombres, t.apellidos;
```  
