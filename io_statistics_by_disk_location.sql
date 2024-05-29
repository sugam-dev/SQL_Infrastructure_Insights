-- This query retrieves aggregated I/O statistics for database files grouped by disk location.

SELECT  
    @@SERVERNAME AS SQLServer, -- Retrieves the SQL Server name
    UPPER(SUBSTRING(b.physical_name, 1, 2)) AS disk_location, -- Retrieves the disk location of the files
    SUM(a.io_stall_read_ms) AS io_stall_read_ms, -- Calculates the total stall time for read operations
    SUM(a.num_of_reads) AS num_of_reads, -- Calculates the total number of read operations
    CAST(SUM(a.num_of_bytes_read) / 1024.0 / 1024.0 / 1024.0 AS NUMERIC(23, 1)) AS GB_read, -- Calculates the total amount of data read in GB
    CASE 
        WHEN SUM(a.num_of_reads) > 0 THEN CAST(SUM(a.io_stall_read_ms) / (1.0 * SUM(a.num_of_reads)) AS INT) -- Calculates the average read stall time
        ELSE CAST(0 AS INT) 
    END AS avg_read_stall_ms, -- Calculates the average read stall time
    SUM(a.io_stall_write_ms) AS io_stall_write_ms, -- Calculates the total stall time for write operations
    SUM(a.num_of_writes) AS num_of_writes, -- Calculates the total number of write operations
    CAST(SUM(a.num_of_bytes_written) / 1024.0 / 1024.0 / 1024.0 AS NUMERIC(23, 1)) AS GB_written, -- Calculates the total amount of data written in GB
    CASE 
        WHEN SUM(a.num_of_writes) > 0 THEN CAST(SUM(a.io_stall_write_ms) / (1.0 * SUM(a.num_of_writes)) AS INT) -- Calculates the average write stall time
        ELSE CAST(0 AS INT) 
    END AS avg_writes_stall_ms -- Calculates the average write stall time
FROM    
    sys.dm_io_virtual_file_stats(NULL, NULL) AS a -- Retrieves I/O statistics for database files
INNER JOIN 
    sys.master_files AS b ON a.file_id = b.file_id
                             AND a.database_id = b.database_id -- Joins with master_files to get file details
GROUP BY 
    UPPER(SUBSTRING(b.physical_name, 1, 2)) -- Groups the result by disk location
ORDER BY 
    4 DESC; -- Orders the result by total number of reads in descending order
GO
