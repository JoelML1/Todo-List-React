#!/bin/bash

echo "🚂 Guía Rápida - Desplegar BD en Railway"
echo ""
echo "PROBLEMA DETECTADO:"
echo "El host 'mysql-cdqc.railway.internal' es INTERNO de Railway."
echo "No puedes conectarte desde MySQL Workbench con ese host."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "SOLUCIÓN 1: Obtener el Host Público (Para MySQL Workbench)"
echo ""
echo "1. Ve a https://railway.app"
echo "2. Abre tu proyecto MySQL"
echo "3. Ve a Settings → Networking"
echo "4. Habilita 'Public Networking' si no está activo"
echo "5. Copia el hostname público (containers-us-west-XXX.railway.app)"
echo "6. Usa ese host en MySQL Workbench en lugar de .internal"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "SOLUCIÓN 2: Desplegar usando Railway CLI (Desde aquí)"
echo ""
echo "Ejecuta estos comandos paso a paso:"
echo ""
echo "# 1. Login a Railway"
echo "railway login"
echo ""
echo "# 2. Vincular tu proyecto"
echo "railway link"
echo ""
echo "# 3. Ver tus variables para verificar la conexión"
echo "railway variables"
echo ""
echo "# 4. Ejecutar el SQL en Railway"
echo "railway run bash -c 'mysql -h \$MYSQLHOST -P \$MYSQLPORT -u \$MYSQLUSER -p\$MYSQLPASSWORD \$MYSQLDATABASE < /workspaces/Todo-List-React/database/todo_list.sql'"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "SOLUCIÓN 3: Usar la interfaz web de Railway (MÁS FÁCIL)"
echo ""
echo "1. Ve a https://railway.app"
echo "2. Abre tu servicio MySQL"
echo "3. Click en la pestaña 'Data'"
echo "4. Click en 'Query' para abrir el editor SQL"
echo "5. Copia TODO el contenido de: database/todo_list.sql"
echo "6. Pégalo en el editor y ejecuta"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "¿Quieres intentar con Railway CLI ahora? (s/n): " RESPUESTA

if [[ "$RESPUESTA" == "s" || "$RESPUESTA" == "S" ]]; then
    echo ""
    echo "Iniciando proceso con Railway CLI..."
    echo ""
    
    # Login
    echo "Paso 1: Login a Railway"
    echo "Se abrirá tu navegador para autenticarte..."
    railway login
    
    echo ""
    echo "Paso 2: Vincular proyecto"
    railway link
    
    echo ""
    echo "Paso 3: Mostrar variables de entorno"
    railway variables
    
    echo ""
    read -p "¿Las variables se ven correctas? Continuar con la importación? (s/n): " CONTINUAR
    
    if [[ "$CONTINUAR" == "s" || "$CONTINUAR" == "S" ]]; then
        echo ""
        echo "Importando base de datos..."
        railway run bash -c 'mysql -h $MYSQLHOST -P $MYSQLPORT -u $MYSQLUSER -p$MYSQLPASSWORD $MYSQLDATABASE < /workspaces/Todo-List-React/database/todo_list.sql'
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "✅ Base de datos importada exitosamente!"
            echo ""
            echo "Verificando instalación..."
            railway run bash -c 'mysql -h $MYSQLHOST -P $MYSQLPORT -u $MYSQLUSER -p$MYSQLPASSWORD $MYSQLDATABASE -e "SHOW TABLES;"'
        else
            echo ""
            echo "❌ Error al importar. Intenta la Solución 3 (interfaz web)"
        fi
    fi
else
    echo ""
    echo "No hay problema. Usa la Solución 1 o 3 según prefieras."
    echo ""
    echo "Archivo de base de datos: database/todo_list.sql"
    echo ""
fi
