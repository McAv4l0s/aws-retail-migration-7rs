# CloudFormation: base del laboratorio de migración

La plantilla `retail-migration-foundation.yaml` crea una base desplegable para el caso retail:

- Una VPC con DNS habilitado.
- Dos subredes públicas en zonas de disponibilidad distintas.
- Dos subredes privadas aisladas en zonas distintas.
- Internet Gateway y rutas únicamente para las subredes públicas.
- Grupo de seguridad sin reglas entrantes.
- VPC Flow Logs opcionales hacia CloudWatch Logs.
- Bucket S3 cifrado, versionado y sin acceso público para evidencias.

No crea NAT Gateway, instancias EC2, balanceadores ni bases de datos. Esto reduce el riesgo de costos inesperados, pero las subredes privadas no tienen salida a internet. Para utilizar MGN se deberá diseñar conectividad mediante endpoints, NAT Gateway o red híbrida según el escenario.

## Requisitos

- AWS CLI configurada con una cuenta sandbox.
- Permisos para CloudFormation, EC2, IAM, CloudWatch Logs y S3.
- Una región con al menos dos zonas de disponibilidad.

## Validación local

```bash
cfn-lint infra/cloudformation/retail-migration-foundation.yaml

aws cloudformation validate-template \
  --template-body file://infra/cloudformation/retail-migration-foundation.yaml
```

La segunda validación requiere credenciales AWS y consulta el servicio CloudFormation.

## Crear o actualizar el stack

Ejecutar desde la raíz del repositorio:

```bash
aws cloudformation deploy \
  --stack-name retail-migration-foundation-dev \
  --template-file infra/cloudformation/retail-migration-foundation.yaml \
  --parameter-overrides \
    ProjectName=retail-migration-7rs \
    Environment=dev \
    EnableVpcFlowLogs=true \
    LogRetentionDays=30 \
  --capabilities CAPABILITY_IAM \
  --no-fail-on-empty-changeset \
  --tags Portfolio=aws-migration Environment=dev ManagedBy=CloudFormation
```

## Consultar resultados

```bash
aws cloudformation describe-stacks \
  --stack-name retail-migration-foundation-dev \
  --query 'Stacks[0].Outputs' \
  --output table
```

## Eliminar el stack

```bash
aws cloudformation delete-stack \
  --stack-name retail-migration-foundation-dev

aws cloudformation wait stack-delete-complete \
  --stack-name retail-migration-foundation-dev
```

El bucket de evidencias utiliza `DeletionPolicy: Retain`, por lo que permanece después de eliminar el stack. Esto protege la evidencia de borrados accidentales. Cuando ya no sea necesario, se debe vaciar y eliminar manualmente después de comprobar su contenido.

## Controles antes de producción

- Revisar que los CIDR no se superpongan con redes corporativas.
- Sustituir la salida abierta del security group por reglas específicas.
- Definir conectividad privada para MGN y servicios administrados.
- Evaluar cifrado con una clave KMS administrada por el cliente.
- Añadir AWS Config, CloudTrail centralizado, budgets y controles organizacionales.
- Ejecutar un change set y revisar todos los reemplazos antes del deploy.

