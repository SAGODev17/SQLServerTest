-- llenado de la bd [Permit_management_system]


select * from Permission;

	-- Procedimiento para insertar combinaciones de permisos

CREATE PROCEDURE InsertPermissionCombinations
AS
BEGIN
    -- Limpia la tabla antes de insertar las combinaciones
    DELETE FROM Permission;

    DECLARE @i INT = 0;
    DECLARE @totalCombinations INT = 64;

    -- Recorremos las combinaciones de 0 a 63 (6 bits)
    WHILE @i < @totalCombinations
    BEGIN
        -- Convertimos el número a una combinación binaria de 6 bits
        DECLARE @can_create BIT = (@i & 1);
        DECLARE @can_read BIT = (@i & 2) / 2;
        DECLARE @can_update BIT = (@i & 4) / 4;
        DECLARE @can_delete BIT = (@i & 8) / 8;
        DECLARE @can_import BIT = (@i & 16) / 16;
        DECLARE @can_export BIT = (@i & 32) / 32;

        -- Generamos un nombre descriptivo del permiso
        DECLARE @name NVARCHAR(255) = CONCAT(
            'Permission_',
            CASE WHEN @can_create = 1 THEN 'C' ELSE '' END,
            CASE WHEN @can_read = 1 THEN 'R' ELSE '' END,
            CASE WHEN @can_update = 1 THEN 'U' ELSE '' END,
            CASE WHEN @can_delete = 1 THEN 'D' ELSE '' END,
            CASE WHEN @can_import = 1 THEN 'I' ELSE '' END,
            CASE WHEN @can_export = 1 THEN 'E' ELSE '' END
        );

        -- Descripción del permiso
        DECLARE @description NVARCHAR(MAX) = CONCAT(
            'Permiso que permite: ',
            CASE WHEN @can_create = 1 THEN 'Crear, ' ELSE '' END,
            CASE WHEN @can_read = 1 THEN 'Leer, ' ELSE '' END,
            CASE WHEN @can_update = 1 THEN 'Actualizar, ' ELSE '' END,
            CASE WHEN @can_delete = 1 THEN 'Eliminar, ' ELSE '' END,
            CASE WHEN @can_import = 1 THEN 'Importar, ' ELSE '' END,
            CASE WHEN @can_export = 1 THEN 'Exportar, ' ELSE '' END
        );
        -- Elimina la coma final
        SET @description = LEFT(@description, LEN(@description) - 2);

        -- Inserta la combinación en la tabla Permission
        INSERT INTO Permission (
            name, description, 
            can_create, can_read, can_update, can_delete, 
            can_import, can_export
        )
        VALUES (
            @name, @description, 
            @can_create, @can_read, @can_update, @can_delete, 
            @can_import, @can_export
        );

        -- Incrementa el contador
        SET @i = @i + 1;
    END
END;
GO

-- Ejecución del procedimiento
EXEC InsertPermissionCombinations;



-- Populate EntityCatalog
INSERT INTO EntityCatalog (entit_name, entit_descrip, entit_active, entit_config)
VALUES 
('Company', 'Gestión de compañías', 1, NULL),
('User', 'Gestión de usuarios', 1, NULL),
('Role', 'Gestión de roles', 1, NULL),
('Permission', 'Gestión de permisos', 1, NULL),
('CostCenter', 'Gestión de centros de costos', 1, NULL),
('BranchOffice', 'Gestión de sucursales', 1, NULL),
('UserCompany', 'Relación usuario-compañía', 1, NULL),
('PermiRole', 'Permisos asignados a roles', 1, NULL),
('PermiUser', 'Permisos asignados a usuarios', 1, NULL),
('PermiRoleRecord', 'Permisos específicos a roles por registro', 1, NULL);

