-- This comment was added fօr merge
BEGIN TRAN

UPDATE  DE_CourtCase
SET     DE_CourtCase.CategoryID = SubQuery.NewCategoryID ,
		DE_CourtCase.SubCategoryID = CASE WHEN DE_CourtCase.SubCategoryID IS NULL THEN SubQuery.NewSubCategory ELSE DE_CourtCase.SubCategoryID END,
		DE_CourtCase.CourtPresidentUserID = CASE WHEN DE_CourtCase.CourtPresidentUserID IS NULL THEN SubQuery.NewCourtPresidentUserID ELSE DE_CourtCase.CourtPresidentUserID END ,
		DE_CourtCase.ChiefRegistrarUserID = CASE WHEN DE_CourtCase.ChiefRegistrarUserID IS NULL THEN SubQuery.NewChiefRegistrarUserID ELSE DE_CourtCase.ChiefRegistrarUserID END ,
		DE_CourtCase.AssignedRegistrarUserID = CASE WHEN DE_CourtCase.AssignedRegistrarUserID IS NULL THEN SubQuery.NewAssignedRegistrarUserID ELSE DE_CourtCase.AssignedRegistrarUserID END 
FROM    dbo.DE_CourtCase AS DE_CourtCase
        JOIN ( SELECT   Sub.CourtCaseID ,
                        Sub.CourtCaseInstanceID ,
                        Sub.NewCategoryID ,
						Sub.NewSubCategory ,
						Sub.NewCourtPresidentUserID ,
						Sub.NewChiefRegistrarUserID ,
						Sub.NewAssignedRegistrarUserID ,
                        ROW_NUMBER() OVER ( PARTITION BY Sub.CourtCaseInstanceID,
                                            Sub.CourtCaseID ORDER BY Sub.CourtCaseInstanceID , Sub.CourtCaseID ) AS RowNum
               FROM     ( SELECT    DE_CourtCase.CourtCaseID ,
                                    DE_CourtCase.CourtCaseInstanceID ,
                                    OuterQuery.CategoryID AS NewCategoryID ,
									OuterQuery.SubCategoryID AS NewSubCategory ,
									OuterQuery.CourtPresidentUserID AS NewCourtPresidentUserID ,
									OuterQuery.ChiefRegistrarUserID AS NewChiefRegistrarUserID ,
									OuterQuery.AssignedRegistrarUserID AS NewAssignedRegistrarUserID
                          FROM      dbo.DE_CourtCase AS DE_CourtCase
                                    JOIN dbo.DE_CourtCase AS OuterQuery ON OuterQuery.CourtCaseInstanceID = DE_CourtCase.CourtCaseInstanceID
                                                              AND DE_CourtCase.MajorVersion < OuterQuery.MajorVersion
                          WHERE     DE_CourtCase.CategoryID IS NULL
                                    AND OuterQuery.CategoryID IS NOT NULL
                        ) AS Sub
             ) AS SubQuery ON SubQuery.CourtCaseID = DE_CourtCase.CourtCaseID
WHERE   SubQuery.RowNum = 1;
-- when CategoryID is null In Last version
UPDATE  DE_CourtCase
SET     DE_CourtCase.CategoryID = SubQuery.NewCategoryID ,
		DE_CourtCase.SubCategoryID = CASE WHEN DE_CourtCase.SubCategoryID IS NULL THEN SubQuery.NewSubCategory ELSE DE_CourtCase.SubCategoryID END,
		DE_CourtCase.CourtPresidentUserID = CASE WHEN DE_CourtCase.CourtPresidentUserID IS NULL THEN SubQuery.NewCourtPresidentUserID ELSE DE_CourtCase.CourtPresidentUserID END ,
		DE_CourtCase.ChiefRegistrarUserID = CASE WHEN DE_CourtCase.ChiefRegistrarUserID IS NULL THEN SubQuery.NewChiefRegistrarUserID ELSE DE_CourtCase.ChiefRegistrarUserID END ,
		DE_CourtCase.AssignedRegistrarUserID = CASE WHEN DE_CourtCase.AssignedRegistrarUserID IS NULL THEN SubQuery.NewAssignedRegistrarUserID ELSE DE_CourtCase.AssignedRegistrarUserID END 
FROM    dbo.DE_CourtCase AS DE_CourtCase
        JOIN ( SELECT   Sub.CourtCaseID ,
                        Sub.CourtCaseInstanceID ,
                        Sub.NewCategoryID ,
						Sub.NewSubCategory ,
						Sub.NewCourtPresidentUserID ,
						Sub.NewChiefRegistrarUserID ,
						Sub.NewAssignedRegistrarUserID ,
                        ROW_NUMBER() OVER ( PARTITION BY Sub.CourtCaseInstanceID,
                                            Sub.CourtCaseID ORDER BY Sub.CourtCaseInstanceID , Sub.CourtCaseID ) AS RowNum
               FROM     ( SELECT    DE_CourtCase.CourtCaseID ,
                                    DE_CourtCase.CourtCaseInstanceID ,
                                    OuterQuery.CategoryID AS NewCategoryID ,
									OuterQuery.SubCategoryID AS NewSubCategory ,
									OuterQuery.CourtPresidentUserID AS NewCourtPresidentUserID ,
									OuterQuery.ChiefRegistrarUserID AS NewChiefRegistrarUserID ,
									OuterQuery.AssignedRegistrarUserID AS NewAssignedRegistrarUserID
                          FROM      dbo.DE_CourtCase AS DE_CourtCase
                                    JOIN dbo.DE_CourtCase AS OuterQuery ON OuterQuery.CourtCaseInstanceID = DE_CourtCase.CourtCaseInstanceID
                                                              AND DE_CourtCase.MajorVersion > OuterQuery.MajorVersion
                          WHERE     DE_CourtCase.CategoryID IS NULL
                                    AND OuterQuery.CategoryID IS NOT NULL
                        ) AS Sub
             ) AS SubQuery ON SubQuery.CourtCaseID = DE_CourtCase.CourtCaseID
