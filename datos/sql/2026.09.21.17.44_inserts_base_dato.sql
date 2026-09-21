-- =====================================================
-- DATOS DE PRUEBA - Plataforma de encuestas
-- Ejecutar DESPUÉS de crear las 13 tablas, en una base vacía
-- (los IDs asumen que AUTO_INCREMENT parte en 1).
-- =====================================================

-- 1. USUARIOS (ids 1-2 administradores, ids 3-7 encuestados)
-- Las contraseñas son texto de ejemplo: en tu app real guarda hashes (bcrypt/argon2).
INSERT INTO Usuario (rut, nombre, email, contrasena, rol) VALUES
('11.111.111-1', 'Camila Rojas',     'camila.rojas@ejemplo.cl',     'hash_ejemplo_1', 'Administrador'),
('22.222.222-2', 'Felipe Soto',      'felipe.soto@ejemplo.cl',      'hash_ejemplo_2', 'Administrador'),
('33.333.333-3', 'Valentina Muñoz',  'valentina.munoz@ejemplo.cl',  'hash_ejemplo_3', 'Encuestado'),
('44.444.444-4', 'Matías González',  'matias.gonzalez@ejemplo.cl',  'hash_ejemplo_4', 'Encuestado'),
('55.555.555-5', 'Javiera Pérez',    'javiera.perez@ejemplo.cl',    'hash_ejemplo_5', 'Encuestado'),
('66.666.666-6', 'Diego Fuentes',    'diego.fuentes@ejemplo.cl',    'hash_ejemplo_6', 'Encuestado'),
('77.777.777-7', 'Constanza Vega',   'constanza.vega@ejemplo.cl',   'hash_ejemplo_7', 'Encuestado');

INSERT INTO Administrador (id_usuario, cargo, fecha_contratacion) VALUES
(1, 'Jefa de Estudios',     '2022-03-15'),
(2, 'Analista de Datos',    '2023-08-01');

INSERT INTO Encuestado (id_usuario, fecha_nacimiento, genero, pais, ocupacion) VALUES
(3, '1998-03-15', 'Femenino',  'Chile',     'Ingeniera'),
(4, '1991-07-22', 'Masculino', 'Chile',     'Comerciante'),
(5, '2004-01-10', 'Femenino',  'Argentina', 'Estudiante'),
(6, '1985-11-08', 'Masculino', 'Chile',     'Profesor'),
(7, '2007-05-30', 'Femenino',  'Perú',      'Estudiante');

-- 2. CATEGORÍAS
INSERT INTO Categoria (nombre, descripcion) VALUES
('Satisfacción del cliente', 'Encuestas para medir la experiencia con productos y servicios'),
('Educación',                'Encuestas sobre hábitos y experiencias de estudio'),
('Salud y bienestar',        'Encuestas sobre hábitos saludables');

-- 3. ENCUESTAS
INSERT INTO Encuesta (titulo, descripcion, fecha_expiracion, estado, id_admin, id_categoria) VALUES
('Satisfacción con nuestro servicio', 'Queremos conocer tu opinión sobre la atención recibida', '2026-12-31', 'PUBLICADA', 1, 1),
('Hábitos de estudio',                'Encuesta sobre cómo y cuánto estudian los alumnos',     '2026-12-31', 'PUBLICADA', 2, 2),
('Bienestar y vida saludable',        'Encuesta en preparación',                               NULL,         'BORRADOR',  2, 3);

-- 4. PREGUNTAS
-- Encuesta 1: ids 1-4 | Encuesta 2: ids 5-6
INSERT INTO Pregunta (texto, obligatoria, orden, tipo, id_encuesta) VALUES
('¿Qué mejorarías de nuestro servicio?',                        FALSE, 1, 'Abierta',         1),
('¿Cómo te enteraste de nosotros?',                             TRUE,  2, 'Seleccion Unica', 1),
('¿Qué aspectos valoras más? (puedes elegir varios)',           TRUE,  3, 'Opcion Multiple', 1),
('Del 1 al 10, ¿qué tan probable es que nos recomiendes?',      TRUE,  4, 'Escala',          1),
('¿Cuántas horas estudias al día?',                             TRUE,  1, 'Seleccion Unica', 2),
('Del 1 al 5, ¿qué tan satisfecho estás con tu método de estudio?', TRUE, 2, 'Escala',       2);

