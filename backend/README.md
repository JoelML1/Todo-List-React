# Backend Todo List API - Python/FastAPI

API REST moderna para la gestión de tareas usando Python y FastAPI.

## 🚀 Características

- ⚡ FastAPI - Framework moderno y rápido
- 📝 Documentación automática (Swagger UI)
- ✅ Validación de datos con Pydantic
- 🔄 CORS configurado
- 💾 Persistencia en JSON

## 📦 Instalación

### 1. Crear entorno virtual (recomendado)
```bash
cd backend-python
python3 -m venv venv
source venv/bin/activate  # En Linux/Mac
# o en Windows: venv\Scripts\activate
```

### 2. Instalar dependencias
```bash
pip install -r requirements.txt
```

## 🏃 Ejecución

### Iniciar el servidor
```bash
python server.py
```

O con uvicorn directamente:
```bash
uvicorn server:app --host 0.0.0.0 --port 3000 --reload
```

El servidor se ejecutará en `http://localhost:3000`

## 📚 Documentación Interactiva

FastAPI genera documentación automática:

- **Swagger UI**: http://localhost:3000/docs
- **ReDoc**: http://localhost:3000/redoc

## 🔌 Endpoints

### GET /api/tareas
Obtiene todas las tareas.

**Respuesta:**
```json
[
  {
    "id": 1234567890,
    "text": "Tarea ejemplo",
    "completed": false
  }
]
```

### POST /api/tareas
Crea una nueva tarea.

**Body:**
```json
{
  "text": "Nueva tarea"
}
```

**Respuesta:** `201 Created`
```json
{
  "id": 1234567890,
  "text": "Nueva tarea",
  "completed": false
}
```

### PUT /api/tareas/{id}
Actualiza una tarea existente.

**Body:**
```json
{
  "text": "Tarea actualizada",
  "completed": true
}
```

**Respuesta:**
```json
{
  "id": 1234567890,
  "text": "Tarea actualizada",
  "completed": true
}
```

### DELETE /api/tareas/{id}
Elimina una tarea.

**Respuesta:** `204 No Content`

## 🛠️ Tecnologías

- **Python 3.x**
- **FastAPI 0.104.1** - Framework web moderno
- **Uvicorn 0.24.0** - Servidor ASGI
- **Pydantic 2.5.0** - Validación de datos

## 📁 Estructura del Proyecto

```
backend-python/
├── server.py           # Servidor FastAPI
├── requirements.txt    # Dependencias
├── tareas.json        # Base de datos (se crea automáticamente)
├── .gitignore
└── README.md
```

## 🎯 Ventajas de FastAPI

- ✅ Alto rendimiento (comparable a NodeJS y Go)
- ✅ Documentación automática
- ✅ Validación automática de datos
- ✅ Type hints nativos de Python
- ✅ Async/await support
- ✅ Menos código, menos bugs
