DECLARE @retvalue INT,
        @data_dir VARCHAR(500);
EXECUTE @retvalue = master.dbo.xp_instance_regread 'HKEY_LOCAL_MACHINE',
                                                   'SOFTWARE\Microsoft\MSSQLServer\Setup',
                                                   'SQLDataRoot',
                                                   @param = @data_dir OUTPUT;
SELECT @data_dir + '\Data\';