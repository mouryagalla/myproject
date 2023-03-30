# Set the InfluxDB parameters
$influxdbHost = "your-influxdb-host"
$influxdbPort = 8086
$influxdbName = "your-influxdb-database"
$influxdbMeasurement = "mismatched_files"

# Set the directory to search for files
$directory = "D:\VSC PROJECTS\2023\"

# Set the list of patterns to match against
$patterns = @("*.txt", "*.csv", "*.log")

# Get the list of files in the directory
$files = Get-ChildItem -Path $directory -File

# Filter out files that match the patterns
$mismatchedFiles = $files | Where-Object { $patterns -notcontains $_.Name }

# Get the count of mismatched files
$mismatchedFilesCount = $mismatchedFiles.Count

# Get the current time in UTC
$timestamp = [System.DateTime]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")

# Build the InfluxDB line protocol message
$influxdbMessage = "mismatched_files,host=local,dir=$directory count=$mismatchedFilesCount $([System.Math]::Floor((get-date -UFormat %s)))"


# Display the results
Write-Output $influxdbMessage
