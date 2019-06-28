CREATE TABLE [dbo].[_AWR_MissingIndex](
	[AVG_estimated_impact] [INT] NULL,
	[Last_user_seek] [NVARCHAR](500) NULL,
	[TableName] [NVARCHAR](200) NULL,
	[Create_statment] [NVARCHAR](2000) NULL,
	[User_seeks_count] [INT] NULL,
	[User_scans_count] [INT] NULL,
	[avg_user_impact] [DECIMAL](18, 10) NULL
)
GO
SELECT *
FROM dbo._AWR_MissingIndex
WHERE User_seeks_count > 1000 AND avg_user_impact > 50
ORDER BY avg_user_impact DESC, User_seeks_count DESC
