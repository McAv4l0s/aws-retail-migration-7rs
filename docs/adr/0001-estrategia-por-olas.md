# ADR-0001: Migración por olas y modernización posterior

- Estado: Aceptada
- Fecha: 2026-08-31

## Contexto

El portafolio combina urgencia de hardware, dependencias poco observables y componentes que sí diferencian al negocio. Una transformación simultánea elevaría el blast radius y dificultaría atribuir resultados.

## Decisión

Preparar primero la plataforma, retirar alcance innecesario, ejecutar rehost/replatform con gates y modernizar checkout después de estabilizar dependencias y operación.

## Consecuencias

- Menor riesgo por ola y rollback más claro.
- Periodo híbrido y operación temporalmente más compleja.
- Beneficios de refactor aparecen después de los movimientos de salida.
- Las decisiones 7 R se revisan con nueva evidencia.

