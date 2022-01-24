select  r.end_time,
		r.avg_instance_cpu_percent,
		r.avg_instance_memory_percent,
		r.max_worker_percent,
		r.max_session_percent,
		r.avg_cpu_percent,
		r.avg_data_io_percent,
		r.avg_memory_usage_percent,
		r.avg_log_write_percent
from	sys.dm_db_resource_stats r 
order by r.end_time

/*
SELECT TOP 25 query_stats.query_hash AS "Query Hash",   
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS "Avg CPU Time",  
    MIN(query_stats.statement_text) AS "Statement Text"  
FROM   
    (SELECT QS.*,   
    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,  
    ((CASE statement_end_offset   
        WHEN -1 THEN DATALENGTH(ST.text)  
        ELSE QS.statement_end_offset END   
            - QS.statement_start_offset)/2) + 1) AS statement_text  
     FROM sys.dm_exec_query_stats AS QS  
     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST) as query_stats  
GROUP BY query_stats.query_hash  
ORDER BY 2 DESC;  
*/
