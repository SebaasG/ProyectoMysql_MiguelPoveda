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

## **1. Registrar un nuevo camper**
```sql
DELIMITER //
CREATE PROCEDURE registrar_camper(
    IN doc VARCHAR(12),
    IN nombres VARCHAR(45),
    IN apellidos VARCHAR(45),
    IN docAcu VARCHAR(12),
    IN idEstado INT,
    IN direccion VARCHAR(120),
    IN idNivel INT,
    IN idSede INT
)
BEGIN
    INSERT INTO camper (doc, nombres, apellidos) 
    VALUES (doc, nombres, apellidos);

    INSERT INTO datosCamper (docCamper, docAcu, idEstado, direccion, idNivel, idSede)
    VALUES (doc, docAcu, idEstado, direccion, idNivel, idSede);
END //
DELIMITER ;
```


---

## **2. Actualizar estado del camper**
```sql

DELIMITER //
CREATE PROCEDURE actualizar_estado_camper(
    IN docCamper VARCHAR(12),
    IN nuevoEstado INT
)
BEGIN
    UPDATE datosCamper 
    SET idEstado = nuevoEstado 
    WHERE docCamper = docCamper;

    INSERT INTO historialEstados (docCamper, idEstado, fechaCambio)
    VALUES (docCamper, nuevoEstado, CURDATE());
END //
DELIMITER ;
```


---

## **3. Inscribir un camper en una ruta**
```sql
DELIMITER //
CREATE PROCEDURE inscribir_camper(
    IN docCamper VARCHAR(12),
    IN idRuta INT
)
BEGIN
    INSERT INTO inscripciones (docCamper, idRuta) 
    VALUES (docCamper, idRuta);
END //
DELIMITER ;

```

---

## **4. Registrar una evaluación completa**
```sql
DELIMITER //
CREATE PROCEDURE registrar_evaluacion(
    IN idSkill INT,
    IN docCamper VARCHAR(12),
    IN proyecto DOUBLE,
    IN examen DOUBLE,
    IN actividades DOUBLE
)
BEGIN
    INSERT INTO evaluaciones (idSkill, docCamper, proyecto, examen, actividades)
    VALUES (idSkill, docCamper, proyecto, examen, actividades);
END //
DELIMITER ;

```

---

## **5. Calcular y registrar automáticamente la nota final de un módulo**
```sql
DELIMITER //
CREATE PROCEDURE calcular_nota_final(
    IN idSkill INT,
    IN docCamper VARCHAR(12)
)
BEGIN
    DECLARE notaFinal DOUBLE;

    SELECT (proyecto * 0.4 + examen * 0.4 + actividades * 0.2) 
    INTO notaFinal 
    FROM evaluaciones 
    WHERE idSkill = idSkill AND docCamper = docCamper;

    UPDATE skillCamper 
    SET calificacion = notaFinal 
    WHERE idSkill = idSkill AND docCamper = docCamper;
END //
DELIMITER ;
```

---

## **6. Asignar campers aprobados a una ruta disponible**
```sql
DELIMITER //
CREATE PROCEDURE asignar_ruta_a_camper(
    IN docCamper VARCHAR(12),
    IN idRuta INT
)
BEGIN
    UPDATE inscripciones 
    SET idRuta = idRuta 
    WHERE docCamper = docCamper;
END //
DELIMITER ;
```

---

## **7. Asignar trainer a ruta y área validando horario**
```sql
DELIMITER //

CREATE PROCEDURE asignarTrainer(
    IN p_docTrainer VARCHAR(20),
    IN p_idArea INT,
    IN p_horario VARCHAR(20)
)
BEGIN
    -- Verificar disponibilidad del horario
    IF NOT EXISTS (SELECT 1 FROM usoArea WHERE docTrainer = p_docTrainer AND horario = p_horario) THEN
        INSERT INTO usoArea (idArea, docTrainer, horario) VALUES (p_idArea, p_docTrainer, p_horario);
    END IF;
END //

DELIMITER ;
```

---

