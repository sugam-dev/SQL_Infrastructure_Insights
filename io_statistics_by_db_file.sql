-- This query retrieves information about I/O statistics for database files 
-- including read and write operations, stall times, and related wait types.

SELECT  
    @@SERVERNAME AS ServerName, -- Retrieves the server name
    DB_NAME(a.database_id) AS [db_name], -- Retrieves the database name
    b.name + N' [' + b.type_desc COLLATE SQL_Latin1_General_CP1_CI_AS + N']' AS file_logical_name, -- Retrieves the logical name of the file
    UPPER(SUBSTRING(b.physical_name, 1, 2)) AS disk_location, -- Retrieves the disk location of the file
    CAST((a.size_on_disk_bytes / 1024.0 / 1024.0) AS INT) AS size_on_disk_mb, -- Calculates the size of the file on disk in MB
    a.io_stall_read_ms, -- Retrieves the total stall time for read operations
    a.num_of_reads, -- Retrieves the total number of read operations
    CASE 
        WHEN a.num_of_bytes_read > 0 THEN CAST(a.num_of_bytes_read / 1024.0 / 1024.0 / 1024.0 AS NUMERIC(23, 1)) -- Calculates the total amount of data read in GB
        ELSE 0 
    END AS GB_read, -- Retrieves the total amount of data read in GB
    CAST(a.io_stall_read_ms / (1.0 * a.num_of_reads) AS INT) AS avg_read_stall_ms, -- Calculates the average read stall time
    avg_read_stall_ms_recommended_max = 
        CASE 
            WHEN b.type = 0 THEN 30 /* data files */ -- Sets recommended maximum average read stall time for data files
            WHEN b.type = 1 THEN 5 /* log files */ -- Sets recommended maximum average read stall time for log files
            ELSE 0
        END,
    a.io_stall_write_ms, -- Retrieves the total stall time for write operations
    a.num_of_writes, -- Retrieves the total number of write operations
    CASE 
        WHEN a.num_of_bytes_written > 0 THEN CAST(a.num_of_bytes_written / 1024.0 / 1024.0 / 1024.0 AS NUMERIC(23, 1)) -- Calculates the total amount of data written in GB
        ELSE 0 
    END AS GB_written, -- Retrieves the total amount of data written in GB
    CAST(a.io_stall_write_ms / (1.0 * a.num_of_writes) AS INT) AS avg_write_stall_ms, -- Calculates the average write stall time
    avg_write_stall_ms_recommended_max = 
        CASE 
            WHEN b.type = 0 THEN 30 /* data files */ -- Sets recommended maximum average write stall time for data files
            WHEN b.type = 1 THEN 2 /* log files */ -- Sets recommended maximum average write stall time for log files
            ELSE 0
        END,
    b.physical_name, -- Retrieves the physical name of the file
    related_wait_type_reads = 
        CASE
            WHEN b.name = 'tempdb' THEN 'N/A' -- Specifies related wait type for tempdb
            WHEN b.type = 1 THEN 'N/A' /* log files */ -- Specifies related wait type for log files
            ELSE 'PAGEIOLATCH*' -- Specifies related wait type for data files
        END,
    related_wait_type_writes = 
        CASE
            WHEN b.type = 1 THEN 'WRITELOG' /* log files */ -- Specifies related wait type for log files
            WHEN b.name = 'tempdb' THEN 'xxx' /* tempdb data files */ -- Specifies related wait type for tempdb data files
            WHEN b.type = 0 THEN 'ASYNC_IO_COMPLETION' /* data files */ -- Specifies related wait type for data files
            ELSE 'xxx'
        END,
    GETDATE() AS sample_time -- Retrieves the current date and time as sample time
FROM    
    sys.dm_io_virtual_file_stats(NULL, NULL) AS a -- Retrieves I/O statistics for database files
INNER JOIN 
    sys.master_files AS b ON a.file_id = b.file_id
                             AND a.database_id = b.database_id -- Joins with master_files to get file details
WHERE   
    a.num_of_reads > 0 -- Filters out files with no read operations
    AND a.num_of_writes > 0 -- Filters out files with no write operations
ORDER BY 
    avg_read_stall_ms DESC; -- Orders the result by average read stall time in descending order
GO
