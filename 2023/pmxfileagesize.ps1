
# Set the InfluxDB server and database information
$influxServer = "localhost"
$influxDatabase = "mydatabase"

# Set the path to the CSV file containing the list of files to monitor
$csvFile = "D:\VSC PROJECTS\2023\pmxlist.csv"

# Read the CSV file and store the file patterns and file paths to monitor in an array
$fileList = Import-Csv $csvFile

# Set the age and size thresholds for the files (in seconds and bytes, respectively)
$maxAge = 10 # 10 minutes
$maxSize = 1048576 # 1 MB

# Loop through the files in the specified directories and check their age and size
foreach ($fileInfo in $fileList) {
    $filePath = $fileInfo.filepath
    $pattern = $fileInfo.pattern
    $files = Get-ChildItem -Path $filePath -Filter $pattern
    foreach ($file in $files) {
        $age = (Get-Date) - $file.LastWriteTime
        $size = $file.Length/1MB
        if ($age.TotalMinutes -gt $maxAge -or $size -gt $maxSize) {
            # Construct the InfluxDB line protocol message
            $measurement = "file_monitor"
            $tags = "pattern=$pattern,file=$($file.Name)"
            $fields = "age=$([int]$age.TotalSeconds),size=$([int]$size)"
            $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
            $lineProtocol = "$measurement,$tags $fields $timestamp"
            # Write the message to InfluxDB
            Write-Output $lineProtocol
        }
    }
}