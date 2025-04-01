-- Corrected SQL Script for Campuslands

-- Existing inserts for basic tables (no changes needed)
INSERT INTO empresa (nit, nombre)
VALUES
('901628406', 'CampusLands');

INSERT INTO ciudad (nombre)
VALUES
('Bucaramanga'),
('Bogotá'),
('Cúcuta');

INSERT INTO sedes (nombre, idEmpresa, idCiudad)
VALUES
('Zona Franca', '901628406', 1),
('Cajasan', '901628406', 2),
('Tibú', '901628406', 3);

INSERT INTO acudientes (doc, nombre, telefono)
VALUES
('1001001001', 'Carlos Ramírez', '3001002001'),
('1001001002', 'María López', '3001002002'),
('1001001003', 'Andrés Gómez', '3001002003'),
('1001001004', 'Luisa Fernández', '3001002004'),
('1001001005', 'Jorge Herrera', '3001002005'),
('1001001006', 'Ana Martínez', '3001002006'),
('1001001007', 'Felipe Ríos', '3001002007'),
('1001001008', 'Sofía Castro', '3001002008'),
('1001001009', 'Ricardo Méndez', '3001002009'),
('1001001010', 'Paula Sánchez', '3001002010');

INSERT INTO estados (estado)
VALUES
('Proceso de ingreso'),
('Inscrito'),
('Aprobado'),
('Cursando'),
('Graduado'),
('Expulsado'),
('Retirado');

INSERT INTO nivelRiesgo (nivel)
VALUES
('Alto'),
('Medio'),
('Bajo');

INSERT INTO tipoDocumento (nombre)
VALUES
('Cédula de Ciudadanía'),
('Tarjeta de Identidad'),
('Cédula de Extranjería'),
('Pasaporte'),
('Registro Civil');

INSERT INTO rutas (nombre)
VALUES
('Java'),
('JavaScript'),
('C#'),
('PHP');

INSERT INTO camper (doc, nombres, apellidos)
VALUES
('100011', 'Sebastián', 'Mejía'),
('100012', 'Camila', 'Ortega'),
('100013', 'Samuel', 'Villalobos'),
('100014', 'Daniela', 'Mendoza'),
('100015', 'Tomás', 'Guzmán'),
('100016', 'Gabriela', 'Suárez'),
('100017', 'Felipe', 'Navarro'),
('100018', 'Natalia', 'Rivas'),
('100019', 'Julián', 'Castañeda'),
('100020', 'Andrea', 'Pacheco');

INSERT INTO inscripciones (docCamper, idRuta)
VALUES
('100011', 1), -- Sebastián Mejía en Java
('100012', 2), -- Camila Ortega en JavaScript
('100013', 3), -- Samuel Villalobos en C#
('100014', 4), -- Daniela Mendoza en PHP
('100015', 1); -- Tomás Guzmán en Java


INSERT INTO datosCamper (docCamper, docAcu, idEstado, direccion, idNivel, idSede)
VALUES
('100011', '1001001001', 1, 'Calle 123 #45-67', 3, 1),
('100013', '1001001002', 2, 'Carrera 12 #34-56', 2, 2),
('100014', '1001001003', 3, 'Avenida 89 #23-45', 1, 3),
('100015', '1001001004', 4, 'Calle 50 #10-20', 3, 1),
('100016', '1001001005', 5, 'Diagonal 33 #22-11', 2, 2),
('100017', '1001001006', 1, 'Transversal 5 #67-89', 1, 3),
('100018', '1001001007', 2, 'Calle 74 #98-12', 3, 1),
('100019', '1001001008', 3, 'Carrera 9 #11-34', 2, 2),
('100020', '1001001009', 4, 'Avenida 100 #45-67', 1, 3);

-- HISTORIAL ESTADOS
INSERT INTO historialEstados (docCamper, idEstado, fechaCambio) 
VALUES
('100011', 1, '2024-01-15'),
('100012', 2, '2024-01-16'),
('100013', 3, '2024-01-17'),
('100014', 1, '2024-01-18'),
('100015', 2, '2024-01-19'),
('100016', 3, '2024-01-20'),
('100017', 1, '2024-01-21');


-- Insertar datos en la tabla telefonos
INSERT INTO telefonos (numero) VALUES
('3151234567'),
('3162345678'),
('3173456789'),
('3184567890'),
('3195678901'),
('3101234567'),
('3112345678'),
('3123456789'),
('3134567890'),
('3145678901'),
('3156789012'),
('3167890123'),
('3178901234'),
('3189012345'),
('3190123456'),
('3201234567'),
('3212345678'),
('3223456789'),
('3234567890'),
('3245678901'),
('3256789012'),
('3267890123'),
('3278901234'),
('3289012345'),
('3290123456'),
('3301234567'),
('3312345678'),
('3323456789'),
('3334567890');


-- Insertar datos en la tabla camperTelefonos
INSERT INTO camperTelefonos (docCamper, idTelefono) VALUES
('100011', 1),
('100011', 2),
('100012', 3),
('100013', 4),
('100013', 5),
('100014', 6),
('100015', 7),
('100016', 8),
('100016', 9),
('100017', 10),
('100018', 11),
('100019', 12),
('100019', 13),
('100020', 14);
SELECT * FROM datosCamper;

