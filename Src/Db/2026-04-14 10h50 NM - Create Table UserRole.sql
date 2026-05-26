/******************************************************************************************************************/
/* DROP FOREIGN KEYS */

IF EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FkUserRoleUser'
      AND parent_object_id = OBJECT_ID('[UserManagement].[UserRole]'))
ALTER TABLE [UserManagement].[UserRole] DROP CONSTRAINT [FkUserRoleUser];
GO

IF EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FkUserRoleRole'
      AND parent_object_id = OBJECT_ID('[UserManagement].[UserRole]'))
ALTER TABLE [UserManagement].[UserRole] DROP CONSTRAINT [FkUserRoleRole];
GO

/******************************************************************************************************************/
/* DROP UNIQUE INDEXES */

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UxUserManagementUserRole'
      AND object_id = OBJECT_ID('[UserManagement].[UserRole]'))
DROP INDEX [UxUserManagementUserRole] ON [UserManagement].[UserRole];
GO

/******************************************************************************************************************/
/* DROP TABLE */

DROP TABLE IF EXISTS [UserManagement].[UserRole];
GO

/******************************************************************************************************************/
/* CREATE TABLE */

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [UserManagement].[UserRole]
(
    [Id]              INT              IDENTITY(1,1) NOT NULL,
    [UserId]          INT              NOT NULL,
    [RoleId]          INT              NOT NULL,
    [LastChangedUser] VARCHAR(100)     NOT NULL,
    [LastChangedDate] DATETIME         NOT NULL CONSTRAINT [DfUserManagementUserRoleLastChangedDate] DEFAULT (GETDATE()),

    CONSTRAINT [PkUserManagementUserRole] PRIMARY KEY CLUSTERED
    (
        [Id] ASC
    ) WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        IGNORE_DUP_KEY = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON
    ) ON [PRIMARY]
) ON [PRIMARY];
GO

/******************************************************************************************************************/
/* CREATE INDEXES */

CREATE UNIQUE NONCLUSTERED INDEX [UxUserManagementUserRole] ON [UserManagement].[UserRole]
(
    [UserId] ASC,
    [RoleId] ASC
) WITH (
    PAD_INDEX = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB = OFF,
    IGNORE_DUP_KEY = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON,
    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
) ON [PRIMARY];
GO

/******************************************************************************************************************/
/* CREATE FOREIGN KEYS */

ALTER TABLE [UserManagement].[UserRole] WITH CHECK ADD CONSTRAINT [FkUserRoleUser] FOREIGN KEY ([UserId])
REFERENCES [UserManagement].[User] ([Id]);
GO

ALTER TABLE [UserManagement].[UserRole] CHECK CONSTRAINT [FkUserRoleUser];
GO

ALTER TABLE [UserManagement].[UserRole] WITH CHECK ADD CONSTRAINT [FkUserRoleRole] FOREIGN KEY ([RoleId])
REFERENCES [UserManagement].[Role] ([Id]);
GO

ALTER TABLE [UserManagement].[UserRole] CHECK CONSTRAINT [FkUserRoleRole];
GO
