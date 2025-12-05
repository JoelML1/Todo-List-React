#!/bin/bash
#binenaspmdklda
#!/bin/bash
# Script para configurar la base de datos MySQL localmente

echo "🚀 Configurando Base de Datos MySQL para Todo List"
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar si MySQL está instalado
if ! command -v mysql &> /dev/null; then
    echo -e "${RED}❌ MySQL no está instalado${NC}"
    echo "Instalando MySQL..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install -y mysql-server
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install mysql
    else
        echo -e "${RED}Sistema operativo no soportado. Instala MySQL manualmente.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ MySQL está instalado${NC}"
echo ""

# Solicitar credenciales
echo -e "${YELLOW}Ingresa las credenciales de MySQL:${NC}"
read -p "Usuario root de MySQL (default: root): " MYSQL_ROOT_USER
MYSQL_ROOT_USER=${MYSQL_ROOT_USER:-root}

read -sp "Contraseña de root: " MYSQL_ROOT_PASSWORD
echo ""

# Probar conexión
echo ""
echo "Probando conexión a MySQL..."
if mysql -u "$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1;" &> /dev/null; then
    echo -e "${GREEN}✓ Conexión exitosa${NC}"
else
    echo -e "${RED}❌ Error de conexión. Verifica tus credenciales.${NC}"
    exit 1
fi

# Crear base de datos
echo ""
echo "Creando base de datos y tablas..."
mysql -u "$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" < database/schema.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Base de datos creada exitosamente${NC}"
else
    echo -e "${RED}❌ Error al crear la base de datos${NC}"
    exit 1
fi

# Preguntar si quiere cargar datos de ejemplo
echo ""
read -p "¿Deseas cargar datos de ejemplo? (s/n): " LOAD_SEED
if [[ "$LOAD_SEED" == "s" || "$LOAD_SEED" == "S" ]]; then
    echo "Cargando datos de ejemplo..."
    mysql -u "$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" < database/seed.sql
    echo -e "${GREEN}✓ Datos de ejemplo cargados${NC}"
fi

# Crear usuario de aplicación
echo ""
echo "Creando usuario de aplicación..."
read -p "Usuario para la aplicación (default: todolist_user): " APP_USER
APP_USER=${APP_USER:-todolist_user}

read -sp "Contraseña para el usuario de aplicación: " APP_PASSWORD
echo ""

mysql -u "$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" << EOF
CREATE USER IF NOT EXISTS '$APP_USER'@'localhost' IDENTIFIED BY '$APP_PASSWORD';
GRANT ALL PRIVILEGES ON todo_list_db.* TO '$APP_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

echo -e "${GREEN}✓ Usuario de aplicación creado${NC}"

# Crear archivo .env
echo ""
echo "Creando archivo .env..."
cat > database/.env << EOF
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=$APP_USER
MYSQL_PASSWORD=$APP_PASSWORD
MYSQL_DATABASE=todo_list_db

NODE_ENV=development
PORT=3000
JWT_SECRET=$(openssl rand -base64 32)
EOF

echo -e "${GREEN}✓ Archivo .env creado${NC}"

# Resumen
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Configuración completada exitosamente${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo ""
echo "Base de datos: todo_list_db"
echo "Usuario: $APP_USER"
echo "Archivo de configuración: database/.env"
echo ""
echo "Para conectarte a la base de datos:"
echo "  mysql -u $APP_USER -p todo_list_db"
echo ""
echo -e "${YELLOW}Siguiente paso: Desplegar en Railway${NC}"
echo "1. Visita https://railway.app"
echo "2. Crea un nuevo proyecto MySQL"
echo "3. Ejecuta database/schema.sql en Railway"
echo "4. Actualiza las variables de entorno en tu aplicación"
echo ""
