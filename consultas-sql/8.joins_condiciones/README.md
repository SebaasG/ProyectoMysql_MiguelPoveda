# 📋 JOINs con Funciones de Agregación

## 📂 Otras Categorías

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

---  

## 📌 Consultas  

### 1️⃣ Obtener el promedio de nota final por módulo.  
```sql
SELECT m.nombre AS modulo, 
       AVG((e.proyecto + e.examen + e.actividades) / 3) AS promedio_nota_final
FROM evaluaciones e
JOIN skills s ON e.idSkill = s.id
JOIN modulos m ON s.id = m.idSkill
GROUP BY m.nombre;
```
### 2️⃣ Calcular la cantidad total de campers por ruta.  
```sql
SELECT r.nombre AS ruta, COUNT(i.docCamper) AS total_campers
FROM rutas r
LEFT JOIN inscripciones i ON r.id = i.idRuta
GROUP BY r.nombre;

```
### 3️⃣ Mostrar la cantidad de evaluaciones realizadas por cada trainer (según las rutas que imparte).  
```sql
SELECT t.nombres, t.apellidos, COUNT(e.id) AS total_evaluaciones
FROM trainer t
JOIN rutasTrainer rt ON t.doc = rt.docTrainer
JOIN rutas r ON rt.idRuta = r.id
JOIN skills s ON r.id = s.idRuta
JOIN evaluaciones e ON s.id = e.idSkill
GROUP BY t.nombres, t.apellidos;
```
### 4️⃣ Consultar el promedio general de rendimiento por cada área de entrenamiento.  
```sql
SELECT a.nombre AS area, 
       AVG((e.proyecto + e.examen + e.actividades) / 3) AS promedio_rendimiento
FROM usoArea ua
JOIN areas a ON ua.idArea = a.id
JOIN grupo g ON ua.idGrupo = g.id
JOIN inscripciones i ON g.idRuta = i.idRuta
JOIN evaluaciones e ON i.docCamper = e.docCamper
GROUP BY a.nombre;
```
### 5️⃣ Obtener la cantidad de módulos asociados a cada ruta de entrenamiento.  
```sql
SELECT r.nombre AS ruta, COUNT(m.id) AS total_modulos
FROM rutas r
JOIN skills s ON r.id = s.idRuta
JOIN modulos m ON s.id = m.idSkill
GROUP BY r.nombre;
```
### 6️⃣ Mostrar el promedio de nota final de los campers en estado “Cursando”.  
```sql
SELECT AVG((e.proyecto + e.examen + e.actividades) / 3) AS promedio_nota_cursando
FROM evaluaciones e
JOIN datosCamper dc ON e.docCamper = dc.docCamper
JOIN estados est ON dc.idEstado = est.id
WHERE est.estado = 'Cursando';
```
### 7️⃣ Listar el número de campers evaluados en cada módulo.  
```sql
SELECT m.nombre AS modulo, COUNT(e.docCamper) AS total_evaluados
FROM evaluaciones e
JOIN skills s ON e.idSkill = s.id
JOIN modulos m ON s.id = m.idSkill
GROUP BY m.nombre;
```
### 8️⃣ Consultar el porcentaje de ocupación actual por cada área de entrenamiento.  
```sql

       (COUNT(ua.id) * 100.0 / a.capacidad) AS porcentaje_ocupacion
FROM areas a
LEFT JOIN usoArea ua ON a.id = ua.idArea
GROUP BY a.nombre, a.capacidad;
```
### 9️⃣ Mostrar cuántos trainers tiene asignados cada área.  
```sql
SELECT a.nombre AS area, COUNT(DISTINCT ua.docTrainer) AS total_trainers
FROM usoArea ua
JOIN areas a ON ua.idArea = a.id
GROUP BY a.nombre;
```
### 🔟 Listar las rutas que tienen más campers en riesgo alto.  
```sql
SELECT r.nombre AS ruta, COUNT(dc.docCamper) AS total_campers_riesgo
FROM rutas r
JOIN inscripciones i ON r.id = i.idRuta
JOIN datosCamper dc ON i.docCamper = dc.docCamper
JOIN nivelRiesgo nr ON dc.idNivel = nr.id
WHERE nr.nivel = 'Alto Riesgo'
GROUP BY r.nombre
ORDER BY total_campers_riesgo DESC;
```