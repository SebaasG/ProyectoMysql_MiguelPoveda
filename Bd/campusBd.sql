CREATE DATABASE CampusLands;
USE CampusLands;

-- EMPRESAS Y SEDES
CREATE TABLE empresa (
    nit VARCHAR(20) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE ciudad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL
);

CREATE TABLE sedes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    idEmpresa VARCHAR(20) NOT NULL, 
    idCiudad INT NOT NULL,
    FOREIGN KEY (idEmpresa) REFERENCES empresa (nit) ON DELETE CASCADE,
    FOREIGN KEY (idCiudad) REFERENCES ciudad (id) ON DELETE CASCADE
);

CREATE TABLE acudientes (
    doc VARCHAR(12) PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    telefono VARCHAR(15) NOT NULL
);

CREATE TABLE estados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(20) NOT NULL
);

-- NIVELES, ESTADOS Y ACUDIENTES
CREATE TABLE nivelRiesgo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nivel VARCHAR(30) NOT NULL
);

CREATE TABLE tipoDocumento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL
);

-- RUTAS Y MÓDULOS
CREATE TABLE rutas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- CAMPERS Y SUS DATOS
CREATE TABLE camper (
    doc VARCHAR(12) NOT NULL PRIMARY KEY,
    nombres VARCHAR(45) NOT NULL,
    apellidos VARCHAR(45) NOT NULL
);

CREATE TABLE inscripciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    docCamper VARCHAR(12) NOT NULL,
    idRuta INT NOT NULL,
    FOREIGN KEY (docCamper) REFERENCES camper (doc) ON DELETE CASCADE,
    FOREIGN KEY (idRuta) REFERENCES rutas (id) ON DELETE CASCADE
);

CREATE TABLE datosCamper (
    docCamper VARCHAR(12) NOT NULL PRIMARY KEY,
    docAcu VARCHAR(12) NOT NULL,
    idEstado INT NOT NULL,
    direccion VARCHAR(120),
    idNivel INT NOT NULL,
    idSede INT NOT NULL,
    FOREIGN KEY (docCamper) REFERENCES camper (doc) ON DELETE CASCADE,
    FOREIGN KEY (docAcu) REFERENCES acudientes (doc) ON DELETE CASCADE,
    FOREIGN KEY (idEstado) REFERENCES estados (id) ON DELETE CASCADE,
    FOREIGN KEY (idNivel) REFERENCES nivelRiesgo (id) ON DELETE CASCADE,
    FOREIGN KEY (idSede) REFERENCES sedes (id) ON DELETE CASCADE
);

CREATE TABLE historialEstados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    docCamper VARCHAR(12) NOT NULL,
    idEstado INT NOT NULL,
    fechaCambio DATE NOT NULL,
    FOREIGN KEY (docCamper) REFERENCES camper (doc) ON DELETE CASCADE,
    FOREIGN KEY (idEstado) REFERENCES estados (id) ON DELETE CASCADE
);

CREATE TABLE telefonos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE camperTelefonos (
    docCamper VARCHAR(12) NOT NULL,
    idTelefono INT NOT NULL,
    PRIMARY KEY (docCamper , idTelefono),
    FOREIGN KEY (docCamper) REFERENCES datosCamper (docCamper) ON DELETE CASCADE,
    FOREIGN KEY (idTelefono) REFERENCES telefonos (id) ON DELETE CASCADE
);

-- TRAINERS Y SUS DATOS
CREATE TABLE trainer (
    doc VARCHAR(12) NOT NULL PRIMARY KEY,
    nombres VARCHAR(45) NOT NULL,
    apellidos VARCHAR(45) NOT NULL
);

CREATE TABLE trainerTelefonos (
    docTrainer VARCHAR(12) NOT NULL,
    idTelefono INT NOT NULL,
    PRIMARY KEY (docTrainer , idTelefono),
    FOREIGN KEY (docTrainer) REFERENCES trainer (doc) ON DELETE CASCADE,
    FOREIGN KEY (idTelefono) REFERENCES telefonos (id) ON DELETE CASCADE
);

CREATE TABLE skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    idRuta INT NOT NULL,
    FOREIGN KEY (idRuta) REFERENCES rutas (id) ON DELETE CASCADE
);

CREATE TABLE modulos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    idSkill INT NOT NULL,
    FOREIGN KEY (idSkill) REFERENCES skills (id) ON DELETE CASCADE
);

CREATE TABLE sesiones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    idModulo INT NOT NULL,
    FOREIGN KEY (idModulo) REFERENCES modulos (id) ON DELETE CASCADE
);

