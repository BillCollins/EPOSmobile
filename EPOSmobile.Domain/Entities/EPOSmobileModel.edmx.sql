/*
Deployment script for EPOSmobile
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "EPOSmobile"
:setvar DefaultDataPath "c:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\"
:setvar DefaultLogPath "c:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\"

GO
:on error exit
GO
USE [master]
GO
IF (DB_ID(N'$(DatabaseName)') IS NOT NULL
    AND DATABASEPROPERTYEX(N'$(DatabaseName)','Status') <> N'ONLINE')
BEGIN
    RAISERROR(N'The state of the target database, %s, is not set to ONLINE. To deploy to this database, its state must be set to ONLINE.', 16, 127,N'$(DatabaseName)') WITH NOWAIT
    RETURN
END

GO

IF NOT EXISTS (SELECT 1 FROM [master].[dbo].[sysdatabases] WHERE [name] = N'$(DatabaseName)')
BEGIN
    RAISERROR(N'You cannot deploy this update script to target SUISEISEKI\SQLEXPRESS. The database for which this script was built, EPOSmobile, does not exist on this server.', 16, 127) WITH NOWAIT
    RETURN
END

GO

IF (@@servername != 'SUISEISEKI\SQLEXPRESS')
BEGIN
    RAISERROR(N'The server name in the build script %s does not match the name of the target server %s. Verify whether your database project settings are correct and whether your build script is up to date.', 16, 127,N'SUISEISEKI\SQLEXPRESS',@@servername) WITH NOWAIT
    RETURN
END

GO

IF CAST(DATABASEPROPERTY(N'$(DatabaseName)','IsReadOnly') as bit) = 1
BEGIN
    RAISERROR(N'You cannot deploy this update script because the database for which it was built, %s , is set to READ_ONLY.', 16, 127, N'$(DatabaseName)') WITH NOWAIT
    RETURN
END

GO
USE [$(DatabaseName)]
GO
/*
The column [dbo].[ProductGroups].[GroupName] on table [dbo].[ProductGroups] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue, you must add a default value to the column or mark it as allowing NULL values.
*/

IF EXISTS (select top 1 1 from [dbo].[ProductGroups])
    RAISERROR ('Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping FK_EmployeeAddress...';


GO
ALTER TABLE [dbo].[Addresses] DROP CONSTRAINT [FK_EmployeeAddress];


GO
PRINT N'Dropping FK_EmployeeSales...';


GO
ALTER TABLE [dbo].[Sales] DROP CONSTRAINT [FK_EmployeeSales];


GO
PRINT N'Dropping FK_ShiftEmployee...';


GO
ALTER TABLE [dbo].[Employees] DROP CONSTRAINT [FK_ShiftEmployee];


GO
PRINT N'Dropping FK_MenuProductGroup...';


GO
ALTER TABLE [dbo].[ProductGroups] DROP CONSTRAINT [FK_MenuProductGroup];


GO
PRINT N'Dropping FK_OrderOrderItem...';


GO
ALTER TABLE [dbo].[OrderItems] DROP CONSTRAINT [FK_OrderOrderItem];


GO
PRINT N'Dropping FK_ProductOrderItem...';


GO
ALTER TABLE [dbo].[OrderItems] DROP CONSTRAINT [FK_ProductOrderItem];


GO
PRINT N'Dropping FK_SalesOrder...';


GO
ALTER TABLE [dbo].[Orders] DROP CONSTRAINT [FK_SalesOrder];


GO
PRINT N'Dropping FK_TableOrder...';


GO
ALTER TABLE [dbo].[Orders] DROP CONSTRAINT [FK_TableOrder];


GO
PRINT N'Dropping FK_ProductGroupProduct...';


GO
ALTER TABLE [dbo].[Products] DROP CONSTRAINT [FK_ProductGroupProduct];


GO
PRINT N'Dropping FK_RoomTable...';


GO
ALTER TABLE [dbo].[Tables] DROP CONSTRAINT [FK_RoomTable];


GO
PRINT N'Dropping FK_ShiftSales...';


GO
ALTER TABLE [dbo].[Sales] DROP CONSTRAINT [FK_ShiftSales];


GO
PRINT N'Dropping FK_ShiftScheduleShift...';


GO
ALTER TABLE [dbo].[Shifts] DROP CONSTRAINT [FK_ShiftScheduleShift];


GO
PRINT N'Starting rebuilding table [dbo].[Addresses]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_Addresses] (
    [AddressID]           INT            IDENTITY (1, 1) NOT NULL,
    [Street]              NVARCHAR (MAX) NOT NULL,
    [StreetNumber]        NVARCHAR (MAX) NOT NULL,
    [PostalCode]          NVARCHAR (MAX) NOT NULL,
    [City]                NVARCHAR (MAX) NOT NULL,
    [Employee_EmployeeID] INT            NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_Addresses]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_Addresses] PRIMARY KEY CLUSTERED ([AddressID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[Addresses])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Addresses] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Addresses] ([AddressID], [Street], [StreetNumber], [PostalCode], [City], [Employee_EmployeeID])
        SELECT   [AddressID],
                 [Street],
                 [StreetNumber],
                 [PostalCode],
                 [City],
                 [Employee_EmployeeID]
        FROM     [dbo].[Addresses]
        ORDER BY [AddressID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Addresses] OFF;
    END

