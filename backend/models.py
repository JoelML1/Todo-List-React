from sqlalchemy import Column, Integer, String, Boolean, Text, DateTime, Enum, ForeignKey, TIMESTAMP, BigInteger
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database import Base
import enum

# Enums
class EstadoUsuario(str, enum.Enum):
    activo = "activo"
    inactivo = "inactivo"
    suspendido = "suspendido"

class PrioridadTarea(str, enum.Enum):
    baja = "baja"
    media = "media"
    alta = "alta"
    urgente = "urgente"

class EstadoTarea(str, enum.Enum):
    pendiente = "pendiente"
    en_progreso = "en_progreso"
    completada = "completada"
    cancelada = "cancelada"

# Modelos
class Usuario(Base):
    __tablename__ = "usuarios"
    
    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    email = Column(String(150), unique=True, nullable=False, index=True)
    password = Column(String(255), nullable=False)
    fecha_registro = Column(TIMESTAMP, server_default=func.now())
    ultima_sesion = Column(TIMESTAMP, nullable=True)
    estado = Column(Enum(EstadoUsuario), default=EstadoUsuario.activo, index=True)
    
    # Relaciones
    tareas = relationship("Tarea", back_populates="usuario", cascade="all, delete-orphan")
    categorias = relationship("Categoria", back_populates="usuario", cascade="all, delete-orphan")
    etiquetas = relationship("Etiqueta", back_populates="usuario", cascade="all, delete-orphan")

class Categoria(Base):
    __tablename__ = "categorias"
    
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id", ondelete="CASCADE"), nullable=False, index=True)
    nombre = Column(String(50), nullable=False)
    color = Column(String(7), default="#3B82F6")
    icono = Column(String(50), default="folder")
    descripcion = Column(Text, nullable=True)
    fecha_creacion = Column(TIMESTAMP, server_default=func.now())
    
    # Relaciones
    usuario = relationship("Usuario", back_populates="categorias")
    tareas = relationship("Tarea", back_populates="categoria")

class Tarea(Base):
    __tablename__ = "tareas"
    
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id", ondelete="CASCADE"), nullable=False, index=True)
    categoria_id = Column(Integer, ForeignKey("categorias.id", ondelete="SET NULL"), nullable=True, index=True)
    titulo = Column(String(200), nullable=False)
    descripcion = Column(Text, nullable=True)
    prioridad = Column(Enum(PrioridadTarea), default=PrioridadTarea.media, index=True)
    estado = Column(Enum(EstadoTarea), default=EstadoTarea.pendiente, index=True)
    completada = Column(Boolean, default=False, index=True)
    fecha_creacion = Column(TIMESTAMP, server_default=func.now())
    fecha_modificacion = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())
    fecha_vencimiento = Column(DateTime, nullable=True, index=True)
    fecha_completada = Column(DateTime, nullable=True)
    posicion = Column(Integer, default=0)
    
    # Relaciones
    usuario = relationship("Usuario", back_populates="tareas")
    categoria = relationship("Categoria", back_populates="tareas")
    subtareas = relationship("Subtarea", back_populates="tarea", cascade="all, delete-orphan")
    comentarios = relationship("Comentario", back_populates="tarea", cascade="all, delete-orphan")

class Etiqueta(Base):
    __tablename__ = "etiquetas"
    
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id", ondelete="CASCADE"), nullable=False, index=True)
    nombre = Column(String(50), nullable=False)
    color = Column(String(7), default="#10B981")
    fecha_creacion = Column(TIMESTAMP, server_default=func.now())
    
    # Relaciones
    usuario = relationship("Usuario", back_populates="etiquetas")

class Subtarea(Base):
    __tablename__ = "subtareas"
    
    id = Column(Integer, primary_key=True, index=True)
    tarea_id = Column(Integer, ForeignKey("tareas.id", ondelete="CASCADE"), nullable=False, index=True)
    titulo = Column(String(200), nullable=False)
    completada = Column(Boolean, default=False, index=True)
    posicion = Column(Integer, default=0)
    fecha_creacion = Column(TIMESTAMP, server_default=func.now())
    fecha_completada = Column(DateTime, nullable=True)
    
    # Relaciones
    tarea = relationship("Tarea", back_populates="subtareas")

class Comentario(Base):
    __tablename__ = "comentarios"
    
    id = Column(Integer, primary_key=True, index=True)
    tarea_id = Column(Integer, ForeignKey("tareas.id", ondelete="CASCADE"), nullable=False, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id", ondelete="CASCADE"), nullable=False, index=True)
    contenido = Column(Text, nullable=False)
    fecha_creacion = Column(TIMESTAMP, server_default=func.now())
    fecha_modificacion = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())
    
    # Relaciones
    tarea = relationship("Tarea", back_populates="comentarios")
