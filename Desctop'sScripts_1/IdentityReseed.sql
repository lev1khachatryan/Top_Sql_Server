-- This comment was added fօr merge
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.KB_ItemDeleteds
	DROP CONSTRAINT FK_KB_ItemDeleteds_KB_WorkingCopies
GO
ALTER TABLE dbo.KB_WorkingCopies SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.KB_ItemDeleteds
	DROP CONSTRAINT FK_KB_ItemDeleteds_KB_C_Languages
GO
ALTER TABLE dbo.KB_C_Languages SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_KB_ItemDeleteds
	(
	ItemDeletedID int NOT NULL IDENTITY (1, 2),
	ItemID int NOT NULL,
	WorkingCopyID int NOT NULL,
	DatasetID int NULL,
	LanguageID int NULL,
	ItemName nvarchar(500) NULL,
	ItemApiName nvarchar(1024) NULL,
	ItemUId int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_KB_ItemDeleteds SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Functional table for deleted items.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_KB_ItemDeleteds', NULL, NULL
GO
DECLARE @v sql_variant 
SET @v = N'System Identifier for the table record.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_KB_ItemDeleteds', N'COLUMN', N'ItemDeletedID'
GO
DECLARE @v sql_variant 
SET @v = N'ID used as a key to link the record to specific item.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_KB_ItemDeleteds', N'COLUMN', N'ItemID'
GO
DECLARE @v sql_variant 
SET @v = N'ID used as a key to link the record to specific working copy.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_KB_ItemDeleteds', N'COLUMN', N'WorkingCopyID'
GO
DECLARE @v sql_variant 
SET @v = N'ID used as a key to link the record to specific dataset.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_KB_ItemDeleteds', N'COLUMN', N'DatasetID'
GO
DECLARE @v sql_variant 
SET @v = N'ID used as a key to link the record to specific language.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_KB_ItemDeleteds', N'COLUMN', N'LanguageID'
GO
DECLARE @v sql_variant 
SET @v = N'Multilingual name of item.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_KB_ItemDeleteds', N'COLUMN', N'ItemName'
GO
DECLARE @v sql_variant 
SET @v = N'Api Name of item.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_KB_ItemDeleteds', N'COLUMN', N'ItemApiName'
GO
DECLARE @v sql_variant 
SET @v = N'Unique identifier for deleted Item.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_KB_ItemDeleteds', N'COLUMN', N'ItemUId'
GO
SET IDENTITY_INSERT dbo.Tmp_KB_ItemDeleteds ON
GO
IF EXISTS(SELECT * FROM dbo.KB_ItemDeleteds)
	 EXEC('INSERT INTO dbo.Tmp_KB_ItemDeleteds (ItemDeletedID, ItemID, WorkingCopyID, DatasetID, LanguageID, ItemName, ItemApiName, ItemUId)
		SELECT ItemDeletedID, ItemID, WorkingCopyID, DatasetID, LanguageID, ItemName, ItemApiName, ItemUId FROM dbo.KB_ItemDeleteds WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_KB_ItemDeleteds OFF
GO
DROP TABLE dbo.KB_ItemDeleteds
GO
EXECUTE sp_rename N'dbo.Tmp_KB_ItemDeleteds', N'KB_ItemDeleteds', 'OBJECT' 
GO
ALTER TABLE dbo.KB_ItemDeleteds ADD CONSTRAINT
	PK_KB_ItemDeleteds PRIMARY KEY CLUSTERED 
	(
	ItemDeletedID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_KB_ItemDeleteds_KB_C_Languages ON dbo.KB_ItemDeleteds
	(
	LanguageID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_KB_ItemDeleteds_WorkingCopyID ON dbo.KB_ItemDeleteds
	(
	DatasetID,
	WorkingCopyID
	) INCLUDE (ItemApiName, ItemID, ItemName, ItemUId, LanguageID) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX UIX_KB_ItemDeleteds ON dbo.KB_ItemDeleteds
	(
	ItemID,
	WorkingCopyID,
	DatasetID,
	LanguageID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.KB_ItemDeleteds ADD CONSTRAINT
	FK_KB_ItemDeleteds_KB_C_Languages FOREIGN KEY
	(
	LanguageID
	) REFERENCES dbo.KB_C_Languages
	(
	LanguageID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.KB_ItemDeleteds ADD CONSTRAINT
	FK_KB_ItemDeleteds_KB_WorkingCopies FOREIGN KEY
	(
	WorkingCopyID
	) REFERENCES dbo.KB_WorkingCopies
	(
	WorkingCopyID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
GO



DECLARE @maxid INT
SELECT @maxID = MAX(ItemDeletedID) FROM KB_ItemDeleteds --WHERE ItemDeletedID < 1000000
SELECT @maxid

DBCC CHECKIDENT (KB_ItemDeleteds, RESEED, @maxID)

