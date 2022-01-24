SELECT 
    percent_complete, 
    dateadd(second,estimated_completion_time/ 1000, getdate()) as est_completion_time
FROM 
    sys.dm_exec_requests
WHERE
    command = 'DbccFilesCompact'
