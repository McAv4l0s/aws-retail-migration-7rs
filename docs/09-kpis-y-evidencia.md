# KPIs y evidencia

## Regla de trazabilidad

Cada cifra se etiqueta como línea base, objetivo, medición de laboratorio o resultado operativo. No se convierte un objetivo en resultado sin evidencia.

| KPI | Fórmula | Fuente | Cadencia | Evidencia en repo |
|---|---|---|---|---|
| Disponibilidad | solicitudes exitosas / solicitudes totales | Métricas de aplicación | Mensual | Export anonimizado |
| RTO | restauración - inicio del incidente | Ejercicio DR | Trimestral | Reporte de game day |
| RPO | último dato recuperado vs interrupción | DB/reconciliación | Trimestral | Reporte de restore |
| Lead time | producción - commit aprobado | CI/CD | Por release | Historial de workflow |
| Costo por pedido | costo atribuible / pedidos completados | Billing + negocio | Mensual | Modelo FinOps |
| Change failure rate | despliegues con incidente / despliegues | ITSM + CI/CD | Mensual | Registro de releases |

## Evidencia inicial del proyecto

- Validación automática de formato y sintaxis de Terraform.
- Inventario versionado de decisiones 7 R.
- Diagramas as-is y to-be revisables.
- Runbook de MGN con prueba, cutover y reversa.
- Registro de riesgos y owners.

Los load tests, restore tests y capturas de ejecución se añadirán cuando exista un entorno sandbox desplegable.