-- Tablas específicas según tipo de pregunta
INSERT INTO PreguntaAbierta (id_pregunta, max_caracteres) VALUES
(1, 500);

INSERT INTO PreguntaMultiple (id_pregunta, permite_multiple) VALUES
(2, FALSE),
(3, TRUE),
(5, FALSE);

INSERT INTO PreguntaEscala (id_pregunta, escala_min, escala_max) VALUES
(4, 1, 10),
(6, 1, 5);

-- 5. OPCIONES (contador_votos se calcula más abajo a partir de las respuestas)
INSERT INTO Opcion (texto, id_pregunta) VALUES
-- Pregunta 2
('Redes sociales',              2),
('Recomendación de un amigo',   2),
('Búsqueda en Google',          2),
('Publicidad en la calle',      2),
-- Pregunta 3
('Precio',                      3),
('Atención al cliente',         3),
('Rapidez',                     3),
('Calidad',                     3),
-- Pregunta 5
('Menos de 1 hora',             5),
('1 a 2 horas',                 5),
('3 a 4 horas',                 5),
('Más de 4 horas',              5);

-- 6. PARTICIPACIONES
-- Cada encuestado participa una sola vez por encuesta.
INSERT INTO ParticipacionEncuesta (id_encuestado, id_encuesta, completada) VALUES
(3, 1, TRUE),   -- id 1
(4, 1, TRUE),   -- id 2
(5, 1, TRUE),   -- id 3
(6, 1, FALSE),  -- id 4 (incompleta: solo respondió una pregunta)
(3, 2, TRUE),   -- id 5
(7, 2, TRUE);   -- id 6

-- 7. RESPUESTAS
-- En preguntas de opciones, "valor" guarda el texto de la opción elegida
-- (una fila por cada opción marcada en la pregunta múltiple).
INSERT INTO Respuesta (id_participacion, id_pregunta, valor) VALUES
-- Participación 1 (Valentina, encuesta 1)
(1, 1, 'Más horarios de atención'),
(1, 2, 'Redes sociales'),
(1, 3, 'Precio'),
(1, 3, 'Rapidez'),
(1, 4, '9'),
-- Participación 2 (Matías, encuesta 1)
(2, 1, 'Todo excelente, sigan así'),
(2, 2, 'Recomendación de un amigo'),
(2, 3, 'Atención al cliente'),
(2, 4, '10'),
-- Participación 3 (Javiera, encuesta 1)
(3, 1, 'Bajar un poco los precios'),
(3, 2, 'Recomendación de un amigo'),
(3, 3, 'Precio'),
(3, 3, 'Calidad'),
(3, 3, 'Atención al cliente'),
(3, 4, '7'),
-- Participación 4 (Diego, encuesta 1, incompleta)
(4, 2, 'Búsqueda en Google'),
-- Participación 5 (Valentina, encuesta 2)
(5, 5, '1 a 2 horas'),
(5, 6, '4'),
-- Participación 6 (Constanza, encuesta 2)
(6, 5, '3 a 4 horas'),
(6, 6, '3');

-- 8. CONTADOR DE VOTOS (se calcula desde las respuestas para que sea consistente)
UPDATE Opcion o
SET contador_votos = (
  SELECT COUNT(*) FROM Respuesta r
  WHERE r.id_pregunta = o.id_pregunta AND r.valor = o.texto
);

-- 9. REPORTES (totales calculados desde las participaciones y respuestas)
INSERT INTO Reporte (id_encuesta, total_participantes, total_respuestas)
SELECT e.id_encuesta,
       (SELECT COUNT(*) FROM ParticipacionEncuesta p
         WHERE p.id_encuesta = e.id_encuesta),
       (SELECT COUNT(*) FROM Respuesta r
          JOIN ParticipacionEncuesta p ON p.id_participacion = r.id_participacion
         WHERE p.id_encuesta = e.id_encuesta)
FROM Encuesta e
WHERE e.estado = 'PUBLICADA';
