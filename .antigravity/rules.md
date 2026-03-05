# Reglas de Orquestación - Antigravity 2026

Este archivo define las reglas estrictas de comportamiento para todos los agentes autónomos operando dentro del ecosistema Antigravity.

## 1. Regla de Oro: Planificación Obligatoria
**PROHIBIDO** escribir, modificar o eliminar código en el directorio `src/` sin antes generar un documento `plan.md` en el directorio `artifacts/`.
1. El agente Plannner debe crear `artifacts/plan_YYYYMMDD.md`.
2. El usuario debe aprobar el plan (o el agente orquestador si está en modo 100% autónomo).
3. Solo después de la aprobación, el agente Coder puede ejecutar cambios en `src/`.

## 2. Paradigma Agent-First (LangGraph)
- Todo el flujo de trabajo debe modelarse como un grafo direccional en `src/main.py` usando LangGraph.
- Los nodos representan agentes especializados (Planner, Coder, Tester, Reviewer).
- Las aristas representan transiciones condicionales basadas en el estado.

## 3. Manejo de Memoria Híbrida
- **Estados Efímeros y Checkpoints:** El estado de LangGraph (la conversación actual y el contexto inmediato) DEBE persistirse usando SQLite local para permitir *Human-in-the-Loop* (dormir/despertar).
- **Memoria Infinita:** Para almacenamiento a largo plazo (documentos, KIs, historiales de código), los agentes DEBEN utilizar `src/memory.py` respaldado por **ChromaDB**. 
- Todo Knowledge Item (KI) nuevo debe ser vectorizado automáticamente.

## 4. Testing Obligatorio
- **Backend:** Puntuación mínima de cobertura del 80% usando `pytest`. 
- **Frontend/UI:** Los flujos críticos deben ser verificados mediante simulaciones E2E con `Playwright`.

## 5. Control de Calidad
- Antes de que el flujo termine, el nodo Reviewer debe ejecutar:
  - Linter (`ruff` en Python).
  - Verificación de tipos (`mypy`).
  - Formateo (`black` / `prettier`).

## 6. Autodescubrimiento de Herramientas
- Las herramientas personalizadas deben colocarse en `src/tools/` y seguir el esquema `@tool` de LangChain/LangGraph para que los agentes las descubran dinámicamente en tiempo de ejecución.
