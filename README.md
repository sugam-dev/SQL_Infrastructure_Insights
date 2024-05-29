
        <h1>I/O Statistics Query README <span>&#x1F4BB;</span></h1>

        <h2>Query 1: Detailed I/O Statistics by File <span>&#x1F4C2;</span></h2>
        <ul>
            <li><strong>File:</strong> io_statistics_by_file.sql</li>
            <li><strong>Description:</strong> This query provides detailed I/O statistics for each database file, including read and write operations, stall times, and related wait types.</li>
            <li><strong>Usage:</strong> Execute the query in SQL Server Management Studio or any SQL client connected to your SQL Server instance.</li>
            <li><strong>Prerequisites:</strong> Ensure that the user executing the query has sufficient permissions to access the sys.dm_io_virtual_file_stats and sys.master_files views.</li>
            <li><strong>Output:</strong> The query outputs a table with columns detailing server name, database name, file logical name, disk location, size on disk (in MB), I/O stall times for reads and writes, number of reads and writes, average stall times for reads and writes, related wait types for reads and writes, physical name of the file, and the sample time.</li>
        </ul>

        <h2>Query 2: Aggregated I/O Statistics by Disk Location <span>&#x1F4C8;</span></h2>
        <ul>
            <li><strong>File:</strong> io_statistics_by_disk_location.sql</li>
            <li><strong>Description:</strong> This query provides aggregated I/O statistics grouped by disk location, including total stall times, number of reads and writes, total data read and written, and average stall times for reads and writes.</li>
            <li><strong>Usage:</strong> Execute the query in SQL Server Management Studio or any SQL client connected to your SQL Server instance.</li>
            <li><strong>Prerequisites:</strong> Ensure that the user executing the query has sufficient permissions to access the sys.dm_io_virtual_file_stats and sys.master_files views.</li>
            <li><strong>Output:</strong> The query outputs a table with columns detailing SQL Server name, disk location, total I/O stall times for reads and writes, total number of reads and writes, total data read and written (in GB), and average stall times for reads and writes.</li>
        </ul>

        <h2>Additional Notes <span>&#x1F4DD;</span></h2>
        <ul>
            <li><strong>Adjustments:</strong> You may need to adjust certain parameters such as recommended maximum average stall times based on your specific environment and performance requirements.</li>
            <li><strong>Recommendations:</strong> Consider scheduling these queries to run at regular intervals to monitor database I/O performance over time.</li>
            <li><strong>Permissions:</strong> Ensure that the user executing these queries has the necessary permissions to access system views and tables.</li>
        </ul>

        <p>Feel free to customize and utilize these queries to effectively monitor and optimize the I/O performance of your SQL Server databases.</p>

        <p>For any questions or issues, please feel free to open an issue in this repository.</p>
