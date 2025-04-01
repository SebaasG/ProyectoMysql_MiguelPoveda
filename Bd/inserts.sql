insert into empresa (nit, nombre) VALUES ("901628406", "Campuslands");

insert into ciudad (id, nombre) VALUES ("Bucaramanga"), ("Bogota"), ("Tibu"), ("Cucuta");

insert into sedes (nombre, idEmpresa, idCiudad) VALUES ("Zona franca", 1, 1),("Cajasan"1,1);

INSERT INTO acudientes (doc, nombre, telefono) VALUES
('100001', 'Carlos Ramírez', '3101234567'),
('100002', 'María Fernanda Gómez', '3159876543'),
('100003', 'Luis Eduardo Pérez', '3124567890'),
('100004', 'Diana Marcela López', '3006543219'),
('100005', 'Jorge Andrés Sánchez', '3147896542'),
('100006', 'Paola Andrea Rodríguez', '3205678912'),
('100007', 'Juan Sebastián Vargas', '3113456789'),
('100008', 'Sandra Milena Castillo', '3187654321'),
('100009', 'José Alejandro Torres', '3198765432'),
('100010', 'Martha Cecilia Rojas', '3223456789'),
('100011', 'Felipe Hernán Mejía', '3002345678'),
('100012', 'Andrea Carolina Quintero', '3165432109'),
('100013', 'Oscar Darío Martínez', '3176543210'),
('100014', 'Gloria Patricia Guzmán', '3214567890'),
('100015', 'Ricardo Alfonso Peña', '3245678901'),
('100016', 'Lina Marcela Herrera', '3056789012'),
('100017', 'Sergio Daniel Pineda', '3078901234'),
('100018', 'Yolanda Beatriz Ramírez', '3126789012'),
('100019', 'Camilo Esteban Cárdenas', '3157890123'),
('100020', 'Adriana Isabel Salazar', '3208901234'),
('100021', 'Javier Augusto Cortés', '3119012345'),
('100022', 'Beatriz Elena Arango', '3130123456'),
('100023', 'Fernando José Gutiérrez', '3171234567'),
('100024', 'Nidia Esperanza Pacheco', '3192345678'),
('100025', 'Julián Alberto Valencia', '3013456789'),
('100026', 'Luisa Fernanda Molina', '3044567890'),
('100027', 'Hernando Raúl Suárez', '3085678901'),
('100028', 'Natalia Rocío Parra', '3106789012'),
('100029', 'Francisco Javier Ospina', '3147890123'),
('100030', 'Patricia Eugenia Mendoza', '3208901234');


INSERT INTO estados (estado) VALUES("Proceso de ingreso"), ("Inscrito"), ("Aprobado"), ("Cursando"), ("Graduado"), ("Expulsado"), ("Retirado");

INSERT INTO nivelRiesgo (nivel) VALUES("alto"),("medio"), ("bajo");

INSERT INTO tipoDocumento (nombre) VALUES
('Cédula de Ciudadanía'),
('Tarjeta de Identidad'),
('Cédula de Extranjería'),
('Pasaporte'),
('Registro Civil'),
('Permiso Especial de Permanencia'),
('Documento Nacional de Identidad');


INSERT INTO rutas (nombre) VALUES ("Java"),("JavaScript"), ("C#"), ("Php");

