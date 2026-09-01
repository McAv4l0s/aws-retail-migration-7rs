# Plan de olas

| Ola | Alcance | Objetivo | Gate de salida |
|---|---|---|---|
| 0 | Landing zone, red, identidad, logs | Preparar operación segura | Controles y conectividad aprobados |
| 1 | Retire catálogo + carga piloto | Reducir alcance y validar método | Reconciliación y soporte estabilizado |
| 2 | Rehost ERP con MGN | Evitar renovación de hardware | UAT, rendimiento y rollback aprobados |
| 3 | Replatform inventario | Reducir operación de DB | Integridad, RPO y performance aprobados |
| 4 | Repurchase CRM + relocate integraciones | Completar salida gradual | Contratos, datos y operación aprobados |
| 5 | Refactor checkout | Mejorar escala y velocidad | SLO y despliegue progresivo aprobados |

## Gates comunes

- Go/no-go firmado por negocio, aplicación, infraestructura y seguridad.
- Cambio congelado y backup verificado.
- Observabilidad y mesa de control activas.
- Pruebas críticas completadas.
- Umbrales de rollback cuantificados.
- Validación financiera y de licencias.

## Rollback

Se revierte si hay pérdida o inconsistencia de pedidos, error sostenido sobre el SLO, degradación no mitigable dentro de la ventana o incumplimiento de seguridad. La reversa conserva la fuente hasta la aceptación y evita escrituras concurrentes no reconciliables.

