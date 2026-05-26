/******************************************************************************************************************/
/* DROP FOREIGN KEYS */

IF EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FkUserRoleUser'
      AND parent_object_id = OBJECT_ID('[UserManagement].[UserRole]'))
ALTER TABLE [UserManagement].[UserRole] DROP CONSTRAINT [FkUserRoleUser];
GO


/******************************************************************************************************************/
/* DROP UNIQUE INDEXES */

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UxUserManagementUser'
      AND object_id = OBJECT_ID('[UserManagement].[User]'))
DROP INDEX [UxUserManagementUser] ON [UserManagement].[User];
GO

/******************************************************************************************************************/
/* DROP TABLE */

DROP TABLE IF EXISTS [UserManagement].[User];
GO

/******************************************************************************************************************/
/* CREATE TABLE */

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [UserManagement].[User]
(
    [Id]              INT              IDENTITY(1,1) NOT NULL,
    [Email]           VARCHAR(200)     NOT NULL,
    [FirstName]       VARCHAR(200)     NOT NULL,
    [LastName]        VARCHAR(200)     NOT NULL,
    [LastChangedUser] VARCHAR(100)     NOT NULL,
    [LastChangedDate] DATETIME         NOT NULL CONSTRAINT [DfUserManagementUserLastChangedDate] DEFAULT (GETDATE()),

    CONSTRAINT [PkUserManagementUser] PRIMARY KEY CLUSTERED
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

CREATE UNIQUE NONCLUSTERED INDEX [UxUserManagementUser] ON [UserManagement].[User]
(
    [Email] ASC
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

