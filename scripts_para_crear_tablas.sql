-- Create DataBase Permit_management_system

CREATE DATABASE Permit_management_system; -- Sentencia para la creaci�n de la base de datos que almacenar� todas las entidades.

-- Create EntityCatalog Table

CREATE TABLE EntityCatalog (
    -- Primary Key
    id_entit INT IDENTITY(1,1) PRIMARY KEY,                    -- Identificador �nico para el elemento del cat�logo de entidades

    -- Entity Information
    entit_name NVARCHAR(255) NOT NULL UNIQUE,                  -- Nombre del modelo Django asociado
    entit_descrip NVARCHAR(255) NOT NULL,                      -- Descripci�n del elemento del cat�logo de entidades

    -- Status
    entit_active BIT NOT NULL DEFAULT 1,                       -- Indica si el elemento del cat�logo est� activo (1) o inactivo (0)

    -- Configuration
    entit_config NVARCHAR(MAX) NULL                           -- Configuraci�n adicional para el elemento del cat�logo
);


--Modelos Implementados

-- Create Company Table
CREATE TABLE Company (
    -- Primary Key
    id_compa BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para la compa��a

    -- Company Information
    compa_name NVARCHAR(255) NOT NULL,                        -- Nombre legal completo de la compa��a
    compa_tradename NVARCHAR(255) NOT NULL,                   -- Nombre comercial o marca de la compa��a

    -- Document Information
    compa_doctype NVARCHAR(2) NOT NULL                        -- Tipo de documento de identificaci�n de la compa��a
        CONSTRAINT CK_Company_DocType 
        CHECK (compa_doctype IN ('NI', 'CC', 'CE', 'PP', 'OT')),
    compa_docnum NVARCHAR(255) NOT NULL,                      -- N�mero de identificaci�n fiscal o documento legal de la compa��a

    -- Location Information
    compa_address NVARCHAR(255) NOT NULL,                     -- Direcci�n f�sica de la compa��a
    compa_city NVARCHAR(255) NOT NULL,                        -- Ciudad donde est� ubicada la compa��a
    compa_state NVARCHAR(255) NOT NULL,                       -- Departamento o estado donde est� ubicada la compa��a
    compa_country NVARCHAR(255) NOT NULL,                     -- Pa�s donde est� ubicada la compa��a

    -- Contact Information
    compa_industry NVARCHAR(255) NOT NULL,                    -- Sector industrial al que pertenece la compa��a
    compa_phone NVARCHAR(255) NOT NULL,                       -- N�mero de tel�fono principal de la compa��a
    compa_email NVARCHAR(255) NOT NULL,                       -- Direcci�n de correo electr�nico principal de la compa��a
    compa_website NVARCHAR(255) NULL,                         -- Sitio web oficial de la compa��a

    -- Media
    compa_logo NVARCHAR(MAX) NULL,                           -- Logo oficial de la compa��a

    -- Status
    compa_active BIT NOT NULL DEFAULT 1                       -- Indica si la compa��a est� activa (1) o inactiva (0)
);


-- Create User Table
CREATE TABLE [User] (
    -- Primary Key
    id_user BIGINT IDENTITY(1,1) PRIMARY KEY,                 -- Identificador �nico para el usuario

    -- Authentication Information
    user_username NVARCHAR(255) NOT NULL,                     -- Nombre de usuario para iniciar sesi�n
    user_password NVARCHAR(255) NOT NULL,                     -- Contrase�a encriptada del usuario

    -- Contact Information
    user_email NVARCHAR(255) NOT NULL,                        -- Direcci�n de correo electr�nico del usuario
    user_phone NVARCHAR(255) NULL,                            -- N�mero de tel�fono del usuario

    -- Access Control
    user_is_admin BIT NOT NULL DEFAULT 0,                     -- Indica si el usuario es Administrador (1) o normal (0)
    user_is_active BIT NOT NULL DEFAULT 1,                    -- Indica si el usuario est� activo (1) o inactivo (0)

    -- Unique Constraints
    CONSTRAINT UQ_User_Username UNIQUE (user_username),
    CONSTRAINT UQ_User_Email UNIQUE (user_email)
);

-- Create Role Table
CREATE TABLE Role (
    -- Primary Key
    id_role BIGINT IDENTITY(1,1) PRIMARY KEY,                 -- Identificador �nico para el rol

    -- Foreign Keys
    company_id BIGINT NOT NULL                                -- Compa��a a la que pertenece este rol
        CONSTRAINT FK_Role_Company 
        FOREIGN KEY REFERENCES Company(id_compa),

    -- Basic Information
    role_name NVARCHAR(255) NOT NULL,                         -- Nombre descriptivo del rol
    role_code NVARCHAR(255) NOT NULL,                         -- C�digo del rol (agregado basado en unique_together)
    role_description NVARCHAR(MAX) NULL,                      -- Descripci�n detallada del rol y sus responsabilidades

    -- Status
    role_active BIT NOT NULL DEFAULT 1,                       -- Indica si el rol est� activo (1) o inactivo (0)

    -- Unique constraint for company and role code combination
    CONSTRAINT UQ_Company_RoleCode UNIQUE (company_id, role_code)
);

