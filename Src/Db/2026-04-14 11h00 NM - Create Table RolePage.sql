/******************************************************************************************************************/
/* DROP FOREIGN KEYS */

IF EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FkRolePageRole'
      AND parent_object_id = OBJECT_ID('[UserManagement].[RolePage]'))
ALTER TABLE [UserManagement].[RolePage] DROP CONSTRAINT [FkRolePageRole];
GO

IF EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FkRolePagePage'
      AND parent_object_id = OBJECT_ID('[UserManagement].[RolePage]'))
ALTER TABLE [UserManagement].[RolePage] DROP CONSTRAINT [FkRolePagePage];
GO

/******************************************************************************************************************/
/* DROP UNIQUE INDEXES */

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UxUserManagementRolePage'
      AND object_id = OBJECT_ID('[UserManagement].[RolePage]'))
DROP INDEX [UxUserManagementRolePage] ON [UserManagement].[RolePage];
GO

/******************************************************************************************************************/
/* DROP TABLE */

DROP TABLE IF EXISTS [UserManagement].[RolePage];
GO

/******************************************************************************************************************/
/* CREATE TABLE */

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [UserManagement].[RolePage]
(
    [Id]              INT              IDENTITY(1,1) NOT NULL,
    [RoleId]          INT              NOT NULL,
    [PageId]          INT              NOT NULL,
    [LastChangedUser] VARCHAR(100)     NOT NULL,
    [LastChangedDate] DATETIME         NOT NULL CONSTRAINT [DfUserManagementRolePageLastChangedDate] DEFAULT (GETDATE()),

    CONSTRAINT [PkUserManagementRolePage] PRIMARY KEY CLUSTERED
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

CREATE UNIQUE NONCLUSTERED INDEX [UxUserManagementRolePage] ON [UserManagement].[RolePage]
(
    [RoleId] ASC,
    [PageId] ASC
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

ALTER TABLE [UserManagement].[RolePage] WITH CHECK ADD CONSTRAINT [FkRolePageRole] FOREIGN KEY ([RoleId])
REFERENCES [UserManagement].[Role] ([Id]);
GO

ALTER TABLE [UserManagement].[RolePage] CHECK CONSTRAINT [FkRolePageRole];
GO

ALTER TABLE [UserManagement].[RolePage] WITH CHECK ADD CONSTRAINT [FkRolePagePage] FOREIGN KEY ([PageId])
REFERENCES [UserManagement].[Page] ([Id]);
GO

ALTER TABLE [UserManagement].[RolePage] CHECK CONSTRAINT [FkRolePagePage];
GO
