import { TrashIcon, PencilIcon } from "@heroicons/react/24/solid";
import { useState } from "react";

export default function TodoItem({ tarea, toggleCompleted, eliminarTarea, editarTarea }) {
  const [editando, setEditando] = useState(false);
  const [nuevoTexto, setNuevoTexto] = useState(tarea.text);

  const guardarCambios = () => {
    if (nuevoTexto.trim()) {
      editarTarea(tarea.id, nuevoTexto);
      setEditando(false);
    }
  };

  return (
    <div className="flex items-center gap-3 justify-between border-b border-gray-300 p-3 shadow-sm rounded">
      {editando ? (
        <form
          onSubmit={(e) => {
            e.preventDefault();
            guardarCambios();
          }}
          className="flex flex-1 gap-2"
        >
          <input
            type="text"
            value={nuevoTexto}
            onChange={(e) => setNuevoTexto(e.target.value)}
            className="flex-1 border rounded p-1"
            autoFocus
          />
          <button
            type="submit"
            className="bg-green-500 text-white px-3 py-1 rounded"
          >
            Guardar
          </button>
        </form>
      ) : (
        <>
          <span className={tarea.completed ? "line-through" : "text-gray-700"}>
            {tarea.text}
          </span>
          <div className="flex items-center gap-2">
            <input
              className="w-4 h-4"
              type="checkbox"
              checked={tarea.completed}
              onChange={() => toggleCompleted(tarea.id)}
            />
            <button onClick={() => setEditando(true)}>
              <PencilIcon className="w-5 h-5 text-blue-500" />
            </button>
            <button onClick={() => eliminarTarea(tarea.id)}>
              <TrashIcon className="w-5 h-5 text-red-500" />
            </button>
          </div>
        </>
      )}
    </div>
  );
}
