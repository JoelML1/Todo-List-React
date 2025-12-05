import TodoItem from "./TodoItem";
import { useState, useEffect } from "react";
import { PlusIcon } from "@heroicons/react/24/solid";

const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";

export default function App() {
  const [tareas, setTareas] = useState([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [dbStatus, setDbStatus] = useState(null);

  // Cargar tareas al iniciar
  useEffect(() => {
    cargarTareas();
    verificarConexion();
  }, []);

  const verificarConexion = async () => {
    try {
      const response = await fetch(`${API_URL}/`);
      const data = await response.json();
      setDbStatus(data.database);
    } catch (err) {
      setDbStatus({ status: "disconnected", message: "No se pudo conectar al backend" });
    }
  };

  const cargarTareas = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetch(`${API_URL}/api/tareas?usuario_id=1`);
      if (!response.ok) throw new Error("Error al cargar tareas");
      const data = await response.json();
      setTareas(data);
    } catch (err) {
      setError(err.message);
      console.error("Error:", err);
    } finally {
      setLoading(false);
    }
  };

  const agregarTarea = async () => {
    if (!input.trim()) return;
    
    try {
      const response = await fetch(`${API_URL}/api/tareas`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          titulo: input.trim(),
          usuario_id: 1
        })
      });
      
      if (!response.ok) throw new Error("Error al crear tarea");
      const nuevaTarea = await response.json();
      setTareas([nuevaTarea, ...tareas]);
      setInput("");
    } catch (err) {
      setError(err.message);
    }
  };

  const eliminarTarea = async (id) => {
    try {
      const response = await fetch(`${API_URL}/api/tareas/${id}`, {
        method: "DELETE"
      });
      
      if (!response.ok) throw new Error("Error al eliminar tarea");
      setTareas(tareas.filter((t) => t.id !== id));
    } catch (err) {
      setError(err.message);
    }
  };

  const toggleCompleted = async (id) => {
    const tarea = tareas.find(t => t.id === id);
    if (!tarea) return;

    try {
      const response = await fetch(`${API_URL}/api/tareas/${id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          titulo: tarea.titulo,
          completada: !tarea.completada
        })
      });
      
      if (!response.ok) throw new Error("Error al actualizar tarea");
      const tareaActualizada = await response.json();
      setTareas(tareas.map((t) => t.id === id ? tareaActualizada : t));
    } catch (err) {
      setError(err.message);
    }
  };

  const editarTarea = async (id, nuevoTitulo) => {
    const tarea = tareas.find(t => t.id === id);
    if (!tarea) return;

    try {
      const response = await fetch(`${API_URL}/api/tareas/${id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          titulo: nuevoTitulo,
          completada: tarea.completada
        })
      });
      
      if (!response.ok) throw new Error("Error al editar tarea");
      const tareaActualizada = await response.json();
      setTareas(tareas.map((t) => t.id === id ? tareaActualizada : t));
    } catch (err) {
      setError(err.message);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === "Enter") agregarTarea();
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-black via-zinc-900 to-black flex items-center justify-center p-4">
      {/* Efectos de fondo 3D */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 left-20 w-96 h-96 bg-red-600/10 rounded-full blur-3xl animate-pulse"></div>
        <div className="absolute bottom-20 right-20 w-96 h-96 bg-red-700/10 rounded-full blur-3xl animate-pulse delay-1000"></div>
      </div>

      <div className="relative w-full max-w-2xl">
        {/* Contenedor principal con efecto 3D */}
        <div className="bg-zinc-900 rounded-3xl shadow-2xl border border-red-900/30 backdrop-blur-xl overflow-hidden transform transition-all duration-300 hover:shadow-red-900/20 hover:shadow-2xl">
          
          {/* Header con gradiente */}
          <div className="bg-gradient-to-r from-red-600 via-red-700 to-black p-8 relative overflow-hidden">
            <div className="absolute inset-0 bg-black/20"></div>
            <div className="relative z-10">
              <h1 className="text-5xl font-black text-white text-center tracking-tight drop-shadow-2xl">
                LISTA DE TAREAS
              </h1>
              <p className="text-center text-red-100 mt-2 font-medium">Organiza tu vida con estilo</p>
            </div>
            {/* Decoración geométrica */}
            <div className="absolute -top-10 -right-10 w-40 h-40 border-4 border-red-400/20 rounded-full"></div>
            <div className="absolute -bottom-5 -left-5 w-32 h-32 border-4 border-red-400/20 rounded-full"></div>
          </div>

          <div className="p-8">
            {/* Estado de conexión */}
            {dbStatus && (
              <div className={`mb-6 p-4 rounded-xl border ${
                dbStatus.status === 'connected' 
                  ? 'bg-green-950/50 border-green-800/50 text-green-400' 
                  : 'bg-red-950/50 border-red-800/50 text-red-400'
              } backdrop-blur-sm flex items-center gap-3`}>
                <div className={`w-3 h-3 rounded-full ${
                  dbStatus.status === 'connected' ? 'bg-green-500' : 'bg-red-500'
                } animate-pulse`}></div>
                <span className="text-sm font-semibold">{dbStatus.message}</span>
              </div>
            )}

            {/* Input para nueva tarea */}
            <div className="mb-8 flex gap-3">
              <div className="flex-1 relative group">
                <input
                  className="w-full px-6 py-4 bg-black/50 border-2 border-zinc-700 rounded-2xl text-white placeholder-zinc-500 focus:outline-none focus:border-red-600 focus:ring-4 focus:ring-red-600/20 transition-all duration-300 font-medium shadow-inner"
                  type="text"
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  onKeyPress={handleKeyPress}
                  placeholder="✨ Escribe una nueva tarea..."
                  disabled={loading}
                />
                <div className="absolute inset-0 rounded-2xl bg-gradient-to-r from-red-600/0 via-red-600/5 to-red-600/0 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none"></div>
              </div>
              <button
                className="px-8 py-4 bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 text-white font-bold rounded-2xl shadow-lg shadow-red-600/30 hover:shadow-red-600/50 transform hover:scale-105 active:scale-95 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2 group"
                onClick={agregarTarea}
                disabled={loading || !input.trim()}
              >
                <PlusIcon className="w-6 h-6 group-hover:rotate-90 transition-transform duration-300" />
                <span>Agregar</span>
              </button>
            </div>

            {/* Mensajes de error */}
            {error && (
              <div className="mb-6 p-4 bg-red-950/50 border-2 border-red-800/50 rounded-xl text-red-400 backdrop-blur-sm animate-shake">
                <p className="font-semibold">⚠️ {error}</p>
              </div>
            )}

            {/* Loading */}
            {loading && (
              <div className="text-center py-8">
                <div className="inline-block w-12 h-12 border-4 border-red-600 border-t-transparent rounded-full animate-spin"></div>
                <p className="text-zinc-400 mt-4 font-medium">Cargando tareas...</p>
              </div>
            )}

            {/* Lista de tareas */}
            <div className="space-y-3">
              {tareas.length === 0 && !loading ? (
                <div className="text-center py-16">
                  <div className="w-24 h-24 mx-auto mb-6 bg-gradient-to-br from-zinc-800 to-zinc-900 rounded-3xl flex items-center justify-center border border-zinc-700 shadow-xl">
                    <span className="text-5xl">📝</span>
                  </div>
                  <p className="text-zinc-500 text-lg font-medium">No hay tareas aún</p>
                  <p className="text-zinc-600 text-sm mt-2">¡Comienza agregando tu primera tarea!</p>
                </div>
              ) : (
                tareas.map((tarea) => (
                  <TodoItem
                    key={tarea.id}
                    tarea={tarea}
                    toggleCompleted={toggleCompleted}
                    eliminarTarea={eliminarTarea}
                    editarTarea={editarTarea}
                  />
                ))
              )}
            </div>

            {/* Estadísticas */}
            {tareas.length > 0 && (
              <div className="mt-8 pt-6 border-t border-zinc-800 flex justify-between text-sm">
                <div className="text-zinc-400">
                  <span className="font-bold text-white">{tareas.length}</span> tareas totales
                </div>
                <div className="text-zinc-400">
                  <span className="font-bold text-red-500">{tareas.filter(t => t.completada).length}</span> completadas
                </div>
                <div className="text-zinc-400">
                  <span className="font-bold text-red-500">{tareas.filter(t => !t.completada).length}</span> pendientes
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Footer */}
        <div className="text-center mt-6 text-zinc-600 text-sm">
          <p>Powered by <span className="text-red-600 font-bold">React</span> + <span className="text-red-600 font-bold">FastAPI</span></p>
        </div>
      </div>
    </div>
  );
}
