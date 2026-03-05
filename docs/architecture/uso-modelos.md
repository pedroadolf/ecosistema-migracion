# ⛽ Protocolo de Optimización de Modelos y Cuotas (Gasolina) v3.0

Guía definitiva para eficientar el consumo de IA mediante la gestión de "Tanques Compartidos" y prevenir bloqueos de servicio.

## 🏗️ 1. Arquitectura de Tanques

Los modelos de IA operan bajo presupuestos compartidos. Agotar un modelo puede bloquear a toda su familia.

### 🔵 TANQUE 1: Google Gemini (Recuperación: ~3.5h)
- **🟢 Gemini Flash:** Tanque Independiente. (85% de las tareas).
- **🟡 Gemini Pro Low:** Tanque Compartido con High.
- **🔴 Gemini Pro High:** Tanque Compartido.
> **REGLA:** Si Pro Low falla por cuota, Pro High también está bloqueado. **No alternar hermanos.** Saltar a Flash o Tanque 2.

### 🟣 TANQUE 2: Terceros / Anthropic & OpenAI (Recuperación: ~5h)
- **🟡 Claude Sonnet:** Estándar.
- **🔴 Modelos "Thinking" (Opus / GPT-Oss / Sonnet Thinking):** Consumen 5-10x más y vacían el tanque en escasos turnos.
> **REGLA:** Si Claude falla, GPT también falla. Evitar usar "Thinking" a menos que sea una emergencia nuclear absoluta.

---

## 🎯 2. Reglas de Oro Operativas

1. **Flash First (80-85%):** El 80% del trabajo (refactors medios, explicaciones, snippets, debug) debe resolverse con Flash.
2. **Chunking Inteligente:** Si una tarea supera las 50 líneas, **divídela** en tareas más pequeñas asimilables por Flash, en lugar de invocar a Pro.
3. **No Hermanos:** No intentes usar Gemini Pro High tras un fallo de Gemini Pro Low.
4. **Tanque 2 = Último Recurso:** Usar Claude Sonnet únicamente cuando Gemini Pro se haya agotado o falle estructuralmente en un problema complejo.
5. **Thinking = Veneno:** Jamás usar modelos "Thinking" para tareas estándar. Advierten bloqueo de 5h si se usan frívolamente.

---

## 🧠 3. Protocolo Sensor (Manejo de Respuestas)

Los agentes deben funcionar como un **sensor de gasolina**, deteniendo operaciones que amenacen con vaciar el tanque.

- **Evaluación de Carga [Pre-ejecución]:** Si detectas una tarea superior a 50 líneas, pausa y pregunta al usuario si desea dividirla en subtareas para Flash.
- **Alerta de Chat Largo [Mensaje > 25]:** Los historiales largos consumen token exponencialmente (3x). Al acercarse a los 25 mensajes, debes advertir al usuario.
- **Gestión de Errores `quota_exceeded`:** Al detectar falla por cuotas, **bloquear todo el tanque familiar** en el enrutamiento (ej. si falla Pro Low, bloquear mentalmente Pro High) y ofercer explícitamente el "Procedimiento Failover".

---

## 💾 4. Checkpoint ADN (Guardado de Estado)

Herramienta crítica para vaciar la memoria de contexto y reiniciar con un chat fresco sin perder el progreso.
**Cuándo activarlo:**
- El chat supera los 25-30 mensajes.
- El usuario lo solicita orgánicamente (ej. "resumen", "checkpoint").
- Se ha concluido una fase pesada de arquitectura.

**Estructura del Checkpoint:**
- Estado Actual y objetivos completados.
- Contexto Técnico (Variables, configuraciones, decisiones clave).
- Siguientes pasos exactos.
- Mensaje pre-compilado listo para copiar y pegar en un nuevo chat de Flash.

---

## 🔄 5. Árbol de Decisión / Failover

1. **¿Tarea Simple o divisible?** → Gemini Flash 🟢
2. **¿Requiere razonamiento complejo / Flash Falló?**
   - Tanque Pro disponible → Gemini Pro Low 🟡
   - Tanque Pro agotado → Claude Sonnet 🟡 (Sin Thinking)
3. **¿Emergencia Arquitectónica Absoluta de Vida o Muerte?** → Modelos Thinking 🔴 (Aviso de bloqueo inminente).

---

## 📋 6. Formato de Respuesta Obligatorio de los Agentes

Para tareas de desarrollo o análisis, los agentes deben estructurar su salida incluyendo lo siguiente:

> ⛽ **Estado de Tanques:** [Flash / Pro / Terceros] - [Nivel de Riesgo]
> 
> 🛠️ **Solución:**
> [Código o recomendaciones técnicas]
> 
> ⚠️ **Sensor:** [Avisos de tamaño de tarea, longitud de chat, alertas tempranas de cuotas]
> 
> 💾 **Checkpoint:** [Generarlo si el sensor marca riesgo por historial largo o si el usuario lo pidió explícitamente]
