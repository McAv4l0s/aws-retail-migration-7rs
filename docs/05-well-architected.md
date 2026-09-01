# Revisión AWS Well-Architected

| Pilar | Riesgo inicial | Decisión | Evidencia esperada |
|---|---|---|---|
| Excelencia operativa | Runbooks manuales y ownership incompleto | IaC, CI/CD, owners y game days | Pipeline, ADR, runbooks y postmortems |
| Seguridad | Accesos persistentes y logs fragmentados | Federación, mínimo privilegio, cifrado y logs centrales | Policy checks, trails y findings |
| Confiabilidad | Recuperación no ensayada | Multi-AZ según criticidad, backups y pruebas | Restore report y métricas RTO/RPO |
| Rendimiento | Capacidad fija para picos | Pruebas, escalamiento y colas | Load test y utilización |
| Costos | Sin costo por producto | Etiquetas, budgets, rightsizing y unit economics | Reporte costo/pedido |
| Sostenibilidad | Ambientes ociosos | Apagado programado y servicios administrados | Horas evitadas y utilización |

## Riesgos altos pendientes

1. Dependencias del ERP no observadas durante un ciclo comercial completo.
2. RPO de inventario no validado mediante reconciliación de pedidos.
3. Modelo de identidad de operadores y proveedores por aprobar.
4. Costo del pico sin prueba de carga representativa.

La revisión se repite antes de producción y 30 días después de cada ola. Cada riesgo debe tener propietario, fecha y criterio de cierre.

