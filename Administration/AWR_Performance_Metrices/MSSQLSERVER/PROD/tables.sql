USE [DBAMonitor]
GO
/****** Object:  Table [dbo].[html]    Script Date: 03/13/2014 08:27:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[html](
	[body] [nvarchar](max) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dlock]    Script Date: 03/13/2014 08:27:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dlock](
	[alerttime] [datetime] NULL,
	[deadlock_report] [xml] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TOP_QUERY_BY_TIME]    Script Date: 03/13/2014 08:28:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TOP_QUERY_BY_TIME](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[row_rank] [int] NULL,
	[DBname] [varchar](250) NULL,
	[exec_count] [int] NULL,
	[total_elapsed_time] [decimal](18, 5) NULL,
	[avg_elapsed_time] [decimal](18, 5) NULL,
	[last_exec_time] [datetime] NULL,
	[TSQL] [varchar](max) NULL,
 CONSTRAINT [PK__TOP_QUERY_BY_TIM__540C7B0a0] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TOP_QUERY_BY_CPU]    Script Date: 03/13/2014 08:28:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TOP_QUERY_BY_CPU](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DBNAME] [varchar](50) NULL,
	[TSQL] [varchar](max) NULL,
	[objtype] [varchar](50) NULL,
	[Schema_name] [varchar](50) NULL,
	[Object_name] [varchar](250) NULL,
	[execution_count] [int] NULL,
	[total_cpu_time_ms] [decimal](18, 5) NULL,
	[avg_cpu_time_ms] [decimal](18, 5) NULL,
	[last_execution_time] [datetime] NULL,
 CONSTRAINT [PK__TOP_QUERY_BY_CPU__14A8310C6] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SPstatistics]    Script Date: 03/13/2014 08:28:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SPstatistics](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DBName] [nvarchar](250) NULL,
	[Schema_Name] [nvarchar](50) NULL,
	[object_Name] [nvarchar](250) NULL,
	[cache_time] [datetime] NULL,
	[last_execution_time] [datetime] NULL,
	[execution_count] [int] NULL,
	[avg_cpu] [decimal](18, 3) NULL,
	[avg_elapsed] [decimal](18, 3) NULL,
	[avg_logical_reads] [int] NULL,
	[avg_logical_writes] [int] NULL,
	[avg_physical_writes] [int] NULL,
 CONSTRAINT [PK_SP_statistics] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TOP_QUERY_BY_IO]    Script Date: 03/13/2014 08:28:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TOP_QUERY_BY_IO](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DBNAME] [varchar](50) NULL,
	[TSQL] [varchar](max) NULL,
	[objtype] [varchar](50) NULL,
	[Schema_name] [varchar](50) NULL,
	[Object_name] [varchar](250) NULL,
	[execution_count] [int] NULL,
	[total_IOs] [bigint] NULL,
	[avg_Ios] [bigint] NULL,
	[total_logical_reads] [bigint] NULL,
	[avg_logical_reads] [bigint] NULL,
	[total_logical_writes] [int] NULL,
	[avg_logical_writes] [int] NULL,
	[total_physical_reads] [int] NULL,
	[avg_physical_reads] [int] NULL,
	[last_execution_time] [datetime] NULL,
 CONSTRAINT [PK__TOP_QUERY_BY_IO__503BEA1C] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
