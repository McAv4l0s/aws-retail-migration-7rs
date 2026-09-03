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

## Ventanas de cutover

| ID | Wave | Ventana | Cambio de servicio |
|---|---|---|---|
| CO-01 | 1 | 15 mayo, 21:00–23:00 | Retiro del catálogo heredado |
| CO-02 | 2 | 22 mayo, 22:00–23 mayo, 02:00 | Cutover del ERP mediante MGN |
| CO-03 | 3 | 29 mayo, 22:00–30 mayo, 03:00 | Inventario hacia Amazon RDS |
| CO-04 | 4 | 12 junio, 21:00–13 junio, 02:00 | CRM SaaS e integraciones trasladadas |
| CO-05 | 5 | 22 junio, 22:00–23 junio, 01:00 | Tráfico progresivo al nuevo checkout |

La operación detallada, los checkpoints y los umbrales de reversa están en [`10-plan-de-cutover.md`](10-plan-de-cutover.md).

## Gates comunes

- Go/no-go firmado por negocio, aplicación, infraestructura y seguridad.
- Cambio congelado y backup verificado.
- Observabilidad y mesa de control activas.
- Pruebas críticas completadas.
- Umbrales de rollback cuantificados.
- Validación financiera y de licencias.

## Rollback

Se revierte si hay pérdida o inconsistencia de pedidos, error sostenido sobre el SLO, degradación no mitigable dentro de la ventana o incumplimiento de seguridad. La reversa conserva la fuente hasta la aceptación y evita escrituras concurrentes no reconciliables.
