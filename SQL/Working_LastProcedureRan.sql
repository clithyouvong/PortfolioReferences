SELECT o.name, 
       ps.last_execution_time 
FROM   sys.dm_exec_procedure_stats ps 
INNER JOIN 
       sys.objects o 
       ON ps.object_id = o.object_id 
WHERE  DB_NAME(ps.database_id) = 'databaseName' 
ORDER  BY 
       ps.last_execution_time DESC
