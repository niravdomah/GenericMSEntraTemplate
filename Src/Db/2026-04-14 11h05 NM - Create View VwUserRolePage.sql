/******************************************************************************************************************/
/* DROP VIEWS */

DROP VIEW IF EXISTS [UserManagement].[VwUserRolePage];
GO

/******************************************************************************************************************/
/* CREATE VIEWS */

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE VIEW [UserManagement].[VwUserRolePage]
AS
SELECT
    [User].Id          AS UserId,
    [User].Email,
    [User].FirstName,
    [User].LastName,
    [Role].Id          AS RoleId,
    [Role].[Name]      AS RoleName,
    Page.Id            AS PageId,
    Page.[Name]        AS PageName
FROM
    [UserManagement].[User]
INNER JOIN
    [UserManagement].[UserRole] ON UserRole.UserId = [User].Id
INNER JOIN
    [UserManagement].[Role] ON [Role].Id = UserRole.RoleId
INNER JOIN
    [UserManagement].[RolePage] ON RolePage.RoleId = [Role].Id
INNER JOIN
    [UserManagement].[Page] ON Page.Id = RolePage.PageId
GO
