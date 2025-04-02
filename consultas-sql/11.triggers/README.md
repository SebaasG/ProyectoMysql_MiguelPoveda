# 🔥 Triggers en SQL  

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

## 📌 Triggers  

### 1️⃣ Al insertar una evaluación, calcular automáticamente la nota final  
```sql  
DELIMITER //
    CREATE TRIGGER calcular_nota_final
    AFTER INSERT ON evaluaciones
    FOR EACH ROW
    BEGIN
        -- Calculamos el promedio ponderado (30% proyecto, 40% examen, 30% actividades)
        DECLARE nota_final DOUBLE;
        SET nota_final = (NEW.proyecto * 0.3) + (NEW.examen * 0.4) + (NEW.actividades * 0.3);
        
        -- Actualizamos el skillCamper con la nota final calculada
        UPDATE skillCamper      
        SET calificacion = nota_final 
        WHERE idSkill = NEW.idSkill AND docCamper = NEW.docCamper;
    END//
    DELIMITER ;  
```  

### 2️⃣ Al actualizar la nota final de un módulo, verificar si el camper aprueba o reprueba  
```sql  
DELIMITER //
    CREATE TRIGGER verificar_aprobacion
    AFTER UPDATE ON skillCamper
    FOR EACH ROW
    BEGIN
        IF NEW.calificacion >= 60 THEN
            UPDATE skillCamper 
            SET estado = 'Aprobado' 
            WHERE id = NEW.id;
        ELSE
            UPDATE skillCamper 
            SET estado = 'Reprobado' 
            WHERE id = NEW.id;
        END IF;
    END//
DELIMITER ;
```  

### 3️⃣ Al insertar una inscripción, cambiar el estado del camper a "Inscrito"  
```sql  
DELIMITER //
    CREATE TRIGGER cambiar_estado_inscrito
    AFTER INSERT ON inscripciones
    FOR EACH ROW
    BEGIN
        DECLARE id_estado_inscrito INT;
        
        -- Obtenemos el ID del estado "Inscrito"
        SELECT id INTO id_estado_inscrito FROM estados WHERE estado = 'Inscrito' LIMIT 1;
        
        -- Actualizamos el estado del camper
        UPDATE datosCamper 
        SET idEstado = id_estado_inscrito 
        WHERE docCamper = NEW.docCamper;
        
        -- Registramos en el historial de estados
        INSERT INTO historialEstados (docCamper, idEstado, fechaCambio)
        VALUES (NEW.docCamper, id_estado_inscrito, CURDATE());
    END//
DELIMITER ;
```  

### 4️⃣ Al actualizar una evaluación, recalcular su promedio inmediatamente  
```sql  
DELIMITER //
    CREATE TRIGGER recalcular_promedio
    AFTER UPDATE ON evaluaciones
    FOR EACH ROW
    BEGIN
        DECLARE nota_final DOUBLE;
        SET nota_final = (NEW.proyecto * 0.3) + (NEW.examen * 0.4) + (NEW.actividades * 0.3);
        
        UPDATE skillCamper 
        SET calificacion = nota_final 
        WHERE idSkill = NEW.idSkill AND docCamper = NEW.docCamper;
    END//
DELIMITER ; 
```  

### 5️⃣ Al eliminar una inscripción, marcar al camper como “Retirado”  
```sql  
DELIMITER //
    CREATE TRIGGER marcar_retirado
    BEFORE DELETE ON inscripciones
    FOR EACH ROW
    BEGIN
        DECLARE id_estado_retirado INT;
        
        -- Obtenemos el ID del estado "Retirado"
        SELECT id INTO id_estado_retirado FROM estados WHERE estado = 'Retirado' LIMIT 1;
        
        -- Actualizamos el estado del camper
        UPDATE datosCamper 
        SET idEstado = id_estado_retirado 
        WHERE docCamper = OLD.docCamper;
        
        -- Registramos en el historial de estados
        INSERT INTO historialEstados (docCamper, idEstado, fechaCambio)
        VALUES (OLD.docCamper, id_estado_retirado, CURDATE());
    END//
DELIMITER ; 
```  