DROP TABLE [dbo].[Addresses];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Addresses]', N'Addresses';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_Addresses]', N'PK_Addresses', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[Addresses].[IX_FK_EmployeeAddress]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_EmployeeAddress]
    ON [dbo].[Addresses]([Employee_EmployeeID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Starting rebuilding table [dbo].[Employees]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_Employees] (
    [EmployeeID]      INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]       NVARCHAR (MAX) NOT NULL,
    [LastName]        NVARCHAR (MAX) NOT NULL,
    [TelephoneNumber] NVARCHAR (MAX) NOT NULL,
    [EmailAddress]    NVARCHAR (MAX) NOT NULL,
    [EmployeeNumber]  NVARCHAR (MAX) NOT NULL,
    [Shift_ShiftID]   INT            NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_Employees]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_Employees] PRIMARY KEY CLUSTERED ([EmployeeID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[Employees])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Employees] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Employees] ([EmployeeID], [FirstName], [LastName], [TelephoneNumber], [EmailAddress], [EmployeeNumber], [Shift_ShiftID])
        SELECT   [EmployeeID],
                 [FirstName],
                 [LastName],
                 [TelephoneNumber],
                 [EmailAddress],
                 [EmployeeNumber],
                 [Shift_ShiftID]
        FROM     [dbo].[Employees]
        ORDER BY [EmployeeID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Employees] OFF;
    END

DROP TABLE [dbo].[Employees];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Employees]', N'Employees';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_Employees]', N'PK_Employees', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[Employees].[IX_FK_ShiftEmployee]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_ShiftEmployee]
    ON [dbo].[Employees]([Shift_ShiftID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Starting rebuilding table [dbo].[Menus]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_Menus] (
    [MenuID]      INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (MAX) NOT NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    [IsActive]    BIT            NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_Menus]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_Menus] PRIMARY KEY CLUSTERED ([MenuID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[Menus])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Menus] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Menus] ([MenuID], [Name], [Description], [IsActive])
        SELECT   [MenuID],
                 [Name],
                 [Description],
                 [IsActive]
        FROM     [dbo].[Menus]
        ORDER BY [MenuID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Menus] OFF;
    END

DROP TABLE [dbo].[Menus];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Menus]', N'Menus';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_Menus]', N'PK_Menus', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Starting rebuilding table [dbo].[OrderItems]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_OrderItems] (
    [OrderItemID]       INT IDENTITY (1, 1) NOT NULL,
    [Quantity]          INT NOT NULL,
    [Order_OrderID]     INT NOT NULL,
    [Product_ProductID] INT NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_OrderItems]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_OrderItems] PRIMARY KEY CLUSTERED ([OrderItemID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[OrderItems])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_OrderItems] ON;
        INSERT INTO [dbo].[tmp_ms_xx_OrderItems] ([OrderItemID], [Quantity], [Order_OrderID], [Product_ProductID])
        SELECT   [OrderItemID],
                 [Quantity],
                 [Order_OrderID],
                 [Product_ProductID]
        FROM     [dbo].[OrderItems]
        ORDER BY [OrderItemID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_OrderItems] OFF;
    END

