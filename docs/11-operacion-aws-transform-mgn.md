# Modelo operativo de AWS Transform MGN

Este documento cubre las funciones visibles en el menú de AWS Transform MGN y las conecta con la Wave 2 y el cutover CO-02. MGN es regional: antes de operar se debe confirmar la cuenta y la región objetivo.

## Cobertura de la consola

| Vista | Uso dentro del programa | Propietario | Evidencia mínima | Gate |
|---|---|---|---|---|
| Source servers | Registrar y monitorear servidores, réplica, alertas y lifecycle | MGN Operator | Inventario, lag, backlog y estado | Servidores `Ready for testing` |
| Applications | Agrupar servidores del ERP como una unidad de negocio | Application Owner | Aplicación, tags y dependencias | Todos los servidores asociados y saludables |
| Waves | Asociar aplicaciones a Wave 2 y ejecutar acciones coordinadas | Migration Factory Lead | Wave, ventana y estado agregado | Wave aprobada para test/cutover |
| Global view | Supervisar cuentas miembro cuando existe AWS Organizations | Cloud Platform Lead | Cuentas vinculadas y permisos | Inventario entre cuentas conciliado |
| Launch history | Auditar tests, cutovers, terminaciones y errores | Cutover Manager | Job ID, timestamps, estado y log | Job completado sin errores abiertos |
| MGN connectors | Automatizar prerequisitos, credenciales e instalación de agentes | Source Infrastructure Lead | Connector, `Last seen`, servidores y command history | Connector saludable y acceso probado |
| Import | Crear o actualizar servidores, aplicaciones, waves y launch settings por CSV | Migration Planner | Archivo, import job y errores por fila | Import completado y reconciliado |
| Export | Obtener inventario consolidado para revisión y evidencia | PMO / Migration Planner | CSV exportado y export history | Archivo conciliado con el plan |

## Source servers

La página principal lista los servidores agregados a MGN. El filtro puede mostrar servidores activos, descubiertos sin agente, importados sin agente o archivados.

### Inventario de Wave 2

| Server ID del programa | Función | Plataforma | Application | Estado requerido antes de test |
|---|---|---|---|---|
| ERP-WEB-01 | Frontend interno | Linux | ERP-Auxiliar | Healthy / Ready for testing |
| ERP-APP-01 | Servicios ERP | Windows | ERP-Auxiliar | Healthy / Ready for testing |
| ERP-BATCH-01 | Jobs e integraciones | Linux | ERP-Auxiliar | Healthy / Ready for testing |

Para cada servidor se revisan alertas, lag, backlog, discos, replication settings, launch settings, post-launch settings, tags y lifecycle. Un servidor `Lagging` o `Stalled` bloquea el go/no-go hasta investigar la causa.

## Applications

La aplicación `ERP-Auxiliar` agrupa los tres servidores de la Wave 2. La vista de aplicación se usa para observar alertas, estado de réplica y lifecycle agregado, y para ejecutar test o cutover sobre una unidad coherente.

Tags mínimos:

| Tag | Valor |
|---|---|
| Portfolio | c2kmig |
| Wave | wave-02 |
| Application | ERP-Auxiliar |
| BusinessOwner | Finance-Fulfillment |
| Environment | production |
| CutoverId | CO-02 |

## Waves

MGN agrupa aplicaciones y servidores en waves lógicas para monitoreo y acciones masivas. La wave técnica de MGN debe coincidir con el calendario del programa:

| Campo | Valor |
|---|---|
| Wave | `wave-02-erp-rehost` |
| Test window | 19 de mayo de 2026, 20:00–23:00 |
| Cutover window | 22 de mayo, 22:00–23 de mayo, 02:00 |
| Cutover ID | CO-02 |
| Criterio de entrada | Replicación saludable, test finalizado y UAT aprobado |
| Criterio de salida | Cutover aceptado, evidencia completa y aplicación estable |

Secuencia operativa:

1. Start replication.
2. Confirmar sincronización inicial y CDP saludable.
3. Launch test.
4. Ejecutar smoke tests, integraciones, rendimiento, seguridad y UAT.
5. Mark as ready for cutover.
6. Confirmar go/no-go de CO-02.
7. Launch cutover.
8. Validar y reconciliar.
9. Finalize cutover únicamente después de la aceptación.
10. Archive application y source servers al cerrar hypercare.

## Global view