### 6️⃣ Al insertar un nuevo módulo, registrar automáticamente su SGDB asociado  
```sql  
DELIMITER //
CREATE TRIGGER registrar_sgdb_modulo
AFTER INSERT ON modulos
FOR EACH ROW
BEGIN
    DECLARE ruta_id INT;
    
    -- Obtenemos la ruta asociada al skill
    SELECT idRuta INTO ruta_id FROM skills WHERE id = NEW.idSkill LIMIT 1;
    
    -- Registramos el SGDB por defecto para la ruta (asumiendo MySQL como predeterminado, ID=1)
    IF NOT EXISTS (SELECT * FROM bdAsociadas WHERE idRuta = ruta_id) THEN
        INSERT INTO bdAsociadas (idSgdbP, idSgdbA, idRuta)
        VALUES (1, 1, ruta_id);
    END IF;
END//
DELIMITER ;
```  

### 7️⃣ Al insertar un nuevo trainer, verificar duplicados por identificación  
```sql  
DELIMITER //
    CREATE TRIGGER verificar_duplicado_trainer
    BEFORE INSERT ON trainer
    FOR EACH ROW
    BEGIN
        DECLARE contador INT;
        
        SELECT COUNT(*) INTO contador FROM trainer WHERE doc = NEW.doc;
        
        IF contador > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: Ya existe un trainer con esta identificación';
        END IF;
    END//
DELIMITER ; 
```  

### 8️⃣ Al asignar un área, validar que no exceda su capacidad  
```sql  
DELIMITER //
    CREATE TRIGGER validar_capacidad_area
    BEFORE INSERT ON usoArea
    FOR EACH ROW
    BEGIN
        DECLARE capacidad_area INT;
        DECLARE asignados INT;
        
        -- Obtenemos la capacidad del área
        SELECT capacidad INTO capacidad_area FROM areas WHERE id = NEW.idArea;
        
        -- Contamos cuántos usos ya tiene asignados para esa fecha y horario
        SELECT COUNT(*) INTO asignados 
        FROM usoArea 
        WHERE idArea = NEW.idArea 
        AND fechaUso = NEW.fechaUso 
        AND idHorario = NEW.idHorario;
        
        IF asignados >= capacidad_area THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: La capacidad del área ha sido excedida para este horario';
        END IF;
    END//
DELIMITER ;
```  

### 9️⃣ Al insertar una evaluación con nota < 60, marcar al camper como “Bajo rendimiento”  
```sql  
DELIMITER //
    CREATE TRIGGER marcar_bajo_rendimiento
    AFTER INSERT ON evaluaciones
    FOR EACH ROW
    BEGIN
        DECLARE nota_final DOUBLE;
        DECLARE id_estado_bajo INT;
        
        SET nota_final = (NEW.proyecto * 0.3) + (NEW.examen * 0.4) + (NEW.actividades * 0.3);
        
        IF nota_final < 60 THEN
            -- Obtenemos el ID del estado "Bajo rendimiento"
            SELECT id INTO id_estado_bajo FROM estados WHERE estado = 'Bajo rendimiento' LIMIT 1;
            
            -- Actualizamos el estado del camper
            UPDATE datosCamper 
            SET idEstado = id_estado_bajo 
            WHERE docCamper = NEW.docCamper;
            
            -- Registramos en el historial de estados
            INSERT INTO historialEstados (docCamper, idEstado, fechaCambio)
            VALUES (NEW.docCamper, id_estado_bajo, CURDATE());
        END IF;
    END//
DELIMITER ; 
```  

### 🔟 Al cambiar de estado a “Graduado”, mover registro a la tabla de egresados  
```sql  
DELIMITER //
    CREATE TRIGGER mover_a_egresados
    AFTER UPDATE ON datosCamper
    FOR EACH ROW
    BEGIN
        DECLARE id_estado_graduado INT;
        DECLARE ruta_camper INT;
        
        -- Obtenemos el ID del estado "Graduado"
        SELECT id INTO id_estado_graduado FROM estados WHERE estado = 'Graduado' LIMIT 1;
        
        IF NEW.idEstado = id_estado_graduado AND OLD.idEstado != id_estado_graduado THEN
            -- Obtenemos la ruta actual del camper
            SELECT idRuta INTO ruta_camper 
            FROM inscripciones 
            WHERE docCamper = NEW.docCamper 
            ORDER BY id DESC LIMIT 1;
            
            -- Insertamos en la tabla de egresados
            INSERT INTO egresados (docCamper, idRuta, fechaSalida)
            VALUES (NEW.docCamper, ruta_camper, CURDATE());
        END IF;
    END//
DELIMITER ; 
```  

