from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import List
from datetime import datetime, date
import models, schemas
from database import engine, get_db
import os
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# Crear las tablas (si no existen)
try:
    models.Base.metadata.create_all(bind=engine)
    print("✅ Conexión exitosa a la base de datos MySQL en Railway")
    print(f"📊 Base de datos: {os.getenv('DATABASE_URL', '').split('@')[1].split('/')[0] if '@' in os.getenv('DATABASE_URL', '') else 'No configurada'}")
except Exception as e:
    print(f"❌ Error al conectar con la base de datos: {e}")

# Crear la aplicación FastAPI
app = FastAPI(
    title="Todo List API",
    description="API para gestión de tareas con MySQL",
    version="1.0.0"
)

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, especifica los dominios permitidos
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================
# RUTAS - TAREAS
# ============================================

@app.get("/", tags=["Health"])
def read_root(db: Session = Depends(get_db)):
    """Health check endpoint"""
    try:
        # Verificar conexión a la base de datos
        db.execute(text("SELECT 1"))
        db_status = "connected"
        db_message = "Base de datos MySQL conectada correctamente"
    except Exception as e:
        db_status = "disconnected"
        db_message = f"Error de conexión: {str(e)}"
    
    return {
        "status": "ok",
        "message": "Todo List API está funcionando correctamente",
        "version": "1.0.0",
        "database": {
            "status": db_status,
            "message": db_message
        }
    }

@app.get("/api/tareas", response_model=List[schemas.TareaResponse], tags=["Tareas"])
def obtener_tareas(
    usuario_id: int = 1,  # Por defecto usuario 1 (demo)
    skip: int = 0,
    limit: int = 100,
    completada: bool = None,
    db: Session = Depends(get_db)
):
    """Obtener todas las tareas de un usuario"""
    query = db.query(models.Tarea).filter(models.Tarea.usuario_id == usuario_id)
    
    if completada is not None:
        query = query.filter(models.Tarea.completada == completada)
    
    tareas = query.order_by(models.Tarea.fecha_creacion.desc()).offset(skip).limit(limit).all()
    return tareas

@app.get("/api/tareas/{tarea_id}", response_model=schemas.TareaResponse, tags=["Tareas"])
def obtener_tarea(tarea_id: int, db: Session = Depends(get_db)):
    """Obtener una tarea específica"""
    tarea = db.query(models.Tarea).filter(models.Tarea.id == tarea_id).first()
    if not tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")
    return tarea

@app.post("/api/tareas", response_model=schemas.TareaResponse, status_code=status.HTTP_201_CREATED, tags=["Tareas"])
def crear_tarea(
    tarea: schemas.TareaCreate,
    usuario_id: int = 1,  # Por defecto usuario 1 (demo)
    db: Session = Depends(get_db)
):
    """Crear una nueva tarea"""
    db_tarea = models.Tarea(
        **tarea.dict(),
        usuario_id=usuario_id
    )
    db.add(db_tarea)
    db.commit()
    db.refresh(db_tarea)
    return db_tarea

@app.put("/api/tareas/{tarea_id}", response_model=schemas.TareaResponse, tags=["Tareas"])
def actualizar_tarea(
    tarea_id: int,
    tarea_update: schemas.TareaUpdate,
    db: Session = Depends(get_db)
):
    """Actualizar una tarea existente"""
    db_tarea = db.query(models.Tarea).filter(models.Tarea.id == tarea_id).first()
    
    if not db_tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")
    
    # Actualizar solo los campos proporcionados
    update_data = tarea_update.dict(exclude_unset=True)
    
    # Si se marca como completada, actualizar fecha_completada
    if "completada" in update_data:
        if update_data["completada"]:
            update_data["fecha_completada"] = datetime.now()
            update_data["estado"] = "completada"
        else:
            update_data["fecha_completada"] = None
    
    for key, value in update_data.items():
        setattr(db_tarea, key, value)
    
    db.commit()
    db.refresh(db_tarea)
    return db_tarea

@app.delete("/api/tareas/{tarea_id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Tareas"])
def eliminar_tarea(tarea_id: int, db: Session = Depends(get_db)):
    """Eliminar una tarea"""
    db_tarea = db.query(models.Tarea).filter(models.Tarea.id == tarea_id).first()
    
    if not db_tarea:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")
    
    db.delete(db_tarea)
    db.commit()
    return None

# ============================================
# RUTAS - CATEGORÍAS
# ============================================

@app.get("/api/categorias", response_model=List[schemas.CategoriaResponse], tags=["Categorías"])
def obtener_categorias(
    usuario_id: int = 1,
    db: Session = Depends(get_db)
):
    """Obtener todas las categorías de un usuario"""
    categorias = db.query(models.Categoria).filter(
        models.Categoria.usuario_id == usuario_id
    ).all()
    return categorias

