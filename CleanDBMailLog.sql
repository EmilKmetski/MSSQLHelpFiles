DECLARE @GETDATE datetime  
SET @GETDATE = DATEADD(DAY,-7,GETDATE())  
EXECUTE msdb.dbo.sysmail_delete_mailitems_sp @sent_before = @GETDATE;  
GO