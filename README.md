# 📝 Lista de Tareas - Aplicación Full Stack

<div align="center">

![Logo](https://img.shields.io/badge/TODO-LIST-red?style=for-the-badge&logo=todoist&logoColor=white)

**Aplicación moderna de gestión de tareas con diseño 3D en negro y rojo**

[![React](https://img.shields.io/badge/React-19.1.1-61DAFB?style=for-the-badge&logo=react&logoColor=white)](https://reactjs.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.109.0-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.1.12-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)
[![Vite](https://img.shields.io/badge/Vite-7.1.2-646CFF?style=for-the-badge&logo=vite&logoColor=white)](https://vitejs.dev/)

[Demo en Vivo](https://tu-app.vercel.app) · [Reportar Bug](https://github.com/JoelML1/Todo-List-React/issues) · [Solicitar Feature](https://github.com/JoelML1/Todo-List-React/issues)

</div>

---

## 📋 Tabla de Contenidos

- [Acerca del Proyecto](#-acerca-del-proyecto)
- [Características](#-características)
- [Arquitectura](#️-arquitectura)
- [Tecnologías](#-tecnologías)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Instalación Local](#-instalación-local)
- [Documentación de API](#-documentación-de-api)
- [Despliegue en Producción](#-despliegue-en-producción)
- [Variables de Entorno](#-variables-de-entorno)
- [Scripts Disponibles](#-scripts-disponibles)
- [Solución de Problemas](#-solución-de-problemas)
- [Contribuir](#-contribuir)
- [Licencia](#-licencia)
- [Contacto](#-contacto)

---

## 🚀 Acerca del Proyecto

Esta es una aplicación full stack de gestión de tareas (TODO List) diseñada con las mejores prácticas de desarrollo moderno. Combina un frontend elegante con animaciones 3D y un backend robusto con FastAPI, todo conectado a una base de datos MySQL en la nube.

### ✨ Características Destacadas

- 🎨 **Diseño Moderno 3D**: Interfaz con gradientes negro/rojo y efectos visuales impactantes
- 🔄 **CRUD Completo**: Crear, leer, actualizar y eliminar tareas
- ✅ **Gestión de Estados**: Marcar tareas como completadas/pendientes
- ✏️ **Edición Inline**: Modificar tareas directamente desde la lista
- 📊 **Estadísticas en Tiempo Real**: Contadores de tareas totales, completadas y pendientes
- 🔌 **Indicador de Conexión**: Monitoreo en vivo del estado de la base de datos
- 📱 **Responsive**: Adaptado para móvil, tablet y desktop
- ⚡ **Optimizado**: Carga rápida y rendimiento optimizado
- 🔐 **API Documentada**: Swagger UI y ReDoc integrados
- 🌐 **Desplegado**: Frontend en Vercel, Backend y DB en Railway

### 🎯 Casos de Uso

- Gestión personal de tareas diarias
- Seguimiento de proyectos y objetivos
- Lista de compras o pendientes
- Organización de actividades

---

## 🏗️ Arquitectura

La aplicación sigue una arquitectura de tres capas completamente separada:

```
┌──────────────────────────────────────────────────────────────┐
│                         CLIENTE                              │
│                  (Navegador Web)                             │
└────────────────────────┬─────────────────────────────────────┘
                         │ HTTPS
                         ▼
┌──────────────────────────────────────────────────────────────┐
│                    CAPA DE PRESENTACIÓN                      │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │          VERCEL - Frontend                         │    │
│  │  ┌──────────────────────────────────────────┐     │    │
│  │  │  React 19 + Vite 7 + Tailwind CSS 4     │     │    │
│  │  │  - Componentes reutilizables             │     │    │
│  │  │  - Estado global con useState            │     │    │
│  │  │  - Fetch API para comunicación           │     │    │
│  │  │  - Diseño responsive y animaciones 3D    │     │    │
│  │  └──────────────────────────────────────────┘     │    │
│  └────────────────────────────────────────────────────┘    │
└────────────────────────┬─────────────────────────────────────┘
                         │ REST API (JSON)
                         ▼
┌──────────────────────────────────────────────────────────────┐
│                    CAPA DE APLICACIÓN                        │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │         RAILWAY - Backend API                      │    │
│  │  ┌──────────────────────────────────────────┐     │    │
│  │  │  FastAPI 0.109 + Uvicorn                 │     │    │
│  │  │  - Endpoints RESTful                     │     │    │
│  │  │  - Validación con Pydantic               │     │    │
│  │  │  - CORS configurado                      │     │    │
│  │  │  - Documentación automática (Swagger)    │     │    │
│  │  │  - Manejo de errores                     │     │    │
│  │  └──────────────────────────────────────────┘     │    │
│  └────────────────────────────────────────────────────┘    │
└────────────────────────┬─────────────────────────────────────┘
                         │ SQL (PyMySQL)
                         ▼
┌──────────────────────────────────────────────────────────────┐
│                    CAPA DE DATOS                             │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │         RAILWAY - MySQL Database                   │    │
│  │  ┌──────────────────────────────────────────┐     │    │
│  │  │  MySQL 8.0                               │     │    │
│  │  │  - Tablas: usuarios, tareas, categorias  │     │    │
│  │  │  - ORM: SQLAlchemy 2.0                   │     │    │
│  │  │  - Relaciones y constraints              │     │    │
│  │  │  - Índices para optimización             │     │    │
│  │  └──────────────────────────────────────────┘     │    │
│  └────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────┘
```

### Flujo de Datos

1. **Usuario** interactúa con la interfaz React
2. **Frontend** envía petición HTTP al backend
3. **FastAPI** procesa la petición y valida datos
4. **SQLAlchemy** ejecuta query en MySQL
5. **MySQL** retorna datos
6. **Backend** formatea respuesta JSON
7. **Frontend** actualiza la interfaz

---

## 💻 Tecnologías

### Frontend

| Tecnología | Versión | Descripción |
|-----------|---------|-------------|
| **React** | 19.1.1 | Framework UI declarativo |
| **Vite** | 7.1.2 | Build tool ultra rápido |
| **Tailwind CSS** | 4.1.12 | Framework CSS utility-first |
| **Heroicons** | 2.2.0 | Iconos SVG de alta calidad |
| **PostCSS** | - | Procesador CSS |
| **ESLint** | 9.34.0 | Linter de JavaScript |
| **Prettier** | 3.6.2 | Formateador de código |

### Backend

| Tecnología | Versión | Descripción |
|-----------|---------|-------------|
| **Python** | 3.11.7 | Lenguaje de programación |
| **FastAPI** | 0.109.0 | Framework web moderno |
| **Uvicorn** | 0.27.0 | Servidor ASGI de alto rendimiento |
| **SQLAlchemy** | 2.0.25 | ORM Python más popular |
| **PyMySQL** | 1.1.0 | Driver MySQL para Python |
| **Pydantic** | - | Validación de datos |
| **Python-dotenv** | 1.0.0 | Manejo de variables de entorno |

### Base de Datos

| Tecnología | Versión | Descripción |
|-----------|---------|-------------|
| **MySQL** | 8.0 | Sistema de gestión de bases de datos relacional |

### DevOps y Hosting

| Servicio | Uso | URL |
|----------|-----|-----|
| **Vercel** | Hosting del frontend | https://vercel.com |
| **Railway** | Hosting del backend y BD | https://railway.app |
| **GitHub** | Control de versiones | https://github.com |
| **Git** | Sistema de control de versiones | - |

---

## 📁 Estructura del Proyecto

```
Todo-List-React/
│
├── frontend/                           # Aplicación React
│   ├── public/                        # Archivos estáticos
│   ├── src/
│   │   ├── assets/                    # Imágenes, fuentes, etc.
│   │   ├── App.jsx                    # Componente principal
│   │   ├── TodoItem.jsx               # Componente de tarea individual
│   │   ├── Editartarea.jsx            # Componente de edición
│   │   ├── main.jsx                   # Punto de entrada
│   │   └── index.css                  # Estilos globales con Tailwind
│   ├── .env                           # Variables de entorno (no en Git)
│   ├── .env.production                # Variables para producción
│   ├── .gitignore                     # Archivos ignorados por Git
│   ├── eslint.config.js               # Configuración de ESLint
│   ├── index.html                     # HTML principal
│   ├── package.json                   # Dependencias del proyecto
│   ├── postcss.config.js              # Configuración de PostCSS
│   ├── README.md                      # Documentación del frontend
│   ├── vercel.json                    # Configuración de Vercel
│   └── vite.config.js                 # Configuración de Vite
│
├── backend/                            # API con FastAPI
│   ├── entornoV/                      # Entorno virtual Python (no en Git)
│   ├── __pycache__/                   # Cache de Python (no en Git)
│   ├── .env                           # Variables de entorno (no en Git)
│   ├── .gitignore                     # Archivos ignorados
│   ├── database.py                    # Configuración de SQLAlchemy
│   ├── main.py                        # Punto de entrada de FastAPI
│   ├── models.py                      # Modelos de base de datos
│   ├── schemas.py                     # Esquemas de Pydantic
│   ├── Procfile                       # Configuración para Railway
│   ├── README.md                      # Documentación del backend
│   ├── requirements.txt               # Dependencias Python
│   ├── runtime.txt                    # Versión de Python
│   └── railway.json                   # Configuración de Railway
│
├── database/                           # Scripts de base de datos
│   ├── schema.sql                     # Esquema de tablas
│   ├── seed.sql                       # Datos de ejemplo
│   ├── queries.sql                    # Consultas útiles
│   ├── deploy-railway.sh              # Script de despliegue
│   ├── setup.sh                       # Script de configuración
│   ├── RAILWAY.md                     # Documentación de Railway
│   └── README.md                      # Documentación de la BD
│
├── .gitignore                          # Ignorar archivos del proyecto
├── README.md                           # Este archivo
├── eslint.config.js                    # ESLint global
├── package.json                        # Dependencias raíz
├── postcss.config.js                   # PostCSS global
└── vite.config.js                      # Vite global
```

---

## 🔧 Instalación Local

### Prerrequisitos

Antes de comenzar, asegúrate de tener instalado:

- **Node.js** (v18 o superior) - [Descargar](https://nodejs.org/)
- **npm** (v9 o superior) - Incluido con Node.js
- **Python** (v3.11 o superior) - [Descargar](https://www.python.org/)
- **pip** (Incluido con Python)
- **MySQL** (v8.0 o superior) - [Descargar](https://www.mysql.com/downloads/)
- **Git** - [Descargar](https://git-scm.com/)

### 1️⃣ Clonar el Repositorio

```bash
git clone https://github.com/JoelML1/Todo-List-React.git
cd Todo-List-React
```

### 2️⃣ Configurar la Base de Datos

#### Opción A: MySQL Local

```bash
# Conectar a MySQL
mysql -u root -p

# Crear base de datos
CREATE DATABASE todo_list_db;

# Salir de MySQL
EXIT;

# Importar esquema
mysql -u root -p todo_list_db < database/schema.sql

# (Opcional) Importar datos de ejemplo
mysql -u root -p todo_list_db < database/seed.sql
```

#### Opción B: Usar Railway (Recomendado)

1. Ve a [railway.app](https://railway.app)
2. Crea una nueva base de datos MySQL
3. Copia la `DATABASE_URL` desde las variables de entorno

### 3️⃣ Configurar el Backend

```bash
# Navegar al directorio del backend
cd backend

# Crear entorno virtual
python -m venv entornoV

# Activar entorno virtual
# En Windows:
entornoV\Scripts\activate
# En macOS/Linux:
source entornoV/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Crear archivo .env
echo "DATABASE_URL=mysql+pymysql://root:PASSWORD@localhost:3306/todo_list_db" > .env
# Reemplaza PASSWORD con tu contraseña de MySQL

# O si usas Railway:
echo "DATABASE_URL=mysql+pymysql://root:PASSWORD@HOST:PORT/railway" > .env

# Ejecutar servidor de desarrollo
uvicorn main:app --reload
```

El backend estará disponible en: **http://localhost:8000**

- Documentación Swagger: http://localhost:8000/docs
- Documentación ReDoc: http://localhost:8000/redoc

### 4️⃣ Configurar el Frontend

Abre una **nueva terminal** (mantén el backend corriendo):

```bash
# Navegar al directorio del frontend
cd frontend

# Instalar dependencias
npm install

# Crear archivo .env
echo "VITE_API_URL=http://localhost:8000" > .env

# Ejecutar servidor de desarrollo
npm run dev
```

El frontend estará disponible en: **http://localhost:5173**

### 5️⃣ Verificar la Instalación

1. Abre http://localhost:5173 en tu navegador
2. Deberías ver el mensaje "Base de datos MySQL conectada correctamente"
3. Intenta agregar, editar y eliminar tareas

---

## 📡 Documentación de API

### Base URL

- **Desarrollo**: `http://localhost:8000`
- **Producción**: `https://todo-list-react-production.up.railway.app`

### Autenticación

Actualmente la API no requiere autenticación. Todas las tareas están asociadas al `usuario_id=1` por defecto.

### Endpoints

#### 1. Health Check

Verifica el estado de la API y la conexión a la base de datos.

```http
GET /
```

**Respuesta Exitosa (200 OK)**:
```json
{
  "status": "ok",
  "message": "Todo List API está funcionando correctamente",
  "version": "1.0.0",
  "database": {
    "status": "connected",
    "message": "Base de datos MySQL conectada correctamente"
  }
}
```

---

#### 2. Obtener Todas las Tareas

Recupera todas las tareas de un usuario específico.

```http
GET /api/tareas?usuario_id=1&skip=0&limit=100&completada=null
```

**Query Parameters**:

| Parámetro | Tipo | Requerido | Por Defecto | Descripción |
|-----------|------|-----------|-------------|-------------|
| `usuario_id` | integer | No | 1 | ID del usuario |
| `skip` | integer | No | 0 | Número de tareas a saltar (paginación) |
| `limit` | integer | No | 100 | Número máximo de tareas a retornar |
| `completada` | boolean | No | null | Filtrar por estado (true/false/null) |

**Respuesta Exitosa (200 OK)**:
```json
[
  {
    "id": 1,
    "titulo": "Comprar leche",
    "descripcion": null,
    "completada": false,
    "prioridad": "media",
    "estado": "pendiente",
    "usuario_id": 1,
    "categoria_id": null,
    "fecha_creacion": "2025-12-05T10:30:00",
    "fecha_modificacion": "2025-12-05T10:30:00",
    "fecha_completada": null,
    "fecha_vencimiento": null,
    "posicion": 0
  },
  {
    "id": 2,
    "titulo": "Estudiar Python",
    "descripcion": "Repasar FastAPI y SQLAlchemy",
    "completada": true,
    "prioridad": "alta",
    "estado": "completada",
    "usuario_id": 1,
    "categoria_id": 2,
    "fecha_creacion": "2025-12-04T15:20:00",
    "fecha_modificacion": "2025-12-05T09:15:00",
    "fecha_completada": "2025-12-05T09:15:00",
    "fecha_vencimiento": "2025-12-06T00:00:00",
    "posicion": 1
  }
]
```

---

#### 3. Obtener Tarea por ID

Recupera una tarea específica por su ID.

```http
GET /api/tareas/{id}
```

**Path Parameters**:

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `id` | integer | ID de la tarea |

**Respuesta Exitosa (200 OK)**:
```json
{
  "id": 1,
  "titulo": "Comprar leche",
  "descripcion": null,
  "completada": false,
  "prioridad": "media",
  "estado": "pendiente",
  "usuario_id": 1,
  "categoria_id": null,
  "fecha_creacion": "2025-12-05T10:30:00",
  "fecha_modificacion": "2025-12-05T10:30:00",
  "fecha_completada": null,
  "fecha_vencimiento": null,
  "posicion": 0
}
```

**Error (404 Not Found)**:
```json
{
  "detail": "Tarea no encontrada"
}
```

---

#### 4. Crear Nueva Tarea

Crea una nueva tarea para un usuario.

```http
POST /api/tareas
Content-Type: application/json
```

**Request Body**:
```json
{
  "titulo": "Hacer ejercicio",
  "descripcion": "30 minutos de cardio",
  "prioridad": "media",
  "estado": "pendiente",
  "completada": false,
  "usuario_id": 1,
  "categoria_id": 3,
  "fecha_vencimiento": "2025-12-06T18:00:00"
}
```

**Campos**:

| Campo | Tipo | Requerido | Valores | Descripción |
|-------|------|-----------|---------|-------------|
| `titulo` | string | ✅ | 1-200 caracteres | Título de la tarea |
| `descripcion` | string | ❌ | null o texto | Descripción detallada |
| `prioridad` | string | ❌ | baja, media, alta, urgente | Nivel de prioridad |
| `estado` | string | ❌ | pendiente, en_progreso, completada, cancelada | Estado actual |
| `completada` | boolean | ❌ | true/false | Si está completada |
| `usuario_id` | integer | ❌ | Por defecto: 1 | ID del usuario |
| `categoria_id` | integer | ❌ | null o ID | ID de categoría |
| `fecha_vencimiento` | datetime | ❌ | null o ISO 8601 | Fecha límite |

**Respuesta Exitosa (200 OK)**:
```json
{
  "id": 5,
  "titulo": "Hacer ejercicio",
  "descripcion": "30 minutos de cardio",
  "completada": false,
  "prioridad": "media",
  "estado": "pendiente",
  "usuario_id": 1,
  "categoria_id": 3,
  "fecha_creacion": "2025-12-05T11:00:00",
  "fecha_modificacion": "2025-12-05T11:00:00",
  "fecha_completada": null,
  "fecha_vencimiento": "2025-12-06T18:00:00",
  "posicion": 4
}
```

**Error de Validación (422 Unprocessable Entity)**:
```json
{
  "detail": [
    {
      "loc": ["body", "titulo"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

---

#### 5. Actualizar Tarea

Actualiza una tarea existente parcial o totalmente.

```http
PUT /api/tareas/{id}
Content-Type: application/json
```

**Path Parameters**:

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `id` | integer | ID de la tarea a actualizar |

**Request Body** (todos los campos son opcionales):
```json
{
  "titulo": "Hacer ejercicio intenso",
  "completada": true,
  "prioridad": "alta"
}
```

**Respuesta Exitosa (200 OK)**:
```json
{
  "id": 5,
  "titulo": "Hacer ejercicio intenso",
  "descripcion": "30 minutos de cardio",
  "completada": true,
  "prioridad": "alta",
  "estado": "completada",
  "usuario_id": 1,
  "categoria_id": 3,
  "fecha_creacion": "2025-12-05T11:00:00",
  "fecha_modificacion": "2025-12-05T12:30:00",
  "fecha_completada": "2025-12-05T12:30:00",
  "fecha_vencimiento": "2025-12-06T18:00:00",
  "posicion": 4
}
```

---

#### 6. Eliminar Tarea

Elimina permanentemente una tarea.

```http
DELETE /api/tareas/{id}
```

**Path Parameters**:

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `id` | integer | ID de la tarea a eliminar |

**Respuesta Exitosa (200 OK)**:
```json
{
  "message": "Tarea eliminada exitosamente"
}
```

**Error (404 Not Found)**:
```json
{
  "detail": "Tarea no encontrada"
}
```

---

### Códigos de Estado HTTP

| Código | Descripción |
|--------|-------------|
| 200 | OK - Petición exitosa |
| 404 | Not Found - Recurso no encontrado |
| 422 | Unprocessable Entity - Error de validación |
| 500 | Internal Server Error - Error del servidor |

### Ejemplos de Uso

#### Con cURL

```bash
# Obtener todas las tareas
curl -X GET "http://localhost:8000/api/tareas?usuario_id=1"

# Crear tarea
curl -X POST "http://localhost:8000/api/tareas" \
  -H "Content-Type: application/json" \
  -d '{"titulo":"Nueva tarea","usuario_id":1}'

# Actualizar tarea
curl -X PUT "http://localhost:8000/api/tareas/1" \
  -H "Content-Type: application/json" \
  -d '{"completada":true}'

# Eliminar tarea
curl -X DELETE "http://localhost:8000/api/tareas/1"
```

#### Con JavaScript (Fetch API)

```javascript
// Obtener tareas
const getTareas = async () => {
  const response = await fetch('http://localhost:8000/api/tareas?usuario_id=1');
  const tareas = await response.json();
  console.log(tareas);
};

// Crear tarea
const crearTarea = async () => {
  const response = await fetch('http://localhost:8000/api/tareas', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      titulo: 'Nueva tarea',
      usuario_id: 1
    })
  });
  const tarea = await response.json();
  console.log(tarea);
};
```

---

## 🚢 Despliegue en Producción

### Backend en Railway

#### 1. Crear Cuenta y Proyecto

1. Ve a [railway.app](https://railway.app)
2. Crea una cuenta con GitHub
3. Click en **"New Project"**
4. Selecciona **"Deploy from GitHub repo"**
5. Conecta tu repositorio `JoelML1/Todo-List-React`

#### 2. Configurar el Servicio del Backend

```bash
# Railway detectará automáticamente:
- Lenguaje: Python
- Framework: FastAPI
- Procfile: backend/Procfile
```

**Configuración manual necesaria**:

1. **Root Directory**: 
   - Settings → General → Root Directory: `backend`

2. **Build Command**: 
   ```bash
   pip install -r requirements.txt
   ```

3. **Start Command** (en Procfile):
   ```bash
   python -m uvicorn main:app --host 0.0.0.0 --port $PORT
   ```

4. **Runtime** (en runtime.txt):
   ```
   python-3.11.7
   ```

#### 3. Variables de Entorno del Backend

Ve a **Variables** y agrega:

```bash
DATABASE_URL=mysql+pymysql://root:PASSWORD@HOST:PORT/railway
```

💡 **Tip**: Usa la variable de referencia de Railway:
```bash
DATABASE_URL=${{MySQL.DATABASE_URL}}
```
Luego modifica el prefijo de `mysql://` a `mysql+pymysql://`

#### 4. Generar Dominio Público

1. Ve a **Settings** → **Networking**
2. Click en **"Generate Domain"**
3. Copia la URL generada (ej: `https://todo-list-react-production.up.railway.app`)

#### 5. Verificar Despliegue

```bash
# Health check
curl https://tu-backend.railway.app/

# Documentación
# Abre en navegador:
https://tu-backend.railway.app/docs
```

---

### Base de Datos MySQL en Railway

#### 1. Crear Servicio MySQL

1. En tu proyecto de Railway, click **"+ New"**
2. Selecciona **"Database"** → **"MySQL"**
3. Railway creará automáticamente la base de datos

#### 2. Obtener Credenciales

Ve a la pestaña **"Variables"** y copia:

```bash
MYSQL_HOST=containers-us-west-xxx.railway.app
MYSQL_PORT=6543
MYSQL_USER=root
MYSQL_PASSWORD=tu_contraseña_generada
MYSQL_DATABASE=railway
MYSQL_URL=mysql://root:password@host:port/railway
```

#### 3. Importar Esquema de Base de Datos

**Opción A: Desde tu máquina local**

```bash
# Conectar a Railway MySQL
mysql -h containers-us-west-xxx.railway.app \
      -P 6543 \
      -u root \
      -p \
      railway

# Una vez conectado, importar esquema
source database/schema.sql;

# O desde la terminal
mysql -h HOST -P PORT -u root -p railway < database/schema.sql
```

**Opción B: Usar Railway CLI**

```bash
# Instalar Railway CLI
npm install -g @railway/cli

# Login
railway login

# Conectar al proyecto
railway link

# Ejecutar comando SQL
railway run mysql -u root -p railway < database/schema.sql
```

#### 4. Configurar Conexión desde Backend

Actualiza la variable `DATABASE_URL` en el servicio del backend:

```bash
# Formato correcto con PyMySQL
DATABASE_URL=mysql+pymysql://root:PASSWORD@mainline.proxy.rlwy.net:PORT/railway
```

**⚠️ Importante**: 
- Usa la **URL pública** (`mainline.proxy.rlwy.net`) no la interna
- Usa el prefijo `mysql+pymysql://` (no solo `mysql://`)

---

### Frontend en Vercel

#### 1. Importar Proyecto

1. Ve a [vercel.com](https://vercel.com)
2. Click en **"Add New..."** → **"Project"**
3. Importa desde GitHub: `JoelML1/Todo-List-React`

#### 2. Configurar el Proyecto

**Framework Preset**: Vite

**Build Settings**:
```bash
# Root Directory
frontend

# Build Command
npm run build

# Output Directory
dist

# Install Command
npm install
```

#### 3. Variables de Entorno

En **Environment Variables**, agrega:

```bash
# Variable de entorno
VITE_API_URL=https://todo-list-react-production.up.railway.app
```

**Para todos los entornos**: Production, Preview, Development

#### 4. Deploy

1. Click en **"Deploy"**
2. Espera 2-3 minutos
3. Vercel te dará una URL (ej: `https://todo-list-react.vercel.app`)

#### 5. Configurar Dominio Personalizado (Opcional)

1. Ve a **Settings** → **Domains**
2. Agrega tu dominio personalizado
3. Configura DNS según las instrucciones

---

### Comandos de Despliegue Automático

#### Backend (Railway)

Railway despliega automáticamente cuando haces push a la rama `default`:

```bash
cd backend

# Hacer cambios en el código...

# Commit y push
git add .
git commit -m "Actualizar backend"
git push origin default

# Railway detectará el push y desplegará automáticamente
```

#### Frontend (Vercel)

Vercel también despliega automáticamente:

```bash
cd frontend

# Hacer cambios...

# Commit y push
git add .
git commit -m "Actualizar frontend"
git push origin default

# Vercel desplegará automáticamente
```

---

## 🔐 Variables de Entorno

### Frontend (.env)

```bash
# URL del backend API
VITE_API_URL=http://localhost:8000

# Para producción en Vercel
# VITE_API_URL=https://tu-backend.railway.app
```

**Importante**: Las variables en Vite DEBEN empezar con `VITE_`

### Backend (.env)

```bash
# Conexión a base de datos
DATABASE_URL=mysql+pymysql://user:password@host:port/database

# Ejemplos:

# Local
# DATABASE_URL=mysql+pymysql://root:password@localhost:3306/todo_list_db

# Railway (desarrollo)
# DATABASE_URL=mysql+pymysql://root:pass@mainline.proxy.rlwy.net:41352/railway

# Railway (producción) - usar variable de referencia
# DATABASE_URL=${{MySQL.DATABASE_URL}}
```

### Archivo .env.example

Crea un `.env.example` en cada directorio para documentar las variables necesarias:

**frontend/.env.example**:
```bash
VITE_API_URL=http://localhost:8000
```

**backend/.env.example**:
```bash
DATABASE_URL=mysql+pymysql://user:password@host:port/database
```

---

## 📜 Scripts Disponibles

### Frontend

```bash
# Desarrollo
npm run dev          # Inicia servidor de desarrollo en http://localhost:5173

# Producción
npm run build        # Crea build optimizado en /dist
npm run preview      # Preview del build de producción

# Calidad de código
npm run lint         # Ejecuta ESLint
npm run format       # Formatea código con Prettier
```

### Backend

```bash
# Desarrollo
uvicorn main:app --reload                    # Con auto-reload
uvicorn main:app --reload --log-level debug  # Con logs debug

# Producción
uvicorn main:app --host 0.0.0.0 --port 8000  # Producción

# Alternativa con Gunicorn (más robusto)
gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app

# Tests (si existen)
pytest                                       # Ejecutar tests
pytest --cov                                 # Con cobertura

# Base de datos
alembic upgrade head                         # Aplicar migraciones
alembic revision --autogenerate -m "mensaje" # Crear migración
```

### Base de Datos

```bash
# MySQL local
mysql -u root -p                             # Conectar a MySQL
mysql -u root -p todo_list_db < schema.sql   # Importar esquema
mysqldump -u root -p todo_list_db > backup.sql # Backup

# Railway MySQL
mysql -h HOST -P PORT -u root -p railway     # Conectar a Railway
```

---

## 🐛 Solución de Problemas

### Problema: Error de CORS

**Síntoma**: Error en consola del navegador:
```
Access to fetch at 'http://localhost:8000/api/tareas' from origin 'http://localhost:5173' 
has been blocked by CORS policy
```

**Solución**:

1. Verifica que el backend tenga configurado CORS en `main.py`:

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, especifica dominios
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

2. Para producción, reemplaza `["*"]` con tu dominio:
```python
allow_origins=["https://tu-app.vercel.app"]
```

---

### Problema: Error de Conexión a Base de Datos

**Síntoma**: 
```
sqlalchemy.exc.OperationalError: (pymysql.err.OperationalError) 
(2003, "Can't connect to MySQL server")
```

**Soluciones**:

1. **Verifica la URL de conexión**:
```bash
# ❌ Incorrecto
DATABASE_URL=mysql://root:pass@host:port/db

# ✅ Correcto (nota el +pymysql)
DATABASE_URL=mysql+pymysql://root:pass@host:port/db
```

2. **Verifica credenciales**:
```bash
# Prueba la conexión
mysql -h HOST -P PORT -u root -p
```

3. **Railway: Usa URL pública, no interna**:
```bash
# ❌ No funcionará desde tu PC
mysql-cdqc.railway.internal

# ✅ Usar esta
mainline.proxy.rlwy.net
```

4. **Verifica que MySQL esté corriendo**:
```bash
# Windows
services.msc  # Buscar MySQL

# Linux/Mac
sudo systemctl status mysql
```

---

### Problema: Variables de Entorno no se Cargan

**Síntoma**: `import.meta.env.VITE_API_URL` es `undefined`

**Soluciones**:

1. **Verifica el nombre de la variable**:
   - DEBE empezar con `VITE_`
   - Ejemplo: `VITE_API_URL` ✅, `API_URL` ❌

2. **Reinicia el servidor de desarrollo**:
```bash
# Ctrl+C para detener
npm run dev  # Reiniciar
```

3. **Verifica que el archivo .env existe**:
```bash
# En la raíz de frontend/
ls -la .env  # Linux/Mac
dir .env     # Windows
```

4. **En Vercel, asegúrate de agregar la variable**:
   - Settings → Environment Variables
   - Agregar para todos los entornos

---

### Problema: Error 404 en Endpoints

**Síntoma**: `GET /tareas` retorna 404

**Solución**:

Usa la ruta correcta con `/api`:
```bash
# ❌ Incorrecto
GET /tareas

# ✅ Correcto
GET /api/tareas
```

Verifica en el código del frontend:
```javascript
// ❌ Incorrecto
fetch(`${API_URL}/tareas`)

// ✅ Correcto
fetch(`${API_URL}/api/tareas`)
```

---

### Problema: Estilos de Tailwind no Funcionan

**Síntoma**: Las clases de Tailwind no aplican estilos

**Soluciones**:

1. **Verifica que Tailwind esté importado en `index.css`**:
```css
@import "tailwindcss";
```

2. **Verifica `postcss.config.js`**:
```javascript
export default {
  plugins: {
    '@tailwindcss/postcss': {},
  },
}
```

3. **Reinstala dependencias**:
```bash
rm -rf node_modules package-lock.json
npm install
```

---

### Problema: Build Falla en Vercel

**Síntoma**: Error durante `npm run build`

**Soluciones**:

1. **Verifica que el Root Directory sea correcto**: `frontend`

2. **Prueba el build localmente**:
```bash
cd frontend
npm run build
```

3. **Revisa los logs en Vercel** para ver el error específico

4. **Verifica la versión de Node.js**:
```bash
# En Vercel Settings → General → Node.js Version
# Selecciona: 18.x o 20.x
```

---

### Problema: Railway no Despliega

**Síntoma**: El deploy falla o no inicia

**Soluciones**:

1. **Verifica los logs en Railway**:
   - Click en el deployment
   - Revisa la pestaña "Logs"

2. **Verifica el `Procfile`**:
```
web: python -m uvicorn main:app --host 0.0.0.0 --port $PORT
```

3. **Verifica `requirements.txt`**:
   - Asegúrate de que todas las dependencias estén listadas
   - Versiones compatibles

4. **Verifica `runtime.txt`**:
```
python-3.11.7
```

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Si quieres mejorar este proyecto:

### Proceso de Contribución

1. **Fork el proyecto**
```bash
# Click en "Fork" en GitHub
```

2. **Crea una rama para tu feature**
```bash
git checkout -b feature/AmazingFeature
```

3. **Haz tus cambios y commitea**
```bash
git add .
git commit -m 'Add: Amazing new feature'
```

4. **Push a tu fork**
```bash
git push origin feature/AmazingFeature
```

5. **Abre un Pull Request**

### Guía de Estilo

- **Commits**: Usa [Conventional Commits](https://www.conventionalcommits.org/)
  - `feat:` Nueva funcionalidad
  - `fix:` Corrección de bug
  - `docs:` Cambios en documentación
  - `style:` Formato, punto y coma faltante, etc
  - `refactor:` Refactorización de código
  - `test:` Agregar tests
  
- **Código**: 
  - JavaScript: ESLint + Prettier
  - Python: PEP 8

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver archivo `LICENSE` para más detalles.

```
MIT License

Copyright (c) 2025 Joel Medina

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## 📞 Contacto

**Joel Medina**

- GitHub: [@JoelML1](https://github.com/JoelML1)
- Email: tu-email@ejemplo.com
- LinkedIn: [Tu LinkedIn](https://linkedin.com/in/tu-perfil)

**Link del Proyecto**: [https://github.com/JoelML1/Todo-List-React](https://github.com/JoelML1/Todo-List-React)

---

## 🙏 Agradecimientos

- [FastAPI](https://fastapi.tiangolo.com/) - Por el increíble framework de Python
- [React](https://reactjs.org/) - Por la biblioteca UI más popular
- [Tailwind CSS](https://tailwindcss.com/) - Por hacer el CSS divertido de nuevo
- [Railway](https://railway.app/) - Por el hosting gratuito y fácil
- [Vercel](https://vercel.com/) - Por el mejor hosting de frontend
- [Heroicons](https://heroicons.com/) - Por los hermosos iconos
- Todos los contribuidores y la comunidad open source

---

<div align="center">

**⭐ Si este proyecto te fue útil, considera darle una estrella en GitHub! ⭐**

Hecho con ❤️ y ☕ por [Joel Medina](https://github.com/JoelML1)

</div>