## **8. Registrar nueva ruta con sus módulos**
```sql
DELIMITER //

CREATE PROCEDURE registrarRuta(
    IN p_nombreRuta VARCHAR(50),
    IN p_idSGDB INT
)
BEGIN
    INSERT INTO rutas (nombre, idSGDB) VALUES (p_nombreRuta, p_idSGDB);
END //

DELIMITER ;
```

---

## **9. Registrar nueva área de entrenamiento**
```sql
DELIMITER //

CREATE PROCEDURE registrarArea(
    IN p_nombre VARCHAR(50),
    IN p_capacidad INT,
    IN p_horario VARCHAR(20)
)
BEGIN
    INSERT INTO areas (nombre, capacidad, horario) VALUES (p_nombre, p_capacidad, p_horario);
END //

DELIMITER ;
```

---

## **10. Consultar disponibilidad de un área**
```sql
DELIMITER //

CREATE PROCEDURE consultarDisponibilidadArea(IN p_nombreArea VARCHAR(50))
BEGIN
    SELECT a.nombre, a.capacidad - COUNT(ua.id) AS cupos_disponibles
    FROM areas a
    LEFT JOIN usoArea ua ON a.id = ua.idArea
    WHERE a.nombre = p_nombreArea
    GROUP BY a.nombre, a.capacidad;
END //

DELIMITER ;
```


---

## **11. Reasignar a un camper a otra ruta en caso de bajo rendimiento**
```sql
DELIMITER //

CREATE PROCEDURE reasignarCamper(
    IN p_docCamper VARCHAR(20),
    IN p_nuevaRuta VARCHAR(50)
)
BEGIN
    DECLARE v_idNuevaRuta INT;

    -- Obtener ID de la nueva ruta
    SELECT id INTO v_idNuevaRuta FROM rutas WHERE nombre = p_nuevaRuta LIMIT 1;

    -- Actualizar la inscripción del camper a la nueva ruta
    UPDATE inscripciones 
    SET idRuta = v_idNuevaRuta, fechaInscripcion = NOW() 
    WHERE docCamper = p_docCamper;
END //

DELIMITER ;
```

---

## **12. Cambiar el estado de un camper a "Graduado" al finalizar todos los módulos**
```sql
DELIMITER //

CREATE PROCEDURE graduarCamper(IN p_docCamper VARCHAR(20))
BEGIN
    DECLARE v_totalModulos INT;
    DECLARE v_modulosAprobados INT;

    -- Contar los módulos requeridos en la ruta del camper
    SELECT COUNT(*) INTO v_totalModulos 
    FROM modulos 
    WHERE idRuta = (SELECT idRuta FROM inscripciones WHERE docCamper = p_docCamper);

    -- Contar los módulos aprobados por el camper
    SELECT COUNT(*) INTO v_modulosAprobados 
    FROM evaluaciones 
    WHERE docCamper = p_docCamper AND notaFinal >= 70;

    -- Si aprobó todos los módulos, actualizar su estado a "Graduado"
    IF v_modulosAprobados = v_totalModulos THEN
        UPDATE datosCamper 
        SET idEstado = (SELECT id FROM estados WHERE estado = 'Graduado') 
        WHERE docCamper = p_docCamper;
    END IF;
END //

DELIMITER ;
```

---

## **13. Consultar y exportar todos los datos de rendimiento de un camper**
```sql
DELIMITER //

CREATE PROCEDURE consultarRendimientoCamper(IN p_docCamper VARCHAR(20))
BEGIN
    SELECT e.docCamper, c.nombres, c.apellidos, s.nombre AS skill, e.proyecto, e.examen, e.actividades, e.notaFinal
    FROM evaluaciones e
    JOIN datosCamper c ON e.docCamper = c.docCamper
    JOIN skills s ON e.idSkill = s.id
    WHERE e.docCamper = p_docCamper;
END //

DELIMITER ;
```

