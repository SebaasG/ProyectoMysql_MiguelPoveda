# 🧮 FUNCIONES SQL

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

## 📌 Funciones SQL  

### 1️⃣ Calcular el promedio ponderado de evaluaciones de un camper.  
```sql
DELIMITER //

CREATE FUNCTION calcular_promedio_camper(docCamperParam VARCHAR(12)) 
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE promedio DOUBLE;

    SELECT COALESCE(AVG((proyecto * 0.4) + (examen * 0.35) + (actividades * 0.25)), 0)
    INTO promedio
    FROM evaluaciones
    WHERE docCamper = docCamperParam;

    RETURN promedio;
END //

DELIMITER ;

SELECT calcular_promedio_camper('123456789012');
```
### 2️⃣ Determinar si un camper aprueba o no un módulo específico.  
```sql
DELIMITER //

CREATE FUNCTION camper_aprueba_modulo(docCamperParam VARCHAR(12), idSkillParam INT) 
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE promedio DOUBLE;
    DECLARE resultado VARCHAR(10);

    SELECT COALESCE((proyecto * 0.4) + (examen * 0.35) + (actividades * 0.25), 0)
    INTO promedio
    FROM evaluaciones
    WHERE docCamper = docCamperParam AND idSkill = idSkillParam;

    IF promedio >= 70 THEN
        SET resultado = 'Aprobado';
    ELSE
        SET resultado = 'Reprobado';
    END IF;

    RETURN resultado;
END //

DELIMITER ;

SELECT camper_aprueba_modulo('123456789012', 5);

```
### 3️⃣ Evaluar el nivel de riesgo de un camper según su rendimiento promedio.  
```sql
DELIMITER //

CREATE FUNCTION nivel_riesgo_camper(docCamperParam VARCHAR(12))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE promedio DOUBLE;
    DECLARE riesgo VARCHAR(20);
    SET promedio = calcular_promedio_camper(docCamperParam);
    IF promedio >= 80 THEN
        SET riesgo = 'Bajo';
    ELSEIF promedio >= 60 THEN
        SET riesgo = 'Medio';
    ELSE
        SET riesgo = 'Alto';
    END IF;
    RETURN riesgo;
END //

DELIMITER ;

SELECT nivel_riesgo_camper('123456789012');

```
### 4️⃣ Obtener el total de campers asignados a una ruta específica.  
```sql
DELIMITER //

CREATE FUNCTION total_campers_ruta(idRutaParam INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM inscripciones WHERE idRuta = idRutaParam;
    RETURN total;
END //

DELIMITER ;

SELECT total_campers_ruta(3);

```
### 5️⃣ Consultar la cantidad de módulos que ha aprobado un camper.  
```sql
DELIMITER //

CREATE FUNCTION modulos_aprobados_camper(docCamperParam VARCHAR(12))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM evaluaciones
    WHERE docCamper = docCamperParam 
          AND (proyecto * 0.4 + examen * 0.35 + actividades * 0.25) >= 70;
    RETURN total;
END //

DELIMITER ;

SELECT modulos_aprobados_camper('123456789012');
```
### 6️⃣ Validar si hay cupos disponibles en una determinada área.  
```sql
DELIMITER //

CREATE FUNCTION cupos_disponibles_area(idAreaParam INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE capacidad INT;
    DECLARE ocupados INT;
    DECLARE disponibles INT;
    
    SELECT capacidad INTO capacidad FROM areas WHERE id = idAreaParam;
    SELECT COUNT(*) INTO ocupados FROM usoArea WHERE idArea = idAreaParam;
    
    SET disponibles = capacidad - ocupados;
    RETURN disponibles;
END //

DELIMITER ;

SELECT cupos_disponibles_area(2);


```
### 7️⃣ Calcular el porcentaje de ocupación de un área de entrenamiento.  
```sql
DELIMITER //

CREATE FUNCTION porcentaje_ocupacion_area(idAreaParam INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE capacidad INT;
    DECLARE ocupados INT;
    DECLARE porcentaje DOUBLE;
    
    SELECT capacidad INTO capacidad FROM areas WHERE id = idAreaParam;
    SELECT COUNT(*) INTO ocupados FROM usoArea WHERE idArea = idAreaParam;
    
    IF capacidad > 0 THEN
        SET porcentaje = (ocupados / capacidad) * 100;
    ELSE
        SET porcentaje = 0;
    END IF;
    RETURN porcentaje;
END //

DELIMITER ;

SELECT porcentaje_ocupacion_area(1);

```
### 8️⃣ Determinar la nota más alta obtenida en un módulo.  
```sql
DELIMITER //

CREATE FUNCTION nota_maxima_modulo(idSkillParam INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE maxNota DOUBLE;
    
    SELECT MAX(proyecto * 0.4 + examen * 0.35 + actividades * 0.25) 
    INTO maxNota
    FROM evaluaciones 
    WHERE idSkill = idSkillParam;
    
    RETURN COALESCE(maxNota, 0);
END //

DELIMITER ;

SELECT nota_maxima_modulo(3);

```
### 9️⃣ Calcular la tasa de aprobación de una ruta.  
```sql
DELIMITER //

CREATE FUNCTION tasa_aprobacion_ruta(idRutaParam INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE total INT;
    DECLARE aprobados INT;
    DECLARE tasa DOUBLE;
    
    SELECT COUNT(*) INTO total FROM evaluaciones
    WHERE docCamper IN (SELECT docCamper FROM inscripciones WHERE idRuta = idRutaParam);
    
    SELECT COUNT(*) INTO aprobados FROM evaluaciones
    WHERE docCamper IN (SELECT docCamper FROM inscripciones WHERE idRuta = idRutaParam)
    AND (proyecto * 0.4 + examen * 0.35 + actividades * 0.25) >= 70;
    
    IF total > 0 THEN
        SET tasa = (aprobados / total) * 100;
    ELSE
        SET tasa = 0;
    END IF;
    RETURN tasa;
END //

DELIMITER ;

SELECT tasa_aprobacion_ruta(2);

```
### 🔟 Verificar si un trainer tiene horario disponible.  
```sql
DELIMITER //

CREATE FUNCTION trainer_disponible(docTrainerParam VARCHAR(12), fechaUsoParam DATE, idHorarioParam INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE ocupado INT;
    SELECT COUNT(*) INTO ocupado FROM usoArea
    WHERE docTrainer = docTrainerParam AND fechaUso = fechaUsoParam AND idHorario = idHorarioParam;
    
    IF ocupado > 0 THEN
        RETURN 'Ocupado';
    ELSE
        RETURN 'Disponible';
    END IF;
END //

DELIMITER ;

SELECT trainer_disponible('987654321012', '2024-07-03', 2);

```
### 1️⃣1️⃣ Obtener el promedio de notas por ruta.  
```sql
DELIMITER //

CREATE FUNCTION promedio_notas_ruta(idRutaParam INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE promedio DOUBLE;
    
    SELECT COALESCE(AVG(proyecto * 0.4 + examen * 0.35 + actividades * 0.25), 0)
    INTO promedio
    FROM evaluaciones
    WHERE docCamper IN (SELECT docCamper FROM inscripciones WHERE idRuta = idRutaParam);
    
    RETURN promedio;
END //

DELIMITER ;

SELECT promedio_notas_ruta(1);

```
### 1️⃣2️⃣ Calcular cuántas rutas tiene asignadas un trainer.  
```sql
DELIMITER //

CREATE FUNCTION rutas_asignadas_trainer(docTrainerParam VARCHAR(12))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total FROM rutasTrainer WHERE docTrainer = docTrainerParam;
    
    RETURN total;
END //

DELIMITER ;
SELECT rutas_asignadas_trainer('987654321012');

```
### 1️⃣3️⃣ Verificar si un camper puede ser graduado.  
```sql
DELIMITER //

CREATE FUNCTION camper_puede_graduarse(docCamperParam VARCHAR(12))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE aprobados INT;
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total FROM evaluaciones WHERE docCamper = docCamperParam;
    SELECT COUNT(*) INTO aprobados FROM evaluaciones WHERE docCamper = docCamperParam AND (proyecto * 0.4 + examen * 0.35 + actividades * 0.25) >= 70;
    
    IF total > 0 AND aprobados = total THEN
        RETURN 'Sí';
    ELSE
        RETURN 'No';
    END IF;
END //

DELIMITER ;
```
### 1️⃣4️⃣ Obtener el estado actual de un camper en función de sus evaluaciones.  
```sql
DELIMITER //

CREATE FUNCTION promedio_notas_trainer(docTrainerParam VARCHAR(12))
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE promedio DOUBLE;
    
    SELECT COALESCE(AVG(proyecto * 0.4 + examen * 0.35 + actividades * 0.25), 0)
    INTO promedio
    FROM evaluaciones
    WHERE docCamper IN (SELECT docCamper FROM inscripciones WHERE idRuta IN 
                        (SELECT idRuta FROM rutasTrainer WHERE docTrainer = docTrainerParam));
    
    RETURN promedio;
END //

DELIMITER ;
```
### 1️⃣5️⃣ Calcular la carga horaria semanal de un trainer.  
```sql
DELIMITER //

CREATE FUNCTION areas_usadas_camper(docCamperParam VARCHAR(12))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT idArea) INTO total FROM usoArea WHERE docCamper = docCamperParam;
    
    RETURN total;
END //

DELIMITER ;

```
### 1️⃣6️⃣ Determinar si una ruta tiene módulos pendientes por evaluación.  
```sql
DELIMITER //

CREATE FUNCTION areas_usadas_camper(docCamperParam VARCHAR(12))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT idArea) INTO total FROM usoArea WHERE docCamper = docCamperParam;
    
    RETURN total;
END //

DELIMITER ;

```
### 1️⃣7️⃣ Calcular el promedio general del programa.  
```sql
DELIMITER //

CREATE FUNCTION campers_en_espera()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total FROM campers WHERE estado = 'En espera';
    
    RETURN total;
END //

DELIMITER ;

```
### 1️⃣8️⃣ Verificar si un horario choca con otros entrenadores en el área.  
```sql
DELIMITER //

CREATE FUNCTION trainers_con_rutas()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT docTrainer) INTO total FROM rutasTrainer;
    
    RETURN total;
END //

DELIMITER ;

```
### 1️⃣9️⃣ Calcular cuántos campers están en riesgo en una ruta específica.  
```sql
DELIMITER //

CREATE FUNCTION horario_choca(idHorarioParam INT, idAreaParam INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE existe INT;
    
    SELECT COUNT(*) INTO existe 
    FROM usoArea 
    WHERE idHorario = idHorarioParam AND idArea = idAreaParam;
    
    RETURN existe > 0;
END //

DELIMITER ;

```
### 2️⃣0️⃣ Consultar el número de módulos evaluados por un camper.  
```sql
DELIMITER //

CREATE FUNCTION modulos_evaluados(docCamperParam VARCHAR(12))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT idSkill) INTO total FROM evaluaciones WHERE docCamper = docCamperParam;
    
    RETURN total;
END //

DELIMITER ;

```