select * from camperTelefonos;
INSERT INTO datosTrainer (docTrainer, direccion) VALUES
('2001234567', 'Calle 101 #45-67'),
('2001234568', 'Avenida Central #23-45'),
('2001234569', 'Carrera 12 #56-78'),
('2001234570', 'Diagonal 90 #33-12'),
('2001234571', 'Transversal 5 #89-11'),
('2001234572', 'Calle 60 #40-22'),
('2001234573', 'Avenida del Sol #9-99'),
('2001234574', 'Carrera 50 #78-30'),
('2001234575', 'Calle 72 #11-25'),
('2001234576', 'Diagonal 33 #5-60'),
('2001234577', 'Transversal 7 #14-33'),
('2001234578', 'Avenida Norte #66-77'),
('2001234579', 'Carrera 88 #21-44'),
('2001234580', 'Calle 55 #32-90');


INSERT INTO trainerTelefonos (docTrainer, idTelefono) VALUES
('2001234567', 16),
('2001234568', 17),
('2001234569', 18),
('2001234570', 19),
('2001234571', 20),
('2001234572', 21),
('2001234573', 22),
('2001234574', 23),
('2001234575', 24),
('2001234576', 25),
('2001234577', 26),
('2001234578', 27),
('2001234579', 28),
('2001234580', 29);

INSERT INTO skills (nombre, idRuta) VALUES
('HTML5 y CSS3', 1),
('JavaScript', 1),
('React', 1),
('Node.js', 1),
('Java', 2),
('Kotlin', 2),
('Docker', 3),
('AWS', 3),
('Azure', 3),
('Python', 4),
('Machine Learning', 4),
('Deep Learning', 4),
('C++', 3),
('Seguridad de Redes', 1),
('Ethical Hacking', 2);


INSERT INTO modulos (nombre, idSkill) VALUES
('Introducción a HTML5', 1),
('CSS Avanzado', 1),
('JavaScript Básico', 2),
('JavaScript Avanzado', 2),
('React Fundamentos', 3),
('React Hooks', 3),
('Node.js Express', 4),
('APIs con Node', 4),
('Programación en Java', 5),
('Android con Java', 5),
('Kotlin Fundamentals', 6),
('Contenedores con Docker', 7),
('Docker Compose', 7),
('AWS EC2 y S3', 8),
('AWS Lambda', 8),
('Azure VM', 9),
('Python Básico', 10),
('Python para Análisis', 10),
('Algoritmos ML', 11),
('Redes Neuronales', 12);

INSERT INTO sesiones (nombre, idModulo) VALUES
('Estructura HTML', 1),
('CSS Flexbox', 2),
('Variables y Tipos', 3),
('Funciones JS', 3),
('Componentes React', 5),
('Props y State', 5),
('useState', 6),
('useEffect', 6),
('Express Básico', 7),
('REST API', 8),
('Clases en Java', 9),
('Herencia Java', 9),
('Kotlin Fundamentals', 11),
('Docker Run', 12),
('Dockerfile', 13),
('AWS EC2 y S3', 14),
('Python Básico', 15),
('Python para Análisis', 16),
('Algoritmos ML', 17),
('Redes Neuronales', 18);


INSERT INTO sgdb (nombre) VALUES
('MySQL'),
('PostgreSQL'),
('MongoDB'),
('Oracle'),
('SQLite'),
('SQL Server'),
('Firebase');


INSERT INTO bdAsociadas (idSgdbP, idSgdbA, idRuta) VALUES
(1, 3, 1),
(1, 5, 2),
(1, 2, 3),
(2, 3, 4),
(3, 1, 1),
(4, 5, 2),
(5, 2, 3),
(6, 3, 4),
(7, 1, 1),
(2, 6, 2);

-- ESPECIALIDADES
INSERT INTO especialidades (nombre) VALUES
('Desarrollo Web'),
('Desarrollo Móvil'),
('Cloud Computing'),
('Inteligencia Artificial'),
('Ciberseguridad'),
('Blockchain'),
('DevOps');

-- Insertar datos en la tabla horarios
INSERT INTO horarios (horaInicio, horaFin) VALUES
('06:00:00', '09:00:00'),
('10:00:00', '13:00:00'),
('14:00:00', '17:00:00'),
('18:00:00', '21:00:00');

INSERT INTO rutasTrainer (docTrainer, idRuta) VALUES
('2001234567', 1),
('2001234567', 2),
('2001234568', 3),
('2001234568', 4),
('2001234569', 1),
('2001234569', 3),
('2001234570', 2),
('2001234570', 4);

