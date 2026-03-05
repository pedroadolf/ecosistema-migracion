# ---------------------------------------------------------------------------
# Antigravity Ecosystem 2026 - Makefile Orchestrator
# ---------------------------------------------------------------------------
# Optimizado para Apple Silicon (M1/M2/M3) y Docker.
# Utiliza 'uv' para operaciones ultra rápidas de Python en local.

.PHONY: help init dev test docker-up docker-build clean lint

# Colores para la terminal
CYAN := \033[36m
RESET := \033[0m

# ==========================================
# 🚀 1. Setup Local Ultra-Rápido (MacOS/Apple Silicon)
# ==========================================

init: ## ✅ Inicializa el entorno local usando 'uv'
	@echo "$(CYAN)[Antigravity] Inicializando entorno virtual con uv...$(RESET)"
	uv venv
	@echo "$(CYAN)[Antigravity] Sincronizando dependencias...$(RESET)"
	uv pip install -r requirements.txt
	@echo "$(CYAN)[Antigravity] Inicializando directorios clave...$(RESET)"
	mkdir -p artifacts src/tools src/agents tests .antigravity/workflows
	@echo "¡Listo! Activa el entorno con: source .venv/bin/activate"

dev: ## ⚡ Inicia el orquestador principal (LangGraph) en local
	@echo "$(CYAN)[Antigravity] Levantando orquestador local...$(RESET)"
	uv run python src/main.py

# ==========================================
# 🐳 2. Contenedores (Aislado y Consistente)
# ==========================================

docker-build: ## 🏗️  Construye la imagen Docker optimizada
	@echo "$(CYAN)[Docker] Construyendo imagen de Antigravity...$(RESET)"
	docker compose build

docker-up: ## 🐋 Levanta los agentes en Docker con memoria persistente
	@echo "$(CYAN)[Docker] Iniciando ecosistema...$(RESET)"
	docker compose up -d
	@echo "$(CYAN)[Docker] Logs disponibles: docker compose logs -f$(RESET)"

docker-down: ## 🛑 Detiene los contenedores Docker
	@echo "$(CYAN)[Docker] Apagando ecosistema...$(RESET)"
	docker compose down

# ==========================================
# 🧪 3. Testing y Calidad (Pytest & Playwright)
# ==========================================

test: ## 🚦 Ejecuta toda la suite de pruebas (Unit + E2E)
	@echo "$(CYAN)[Testing] Ejecutando Pytest...$(RESET)"
	uv run pytest tests/
	@echo "$(CYAN)[Testing] Ejecutando Playwright E2E...$(RESET)"
	uv run playwright test

lint: ## 🧹 Ejecuta linters y formatters (Ruff / Black)
	@echo "$(CYAN)[Linting] Revisando calidad de código...$(RESET)"
	uv run ruff check src/
	uv run black src/

# ==========================================
# 🗑️ 4. Mantenimiento
# ==========================================

clean: ## 💥 Limpia cachés, bd locales y entornos virtuales
	@echo "$(CYAN)[Clean] Eliminando artefactos y caché...$(RESET)"
	rm -rf .venv/
	rm -rf .pytest_cache/
	rm -rf __pycache__/
	rm -rf artifacts/*
	@echo "Entorno limpio."

# Ayuda por defecto
help:
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-15s$(RESET) %s\n", $$1, $$2}'
