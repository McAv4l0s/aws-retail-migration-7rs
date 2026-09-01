# Arquitectura objetivo

## Principios

- Separación de cuentas por ambiente y función.
- Acceso humano federado; sin usuarios permanentes para operación diaria.
- Cifrado, registros y etiquetado habilitados desde la plataforma.
- Alta disponibilidad proporcional a la criticidad.
- Preferencia por servicios administrados cuando reduce carga operativa.
- Interfaces asíncronas para absorber picos y fallas transitorias.

## Flujo objetivo

```mermaid
flowchart TB
    subgraph Edge
      CF[CloudFront]
      WA[AWS WAF]
    end
    subgraph Application
      ALB[Application Load Balancer]
      APP[Checkout services]
      EVT[EventBridge / SQS]
      WORK[Order workers]
    end
    subgraph Data
      RDS[(Amazon RDS Multi-AZ)]
      S3[(Amazon S3)]
    end
    subgraph Migrated
      EC2[ERP on EC2]
      MGN[MGN staging]
    end
    CF --> WA --> ALB --> APP
    APP --> RDS
    APP --> EVT --> WORK --> EC2
    APP --> S3
    MGN -. replication/cutover .-> EC2
```

## Controles transversales

CloudTrail y logs centralizados, métricas y alarmas, detección de configuración, gestión de secretos, backups con pruebas de restauración, etiquetado obligatorio y presupuestos por cuenta. Los servicios exactos se confirman mediante requisitos, región y costo; el diagrama no reemplaza el diseño detallado.

