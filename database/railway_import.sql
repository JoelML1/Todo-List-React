-- Base de datos simplificada para importar en Railway
-- Ya estamos en la base de datos 'railway', no necesitamos CREATE DATABASE

-- ============================================
-- TABLA: usuarios
-- ============================================
CREATE TABLE IF NOT EXISTS usuarios (
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
-- ============================================
CREATE TABLE IF NOT EXISTS categorias (
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
-- ============================================
CREATE TABLE IF NOT EXISTS tareas (
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
-- ============================================
CREATE TABLE IF NOT EXISTS etiquetas (
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
-- ============================================
CREATE TABLE IF NOT EXISTS tareas_etiquetas (
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
-- ============================================
CREATE TABLE IF NOT EXISTS subtareas (
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
-- ============================================
CREATE TABLE IF NOT EXISTS comentarios (
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
-- ============================================
CREATE TABLE IF NOT EXISTS adjuntos (
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
-- ============================================
CREATE TABLE IF NOT EXISTS recordatorios (
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
-- ============================================
CREATE TABLE IF NOT EXISTS actividad_log (
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
-- ============================================
CREATE TABLE IF NOT EXISTS configuracion_usuario (
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
-- DATOS DE EJEMPLO
-- ============================================

INSERT INTO usuarios (nombre, email, password, estado) VALUES
('Usuario Demo', 'demo@todolist.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'activo'),
('Juan Pérez', 'juan@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'activo'),
('María García', 'maria@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'activo');

INSERT INTO categorias (usuario_id, nombre, color, icono, descripcion) VALUES
(1, 'Personal', '#3B82F6', 'user', 'Tareas personales'),
(1, 'Trabajo', '#EF4444', 'briefcase', 'Tareas laborales'),
(1, 'Estudios', '#10B981', 'book', 'Tareas académicas'),
(1, 'Hogar', '#F59E0B', 'home', 'Tareas del hogar'),
(2, 'Proyectos', '#8B5CF6', 'folder', 'Proyectos en curso'),
(3, 'Compras', '#EC4899', 'shopping-cart', 'Lista de compras');

INSERT INTO etiquetas (usuario_id, nombre, color) VALUES
(1, 'Urgente', '#EF4444'),
(1, 'Importante', '#F59E0B'),
(1, 'Rápido', '#10B981'),
(1, 'Revisión', '#3B82F6'),
(2, 'Reunión', '#8B5CF6'),
(3, 'Pendiente', '#6B7280');

INSERT INTO tareas (usuario_id, categoria_id, titulo, descripcion, prioridad, estado, fecha_vencimiento) VALUES
(1, 1, 'Comprar ingredientes para la cena', 'Comprar: tomates, pasta, queso parmesano, albahaca', 'media', 'pendiente', DATE_ADD(NOW(), INTERVAL 1 DAY)),
(1, 2, 'Terminar reporte mensual', 'Completar análisis de ventas y presentación', 'alta', 'en_progreso', DATE_ADD(NOW(), INTERVAL 3 DAY)),
(1, 3, 'Estudiar para examen de matemáticas', 'Repasar capítulos 5-8', 'alta', 'pendiente', DATE_ADD(NOW(), INTERVAL 5 DAY)),
(1, 1, 'Hacer ejercicio', 'Rutina de 30 minutos', 'media', 'pendiente', NOW()),
(2, 5, 'Desarrollar nueva funcionalidad', 'Implementar sistema de notificaciones', 'urgente', 'en_progreso', DATE_ADD(NOW(), INTERVAL 2 DAY)),
(3, 6, 'Comprar regalo cumpleaños', 'Buscar ideas de regalo para Ana', 'baja', 'pendiente', DATE_ADD(NOW(), INTERVAL 7 DAY));

INSERT INTO subtareas (tarea_id, titulo, completada, posicion) VALUES
(2, 'Recopilar datos de ventas', TRUE, 1),
(2, 'Crear gráficos', TRUE, 2),
(2, 'Escribir análisis', FALSE, 3),
(2, 'Revisar presentación', FALSE, 4),
(3, 'Leer capítulo 5', TRUE, 1),
(3, 'Hacer ejercicios capítulo 6', FALSE, 2),
(3, 'Resolver exámenes anteriores', FALSE, 3);

INSERT INTO tareas_etiquetas (tarea_id, etiqueta_id) VALUES
(1, 3),
(2, 1),
(2, 2),
(3, 2),
(5, 1);

INSERT INTO comentarios (tarea_id, usuario_id, contenido) VALUES
(2, 1, 'Necesito coordinar con el equipo de ventas'),
(2, 1, 'Actualización: Ya tengo los datos del Q3'),
(3, 1, 'Recordar hacer el simulacro completo');

INSERT INTO recordatorios (tarea_id, fecha_recordatorio, tipo) VALUES
(2, DATE_ADD(NOW(), INTERVAL 2 DAY), 'notificacion'),
(3, DATE_ADD(NOW(), INTERVAL 4 DAY), 'ambos'),
(4, NOW(), 'notificacion');

INSERT INTO configuracion_usuario (usuario_id, tema, idioma, vista_predeterminada) VALUES
(1, 'dark', 'es', 'lista'),
(2, 'light', 'es', 'kanban'),
(3, 'auto', 'es', 'cuadricula');
