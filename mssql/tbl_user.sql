/****** Object:  Table [dbo].[tbl_user]    Script Date: 07-Apr-20 22:52:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_user](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[dt] [datetime] NOT NULL,
	[ts] [bigint] NOT NULL,
	[telephone] [int] NOT NULL,
	[auth_code] [int] NOT NULL,
	[access_token] [varchar](50) NOT NULL,
	[is_verified] [bit] NOT NULL,
 CONSTRAINT [PK_tbl_user] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[telephone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbl_user] ADD  CONSTRAINT [DF_tbl_user_dt]  DEFAULT (getdate()) FOR [dt]
GO

ALTER TABLE [dbo].[tbl_user] ADD  CONSTRAINT [DF_tbl_user_ts]  DEFAULT (datediff(second,'1970/01/01 00:00:00',getdate())) FOR [ts]
GO

ALTER TABLE [dbo].[tbl_user] ADD  CONSTRAINT [DF_tbl_user_tel]  DEFAULT ((0)) FOR [telephone]
GO

ALTER TABLE [dbo].[tbl_user] ADD  CONSTRAINT [DF_tbl_user_auth_code]  DEFAULT ((0)) FOR [auth_code]
GO

ALTER TABLE [dbo].[tbl_user] ADD  CONSTRAINT [DF_tbl_user_access_token]  DEFAULT ('') FOR [access_token]
GO

ALTER TABLE [dbo].[tbl_user] ADD  CONSTRAINT [DF_tbl_user_is_verified]  DEFAULT ((0)) FOR [is_verified]
GO


