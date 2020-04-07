/****** Object:  StoredProcedure [dbo].[sp_cofight_process_spool]    Script Date: 07-Apr-20 22:55:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_cofight_process_spool] 
	
AS

DECLARE @ULOGS_ID INT;
DECLARE @SQL NVARCHAR(MAX);

WHILE EXISTS (SELECT ulogs_id FROM tbl_user_log_spool)
BEGIN
	BEGIN TRANSACTION
		SET @ULOGS_ID = (SELECT TOP 1 ulogs_id FROM tbl_user_log_spool);
		SET @SQL = (SELECT TOP 1 cmd FROM tbl_user_log_spool);
		EXEC (@SQL);
		DELETE FROM tbl_user_log_spool WHERE ulogs_id = @ULOGS_ID
	COMMIT TRANSACTION
END


GO