@app.post("/api/categorias", response_model=schemas.CategoriaResponse, status_code=status.HTTP_201_CREATED, tags=["Categorías"])
def crear_categoria(
    categoria: schemas.CategoriaCreate,
    usuario_id: int = 1,
    db: Session = Depends(get_db)
):
    """Crear una nueva categoría"""
    db_categoria = models.Categoria(
        **categoria.dict(),
        usuario_id=usuario_id
    )
    db.add(db_categoria)
    db.commit()
    db.refresh(db_categoria)
    return db_categoria

@app.delete("/api/categorias/{categoria_id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Categorías"])
def eliminar_categoria(categoria_id: int, db: Session = Depends(get_db)):
    """Eliminar una categoría"""
    db_categoria = db.query(models.Categoria).filter(models.Categoria.id == categoria_id).first()
    
    if not db_categoria:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    
    db.delete(db_categoria)
    db.commit()
    return None

# ============================================
# RUTAS - SUBTAREAS
# ============================================

@app.get("/api/tareas/{tarea_id}/subtareas", response_model=List[schemas.SubtareaResponse], tags=["Subtareas"])
def obtener_subtareas(tarea_id: int, db: Session = Depends(get_db)):
    """Obtener todas las subtareas de una tarea"""
    subtareas = db.query(models.Subtarea).filter(
        models.Subtarea.tarea_id == tarea_id
    ).order_by(models.Subtarea.posicion).all()
    return subtareas

@app.post("/api/subtareas", response_model=schemas.SubtareaResponse, status_code=status.HTTP_201_CREATED, tags=["Subtareas"])
def crear_subtarea(
    subtarea: schemas.SubtareaCreate,
    db: Session = Depends(get_db)
):
    """Crear una nueva subtarea"""
    db_subtarea = models.Subtarea(**subtarea.dict())
    db.add(db_subtarea)
    db.commit()
    db.refresh(db_subtarea)
    return db_subtarea

@app.put("/api/subtareas/{subtarea_id}", response_model=schemas.SubtareaResponse, tags=["Subtareas"])
def actualizar_subtarea(
    subtarea_id: int,
    subtarea_update: schemas.SubtareaUpdate,
    db: Session = Depends(get_db)
):
    """Actualizar una subtarea"""
    db_subtarea = db.query(models.Subtarea).filter(models.Subtarea.id == subtarea_id).first()
    
    if not db_subtarea:
        raise HTTPException(status_code=404, detail="Subtarea no encontrada")
    
    update_data = subtarea_update.dict(exclude_unset=True)
    
    # Si se marca como completada, actualizar fecha_completada
    if "completada" in update_data and update_data["completada"]:
        update_data["fecha_completada"] = datetime.now()
    
    for key, value in update_data.items():
        setattr(db_subtarea, key, value)
    
    db.commit()
    db.refresh(db_subtarea)
    return db_subtarea

@app.delete("/api/subtareas/{subtarea_id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Subtareas"])
def eliminar_subtarea(subtarea_id: int, db: Session = Depends(get_db)):
    """Eliminar una subtarea"""
    db_subtarea = db.query(models.Subtarea).filter(models.Subtarea.id == subtarea_id).first()
    
    if not db_subtarea:
        raise HTTPException(status_code=404, detail="Subtarea no encontrada")
    
    db.delete(db_subtarea)
    db.commit()
    return None

# ============================================
# RUTAS - ESTADÍSTICAS
# ============================================

@app.get("/api/estadisticas", response_model=schemas.EstadisticasResponse, tags=["Estadísticas"])
def obtener_estadisticas(
    usuario_id: int = 1,
    db: Session = Depends(get_db)
):
    """Obtener estadísticas de tareas del usuario"""
    tareas = db.query(models.Tarea).filter(models.Tarea.usuario_id == usuario_id).all()
    
    hoy = date.today()
    
    estadisticas = {
        "total_tareas": len(tareas),
        "completadas": sum(1 for t in tareas if t.completada),
        "pendientes": sum(1 for t in tareas if t.estado == "pendiente"),
        "en_progreso": sum(1 for t in tareas if t.estado == "en_progreso"),
        "urgentes": sum(1 for t in tareas if t.prioridad == "urgente"),
        "vencidas": sum(1 for t in tareas if t.fecha_vencimiento and t.fecha_vencimiento.date() < hoy and not t.completada),
        "para_hoy": sum(1 for t in tareas if t.fecha_vencimiento and t.fecha_vencimiento.date() == hoy and not t.completada)
    }
    
    return estadisticas

# ============================================
# INICIAR SERVIDOR
# ============================================

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 3000))
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=port,
        reload=True
    )
