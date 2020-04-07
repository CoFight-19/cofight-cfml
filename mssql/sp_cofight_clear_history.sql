/****** Object:  StoredProcedure [dbo].[sp_cofight_clear_history]    Script Date: 07-Apr-20 22:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_cofight_clear_history] 
	
AS

DELETE FROM 
	tbl_user_log 
WHERE
	DateDiff(d,dateadd(S, meet_ts, '1970-01-01'),getdate()) > 21
GO

