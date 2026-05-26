/******************************************************************************************************************/
/* DROP UNIQUE INDEXES */
IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UxUserManagementSession1'
      AND object_id = OBJECT_ID('[UserManagement].[Session]'))
DROP INDEX [UxUserManagementSession1] ON [UserManagement].[Session];
GO


/******************************************************************************************************************/
/* DROP TABLE */
DROP TABLE IF EXISTS [UserManagement].[Session];
GO


/******************************************************************************************************************/
/* CREATE TABLE */

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE TABLE [UserManagement].[Session]
(
    [Id]             INT              IDENTITY(1,1) NOT NULL,
    [UserId]         INT              NOT NULL,
    [IpAddress]      VARCHAR(45)      NOT NULL,
    [CreatedDate]    DATETIME         NOT NULL CONSTRAINT [DfUserManagementSessionCreatedDate] DEFAULT (GETUTCDATE()),
    [ExpiryDate]     DATETIME         NOT NULL,
    [LastAccessDate] DATETIME         NOT NULL,
    [Token]          VARCHAR(1000)    NOT NULL,
    CONSTRAINT [PkUserManagementSession] PRIMARY KEY CLUSTERED
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
CREATE UNIQUE NONCLUSTERED INDEX [UxUserManagementSession1] ON [UserManagement].[Session]
(
    [UserId] ASC,
    [Token] ASC
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
