#!/bin/bash

# Script para desplegar la base de datos en Railway usando las credenciales proporcionadas

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚂 Desplegando Base de Datos en Railway${NC}"
echo ""

# Credenciales de Railway (extraídas de la imagen)
RAILWAY_HOST="mysql-cdqc.railway.internal"
RAILWAY_PORT="3306"
RAILWAY_DB="railway"
RAILWAY_USER="root"
RAILWAY_PASSWORD="hqLczmykgJHqKHCUWyhOgiGrwtFtFzoI"

echo -e "${YELLOW}Credenciales de Railway detectadas:${NC}"
echo "Host: $RAILWAY_HOST"
echo "Puerto: $RAILWAY_PORT"
echo "Base de datos: $RAILWAY_DB"
echo "Usuario: $RAILWAY_USER"
echo ""

# Verificar si mysql client está instalado
if ! command -v mysql &> /dev/null; then
    echo -e "${YELLOW}MySQL client no está instalado. Instalando...${NC}"
    sudo apt update
    sudo apt install -y mysql-client
fi

echo -e "${BLUE}Probando conexión a Railway...${NC}"

# Probar conexión
if mysql -h "$RAILWAY_HOST" -P "$RAILWAY_PORT" -u "$RAILWAY_USER" -p"$RAILWAY_PASSWORD" "$RAILWAY_DB" -e "SELECT 1;" &> /dev/null; then
    echo -e "${GREEN}✓ Conexión exitosa${NC}"
else
    echo -e "${RED}❌ Error de conexión${NC}"
    echo ""
    echo -e "${YELLOW}El host 'mysql-cdqc.railway.internal' es una dirección INTERNA de Railway.${NC}"
    echo -e "${YELLOW}Solo funciona desde servicios dentro de Railway, no desde conexiones externas.${NC}"
    echo ""
    echo -e "${BLUE}Soluciones:${NC}"
    echo "1. Usar el host público desde Railway (no .internal)"
    echo "2. Desplegar la base de datos desde un servicio dentro de Railway"
    echo "3. Usar Railway CLI desde este contenedor"
    echo ""
    echo -e "${YELLOW}Intentando con Railway CLI...${NC}"
fi

# Verificar si Railway CLI está instalado
if ! command -v railway &> /dev/null; then
    echo -e "${YELLOW}Railway CLI no está instalado. Instalando...${NC}"
    npm install -g @railway/cli
fi

echo ""
echo -e "${BLUE}Iniciando sesión en Railway...${NC}"
railway login

echo ""
echo -e "${BLUE}Vinculando proyecto...${NC}"
echo "Por favor, selecciona tu proyecto 'Todo List' cuando se te solicite"
railway link

echo ""
echo -e "${BLUE}Conectándose a MySQL...${NC}"
railway connect mysql

