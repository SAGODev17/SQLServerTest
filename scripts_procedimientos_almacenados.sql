

	-- procedimiento almacenado para el filtro y busqueda de los permisos asignados por usurio y entidad


CREATE PROCEDURE GetUserPermissions  -- creación del procedimiento almacenado
    @id_user BIGINT,   -- Parámetro para el ID del usuario
    @id_entit INT      -- Parámetro para el ID de la entidad (EntityCatalog)
AS
BEGIN
    -- Comprobar si existe una relación entre el usuario y la entidad
    IF NOT EXISTS (
        SELECT 1
        FROM PermiUser PU
        JOIN UserCompany UC ON UC.id_useco = PU.usercompany_id
        JOIN [User] U ON U.id_user = UC.[user_id]
        WHERE U.id_user = @id_user AND PU.entitycatalog_id = @id_entit
    )
    BEGIN
        -- Si no existe la relación, muestra un mensaje
        RAISERROR('No existe una relación entre el usuario y la entidad especificada.', 16, 1);
        RETURN;  -- Termina la ejecución del procedimiento
    END
    
    -- Si existe la relación, obtiene los permisos
    SELECT DISTINCT
        U.user_username AS 'nombre',                     -- Nombre del usuario
        P.description AS 'descripcion_de_permiso',       -- Descripción del permiso
        E.entit_name AS 'entidad'                        -- Nombre de la entidad
    FROM Permission P
    JOIN PermiUser PU 
        ON PU.permission_id = P.id_permi
    JOIN EntityCatalog E 
        ON E.id_entit = PU.entitycatalog_id
    JOIN UserCompany UC 
        ON UC.id_useco = PU.usercompany_id
    JOIN [User] U 
        ON U.id_user = UC.[user_id]
    WHERE U.id_user = @id_user    -- Filtra por el ID del usuario proporcionado
    AND E.id_entit = @id_entit;   -- Filtra por el ID de la entidad proporcionada
END;


EXEC GetUserPermissions @id_user = 1, @id_entit = 1; -- ejecución del procedimiento


-- procedimiento almacenado para el filtro y busqueda de los permisos asignados por role y entidad
	
	SELECT * FROM [role];

CREATE PROCEDURE GetRolPermissions -- Creación del procedimiento almacenado

	 @id_role BIGINT,   -- Parámetro para el ID del rol 
     @id_entit INT      -- Parámetro para el ID de la entidad (EntityCatalog)
AS
BEGIN
-- Comprobar si existe una relación entre el roll y la entidad 

    IF NOT EXISTS (
        SELECT 1
        FROM [Role] R
        JOIN PermiRole PR ON R.id_role = PR.role_id
        JOIN EntityCatalog E ON E.id_entit = PR.entitycatalog_id
        WHERE R.id_role = @id_role AND Pr.entitycatalog_id = @id_entit
    )
    BEGIN
        -- Si no existe la relación, muestra un mensaje
        RAISERROR('No existe una relación entre el roll y la entidad especificada.', 16, 1);
        RETURN;  -- Termina la ejecución del procedimiento
    END
	-- consulta 
	
    -- Si existe la relación, obtiene los permisos rol -entidad
    SELECT 
        R.role_name AS 'rol',                     -- Nombre del rol
        P.[description] AS 'descripcion_de_permiso',       -- Descripción del permiso
        E.entit_name AS 'entidad'                       -- Nombre de la entidad
   
   FROM Permission P
    JOIN PermiRole PR 
        ON PR.permission_id = P.id_permi
    JOIN EntityCatalog E 
        ON E.id_entit = PR.entitycatalog_id
	JOIN [Role] R 
        ON R.id_role = PR.role_id

    WHERE R.id_role = @id_role    -- Filtra por el ID del rol proporcionado
    AND E.id_entit = @id_entit;   -- Filtra por el ID de la entidad proporcionada
END;


