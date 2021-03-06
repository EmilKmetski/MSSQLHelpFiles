EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'xp_cmdshell', 1;
GO
RECONFIGURE;
GO
CREATE TABLE #files
(
    files VARCHAR(MAX),
    [file] VARCHAR(MAX),
    extension VARCHAR(4)
);
GO
DECLARE @DBdir AS VARCHAR(8000);
SET @DBdir = 'dir /b ' + '"' +
             (
                 SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)
                 FROM master.sys.master_files
                 WHERE database_id = 1
                       AND file_id = 1
             ) + '"';
INSERT INTO #files
(
    files
)
EXEC xp_cmdshell @DBdir; -- put here your directory nam
GO
UPDATE #files
SET [file] = LEFT(files, CASE
                             WHEN (LEN(files) - 4) < 0 THEN
                                 1
                             ELSE
    (LEN(files) - 4)
                         END),
    [extension] = RIGHT(files, 4);
GO
DECLARE @DB AS VARCHAR(MAX);
DECLARE DB_cursor CURSOR FOR
SELECT [file]
FROM #files
WHERE extension IN ( '.mdf' )
      AND [file] NOT IN ( 'tempdb', 'templog', 'ReportServer', 'ReportServerTempDB', 'ReportServerTempDB_log',
                          'ReportServer_log', 'model', 'modellog', 'MSDBData', 'MSDBLog', 'mastlog', 'master'
                        );
OPEN DB_cursor;
FETCH NEXT FROM DB_cursor
INTO @DB;
DECLARE @DBdir AS VARCHAR(MAX);
SET @DBdir = '''' +
             (
                 SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)
                 FROM master.sys.master_files
                 WHERE database_id = 1
                       AND file_id = 1
             );
WHILE @@FETCH_STATUS = 0
IF @@FETCH_STATUS = 0
BEGIN
    EXEC ('USE [master]
	CREATE DATABASE [' + @DB + '] ON 
	( FILENAME = N' + @DBdir + @DB + '.mdf' + '''' + ' )
	FOR ATTACH');
    FETCH NEXT FROM DB_cursor
    INTO @DB;
END;
CLOSE DB_cursor;
DEALLOCATE DB_cursor;
GO
DROP TABLE #files;
GO
EXEC sp_configure 'xp_cmdshell', 0;
GO
RECONFIGURE;
GO
EXEC sp_configure 'show advanced options', 0;
GO
RECONFIGURE;
GO
