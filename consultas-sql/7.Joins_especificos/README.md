# 📋 JOINs con Condiciones Específicas

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

### 1️⃣ Listar los campers que han aprobado todos los módulos de su ruta (nota_final >= 60).  
```sql
SELECT c.doc, c.nombres, c.apellidos, r.nombre AS ruta
FROM camper c
JOIN inscripciones i ON c.doc = i.docCamper
JOIN rutas r ON i.idRuta = r.id
WHERE NOT EXISTS (
    SELECT 1 FROM skillCamper sc
    JOIN skills s ON sc.idSkill = s.id
    WHERE sc.docCamper = c.doc AND sc.calificacion < 60
);
```
### 2️⃣ Mostrar las rutas que tienen más de 10 campers inscritos actualmente.  
```sql
SELECT r.id, r.nombre, COUNT(i.docCamper) AS total_inscritos
FROM rutas r
JOIN inscripciones i ON r.id = i.idRuta
GROUP BY r.id, r.nombre
HAVING COUNT(i.docCamper) > 10;
```
### 3️⃣ Consultar las áreas que superan el 80% de su capacidad con el número actual de campers asignados.  
```sql
SELECT a.id, a.nombre, a.capacidad, COUNT(gc.docCamper) AS campers_asignados,
       (COUNT(gc.docCamper) / a.capacidad) * 100 AS porcentaje_ocupacion
FROM areas a
JOIN usoArea ua ON a.id = ua.idArea
JOIN grupo g ON ua.idGrupo = g.id
JOIN grupoCamper gc ON g.id = gc.idGrupo
GROUP BY a.id, a.nombre, a.capacidad
HAVING porcentaje_ocupacion > 80;
```
### 4️⃣ Obtener los trainers que imparten más de una ruta diferente.  
```sql
SELECT t.doc, t.nombres, t.apellidos, COUNT(DISTINCT rt.idRuta) AS total_rutas
FROM trainer t
JOIN rutasTrainer rt ON t.doc = rt.docTrainer
GROUP BY t.doc, t.nombres, t.apellidos
HAVING total_rutas > 1;
```
### 5️⃣ Listar las evaluaciones donde la nota práctica es mayor que la nota teórica.  
```sql
SELECT e.id, c.nombres, c.apellidos, s.nombre AS skill, 
       e.proyecto AS nota_practica, e.examen AS nota_teorica
FROM evaluaciones e
JOIN camper c ON e.docCamper = c.doc
JOIN skills s ON e.idSkill = s.id
WHERE e.proyecto > e.examen;
```
### 6️⃣ Mostrar campers que están en rutas cuyo SGDB principal es MySQL.  
```sql
SELECT DISTINCT c.doc, c.nombres, c.apellidos, r.nombre AS ruta, s.nombre AS sgdb
FROM camper c
JOIN inscripciones i ON c.doc = i.docCamper
JOIN rutas r ON i.idRuta = r.id
JOIN bdAsociadas b ON r.id = b.idRuta
JOIN sgdb s ON b.idSgdbP = s.id
WHERE s.nombre = 'MySQL';
```
### 7️⃣ Obtener los nombres de los módulos donde los campers han tenido bajo rendimiento.  
```sql
SELECT DISTINCT m.nombre AS modulo, s.nombre AS skill, r.nombre AS ruta
FROM skillCamper sc
JOIN skills s ON sc.idSkill = s.id
JOIN modulos m ON s.id = m.idSkill
JOIN rutas r ON s.idRuta = r.id
WHERE sc.calificacion < 70;
```
### 8️⃣ Consultar las rutas con más de 3 módulos asociados.  
```sql
SELECT r.id, r.nombre, COUNT(m.id) AS total_modulos
FROM rutas r
JOIN skills s ON r.id = s.idRuta
JOIN modulos m ON s.id = m.idSkill
GROUP BY r.id, r.nombre
HAVING total_modulos > 3;
```
### 9️⃣ Listar las inscripciones realizadas en los últimos 30 días con sus respectivos campers y rutas.  
```sql
SELECT i.id, c.nombres, c.apellidos, r.nombre AS ruta, i.idRuta, i.docCamper, i.id
FROM inscripciones i
JOIN camper c ON i.docCamper = c.doc
JOIN rutas r ON i.idRuta = r.id
WHERE i.id IN (
    SELECT id FROM inscripciones 
    WHERE DATEDIFF(CURDATE(), (SELECT MAX(fechaCambio) FROM historialEstados WHERE docCamper = i.docCamper)) <= 30
);
```
### 🔢 Obtener los trainers que están asignados a rutas con campers en estado de “Alto Riesgo”.  
```sql
SELECT DISTINCT t.nombres, t.apellidos, r.nombre AS ruta, nr.nivel AS nivel_riesgo
FROM trainer t
JOIN rutasTrainer rt ON t.doc = rt.docTrainer
JOIN rutas r ON rt.idRuta = r.id
JOIN inscripciones i ON r.id = i.idRuta
JOIN datosCamper dc ON i.docCamper = dc.docCamper
JOIN nivelRiesgo nr ON dc.idNivel = nr.id
WHERE nr.nivel = 'Alto Riesgo';
```