# 📋 Consultas SQL Avanzadas

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

### 1️⃣ Obtener los campers con la nota más alta en cada módulo  
```sql
SELECT s.id, s.nombre AS modulo, sc.docCamper, c.nombres, c.apellidos, MAX(sc.calificacion) AS notaMaxima
FROM skillCamper sc
JOIN skills s ON sc.idSkill = s.id
JOIN camper c ON sc.docCamper = c.doc
GROUP BY s.id, sc.docCamper;
```
### 2️⃣ Mostrar el promedio general de notas por ruta y comparar con el promedio global  
```sql
SELECT r.nombre AS ruta, AVG(sc.calificacion) AS promedioRuta,
       (SELECT AVG(calificacion) FROM skillCamper) AS promedioGlobal
FROM skillCamper sc
JOIN skills s ON sc.idSkill = s.id
JOIN rutas r ON s.idRuta = r.id
GROUP BY r.id;
```
### 3️⃣ Listar las áreas con más del 80% de ocupación  
```sql
SELECT a.nombre, a.capacidad, COUNT(u.id) AS ocupacion, 
       (COUNT(u.id) / a.capacidad) * 100 AS porcentajeOcupacion
FROM usoArea u
JOIN areas a ON u.idArea = a.id
GROUP BY a.id
HAVING porcentajeOcupacion > 80;
```
### 4️⃣ Mostrar los trainers con menos del 70% de rendimiento promedio  
```sql
SELECT t.doc, t.nombres, t.apellidos, AVG(sc.calificacion) AS rendimiento
FROM skillCamper sc
JOIN rutasTrainer rt ON sc.idSkill = rt.idRuta
JOIN trainer t ON rt.docTrainer = t.doc
GROUP BY t.doc
HAVING rendimiento < 70;
```
### 5️⃣ Consultar los campers cuyo promedio está por debajo del promedio general  
```sql
SELECT c.doc, c.nombres, c.apellidos, AVG(sc.calificacion) AS promedio
FROM skillCamper sc
JOIN camper c ON sc.docCamper = c.doc
GROUP BY c.doc
HAVING promedio < (SELECT AVG(calificacion) FROM skillCamper);
```
### 6️⃣ Obtener los módulos con la menor tasa de aprobación  
```sql
SELECT s.nombre, COUNT(CASE WHEN sc.calificacion >= 60 THEN 1 END) AS aprobados,
       COUNT(sc.id) AS total,
       (COUNT(CASE WHEN sc.calificacion >= 60 THEN 1 END) / COUNT(sc.id)) * 100 AS tasaAprobacion
FROM skillCamper sc
JOIN skills s ON sc.idSkill = s.id
GROUP BY s.id
ORDER BY tasaAprobacion ASC
LIMIT 5;
```
### 7️⃣ Listar los campers que han aprobado todos los módulos de su ruta  
```sql
SELECT c.doc, c.nombres, c.apellidos
FROM camper c
WHERE NOT EXISTS (
    SELECT 1 FROM skillCamper sc
    WHERE sc.docCamper = c.doc AND sc.calificacion < 60
);
```
### 8️⃣ Mostrar rutas con más de 10 campers en bajo rendimiento  
```sql
SELECT r.nombre, COUNT(c.doc) AS campersBajoRendimiento
FROM skillCamper sc
JOIN camper c ON sc.docCamper = c.doc
JOIN skills s ON sc.idSkill = s.id
JOIN rutas r ON s.idRuta = r.id
WHERE sc.calificacion < 60
GROUP BY r.id
HAVING campersBajoRendimiento > 10;
```
### 9️⃣ Calcular el promedio de rendimiento por SGDB principal  
```sql
SELECT sg.nombre, AVG(sc.calificacion) AS promedioRendimiento
FROM bdAsociadas b
JOIN sgdb sg ON b.idSgdbP = sg.id
JOIN skills s ON b.idRuta = s.idRuta
JOIN skillCamper sc ON s.id = sc.idSkill
GROUP BY sg.id;
```
### 🔟 Listar los módulos con al menos un 30% de campers reprobados  
```sql
SELECT s.nombre, COUNT(CASE WHEN sc.calificacion < 60 THEN 1 END) AS reprobados,
       COUNT(sc.id) AS total,
       (COUNT(CASE WHEN sc.calificacion < 60 THEN 1 END) / COUNT(sc.id)) * 100 AS tasaReprobacion
FROM skillCamper sc
JOIN skills s ON sc.idSkill = s.id
GROUP BY s.id
HAVING tasaReprobacion >= 30;
```
### 1️⃣ Mostrar el módulo más cursado por campers con riesgo alto  
```sql
SELECT m.nombre AS modulo, COUNT(sc.docCamper) AS cantidadCampers
FROM skillCamper sc
JOIN skills s ON sc.idSkill = s.id
JOIN modulos m ON s.id = m.idSkill
JOIN datosCamper dc ON sc.docCamper = dc.docCamper
JOIN nivelRiesgo nr ON dc.idNivel = nr.id
WHERE nr.nivel = 'Alto'
GROUP BY m.id
ORDER BY cantidadCampers DESC
LIMIT 1;
```
### 🔡 Consultar los trainers con más de 3 rutas asignadas  
```sql
SELECT t.doc, t.nombres, t.apellidos, COUNT(rt.idRuta) AS cantidadRutas
FROM trainer t
JOIN rutasTrainer rt ON t.doc = rt.docTrainer
GROUP BY t.doc
HAVING cantidadRutas > 3;
```
### 🔢 Listar los horarios más ocupados por áreas  
```sql
SELECT h.horaInicio, h.horaFin, COUNT(u.idArea) AS vecesOcupado
FROM horarios h
JOIN usoArea u ON h.id = u.idHorario
GROUP BY h.id
ORDER BY vecesOcupado DESC;
```
### 🔣 Consultar las rutas con el mayor número de módulos  
```sql
SELECT r.nombre AS ruta, COUNT(m.id) AS cantidadModulos
FROM rutas r
JOIN skills s ON r.id = s.idRuta
JOIN modulos m ON s.id = m.idSkill
GROUP BY r.id
ORDER BY cantidadModulos DESC;
```
### 🔤 Obtener los campers que han cambiado de estado más de una vez  
```sql
SELECT c.doc, c.nombres, c.apellidos, COUNT(he.id) AS cambiosEstado
FROM camper c
JOIN historialEstados he ON c.doc = he.docCamper
GROUP BY c.doc
HAVING cambiosEstado > 1;
```
### 🔥 Mostrar las evaluaciones donde la nota teórica sea mayor a la práctica  
```sql
SELECT e.id, c.nombres, c.apellidos, e.examen, e.proyecto
FROM evaluaciones e
JOIN camper c ON e.docCamper = c.doc
WHERE e.examen > e.proyecto;
```
### 🔦 Listar los módulos donde la media de quizzes supera el 9  
```sql
SELECT m.nombre AS modulo, AVG(e.actividades) AS promedioQuizzes
FROM evaluaciones e
JOIN skills s ON e.idSkill = s.id
JOIN modulos m ON s.id = m.idSkill
GROUP BY m.id
HAVING promedioQuizzes > 90;
```
### 🔧 Consultar la ruta con mayor tasa de graduación  
```sql
SELECT r.nombre AS ruta, 
       COUNT(e.docCamper) / COUNT(i.docCamper) * 100 AS tasaGraduacion
FROM rutas r
LEFT JOIN inscripciones i ON r.id = i.idRuta
LEFT JOIN egresados e ON r.id = e.idRuta
GROUP BY r.id
ORDER BY tasaGraduacion DESC
LIMIT 1;
```
### 🔨 Mostrar los módulos cursados por campers de nivel de riesgo medio o alto  
```sql
SELECT DISTINCT m.nombre AS modulo
FROM skillCamper sc
JOIN skills s ON sc.idSkill = s.id
JOIN modulos m ON s.id = m.idSkill
JOIN datosCamper dc ON sc.docCamper = dc.docCamper
JOIN nivelRiesgo nr ON dc.idNivel = nr.id
WHERE nr.nivel IN ('Medio', 'Alto');
```
### 🔩 Obtener la diferencia entre capacidad y ocupación en cada área  
```sql
SELECT a.nombre AS area, 
       a.capacidad, 
       (a.capacidad - COUNT(u.id)) AS diferencia
FROM areas a
LEFT JOIN usoArea u ON a.id = u.idArea
GROUP BY a.id;
```