DROP TABLE [dbo].[OrderItems];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_OrderItems]', N'OrderItems';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_OrderItems]', N'PK_OrderItems', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[OrderItems].[IX_FK_OrderOrderItem]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_OrderOrderItem]
    ON [dbo].[OrderItems]([Order_OrderID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Creating [dbo].[OrderItems].[IX_FK_ProductOrderItem]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_ProductOrderItem]
    ON [dbo].[OrderItems]([Product_ProductID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Starting rebuilding table [dbo].[Orders]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_Orders] (
    [OrderID]       INT IDENTITY (1, 1) NOT NULL,
    [Sale_SalesID]  INT NOT NULL,
    [Table_TableID] INT NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_Orders]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_Orders] PRIMARY KEY CLUSTERED ([OrderID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[Orders])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Orders] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Orders] ([OrderID], [Sale_SalesID], [Table_TableID])
        SELECT   [OrderID],
                 [Sale_SalesID],
                 [Table_TableID]
        FROM     [dbo].[Orders]
        ORDER BY [OrderID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Orders] OFF;
    END

DROP TABLE [dbo].[Orders];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Orders]', N'Orders';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_Orders]', N'PK_Orders', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[Orders].[IX_FK_SalesOrder]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_SalesOrder]
    ON [dbo].[Orders]([Sale_SalesID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Creating [dbo].[Orders].[IX_FK_TableOrder]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_TableOrder]
    ON [dbo].[Orders]([Table_TableID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Starting rebuilding table [dbo].[ProductGroups]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_ProductGroups] (
    [ProductGroupID] INT            IDENTITY (1, 1) NOT NULL,
    [GroupName]      NVARCHAR (MAX) NOT NULL,
    [Menu_MenuID]    INT            NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_ProductGroups]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_ProductGroups] PRIMARY KEY CLUSTERED ([ProductGroupID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[ProductGroups])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_ProductGroups] ON;
        INSERT INTO [dbo].[tmp_ms_xx_ProductGroups] ([ProductGroupID], [Menu_MenuID])
        SELECT   [ProductGroupID],
                 [Menu_MenuID]
        FROM     [dbo].[ProductGroups]
        ORDER BY [ProductGroupID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_ProductGroups] OFF;
    END

DROP TABLE [dbo].[ProductGroups];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_ProductGroups]', N'ProductGroups';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_ProductGroups]', N'PK_ProductGroups', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[ProductGroups].[IX_FK_MenuProductGroup]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_MenuProductGroup]
    ON [dbo].[ProductGroups]([Menu_MenuID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Starting rebuilding table [dbo].[Products]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_Products] (
    [ProductID]                   INT             IDENTITY (1, 1) NOT NULL,
    [Name]                        NVARCHAR (MAX)  NOT NULL,
    [Description]                 NVARCHAR (MAX)  NOT NULL,
    [Price]                       DECIMAL (18)    NOT NULL,
    [Picture]                     VARBINARY (MAX) NOT NULL,
    [IsActive]                    BIT             NOT NULL,
    [ProductGroup_ProductGroupID] INT             NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_Products]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_Products] PRIMARY KEY CLUSTERED ([ProductID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[Products])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Products] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Products] ([ProductID], [Name], [Description], [Price], [Picture], [IsActive], [ProductGroup_ProductGroupID])
        SELECT   [ProductID],
                 [Name],
                 [Description],
                 [Price],
                 [Picture],
                 [IsActive],
                 [ProductGroup_ProductGroupID]
        FROM     [dbo].[Products]
        ORDER BY [ProductID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Products] OFF;
    END

DROP TABLE [dbo].[Products];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Products]', N'Products';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_Products]', N'PK_Products', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[Products].[IX_FK_ProductGroupProduct]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_ProductGroupProduct]
    ON [dbo].[Products]([ProductGroup_ProductGroupID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Starting rebuilding table [dbo].[Rooms]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_Rooms] (
    [RoomID]     INT            IDENTITY (1, 1) NOT NULL,
    [RoomNumber] NVARCHAR (MAX) NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_Rooms]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_Rooms] PRIMARY KEY CLUSTERED ([RoomID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[Rooms])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Rooms] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Rooms] ([RoomID], [RoomNumber])
        SELECT   [RoomID],
                 [RoomNumber]
        FROM     [dbo].[Rooms]
        ORDER BY [RoomID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Rooms] OFF;
    END

DROP TABLE [dbo].[Rooms];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Rooms]', N'Rooms';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_Rooms]', N'PK_Rooms', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Starting rebuilding table [dbo].[Sales]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_Sales] (
    [SalesID]             INT IDENTITY (1, 1) NOT NULL,
    [Employee_EmployeeID] INT NOT NULL,
    [Shift_ShiftID]       INT NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_Sales]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_Sales] PRIMARY KEY CLUSTERED ([SalesID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[Sales])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Sales] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Sales] ([SalesID], [Employee_EmployeeID], [Shift_ShiftID])
        SELECT   [SalesID],
                 [Employee_EmployeeID],
                 [Shift_ShiftID]
        FROM     [dbo].[Sales]
        ORDER BY [SalesID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Sales] OFF;
    END

