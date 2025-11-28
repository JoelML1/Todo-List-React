-- Queries útiles para la aplicación Todo List
USE todo_list_db;

-- ========================================
-- QUERIES DE CONSULTA
-- ========================================

-- Obtener todas las tareas de un usuario con sus categorías y etiquetas
SELECT 
    t.id,
    t.title,
    t.description,
    t.completed,
    t.priority,
    t.due_date,
    t.created_at,
    c.name AS category_name,
    c.color AS category_color,
    GROUP_CONCAT(DISTINCT tag.name SEPARATOR ', ') AS tags
FROM todos t
LEFT JOIN categories c ON t.category_id = c.id
LEFT JOIN todo_tags tt ON t.id = tt.todo_id
LEFT JOIN tags tag ON tt.tag_id = tag.id
WHERE t.user_id = 1
GROUP BY t.id, c.name, c.color
ORDER BY t.due_date ASC, t.created_at DESC;

-- Obtener tareas pendientes con subtareas
SELECT 
    t.id AS todo_id,
    t.title AS todo_title,
    t.priority,
    t.due_date,
    COUNT(st.id) AS total_subtasks,
    SUM(CASE WHEN st.completed = 1 THEN 1 ELSE 0 END) AS completed_subtasks
FROM todos t
LEFT JOIN subtasks st ON t.id = st.todo_id
WHERE t.user_id = 1 AND t.completed = FALSE
GROUP BY t.id
ORDER BY t.due_date ASC;

-- Obtener estadísticas del usuario
SELECT 
    u.username,
    COUNT(DISTINCT t.id) AS total_tasks,
    SUM(CASE WHEN t.completed = 1 THEN 1 ELSE 0 END) AS completed_tasks,
    SUM(CASE WHEN t.completed = 0 THEN 1 ELSE 0 END) AS pending_tasks,
    COUNT(DISTINCT c.id) AS total_categories,
    COUNT(DISTINCT tag.id) AS total_tags
FROM users u
LEFT JOIN todos t ON u.id = t.user_id
LEFT JOIN categories c ON u.id = c.user_id
LEFT JOIN tags tag ON u.id = tag.user_id
WHERE u.id = 1
GROUP BY u.id, u.username;

-- Obtener tareas vencidas
SELECT 
    t.id,
    t.title,
    t.priority,
    t.due_date,
    c.name AS category,
    DATEDIFF(NOW(), t.due_date) AS days_overdue
FROM todos t
LEFT JOIN categories c ON t.category_id = c.id
WHERE t.user_id = 1 
    AND t.completed = FALSE 
    AND t.due_date < NOW()
ORDER BY t.due_date ASC;

-- Obtener tareas por prioridad
SELECT 
    t.priority,
    COUNT(*) AS task_count,
    SUM(CASE WHEN t.completed = 1 THEN 1 ELSE 0 END) AS completed
FROM todos t
WHERE t.user_id = 1
GROUP BY t.priority
ORDER BY 
    FIELD(t.priority, 'high', 'medium', 'low');

-- Obtener tareas de hoy
SELECT 
    t.id,
    t.title,
    t.priority,
    c.name AS category,
    c.color
FROM todos t
LEFT JOIN categories c ON t.category_id = c.id
WHERE t.user_id = 1
    AND DATE(t.due_date) = CURDATE()
    AND t.completed = FALSE
ORDER BY 
    FIELD(t.priority, 'high', 'medium', 'low'),
    t.created_at DESC;

-- Obtener progreso por categoría
SELECT 
    c.name AS category,
    c.color,
    COUNT(t.id) AS total_tasks,
    SUM(CASE WHEN t.completed = 1 THEN 1 ELSE 0 END) AS completed_tasks,
    ROUND(SUM(CASE WHEN t.completed = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(t.id), 2) AS completion_percentage
FROM categories c
LEFT JOIN todos t ON c.id = t.category_id
WHERE c.user_id = 1
GROUP BY c.id, c.name, c.color
HAVING COUNT(t.id) > 0
ORDER BY completion_percentage DESC;

-- ========================================
-- QUERIES DE INSERCIÓN
-- ========================================

-- Insertar nueva tarea
INSERT INTO todos (user_id, category_id, title, description, priority, due_date)
VALUES (1, 1, 'Nueva tarea', 'Descripción de la tarea', 'medium', DATE_ADD(NOW(), INTERVAL 1 DAY));

-- Insertar nueva categoría
INSERT INTO categories (user_id, name, color)
VALUES (1, 'Fitness', '#F97316');

-- Insertar nueva etiqueta
INSERT INTO tags (user_id, name, color)
VALUES (1, 'Productividad', '#06B6D4');

-- Insertar subtarea
INSERT INTO subtasks (todo_id, title, position)
VALUES (1, 'Nueva subtarea', 1);

-- ========================================
-- QUERIES DE ACTUALIZACIÓN
-- ========================================

-- Marcar tarea como completada
UPDATE todos 
SET completed = TRUE, 
    completed_at = NOW() 
WHERE id = 1 AND user_id = 1;

-- Actualizar tarea
UPDATE todos 
SET title = 'Título actualizado',
    description = 'Nueva descripción',
    priority = 'high',
    due_date = DATE_ADD(NOW(), INTERVAL 3 DAY)
WHERE id = 1 AND user_id = 1;

-- Marcar subtarea como completada
UPDATE subtasks 
SET completed = TRUE 
WHERE id = 1;

-- ========================================
-- QUERIES DE ELIMINACIÓN
-- ========================================

-- Eliminar tarea (las subtareas se eliminan automáticamente por CASCADE)
DELETE FROM todos 
WHERE id = 1 AND user_id = 1;

-- Eliminar categoría (las tareas se mantienen con category_id = NULL por SET NULL)
DELETE FROM categories 
WHERE id = 1 AND user_id = 1;

-- Eliminar etiqueta
DELETE FROM tags 
WHERE id = 1 AND user_id = 1;

-- Eliminar todas las tareas completadas de un usuario
DELETE FROM todos 
WHERE user_id = 1 AND completed = TRUE;
