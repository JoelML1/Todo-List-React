# Frontend - Despliegue

## 🚀 Opciones de Despliegue

### 1. Vercel (Recomendado para React)

```bash
# Instalar Vercel CLI
npm install -g vercel

# Desde la carpeta frontend
cd frontend

# Login en Vercel
vercel login

# Desplegar
vercel --prod
```

### 2. Netlify

```bash
# Instalar Netlify CLI
npm install -g netlify-cli

# Desde la carpeta frontend
cd frontend

# Login en Netlify
netlify login

# Desplegar
netlify deploy --prod
```

### 3. Railway

```bash
# Desde la carpeta frontend
cd frontend

# Build
npm run build

# Subir a Railway usando el dashboard
# Conectar tu repo de GitHub
# Railway auto-detectará el proyecto Vite
```

## ⚙️ Configuración Importante

### Variables de Entorno

Antes de desplegar, actualiza `.env.production` con la URL de tu backend:

```env
VITE_API_URL=https://tu-backend-en-railway.railway.app/api
```

### Configuración de CORS en el Backend

Asegúrate de que en `backend/main.py` tengas configurado CORS para tu dominio del frontend:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "https://tu-frontend.vercel.app",  # Agregar tu dominio
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 📝 Pasos Recomendados

1. **Desplegar Backend en Railway**
   - Conectar repo de GitHub
   - Railway detectará el backend Python
   - Configurar variables de entorno (DATABASE_URL)
   
2. **Desplegar Frontend en Vercel**
   - Conectar repo de GitHub
   - Configurar root directory: `frontend`
   - Agregar variable de entorno: `VITE_API_URL`
   
3. **Actualizar CORS**
   - Agregar la URL de Vercel al CORS del backend
   
4. **Probar**
   - Verificar que el frontend se comunique con el backend
