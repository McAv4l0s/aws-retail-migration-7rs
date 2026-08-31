# Migración y modernización AWS para retail omnicanal

Proyecto de trabajo que documenta la evaluación, movilización y migración de un portafolio retail hacia AWS. La organización se identifica como **Cliente Confidencial** y los datos del caso se presentan de forma agregada o anonimizada.

## Resumen ejecutivo

La organización opera comercio electrónico, tiendas físicas y procesos de back office sobre una combinación de VMware, servidores físicos y software comercial. El crecimiento estacional expone limitaciones de capacidad, recuperaciones manuales, despliegues lentos y costos difíciles de atribuir.

El programa clasifica siete cargas mediante las **7 R de migración**, establece una landing zone, ejecuta un rehost controlado con AWS Transform MGN y moderniza los componentes que aportan una ventaja competitiva. La arquitectura objetivo se evalúa con los seis pilares del AWS Well-Architected Framework.

### Resultados objetivo del business case

| Indicador | Línea base | Objetivo | Método de validación |
|---|---:|---:|---|
| Disponibilidad del canal digital | 99.50% | 99.95% | SLI mensual de solicitudes exitosas |
| Tiempo de recuperación (RTO) | 8 h | 60 min | Ejercicio de recuperación |
| Punto de recuperación (RPO) | 24 h | 15 min | Prueba de restauración y reconciliación |
| Tiempo de aprovisionamiento | 10 días | < 2 h | Pipeline de infraestructura |
| Frecuencia de despliegue | Mensual | Semanal | Historial de CI/CD |
| Costo unitario por pedido | Índice 100 | ≤ 82 | Cost allocation / pedidos completados |

Los valores son objetivos del caso de negocio; no se presentan como resultados de producción. Las mediciones reproducibles del laboratorio se registran en [`docs/09-kpis-y-evidencia.md`](docs/09-kpis-y-evidencia.md).

## Alcance de las 7 R

| R | Carga | Decisión | Resultado esperado |
|---|---|---|---|
| Retire | Catálogo batch heredado | Desactivar tras reconciliar datos | Eliminar soporte y riesgo obsoleto |
| Retain | POS de tiendas | Mantener durante la primera fase | Evitar interrupción en sucursales |
| Rehost | ERP auxiliar en VMware | Migrar a EC2 con MGN | Salir del hardware próximo a renovación |
| Relocate | Clúster VMware de integraciones | Trasladar sin rediseño inicial | Reducir plazo de salida del datacenter |
| Repurchase | CRM instalado localmente | Sustituir por SaaS | Estandarizar ventas y soporte |
| Replatform | Base de datos de inventario | Migrar a Amazon RDS | Reducir operación y mejorar recuperación |
| Refactor | Checkout monolítico | Servicios desacoplados y eventos | Escalar pedidos y acelerar cambios |

La matriz completa y los criterios de decisión están en [`docs/03-evaluacion-7r.md`](docs/03-evaluacion-7r.md).

## Arquitectura y método

```mermaid
flowchart LR
    U[Clientes y tiendas] --> E[CloudFront + WAF]
    E --> A[ALB / API]
    A --> C[Checkout y catálogo]
    C --> DB[(RDS Multi-AZ)]
    C --> Q[Colas y eventos]
    Q --> F[Procesamiento de pedidos]
    F --> ERP[ERP en EC2 migrado con MGN]
    POS[POS retenido] --> DX[Conectividad híbrida]
    DX --> F
    O[Observabilidad y seguridad] -.-> A
    O -.-> C
    O -.-> DB
    O -.-> ERP
```

El programa sigue cuatro movimientos: descubrir y evaluar, preparar la plataforma, migrar por olas y optimizar. MGN se utiliza exclusivamente donde la decisión es rehost; no se atribuye a las demás estrategias.

## Contenido del repositorio

- [`docs/00-resumen-ejecutivo.md`](docs/00-resumen-ejecutivo.md): narrativa para dirección.
- [`docs/01-caso-de-negocio.md`](docs/01-caso-de-negocio.md): valor, costos, beneficios y gobierno.
- [`docs/02-estado-actual.md`](docs/02-estado-actual.md): alcance, dependencias y restricciones.
- [`docs/03-evaluacion-7r.md`](docs/03-evaluacion-7r.md): racionalización del portafolio.
- [`docs/04-arquitectura-objetivo.md`](docs/04-arquitectura-objetivo.md): diseño de la solución.
- [`docs/05-well-architected.md`](docs/05-well-architected.md): revisión de los seis pilares.
- [`docs/06-plan-de-olas.md`](docs/06-plan-de-olas.md): calendario, gates y rollback.
- [`docs/07-runbook-mgn.md`](docs/07-runbook-mgn.md): prueba y cutover del rehost.
- [`docs/08-riesgos-y-raci.md`](docs/08-riesgos-y-raci.md): riesgos, responsables y controles.
- [`docs/09-kpis-y-evidencia.md`](docs/09-kpis-y-evidencia.md): trazabilidad de resultados.
- [`data/application-portfolio.csv`](data/application-portfolio.csv): inventario de decisiones.
- [`infra/terraform`](infra/terraform): landing zone de laboratorio como código.

## Cómo validar la infraestructura

```bash
cd infra/terraform
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

El código está diseñado para revisión y laboratorio. Antes de aplicar recursos debe configurarse una cuenta sandbox, límites de presupuesto, región permitida y controles de seguridad.

## Gobierno de información

Este repositorio no contiene nombres de compañías, credenciales, datos personales, configuraciones exportadas ni identificadores de infraestructura de terceros. Las decisiones se documentan como un proyecto de trabajo de portafolio y deben evaluarse contra el contexto real antes de reutilizarse.
