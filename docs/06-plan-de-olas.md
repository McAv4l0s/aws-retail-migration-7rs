# Plan de olas

**Línea base del programa:** mayo de 2026

**Ventana planificada:** 4 de mayo–26 de junio de 2026

| Ola | Ventana planificada | Alcance | Objetivo | Gate de salida |
|---|---|---|---|---|
| 0 | 4–8 mayo | Landing zone, red, identidad, logs | Preparar operación segura | Controles y conectividad aprobados |
| 1 | 11–15 mayo | Retire catálogo + carga piloto | Reducir alcance y validar método | Reconciliación y soporte estabilizado |
| 2 | 18–22 mayo | Rehost ERP con MGN | Evitar renovación de hardware | UAT, rendimiento y rollback aprobados |
| 3 | 25–29 mayo | Replatform inventario | Reducir operación de DB | Integridad, RPO y rendimiento aprobados |
| 4 | 1–12 junio | Repurchase CRM + relocate integraciones | Completar salida gradual | Contratos, datos y operación aprobados |
| 5 | 15–22 junio | Refactor checkout | Mejorar escala y velocidad | SLO y despliegue progresivo aprobados |
| Estabilización | 23–26 junio | Hypercare, costos, seguridad y cierre | Confirmar beneficios y operación | KPIs y aceptación ejecutiva |

## Gates comunes

- Go/no-go firmado por negocio, aplicación, infraestructura y seguridad.
- Cambio congelado y backup verificado.
- Observabilidad y mesa de control activas.
- Pruebas críticas completadas.
- Umbrales de rollback cuantificados.
- Validación financiera y de licencias.

## Rollback

Se revierte si hay pérdida o inconsistencia de pedidos, error sostenido sobre el SLO, degradación no mitigable dentro de la ventana o incumplimiento de seguridad. La reversa conserva la fuente hasta la aceptación y evita escrituras concurrentes no reconciliables.
