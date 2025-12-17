# *Base de Datos - Campamento*
## Descripción del Proyecto
### Creación de usuarios:

`PP_GRILLO` → Usuario con permisos básicos, posteriormente ampliados.

`user_Dolores_de_Barriga` → Usuario especializado en gestión de clientes.

`user_Paco_Mer` → Usuario especializado en gestión de pagos.


`super_admin` → Usuario con privilegios completos en todas las bases de datos.

## Asignación de permisos
Se aplicó correctamente asignando permisos específicos por tabla:

`user_Dolores_de_Barriga:`Permisos completos (SELECT, INSERT, UPDATE) en clientes. Solo lectura (SELECT) en pago_campamento

`user_Paco_Mer:`Permisos completos (SELECT, INSERT, DELETE) en pago_campamento. Solo lectura (SELECT) en clientes.

## Evolución de Permisos de PP_GRILLO
Este usuario experimentó una evolución controlada de permisos:

* Inicio: Solo SELECT, INSERT en toda la base

* Ajuste 1: Se revocó INSERT (posible corrección de seguridad)

* Ajuste 2: Se añadió UPDATE en toda la base

* Configuración final: CRUD completo en clientes + SELECT en pago_campamento

/-------------------------------------------------------------------------------------------------------------------------------/

# *Base de Datos - Negocios_Extranjeros S.A.*
## Descripción del Proyecto
Se ha implementado un sistema de base de datos para "Negocios_Extranjeros S.A." con control de auditoría y gestión de usuarios por roles. El sistema cumple con los requisitos regulatorios de trazabilidad de modificaciones.

### TABLAS ESPECÍFICAS
`clientes:` Campos esenciales para gestión internacional (país, email único)

`inversionistas:` Distinción clara entre tipos de inversionistas

`ventas:` Estados de transacción bien definidos

`audit_log:` Estructura flexible con JSON para valores antiguos/nuevos.

### Puntos a Destacar
* Sistema de auditoría completo con triggers bien diseñados

* Relaciones adecuadas entre tablas

* Uso de JSON para flexibilidad en auditoría