DROP TABLE [dbo].[Sales];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Sales]', N'Sales';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_Sales]', N'PK_Sales', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[Sales].[IX_FK_EmployeeSales]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_EmployeeSales]
    ON [dbo].[Sales]([Employee_EmployeeID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Creating [dbo].[Sales].[IX_FK_ShiftSales]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_ShiftSales]
    ON [dbo].[Sales]([Shift_ShiftID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Starting rebuilding table [dbo].[Shifts]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_Shifts] (
    [ShiftID]                       INT      IDENTITY (1, 1) NOT NULL,
    [StartTime]                     DATETIME NOT NULL,
    [EndTime]                       DATETIME NOT NULL,
    [ShiftSchedule_ShiftScheduleID] INT      NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_Shifts]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_Shifts] PRIMARY KEY CLUSTERED ([ShiftID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[Shifts])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Shifts] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Shifts] ([ShiftID], [StartTime], [EndTime], [ShiftSchedule_ShiftScheduleID])
        SELECT   [ShiftID],
                 [StartTime],
                 [EndTime],
                 [ShiftSchedule_ShiftScheduleID]
        FROM     [dbo].[Shifts]
        ORDER BY [ShiftID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Shifts] OFF;
    END

DROP TABLE [dbo].[Shifts];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Shifts]', N'Shifts';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_Shifts]', N'PK_Shifts', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[Shifts].[IX_FK_ShiftScheduleShift]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_ShiftScheduleShift]
    ON [dbo].[Shifts]([ShiftSchedule_ShiftScheduleID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Starting rebuilding table [dbo].[ShiftSchedules]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_ShiftSchedules] (
    [ShiftScheduleID] INT IDENTITY (1, 1) NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_ShiftSchedules]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_ShiftSchedules] PRIMARY KEY CLUSTERED ([ShiftScheduleID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[ShiftSchedules])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_ShiftSchedules] ON;
        INSERT INTO [dbo].[tmp_ms_xx_ShiftSchedules] ([ShiftScheduleID])
        SELECT   [ShiftScheduleID]
        FROM     [dbo].[ShiftSchedules]
        ORDER BY [ShiftScheduleID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_ShiftSchedules] OFF;
    END

DROP TABLE [dbo].[ShiftSchedules];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_ShiftSchedules]', N'ShiftSchedules';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_ShiftSchedules]', N'PK_ShiftSchedules', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Starting rebuilding table [dbo].[Tables]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

CREATE TABLE [dbo].[tmp_ms_xx_Tables] (
    [TableID]     INT            IDENTITY (1, 1) NOT NULL,
    [TableNumber] NVARCHAR (MAX) NOT NULL,
    [Room_RoomID] INT            NOT NULL
);

ALTER TABLE [dbo].[tmp_ms_xx_Tables]
    ADD CONSTRAINT [tmp_ms_xx_clusteredindex_PK_Tables] PRIMARY KEY CLUSTERED ([TableID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

IF EXISTS (SELECT TOP 1 1
           FROM   [dbo].[Tables])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Tables] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Tables] ([TableID], [TableNumber], [Room_RoomID])
        SELECT   [TableID],
                 [TableNumber],
                 [Room_RoomID]
        FROM     [dbo].[Tables]
        ORDER BY [TableID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Tables] OFF;
    END

DROP TABLE [dbo].[Tables];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Tables]', N'Tables';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_clusteredindex_PK_Tables]', N'PK_Tables', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[Tables].[IX_FK_RoomTable]...';