-- Populate Company
INSERT INTO Company (compa_name, compa_tradename, compa_doctype, compa_docnum, compa_address, compa_city, compa_state, compa_country, compa_industry, compa_phone, compa_email, compa_website, compa_logo, compa_active)
VALUES 
('Compañía 1', 'Comercial 1', 'NI', '1234567890', 'Calle 1', 'Ciudad A', 'Estado A', 'País X', 'Industria A', '123-4567', 'contacto@comp1.com', 'www.comp1.com', NULL, 1),
('Compañía 2', 'Comercial 2', 'NI', '2234567890', 'Calle 2', 'Ciudad B', 'Estado B', 'País X', 'Industria B', '123-4568', 'contacto@comp2.com', 'www.comp2.com', NULL, 1),
('Compañía 3', 'Comercial 3', 'NI', '3234567890', 'Calle 3', 'Ciudad C', 'Estado C', 'País X', 'Industria C', '123-4569', 'contacto@comp3.com', 'www.comp3.com', NULL, 1),
('Compañía 4', 'Comercial 4', 'CC', '4234567890', 'Calle 4', 'Ciudad D', 'Estado D', 'País Y', 'Industria D', '123-4570', 'contacto@comp4.com', 'www.comp4.com', NULL, 1),
('Compañía 5', 'Comercial 5', 'CE', '5234567890', 'Calle 5', 'Ciudad E', 'Estado E', 'País Y', 'Industria E', '123-4571', 'contacto@comp5.com', 'www.comp5.com', NULL, 1),
('Compañía 6', 'Comercial 6', 'PP', '6234567890', 'Calle 6', 'Ciudad F', 'Estado F', 'País Z', 'Industria F', '123-4572', 'contacto@comp6.com', 'www.comp6.com', NULL, 1),
('Compañía 7', 'Comercial 7', 'NI', '7234567890', 'Calle 7', 'Ciudad G', 'Estado G', 'País Z', 'Industria G', '123-4573', 'contacto@comp7.com', 'www.comp7.com', NULL, 1),
('Compañía 8', 'Comercial 8', 'NI', '8234567890', 'Calle 8', 'Ciudad H', 'Estado H', 'País W', 'Industria H', '123-4574', 'contacto@comp8.com', 'www.comp8.com', NULL, 1),
('Compañía 9', 'Comercial 9', 'NI', '9234567890', 'Calle 9', 'Ciudad I', 'Estado I', 'País W', 'Industria I', '123-4575', 'contacto@comp9.com', 'www.comp9.com', NULL, 1),
('Compañía 10', 'Comercial 10', 'OT', '1023456789', 'Calle 10', 'Ciudad J', 'Estado J', 'País V', 'Industria J', '123-4576', 'contacto@comp10.com', 'www.comp10.com', NULL, 1);


-- Populate User
INSERT INTO [User] (user_username, user_password, user_email, user_phone, user_is_admin, user_is_active)
VALUES
('usuario1', 'hashed_pass1', 'usuario1@mail.com', '111-2222', 1, 1),
('usuario2', 'hashed_pass2', 'usuario2@mail.com', '111-2223', 0, 1),
('usuario3', 'hashed_pass3', 'usuario3@mail.com', '111-2224', 0, 1),
('usuario4', 'hashed_pass4', 'usuario4@mail.com', '111-2225', 1, 1),
('usuario5', 'hashed_pass5', 'usuario5@mail.com', '111-2226', 0, 1),
('usuario6', 'hashed_pass6', 'usuario6@mail.com', '111-2227', 0, 0),
('usuario7', 'hashed_pass7', 'usuario7@mail.com', '111-2228', 1, 1),
('usuario8', 'hashed_pass8', 'usuario8@mail.com', '111-2229', 0, 1),
('usuario9', 'hashed_pass9', 'usuario9@mail.com', '111-2230', 1, 0),
('usuario10', 'hashed_pass10', 'usuario10@mail.com', '111-2231', 0, 1);

-- Populate Role
INSERT INTO Role (company_id, role_name, role_code, role_description, role_active)
VALUES 
(1, 'Administrador', 'ADMIN', 'Rol de administrador', 1),
(1, 'Usuario', 'USER', 'Rol de usuario estándar', 1),
(2, 'Gerente', 'MANAGER', 'Rol de gerente con permisos superiores', 1),
(2, 'Asistente', 'ASSISTANT', 'Rol de asistente con permisos limitados', 1),
(3, 'Superusuario', 'SUPERUSER', 'Rol con todos los permisos de la compañía', 1),
(3, 'Empleado', 'EMPLOYEE', 'Rol de empleado con permisos básicos', 1),
(4, 'Director', 'DIRECTOR', 'Rol de director con permisos altos', 1),
(4, 'Técnico', 'TECHNICIAN', 'Rol de técnico con permisos para operaciones específicas', 1),
(5, 'Administrador', 'ADMIN', 'Rol de administrador en una sucursal', 1),
(5, 'Vendedor', 'SALESPERSON', 'Rol de vendedor con permisos para gestionar ventas', 1);


-- Populate UserCompany
INSERT INTO UserCompany (user_id, company_id, useco_active)
VALUES 
(1, 1, 1),
(2, 1, 1),
(3, 2, 1),
(4, 2, 1),
(5, 3, 1),
(6, 3, 1),
(7, 4, 1),
(8, 4, 1),
(9, 5, 1),
(10, 5, 1);


-- Populate PermiRole
INSERT INTO PermiRole (role_id, permission_id, entitycatalog_id, perol_include, perol_record)
VALUES 
(1, 1, 1, 1, NULL),
(1, 2, 1, 1, NULL),
(1, 3, 1, 1, NULL),
(1, 4, 1, 1, NULL),
(1, 5, 1, 1, NULL),
(2, 1, 2, 1, NULL),
(2, 2, 2, 1, NULL),
(2, 3, 2, 1, NULL),
(2, 4, 2, 1, NULL),
(2, 5, 2, 1, NULL);

-- Populate PermiUser
INSERT INTO PermiUser (usercompany_id, permission_id, entitycatalog_id, peusr_include)
VALUES 
(1, 1, 1, 1),
(1, 2, 1, 1),
(1, 3, 1, 1),
(1, 4, 1, 1),
(1, 5, 1, 1),
(2, 1, 2, 1),
(2, 2, 2, 1),
(2, 3, 2, 1),
(2, 4, 2, 1),
(2, 5, 2, 1);


