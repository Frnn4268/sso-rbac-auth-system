-- Drop database if it exists
USE master;
GO

DROP DATABASE IF EXISTS [gate-master];
GO

-- Create database
CREATE DATABASE [gate-master];
GO

-- Use database
USE [gate-master];
GO

-- Create tables
CREATE TABLE [tbl_App] (
  [app_id] BIGINT PRIMARY KEY,
  [app_name] VARCHAR(30),
  [app_description] VARCHAR(50),
  [app_version] VARCHAR(15),
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_Module] (
  [module_id] BIGINT PRIMARY KEY,
  [app_id] BIGINT,
  [name] VARCHAR(30),
  [active] BIT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_User_history] (
  [history_number] INT PRIMARY KEY IDENTITY(1, 1),
  [user_id] UNIQUEIDENTIFIER,
  [allow] BIT,
  [username] VARCHAR(20),
  [first_name] VARCHAR(20),
  [last_name] VARCHAR(20),
  [password] VARCHAR(250),
  [email] VARCHAR(60),
  [active] BIT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_Audit_User] (
  [histoy_id] INT PRIMARY KEY IDENTITY(1, 1),
  [user_id] UNIQUEIDENTIFIER,
  [effective_date] DATE,
  [module_affected] BIGINT,
  [resourse_affected] BIGINT,
  [change_code] INT,
  [change_description] VARCHAR(100)
);
GO

CREATE TABLE [tbl_User] (
  [user_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
  [allow] BIT,
  [username] VARCHAR(20),
  [first_name] VARCHAR(20),
  [last_name] VARCHAR(20),
  [password] VARCHAR(250),
  [email] VARCHAR(60) UNIQUE,
  [active] BIT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_Role] (
  [role_id] BIGINT PRIMARY KEY,
  [name] VARCHAR(20) UNIQUE,
  [active] BIT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_Permission] (
  [permission_id] BIGINT PRIMARY KEY,
  [type] VARCHAR(10),
  [name] VARCHAR(20) UNIQUE,
  [active] BIT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_Resource] (
  [resource_id] BIGINT PRIMARY KEY,
  [name] VARCHAR(30),
  [active] BIT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_User_App] (
  [user_app_id] BIGINT PRIMARY KEY,
  [user_id] UNIQUEIDENTIFIER,
  [app_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_User_Role] (
  [user_role_id] BIGINT PRIMARY KEY,
  [user_id] UNIQUEIDENTIFIER,
  [role_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_Role_Role] (
  [role_role_id] BIGINT PRIMARY KEY,
  [parent_role_id] BIGINT,
  [child_role_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_Role_Permission] (
  [role_permission_id] BIGINT PRIMARY KEY,
  [role_id] BIGINT,
  [permission_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_Permission_Resource] (
  [permission_resource_id] BIGINT PRIMARY KEY,
  [permission_id] BIGINT,
  [resource_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_Module_Resource] (
  [department_resource_id] BIGINT PRIMARY KEY,
  [department_id] BIGINT,
  [resource_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_Sessions] (
  [Session_id] INTEGER PRIMARY KEY IDENTITY(1, 1),
  [User_id] UNIQUEIDENTIFIER,
  [Session_at] DATETIME DEFAULT GETDATE(),
  [Session_from] VARCHAR(100),
  [Session_duration] TIMESTAMP,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

-- Add foreign keys
ALTER TABLE [tbl_Module] ADD FOREIGN KEY ([app_id]) REFERENCES [tbl_App] ([app_id])
GO

ALTER TABLE [tbl_User_history] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id])
GO

ALTER TABLE [tbl_Audit_User] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id])
GO

ALTER TABLE [tbl_User_App] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id])
GO

ALTER TABLE [tbl_User_App] ADD FOREIGN KEY ([app_id]) REFERENCES [tbl_App] ([app_id])
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