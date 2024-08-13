-- Use master
USE master;
GO

-- Use database
USE [gate-master];
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