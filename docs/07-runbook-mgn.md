# Runbook de rehost con AWS Transform MGN

## Alcance

Este runbook aplica al ERP auxiliar clasificado como **Rehost**. MGN replica servidores; la migración de base de datos, modernización y relocate requieren patrones distintos.

## Preparación

- Confirmar sistema operativo, discos, espacio, red y compatibilidad.
- Aprobar puertos, endpoints, permisos y cifrado del staging area.
- Definir plantillas de replicación, lanzamiento y post-launch.
- Registrar owner, ola, tags, instancia objetivo y licensing.
- Tomar backup independiente y verificar restauración.

## Prueba

1. Instalar el agente autorizado en la fuente.
2. Esperar sincronización inicial y confirmar lag/backlog aceptables.
3. Lanzar instancia en modo test en red aislada.
4. Aplicar acciones post-launch y hardening.
5. Ejecutar smoke, integración, rendimiento, seguridad y UAT.
6. Corregir hallazgos y repetir hasta obtener aprobación.

## Cutover

1. Iniciar freeze y mesa de control.
2. Confirmar backup, replicación saludable y ausencia de lag.
3. Detener servicios que generan escrituras.
4. Lanzar la instancia de cutover.
5. Validar sistema, integraciones, monitoreo y reconciliación.
6. Cambiar tráfico/DNS conforme al TTL aprobado.
7. Observar durante la ventana de estabilización.
8. Finalizar el cutover solo después de la aceptación.

## Reversa

La reversa se ejecuta antes de finalizar MGN: detener escrituras en el destino, restaurar el enrutamiento, iniciar la fuente, validar integridad y documentar diferencias. El detalle de reconciliación depende de las transacciones aceptadas durante la ventana.

