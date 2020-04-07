/****** Object:  Table [dbo].[tbl_user_log]    Script Date: 07-Apr-20 22:53:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_user_log](
	[ulog_id] [int] IDENTITY(1,1) NOT NULL,
	[dt] [datetime] NOT NULL,
	[meet_ts] [bigint] NOT NULL,
	[user_id] [int] NOT NULL,
	[user_id2] [int] NOT NULL,
 CONSTRAINT [PK_tbl_userlog] PRIMARY KEY CLUSTERED 
(
	[ulog_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbl_user_log] ADD  CONSTRAINT [DF_tbl_userlog_dt]  DEFAULT (getdate()) FOR [dt]
GO

ALTER TABLE [dbo].[tbl_user_log] ADD  CONSTRAINT [DF_tbl_userlog_meet_ts]  DEFAULT ((0)) FOR [meet_ts]
GO

ALTER TABLE [dbo].[tbl_user_log] ADD  CONSTRAINT [DF_tbl_userlog_user_id]  DEFAULT ((0)) FOR [user_id]
GO

ALTER TABLE [dbo].[tbl_user_log] ADD  CONSTRAINT [DF_tbl_userlog_user_id2]  DEFAULT ((0)) FOR [user_id2]
GO

