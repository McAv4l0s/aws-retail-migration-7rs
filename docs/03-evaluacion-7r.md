# Evaluación de las 7 R

## Método de decisión

Cada carga recibe una puntuación de 1 a 5 en valor de negocio, urgencia, riesgo técnico, complejidad de dependencias, preparación operativa y potencial de modernización. La R elegida no es permanente: se revisa al completar descubrimiento y pruebas.

| Carga | R | Motivo de negocio | Motivo técnico | Gate principal |
|---|---|---|---|---|
| Catálogo batch | Retire | Función duplicada | Componentes sin soporte | Reconciliación y archivo aprobados |
| POS | Retain | Alto riesgo en tiendas | Dependencia de periféricos y red | Estrategia edge definida |
| ERP auxiliar | Rehost | Fecha límite de hardware | Compatible con réplica a EC2 | Prueba MGN y licencias aprobadas |
| Integraciones VMware | Relocate | Salida rápida del sitio | Cambio mínimo de hipervisor | Compatibilidad y conectividad |
| CRM | Repurchase | No diferencia al negocio | SaaS cubre capacidades | Migración de datos y contratos |
| Inventario | Replatform | Menor operación | Motor compatible con RDS | Rendimiento y reconciliación |
| Checkout | Refactor | Diferenciador de ingresos | Monolito limita escalamiento | SLO, pruebas y strangler pattern |

## Secuencia

La clasificación no significa ejecutar siete movimientos simultáneos. Retire y repurchase reducen alcance; retain controla riesgo; rehost/relocate aceleran la salida; replatform/refactor se programan cuando la plataforma y el equipo están preparados.

