
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, and Azure
-- --------------------------------------------------
-- Date Created: 11/25/2012 18:08:31
-- Generated from EDMX file: C:\Users\SchlemmerT\Documents\Visual Studio 2010\Projects\EPOSmobile\EPOSmobile.Domain\Entities\EPOSmobileModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [EPOSmobile];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_EmployeeAddress]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Addresses] DROP CONSTRAINT [FK_EmployeeAddress];
GO
IF OBJECT_ID(N'[dbo].[FK_EmployeeSales]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Sales] DROP CONSTRAINT [FK_EmployeeSales];
GO
IF OBJECT_ID(N'[dbo].[FK_MenuProductGroup]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ProductGroups] DROP CONSTRAINT [FK_MenuProductGroup];
GO
IF OBJECT_ID(N'[dbo].[FK_ProductGroupProduct]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Products] DROP CONSTRAINT [FK_ProductGroupProduct];
GO
IF OBJECT_ID(N'[dbo].[FK_ShiftSales]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Sales] DROP CONSTRAINT [FK_ShiftSales];
GO
IF OBJECT_ID(N'[dbo].[FK_ShiftScheduleShift]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Shifts] DROP CONSTRAINT [FK_ShiftScheduleShift];
GO
IF OBJECT_ID(N'[dbo].[FK_ShiftEmployee]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Employees] DROP CONSTRAINT [FK_ShiftEmployee];
GO
IF OBJECT_ID(N'[dbo].[FK_OrderOrderItem]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[OrderItems] DROP CONSTRAINT [FK_OrderOrderItem];
GO
IF OBJECT_ID(N'[dbo].[FK_ProductOrderItem]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[OrderItems] DROP CONSTRAINT [FK_ProductOrderItem];
GO
IF OBJECT_ID(N'[dbo].[FK_SalesOrder]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Orders] DROP CONSTRAINT [FK_SalesOrder];
GO
IF OBJECT_ID(N'[dbo].[FK_TableOrder]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Orders] DROP CONSTRAINT [FK_TableOrder];
GO
IF OBJECT_ID(N'[dbo].[FK_RoomTable]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Tables] DROP CONSTRAINT [FK_RoomTable];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[Products]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Products];
GO
IF OBJECT_ID(N'[dbo].[Menus]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Menus];
GO
IF OBJECT_ID(N'[dbo].[Employees]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Employees];
GO
IF OBJECT_ID(N'[dbo].[Addresses]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Addresses];
GO
IF OBJECT_ID(N'[dbo].[Sales]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Sales];
GO
IF OBJECT_ID(N'[dbo].[Shifts]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Shifts];
GO
IF OBJECT_ID(N'[dbo].[ProductGroups]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProductGroups];
GO
IF OBJECT_ID(N'[dbo].[ShiftSchedules]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ShiftSchedules];
GO
IF OBJECT_ID(N'[dbo].[Orders]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Orders];
GO
IF OBJECT_ID(N'[dbo].[OrderItems]', 'U') IS NOT NULL
    DROP TABLE [dbo].[OrderItems];
GO
IF OBJECT_ID(N'[dbo].[Rooms]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Rooms];
GO
IF OBJECT_ID(N'[dbo].[Tables]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Tables];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Products'
CREATE TABLE [dbo].[Products] (
    [ProductID] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [Description] nvarchar(max)  NOT NULL,
    [Price] decimal(18,0)  NOT NULL,
    [Picture] varbinary(max)  NOT NULL,
    [IsActive] bit  NOT NULL,
    [ProductGroup_ProductGroupID] int  NOT NULL
);
GO

-- Creating table 'Menus'
CREATE TABLE [dbo].[Menus] (
    [MenuID] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [Description] nvarchar(max)  NOT NULL,
    [IsActive] bit  NOT NULL
);
GO

-- Creating table 'Employees'
CREATE TABLE [dbo].[Employees] (
    [EmployeeID] int IDENTITY(1,1) NOT NULL,
    [FirstName] nvarchar(max)  NOT NULL,
    [LastName] nvarchar(max)  NOT NULL,
    [TelephoneNumber] nvarchar(max)  NOT NULL,
    [EmailAddress] nvarchar(max)  NOT NULL,
    [EmployeeNumber] nvarchar(max)  NOT NULL,
    [Shift_ShiftID] int  NOT NULL
);
GO

-- Creating table 'Addresses'
CREATE TABLE [dbo].[Addresses] (
    [AddressID] int IDENTITY(1,1) NOT NULL,
    [Street] nvarchar(max)  NOT NULL,
    [StreetNumber] nvarchar(max)  NOT NULL,
    [PostalCode] nvarchar(max)  NOT NULL,
    [City] nvarchar(max)  NOT NULL,
    [Employee_EmployeeID] int  NOT NULL
);
GO

-- Creating table 'Sales'
CREATE TABLE [dbo].[Sales] (
    [SalesID] int IDENTITY(1,1) NOT NULL,
    [Employee_EmployeeID] int  NOT NULL,
    [Shift_ShiftID] int  NOT NULL
);
GO

-- Creating table 'Shifts'
CREATE TABLE [dbo].[Shifts] (
    [ShiftID] int IDENTITY(1,1) NOT NULL,
    [StartTime] datetime  NOT NULL,
    [EndTime] datetime  NOT NULL,
    [ShiftSchedule_ShiftScheduleID] int  NOT NULL
);
GO

-- Creating table 'ProductGroups'
CREATE TABLE [dbo].[ProductGroups] (
    [ProductGroupID] int IDENTITY(1,1) NOT NULL,
    [GroupName] nvarchar(max)  NOT NULL,
    [Menu_MenuID] int  NOT NULL
);
GO

-- Creating table 'ShiftSchedules'
CREATE TABLE [dbo].[ShiftSchedules] (
    [ShiftScheduleID] int IDENTITY(1,1) NOT NULL
);
GO

-- Creating table 'Orders'
CREATE TABLE [dbo].[Orders] (
    [OrderID] int IDENTITY(1,1) NOT NULL,
    [IsOpen] bit  NOT NULL,
    [IsCleared] bit  NOT NULL,
    [Sale_SalesID] int  NOT NULL,
    [Table_TableID] int  NOT NULL
);
GO

-- Creating table 'OrderItems'
CREATE TABLE [dbo].[OrderItems] (
    [OrderItemID] int IDENTITY(1,1) NOT NULL,
    [Quantity] int  NOT NULL,
    [Order_OrderID] int  NOT NULL,
    [Product_ProductID] int  NOT NULL
);
GO

-- Creating table 'Rooms'
CREATE TABLE [dbo].[Rooms] (
    [RoomID] int IDENTITY(1,1) NOT NULL,
    [RoomNumber] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'Tables'
CREATE TABLE [dbo].[Tables] (
    [TableID] int IDENTITY(1,1) NOT NULL,
    [TableNumber] nvarchar(max)  NOT NULL,
    [Room_RoomID] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [ProductID] in table 'Products'
ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [PK_Products]
    PRIMARY KEY CLUSTERED ([ProductID] ASC);
GO

-- Creating primary key on [MenuID] in table 'Menus'
ALTER TABLE [dbo].[Menus]
ADD CONSTRAINT [PK_Menus]
    PRIMARY KEY CLUSTERED ([MenuID] ASC);
GO

-- Creating primary key on [EmployeeID] in table 'Employees'
ALTER TABLE [dbo].[Employees]
ADD CONSTRAINT [PK_Employees]
    PRIMARY KEY CLUSTERED ([EmployeeID] ASC);
GO

-- Creating primary key on [AddressID] in table 'Addresses'
ALTER TABLE [dbo].[Addresses]
ADD CONSTRAINT [PK_Addresses]
    PRIMARY KEY CLUSTERED ([AddressID] ASC);
GO

-- Creating primary key on [SalesID] in table 'Sales'
ALTER TABLE [dbo].[Sales]
ADD CONSTRAINT [PK_Sales]
    PRIMARY KEY CLUSTERED ([SalesID] ASC);
GO

-- Creating primary key on [ShiftID] in table 'Shifts'
ALTER TABLE [dbo].[Shifts]
ADD CONSTRAINT [PK_Shifts]
    PRIMARY KEY CLUSTERED ([ShiftID] ASC);
GO

-- Creating primary key on [ProductGroupID] in table 'ProductGroups'
ALTER TABLE [dbo].[ProductGroups]
ADD CONSTRAINT [PK_ProductGroups]
    PRIMARY KEY CLUSTERED ([ProductGroupID] ASC);
GO

-- Creating primary key on [ShiftScheduleID] in table 'ShiftSchedules'
ALTER TABLE [dbo].[ShiftSchedules]
ADD CONSTRAINT [PK_ShiftSchedules]
    PRIMARY KEY CLUSTERED ([ShiftScheduleID] ASC);
GO

-- Creating primary key on [OrderID] in table 'Orders'
ALTER TABLE [dbo].[Orders]
ADD CONSTRAINT [PK_Orders]
    PRIMARY KEY CLUSTERED ([OrderID] ASC);
GO

-- Creating primary key on [OrderItemID] in table 'OrderItems'
ALTER TABLE [dbo].[OrderItems]
ADD CONSTRAINT [PK_OrderItems]
    PRIMARY KEY CLUSTERED ([OrderItemID] ASC);
GO

-- Creating primary key on [RoomID] in table 'Rooms'
ALTER TABLE [dbo].[Rooms]
ADD CONSTRAINT [PK_Rooms]
    PRIMARY KEY CLUSTERED ([RoomID] ASC);
GO

-- Creating primary key on [TableID] in table 'Tables'
ALTER TABLE [dbo].[Tables]
ADD CONSTRAINT [PK_Tables]
    PRIMARY KEY CLUSTERED ([TableID] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [Employee_EmployeeID] in table 'Addresses'
ALTER TABLE [dbo].[Addresses]
ADD CONSTRAINT [FK_EmployeeAddress]
    FOREIGN KEY ([Employee_EmployeeID])
    REFERENCES [dbo].[Employees]
        ([EmployeeID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_EmployeeAddress'
CREATE INDEX [IX_FK_EmployeeAddress]
ON [dbo].[Addresses]
    ([Employee_EmployeeID]);
GO

-- Creating foreign key on [Employee_EmployeeID] in table 'Sales'
ALTER TABLE [dbo].[Sales]
ADD CONSTRAINT [FK_EmployeeSales]
    FOREIGN KEY ([Employee_EmployeeID])
    REFERENCES [dbo].[Employees]
        ([EmployeeID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_EmployeeSales'
CREATE INDEX [IX_FK_EmployeeSales]
ON [dbo].[Sales]
    ([Employee_EmployeeID]);
GO

-- Creating foreign key on [Menu_MenuID] in table 'ProductGroups'
ALTER TABLE [dbo].[ProductGroups]
ADD CONSTRAINT [FK_MenuProductGroup]
    FOREIGN KEY ([Menu_MenuID])
    REFERENCES [dbo].[Menus]
        ([MenuID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_MenuProductGroup'
CREATE INDEX [IX_FK_MenuProductGroup]
ON [dbo].[ProductGroups]
    ([Menu_MenuID]);
GO

-- Creating foreign key on [ProductGroup_ProductGroupID] in table 'Products'
ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [FK_ProductGroupProduct]
    FOREIGN KEY ([ProductGroup_ProductGroupID])
    REFERENCES [dbo].[ProductGroups]
        ([ProductGroupID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_ProductGroupProduct'
CREATE INDEX [IX_FK_ProductGroupProduct]
ON [dbo].[Products]
    ([ProductGroup_ProductGroupID]);
GO

-- Creating foreign key on [Shift_ShiftID] in table 'Sales'
ALTER TABLE [dbo].[Sales]
ADD CONSTRAINT [FK_ShiftSales]
    FOREIGN KEY ([Shift_ShiftID])
    REFERENCES [dbo].[Shifts]
        ([ShiftID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_ShiftSales'
CREATE INDEX [IX_FK_ShiftSales]
ON [dbo].[Sales]
    ([Shift_ShiftID]);
GO

-- Creating foreign key on [ShiftSchedule_ShiftScheduleID] in table 'Shifts'
ALTER TABLE [dbo].[Shifts]
ADD CONSTRAINT [FK_ShiftScheduleShift]
    FOREIGN KEY ([ShiftSchedule_ShiftScheduleID])
    REFERENCES [dbo].[ShiftSchedules]
        ([ShiftScheduleID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_ShiftScheduleShift'
CREATE INDEX [IX_FK_ShiftScheduleShift]
ON [dbo].[Shifts]
    ([ShiftSchedule_ShiftScheduleID]);
GO

-- Creating foreign key on [Shift_ShiftID] in table 'Employees'
ALTER TABLE [dbo].[Employees]
ADD CONSTRAINT [FK_ShiftEmployee]
    FOREIGN KEY ([Shift_ShiftID])
    REFERENCES [dbo].[Shifts]
        ([ShiftID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_ShiftEmployee'
CREATE INDEX [IX_FK_ShiftEmployee]
ON [dbo].[Employees]
    ([Shift_ShiftID]);
GO

-- Creating foreign key on [Order_OrderID] in table 'OrderItems'
ALTER TABLE [dbo].[OrderItems]
ADD CONSTRAINT [FK_OrderOrderItem]
    FOREIGN KEY ([Order_OrderID])
    REFERENCES [dbo].[Orders]
        ([OrderID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_OrderOrderItem'
CREATE INDEX [IX_FK_OrderOrderItem]
ON [dbo].[OrderItems]
    ([Order_OrderID]);
GO

-- Creating foreign key on [Product_ProductID] in table 'OrderItems'
ALTER TABLE [dbo].[OrderItems]
ADD CONSTRAINT [FK_ProductOrderItem]
    FOREIGN KEY ([Product_ProductID])
    REFERENCES [dbo].[Products]
        ([ProductID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_ProductOrderItem'
CREATE INDEX [IX_FK_ProductOrderItem]
ON [dbo].[OrderItems]
    ([Product_ProductID]);
GO

-- Creating foreign key on [Sale_SalesID] in table 'Orders'
ALTER TABLE [dbo].[Orders]
ADD CONSTRAINT [FK_SalesOrder]
    FOREIGN KEY ([Sale_SalesID])
    REFERENCES [dbo].[Sales]
        ([SalesID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_SalesOrder'
CREATE INDEX [IX_FK_SalesOrder]
ON [dbo].[Orders]
    ([Sale_SalesID]);
GO

-- Creating foreign key on [Table_TableID] in table 'Orders'
ALTER TABLE [dbo].[Orders]
ADD CONSTRAINT [FK_TableOrder]
    FOREIGN KEY ([Table_TableID])
    REFERENCES [dbo].[Tables]
        ([TableID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_TableOrder'
CREATE INDEX [IX_FK_TableOrder]
ON [dbo].[Orders]
    ([Table_TableID]);
GO

-- Creating foreign key on [Room_RoomID] in table 'Tables'
ALTER TABLE [dbo].[Tables]
ADD CONSTRAINT [FK_RoomTable]
    FOREIGN KEY ([Room_RoomID])
    REFERENCES [dbo].[Rooms]
        ([RoomID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_RoomTable'
CREATE INDEX [IX_FK_RoomTable]
ON [dbo].[Tables]
    ([Room_RoomID]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------