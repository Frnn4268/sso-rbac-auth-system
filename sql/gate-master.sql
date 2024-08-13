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
CREATE TABLE [tbl_Module] (
  [module_id] BIGINT PRIMARY KEY,
  [name] VARCHAR(255),
  [active] BIT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_User_history] (
  [history_number] INT PRIMARY KEY IDENTITY(1, 1),
  [user_id] uniqueidentifier,
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
  [user_id] uniqueidentifier,
  [effective_date] DATE,
  [module_affected] BIGINT,
  [resourse_affected] BIGINT,
  [change_code] INT,
  [change_description] VARCHAR(100)
);
GO

CREATE TABLE [tbl_User] (
  [user_id] uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
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

CREATE TABLE [tbl_User_Module] (
  [user_module_id] BIGINT PRIMARY KEY,
  [user_id] uniqueidentifier,
  [module_id] BIGINT,
  [created_by] VARCHAR(20),
  [created_on] DATE,
  [updated_by] VARCHAR(20),
  [updated_on] DATE
);
GO

CREATE TABLE [tbl_User_Role] (
  [user_role_id] BIGINT PRIMARY KEY,
  [user_id] uniqueidentifier,
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
  [Session_id] INT PRIMARY KEY IDENTITY(1, 1),
  [User_id] uniqueidentifier,
  [Session_at] DATETIME DEFAULT GETDATE(),
  [Session_from] VARCHAR(100),
  [Session_duration] INT
);
GO

-- Add foreign keys
ALTER TABLE [tbl_User_history] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id]);
GO

ALTER TABLE [tbl_Audit_User] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id]);
GO

ALTER TABLE [tbl_User_Module] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id]);
GO

ALTER TABLE [tbl_User_Module] ADD FOREIGN KEY ([module_id]) REFERENCES [tbl_Module] ([module_id]);
GO

ALTER TABLE [tbl_User_Role] ADD FOREIGN KEY ([user_id]) REFERENCES [tbl_User] ([user_id]);
GO

ALTER TABLE [tbl_User_Role] ADD FOREIGN KEY ([role_id]) REFERENCES [tbl_Role] ([role_id]);
GO

ALTER TABLE [tbl_Role_Role] ADD FOREIGN KEY ([parent_role_id]) REFERENCES [tbl_Role] ([role_id]);
GO

ALTER TABLE [tbl_Role_Role] ADD FOREIGN KEY ([child_role_id]) REFERENCES [tbl_Role] ([role_id]);
GO

ALTER TABLE [tbl_Role_Permission] ADD FOREIGN KEY ([role_id]) REFERENCES [tbl_Role] ([role_id]);
GO

ALTER TABLE [tbl_Role_Permission] ADD FOREIGN KEY ([permission_id]) REFERENCES [tbl_Permission] ([permission_id]);
GO

ALTER TABLE [tbl_Permission_Resource] ADD FOREIGN KEY ([permission_id]) REFERENCES [tbl_Permission] ([permission_id]);
GO

ALTER TABLE [tbl_Permission_Resource] ADD FOREIGN KEY ([resource_id]) REFERENCES [tbl_Resource] ([resource_id]);
GO

ALTER TABLE [tbl_Module_Resource] ADD FOREIGN KEY ([department_id]) REFERENCES [tbl_Module] ([module_id]);
GO

ALTER TABLE [tbl_Module_Resource] ADD FOREIGN KEY ([resource_id]) REFERENCES [tbl_Resource] ([resource_id]);
GO

ALTER TABLE [tbl_Sessions] ADD FOREIGN KEY ([User_id]) REFERENCES [tbl_User] ([user_id]);
GO

-- Insert data into tables

-- tbl_Module
INSERT INTO [tbl_Module] (module_id, name, active, created_by, created_on)
VALUES (1, 'CRM', 1, 'Admin', GETDATE()),
       (2, 'ERP', 1, 'Admin', GETDATE()),
       (3, 'HRM', 1, 'Admin', GETDATE()),
       (4, 'Inventory Management', 1, 'Admin', GETDATE());