GO
CREATE NONCLUSTERED INDEX [IX_FK_RoomTable]
    ON [dbo].[Tables]([Room_RoomID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Creating FK_EmployeeAddress...';


GO
ALTER TABLE [dbo].[Addresses] WITH NOCHECK
    ADD CONSTRAINT [FK_EmployeeAddress] FOREIGN KEY ([Employee_EmployeeID]) REFERENCES [dbo].[Employees] ([EmployeeID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_EmployeeSales...';


GO
ALTER TABLE [dbo].[Sales] WITH NOCHECK
    ADD CONSTRAINT [FK_EmployeeSales] FOREIGN KEY ([Employee_EmployeeID]) REFERENCES [dbo].[Employees] ([EmployeeID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_ShiftEmployee...';


GO
ALTER TABLE [dbo].[Employees] WITH NOCHECK
    ADD CONSTRAINT [FK_ShiftEmployee] FOREIGN KEY ([Shift_ShiftID]) REFERENCES [dbo].[Shifts] ([ShiftID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_MenuProductGroup...';


GO
ALTER TABLE [dbo].[ProductGroups] WITH NOCHECK
    ADD CONSTRAINT [FK_MenuProductGroup] FOREIGN KEY ([Menu_MenuID]) REFERENCES [dbo].[Menus] ([MenuID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_OrderOrderItem...';


GO
ALTER TABLE [dbo].[OrderItems] WITH NOCHECK
    ADD CONSTRAINT [FK_OrderOrderItem] FOREIGN KEY ([Order_OrderID]) REFERENCES [dbo].[Orders] ([OrderID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_ProductOrderItem...';


GO
ALTER TABLE [dbo].[OrderItems] WITH NOCHECK
    ADD CONSTRAINT [FK_ProductOrderItem] FOREIGN KEY ([Product_ProductID]) REFERENCES [dbo].[Products] ([ProductID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_SalesOrder...';


GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK
    ADD CONSTRAINT [FK_SalesOrder] FOREIGN KEY ([Sale_SalesID]) REFERENCES [dbo].[Sales] ([SalesID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_TableOrder...';


GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK
    ADD CONSTRAINT [FK_TableOrder] FOREIGN KEY ([Table_TableID]) REFERENCES [dbo].[Tables] ([TableID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_ProductGroupProduct...';


GO
ALTER TABLE [dbo].[Products] WITH NOCHECK
    ADD CONSTRAINT [FK_ProductGroupProduct] FOREIGN KEY ([ProductGroup_ProductGroupID]) REFERENCES [dbo].[ProductGroups] ([ProductGroupID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_RoomTable...';


GO
ALTER TABLE [dbo].[Tables] WITH NOCHECK
    ADD CONSTRAINT [FK_RoomTable] FOREIGN KEY ([Room_RoomID]) REFERENCES [dbo].[Rooms] ([RoomID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_ShiftSales...';


GO
ALTER TABLE [dbo].[Sales] WITH NOCHECK
    ADD CONSTRAINT [FK_ShiftSales] FOREIGN KEY ([Shift_ShiftID]) REFERENCES [dbo].[Shifts] ([ShiftID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating FK_ShiftScheduleShift...';


GO
ALTER TABLE [dbo].[Shifts] WITH NOCHECK
    ADD CONSTRAINT [FK_ShiftScheduleShift] FOREIGN KEY ([ShiftSchedule_ShiftScheduleID]) REFERENCES [dbo].[ShiftSchedules] ([ShiftScheduleID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Addresses] WITH CHECK CHECK CONSTRAINT [FK_EmployeeAddress];

ALTER TABLE [dbo].[Sales] WITH CHECK CHECK CONSTRAINT [FK_EmployeeSales];

ALTER TABLE [dbo].[Employees] WITH CHECK CHECK CONSTRAINT [FK_ShiftEmployee];

ALTER TABLE [dbo].[ProductGroups] WITH CHECK CHECK CONSTRAINT [FK_MenuProductGroup];

ALTER TABLE [dbo].[OrderItems] WITH CHECK CHECK CONSTRAINT [FK_OrderOrderItem];

ALTER TABLE [dbo].[OrderItems] WITH CHECK CHECK CONSTRAINT [FK_ProductOrderItem];

ALTER TABLE [dbo].[Orders] WITH CHECK CHECK CONSTRAINT [FK_SalesOrder];

ALTER TABLE [dbo].[Orders] WITH CHECK CHECK CONSTRAINT [FK_TableOrder];

ALTER TABLE [dbo].[Products] WITH CHECK CHECK CONSTRAINT [FK_ProductGroupProduct];

ALTER TABLE [dbo].[Tables] WITH CHECK CHECK CONSTRAINT [FK_RoomTable];

ALTER TABLE [dbo].[Sales] WITH CHECK CHECK CONSTRAINT [FK_ShiftSales];

ALTER TABLE [dbo].[Shifts] WITH CHECK CHECK CONSTRAINT [FK_ShiftScheduleShift];


GO