## **14. Registrar la asistencia a clases por área y horario**
```sql
DELIMITER //

CREATE PROCEDURE registrarAsistencia(
    IN p_docCamper VARCHAR(20),
    IN p_idArea INT,
    IN p_fecha DATE,
    IN p_horario VARCHAR(20)
)
BEGIN
    INSERT INTO asistencias (docCamper, idArea, fecha, horario)
    VALUES (p_docCamper, p_idArea, p_fecha, p_horario);
END //

DELIMITER ;
```

---

## **15. Generar reporte mensual de notas por ruta**
```sql
DELIMITER //

CREATE PROCEDURE reporteNotasRuta(
    IN p_nombreRuta VARCHAR(50),
    IN p_mes INT,
    IN p_anio INT
)
BEGIN
    SELECT c.docCamper, c.nombres, c.apellidos, s.nombre AS skill, e.notaFinal
    FROM evaluaciones e
    JOIN datosCamper c ON e.docCamper = c.docCamper
    JOIN skills s ON e.idSkill = s.id
    JOIN inscripciones i ON c.docCamper = i.docCamper
    JOIN rutas r ON i.idRuta = r.id
    WHERE r.nombre = p_nombreRuta
    AND MONTH(e.fechaEvaluacion) = p_mes
    AND YEAR(e.fechaEvaluacion) = p_anio;
END //

DELIMITER ;
```
---

## **16. Validar y registrar la asignación de un salón a una ruta sin exceder la capacidad**
```sql
DELIMITER //

CREATE PROCEDURE asignarSalon(
    IN p_idRuta INT,
    IN p_idSalon INT
)
BEGIN
    DECLARE v_capacidadSalon INT;
    DECLARE v_inscritos INT;

    -- Obtener la capacidad del salón
    SELECT capacidad INTO v_capacidadSalon FROM salones WHERE id = p_idSalon;

    -- Contar campers inscritos en la ruta
    SELECT COUNT(*) INTO v_inscritos FROM inscripciones WHERE idRuta = p_idRuta;

    -- Validar capacidad antes de asignar el salón
    IF v_inscritos <= v_capacidadSalon THEN
        UPDATE rutas SET idSalon = p_idSalon WHERE id = p_idRuta;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Capacidad del salón excedida';
    END IF;
END //

DELIMITER ;
```

---

## **17. Registrar cambio de horario de un trainer**
```sql
DELIMITER //

CREATE PROCEDURE cambiarHorarioTrainer(
    IN p_docTrainer VARCHAR(20),
    IN p_nuevoHorario VARCHAR(20)
)
BEGIN
    UPDATE usoArea SET horario = p_nuevoHorario WHERE docTrainer = p_docTrainer;
END //

DELIMITER ;
```


---

## **18. Eliminar la inscripción de un camper a una ruta (en caso de retiro)**
```sql
DELIMITER //

CREATE PROCEDURE eliminarInscripcion(
    IN p_docCamper VARCHAR(20)
)
BEGIN
    DELETE FROM inscripciones WHERE docCamper = p_docCamper;
END //

DELIMITER ;
```

---

## **19. Recalcular el estado de todos los campers según su rendimiento acumulado**
```sql
DELIMITER //

CREATE PROCEDURE recalcularEstadoCampers()
BEGIN
    UPDATE datosCamper c
    SET c.idEstado = CASE 
        WHEN (SELECT AVG(notaFinal) FROM evaluaciones WHERE docCamper = c.docCamper) >= 70 THEN 
            (SELECT id FROM estados WHERE estado = 'Aprobado')
        ELSE 
            (SELECT id FROM estados WHERE estado = 'Reprobado')
    END;
END //

DELIMITER ;
```
---

## **20. Asignar horarios automáticamente a trainers disponibles según sus áreas**
```sql
DELIMITER //

CREATE PROCEDURE asignarHorariosAutom(
    IN p_idArea INT
)
BEGIN
    UPDATE usoArea
    SET horario = (SELECT horario FROM horariosDisponibles WHERE idArea = p_idArea LIMIT 1)
    WHERE idArea = p_idArea AND horario IS NULL;
END //

DELIMITER ;
```