Global view se utiliza cuando la migración abarca varias cuentas. Requiere una cuenta de administración de AWS Organizations o un administrador delegado de MGN. Permite observar y actuar sobre source servers, applications y waves entre cuentas.

Para este laboratorio de una sola cuenta se documenta la capacidad, pero no es un prerrequisito. Si se activa, se deben registrar:

- Cuenta de administración o delegated administrator.
- Cuentas miembro vinculadas.
- Región MGN inicializada por cuenta.
- Permisos de Organizations y trusted access.
- KMS key y modelo de acceso si se usa cifrado administrado por el cliente.

## Launch history

Cada operación genera un Job. Para CO-02 se conservan como mínimo:

| Evidencia | Campos |
|---|---|
| Test job | Job ID, tipo, iniciado por, inicio, fin, status y servidores |
| Test job log | Eventos de conversión, instancia de test, errores y timestamps |
| Cutover job | Job ID, instancia de cutover, status y servidores |
| Cutover job log | Pasos, conversion server, EC2 instance IDs y errores |
| Termination job | Recursos de test terminados y status |

Un Job `Failed` o `Pending` fuera del umbral bloquea el siguiente paso. El Cutover Manager enlaza cada Job ID con el registro de CO-02.

## MGN connectors

El connector automatiza verificación de prerequisitos, registro de credenciales e instalación del replication agent. El dashboard muestra nombre, cantidad de servidores registrados y `Last seen`.

Checklist:

- Connector desplegado en una red con alcance a las fuentes.
- SSM hybrid activation y roles aprobados.
- Credenciales temporales; no almacenar secretos en el repositorio.
- Resolución DNS y puertos verificados.
- `Last seen` dentro del umbral operativo.
- Command history revisado y sin fallas pendientes.
- Credenciales de servidores registradas mediante el mecanismo autorizado.
- Replication agent instalado y validado.

Para tres servidores se puede instalar el agente directamente; el connector se justifica cuando aporta automatización repetible o cuando el portafolio crece. AWS documenta hasta 500 servidores por connector y hasta 50 connectors por cuenta y región.

## Import and Export

MGN permite importar y exportar source servers, applications, waves y atributos de launch template mediante CSV desde disco local o S3.

El ejemplo del repositorio está en [`../data/mgn-import-wave-02.csv`](../data/mgn-import-wave-02.csv). Antes de importarlo:

1. Cambiar región, FQDN, subnet, security group e instance profile por valores de la cuenta sandbox.
2. Confirmar que `mgn:server:user-provided-id`, `mgn:app:name` y `mgn:wave:name` no colisionan con entidades incorrectas.
3. Ejecutar Import y revisar import history fila por fila.
4. Exportar el inventario resultante.
5. Comparar el export con el archivo fuente y con `application-portfolio.csv`.

No se incluyen IDs reales, credenciales ni direcciones de una organización. El import no soporta IPv6. Las políticas administradas sugeridas por AWS para importación son amplias; para producción se deben analizar las acciones usadas y reducir permisos con IAM Access Analyzer.

## Relación con cutover CO-02

| Momento | Vista MGN | Evidencia | Decisión |
|---|---|---|---|
| T-24 h | Source servers / Application | Réplica saludable y test finalizado | Continuar preparación |
| T-60 min | Wave / Global view | Todos los componentes listos | Go/no-go preliminar |
| T-0 | Wave | Launch cutover iniciado | Abrir ventana |
| T+30 min | Launch history | Job completado y sin errores | Iniciar UAT final |
| T+60 min | Source servers / Application | Métricas y reconciliación aprobadas | Aceptar o rollback |
| Cierre | Launch history / Wave | Finalize cutover y archive | Cerrar CO-02 |

## Referencias oficiales

- [AWS Transform MGN console](https://docs.aws.amazon.com/mgn/latest/ug/mgn-console.html)
- [Manage source servers](https://docs.aws.amazon.com/mgn/latest/ug/server-list.html)
- [Group applications in waves](https://docs.aws.amazon.com/mgn/latest/ug/waves.html)
- [Global view](https://docs.aws.amazon.com/mgn/latest/ug/global-view-main.html)
- [Launch history](https://docs.aws.amazon.com/mgn/latest/ug/jobs.html)
- [MGN connectors](https://docs.aws.amazon.com/mgn/latest/ug/mgn-connector-main.html)
- [Import and export](https://docs.aws.amazon.com/mgn/latest/ug/import-export.html)