-- MÓDULOS Y NOTAS DE CAMPERS
-- Insertar datos en la tabla skillCamper
INSERT INTO skillCamper (idSkill, docCamper, estado, calificacion) VALUES
(1, '100011', 'Aprobado', 85),
(2, '100011', 'Aprobado', 78),
(3, '100011', 'En curso', NULL),
(1, '100012', 'Aprobado', 92),
(2, '100012', 'Aprobado', 88),
(3, '100012', 'Reprobado', 55),
(5, '100013', 'Aprobado', 76),
(6, '100013', 'En curso', NULL),
(9, '100014', 'Aprobado', 81),
(10, '100014', 'Aprobado', 79),
(11, '100014', 'En curso', NULL),
(13, '100015', 'Aprobado', 90),
(14, '100015', 'Aprobado', 85),
(15, '100015', 'En curso', NULL),
(16, '100015', 'Pendiente', NULL);

-- ÁREAS DE ENTRENAMIENTO
INSERT INTO areas (nombre, capacidad) VALUES
('Apolo 11', 33),
('Sputnik', 33),
('Artemis', 33);

INSERT INTO grupo (idRuta, nombre, fechaInicio) VALUES
(1, 'J1', '2024-01-15'),
(2, 'J2', '2024-01-22'),
(3, 'M1', '2024-01-29'),
(4, 'M2', '2024-02');

-- USO DE ÁREAS
INSERT INTO usoArea (idArea, idHorario, docTrainer, idGrupo, fechaUso) VALUES
(1, 1, '123456789012', 1, '2024-01-15'),
(2, 2, '987654321012', 2, '2024-01-22'),
(3, 3, '456123789012', 3, '2024-01-29'),
(1, 4, '321654987012', 4, '2024-02-05'),
(2, 1, '654987321012', 1, '2024-02-12'),
(3, 2, '789123456012', 2, '2024-02-19'),
(1, 3, '987321654012', 3, '2024-02-26'),
(2, 4, '456789123012', 4, '2024-01-18'),
(3, 1, '321789654012', 1, '2024-01-25'),
(1, 2, '159357852963', 2, '2024-02-01');


-- NOTIFICACIONES
INSERT INTO tipoNotificacion (nombre) VALUES 
('Aviso general'),
('Cambio de horario'),
('Recordatorio de pago'),
('Suspensión temporal'),
('Actualización de contenido'),
('Evento especial'),
('Revisión de desempeño'),
('Entrega de certificados'),
('Cambio de instructores'),
('Convocatoria a reunión');

INSERT INTO notificaciones (idTipo, descripcion, fecha) VALUES 
(1, 'Revisión de notas finales', '2024-11-20'),
(2, 'Cambio de sala de entrenamiento', '2024-11-21'),
(3, 'Pago mensualidad antes del 30', '2024-11-25'),
(4, 'Suspensión de acceso por inactividad', '2024-11-26'),
(5, 'Nuevo material disponible en la plataforma', '2024-11-27'),
(6, 'Taller especial de bases de datos', '2024-11-28'),
(7, 'Evaluación de desempeño semestral', '2024-11-29'),
(8, 'Entrega de certificados el 1 de diciembre', '2024-11-30'),
(9, 'Cambio de trainer en la ruta 3', '2024-12-01'),
(10, 'Reunión obligatoria para campers el 3 de diciembre', '2024-12-02');

INSERT INTO egresados (docCamper, idRuta, fechaSalida) VALUES
('100011', 1, '2024-06-15'),
('100012', 2, '2024-06-22');

-- GRUPOS DE CAMPERS
INSERT INTO grupoCamper (idGrupo, docCamper) VALUES
(1, '100011'),
(1, '100012'),
(2, '100013'),
(2, '100014'),
(3, '100015'),
(3, '100016'),
(4, '100017'),
(4, '100018'),
(1, '100019'),
(2, '100020');


INSERT INTO datosTrainer (docTrainer, direccion) VALUES 
('2001234567', 'Calle 101 #45-67'),
('2001234568', 'Avenida Central #23-45'),
('2001234569', 'Carrera 12 #56-78'),
('2001234570', 'Diagonal 90 #33-12'),
('2001234571', 'Transversal 5 #89-11'),
('2001234572', 'Calle 60 #40-22'),
('2001234573', 'Avenida del Sol #9-99'),
('2001234574', 'Carrera 50 #78-30'),
('2001234575', 'Calle 72 #11-25'),
('2001234576', 'Diagonal 33 #5-60'),
('2001234577', 'Transversal 7 #14-33'),
('2001234578', 'Avenida Norte #66-77'),
('2001234579', 'Carrera 88 #21-44'),
('2001234580', 'Calle 55 #32-90');

-- EVALUACIONES
INSERT INTO evaluaciones (idSkill, docCamper, proyecto, examen, actividades) VALUES 
(1, '100011', 4.5, 4.8, 4.7),
(2, '100012', 4.2, 4.0, 4.3),
(3, '100013', 4.7, 4.6, 4.8),
(4, '100014', 3.9, 4.1, 4.2),
(5, '100015', 4.8, 4.9, 5.0),
(6, '100016', 4.1, 4.2, 4.3),
(7, '100017', 4.6, 4.4, 4.5),
(8, '100018', 4.3, 4.5, 4.4),
(9, '100019', 3.8, 4.0, 4.1),
(10, '100020', 4.9, 5.0, 4.8);

