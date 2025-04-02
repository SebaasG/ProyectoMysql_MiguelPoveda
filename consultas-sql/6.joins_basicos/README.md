# 📋 Consultas SQL Avanzadas

## 📂 Otras Categorías

📌 **Campers** → [Ver consultas](../../consultas-sql/1.campers/)  
📌 **Evaluaciones** → [Ver consultas](../../consultas-sql/2.evaluaciones/)  
📌 **Rutas y Áreas** → [Ver consultas](../../consultas-sql/3.rutas_Areas/)  
📌 **Trainers** → [Ver consultas](../../consultas-sql/4.trainers/)  
📌 **Subconsultas** → [Ver consultas](../../consultas-sql/5.SubConsultas/)  
📌 **Joins Basicos** → [Ver consultas](../../consultas-sql/6.joins_basicos/)  
📌 **Joins Específicos** → [Ver consultas](../../consultas-sql/7.Joins_especificos/)  
📌 **Joins Condiciones** → [Ver consultas](../../consultas-sql/8.joins_condiciones/)  
📌 **Procedimientos** → [Ver consultas](../../consultas-sql/9.procedimientos/)  
📌 **Funciones** → [Ver consultas](../../consultas-sql/10.funciones/)  
📌 **Triggers** → [Ver consultas](../../consultas-sql/11.triggers/)   


---  

## 📌 Consultas  

### 1️⃣ Obtener los nombres completos de los campers junto con el nombre de la ruta a la que están inscritos  
```sql
SELECT c.nombres, c.apellidos, r.nombre AS ruta
FROM camper c
JOIN inscripciones i ON c.doc = i.docCamper
JOIN rutas r ON i.idRuta = r.id;
```
### 2️⃣ Mostrar los campers con sus evaluaciones (nota teórica, práctica, quizzes y nota final) por cada módulo  
```sql
SELECT c.nombres, c.apellidos, m.nombre AS modulo, 
       e.examen AS notaTeorica, e.proyecto AS notaPractica, e.actividades AS quizzes, 
       ((e.examen + e.proyecto + e.actividades) / 3) AS notaFinal
FROM evaluaciones e
JOIN camper c ON e.docCamper = c.doc
JOIN skills s ON e.idSkill = s.id
JOIN modulos m ON s.id = m.idSkill;
```
### 3️⃣ Listar todos los módulos que componen cada ruta de entrenamiento  
```sql
SELECT r.nombre AS ruta, m.nombre AS modulo
FROM rutas r
JOIN skills s ON r.id = s.idRuta
JOIN modulos m ON s.id = m.idSkill
ORDER BY r.nombre, m.nombre;
```
### 4️⃣ Consultar las rutas con sus trainers asignados y las áreas en las que imparten clases  
```sql
SELECT r.nombre AS ruta, t.nombres AS trainer, t.apellidos, a.nombre AS area
FROM rutasTrainer rt
JOIN rutas r ON rt.idRuta = r.id
JOIN trainer t ON rt.docTrainer = t.doc
JOIN usoArea ua ON t.doc = ua.docTrainer
JOIN areas a ON ua.idArea = a.id;
```
### 5️⃣ Mostrar los campers junto con el trainer responsable de su ruta actual  
```sql
SELECT c.nombres AS camper, c.apellidos, t.nombres AS trainer, t.apellidos
FROM camper c
JOIN inscripciones i ON c.doc = i.docCamper
JOIN rutas r ON i.idRuta = r.id
JOIN rutasTrainer rt ON r.id = rt.idRuta
JOIN trainer t ON rt.docTrainer = t.doc;
```
### 6️⃣ Obtener el listado de evaluaciones realizadas con nombre de camper, módulo y ruta  
```sql
SELECT c.nombres, c.apellidos, m.nombre AS modulo, r.nombre AS ruta
FROM evaluaciones e
JOIN camper c ON e.docCamper = c.doc
JOIN skills s ON e.idSkill = s.id
JOIN modulos m ON s.id = m.idSkill
JOIN rutas r ON s.idRuta = r.id;
```
### 7️⃣ Listar los trainers y los horarios en que están asignados a las áreas de entrenamiento  
```sql
SELECT t.nombres AS trainer, t.apellidos, h.horaInicio, h.horaFin, a.nombre AS area
FROM usoArea ua
JOIN trainer t ON ua.docTrainer = t.doc
JOIN horarios h ON ua.idHorario = h.id
JOIN areas a ON ua.idArea = a.id
ORDER BY t.nombres, h.horaInicio;
```
### 8️⃣ Consultar todos los campers junto con su estado actual y el nivel de riesgo  
```sql
SELECT c.nombres, c.apellidos, e.estado, nr.nivel AS nivelRiesgo
FROM datosCamper dc
JOIN camper c ON dc.docCamper = c.doc 
JOIN estados e ON dc.idEstado = e.id
JOIN nivelRiesgo nr ON dc.idNivel = nr.id;
```
### 9️⃣ Obtener todos los módulos de cada ruta junto con su porcentaje teórico, práctico y de quizzes  
```sql
SELECT r.nombre AS ruta, m.nombre AS modulo, 
       AVG(e.examen) AS porcentajeTeorico, 
       AVG(e.proyecto) AS porcentajePractico, 
       AVG(e.actividades) AS porcentajeQuizzes
FROM evaluaciones e
JOIN skills s ON e.idSkill = s.id
JOIN modulos m ON s.id = m.idSkill
JOIN rutas r ON s.idRuta = r.id
GROUP BY r.nombre, m.nombre;
```
### 🔟 Mostrar los nombres de las áreas junto con los nombres de los campers que están asistiendo en esos espacios  
```sql
SELECT a.nombre AS area, c.nombres AS camper, c.apellidos
FROM usoArea ua
JOIN areas a ON ua.idArea = a.id
JOIN camper c ON dc.docCamper = c.doc 
JOIN datosCamper dc ON ua.docCamper = dc.docCamper;
```