GO

-- tbl_User
-- Create a temporary table to store the generated user IDs
DECLARE @UserIds TABLE (user_id uniqueidentifier);

-- Insert data and store the generated IDs
INSERT INTO [tbl_User] (username, first_name, last_name, password, email, active, created_by, created_on)
OUTPUT INSERTED.user_id INTO @UserIds -- Save the generated user IDs
VALUES ('jdoe', 'John', 'Doe', 'hashed_password', 'jdoe@example.com', 1, 'Admin', GETDATE()),
       ('asmith', 'Alice', 'Smith', 'hashed_password', 'asmith@example.com', 1, 'Admin', GETDATE());

-- tbl_User_history
INSERT INTO [tbl_User_history] (user_id, username, first_name, last_name, password, email, active, created_by, created_on)
SELECT user_id, username, first_name, last_name, password, email, active, created_by, created_on
FROM [tbl_User];

-- tbl_Audit_User
INSERT INTO [tbl_Audit_User] (user_id, effective_date, module_affected, resourse_affected, change_code, change_description)
SELECT TOP 1 user_id, GETDATE(), 1, 101, 200, 'User Login' FROM [tbl_User];

-- tbl_Role
INSERT INTO [tbl_Role] (role_id, name, active, created_by, created_on)
VALUES (1, 'Admin', 1, 'Admin', GETDATE()),
       (2, 'User', 1, 'Admin', GETDATE());

-- tbl_User_Module
INSERT INTO [tbl_User_Module] (user_module_id, user_id, module_id, created_by, created_on)
SELECT 1, user_id, 1, 'Admin', GETDATE() FROM @UserIds WHERE user_id = (SELECT MIN(user_id) FROM @UserIds);

-- tbl_User_Role
INSERT INTO [tbl_User_Role] (user_role_id, user_id, role_id, created_by, created_on)
SELECT 1, user_id, 1, 'Admin', GETDATE() FROM @UserIds WHERE user_id = (SELECT MIN(user_id) FROM @UserIds);

-- tbl_Role_Role
INSERT INTO [tbl_Role_Role] (role_role_id, parent_role_id, child_role_id, created_by, created_on)
VALUES (1, 1, 2, 'Admin', GETDATE());

-- tbl_Permission
INSERT INTO [tbl_Permission] (permission_id, type, name, active, created_by, created_on)
VALUES (1, 'Read', 'View Records', 1, 'Admin', GETDATE()),
       (2, 'Write', 'Edit Records', 1, 'Admin', GETDATE());

-- tbl_Resource
INSERT INTO [tbl_Resource] (resource_id, name, active, created_by, created_on)
VALUES (101, 'Customer Data', 1, 'Admin', GETDATE()),
       (102, 'Sales Data', 1, 'Admin', GETDATE());

-- tbl_Role_Permission
INSERT INTO [tbl_Role_Permission] (role_permission_id, role_id, permission_id, created_by, created_on)
VALUES (1, 1, 1, 'Admin', GETDATE()),
       (2, 1, 2, 'Admin', GETDATE());

-- tbl_Permission_Resource
INSERT INTO [tbl_Permission_Resource] (permission_resource_id, permission_id, resource_id, created_by, created_on)
VALUES (1, 1, 101, 'Admin', GETDATE()),
       (2, 2, 102, 'Admin', GETDATE());

-- tbl_Module_Resource
INSERT INTO [tbl_Module_Resource] (department_resource_id, department_id, resource_id, created_by, created_on)
VALUES (1, 1, 101, 'Admin', GETDATE()),
       (2, 2, 102, 'Admin', GETDATE());

-- tbl_Sessions
INSERT INTO [tbl_Sessions] (User_id, Session_from, Session_duration)
SELECT TOP 1 user_id, '127.0.0.1', 3600 FROM [tbl_User];
GO
