-- Datos de ejemplo para Todo List Application
USE todo_list_db;

-- Insertar usuarios de ejemplo (contraseña: "password123" - deberías usar hash bcrypt en producción)
INSERT INTO users (username, email, password_hash) VALUES
('johndoe', 'john@example.com', '$2b$10$rKvVLrN8NqZ.iqWyJlC1kOH7VmqYxjGz9qEqW8qxQXqxqxqxqxqxq'),
('janedoe', 'jane@example.com', '$2b$10$rKvVLrN8NqZ.iqWyJlC1kOH7VmqYxjGz9qEqW8qxQXqxqxqxqxqxq'),
('demo', 'demo@example.com', '$2b$10$rKvVLrN8NqZ.iqWyJlC1kOH7VmqYxjGz9qEqW8qxQXqxqxqxqxqxq');

-- Insertar categorías
INSERT INTO categories (user_id, name, color) VALUES
(1, 'Trabajo', '#EF4444'),
(1, 'Personal', '#3B82F6'),
(1, 'Estudios', '#10B981'),
(2, 'Casa', '#F59E0B'),
(2, 'Proyectos', '#8B5CF6');

-- Insertar tareas
INSERT INTO todos (user_id, category_id, title, description, completed, priority, due_date) VALUES
(1, 1, 'Completar informe mensual', 'Revisar métricas y crear presentación', FALSE, 'high', DATE_ADD(NOW(), INTERVAL 2 DAY)),
(1, 1, 'Reunión con el equipo', 'Discutir roadmap del Q4', FALSE, 'medium', DATE_ADD(NOW(), INTERVAL 1 DAY)),
(1, 2, 'Comprar despensa', 'Hacer lista de supermercado', FALSE, 'low', DATE_ADD(NOW(), INTERVAL 3 DAY)),
(1, 3, 'Estudiar React Hooks', 'Completar tutorial de useContext y useReducer', TRUE, 'high', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(1, 2, 'Hacer ejercicio', 'Rutina de cardio 30 minutos', FALSE, 'medium', NOW()),
(2, 4, 'Limpiar garaje', 'Organizar herramientas y donar cosas viejas', FALSE, 'low', DATE_ADD(NOW(), INTERVAL 7 DAY)),
(2, 5, 'Actualizar portafolio', 'Agregar últimos proyectos', FALSE, 'high', DATE_ADD(NOW(), INTERVAL 5 DAY));

-- Insertar etiquetas
INSERT INTO tags (user_id, name, color) VALUES
(1, 'Urgente', '#DC2626'),
(1, 'Importante', '#F59E0B'),
(1, 'Rápido', '#10B981'),
(1, 'Largo plazo', '#6366F1'),
(2, 'Casa', '#EC4899'),
(2, 'Creatividad', '#8B5CF6');

-- Relacionar tareas con etiquetas
INSERT INTO todo_tags (todo_id, tag_id) VALUES
(1, 1), -- Informe mensual: Urgente
(1, 2), -- Informe mensual: Importante
(2, 2), -- Reunión: Importante
(4, 3), -- Estudiar React: Rápido
(7, 6); -- Actualizar portafolio: Creatividad

-- Insertar subtareas
INSERT INTO subtasks (todo_id, title, completed, position) VALUES
(1, 'Recopilar datos de ventas', FALSE, 1),
(1, 'Crear gráficos', FALSE, 2),
(1, 'Escribir análisis', FALSE, 3),
(1, 'Revisar con supervisor', FALSE, 4),
(3, 'Hacer lista de productos', TRUE, 1),
(3, 'Comparar precios', FALSE, 2),
(7, 'Seleccionar mejores proyectos', FALSE, 1),
(7, 'Tomar capturas de pantalla', FALSE, 2),
(7, 'Escribir descripciones', FALSE, 3),
(7, 'Actualizar GitHub', FALSE, 4);
