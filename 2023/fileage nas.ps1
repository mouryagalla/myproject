# Specify the directory to monitor
$directory = "\\NAS\share\folder"

# Specify the age limit for files (in days)
$ageLimit = 30

# Define a function to check the age of files
function Check-FileAge {
    $files = Get-ChildItem $directory | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$ageLimit) }
    if ($files.Count -gt 0) {
        Write-Host "The following files are older than $ageLimit days:"
        $files | Select-Object Name, LastWriteTime
    }
}

# Run the function every 5 minutes
while ($true) {
    Check-FileAge
    Start-Sleep -Seconds 300
}

###################

$folderPath = "\\NAS\SharedFolder" # Replace with your NAS drive directory path
$maxAgeInDays = 30 # Replace with the maximum age of files you want to monitor (in days)

while ($true) {
    $files = Get-ChildItem $folderPath | Where-Object {!$_.PSIsContainer}

    foreach ($file in $files) {
        $ageInDays = (Get-Date) - $file.LastWriteTime
        if ($ageInDays.Days -gt $maxAgeInDays) {
            Write-Host "File $($file.Name) in $($file.DirectoryName) is older than $maxAgeInDays days"
        }
    }

    Start-Sleep -Seconds 60 # Sleep for 1 minute before checking again
}