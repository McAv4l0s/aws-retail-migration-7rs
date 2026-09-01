# Resumen ejecutivo

## Decisión solicitada

Aprobar un programa por olas para retirar activos sin valor, conservar temporalmente el POS, mover cargas con baja necesidad de cambio y modernizar checkout e inventario. La prioridad es proteger las ventas durante temporadas altas y reducir la dependencia del datacenter sin transformar todo al mismo tiempo.

## Situación de negocio

La capacidad se dimensiona para el pico anual, aunque gran parte permanece ociosa el resto del año. Los cambios del canal digital dependen de ventanas mensuales y la recuperación requiere coordinación manual entre infraestructura, bases de datos y aplicación. La renovación de hardware crea una fecha límite comercial.

## Propuesta

1. Construir la base de gobierno, identidad, red, registro y seguridad.
2. Validar conectividad y operación con una carga de bajo riesgo.
3. Rehostear el ERP auxiliar con MGN para acelerar la salida de hardware.
4. Replatformar inventario en un servicio administrado.
5. Refactorizar checkout después de estabilizar las dependencias.
6. Retirar el catálogo batch y mantener POS bajo criterios de salida definidos.

## Valor esperado

- Menor exposición a fallas físicas y obsolescencia.
- Capacidad elástica durante campañas comerciales.
- Recuperación ensayada con RTO y RPO medibles.
- Costos asignados por producto y ambiente.
- Cambios más pequeños, frecuentes y reversibles.

## Condiciones para aprobar

- Business owner y technical owner nombrados por carga.
- Presupuesto con contingencia y límites de consumo.
- Pruebas funcionales, de rendimiento, seguridad y recuperación aprobadas.
- Plan de reversa practicado antes de cada cutover.
- Prohibición de cambios críticos durante el periodo de mayor venta.