CREATE TABLE sgdb (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE bdAsociadas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idSgdbP INT NOT NULL,
    idSgdbA INT NOT NULL,
    idRuta INT NOT NULL,
    FOREIGN KEY (idSgdbP) REFERENCES sgdb(id) ON DELETE CASCADE,
    FOREIGN KEY (idSgdbA) REFERENCES sgdb(id) ON DELETE CASCADE,
    FOREIGN KEY (idRuta) REFERENCES rutas(id) ON DELETE CASCADE
);


-- ESPECIALIDADES Y HORARIOS
CREATE TABLE especialidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE horarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    horaInicio TIME NOT NULL,
    horaFin TIME NOT NULL
);

CREATE TABLE rutasTrainer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    docTrainer VARCHAR(12) NOT NULL,
    idRuta INT NOT NULL,
    FOREIGN KEY (docTrainer) REFERENCES trainer (doc) ON DELETE CASCADE,
    FOREIGN KEY (idRuta) REFERENCES rutas (id) ON DELETE CASCADE
);

-- MÓDULOS Y NOTAS DE CAMPERS
CREATE TABLE skillCamper (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idSkill INT NOT NULL,
    docCamper VARCHAR(12) NOT NULL,
    estado VARCHAR(45),
    calificacion DOUBLE,
    FOREIGN KEY (idSkill) REFERENCES skills (id) ON DELETE CASCADE,
    FOREIGN KEY (docCamper) REFERENCES camper (doc) ON DELETE CASCADE
);

-- ÁREAS DE ENTRENAMIENTO
CREATE TABLE areas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    capacidad INT NOT NULL
    estado VARCHAR (20) NOT NULL
);

CREATE TABLE grupo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idRuta INT NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    fechaInicio DATE NOT NULL,
    FOREIGN KEY (idRuta) REFERENCES rutas (id) ON DELETE CASCADE
);

CREATE TABLE usoArea (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idArea INT NOT NULL,
    idHorario INT NOT NULL,
    docTrainer VARCHAR(12) NOT NULL,
    idGrupo INT NOT NULL,
    fechaUso DATE NOT NULL,
    FOREIGN KEY (idArea) REFERENCES areas (id) ON DELETE CASCADE,
    FOREIGN KEY (idHorario) REFERENCES horarios (id) ON DELETE CASCADE,
    FOREIGN KEY (docTrainer) REFERENCES trainer (doc) ON DELETE CASCADE,
    FOREIGN KEY (idGrupo) REFERENCES grupo (id) ON DELETE CASCADE
);


-- NOTIFICACIONES
CREATE TABLE tipoNotificacion (
id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(45) NOT NULL
);


-- NOTIFICACIONES
CREATE TABLE notificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idTipo INT NOT NULL,
    descripcion VARCHAR(200),
    fecha DATE NOT NULL,
    FOREIGN KEY (idTipo) REFERENCES tipoNotificacion (id) ON DELETE CASCADE
);

-- EGRESADOS
CREATE TABLE egresados (
docCamper VARCHAR(12) NOT NULL ,
idRuta INT NOT NULL,
fechaSalida DATE NOT NULL,
PRIMARY KEY(docCamper, idRuta),
FOREIGN KEY (docCamper) REFERENCES camper(doc) ON DELETE CASCADE,
FOREIGN KEY (idRuta) REFERENCES rutas(id) ON DELETE CASCADE
);


CREATE TABLE grupoCamper (
idGrupo INT NOT NULL,
docCamper VARCHAR(12) NOT NULL,
PRIMARY KEY (idGrupo, docCamper),
FOREIGN KEY (idGrupo) REFERENCES grupo(id) ON DELETE CASCADE,
FOREIGN KEY (docCamper) REFERENCES camper(doc) ON DELETE CASCADE
);


-- DATOS ADICIONALES
CREATE TABLE datosTrainer (
docTrainer VARCHAR(12) NOT NULL PRIMARY KEY,
direccion VARCHAR(120),
FOREIGN KEY (docTrainer) REFERENCES trainer(doc) ON DELETE CASCADE
);

CREATE TABLE evaluaciones (
id INT AUTO_INCREMENT PRIMARY KEY,
idSkill INT NOT NULL,
docCamper VARCHAR(12) NOT NULL,
proyecto DOUBLE,
examen DOUBLE,
actividades DOUBLE,
FOREIGN KEY (idSkill) REFERENCES skills(id) ON DELETE CASCADE,
FOREIGN KEY (docCamper) REFERENCES camper(doc) ON DELETE CASCADE
); 

drop database CampusLands;