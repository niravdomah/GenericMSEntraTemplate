/******************************************************************************************************************/
/* DROP FOREIGN KEYS */

IF EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FkUserRoleRole'
      AND parent_object_id = OBJECT_ID('[UserManagement].[UserRole]'))
ALTER TABLE [UserManagement].[UserRole] DROP CONSTRAINT [FkUserRoleRole];
GO

IF EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FkRolePageRole'
      AND parent_object_id = OBJECT_ID('[UserManagement].[RolePage]'))
ALTER TABLE [UserManagement].[RolePage] DROP CONSTRAINT [FkRolePageRole];
GO

/******************************************************************************************************************/
/* DROP UNIQUE INDEXES */

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UxUserManagementRole'
      AND object_id = OBJECT_ID('[UserManagement].[Role]'))
DROP INDEX [UxUserManagementRole] ON [UserManagement].[Role];
GO

/******************************************************************************************************************/
/* DROP TABLE */

DROP TABLE IF EXISTS [UserManagement].[Role];
GO

/******************************************************************************************************************/
/* CREATE TABLE */

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [UserManagement].[Role]
(
    [Id]              INT              IDENTITY(1,1) NOT NULL,
    [Name]            VARCHAR(200)     NOT NULL,
    [LastChangedUser] VARCHAR(100)     NOT NULL,
    [LastChangedDate] DATETIME         NOT NULL CONSTRAINT [DfUserManagementRoleLastChangedDate] DEFAULT (GETDATE()),

    CONSTRAINT [PkUserManagementRole] PRIMARY KEY CLUSTERED
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

CREATE UNIQUE NONCLUSTERED INDEX [UxUserManagementRole] ON [UserManagement].[Role]
(
    [Name] ASC
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
