# 📝 Lista de Tareas - Full Stack App

Aplicación full stack moderna de gestión de tareas con diseño 3D impactante en negro y rojo, construida con React, FastAPI, MySQL y desplegada en Railway y Vercel.

![Tech Stack](https://img.shields.io/badge/React-19-61DAFB?style=for-the-badge&logo=react)
![FastAPI](https://img.shields.io/badge/FastAPI-0.109-009688?style=for-the-badge&logo=fastapi)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql)
![Tailwind](https://img.shields.io/badge/Tailwind-4.0-38B2AC?style=for-the-badge&logo=tailwind-css)

## 🌐 Demo en Vivo

- **Frontend**: Desplegado en Vercel
- **Backend API**: [https://todo-list-react-production.up.railway.app](https://todo-list-react-production.up.railway.app)
- **API Docs**: [https://todo-list-react-production.up.railway.app/docs](https://todo-list-react-production.up.railway.app/docs)

## 🎨 Características

- ✅ Diseño moderno 3D con gradientes en negro y rojo
- ✅ CRUD completo de tareas (Crear, Leer, Actualizar, Eliminar)
- ✅ Marcar tareas como completadas
- ✅ Edición inline de tareas
- ✅ Indicador de estado de conexión a base de datos en tiempo real
- ✅ Estadísticas de tareas (totales, completadas, pendientes)
- ✅ Animaciones y efectos visuales suaves
- ✅ Responsive design (móvil, tablet, desktop)

## 🏗️ Arquitectura

```
┌─────────────────┐      ┌──────────────────┐      ┌─────────────────┐
│  Vercel         │──────│  Railway         │──────│  Railway        │
│  (Frontend)     │      │  (Backend API)   │      │  (MySQL DB)     │
│  React + Vite   │      │  FastAPI         │      │                 │
└─────────────────┘      └──────────────────┘      └─────────────────┘
```

## 📁 Estructura del Proyecto

```
Todo-List-React/
├── frontend/                 # Aplicación React
│   ├── src/
│   │   ├── App.jsx          # Componente principal
│   │   ├── TodoItem.jsx     # Componente de item
│   │   └── index.css        # Estilos Tailwind
│   ├── package.json
│   ├── vite.config.js
│   └── vercel.json
│
├── backend/                  # API FastAPI
│   ├── main.py              # Punto de entrada
│   ├── models.py            # Modelos SQLAlchemy
│   ├── schemas.py           # Esquemas Pydantic
│   ├── database.py          # Configuración DB
│   ├── requirements.txt
│   └── Procfile
│
└── database/                 # Scripts SQL
    ├── schema.sql
    └── seed.sql
```

## 🚀 Despliegue

### Backend en Railway

1. **Crear servicio**:
   - Ve a [railway.app](https://railway.app)
   - New Project → Deploy from GitHub
   - Selecciona `JoelML1/Todo-List-React`

2. **Configurar**:
   - Root Directory: `backend`
   - Variable: `DATABASE_URL=mysql+pymysql://...`

3. **Generar dominio**: Settings → Networking → Generate Domain

### Frontend en Vercel

1. **Importar proyecto**:
   - Ve a [vercel.com](https://vercel.com)
   - New Project → Import from GitHub

2. **Configurar**:
   - Root Directory: `frontend`
   - Framework: `Vite`
   - Variable: `VITE_API_URL=https://tu-backend.railway.app`

3. **Deploy**: Click "Deploy"

## 💻 Desarrollo Local

### Backend
```bash
cd backend
python -m venv entornoV
source entornoV/bin/activate  # Windows: entornoV\Scripts\activate
pip install -r requirements.txt
echo "DATABASE_URL=mysql+pymysql://root:password@localhost:3306/todo_list_db" > .env
uvicorn main:app --reload
```

### Frontend
```bash
cd frontend
npm install
echo "VITE_API_URL=http://localhost:8000" > .env
npm run dev
```

## 📡 API Endpoints

- `GET /` - Health check
- `GET /api/tareas?usuario_id=1` - Obtener tareas
- `POST /api/tareas` - Crear tarea
- `PUT /api/tareas/{id}` - Actualizar tarea
- `DELETE /api/tareas/{id}` - Eliminar tarea

## 🛠️ Stack Tecnológico

**Frontend**: React 19, Vite 7, Tailwind CSS 4, Heroicons  
**Backend**: FastAPI 0.109, SQLAlchemy 2.0, PyMySQL, Uvicorn  
**Database**: MySQL 8.0  
**Hosting**: Vercel (Frontend), Railway (Backend + DB)

## 🔧 Variables de Entorno

**Frontend (.env)**:
```bash
VITE_API_URL=https://todo-list-react-production.up.railway.app
```

**Backend (.env)**:
```bash
DATABASE_URL=mysql+pymysql://user:password@host:port/database
```

## 🐛 Solución de Problemas

- **Error CORS**: Verifica configuración de `CORSMiddleware` en backend
- **Conexión DB**: Usa `mysql+pymysql://` y URL pública de Railway
- **Frontend no conecta**: Verifica `VITE_API_URL` en Vercel

## 👨‍💻 Autor

**Joel Medina**  
GitHub: [@JoelML1](https://github.com/JoelML1)

---

⭐ Si te gusta este proyecto, ¡dale una estrella!

