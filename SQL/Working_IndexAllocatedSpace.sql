--Gets the size of each index for the specified table
DECLARE @TableName sysname = N'ReportQueue';

SELECT i.name AS IndexName
      ,8 * SUM(s.used_page_count) AS IndexSizeKB
FROM sys.indexes AS i
    INNER JOIN sys.dm_db_partition_stats AS s 
        ON i.[object_id] = s.[object_id] AND i.index_id = s.index_id
WHERE s.[object_id] = OBJECT_ID(@TableName, N'U')
GROUP BY i.name
ORDER BY i.name;

SELECT i.name AS IndexName
      ,8 * SUM(a.used_pages) AS IndexSizeKB
FROM sys.indexes AS i
    INNER JOIN sys.partitions AS p 
        ON i.[object_id]  = p.[object_id] AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units AS a 
        ON p.partition_id = a.container_id
WHERE i.[object_id] = OBJECT_ID(@TableName, N'U')
GROUP BY i.name
ORDER BY i.name;
