
# 📋 Consultas SQL - Evaluaciones  

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

### 1️⃣ Obtener las notas teóricas, prácticas y quizzes de cada camper por módulo  
```sql  
SELECT docCamper, idSkill, proyecto AS notaPractica, examen AS notaTeorica, actividades AS notaQuizzes 
FROM evaluaciones; 
```  

### 2️⃣ Calcular la nota final de cada camper por módulo  
```sql  
SELECT 
    docCamper, 
    idSkill, 
    (proyecto * 0.6 + examen * 0.3 + actividades * 0.1) AS notaFinal
FROM evaluaciones;  
```  

### 3️⃣ Mostrar los campers que reprobaron algún módulo (nota < 60)  
```sql  
SELECT 
    e.docCamper, sk.nombre
    idSkill, 
    (e.proyecto * 0.6 + e.examen * 0.3 + e.actividades * 0.1) AS notaFinal
FROM evaluaciones e
INNER JOIN skills sk ON  e.idSkill = sk.id
WHERE (proyecto * 0.6 + examen * 0.3 + actividades * 0.1) < 60;
```  

### 4️⃣ Listar los módulos con más campers en bajo rendimiento  
```sql  
SELECT 
    e.idSkill, sk.nombre,
    AVG(e.proyecto * 0.6 + e.examen * 0.3 + e.actividades * 0.1) AS promedioNotas
FROM evaluaciones e
INNER JOIN skills sk ON  e.idSkill = sk.id
GROUP BY idSkill;
```  

### 5️⃣ Obtener el promedio de notas finales por cada módulo  
```sql  
SELECT 
    idSkill, sk.nombre,
    AVG(proyecto * 0.6 + examen * 0.3 + actividades * 0.1) AS promedioNotas
FROM evaluaciones e
INNER JOIN skills sk ON  e.idSkill = sk.id
GROUP BY idSkill;
```  

### 6️⃣ Consultar el rendimiento general por ruta de entrenamiento  
```sql  
SELECT 
    s.idRuta,  s.nombre,
    AVG(e.proyecto * 0.6 + e.examen * 0.3 + e.actividades * 0.1) AS rendimientoGeneral
FROM evaluaciones e
JOIN skills s ON e.idSkill = s.id
GROUP BY s.idRuta,s.nombre;
```  

### 7️⃣ Mostrar los trainers responsables de campers con bajo rendimiento  
```sql  
SELECT t.nombres, t.apellidos, r.nombre AS ruta, COUNT(e.docCamper) AS campers_reprobados
FROM evaluaciones e
JOIN skills s ON e.idSkill = s.id
JOIN rutas r ON s.idRuta = r.id
JOIN rutasTrainer rt ON r.id = rt.idRuta
JOIN trainer t ON rt.docTrainer = t.doc
WHERE (e.proyecto * 0.6 + e.examen * 0.3 + e.actividades * 0.1) < 60
GROUP BY t.nombres, t.apellidos, r.nombre
ORDER BY campers_reprobados DESC;

```  

### 8️⃣ Comparar el promedio de rendimiento por trainer  
```sql  
SELECT t.nombres, t.apellidos, r.nombre AS ruta,
       AVG(e.proyecto * 0.6 + e.examen * 0.3 + e.actividades * 0.1) AS promedio_rendimiento
FROM evaluaciones e
JOIN skills s ON e.idSkill = s.id
JOIN rutas r ON s.idRuta = r.id
JOIN rutasTrainer rt ON r.id = rt.idRuta
JOIN trainer t ON rt.docTrainer = t.doc
GROUP BY t.nombres, t.apellidos, r.nombre
ORDER BY promedio_rendimiento DESC;
```  

### 9️⃣ Listar los mejores 5 campers por nota final en cada ruta  
```sql  
SELECT *
FROM (
    SELECT 
        e.docCamper, 
        s.idRuta, 
        (e.proyecto * 0.6 + e.examen * 0.3 + e.actividades * 0.1) AS notaFinal,
        RANK() OVER (PARTITION BY s.idRuta ORDER BY (e.proyecto * 0.6 + e.examen * 0.3 + e.actividades * 0.1) DESC) AS ranking
    FROM evaluaciones e
    JOIN skills s ON e.idSkill = s.id
) AS ranked
WHERE ranking <= 5;
```  

### 🔟 Mostrar cuántos campers pasaron cada módulo por ruta  
```sql  
SELECT 
    s.idRuta, 
    e.idSkill, 
    COUNT(*) AS campersAprobados
FROM evaluaciones e
JOIN skills s ON e.idSkill = s.id
WHERE (e.proyecto * 0.6 + e.examen * 0.3 + e.actividades * 0.1) >= 60
GROUP BY s.idRuta, e.idSkill;

```  


