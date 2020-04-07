/****** Object:  Table [dbo].[tbl_user_log_spool]    Script Date: 07-Apr-20 22:54:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_user_log_spool](
	[ulogs_id] [int] IDENTITY(1,1) NOT NULL,
	[dt] [datetime] NOT NULL,
	[user_id] [int] NOT NULL,
	[cmd] [varchar](512) NOT NULL,
 CONSTRAINT [PK_tbl_user_log_spool] PRIMARY KEY CLUSTERED 
(
	[ulogs_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbl_user_log_spool] ADD  CONSTRAINT [DF_tbl_user_log_spool_dt]  DEFAULT (getdate()) FOR [dt]
GO

ALTER TABLE [dbo].[tbl_user_log_spool] ADD  CONSTRAINT [DF_tbl_user_log_spool_user_id]  DEFAULT ((0)) FOR [user_id]
GO

ALTER TABLE [dbo].[tbl_user_log_spool] ADD  CONSTRAINT [DF_tbl_user_log_spool_cmd]  DEFAULT ('') FOR [cmd]
GO

