# Backend - Despliegue en Railway

## 🚀 Pasos para Desplegar

### 1. Preparar el Proyecto

Asegúrate de tener estos archivos en la carpeta `backend/`:

- `main.py` - Aplicación FastAPI
- `requirements.txt` - Dependencias Python
- `Procfile` o Railway lo detectará automáticamente

### 2. Crear Procfile (Opcional)

```
web: uvicorn main:app --host 0.0.0.0 --port $PORT
```

### 3. Desplegar en Railway

#### Opción A: Desde el Dashboard de Railway

1. Ve a [railway.app](https://railway.app)
2. Click en "New Project"
3. Selecciona "Deploy from GitHub repo"
4. Selecciona tu repositorio `Todo-List-React`
5. Railway detectará automáticamente el backend Python
6. Configura el root directory si es necesario: `backend`

#### Opción B: Usando Railway CLI

```bash
# Instalar Railway CLI
npm install -g @railway/cli

# Login
railway login

# Desde la carpeta backend
cd backend

# Inicializar
railway init

# Desplegar
railway up
```

### 4. Configurar Variables de Entorno

En Railway Dashboard → Tu Proyecto → Variables:

```env
DATABASE_URL=mysql+pymysql://root:PASSWORD@HOST:PORT/railway
PORT=8000
PYTHONUNBUFFERED=1
```

### 5. Conectar Base de Datos

Si ya tienes MySQL en Railway:
1. Copia la URL de conexión de tu base de datos
2. Pégala en la variable `DATABASE_URL`

### 6. Verificar Despliegue

Una vez desplegado, Railway te dará una URL como:
```
https://todo-backend-production.up.railway.app
```

Prueba:
```
https://tu-backend.railway.app/
https://tu-backend.railway.app/docs
```

### 7. Actualizar Frontend

Actualiza `.env.production` en el frontend con tu URL de Railway:

```env
VITE_API_URL=https://tu-backend.railway.app/api
```

## 🔧 Solución de Problemas

### Error de Puerto
Railway asigna el puerto automáticamente. Actualiza `main.py`:

```python
import os

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 8000))
    uvicorn.run("main:app", host="0.0.0.0", port=port)
```

### Error de CORS
Agrega el dominio del frontend a CORS:

```python
allow_origins=[
    "http://localhost:5173",
    "https://tu-frontend.vercel.app",
]
```
