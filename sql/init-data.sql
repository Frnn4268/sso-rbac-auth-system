-- Use master
USE master;
GO

-- Use database
USE [gate-master];
GO

-- Insert data into tbl_App
INSERT INTO [tbl_App] (app_id, app_name, app_description, app_version, created_by, created_on, updated_by, updated_on)
VALUES (1, 'Gate', 'Gate Management System', '1.0', 'Admin', GETDATE(), 'Admin', GETDATE()),
       (2, 'Gate Master', 'Gate Master System', '1.0', 'Admin', GETDATE(), 'Admin', GETDATE()),
       (3, 'Gate Keeper', 'Gate Keeper System', '1.0', 'Admin', GETDATE(), 'Admin', GETDATE());

-- Insert data into tbl_Module
INSERT INTO [tbl_Module] (module_id, app_id, name, active, created_by, created_on, updated_by, updated_on)
VALUES (1, 1, 'CRM', 1, 'Admin', GETDATE(), 'Admin', GETDATE()),
       (2, 1, 'ERP', 1, 'Admin', GETDATE(), 'Admin', GETDATE()),
       (3, 1, 'HRM', 1, 'Admin', GETDATE(), 'Admin', GETDATE()),
       (4, 2, 'Inventory Management', 1, 'Admin', GETDATE(), 'Admin', GETDATE());
GO

-- Insert data into tbl_User
-- Create a temporary table to store the generated user IDs
DECLARE @UserIds TABLE (user_id uniqueidentifier);

-- Insert data and store the generated IDs
INSERT INTO [tbl_User] (username, first_name, last_name, password, email, active, created_by, created_on)
OUTPUT INSERTED.user_id INTO @UserIds -- Save the generated user IDs
VALUES ('jdoe', 'John', 'Doe', 'hashed_password', 'jdoe@example.com', 1, 'Admin', GETDATE()),
       ('asmith', 'Alice', 'Smith', 'hashed_password', 'asmith@example.com', 1, 'Admin', GETDATE());

-- Insert data into tbl_User_history
INSERT INTO [tbl_User_history] (user_id, allow, username, first_name, last_name, password, email, active, created_by, created_on, updated_by, updated_on)
SELECT user_id, allow, username, first_name, last_name, password, email, active, created_by, created_on, updated_by, updated_on
FROM [tbl_User];

-- Insert data into tbl_Audit_User
INSERT INTO [tbl_Audit_User] (user_id, effective_date, module_affected, resourse_affected, change_code, change_description)
SELECT TOP 1 user_id, GETDATE(), 1, 101, 200, 'User Login' FROM [tbl_User];

-- Insert data into tbl_Role
INSERT INTO [tbl_Role] (role_id, name, active, created_by, created_on, updated_by, updated_on)
VALUES (1, 'Admin', 1, 'Admin', GETDATE(), 'Admin', GETDATE()),
       (2, 'User', 1, 'Admin', GETDATE(), 'Admin', GETDATE());

-- Insert data into tbl_Permission
INSERT INTO [tbl_Permission] (permission_id, type, name, active, created_by, created_on, updated_by, updated_on)
VALUES (1, 'Read', 'View Records', 1, 'Admin', GETDATE(), 'Admin', GETDATE()),
       (2, 'Write', 'Edit Records', 1, 'Admin', GETDATE(), 'Admin', GETDATE());

-- Insert data into tbl_Resource
INSERT INTO [tbl_Resource] (resource_id, name, active, created_by, created_on, updated_by, updated_on)
VALUES (101, 'Customer Data', 1, 'Admin', GETDATE(), 'Admin', GETDATE()),
       (102, 'Sales Data', 1, 'Admin', GETDATE(), 'Admin', GETDATE());

-- Insert data into tbl_User_App
INSERT INTO [tbl_User_App] (user_app_id, user_id, app_id, created_by, created_on, updated_by, updated_on)
SELECT 1, user_id, 1, 'Admin', GETDATE(), 'Admin', GETDATE() FROM @UserIds WHERE user_id = (SELECT MIN(user_id) FROM @UserIds);

-- Insert data into tbl_User_Role
INSERT INTO [tbl_User_Role] (user_role_id, user_id, role_id, created_by, created_on, updated_by, updated_on)
SELECT 1, user_id, 1, 'Admin', GETDATE(), 'Admin', GETDATE() FROM @UserIds WHERE user_id = (SELECT MIN(user_id) FROM @UserIds);

-- Insert data into tbl_Role_Role
INSERT INTO [tbl_Role_Role] (role_role_id, parent_role_id, child_role_id, created_by, created_on, updated_by, updated_on)
VALUES (1, 1, 2, 'Admin', GETDATE(), 'Admin', GETDATE());

-- Insert data into tbl_Role_Permission
INSERT INTO [tbl_Role_Permission] (role_permission_id, role_id, permission_id, created_by, created_on, updated_by, updated_on)
VALUES (1, 1, 1, 'Admin', GETDATE(), 'Admin', GETDATE()),
       (2, 1, 2, 'Admin', GETDATE(), 'Admin', GETDATE());

-- Insert data into tbl_Permission_Resource
INSERT INTO [tbl_Permission_Resource] (permission_resource_id, permission_id, resource_id, created_by, created_on, updated_by, updated_on)
VALUES (1, 1, 101, 'Admin', GETDATE(), 'Admin', GETDATE()),
       (2, 2, 102, 'Admin', GETDATE(), 'Admin', GETDATE());

-- Insert data into tbl_Module_Resource
INSERT INTO [tbl_Module_Resource] (department_resource_id, department_id, resource_id, created_by, created_on, updated_by, updated_on)
VALUES (1, 1, 101, 'Admin', GETDATE(), 'Admin', GETDATE()),
       (2, 2, 102, 'Admin', GETDATE(), 'Admin', GETDATE());

-- Insert data into tbl_Sessions
INSERT INTO [tbl_Sessions] (User_id, Session_from, created_by, created_on, updated_by, updated_on)
SELECT user_id, '127.0.0.1', 'Admin', CAST(GETDATE() AS DATE), 'Admin', GETDATE()
FROM @UserIds WHERE user_id = (SELECT MIN(user_id) FROM @UserIds);

GO

-- Create a view to display user permissions
CREATE VIEW vw_UserPermissions AS
SELECT 
    u.user_id,
    u.username,
    u.first_name,
    u.last_name,
    a.app_name,
    m.name AS module_name,
    r.name AS resource_name,
    p.name AS permission_name,
    p.type AS permission_type,
    rle.name AS role_name
FROM 
    tbl_User u
    INNER JOIN tbl_User_App ua ON u.user_id = ua.user_id
    INNER JOIN tbl_App a ON ua.app_id = a.app_id
    INNER JOIN tbl_Module m ON a.app_id = m.app_id
    INNER JOIN tbl_Module_Resource mr ON m.module_id = mr.department_id
    INNER JOIN tbl_Resource r ON mr.resource_id = r.resource_id
    INNER JOIN tbl_Permission_Resource pr ON r.resource_id = pr.resource_id
    INNER JOIN tbl_Permission p ON pr.permission_id = p.permission_id
    INNER JOIN tbl_Role_Permission rp ON p.permission_id = rp.permission_id
    INNER JOIN tbl_Role rle ON rp.role_id = rle.role_id
    INNER JOIN tbl_User_Role ur ON rle.role_id = ur.role_id AND ur.user_id = u.user_id
WHERE 
    u.active = 1 AND p.active = 1 AND r.active = 1 AND m.active = 1 AND rle.active = 1;
GO
