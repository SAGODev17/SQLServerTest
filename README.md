Scripts de Gestión de Permisos
Este proyecto consta de tres scripts SQL que permiten la creación de una base de datos, llenado de tablas y la implementación de procedimientos almacenados necesarios para la gestión de permisos en un sistema. A continuación se describe la función de cada uno de los scripts.


1. scripts_para_crear_tablas.sql:
Este script tiene como objetivo la creación de la base de datos y las tablas necesarias para gestionar los permisos en el sistema.

Operaciones realizadas:
Creación de la base de datos: Se crea la base de datos llamada Permit_management_system.
Creación de la tabla EntityCatalog:
Esta tabla almacena información sobre las entidades del sistema, con campos como el nombre de la entidad y un identificador único (id_entit).
Además, se definen otras tablas necesarias para la gestión de permisos, aunque no se mencionan en detalle en este script.


2. scripts_para_llenar_tablas.sql
Este script se encarga de insertar datos en las tablas previamente creadas. Se incluye un procedimiento almacenado para generar combinaciones de permisos.

Operaciones realizadas:
Llenado de la tabla Permission: Se realiza una consulta para obtener datos de la tabla Permission.
Procedimiento almacenado InsertPermissionCombinations:
Este procedimiento limpia la tabla Permission antes de insertar nuevas combinaciones de permisos.
Utiliza un enfoque basado en combinaciones binarias (de 0 a 63) para insertar valores en la tabla.


3. scripts_procedimientos_almacenados.sql
Este script define procedimientos almacenados adicionales que facilitan la gestión de permisos asignados a los usuarios en función de las entidades a las que pertenecen.

Operaciones realizadas:

- 1. GetUserPermissions
Propósito: Obtiene los permisos asignados a un usuario específico para una entidad dada.
Parámetros: @id_user (ID del usuario), @id_entit (ID de la entidad).
Función: Verifica si existe una relación entre el usuario y la entidad. Si existe, devuelve los permisos asignados; de lo contrario, muestra un error.

- 2. GetRolPermissions
Propósito: Obtiene los permisos asignados a un rol específico para una entidad dada.
Parámetros: @id_role (ID del rol), @id_entit (ID de la entidad).
Función: Verifica si existe una relación entre el rol y la entidad. Si existe, devuelve los permisos asignados al rol; si no, muestra un error.

- 3. GetUserRecordPermissions
Propósito: Obtiene los permisos asignados a un usuario específico para registros dentro de una entidad.
Parámetros: @id_user (ID del usuario), @id_entit (ID de la entidad).
Función: Comprueba si existe una relación entre el usuario y la entidad. Si la relación es válida, devuelve los permisos asignados; si no, muestra un error.
- 4. GetRolRecordPermissions
Propósito: Obtiene los permisos asignados a un rol específico para registros dentro de una entidad.
Parámetros: @id_role (ID del rol), @id_entit (ID de la entidad).
Función: Verifica si existe una relación entre el rol y la entidad. Si la relación es válida, devuelve los permisos asignados al rol; si no, muestra un error.

