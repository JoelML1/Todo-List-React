#!/bin/bash

# Script para desplegar la base de datos en Railway

echo "🚂 Desplegando Base de Datos en Railway"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar si Railway CLI está instalado
if ! command -v railway &> /dev/null; then
    echo -e "${YELLOW}Railway CLI no está instalado${NC}"
    echo "Instalando Railway CLI..."
    npm install -g @railway/cli
fi

echo -e "${GREEN}✓ Railway CLI instalado${NC}"
echo ""

# Login a Railway
echo -e "${BLUE}Iniciando sesión en Railway...${NC}"
railway login

# Solicitar credenciales de Railway
echo ""
echo -e "${YELLOW}Ingresa las credenciales de tu base de datos MySQL en Railway:${NC}"
echo "(Puedes encontrarlas en Railway > Tu Proyecto MySQL > Variables)"
echo ""

read -p "MYSQL_HOST: " RAILWAY_HOST
read -p "MYSQL_PORT (default: 3306): " RAILWAY_PORT
RAILWAY_PORT=${RAILWAY_PORT:-3306}
read -p "MYSQL_DATABASE: " RAILWAY_DB
read -p "MYSQL_USER: " RAILWAY_USER
read -sp "MYSQL_PASSWORD: " RAILWAY_PASSWORD
echo ""

# Probar conexión
echo ""
echo -e "${BLUE}Probando conexión a Railway MySQL...${NC}"
if mysql -h "$RAILWAY_HOST" -P "$RAILWAY_PORT" -u "$RAILWAY_USER" -p"$RAILWAY_PASSWORD" "$RAILWAY_DB" -e "SELECT 1;" &> /dev/null; then
    echo -e "${GREEN}✓ Conexión exitosa${NC}"
else
    echo -e "${RED}❌ Error de conexión. Verifica tus credenciales.${NC}"
    exit 1
fi

# Crear schema
echo ""
echo -e "${BLUE}Creando tablas en Railway...${NC}"
mysql -h "$RAILWAY_HOST" -P "$RAILWAY_PORT" -u "$RAILWAY_USER" -p"$RAILWAY_PASSWORD" "$RAILWAY_DB" < database/schema.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Tablas creadas exitosamente${NC}"
else
    echo -e "${RED}❌ Error al crear tablas${NC}"
    exit 1
fi

# Preguntar si cargar datos de ejemplo
echo ""
read -p "¿Deseas cargar datos de ejemplo? (s/n): " LOAD_SEED
if [[ "$LOAD_SEED" == "s" || "$LOAD_SEED" == "S" ]]; then
    echo "Cargando datos de ejemplo..."
    mysql -h "$RAILWAY_HOST" -P "$RAILWAY_PORT" -u "$RAILWAY_USER" -p"$RAILWAY_PASSWORD" "$RAILWAY_DB" < database/seed.sql
    echo -e "${GREEN}✓ Datos de ejemplo cargados${NC}"
fi

# Verificar tablas
echo ""
echo -e "${BLUE}Verificando instalación...${NC}"
TABLES=$(mysql -h "$RAILWAY_HOST" -P "$RAILWAY_PORT" -u "$RAILWAY_USER" -p"$RAILWAY_PASSWORD" "$RAILWAY_DB" -e "SHOW TABLES;" -s)
echo "Tablas creadas:"
echo "$TABLES" | while read table; do
    echo "  ✓ $table"
done

# Crear archivo .env para producción
echo ""
echo -e "${BLUE}Creando archivo .env.production...${NC}"
cat > database/.env.production << EOF
# Railway Production Database
MYSQL_HOST=$RAILWAY_HOST
MYSQL_PORT=$RAILWAY_PORT
MYSQL_USER=$RAILWAY_USER
MYSQL_PASSWORD=$RAILWAY_PASSWORD
MYSQL_DATABASE=$RAILWAY_DB
DATABASE_URL=mysql://$RAILWAY_USER:$RAILWAY_PASSWORD@$RAILWAY_HOST:$RAILWAY_PORT/$RAILWAY_DB

NODE_ENV=production
EOF

echo -e "${GREEN}✓ Archivo .env.production creado${NC}"

# Resumen
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Despliegue en Railway completado${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo ""
echo "Base de datos: $RAILWAY_DB"
echo "Host: $RAILWAY_HOST"
echo "Puerto: $RAILWAY_PORT"
echo "Usuario: $RAILWAY_USER"
echo ""
echo -e "${YELLOW}Siguiente paso: Configurar tu aplicación${NC}"
echo "1. Copia las variables de database/.env.production"
echo "2. Agrégalas a las variables de entorno de tu app en Railway"
echo "3. Asegúrate de usar SSL en la conexión"
echo ""
echo "Ejemplo de conexión con SSL:"
echo "const pool = mysql.createPool({"
echo "  host: process.env.MYSQL_HOST,"
echo "  port: process.env.MYSQL_PORT,"
echo "  user: process.env.MYSQL_USER,"
echo "  password: process.env.MYSQL_PASSWORD,"
echo "  database: process.env.MYSQL_DATABASE,"
echo "  ssl: { rejectUnauthorized: false }"
echo "});"
echo ""
