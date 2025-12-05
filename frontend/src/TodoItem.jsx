import { TrashIcon, PencilIcon, CheckIcon, XMarkIcon } from "@heroicons/react/24/solid";
import { useState } from "react";

export default function TodoItem({ tarea, toggleCompleted, eliminarTarea, editarTarea }) {
  const [editando, setEditando] = useState(false);
  const [nuevoTexto, setNuevoTexto] = useState(tarea.titulo || tarea.text);

  const guardarCambios = () => {
    if (nuevoTexto.trim()) {
      editarTarea(tarea.id, nuevoTexto);
      setEditando(false);
    }
  };

  const cancelarEdicion = () => {
    setNuevoTexto(tarea.titulo || tarea.text);
    setEditando(false);
  };

  return (
    <div className="group relative bg-gradient-to-r from-zinc-800/50 to-zinc-900/50 border-2 border-zinc-700/50 hover:border-red-600/50 rounded-2xl p-5 transition-all duration-300 hover:shadow-lg hover:shadow-red-900/20 backdrop-blur-sm">
      {/* Brillo hover */}
      <div className="absolute inset-0 bg-gradient-to-r from-red-600/0 via-red-600/5 to-red-600/0 opacity-0 group-hover:opacity-100 rounded-2xl transition-opacity duration-300 pointer-events-none"></div>
      
      <div className="relative flex items-center gap-4">
        {editando ? (
          <>
            {/* Modo edición */}
            <div className="flex-1 flex gap-2">
              <input
                type="text"
                value={nuevoTexto}
                onChange={(e) => setNuevoTexto(e.target.value)}
                className="flex-1 bg-black/50 border-2 border-red-600 rounded-xl px-4 py-2 text-white focus:outline-none focus:ring-2 focus:ring-red-600/50 font-medium"
                autoFocus
                onKeyPress={(e) => e.key === 'Enter' && guardarCambios()}
              />
              <button
                onClick={guardarCambios}
                className="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-xl transition-all duration-200 transform hover:scale-105 active:scale-95 shadow-lg"
                title="Guardar"
              >
                <CheckIcon className="w-5 h-5" />
              </button>
              <button
                onClick={cancelarEdicion}
                className="px-4 py-2 bg-zinc-700 hover:bg-zinc-600 text-white rounded-xl transition-all duration-200 transform hover:scale-105 active:scale-95 shadow-lg"
                title="Cancelar"
              >
                <XMarkIcon className="w-5 h-5" />
              </button>
            </div>
          </>
        ) : (
          <>
            {/* Checkbox personalizado */}
            <button
              onClick={() => toggleCompleted(tarea.id)}
              className="relative flex-shrink-0 w-6 h-6 group/check"
            >
              <div className={`w-6 h-6 rounded-lg border-2 transition-all duration-300 ${
                (tarea.completada || tarea.completed)
                  ? 'bg-red-600 border-red-600 shadow-lg shadow-red-600/50' 
                  : 'bg-black/50 border-zinc-600 group-hover/check:border-red-600'
              }`}>
                {(tarea.completada || tarea.completed) && (
                  <CheckIcon className="w-4 h-4 text-white m-auto mt-0.5" />
                )}
              </div>
            </button>

            {/* Texto de la tarea */}
            <span className={`flex-1 font-medium transition-all duration-300 ${
              (tarea.completada || tarea.completed)
                ? 'line-through text-zinc-500' 
                : 'text-white'
            }`}>
              {tarea.titulo || tarea.text}
            </span>

            {/* Botones de acción */}
            <div className="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity duration-200">
              <button 
                onClick={() => setEditando(true)}
                className="p-2 bg-blue-600/80 hover:bg-blue-600 text-white rounded-xl transition-all duration-200 transform hover:scale-110 active:scale-95 shadow-lg"
                title="Editar"
              >
                <PencilIcon className="w-4 h-4" />
              </button>
              <button 
                onClick={() => eliminarTarea(tarea.id)}
                className="p-2 bg-red-600/80 hover:bg-red-600 text-white rounded-xl transition-all duration-200 transform hover:scale-110 active:scale-95 shadow-lg"
                title="Eliminar"
              >
                <TrashIcon className="w-4 h-4" />
              </button>
            </div>
          </>
        )}
      </div>

      {/* Fecha de creación si está disponible */}
      {tarea.fecha_creacion && (
        <div className="mt-2 text-xs text-zinc-600">
          {new Date(tarea.fecha_creacion).toLocaleDateString('es-ES', {
            day: '2-digit',
            month: 'short',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
          })}
        </div>
      )}
    </div>
  );
}