WHERE   SubQuery.RowNum = 1;
------------------

--SELECT CourtCaseID , CourtCaseInstanceID , MajorVersion , CategoryID , DateUpdated , SubCategoryID , CourtPresidentUserID ,ChiefRegistrarUserID  ,AssignedRegistrarUserID
--FROM dbo.DE_CourtCase
--WHERE CourtCaseInstanceID IN
--(
--SELECT DISTINCT CourtCaseInstanceID
--FROM dbo.DE_CourtCase
--WHERE CategoryID IS NULL
--)
--AND DateUpdated >= '20170717'
--ORDER BY CourtCaseInstanceID , CourtCaseID

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET NUMERIC_ROUNDABORT OFF;

DROP VIEW dbo.View_DE_CourtCasePublished;

ALTER TABLE dbo.DE_CourtCase
ALTER COLUMN CategoryID INT NOT NULL;

GO
CREATE VIEW [dbo].[View_DE_CourtCasePublished]
WITH SCHEMABINDING
AS
    SELECT  DE_CourtCase.CourtCaseID ,
            DE_CourtCase.CourtCaseInstanceID AS CourtCaseInstanceID ,
            CaseNumber AS CaseNumber ,
            DE_CourtCase.DateUpdated AS DateUpdated ,
            WFStateID AS WFStateID ,
            OwnerUserID AS OwnerUserID ,
            WFActionDate AS WFActionDate ,
            CaseRegisteredDate AS CaseRegisteredDate ,
            CategoryID AS CategoryID ,
            CaseSubmittedDate AS CaseSubmittedDate ,
            CourtPresidentUserID AS CourtPresidentUserID ,
            ChiefRegistrarUserID AS ChiefRegistrarUserID ,
            AssignedRegistrarUserID AS AssignedRegistrarUserID ,
            AssignedJudgeUserID AS AssignedJudgeUserID ,
            PublicOwnerUserId AS PublicOwnerUserId ,
            CourtID AS CourtID ,
            SubCategoryID AS SubCategoryID ,
            CasePriorityID AS CasePriorityID ,
            ReceiptNumber ,
            SubjectMatter
    FROM    dbo.DE_CourtCase
            JOIN dbo.DE_CourtCasePublishedItem ON DE_CourtCasePublishedItem.CourtCaseID = DE_CourtCase.CourtCaseID;
GO
--------------
GO
CREATE UNIQUE CLUSTERED INDEX [CIX_View_DE_CourtCasePublished] ON [dbo].[View_DE_CourtCasePublished]
(
[CourtCaseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);
GO
----------
CREATE NONCLUSTERED INDEX [IX_View_DE_CourtCasePublished_CategoryID_CourtID] ON [dbo].[View_DE_CourtCasePublished]
(
[CategoryID] ASC,
[CourtID] ASC
)
INCLUDE ( 	[CourtCaseID],
[CaseNumber],
[WFStateID],
[WFActionDate],
[CaseRegisteredDate],
[CaseSubmittedDate],
[CourtPresidentUserID],
[ChiefRegistrarUserID],
[AssignedRegistrarUserID],
[AssignedJudgeUserID],
[PublicOwnerUserId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);
GO
---------
CREATE NONCLUSTERED INDEX [IX_View_DE_CourtCasePublished_CourtID] ON [dbo].[View_DE_CourtCasePublished]
(
[CourtID] ASC
)
INCLUDE ( 	[CourtCaseID],
[CaseNumber],
[WFStateID],
[WFActionDate],
[CaseRegisteredDate],
[CategoryID],
[CaseSubmittedDate],
[CourtPresidentUserID],
[ChiefRegistrarUserID],
[AssignedRegistrarUserID],
[AssignedJudgeUserID],
[PublicOwnerUserId],
[CourtCaseInstanceID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);
GO
-------------------
CREATE NONCLUSTERED INDEX [IX_View_DE_CourtCasePublished_PublicOwnerUserId] ON [dbo].[View_DE_CourtCasePublished]
(
[PublicOwnerUserId] ASC
)
INCLUDE ( 	[CaseNumber],
[CaseRegisteredDate],
[CaseSubmittedDate],
[CategoryID],
[SubjectMatter],
[WFActionDate],
[WFStateID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);
GO
-------------------
CREATE NONCLUSTERED INDEX [IX_View_DE_CourtCasePublished_WFStateID] ON [dbo].[View_DE_CourtCasePublished]
(
[WFStateID] ASC
)
INCLUDE ( 	[AssignedJudgeUserID],
[AssignedRegistrarUserID],
[CaseNumber],
[CaseRegisteredDate],
[CaseSubmittedDate],
[CategoryID],
[ChiefRegistrarUserID],
[CourtCaseID],
[CourtID],
[CourtPresidentUserID],
[PublicOwnerUserId],
[WFActionDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON);
GO

COMMIT

ROLLBACK
