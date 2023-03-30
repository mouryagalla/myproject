# Import the InfluxDB.Client module
Import-Module InfluxDB.Client

# InfluxDB server configuration
$influxServer = "localhost"
$influxPort = "8086"
$influxDatabase = "mydb"
$influxMeasurement = "file_monitoring"

# CSV file path containing the list of files to monitor
$csvPath = "C:\files_to_monitor.csv"

# Get the current timestamp in InfluxDB format
$timestamp = [Math]::Floor((Get-Date).ToUniversalTime().Subtract((New-Object DateTime(1970,1,1,0,0,0,0,([DateTimeKind]::Utc)))).TotalMilliseconds)

# Read the CSV file and get the list of files to monitor
$filesToMonitor = Import-Csv $csvPath

# Loop through the list of files to monitor
foreach ($file in $filesToMonitor) {
    # Get the file path based on the pattern match
    $filePath = Get-ChildItem $file.Pattern | Select-Object -First 1 | Select-Object -ExpandProperty FullName

    # Check if the file exists
    if (Test-Path $filePath) {
        # Get the file age and size
        $fileAge = (Get-Date) - (Get-Item $filePath).LastWriteTime
        $fileSize = (Get-Item $filePath).Length

        # Construct the InfluxDB Line Protocol payload
        $payload = "$influxMeasurement,file_path=$filePath file_age=$fileAge.TotalSeconds,file_size=$fileSize $timestamp"

        # Send the payload to the InfluxDB server
        Write-InfluxDB -Server $influxServer -Port $influxPort -Database $influxDatabase -Payload $payload
    }
}