Aquí tienes los **procedimientos almacenados** para cada una de las operaciones en **MySQL**.  

---

## **1. Registrar un nuevo camper**
```sql
DELIMITER //

CREATE PROCEDURE registrarCamper(
    IN p_docCamper VARCHAR(20),
    IN p_nombres VARCHAR(50),
    IN p_apellidos VARCHAR(50),
    IN p_edad INT,
    IN p_telefono VARCHAR(15),
    IN p_direccion VARCHAR(100)
)
BEGIN
    DECLARE v_estado INT;
    
    -- Obtener el ID del estado inicial "Preinscrito"
    SELECT id INTO v_estado FROM estados WHERE estado = 'Preinscrito' LIMIT 1;
    
    -- Insertar nuevo camper
    INSERT INTO datosCamper (docCamper, nombres, apellidos, edad, telefono, direccion, idEstado) 
    VALUES (p_docCamper, p_nombres, p_apellidos, p_edad, p_telefono, p_direccion, v_estado);
END //

DELIMITER ;
```

📌 **Uso:**  
```sql
CALL registrarCamper('123456789', 'Juan', 'Pérez', 18, '3001234567', 'Calle 123');
```

---

## **2. Actualizar estado del camper**
```sql
DELIMITER //

CREATE PROCEDURE actualizarEstadoCamper(
    IN p_docCamper VARCHAR(20),
    IN p_nuevoEstado VARCHAR(50)
)
BEGIN
    DECLARE v_idEstado INT;

    -- Obtener el ID del nuevo estado
    SELECT id INTO v_idEstado FROM estados WHERE estado = p_nuevoEstado LIMIT 1;
    
    -- Actualizar estado del camper
    UPDATE datosCamper SET idEstado = v_idEstado WHERE docCamper = p_docCamper;
END //

DELIMITER ;
```

📌 **Uso:**  
```sql
CALL actualizarEstadoCamper('123456789', 'Cursando');
```

---

## **3. Inscribir un camper en una ruta**
```sql
DELIMITER //

CREATE PROCEDURE inscribirCamperRuta(
    IN p_docCamper VARCHAR(20),
    IN p_nombreRuta VARCHAR(50)
)
BEGIN
    DECLARE v_idRuta INT;
    
    -- Obtener ID de la ruta
    SELECT id INTO v_idRuta FROM rutas WHERE nombre = p_nombreRuta LIMIT 1;
    
    -- Insertar inscripción
    INSERT INTO inscripciones (docCamper, idRuta, fechaInscripcion) 
    VALUES (p_docCamper, v_idRuta, NOW());
END //

DELIMITER ;
```

📌 **Uso:**  
```sql
CALL inscribirCamperRuta('123456789', 'FullStack JavaScript');
```

---

## **4. Registrar una evaluación completa**
```sql
DELIMITER //

CREATE PROCEDURE registrarEvaluacion(
    IN p_docCamper VARCHAR(20),
    IN p_idSkill INT,
    IN p_proyecto DECIMAL(5,2),
    IN p_examen DECIMAL(5,2),
    IN p_actividades DECIMAL(5,2)
)
BEGIN
    -- Insertar evaluación
    INSERT INTO evaluaciones (docCamper, idSkill, proyecto, examen, actividades) 
    VALUES (p_docCamper, p_idSkill, p_proyecto, p_examen, p_actividades);
END //

DELIMITER ;
```

📌 **Uso:**  
```sql
CALL registrarEvaluacion('123456789', 5, 85, 90, 80);
```

---

## **5. Calcular y registrar automáticamente la nota final de un módulo**
```sql
DELIMITER //

CREATE PROCEDURE calcularNotaFinal(
    IN p_docCamper VARCHAR(20),
    IN p_idSkill INT
)
BEGIN
    DECLARE v_proyecto DECIMAL(5,2);
    DECLARE v_examen DECIMAL(5,2);
    DECLARE v_actividades DECIMAL(5,2);
    DECLARE v_notaFinal DECIMAL(5,2);

    -- Obtener las calificaciones
    SELECT proyecto, examen, actividades INTO v_proyecto, v_examen, v_actividades
    FROM evaluaciones 
    WHERE docCamper = p_docCamper AND idSkill = p_idSkill;
    
    -- Calcular nota final
    SET v_notaFinal = (v_proyecto * 0.4 + v_examen * 0.4 + v_actividades * 0.2);
    
    -- Actualizar la nota final en la evaluación
    UPDATE evaluaciones 
    SET notaFinal = v_notaFinal 
    WHERE docCamper = p_docCamper AND idSkill = p_idSkill;
END //

DELIMITER ;
```

📌 **Uso:**  
```sql
CALL calcularNotaFinal('123456789', 5);
```

---

## **6. Asignar campers aprobados a una ruta disponible**
```sql
DELIMITER //

CREATE PROCEDURE asignarCampersAprobados()
BEGIN
    INSERT INTO inscripciones (docCamper, idRuta, fechaInscripcion)
    SELECT e.docCamper, r.id, NOW()
    FROM evaluaciones e
    JOIN skills s ON e.idSkill = s.id
    JOIN rutas r ON s.idRuta = r.id
    WHERE e.notaFinal >= 70
    AND r.capacidad > (SELECT COUNT(*) FROM inscripciones WHERE idRuta = r.id);
END //

DELIMITER ;
```

📌 **Uso:**  
```sql
CALL asignarCampersAprobados();
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

📌 **Uso:**  
```sql
CALL asignarTrainer('987654321', 3, '08:00 - 12:00');
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

📌 **Uso:**  
```sql
CALL registrarRuta('Data Science', 2);
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

📌 **Uso:**  
```sql
CALL registrarArea('Laboratorio de IA', 20, '08:00 - 14:00');
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

📌 **Uso:**  
```sql
CALL consultarDisponibilidadArea('Laboratorio de IA');
```

---

Esto es solo una parte, ¿quieres que continúe con los demás? 🚀