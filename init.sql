-- Create bd gate-master
CREATE DATABASE [gate-master];
GO

-- Use bd gate-master
USE [gate-master];
GO

CREATE TABLE [tbl_Module] (
  [module_id] BIGINT PRIMARY KEY,
  [name] BIGINT,
  [active] BOOLEAN,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_User_history] (
  [history_number] INT PRIMARY KEY IDENTITY(1, 1),
  [user_id] uniqueidentifier,
  [username] VARCHAR(20),
  [first_name] VARCHAR(20),
  [last_name] VARCHAR(20),
  [password] VARCHAR(250),
  [email] VARCHAR(60),
  [active] BOOLEAN,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_Audit_User] (
  [histoy_id] INT PRIMARY KEY IDENTITY(1, 1),
  [user_id] uniqueidentifier,
  [effective_date] DATE,
  [module_affected] BIGINT,
  [resourse_affected] BIGINT,
  [change_code] INT,
  [change_description] VARCHAR(100)
)
GO

CREATE TABLE [tbl_User] (
  [user_id] uniqueidentifier PRIMARY KEY DEFAULT 'newid()',
  [username] VARCHAR(20),
  [first_name] VARCHAR(20),
  [last_name] VARCHAR(20),
  [password] VARCHAR(250),
  [email] VARCHAR(60) UNIQUE,
  [active] BOOLEAN,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_Role] (
  [role_id] BIGINT PRIMARY KEY,
  [name] VARCHAR(20) UNIQUE,
  [active] BOOLEAN,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_Permission] (
  [permission_id] BIGINT PRIMARY KEY,
  [type] VARCHAR(10),
  [name] VARCHAR(20) UNIQUE,
  [active] BOOLEAN,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_Resource] (
  [resource_id] BIGINT PRIMARY KEY,
  [name] VARCHAR(30),
  [active] BOOLEAN,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_User_Module] (
  [user_module_id] BIGINT PRIMARY KEY,
  [user_id] uniqueidentifier,
  [module_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_User_Role] (
  [user_role_id] BIGINT PRIMARY KEY,
  [user_id] uniqueidentifier,
  [role_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_Role_Role] (
  [role_role_id] BIGINT PRIMARY KEY,
  [parent_role_id] BIGINT,
  [child_role_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_Role_Permission] (
  [role_permission_id] BIGINT PRIMARY KEY,
  [role_id] BIGINT,
  [permission_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_Permission_Resource] (
  [permission_resource_id] BIGINT PRIMARY KEY,
  [permission_id] BIGINT,
  [resource_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_Module_Resource] (
  [department_resource_id] BIGINT PRIMARY KEY,
  [department_id] BIGINT,
  [resource_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
)
GO

CREATE TABLE [tbl_Sessions] (
  [Session_id] integer PRIMARY KEY IDENTITY(1, 1),
  [User_id] uniqueidentifier,
  [Session_at] datetime DEFAULT 'getdate()',
  [Session_from] varchar(100),
  [Session_duration] timestamp
)
GO

ALTER TABLE [tbl_User_history] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id])
GO

ALTER TABLE [tbl_Audit_User] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id])
GO

ALTER TABLE [tbl_User_Module] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id])
GO

ALTER TABLE [tbl_User_Module] ADD FOREIGN KEY ([module_id]) REFERENCES [tbl_Module] ([module_id])
GO

ALTER TABLE [tbl_User_Role] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id])
GO

ALTER TABLE [tbl_User_Role] ADD FOREIGN KEY ([role_id]) REFERENCES [tbl_Role] ([role_id])
GO

ALTER TABLE [tbl_Role_Role] ADD FOREIGN KEY ([parent_role_id]) REFERENCES [tbl_Role] ([role_id])
GO

ALTER TABLE [tbl_Role_Role] ADD FOREIGN KEY ([child_role_id]) REFERENCES [tbl_Role] ([role_id])
GO

ALTER TABLE [tbl_Role_Permission] ADD FOREIGN KEY ([role_id]) REFERENCES [tbl_Role] ([role_id])
GO

ALTER TABLE [tbl_Role_Permission] ADD FOREIGN KEY ([permission_id]) REFERENCES [tbl_Permission] ([permission_id])
GO

ALTER TABLE [tbl_Permission_Resource] ADD FOREIGN KEY ([permission_id]) REFERENCES [tbl_Permission] ([permission_id])
GO

ALTER TABLE [tbl_Permission_Resource] ADD FOREIGN KEY ([resource_id]) REFERENCES [tbl_Resource] ([resource_id])
GO

ALTER TABLE [tbl_Module_Resource] ADD FOREIGN KEY ([department_id]) REFERENCES [tbl_Module] ([module_id])
GO

ALTER TABLE [tbl_Module_Resource] ADD FOREIGN KEY ([resource_id]) REFERENCES [tbl_Resource] ([resource_id])
GO

ALTER TABLE [tbl_Sessions] ADD FOREIGN KEY ([User_id]) REFERENCES [tbl_User] ([user_id])
GO