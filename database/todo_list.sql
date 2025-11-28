-- ============================================
-- BASE DE DATOS: TODO LIST APPLICATION
-- Sistema completo de gestión de tareas
-- ============================================

-- Eliminar la base de datos si existe
DROP DATABASE IF EXISTS todo_list_db;

-- Crear la base de datos
CREATE DATABASE todo_list_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE todo_list_db;

-- ============================================
-- TABLA: usuarios
-- Gestión de usuarios del sistema
-- ============================================
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_sesion TIMESTAMP NULL,
    estado ENUM('activo', 'inactivo', 'suspendido') DEFAULT 'activo',
    INDEX idx_email (email),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: categorias
-- Categorías para organizar las tareas
-- ============================================
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    color VARCHAR(7) DEFAULT '#3B82F6',
    icono VARCHAR(50) DEFAULT 'folder',
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_usuario (usuario_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: tareas
-- Tabla principal de tareas/todos
-- ============================================
CREATE TABLE tareas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    categoria_id INT NULL,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    prioridad ENUM('baja', 'media', 'alta', 'urgente') DEFAULT 'media',
    estado ENUM('pendiente', 'en_progreso', 'completada', 'cancelada') DEFAULT 'pendiente',
    completada BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    fecha_vencimiento DATETIME NULL,
    fecha_completada DATETIME NULL,
    posicion INT DEFAULT 0,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL,
    INDEX idx_usuario (usuario_id),
    INDEX idx_categoria (categoria_id),
    INDEX idx_estado (estado),
    INDEX idx_prioridad (prioridad),
    INDEX idx_fecha_vencimiento (fecha_vencimiento),
    INDEX idx_completada (completada)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: etiquetas
-- Tags para clasificar tareas
-- ============================================
CREATE TABLE etiquetas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    color VARCHAR(7) DEFAULT '#10B981',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    UNIQUE KEY unique_etiqueta_usuario (usuario_id, nombre),
    INDEX idx_usuario (usuario_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: tareas_etiquetas
-- Relación muchos a muchos entre tareas y etiquetas
-- ============================================
CREATE TABLE tareas_etiquetas (
    tarea_id INT NOT NULL,
    etiqueta_id INT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (tarea_id, etiqueta_id),
    FOREIGN KEY (tarea_id) REFERENCES tareas(id) ON DELETE CASCADE,
    FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id) ON DELETE CASCADE,
    INDEX idx_tarea (tarea_id),
    INDEX idx_etiqueta (etiqueta_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: subtareas
-- Subtareas o checklist dentro de una tarea
-- ============================================
CREATE TABLE subtareas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarea_id INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    completada BOOLEAN DEFAULT FALSE,
    posicion INT DEFAULT 0,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_completada DATETIME NULL,
    FOREIGN KEY (tarea_id) REFERENCES tareas(id) ON DELETE CASCADE,
    INDEX idx_tarea (tarea_id),
    INDEX idx_completada (completada)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: comentarios
-- Comentarios y notas en las tareas
-- ============================================
CREATE TABLE comentarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarea_id INT NOT NULL,
    usuario_id INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tarea_id) REFERENCES tareas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_tarea (tarea_id),
    INDEX idx_usuario (usuario_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: adjuntos
-- Archivos adjuntos a las tareas
-- ============================================
CREATE TABLE adjuntos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarea_id INT NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    ruta_archivo VARCHAR(500) NOT NULL,
    tipo_mime VARCHAR(100),
    tamano_bytes BIGINT,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tarea_id) REFERENCES tareas(id) ON DELETE CASCADE,
    INDEX idx_tarea (tarea_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: recordatorios
-- Recordatorios para las tareas
-- ============================================
CREATE TABLE recordatorios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarea_id INT NOT NULL,
    fecha_recordatorio DATETIME NOT NULL,
    tipo ENUM('email', 'notificacion', 'ambos') DEFAULT 'notificacion',
    enviado BOOLEAN DEFAULT FALSE,
    fecha_envio DATETIME NULL,
    FOREIGN KEY (tarea_id) REFERENCES tareas(id) ON DELETE CASCADE,
    INDEX idx_tarea (tarea_id),
    INDEX idx_fecha_recordatorio (fecha_recordatorio),
    INDEX idx_enviado (enviado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: actividad_log
-- Registro de actividades del usuario
-- ============================================
CREATE TABLE actividad_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tarea_id INT NULL,
    accion VARCHAR(100) NOT NULL,
    descripcion TEXT,
    ip_address VARCHAR(45),
    user_agent VARCHAR(255),
    fecha_actividad TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (tarea_id) REFERENCES tareas(id) ON DELETE SET NULL,
    INDEX idx_usuario (usuario_id),
    INDEX idx_tarea (tarea_id),
    INDEX idx_fecha (fecha_actividad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: configuracion_usuario
-- Preferencias y configuración del usuario
-- ============================================
CREATE TABLE configuracion_usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL UNIQUE,
    tema ENUM('light', 'dark', 'auto') DEFAULT 'light',
    idioma VARCHAR(5) DEFAULT 'es',
    notificaciones_email BOOLEAN DEFAULT TRUE,
    notificaciones_push BOOLEAN DEFAULT TRUE,
    vista_predeterminada ENUM('lista', 'cuadricula', 'kanban') DEFAULT 'lista',
    orden_predeterminado ENUM('fecha_creacion', 'fecha_vencimiento', 'prioridad', 'alfabetico') DEFAULT 'fecha_creacion',
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- DATOS DE EJEMPLO (OPCIONAL)
-- ============================================

-- Insertar usuario de prueba
INSERT INTO usuarios (nombre, email, password, estado) VALUES
('Usuario Demo', 'demo@todolist.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'activo'),
('Juan Pérez', 'juan@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'activo'),
('María García', 'maria@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'activo');

-- Insertar categorías de ejemplo
INSERT INTO categorias (usuario_id, nombre, color, icono, descripcion) VALUES
(1, 'Personal', '#3B82F6', 'user', 'Tareas personales'),
(1, 'Trabajo', '#EF4444', 'briefcase', 'Tareas laborales'),
(1, 'Estudios', '#10B981', 'book', 'Tareas académicas'),
(1, 'Hogar', '#F59E0B', 'home', 'Tareas del hogar'),
(2, 'Proyectos', '#8B5CF6', 'folder', 'Proyectos en curso'),
(3, 'Compras', '#EC4899', 'shopping-cart', 'Lista de compras');

-- Insertar etiquetas de ejemplo
INSERT INTO etiquetas (usuario_id, nombre, color) VALUES
(1, 'Urgente', '#EF4444'),
(1, 'Importante', '#F59E0B'),
(1, 'Rápido', '#10B981'),
(1, 'Revisión', '#3B82F6'),
(2, 'Reunión', '#8B5CF6'),
(3, 'Pendiente', '#6B7280');

-- Insertar tareas de ejemplo
INSERT INTO tareas (usuario_id, categoria_id, titulo, descripcion, prioridad, estado, fecha_vencimiento) VALUES
(1, 1, 'Comprar ingredientes para la cena', 'Comprar: tomates, pasta, queso parmesano, albahaca', 'media', 'pendiente', DATE_ADD(NOW(), INTERVAL 1 DAY)),
(1, 2, 'Terminar reporte mensual', 'Completar análisis de ventas y presentación', 'alta', 'en_progreso', DATE_ADD(NOW(), INTERVAL 3 DAY)),
(1, 3, 'Estudiar para examen de matemáticas', 'Repasar capítulos 5-8', 'alta', 'pendiente', DATE_ADD(NOW(), INTERVAL 5 DAY)),
(1, 1, 'Hacer ejercicio', 'Rutina de 30 minutos', 'media', 'pendiente', NOW()),
(2, 5, 'Desarrollar nueva funcionalidad', 'Implementar sistema de notificaciones', 'urgente', 'en_progreso', DATE_ADD(NOW(), INTERVAL 2 DAY)),
(3, 6, 'Comprar regalo cumpleaños', 'Buscar ideas de regalo para Ana', 'baja', 'pendiente', DATE_ADD(NOW(), INTERVAL 7 DAY));

-- Insertar subtareas de ejemplo
INSERT INTO subtareas (tarea_id, titulo, completada, posicion) VALUES
(2, 'Recopilar datos de ventas', TRUE, 1),
(2, 'Crear gráficos', TRUE, 2),
(2, 'Escribir análisis', FALSE, 3),
(2, 'Revisar presentación', FALSE, 4),
(3, 'Leer capítulo 5', TRUE, 1),
(3, 'Hacer ejercicios capítulo 6', FALSE, 2),
(3, 'Resolver exámenes anteriores', FALSE, 3);

-- Insertar relaciones tareas-etiquetas
INSERT INTO tareas_etiquetas (tarea_id, etiqueta_id) VALUES
(1, 3),
(2, 1),
(2, 2),
(3, 2),
(5, 1);

-- Insertar comentarios de ejemplo
INSERT INTO comentarios (tarea_id, usuario_id, contenido) VALUES
(2, 1, 'Necesito coordinar con el equipo de ventas'),
(2, 1, 'Actualización: Ya tengo los datos del Q3'),
(3, 1, 'Recordar hacer el simulacro completo');

-- Insertar recordatorios de ejemplo
INSERT INTO recordatorios (tarea_id, fecha_recordatorio, tipo) VALUES
(2, DATE_ADD(NOW(), INTERVAL 2 DAY), 'notificacion'),
(3, DATE_ADD(NOW(), INTERVAL 4 DAY), 'ambos'),
(4, NOW(), 'notificacion');

-- Insertar configuración de usuario
INSERT INTO configuracion_usuario (usuario_id, tema, idioma, vista_predeterminada) VALUES
(1, 'dark', 'es', 'lista'),
(2, 'light', 'es', 'kanban'),
(3, 'auto', 'es', 'cuadricula');

-- ============================================
-- VISTAS ÚTILES
-- ============================================

-- Vista: Resumen de tareas por usuario
CREATE VIEW vista_resumen_tareas AS
SELECT 
    u.id AS usuario_id,
    u.nombre AS usuario_nombre,
    COUNT(t.id) AS total_tareas,
    SUM(CASE WHEN t.completada = TRUE THEN 1 ELSE 0 END) AS tareas_completadas,
    SUM(CASE WHEN t.estado = 'pendiente' THEN 1 ELSE 0 END) AS tareas_pendientes,
    SUM(CASE WHEN t.estado = 'en_progreso' THEN 1 ELSE 0 END) AS tareas_en_progreso,
    SUM(CASE WHEN t.prioridad = 'urgente' THEN 1 ELSE 0 END) AS tareas_urgentes,
    SUM(CASE WHEN t.fecha_vencimiento < NOW() AND t.completada = FALSE THEN 1 ELSE 0 END) AS tareas_vencidas
FROM usuarios u
LEFT JOIN tareas t ON u.id = t.usuario_id
GROUP BY u.id, u.nombre;

-- Vista: Tareas con detalles completos
CREATE VIEW vista_tareas_completas AS
SELECT 
    t.id,
    t.titulo,
    t.descripcion,
    t.prioridad,
    t.estado,
    t.completada,
    t.fecha_creacion,
    t.fecha_vencimiento,
    u.nombre AS usuario_nombre,
    u.email AS usuario_email,
    c.nombre AS categoria_nombre,
    c.color AS categoria_color,
    GROUP_CONCAT(DISTINCT e.nombre SEPARATOR ', ') AS etiquetas,
    COUNT(DISTINCT s.id) AS total_subtareas,
    SUM(CASE WHEN s.completada = TRUE THEN 1 ELSE 0 END) AS subtareas_completadas,
    COUNT(DISTINCT com.id) AS total_comentarios
FROM tareas t
INNER JOIN usuarios u ON t.usuario_id = u.id
LEFT JOIN categorias c ON t.categoria_id = c.id
LEFT JOIN tareas_etiquetas te ON t.id = te.tarea_id
LEFT JOIN etiquetas e ON te.etiqueta_id = e.id
LEFT JOIN subtareas s ON t.id = s.tarea_id
LEFT JOIN comentarios com ON t.id = com.tarea_id
GROUP BY t.id, t.titulo, t.descripcion, t.prioridad, t.estado, t.completada, 
         t.fecha_creacion, t.fecha_vencimiento, u.nombre, u.email, c.nombre, c.color;

-- ============================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================

-- Procedimiento: Marcar tarea como completada
DELIMITER //
CREATE PROCEDURE completar_tarea(IN p_tarea_id INT)
BEGIN
    UPDATE tareas 
    SET completada = TRUE, 
        estado = 'completada',
        fecha_completada = NOW()
    WHERE id = p_tarea_id;
    
    -- Registrar actividad
    INSERT INTO actividad_log (usuario_id, tarea_id, accion, descripcion)
    SELECT usuario_id, id, 'tarea_completada', CONCAT('Tarea "', titulo, '" marcada como completada')
    FROM tareas WHERE id = p_tarea_id;
END //
DELIMITER ;

-- Procedimiento: Obtener estadísticas del usuario
DELIMITER //
CREATE PROCEDURE obtener_estadisticas_usuario(IN p_usuario_id INT)
BEGIN
    SELECT 
        COUNT(*) AS total_tareas,
        SUM(CASE WHEN completada = TRUE THEN 1 ELSE 0 END) AS completadas,
        SUM(CASE WHEN estado = 'pendiente' THEN 1 ELSE 0 END) AS pendientes,
        SUM(CASE WHEN estado = 'en_progreso' THEN 1 ELSE 0 END) AS en_progreso,
        SUM(CASE WHEN prioridad = 'urgente' THEN 1 ELSE 0 END) AS urgentes,
        SUM(CASE WHEN fecha_vencimiento < NOW() AND completada = FALSE THEN 1 ELSE 0 END) AS vencidas,
        SUM(CASE WHEN DATE(fecha_vencimiento) = CURDATE() AND completada = FALSE THEN 1 ELSE 0 END) AS para_hoy
    FROM tareas
    WHERE usuario_id = p_usuario_id;
END //
DELIMITER ;

-- Procedimiento: Limpiar tareas completadas antiguas
DELIMITER //
CREATE PROCEDURE limpiar_tareas_antiguas(IN p_dias INT)
BEGIN
    DELETE FROM tareas 
    WHERE completada = TRUE 
    AND fecha_completada < DATE_SUB(NOW(), INTERVAL p_dias DAY);
    
    SELECT ROW_COUNT() AS tareas_eliminadas;
END //
DELIMITER ;

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger: Actualizar fecha de completada cuando se marca como completada
DELIMITER //
CREATE TRIGGER actualizar_fecha_completada
BEFORE UPDATE ON tareas
FOR EACH ROW
BEGIN
    IF NEW.completada = TRUE AND OLD.completada = FALSE THEN
        SET NEW.fecha_completada = NOW();
        SET NEW.estado = 'completada';
    END IF;
    
    IF NEW.completada = FALSE AND OLD.completada = TRUE THEN
        SET NEW.fecha_completada = NULL;
    END IF;
END //
DELIMITER ;

-- Trigger: Registrar actividad al crear una tarea
DELIMITER //
CREATE TRIGGER log_crear_tarea
AFTER INSERT ON tareas
FOR EACH ROW
BEGIN
    INSERT INTO actividad_log (usuario_id, tarea_id, accion, descripcion)
    VALUES (NEW.usuario_id, NEW.id, 'tarea_creada', CONCAT('Nueva tarea: "', NEW.titulo, '"'));
END //
DELIMITER ;

-- Trigger: Registrar actividad al eliminar una tarea
DELIMITER //
CREATE TRIGGER log_eliminar_tarea
BEFORE DELETE ON tareas
FOR EACH ROW
BEGIN
    INSERT INTO actividad_log (usuario_id, tarea_id, accion, descripcion)
    VALUES (OLD.usuario_id, OLD.id, 'tarea_eliminada', CONCAT('Tarea eliminada: "', OLD.titulo, '"'));
END //
DELIMITER ;

-- ============================================
-- EVENTOS (Requiere activar event_scheduler)
-- ============================================

-- Habilitar el programador de eventos
SET GLOBAL event_scheduler = ON;

-- Evento: Limpiar logs antiguos (cada día a medianoche)
DELIMITER //
CREATE EVENT limpiar_logs_antiguos
ON SCHEDULE EVERY 1 DAY
STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY)
DO
BEGIN
    DELETE FROM actividad_log 
    WHERE fecha_actividad < DATE_SUB(NOW(), INTERVAL 90 DAY);
END //
DELIMITER ;

-- Evento: Enviar recordatorios pendientes (cada 15 minutos)
DELIMITER //
CREATE EVENT procesar_recordatorios
ON SCHEDULE EVERY 15 MINUTE
DO
BEGIN
    UPDATE recordatorios 
    SET enviado = TRUE, fecha_envio = NOW()
    WHERE fecha_recordatorio <= NOW() 
    AND enviado = FALSE;
END //
DELIMITER ;

-- ============================================
-- CONSULTAS ÚTILES DE EJEMPLO
-- ============================================

-- Ver todas las tareas pendientes de un usuario
-- SELECT * FROM vista_tareas_completas WHERE usuario_email = 'demo@todolist.com' AND completada = FALSE;

-- Ver estadísticas de un usuario
-- CALL obtener_estadisticas_usuario(1);

-- Completar una tarea
-- CALL completar_tarea(1);

-- Ver resumen de todos los usuarios
-- SELECT * FROM vista_resumen_tareas;

-- Tareas vencidas
-- SELECT * FROM tareas WHERE fecha_vencimiento < NOW() AND completada = FALSE;

-- Tareas para hoy
-- SELECT * FROM tareas WHERE DATE(fecha_vencimiento) = CURDATE() AND completada = FALSE;

-- ============================================
-- FIN DEL SCRIPT
-- ============================================
