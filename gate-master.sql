-- Initial script to create the database and tables for the gate-master project

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

-- Insert data into tables
-- tbl_Module
INSERT INTO [tbl_Module] (module_id, name, active, created_by, created_on)
VALUES (1, 'CRM', 1, 'Admin', GETDATE()),
       (2, 'ERP', 1, 'Admin', GETDATE()),
       (3, 'HRM', 1, 'Admin', GETDATE()),
       (4, 'Inventory Management', 1, 'Admin', GETDATE());

-- tbl_User_history
INSERT INTO [tbl_User_history] (user_id, username, first_name, last_name, password, email, active, created_by, created_on)
VALUES (NEWID(), 'jdoe', 'John', 'Doe', 'hashed_password', 'jdoe@example.com', 1, 'Admin', GETDATE()),
       (NEWID(), 'asmith', 'Alice', 'Smith', 'hashed_password', 'asmith@example.com', 1, 'Admin', GETDATE());

-- tbl_Audit_User
INSERT INTO [tbl_Audit_User] (user_id, effective_date, module_affected, resourse_affected, change_code, change_description)
VALUES (NEWID(), GETDATE(), 1, 101, 200, 'User Login'),
       (NEWID(), GETDATE(), 2, 202, 201, 'Updated Customer Information');

-- tbl_User
INSERT INTO [tbl_User] (user_id, username, first_name, last_name, password, email, active, created_by, created_on)
VALUES (NEWID(), 'mjohnson', 'Michael', 'Johnson', 'hashed_password', 'mjohnson@company.com', 1, 'Admin', GETDATE()),
       (NEWID(), 'lwilson', 'Laura', 'Wilson', 'hashed_password', 'lwilson@company.com', 1, 'Admin', GETDATE());

-- tbl_Role
INSERT INTO [tbl_Role] (role_id, name, active, created_by, created_on)
VALUES (1, 'Admin', 1, 'System', GETDATE()),
       (2, 'Manager', 1, 'System', GETDATE()),
       (3, 'Employee', 1, 'System', GETDATE());

-- tbl_Permission
INSERT INTO [tbl_Permission] (permission_id, type, name, active, created_by, created_on)
VALUES (1, 'Read', 'View Reports', 1, 'Admin', GETDATE()),
       (2, 'Write', 'Edit Customer Data', 1, 'Admin', GETDATE()),
       (3, 'Delete', 'Remove Products', 1, 'Admin', GETDATE());

-- tbl_Resource
INSERT INTO [tbl_Resource] (resource_id, name, active, created_by, created_on)
VALUES (1, 'Customer Database', 1, 'Admin', GETDATE()),
       (2, 'Inventory System', 1, 'Admin', GETDATE()),
       (3, 'HR Records', 1, 'Admin', GETDATE());

-- tbl_User_Module
INSERT INTO [tbl_User_Module] (user_module_id, user_id, module_id, created_by, created_on)
VALUES (1, NEWID(), 1, 'Admin', GETDATE()),
       (2, NEWID(), 2, 'Admin', GETDATE());

-- tbl_User_Role
INSERT INTO [tbl_User_Role] (user_role_id, user_id, role_id, created_by, created_on)
VALUES (1, NEWID(), 1, 'Admin', GETDATE()),
       (2, NEWID(), 2, 'Manager', 'Admin', GETDATE());

-- tbl_Role_Role
INSERT INTO [tbl_Role_Role] (role_role_id, parent_role_id, child_role_id, created_by, created_on)
VALUES (1, 1, 2, 'Admin', GETDATE()),
       (2, 2, 3, 'Admin', GETDATE());

-- tbl_Role_Permission
INSERT INTO [tbl_Role_Permission] (role_permission_id, role_id, permission_id, created_by, created_on)
VALUES (1, 1, 1, 'Admin', GETDATE()),
       (2, 2, 2, 'Admin', GETDATE());

-- tbl_Permission_Resource
INSERT INTO [tbl_Module_Resource] (department_resource_id, department_id, resource_id, created_by, created_on)
VALUES (1, 1, 1, 'Admin', GETDATE()),
       (2, 2, 2, 'Admin', GETDATE());

-- tbl_Sessions
INSERT INTO [tbl_Sessions] (User_id, Session_at, Session_from, Session_duration)
VALUES (NEWID(), GETDATE(), '192.168.1.10', DEFAULT),
       (NEWID(), GETDATE(), '192.168.1.11', DEFAULT);
