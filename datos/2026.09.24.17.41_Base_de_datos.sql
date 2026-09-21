CREATE TABLE Usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  rut VARCHAR(20) UNIQUE NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  contrasena VARCHAR(100) NOT NULL,
  fecha_registro DATE DEFAULT (CURRENT_DATE),
  activo BOOLEAN DEFAULT TRUE,
  rol ENUM('Administrador', 'Encuestado') NOT NULL
);

CREATE TABLE Administrador (
  id_usuario INT PRIMARY KEY,
  cargo VARCHAR(50) NOT NULL,
  fecha_contratacion DATE NOT NULL,
  FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE Encuestado (
  id_usuario INT PRIMARY KEY,
  fecha_nacimiento DATE NOT NULL,       
  genero VARCHAR(20),
  pais VARCHAR(50) NOT NULL,
  ocupacion VARCHAR(50),
  FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE Categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  descripcion TEXT
);

CREATE TABLE Encuesta (
  id_encuesta INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  descripcion TEXT,
  fecha_creacion DATE DEFAULT (CURRENT_DATE),
  fecha_expiracion DATE,
  estado VARCHAR(20) DEFAULT 'BORRADOR',
  id_admin INT NOT NULL,
  id_categoria INT,
  FOREIGN KEY (id_admin) REFERENCES Administrador(id_usuario),
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria) ON DELETE SET NULL
);

CREATE TABLE Pregunta (
  id_pregunta INT AUTO_INCREMENT PRIMARY KEY,
  texto VARCHAR(255) NOT NULL,
  obligatoria BOOLEAN DEFAULT FALSE,
  orden INT NOT NULL,
  tipo ENUM('Abierta', 'Opcion Multiple', 'Seleccion Unica', 'Escala') NOT NULL,
  id_encuesta INT NOT NULL,
  FOREIGN KEY (id_encuesta) REFERENCES Encuesta(id_encuesta) ON DELETE CASCADE
);

CREATE TABLE PreguntaMultiple (
  id_pregunta INT PRIMARY KEY,
  permite_multiple BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (id_pregunta) REFERENCES Pregunta(id_pregunta) ON DELETE CASCADE
);

CREATE TABLE PreguntaEscala (
  id_pregunta INT PRIMARY KEY,
  escala_min INT NOT NULL,
  escala_max INT NOT NULL,
  FOREIGN KEY (id_pregunta) REFERENCES Pregunta(id_pregunta) ON DELETE CASCADE
);

CREATE TABLE PreguntaAbierta (
  id_pregunta INT PRIMARY KEY,
  max_caracteres INT NOT NULL,
  FOREIGN KEY (id_pregunta) REFERENCES Pregunta(id_pregunta) ON DELETE CASCADE
);

CREATE TABLE Opcion (
  id_opcion INT AUTO_INCREMENT PRIMARY KEY,
  texto VARCHAR(255) NOT NULL,
  contador_votos INT DEFAULT 0,
  id_pregunta INT NOT NULL,
  FOREIGN KEY (id_pregunta) REFERENCES Pregunta(id_pregunta) ON DELETE CASCADE
);

CREATE TABLE ParticipacionEncuesta (
  id_participacion INT AUTO_INCREMENT PRIMARY KEY,
  id_encuestado INT NOT NULL,
  id_encuesta INT NOT NULL,
  fecha_participacion DATE DEFAULT (CURRENT_DATE),
  completada BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (id_encuestado) REFERENCES Encuestado(id_usuario) ON DELETE CASCADE,
  FOREIGN KEY (id_encuesta) REFERENCES Encuesta(id_encuesta) ON DELETE CASCADE
);

CREATE TABLE Respuesta (
  id_respuesta INT AUTO_INCREMENT PRIMARY KEY,
  id_participacion INT NOT NULL,
  id_pregunta INT NOT NULL,
  valor TEXT NOT NULL,
  fecha_respuesta DATE DEFAULT (CURRENT_DATE),
  FOREIGN KEY (id_participacion) REFERENCES ParticipacionEncuesta(id_participacion) ON DELETE CASCADE,
  FOREIGN KEY (id_pregunta) REFERENCES Pregunta(id_pregunta) ON DELETE CASCADE
);

CREATE TABLE Reporte (
  id_reporte INT AUTO_INCREMENT PRIMARY KEY,
  id_encuesta INT NOT NULL,
  fecha_generacion DATE DEFAULT (CURRENT_DATE),
  total_participantes INT DEFAULT 0,
  total_respuestas INT DEFAULT 0,
  FOREIGN KEY (id_encuesta) REFERENCES Encuesta(id_encuesta) ON DELETE CASCADE
);




