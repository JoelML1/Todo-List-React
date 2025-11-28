# Base de Datos Todo List

Esta es la estructura de base de datos MySQL para la aplicación Todo List.

## 📊 Estructura de Tablas

### Users (Usuarios)
- `id`: ID único del usuario
- `username`: Nombre de usuario único
- `email`: Correo electrónico único
- `password_hash`: Contraseña hasheada
- `created_at`, `updated_at`: Timestamps

### Categories (Categorías)
- `id`: ID único de categoría
- `user_id`: Referencia al usuario
- `name`: Nombre de la categoría
- `color`: Color en formato hexadecimal
- `created_at`: Timestamp

### Todos (Tareas)
- `id`: ID único de la tarea
- `user_id`: Referencia al usuario
- `category_id`: Referencia a la categoría (opcional)
- `title`: Título de la tarea
- `description`: Descripción detallada
- `completed`: Estado de completado
- `priority`: Prioridad (low, medium, high)
- `due_date`: Fecha de vencimiento
- `created_at`, `updated_at`, `completed_at`: Timestamps

### Tags (Etiquetas)
- `id`: ID único de la etiqueta
- `user_id`: Referencia al usuario
- `name`: Nombre de la etiqueta
- `color`: Color en formato hexadecimal
- `created_at`: Timestamp

### Todo_Tags (Relación Tareas-Etiquetas)
- `todo_id`: Referencia a la tarea
- `tag_id`: Referencia a la etiqueta
- `created_at`: Timestamp

### Subtasks (Subtareas)
- `id`: ID único de la subtarea
- `todo_id`: Referencia a la tarea padre
- `title`: Título de la subtarea
- `completed`: Estado de completado
- `position`: Orden de la subtarea
- `created_at`, `updated_at`: Timestamps

## 🚀 Instalación Local (MySQL)

### 1. Instalar MySQL
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install mysql-server

# MacOS
brew install mysql

# Windows
# Descargar desde https://dev.mysql.com/downloads/mysql/
```

### 2. Iniciar MySQL
```bash
# Linux
sudo systemctl start mysql
sudo mysql_secure_installation

# MacOS
brew services start mysql

# Conectarse a MySQL
mysql -u root -p
```

### 3. Crear la Base de Datos
```bash
# Ejecutar el schema
mysql -u root -p < database/schema.sql

# Cargar datos de ejemplo (opcional)
mysql -u root -p < database/seed.sql
```

### 4. Crear Usuario de Aplicación
```sql
CREATE USER 'todolist_user'@'localhost' IDENTIFIED BY 'tu_password_seguro';
GRANT ALL PRIVILEGES ON todo_list_db.* TO 'todolist_user'@'localhost';
FLUSH PRIVILEGES;
```

## ☁️ Deploy en Railway

### Opción 1: Desde la Interfaz Web

1. Ve a [Railway.app](https://railway.app)
2. Crea una cuenta o inicia sesión
3. Click en "New Project"
4. Selecciona "Deploy MySQL"
5. Una vez creado, ve a la pestaña "Data"
6. Click en "Query" y ejecuta el contenido de `schema.sql`
7. Ejecuta `seed.sql` si quieres datos de ejemplo

### Opción 2: Usando Railway CLI

```bash
# Instalar Railway CLI
npm i -g @railway/cli

# Login
railway login

# Crear nuevo proyecto
railway init

# Agregar MySQL
railway add --database mysql

# Conectarse a la base de datos
railway connect mysql

# Ejecutar scripts
mysql < database/schema.sql
mysql < database/seed.sql
```

### Obtener Variables de Conexión

En Railway, ve a tu servicio MySQL y copia las variables:

```env
DATABASE_URL=mysql://user:password@host:port/database
MYSQL_HOST=containers-us-west-xxx.railway.app
MYSQL_PORT=6969
MYSQL_DATABASE=railway
MYSQL_USER=root
MYSQL_PASSWORD=xxxxxxxxxxxx
```

## 🔌 Conexión desde Node.js

### Instalar dependencias
```bash
npm install mysql2 dotenv
```

### Ejemplo de conexión
```javascript
// db.js
import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  port: process.env.MYSQL_PORT,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

export default pool;
```

### Ejemplo de uso
```javascript
import pool from './db.js';

// Obtener todas las tareas de un usuario
async function getTodos(userId) {
  const [rows] = await pool.execute(
    'SELECT * FROM todos WHERE user_id = ? ORDER BY created_at DESC',
    [userId]
  );
  return rows;
}

// Crear nueva tarea
async function createTodo(userId, title, description, priority) {
  const [result] = await pool.execute(
    'INSERT INTO todos (user_id, title, description, priority) VALUES (?, ?, ?, ?)',
    [userId, title, description, priority]
  );
  return result.insertId;
}
```

## 📝 Queries Útiles

Consulta el archivo `queries.sql` para ver ejemplos de:
- Obtener tareas con categorías y etiquetas
- Estadísticas del usuario
- Tareas vencidas
- Progreso por categoría
- Y más...

## 🔐 Seguridad

- Nunca expongas las credenciales de la base de datos
- Usa variables de entorno (`.env`)
- Implementa autenticación y autorización
- Usa prepared statements para prevenir SQL injection
- Hashea las contraseñas con bcrypt antes de guardarlas

## 🧪 Testing

```bash
# Probar conexión
mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE

# Verificar tablas
SHOW TABLES;

# Ver estructura
DESCRIBE todos;

# Contar registros
SELECT COUNT(*) FROM todos;
```
