# Riesgos y RACI

## Registro de riesgos

| ID | Riesgo | Prob. | Impacto | Mitigación | Propietario |
|---|---|---:|---:|---|---|
| R-01 | Dependencia no descubierta | 3 | 5 | Telemetría, entrevistas y prueba de ola | Application Owner |
| R-02 | Inconsistencia de inventario | 3 | 5 | CDC/reconciliación y freeze | Data Owner |
| R-03 | Costo superior al business case | 3 | 4 | Budgets, rightsizing y revisión semanal | FinOps |
| R-04 | Acceso excesivo durante migración | 2 | 5 | Roles temporales y auditoría | Security Owner |
| R-05 | Cutover en periodo comercial crítico | 2 | 5 | Calendario de blackout y go/no-go | Business Owner |
| R-06 | Licencia no portable | 3 | 4 | Validación contractual previa | Procurement |

Escala: 1 bajo, 5 alto. Los riesgos con producto probabilidad × impacto ≥ 12 requieren plan y aceptación ejecutiva.

## RACI resumido

| Actividad | Negocio | Programa | App | Plataforma | Seguridad | FinOps |
|---|---|---|---|---|---|---|
| Aprobar alcance y KPI | A | R | C | C | C | C |
| Clasificar 7 R | C | A | R | R | C | C |
| Diseñar landing zone | I | A | C | R | R | C |
| Aprobar cutover | A | R | R | R | C | I |
| Aceptar riesgo | A | R | C | C | R | C |
| Validar beneficios | A | R | C | I | I | R |

R = responsable, A = accountable, C = consultado, I = informado.

