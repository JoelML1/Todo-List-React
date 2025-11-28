# Guía de Despliegue en Railway

## 🚂 Paso a Paso para Desplegar MySQL en Railway

### 1️⃣ Crear Cuenta en Railway

1. Ve a [https://railway.app](https://railway.app)
2. Click en "Start a New Project"
3. Inicia sesión con GitHub

### 2️⃣ Crear Base de Datos MySQL

1. Click en "New Project"
2. Selecciona "Provision MySQL"
3. Railway creará automáticamente un servicio MySQL

### 3️⃣ Obtener Credenciales de Conexión

1. Click en el servicio MySQL que acabas de crear
2. Ve a la pestaña "Variables"
3. Verás las siguientes variables:
   - `MYSQL_URL` (URL completa de conexión)
   - `MYSQL_HOST`
   - `MYSQL_PORT`
   - `MYSQL_USER`
   - `MYSQL_PASSWORD`
   - `MYSQL_DATABASE`

4. Copia estas variables, las necesitarás para conectarte

### 4️⃣ Crear las Tablas

**Opción A: Usando Railway CLI**

```bash
# Instalar Railway CLI
npm install -g @railway/cli

# Iniciar sesión
railway login

# Enlazar tu proyecto
railway link

# Conectarse a MySQL
railway run mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE

# Una vez conectado, ejecutar:
source /ruta/completa/a/database/schema.sql
source /ruta/completa/a/database/seed.sql  # Opcional: datos de ejemplo
```

**Opción B: Usando un cliente MySQL local**

```bash
# Conectarse usando las credenciales de Railway
mysql -h containers-us-west-xxx.railway.app \
      -P 6969 \
      -u root \
      -p \
      railway

# Una vez conectado, copiar y pegar el contenido de schema.sql
```

**Opción C: Usando un script**

```bash
# Crear archivo deploy-railway.sh
chmod +x database/deploy-railway.sh

# Ejecutar (te pedirá las credenciales de Railway)
./database/deploy-railway.sh
```

### 5️⃣ Verificar la Instalación

```sql
-- Conectarse a Railway MySQL
mysql -h YOUR_RAILWAY_HOST -P YOUR_RAILWAY_PORT -u root -p YOUR_DATABASE

-- Verificar tablas
SHOW TABLES;

-- Debería mostrar:
-- +-------------------------+
-- | Tables_in_railway       |
-- +-------------------------+
-- | categories              |
-- | subtasks                |
-- | tags                    |
-- | todo_tags               |
-- | todos                   |
-- | users                   |
-- +-------------------------+

-- Contar registros (si cargaste seed.sql)
SELECT 
    (SELECT COUNT(*) FROM users) as users,
    (SELECT COUNT(*) FROM todos) as todos,
    (SELECT COUNT(*) FROM categories) as categories,
    (SELECT COUNT(*) FROM tags) as tags;
```

### 6️⃣ Configurar Variables de Entorno en tu App

Copia las variables de Railway a tu aplicación:

**Para Node.js/Express:**
```env
# .env
DATABASE_URL=mysql://root:password@containers-us-west-xxx.railway.app:6969/railway
MYSQL_HOST=containers-us-west-xxx.railway.app
MYSQL_PORT=6969
MYSQL_DATABASE=railway
MYSQL_USER=root
MYSQL_PASSWORD=xxxxxxxxxxxx
```

**Para desplegar tu backend en Railway:**

1. En Railway, click en "New"
2. Selecciona "GitHub Repo"
3. Conecta tu repositorio
4. Railway detectará automáticamente tu app Node.js
5. Agrega las variables de entorno en la pestaña "Variables"
6. Railway desplegará automáticamente tu aplicación

### 7️⃣ Conectar desde tu Aplicación

**Node.js con mysql2:**

```javascript
import mysql from 'mysql2/promise';

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  port: process.env.MYSQL_PORT,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
  ssl: {
    rejectUnauthorized: false // Railway requiere SSL
  }
});

// Probar conexión
pool.getConnection()
  .then(connection => {
    console.log('✓ Conectado a Railway MySQL');
    connection.release();
  })
  .catch(err => {
    console.error('Error de conexión:', err);
  });
```

## 🔒 Seguridad

### Importantes recomendaciones:

1. **Nunca subas el archivo .env a Git**
   ```bash
   echo ".env" >> .gitignore
   ```

2. **Usa variables de entorno en Railway**
   - No hardcodees las credenciales en el código
   - Usa las variables de entorno del servicio

3. **Habilita conexiones SSL**
   - Railway requiere SSL para conexiones externas
   - Configura `ssl: { rejectUnauthorized: false }` en producción

4. **Restringe acceso a la base de datos**
   - Solo permite conexiones desde tu aplicación backend
   - No expongas la base de datos directamente al frontend

## 💰 Costos

Railway ofrece:
- **$5 de crédito gratis al mes** (sin tarjeta de crédito)
- **MySQL**: ~$5/mes por 1GB
- **Plan Developer**: $20/mes con $10 de crédito incluido

## 🆘 Solución de Problemas

### Error: "Access denied"
- Verifica que las credenciales sean correctas
- Asegúrate de usar el host y puerto correctos de Railway

### Error: "Connection timeout"
- Railway puede tardar unos segundos en iniciar
- Verifica que el servicio MySQL esté activo en Railway

### Error: "Table doesn't exist"
- Asegúrate de haber ejecutado schema.sql
- Verifica que estás conectado a la base de datos correcta

### Error: "SSL required"
- Agrega la configuración SSL en tu conexión
- Railway requiere SSL para conexiones externas

## 📞 Recursos

- [Railway Docs](https://docs.railway.app/)
- [Railway MySQL Template](https://railway.app/template/mysql)
- [Railway CLI](https://docs.railway.app/develop/cli)
- [MySQL Docs](https://dev.mysql.com/doc/)

## ✅ Checklist de Despliegue

- [ ] Cuenta creada en Railway
- [ ] Servicio MySQL provisionado
- [ ] Credenciales copiadas
- [ ] Schema.sql ejecutado
- [ ] Tablas verificadas
- [ ] Variables de entorno configuradas
- [ ] Conexión desde la app probada
- [ ] SSL habilitado
- [ ] .env agregado a .gitignore
- [ ] Aplicación desplegada y conectada

¡Listo! Tu base de datos MySQL está desplegada en Railway y lista para producción. 🎉