EXEC GetRolPermissions @id_role = 1, @id_entit = 1; -- ejecución del procedimiento
--drop procedure Getrolpermissions 


	-- procedimiento almacenado para el filtro y busqueda de los permisos asignados por usurio y registros en una entidad

CREATE PROCEDURE GetUserRecordPermissions

    @id_user BIGINT,   -- Parámetro para el ID del usuario
    @id_entit INT      -- Parámetro para el ID de la entidad
AS
BEGIN
    -- Validación inicial: Comprobar existencia de relación
    IF NOT EXISTS (
        SELECT 1
        FROM PermiUser PUR
        JOIN UserCompany UC ON UC.id_useco = PUR.usercompany_id
        JOIN [User] U ON U.id_user = UC.[user_id]
        JOIN EntityCatalog E ON E.id_entit = PUR.entitycatalog_id
        WHERE U.id_user = @id_user AND PUR.entitycatalog_id = @id_entit
    )
    BEGIN
        -- Si no existe la relación, muestra un mensaje
        RAISERROR('No existe una relación entre el roll y la entidad especificada.', 16, 1);
        RETURN  -- Termina la ejecución del procedimiento
    END;

    SELECT 
        U.user_username AS Nombre_Usuario,
        P.[description] AS Permiso,
        E.entit_name AS Entidad
    FROM Permission P
    JOIN PermiUser PUR 
        ON PUR.permission_id = P.id_permi
    JOIN EntityCatalog E 
        ON E.id_entit = PUR.entitycatalog_id
    JOIN UserCompany UC 
        ON UC.id_useco = PUR.usercompany_id
    JOIN [User] U 
        ON U.id_user = UC.[user_id]
    WHERE U.id_user = @id_user
    AND E.id_entit = @id_entit;
END;

EXEC  GetUserRecordPermissions @id_user = 10, @id_entit = 10; -- ejecución del procedimiento
--drop procedure GetUserRecordPermissions



	-- procedimiento almacenado para el filtro y busqueda de los permisos asignados por roll a registros en una entidad


CREATE PROCEDURE GetRolRecordPermissions
    @id_role BIGINT,   -- Parámetro para el ID del rol
    @id_entit INT      -- Parámetro para el ID de la entidad
AS
BEGIN
    -- Validación inicial: Comprobar existencia de relación
    IF NOT EXISTS (
              SELECT 1
        FROM [Role] R
        JOIN PermiRoleRecord PRR ON PRR.role_id = R.id_role
        JOIN EntityCatalog E ON E.id_entit = PRR.entitycatalog_id
        WHERE R.id_role = @id_role AND PRR.entitycatalog_id = @id_entit
    )
    BEGIN
        -- Si no existe la relación, muestra un mensaje
        RAISERROR('No existe una relación entre el roll y la entidad especificada.', 16, 1);
        RETURN; -- Termina la ejecución del procedimiento
    END

  SELECT 
        R.id_role as id_roll,
		E.id_entit as id_entiti,
        R.role_name AS Rol_nombre,
        P.[description] AS Permiso,
        E.entit_name AS Entidad
    FROM Permission P
    JOIN PermiRoleRecord PRR 
        ON PRR.permission_id = P.id_permi
    JOIN [Role] R
        ON R.id_role= PRR.role_id
	JOIN EntityCatalog E
		ON E.id_entit = PRR.entitycatalog_id
    WHERE R.id_role = @id_role    -- Filtra por el ID del rol proporcionado
    AND E.id_entit = @id_entit -- Filtra por el ID de la entidad proporcionada
END;


EXEC  GetRolRecordPermissions @id_role = 2, @id_entit = 5 -- ejecución del procedimiento
--drop procedure GetRolRecordPermissions


SELECT 
    p.name AS Procedimiento,
    SCHEMA_NAME(p.schema_id) AS Esquema,
    p.create_date AS Fecha_Creacion,
    p.modify_date AS Fecha_Modificacion
FROM sys.procedures p