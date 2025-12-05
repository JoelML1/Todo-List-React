const EditarTarea = ({ value, onChange, onSave }) => {
  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        onSave();
      }}
      className="flex gap-2 flex-1"
    >
      <input
        type="text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="border p-1 flex-1 rounded"
        autoFocus
      />
      <button
        type="submit"
        className="bg-green-500 text-white px-3 py-1 rounded"
      >
        Guardar
      </button>
    </form>
  );
};

export default EditarTarea;
