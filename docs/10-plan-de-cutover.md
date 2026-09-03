# Plan de cutover

**Zona horaria:** America/Mexico_City

**Ventana del programa:** 15 de mayo–23 de junio de 2026

**Cierre de estabilización:** 26 de junio de 2026

## Calendario maestro

| ID | Wave | Carga | Estrategia | Ventana de cutover | Freeze | Criterio de éxito | Límite para rollback |
|---|---|---|---|---|---|---|---|
| CO-01 | 1 | Catálogo batch heredado | Retire | 15 mayo, 21:00–23:00 | 20:00 | Archivo conciliado y consumidores redirigidos | Diferencia de catálogo > 0.5% |
| CO-02 | 2 | ERP auxiliar | Rehost con MGN | 22 mayo, 22:00–23 mayo, 02:00 | 21:00 | UAT crítico, integraciones y jobs correctos | Sev-1, pérdida de datos o > 30 min sin progreso |
| CO-03 | 3 | Base de inventario | Replatform a RDS | 29 mayo, 22:00–30 mayo, 03:00 | 21:00 | Reconciliación ≥ 99.99% y latencia dentro del SLO | Diferencia > 0.01% o latencia p95 fuera del SLO 15 min |
| CO-04 | 4 | CRM e integraciones VMware | Repurchase / Relocate | 12 junio, 21:00–13 junio, 02:00 | 20:00 | Casos, usuarios y flujos principales aprobados | Integración crítica fallida durante 30 min |
| CO-05 | 5 | Checkout modernizado | Refactor | 22 junio, 22:00–23 junio, 01:00 | 21:00 | Error rate, pagos y conversión dentro del SLO | Error rate > 2% durante 10 min o pagos inconsistentes |

## Gobierno de la ventana

| Rol | Responsabilidad durante el cutover |
|---|---|
| Cutover Manager | Dirige la secuencia, registra tiempos y declara go/no-go |
| Business Owner | Autoriza interrupción, valida procesos críticos y acepta el servicio |
| Application Owner | Ejecuta smoke tests, UAT y verificación funcional |
| Platform Lead | Ejecuta infraestructura, red, observabilidad y cambio de tráfico |
| Data Lead | Controla freeze, réplica, reconciliación y consistencia |
| Security Lead | Supervisa accesos temporales, hallazgos y evidencia |
| Communications Lead | Actualiza stakeholders y mesa de servicio |

## Checkpoints obligatorios

### T-24 horas

- Change aprobado y responsables confirmados.
- Backup y restauración verificados.
- Replicación, capacidad y observabilidad saludables.
- Runbook y reversa ensayados.
- No existen incidentes críticos abiertos.

### T-60 minutos

- Abrir el command bridge y congelar cambios.
- Confirmar métricas baseline y canales de escalamiento.
- Validar credenciales temporales y accesos de emergencia.
- Registrar decisión preliminar go/no-go.

### T-0

- Detener escrituras conforme al runbook.
- Confirmar lag cero o dentro del umbral aprobado.
- Ejecutar el cambio y registrar cada timestamp.

### T+30 y T+60 minutos

- Ejecutar pruebas funcionales, integraciones y reconciliación.
- Comparar error rate, latencia, volumen y transacciones con la línea base.
- Decidir aceptación, extensión controlada o rollback.

## Reglas de rollback

El Cutover Manager inicia la reversa cuando se alcanza un límite de la tabla, aparece una pérdida o duplicación de transacciones, surge un hallazgo crítico de seguridad o no queda tiempo suficiente para completar pruebas dentro de la ventana. La fuente permanece disponible hasta la aceptación formal.

En CO-02, **no se finaliza el cutover en MGN** hasta completar UAT, reconciliación y aprobación. Finalizar MGN detiene la replicación y elimina los recursos temporales de réplica, por lo que esa acción pertenece al cierre, no al inicio del cutover.

## Evidencia de cierre

- Registro de decisiones go/no-go.
- Timestamps de inicio, cambio, validación y cierre.
- Resultados de smoke tests, UAT y reconciliación.
- Métricas antes y después.
- Incidentes, desviaciones y acciones pendientes.
- Aceptación del Business Owner y del Service Owner.