### 1️⃣1️⃣ Al modificar horarios de trainer, verificar solapamiento con otros  
```sql  
DELIMITER //
    CREATE TRIGGER verificar_solapamiento_horarios
    BEFORE UPDATE ON usoArea
    FOR EACH ROW
    BEGIN
        DECLARE contador INT;
        
        -- Verificamos si hay solapamiento con otros horarios del mismo trainer
        SELECT COUNT(*) INTO contador 
        FROM usoArea 
        WHERE docTrainer = NEW.docTrainer 
        AND fechaUso = NEW.fechaUso 
        AND idHorario = NEW.idHorario 
        AND id != NEW.id;
        
        IF contador > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: El trainer ya tiene asignado este horario';
        END IF;
    END//
DELIMITER ;
```  

### 1️⃣2️⃣ Al eliminar un trainer, liberar sus horarios y rutas asignadas  
```sql  
DELIMITER //
    CREATE TRIGGER liberar_asignaciones_trainer
    BEFORE DELETE ON trainer
    FOR EACH ROW
    BEGIN
        -- Eliminamos los horarios asignados al trainer
        DELETE FROM usoArea WHERE docTrainer = OLD.doc;
        
        -- Eliminamos las rutas asignadas al trainer
        DELETE FROM rutasTrainer WHERE docTrainer = OLD.doc;
        
        -- Eliminamos los teléfonos asociados
        DELETE FROM trainerTelefonos WHERE docTrainer = OLD.doc;
    END//
DELIMITER ;
```  

### 1️⃣3️⃣ Al cambiar la ruta de un camper, actualizar automáticamente sus módulos  
```sql  
DELIMITER //
    CREATE TRIGGER actualizar_modulos_camper
    AFTER UPDATE ON inscripciones
    FOR EACH ROW
    BEGIN
        -- Si cambió la ruta
        IF NEW.idRuta != OLD.idRuta THEN
            -- Eliminamos los skills antiguos
            DELETE FROM skillCamper 
            WHERE docCamper = NEW.docCamper 
            AND idSkill IN (SELECT id FROM skills WHERE idRuta = OLD.idRuta);
            
            -- Insertamos los nuevos skills de la nueva ruta
            INSERT INTO skillCamper (idSkill, docCamper, estado, calificacion)
            SELECT id, NEW.docCamper, 'Pendiente', NULL
            FROM skills
            WHERE idRuta = NEW.idRuta;
        END IF;
    END//
DELIMITER ;
```  

### 1️⃣4️⃣ Al insertar un nuevo camper, verificar si ya existe por número de documento  
```sql  
DELIMITER //
    CREATE TRIGGER verificar_duplicado_camper
    BEFORE INSERT ON camper
    FOR EACH ROW
    BEGIN
        DECLARE contador INT;
        
        SELECT COUNT(*) INTO contador FROM camper WHERE doc = NEW.doc;
        
        IF contador > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: Ya existe un camper con esta identificación';
        END IF;
    END//
DELIMITER ;
```  

### 1️⃣5️⃣ Al actualizar la nota final, recalcular el estado del módulo automáticamente  
```sql  
DELIMITER //
    CREATE TRIGGER actualizar_estado_modulo
    AFTER UPDATE ON skillCamper
    FOR EACH ROW
    BEGIN
        IF NEW.calificacion IS NOT NULL AND (OLD.calificacion IS NULL OR NEW.calificacion != OLD.calificacion) THEN
            IF NEW.calificacion >= 60 THEN
                UPDATE skillCamper 
                SET estado = 'Aprobado' 
                WHERE id = NEW.id;
            ELSE
                UPDATE skillCamper 
                SET estado = 'Reprobado' 
                WHERE id = NEW.id;
            END IF;
        END IF;
    END//
DELIMITER ;  
```  

