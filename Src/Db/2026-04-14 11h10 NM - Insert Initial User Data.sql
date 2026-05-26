/******************************************************************************************************************/
/* INSERT Initial User DATA */
/******************************************************************************************************************/

--UserManagement.Page

SET IDENTITY_INSERT [UserManagement].[Page] ON
IF NOT EXISTS (SELECT 1 FROM [UserManagement].[Page])
	INSERT INTO [UserManagement].[Page] ([Id],[Name], [Route], [LastChangedUser], [LastChangedDate])
VALUES
    (1,		'LandingPage',			'/',                            'System', GETDATE()),
    (2,		'Login',				'/login',                       'System', GETDATE()),
    (3,		'Unauthorized',			'/unauthorized',                'System', GETDATE());
GO
SET IDENTITY_INSERT [UserManagement].[Page] OFF

--UserManagement.Role
IF NOT EXISTS (SELECT 1 FROM [UserManagement].[Role])
	INSERT INTO [UserManagement].[Role] 
		([Name], [LastChangedUser]) 
	VALUES ('Administrator', 'System')
GO


--UserManagement.RolePage 
DECLARE @AdminRoleId INT = (SELECT [Id] FROM [UserManagement].[Role] WHERE [Name] = 'Administrator')

INSERT INTO [UserManagement].[RolePage] 
    ([RoleId], [PageId], [LastChangedUser])
SELECT
    @AdminRoleId,
    [Page].[Id],
    'System'
FROM
    [UserManagement].[Page]
WHERE
    NOT EXISTS (
        SELECT 1 
        FROM [UserManagement].[RolePage] 
        WHERE [RolePage].[RoleId] = @AdminRoleId 
          AND [RolePage].[PageId] = [Page].[Id]
    )
GO


--UserManagement.User
IF NOT EXISTS (SELECT 1 FROM [UserManagement].[User] WHERE [Email] = 'admin@digiata.com')
	INSERT INTO [UserManagement].[User] 
		([Email], [FirstName], [LastName], [LastChangedUser]) 
	VALUES ('admin@digiata.com', 'AdminUser', '', 'System')
GO


--UserManagement.UserRole
DECLARE @AdminRoleId INT = (SELECT [Id] FROM [UserManagement].[Role] WHERE [Name] = 'Administrator')
DECLARE @UserId INT = (SELECT [Id] FROM [UserManagement].[User] WHERE Email = 'admin@digiata.com')

IF NOT EXISTS (SELECT 1 FROM [UserManagement].[UserRole] WHERE [UserId] = @UserId AND [RoleId] = @AdminRoleId)
	INSERT INTO [UserManagement].[UserRole] 
		([UserId], [RoleId], [LastChangedUser]) 
	VALUES 
		(@UserId, @AdminRoleId, 'System')
GO 

