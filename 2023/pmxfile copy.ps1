

# InfluxDB server configuration
$influxServer = "localhost"
$influxPort = "8086"
$influxDatabase = "mydb"
$influxMeasurement = "file_monitoring"

# CSV file path containing the list of files to monitor
$csvPath = "D:\VSC PROJECTS\2023\pmxlist.csv"

# Get the current timestamp in InfluxDB format
$timestamp = [Math]::Floor((Get-Date).ToUniversalTime().Subtract((New-Object DateTime(1970,1,1,0,0,0,0,([DateTimeKind]::Utc)))).TotalMilliseconds)

# Read the CSV file and get the list of files to monitor
$filesToMonitor = Import-Csv -Path $csvPath


# Loop through the list of files to monitor
foreach ($row in $filesToMonitor) {
    $filename = $row.filepath
    $filepattern = $row.pattern 
    Write-Output $filename
    Write-Output $filepattern
    # Get the file path based on the pattern match
    #$filePath = Get-ChildItem $file.Pattern | Select-Object -First 1 | Select-Object -ExpandProperty FullName
    $filePath = Get-ChildItem -Path $filename -Recurse -Filter $filepattern | Select-Object -ExpandProperty FullName
    # Check if the file exists
    Write-Output $filePath
    foreach ($row in $filePath) {
        $filePathrow = $row.filePath
        Write-Output $filePath
        if (Test-Path $filePath) {
            # Get the file age and size
            $fileAge = (Get-Date) - (Get-Item $filePath).LastWriteTime
            $fileSize = (Get-Item $filePath).Length
            $fileAgeMin = $fileAge.TotalMinutes 
            Write-Output $fileAge
            Write-Output $fileSize
            Write-Output $fileAgeMin
            # Construct the InfluxDB Line Protocol payload
            $payload = "$influxMeasurement,file_path=$filePath file_age=$fileAgeMin,file_size=$fileSize $timestamp"

            # Send the payload to the InfluxDB server
            Write-Output $payload
        }
    }
}