### 1️⃣6️⃣ Al asignar un módulo, verificar que el trainer tenga ese conocimiento  
```sql  
DELIMITER //
    CREATE TRIGGER verificar_conocimiento_trainer
    BEFORE INSERT ON usoArea
    FOR EACH ROW
    BEGIN
        DECLARE ruta_grupo INT;
        DECLARE contador INT;
        
        -- Obtenemos la ruta asociada al grupo
        SELECT idRuta INTO ruta_grupo FROM grupo WHERE id = NEW.idGrupo;
        
        -- Verificamos si el trainer tiene asignada esa ruta
        SELECT COUNT(*) INTO contador 
        FROM rutasTrainer 
        WHERE docTrainer = NEW.docTrainer 
        AND idRuta = ruta_grupo;
        
        IF contador = 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: El trainer no tiene conocimiento de esta ruta';
        END IF;
    END//
DELIMITER ;
```  

### 1️⃣7️⃣ Al cambiar el estado de un área a inactiva, liberar campers asignados  
```sql  
DELIMITER //
    CREATE TRIGGER liberar_campers_area_inactiva
    AFTER UPDATE ON areas
    FOR EACH ROW
    BEGIN
        
        IF NEW.capacidad = 0 AND OLD.capacidad > 0 THEN
            -- Eliminamos todos los usos futuros del área
            DELETE FROM usoArea 
            WHERE idArea = NEW.id 
            AND fechaUso >= CURDATE();
            
            -- Notificamos sobre el cambio
            INSERT INTO notificaciones (idTipo, descripcion, fecha)
            VALUES (
                (SELECT id FROM tipoNotificacion WHERE nombre = 'Cambio de área' LIMIT 1),
                CONCAT('Área ', NEW.nombre, ' inactivada. Se han liberado las asignaciones.'),
                CURDATE()
            );
        END IF;
    END//
DELIMITER ;
```  

### 1️⃣8️⃣ Al crear una nueva ruta, clonar la plantilla base de módulos y SGDBs  
```sql  
DELIMITER //
    CREATE TRIGGER clonar_plantilla_ruta
    AFTER INSERT ON rutas
    FOR EACH ROW
    BEGIN
        DECLARE ruta_base INT;
        
        -- Asumimos que la ruta con id=1 es la plantilla base
        SET ruta_base = 1;
        
        -- Clonamos los SGDBs de la ruta base
        INSERT INTO bdAsociadas (idSgdbP, idSgdbA, idRuta)
        SELECT idSgdbP, idSgdbA, NEW.id
        FROM bdAsociadas
        WHERE idRuta = ruta_base;
        
        -- Clonamos los skills de la ruta base
        INSERT INTO skills (nombre, idRuta)
        SELECT nombre, NEW.id
        FROM skills
        WHERE idRuta = ruta_base;
        
        -- Clonamos los módulos para cada skill (esto es más complejo y requiere un cursor)
        -- Esta es una versión simplificada
        INSERT INTO notificaciones (idTipo, descripcion, fecha)
        VALUES (
            (SELECT id FROM tipoNotificacion WHERE nombre = 'Nueva ruta' LIMIT 1),
            CONCAT('Se ha creado la ruta ', NEW.nombre, ' con la plantilla base.'),
            CURDATE()
        );
    END//
DELIMITER ;
```  

### 1️⃣9️⃣ Al registrar la nota práctica, verificar que no supere 60% del total  
```sql  
DELIMITER //
    CREATE TRIGGER verificar_porcentaje_practica
    BEFORE INSERT ON evaluaciones
    FOR EACH ROW
    BEGIN
        -- Verificamos que la nota práctica (proyecto) no supere el 60% del total
        IF NEW.proyecto > 60 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: La nota práctica no puede superar el 60% (60 puntos)';
        END IF;
    END//
DELIMITER ;
```  

### 2️⃣0️⃣ Al modificar una ruta, notificar cambios a los trainers asignados  
```sql  
DELIMITER //
    CREATE TRIGGER notificar_cambios_ruta
    AFTER UPDATE ON rutas
    FOR EACH ROW
    BEGIN
        -- Creamos una notificación sobre el cambio
        INSERT INTO notificaciones (idTipo, descripcion, fecha)
        VALUES (
            (SELECT id FROM tipoNotificacion WHERE nombre = 'Cambio en ruta' LIMIT 1),
            CONCAT('Se ha modificado la ruta "', NEW.nombre, '". Todos los trainers han sido notificados.'),
            CURDATE()
        );
        

    END//
DELIMITER ;
```  