INSERT INTO camper (doc, nombres, apellidos) VALUES
('100000001', 'Juan Carlos', 'Rodríguez López'),
('100000002', 'María Fernanda', 'González Martínez'),
('100000003', 'Andrés Felipe', 'Pérez Ramírez'),
('100000004', 'Daniela Alejandra', 'Gómez Hernández'),
('100000005', 'Carlos Eduardo', 'Díaz Torres'),
('100000006', 'Sofía Isabella', 'Moreno Ríos'),
('100000007', 'Mateo Sebastián', 'Ramírez Castro'),
('100000008', 'Valentina Andrea', 'López Sánchez'),
('100000009', 'Santiago Alejandro', 'Muñoz Jiménez'),
('100000010', 'Laura Camila', 'Ortega Mendoza'),
('100000011', 'Felipe David', 'Castaño Salazar'),
('100000012', 'Gabriela Luciana', 'Quintero Vargas'),
('100000013', 'Alejandro Tomás', 'Mendoza Paredes'),
('100000014', 'Natalia Sofía', 'Castro Guzmán'),
('100000015', 'Julián Esteban', 'Restrepo Velásquez'),
('100000016', 'Camila Antonella', 'Cardona Peña'),
('100000017', 'Samuel Andrés', 'Bermúdez Rincón'),
('100000018', 'Isabella Valeria', 'Mejía Cárdenas'),
('100000019', 'Emmanuel David', 'Galeano Ospina'),
('100000020', 'Manuela Alejandra', 'Ruiz Herrera'),
('100000021', 'Cristian Javier', 'Vargas Suárez'),
('100000022', 'Daniel Santiago', 'Zapata León'),
('100000023', 'Mariana Isabel', 'Arango Flores'),
('100000024', 'Luis Fernando', 'Herrera Acosta'),
('100000025', 'Ana Sofía', 'Salinas Gil'),
('100000026', 'José Ricardo', 'Beltrán Escobar'),
('100000027', 'Sara Valentina', 'Navarro Álvarez'),
('100000028', 'Tomás Emanuel', 'Chávez Medina'),
('100000029', 'Dylan Nicolás', 'Fuentes Mora'),
('100000030', 'Luisa Fernanda', 'Montoya Pineda');


INSERT INTO inscripciones (id, docCamper, idRuta) VALUES 
();

INSERT INTO datosCamper (docCamper, docAcu, idEstado, direccion, idNivel, idSede) VALUES 
();

INSERT INTO historialEstados (id, docCamper, idEstado, fechaCambio) VALUES 
();

INSERT INTO telefonos (id, numero) VALUES 
();

INSERT INTO camperTelefonos (docCamper, idTelefono) VALUES 
();

-- TRAINERS Y SUS DATOS
INSERT INTO trainer (doc, nombres, apellidos) VALUES 
();

INSERT INTO trainerTelefonos (docTrainer, idTelefono) VALUES 
();

INSERT INTO skills (id, nombre, idRuta) VALUES 
();

INSERT INTO modulos (id, nombre, idSkill) VALUES 
();

INSERT INTO sesiones (id, nombre, idModulo) VALUES 
();

INSERT INTO sgdb (id, nombre) VALUES 
();

INSERT INTO bdAsociadas (id, idSgdbP, idSgdbA, idRuta) VALUES 
();

-- ESPECIALIDADES Y HORARIOS
INSERT INTO especialidades (id, nombre) VALUES 
();

INSERT INTO horarios (id, horaInicio, horaFin) VALUES 
();

INSERT INTO rutasTrainer (id, docTrainer, idRuta) VALUES 
();

-- MÓDULOS Y NOTAS DE CAMPERS
INSERT INTO skillCamper (id, idSkill, docCamper, estado, calificacion) VALUES 
();

-- ÁREAS DE ENTRENAMIENTO
INSERT INTO areas (id, nombre, capacidad) VALUES 
();

INSERT INTO grupo (id, idRuta, nombre, fechaInicio) VALUES 
();

INSERT INTO usoArea (id, idArea, idHorario, docTrainer, idGrupo, fechaUso) VALUES 
();

-- NOTIFICACIONES
INSERT INTO tipoNotificacion (id, nombre) VALUES 
();

INSERT INTO notificaciones (id, idTipo, descripcion, fecha) VALUES 
();

-- EGRESADOS
INSERT INTO egresados (docCamper, idRuta, fechaSalida) VALUES 
();

INSERT INTO grupoCamper (idGrupo, docCamper) VALUES 
();

-- DATOS ADICIONALES
INSERT INTO datosTrainer (docTrainer, direccion) VALUES 
();

INSERT INTO evaluaciones (id, idSkill, docCamper, proyecto, examen, actividades) VALUES 
();