-- Populate CostCenter
INSERT INTO CostCenter (company_id, cosce_parent_id, cosce_code, cosce_name, cosce_description, cosce_budget, cosce_level, cosce_active)
VALUES 
(1, NULL, 'CC001', 'Centro de Costos 1', 'Principal', 50000, 1, 1),
(1, 1, 'CC002', 'Centro de Costos 2', 'Secundario', 20000, 2, 1),
(1, 1, 'CC003', 'Centro de Costos 3', 'Tercero', 15000, 2, 1),
(1, 1, 'CC004', 'Centro de Costos 4', 'Cuarto', 10000, 2, 1),
(1, 1, 'CC005', 'Centro de Costos 5', 'Quinto', 8000, 2, 1),
(2, NULL, 'CC006', 'Centro de Costos 6', 'Principal', 60000, 1, 1),
(2, 6, 'CC007', 'Centro de Costos 7', 'Secundario', 25000, 2, 1),
(2, 6, 'CC008', 'Centro de Costos 8', 'Tercero', 18000, 2, 1),
(2, 6, 'CC009', 'Centro de Costos 9', 'Cuarto', 12000, 2, 1),
(2, 6, 'CC010', 'Centro de Costos 10', 'Quinto', 9500, 2, 1);


-- Populate BranchOffice
INSERT INTO BranchOffice (company_id, broff_name, broff_code, broff_address, broff_city, broff_state, broff_country, broff_phone, broff_email, broff_active)
VALUES 
(1, 'Sucursal 1', 'BR001', 'Calle Sucursal 1', 'Ciudad Sucursal A', 'Estado Sucursal A', 'País X', '555-0001', 'sucursal1@comp1.com', 1),
(1, 'Sucursal 2', 'BR002', 'Calle Sucursal 2', 'Ciudad Sucursal B', 'Estado Sucursal B', 'País X', '555-0002', 'sucursal2@comp1.com', 1),
(1, 'Sucursal 3', 'BR003', 'Calle Sucursal 3', 'Ciudad Sucursal C', 'Estado Sucursal C', 'País X', '555-0003', 'sucursal3@comp1.com', 1),
(1, 'Sucursal 4', 'BR004', 'Calle Sucursal 4', 'Ciudad Sucursal D', 'Estado Sucursal D', 'País X', '555-0004', 'sucursal4@comp1.com', 1),
(1, 'Sucursal 5', 'BR005', 'Calle Sucursal 5', 'Ciudad Sucursal E', 'Estado Sucursal E', 'País X', '555-0005', 'sucursal5@comp1.com', 1),
(2, 'Sucursal 6', 'BR006', 'Calle Sucursal 6', 'Ciudad Sucursal F', 'Estado Sucursal F', 'País Y', '555-0006', 'sucursal6@comp2.com', 1),
(2, 'Sucursal 7', 'BR007', 'Calle Sucursal 7', 'Ciudad Sucursal G', 'Estado Sucursal G', 'País Y', '555-0007', 'sucursal7@comp2.com', 1),
(2, 'Sucursal 8', 'BR008', 'Calle Sucursal 8', 'Ciudad Sucursal H', 'Estado Sucursal H', 'País Y', '555-0008', 'sucursal8@comp2.com', 1),
(2, 'Sucursal 9', 'BR009', 'Calle Sucursal 9', 'Ciudad Sucursal I', 'Estado Sucursal I', 'País Y', '555-0009', 'sucursal9@comp2.com', 1),
(2, 'Sucursal 10', 'BR010', 'Calle Sucursal 10', 'Ciudad Sucursal J', 'Estado Sucursal J', 'País Y', '555-0010', 'sucursal10@comp2.com', 1);


-- Populate PermiUserRecord

select * from PermiUserRecord;

INSERT INTO PermiUserRecord (usercompany_id, permission_id, entitycatalog_id, peusr_record, peusr_include)
VALUES 
(1, 1, 2, 1001, 1),
(2, 2, 2, 1002, 1),
(3, 3, 2, 1003, 1),
(4, 4, 2, 1004, 1),
(5, 5, 2, 1005, 1),
(6, 6, 2, 1006, 1),
(7, 7, 2, 1007, 1),
(8, 8, 2, 1008, 1),
(9, 9, 2, 1009, 1),
(10, 10, 2, 1010, 1);

-- Populate PermiRoleRecord
INSERT INTO PermiRoleRecord (role_id, permission_id, entitycatalog_id, perrc_record, perrc_include)
VALUES 
(1, 1, 2, 1001, 1),
(1, 2, 2, 1002, 1),
(1, 3, 2, 1003, 1),
(2, 4, 2, 1004, 1),
(2, 5, 2, 1005, 1),
(2, 6, 2, 1006, 1),
(3, 7, 2, 1007, 1),
(3, 8, 2, 1008, 1),
(4, 9, 2, 1009, 1),
(4, 10, 2, 1010, 1);

select * from PermiRoleRecord;