-- Create UserCompany Table
CREATE TABLE UserCompany (
    -- Primary Key
    id_useco BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para la relaci�n usuario-compa��a

    -- Foreign Keys
    user_id BIGINT NOT NULL                                   -- Usuario asociado a la compa��a
        CONSTRAINT FK_UserCompany_User 
        FOREIGN KEY REFERENCES [User](id_user),

    company_id BIGINT NOT NULL                                -- Compa��a asociada al usuario
        CONSTRAINT FK_UserCompany_Company 
        FOREIGN KEY REFERENCES Company(id_compa),

    -- Status
    useco_active BIT NOT NULL DEFAULT 1,                      -- Indica si la relaci�n usuario-compa��a est� activa (1) o inactiva (0)

    -- Unique constraint for user and company combination
    CONSTRAINT UQ_User_Company UNIQUE (user_id, company_id)
);

-- Create Permission Table
CREATE TABLE Permission (
    -- Primary Key
    id_permi BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el permiso

    -- Basic Information
    name NVARCHAR(255) NOT NULL,                              -- Nombre descriptivo del permiso
    description NVARCHAR(MAX) NULL,                           -- Descripci�n detallada del permiso y su prop�sito

    -- CRUD Permissions
    can_create BIT NOT NULL DEFAULT 0,                        -- Permite crear nuevos registros
    can_read BIT NOT NULL DEFAULT 0,                          -- Permite ver registros existentes
    can_update BIT NOT NULL DEFAULT 0,                        -- Permite modificar registros existentes
    can_delete BIT NOT NULL DEFAULT 0,                        -- Permite eliminar registros existentes

    -- Data Transfer Permissions
    can_import BIT NOT NULL DEFAULT 0,                        -- Permite importar datos masivamente
    can_export BIT NOT NULL DEFAULT 0                         -- Permite exportar datos del sistema
);




-- Create PermiRole Table
CREATE TABLE PermiRole (
    -- Primary Key
    id_perol BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el permiso de rol

    -- Foreign Keys
    role_id BIGINT NOT NULL                                   -- Rol al que se asigna el permiso
        CONSTRAINT FK_PermiRole_Role 
        FOREIGN KEY REFERENCES Role(id_role),

    permission_id BIGINT NOT NULL                             -- Permiso asignado al rol
        CONSTRAINT FK_PermiRole_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),

    entitycatalog_id INT NOT NULL                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiRole_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),

    -- Permission Configuration
    perol_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el rol
    perol_record BIGINT NULL,                                 -- Campo mencionado en unique_together pero no en el modelo

    -- Unique constraint for role, permission, entity catalog, and record combination
    CONSTRAINT UQ_Role_Permission_Entity_Record  
        UNIQUE (role_id, permission_id, entitycatalog_id, perol_record)
);


-- Create PermiRoleRecord Table
CREATE TABLE PermiRoleRecord (
    -- Primary Key
    id_perrc BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el permiso de rol por registro

    -- Foreign Keys
    role_id BIGINT NOT NULL                                   -- Rol al que se asigna el permiso
        CONSTRAINT FK_PermiRoleRecord_Role 
        FOREIGN KEY REFERENCES Role(id_role),

    permission_id BIGINT NOT NULL                             -- Permiso asignado al rol
        CONSTRAINT FK_PermiRoleRecord_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),

    entitycatalog_id INT NOT NULL                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiRoleRecord_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),

    -- Record Specific Information
    perrc_record BIGINT NOT NULL,                             -- Identificador del registro espec�fico al que se aplica el permiso

    -- Permission Configuration
    perrc_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el rol y registro

    -- Unique constraint for role, permission, entity catalog and record combination
    CONSTRAINT UQ_Role_Permission_Entity_Record_PermiRoleRecord  
        UNIQUE (role_id, permission_id, entitycatalog_id, perrc_record)
);




-- Create PermiUser Table

CREATE TABLE PermiUser (
    -- Primary Key
    id_peusr BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el permiso de usuario

    -- Foreign Keys
    usercompany_id BIGINT NOT NULL                            -- Relaci�n usuario-compa��a a la que se asigna el permiso
        CONSTRAINT FK_PermiUser_UserCompany 
        FOREIGN KEY REFERENCES UserCompany(id_useco),

    permission_id BIGINT NOT NULL                             -- Permiso asignado al usuario
        CONSTRAINT FK_PermiUser_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),

    entitycatalog_id INT NOT NULL                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiUser_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),

    -- Permission Configuration
    peusr_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el usuario

    -- Unique constraint for user-company, permission and entity catalog combination
    CONSTRAINT UQ_UserCompany_Permission_Entity 
        UNIQUE (usercompany_id, permission_id, entitycatalog_id)
);



