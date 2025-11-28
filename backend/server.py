from flask import Flask, request, jsonify
from flask_cors import CORS
import json
import os
from datetime import datetime

app = Flask(__name__)
CORS(app)

DB_FILE = 'tareas.json'

# Inicializar archivo de tareas si no existe
def init_db():
    if not os.path.exists(DB_FILE):
        with open(DB_FILE, 'w') as f:
            json.dump([], f)

# Leer tareas del archivo
def leer_tareas():
    try:
        with open(DB_FILE, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f'Error leyendo tareas: {e}')
        return []

# Guardar tareas en el archivo
def guardar_tareas(tareas):
    try:
        with open(DB_FILE, 'w') as f:
            json.dump(tareas, f, indent=2)
    except Exception as e:
        print(f'Error guardando tareas: {e}')
        raise e

# Rutas

# GET - Obtener todas las tareas
@app.route('/api/tareas', methods=['GET'])
def obtener_tareas():
    try:
        tareas = leer_tareas()
        return jsonify(tareas), 200
    except Exception as e:
        return jsonify({'error': 'Error al obtener tareas'}), 500

# POST - Crear nueva tarea
@app.route('/api/tareas', methods=['POST'])
def crear_tarea():
    try:
        data = request.get_json()
        text = data.get('text', '').strip()
        
        if not text:
            return jsonify({'error': 'El texto de la tarea es requerido'}), 400
        
        tareas = leer_tareas()
        nueva_tarea = {
            'id': int(datetime.now().timestamp() * 1000),
            'text': text,
            'completed': False
        }
        
        tareas.append(nueva_tarea)
        guardar_tareas(tareas)
        
        return jsonify(nueva_tarea), 201
    except Exception as e:
        return jsonify({'error': 'Error al crear tarea'}), 500

# PUT - Actualizar tarea
@app.route('/api/tareas/<int:id>', methods=['PUT'])
def actualizar_tarea(id):
    try:
        data = request.get_json()
        tareas = leer_tareas()
        
        # Buscar la tarea
        tarea_index = None
        for i, tarea in enumerate(tareas):
            if tarea['id'] == id:
                tarea_index = i
                break
        
        if tarea_index is None:
            return jsonify({'error': 'Tarea no encontrada'}), 404
        
        # Actualizar campos
        if 'text' in data:
            tareas[tarea_index]['text'] = data['text'].strip()
        if 'completed' in data:
            tareas[tarea_index]['completed'] = data['completed']
        
        guardar_tareas(tareas)
        return jsonify(tareas[tarea_index]), 200
    except Exception as e:
        return jsonify({'error': 'Error al actualizar tarea'}), 500

# DELETE - Eliminar tarea
@app.route('/api/tareas/<int:id>', methods=['DELETE'])
def eliminar_tarea(id):
    try:
        tareas = leer_tareas()
        tareas_filtradas = [t for t in tareas if t['id'] != id]
        
        if len(tareas) == len(tareas_filtradas):
            return jsonify({'error': 'Tarea no encontrada'}), 404
        
        guardar_tareas(tareas_filtradas)
        return '', 204
    except Exception as e:
        return jsonify({'error': 'Error al eliminar tarea'}), 500

if __name__ == '__main__':
    init_db()
    print('Servidor corriendo en http://localhost:3000')
    app.run(host='0.0.0.0', port=3000, debug=True)
