#!/bin/zsh

# ---------------------------------------------------------------------------
# Antigravity Ecosystem 2026 - Setup macOS (Apple Silicon + Docker)
# ---------------------------------------------------------------------------
# Inicializa de manera ultra rápida el workspace Agent-First.
# Valida arquitectura, instala dependencias vía Homebrew y configura 'uv'.

set -e

# Colores para la terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "${BLUE}🚀 Inicializando Setup del Ecosistema Antigravity 2026...${NC}"
echo "================================================================"

# 1. Validación de Sistema Operativo y Arquitectura
echo "\n${BLUE}[1/5] Validando Arquitectura del Sistema...${NC}"
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "${RED}❌ Error: Este script está optimizado para macOS (darwin). Detectado: $OSTYPE${NC}"
    echo "Si estás en Linux/WSL, por favor usa directamente apt-get o dnf."
    exit 1
fi

ARCH=$(uname -m)
if [[ "$ARCH" != "arm64" ]]; then
    echo "${RED}⚠️ Advertencia: Estás en un Mac con procesador Intel ($ARCH).${NC}"
    echo "El stack de Antigravity (Docker + VectorDBs) está altamente optimizado para procesadores Apple Silicon (M1/M2/M3)."
    echo "Podrías experimentar tiempos de build más lentos."
else
    echo "${GREEN}✅ Arquitectura Apple Silicon detectada ($ARCH). ¡Óptimo!${NC}"
fi

# 2. Verificación de Homebrew
echo "\n${BLUE}[2/5] Verificando Gestor de Paquetes (Homebrew)...${NC}"
if ! command -v brew &> /dev/null; then
    echo "${RED}❌ Homebrew no encontrado. Instalando...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "${GREEN}✅ Homebrew instalado.$(brew --version | head -n 1)${NC}"
fi

# 3. Instalación de Docker y Dependencias Base
echo "\n${BLUE}[3/5] Instalando Dependencias de Infraestructura...${NC}"
if ! command -v docker &> /dev/null; then
    echo "🐳 Instalando Docker (Docker Desktop)..."
    brew install --cask docker
    echo "${RED}⚠️ IMPORTANTE: Abre Docker Desktop desde la carpeta de Aplicaciones y acepta los términos antes de continuar.${NC}"
else
    echo "${GREEN}✅ Docker instalado.$(docker --version)${NC}"
fi

if ! command -v git &> /dev/null; then
    echo "📦 Instalando Git..."
    brew install git
else
    echo "${GREEN}✅ Git instalado.$(git --version)${NC}"
fi

if ! command -v make &> /dev/null; then
    echo "🔨 Instalando Make..."
    brew install make
else
    echo "${GREEN}✅ Make instalado.$(make --version | head -n 1)${NC}"
fi

# 4. Instalación de 'uv' (El Game-Changer de 2026)
echo "\n${BLUE}[4/5] Configurando el Gestor Ultra-Rápido de Entornos (uv)...${NC}"
if ! command -v uv &> /dev/null; then
    echo "💻 Instalando 'uv' de Astral..."
    brew install uv
else
    echo "${GREEN}✅ 'uv' ya está instalado.$(uv --version)${NC}"
fi

# Validar versión moderna de Python
if ! command -v python3 &> /dev/null; then
     echo "🐍 Instalando Python 3.11+..."
     brew install python@3.11
fi

# 5. Configurar Proyecto y Finalizar
echo "\n${BLUE}[5/5] Configurando Estructura Base del Workspace...${NC}"

# Ejecutar el target 'init' del Makefile si existe un uv.lock o requirements.txt, 
# sino solo crear la estructura
if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    make init
else
    echo "Creando estructura de directorios básica..."
    mkdir -p artifacts src/tools src/agents tests .antigravity/workflows
    echo "" > .env.example
    echo "OPENAI_API_KEY=" >> .env.example
    echo "GEMINI_API_KEY=" >> .env.example
    echo "CHROMA_DB_PATH=./data/chroma" >> .env.example
    echo "${GREEN}✅ Archivo .env.example creado.${NC}"
fi

echo "\n================================================================"
echo "${GREEN}🎉 ¡Instalación Completada Exitosamente! 🎉${NC}"
echo "================================================================"
echo ""
echo "🚀 Siguientes pasos recomendados:"
echo "1. Copia ${BLUE}.env.example${NC} a ${BLUE}.env${NC} y añade tus API Keys de LLM."
echo "2. Usa ${BLUE}make init${NC} para generar el entorno virtual uv."
echo "3. Ejecuta ${BLUE}make dev${NC} para iniciar el orquestador local."
echo "   ó ${BLUE}make docker-up${NC} si prefieres contenedorizar."
echo ""
echo "¡Bienvenido a la élite del desarrollo Agent-First!"
