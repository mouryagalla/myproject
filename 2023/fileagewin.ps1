# Define the path and age threshold of the file to monitor
$filePath = "C:\Path\To\File.txt"
$maxAgeInMinutes = 30

# Continuously monitor the age of the file
while($true) {
    # Get the age of the file in minutes
    $fileAgeInMinutes = (Get-Date) - (Get-Item $filePath).LastWriteTime
    $fileAgeInMinutes = [int]$fileAgeInMinutes.TotalMinutes
    
    # Check if the file is older than the threshold
    if($fileAgeInMinutes -gt $maxAgeInMinutes) {
        Write-Host "The file is older than $maxAgeInMinutes minutes"
    }
    
    # Wait for some time before checking the file age again
    Start-Sleep -Seconds 60
}
