from pydantic import BaseModel, EmailStr, Field
from datetime import datetime
from typing import Optional, List
from enum import Enum

# Enums
class PrioridadEnum(str, Enum):
    baja = "baja"
    media = "media"
    alta = "alta"
    urgente = "urgente"

class EstadoEnum(str, Enum):
    pendiente = "pendiente"
    en_progreso = "en_progreso"
    completada = "completada"
    cancelada = "cancelada"

# Schemas para Tarea
class TareaBase(BaseModel):
    titulo: str = Field(..., min_length=1, max_length=200)
    descripcion: Optional[str] = None
    prioridad: PrioridadEnum = PrioridadEnum.media
    estado: EstadoEnum = EstadoEnum.pendiente
    completada: bool = False
    categoria_id: Optional[int] = None
    fecha_vencimiento: Optional[datetime] = None

class TareaCreate(TareaBase):
    pass

class TareaUpdate(BaseModel):
    titulo: Optional[str] = Field(None, min_length=1, max_length=200)
    descripcion: Optional[str] = None
    prioridad: Optional[PrioridadEnum] = None
    estado: Optional[EstadoEnum] = None
    completada: Optional[bool] = None
    categoria_id: Optional[int] = None
    fecha_vencimiento: Optional[datetime] = None

class TareaResponse(TareaBase):
    id: int
    usuario_id: int
    fecha_creacion: datetime
    fecha_modificacion: datetime
    fecha_completada: Optional[datetime] = None
    posicion: int

    class Config:
        from_attributes = True

# Schemas para Subtarea
class SubtareaBase(BaseModel):
    titulo: str = Field(..., min_length=1, max_length=200)
    completada: bool = False
    posicion: int = 0

class SubtareaCreate(SubtareaBase):
    tarea_id: int

class SubtareaUpdate(BaseModel):
    titulo: Optional[str] = None
    completada: Optional[bool] = None
    posicion: Optional[int] = None

class SubtareaResponse(SubtareaBase):
    id: int
    tarea_id: int
    fecha_creacion: datetime
    fecha_completada: Optional[datetime] = None

    class Config:
        from_attributes = True

# Schemas para Categoría
class CategoriaBase(BaseModel):
    nombre: str = Field(..., min_length=1, max_length=50)
    color: str = "#3B82F6"
    icono: str = "folder"
    descripcion: Optional[str] = None

class CategoriaCreate(CategoriaBase):
    pass

class CategoriaUpdate(BaseModel):
    nombre: Optional[str] = None
    color: Optional[str] = None
    icono: Optional[str] = None
    descripcion: Optional[str] = None

class CategoriaResponse(CategoriaBase):
    id: int
    usuario_id: int
    fecha_creacion: datetime

    class Config:
        from_attributes = True

# Schemas para Usuario
class UsuarioBase(BaseModel):
    nombre: str = Field(..., min_length=1, max_length=100)
    email: EmailStr

class UsuarioCreate(UsuarioBase):
    password: str = Field(..., min_length=6)

class UsuarioResponse(UsuarioBase):
    id: int
    fecha_registro: datetime
    estado: str

    class Config:
        from_attributes = True

# Schema de respuesta genérica
class MessageResponse(BaseModel):
    message: str

# Schema de estadísticas
class EstadisticasResponse(BaseModel):
    total_tareas: int
    completadas: int
    pendientes: int
    en_progreso: int
    urgentes: int
    vencidas: int
    para_hoy: int