-- Create PermiUserRecord Table
CREATE TABLE PermiUserRecord (
    -- Primary Key
    id_peusr BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el permiso de usuario

    -- Foreign Keys
    usercompany_id BIGINT NOT NULL                            -- Relaci�n usuario-compa��a a la que se asigna el permiso
        CONSTRAINT FK_PermiUserRecord_UserCompany 
        FOREIGN KEY REFERENCES UserCompany(id_useco),

    permission_id BIGINT NOT NULL                             -- Permiso asignado al usuario
        CONSTRAINT FK_PermiUserRecord_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),

    entitycatalog_id INT NOT NULL                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiUserRecord_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),

    -- Record Specific Information
    peusr_record BIGINT NOT NULL,                             -- Identificador del registro espec�fico de la entidad al que aplica el permiso

    -- Permission Configuration
    peusr_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el usuario

    -- Unique constraint for user-company, permission, entity catalog and record combination
    CONSTRAINT UQ_UserCompany_Permission_Entity_Record 
        UNIQUE (usercompany_id, permission_id, entitycatalog_id, peusr_record)
);







--- Entidades Para Pruebas

-- Create CostCenter Table
CREATE TABLE CostCenter (
    -- Primary Key
    id_cosce BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el centro de costo

    -- Foreign Keys
    company_id BIGINT NOT NULL                                -- Compa��a a la que pertenece este centro de costo
        CONSTRAINT FK_CostCenter_Company 
        FOREIGN KEY REFERENCES Company(id_compa),

    cosce_parent_id BIGINT NULL                               -- Centro de costo superior en la jerarqu�a organizacional
        CONSTRAINT FK_CostCenter_Parent 
        FOREIGN KEY REFERENCES CostCenter(id_cosce),

    -- Basic Information
    cosce_code NVARCHAR(255) NOT NULL,                        -- C�digo �nico que identifica el centro de costo
    cosce_name NVARCHAR(255) NOT NULL,                        -- Nombre descriptivo del centro de costo
    cosce_description NVARCHAR(MAX) NULL,                     -- Descripci�n detallada del centro de costo y su prop�sito

    -- Financial Information
    cosce_budget DECIMAL(15,2) NOT NULL DEFAULT 0,            -- Presupuesto asignado al centro de costo

    -- Hierarchical Information
    cosce_level SMALLINT NOT NULL DEFAULT 1                   -- Nivel en la jerarqu�a de centros de costo (1 para nivel superior)
        CONSTRAINT CK_CostCenter_Level 
        CHECK (cosce_level > 0),

    -- Status
    cosce_active BIT NOT NULL DEFAULT 1,                      -- Indica si el centro de costo est� activo (1) o inactivo (0)

    -- Unique constraint for company and cost center code combination
    CONSTRAINT UQ_Company_CostCenterCode UNIQUE (company_id, cosce_code)
);



-- Create BranchOffice Table
CREATE TABLE BranchOffice (
    -- Primary Key
    id_broff BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para la sucursal

    -- Company Reference
    company_id BIGINT NOT NULL                                -- Compa��a a la que pertenece esta sucursal
        CONSTRAINT FK_BranchOffice_Company 
        FOREIGN KEY REFERENCES Company(id_compa),

    -- Branch Office Information
    broff_name NVARCHAR(255) NOT NULL,                        -- Nombre descriptivo de la sucursal
    broff_code NVARCHAR(255) NOT NULL,                        -- C�digo �nico que identifica la sucursal dentro de la empresa

    -- Location Information
    broff_address NVARCHAR(255) NOT NULL,                     -- Direcci�n f�sica de la sucursal
    broff_city NVARCHAR(255) NOT NULL,                        -- Ciudad donde est� ubicada la sucursal
    broff_state NVARCHAR(255) NOT NULL,                       -- Departamento o estado donde est� ubicada la sucursal
    broff_country NVARCHAR(255) NOT NULL,                     -- Pa�s donde est� ubicada la sucursal

    -- Contact Information
    broff_phone NVARCHAR(255) NOT NULL,                       -- N�mero de tel�fono de la sucursal
    broff_email NVARCHAR(255) NOT NULL,                       -- Direcci�n de correo electr�nico de la sucursal

    -- Status
    broff_active BIT NOT NULL DEFAULT 1,                      -- Indica si la sucursal est� activa (1) o inactiva (0)

    -- Unique constraint for company and branch code combination
    CONSTRAINT UQ_Company_BranchCode UNIQUE (company_id, broff_code)
);








select * from Role