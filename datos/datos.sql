
CREATE TABLE Usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  rut VARCHAR(20) UNIQUE NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  contrasena VARCHAR(100) NOT NULL,
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


CREATE TABLE Encuesta (
  id_encuesta INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  descripcion TEXT,
  fecha_creacion DATE DEFAULT (CURRENT_DATE), 
  id_admin INT NOT NULL,
  FOREIGN KEY (id_admin) REFERENCES Administrador(id_usuario)
);


CREATE TABLE Pregunta (
  id_pregunta INT AUTO_INCREMENT PRIMARY KEY,
  texto VARCHAR(255) NOT NULL,
  tipo ENUM('Abierta', 'Opcion Multiple', 'Seleccion Unica', 'Escala') NOT NULL, 
  id_encuesta INT NOT NULL,
  FOREIGN KEY (id_encuesta) REFERENCES Encuesta(id_encuesta) ON DELETE CASCADE
);

-- 6. Tabla Respuesta (Apunta directamente a Encuestado)
CREATE TABLE Respuesta (
  id_respuesta INT AUTO_INCREMENT PRIMARY KEY,
  id_encuestado INT NOT NULL,
  id_pregunta INT NOT NULL,
  contenido TEXT NOT NULL,
  fecha DATE DEFAULT (CURRENT_DATE),
  FOREIGN KEY (id_encuestado) REFERENCES Encuestado(id_usuario),
  FOREIGN KEY (id_pregunta) REFERENCES Pregunta(id_pregunta) ON DELETE CASCADE
);






INSERT INTO Usuario (rut, nombre, email, contrasena, rol) VALUES
('11111111-1', 'Juan Pérez', 'juan.perez@empresa.com', 'hash_123', 'Administrador'),
('22222222-2', 'María Gómez', 'maria.gomez@empresa.com', 'hash_456', 'Administrador'),
('33333333-3', 'Carlos López', 'carlos.lopez@mail.com', 'hash_789', 'Encuestado'),
('44444444-4', 'Ana Silva', 'ana.silva@mail.com', 'hash_abc', 'Encuestado'),
('55555555-5', 'Luis Rojas', 'luis.rojas@mail.com', 'hash_def', 'Encuestado');


INSERT INTO Administrador (id_usuario, cargo, fecha_contratacion) VALUES
((SELECT id_usuario FROM Usuario where rut='11111111-1'), 'Gerente de Proyectos', '2023-01-15'),
((SELECT id_usuario FROM Usuario where rut="22222222-2"), 'Analista de Datos', '2023-05-20');


INSERT INTO Encuestado (id_usuario, fecha_nacimiento, genero, pais, ocupacion) VALUES
((SELECT id_usuario FROM Usuario where rut='33333333-3'), 1998-05-15, 'Masculino', 'Chile', 'Ingeniero Comercial'),
((SELECT id_usuario FROM Usuario where rut='44444444-4'), 1992-08-20, 'Femenino', 'Chile', 'Profesora'),
((SELECT id_usuario FROM Usuario where rut="55555555-5"), 1987-10-1, 'Masculino', 'México', 'Estudiante');


INSERT INTO Encuesta (titulo, descripcion, id_admin) VALUES
('Clima Laboral 2024', 'Encuesta para medir la satisfacción del equipo.', 1),
('Hábitos de Consumo', 'Estudio sobre preferencias de compra online.', 2);


INSERT INTO Pregunta (texto, tipo, id_encuesta) VALUES
('¿Cómo calificarías tu ambiente de trabajo?', 'Escala', 1),
('¿Qué mejorarías de la oficina?', 'Abierta', 1),
('¿Cuál es tu método de pago preferido?', 'Seleccion Unica', 2);


INSERT INTO Respuesta (id_encuestado, id_pregunta, contenido) VALUES
(3, 1, '4'),
(3, 2, 'Mejores sillas ergonómicas'),
(4, 3, 'Tarjeta de Crédito'),
(5, 3, 'Transferencia Bancaria');