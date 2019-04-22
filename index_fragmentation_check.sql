SELECT sys.databases.name,
       OBJECT_NAME(DMV.object_id) AS TABLE_NAME,
       SI.name AS INDEX_NAME,
       avg_fragmentation_in_percent AS FRAGMENT_PERCENT
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'Detailed') AS DMV
    LEFT JOIN sys.databases
        ON (DMV.database_id = sys.databases.database_id)
    LEFT OUTER JOIN sys.indexes AS SI
        ON DMV.object_id = SI.object_id
           AND DMV.index_id = SI.index_id
WHERE avg_fragmentation_in_percent > 10
      AND index_type_desc IN ( 'CLUSTERED INDEX', 'NONCLUSTERED INDEX' )
ORDER BY FRAGMENT_PERCENT DESC;