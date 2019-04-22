DECLARE @sql NVARCHAR(MAX);
SET @sql = N' ';
SELECT @sql
    = @sql + N'
USE [master]
ALTER DATABASE [' + db.name + N'] SET RECOVERY SIMPLE WITH NO_WAIT ' + CHAR(10) + N'USE [' + db.name + N']  '
      + CHAR(10) + N'DBCC SHRINKFILE (N''' + mf.name + N'' + N''' , 0, TRUNCATEONLY)  ' + CHAR(10) + N'USE [master]  '
      + CHAR(10) + N'ALTER DATABASE [' + db.name + N'] SET RECOVERY FULL WITH NO_WAIT ; ' + CHAR(10)
FROM sys.databases db
    JOIN sys.master_files mf
        ON db.database_id = mf.database_id
           AND [file_id] = 2
WHERE db.[name] NOT IN ( 'tempdb' );
EXEC sp_sqlexec @sql;