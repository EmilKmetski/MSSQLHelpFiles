DECLARE @SQL VARCHAR(MAX) = ' '
DECLARE @Dir Varchar(max) = 'G:\DATABASES\'
SELECT 
	  @SQL += CASE WHEN dbmf.type_desc ='ROWS' THEN 'ALTER DATABASE ['+ sdb.[name] +'] MODIFY FILE ( NAME = ['+ dbmf.[name] +'] , FILENAME = '''+ @Dir + dbmf.[name] +'.mdf'')' + CHAR(10) 
				   WHEN dbmf.type_desc ='LOG' THEN 'ALTER DATABASE ['+ sdb.[name] +'] MODIFY FILE ( NAME = ['+ dbmf.[name] +'] , FILENAME		= '''+ @Dir + dbmf.[name] +'.ldf'')' + CHAR(10) 
			  END
  FROM sys.databases sdb
  JOIN sys.master_files dbmf  on sdb.database_id = dbmf.database_id

  PRINT @SQL;