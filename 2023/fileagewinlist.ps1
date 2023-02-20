# Define the path and age threshold of the files to monitor
$folderPath = "C:\Path\To\Folder"
$maxAgeInMinutes = 30

# Continuously monitor the age of the files
while($true) {
    # Get the list of files in the folder and their ages
    $files = Get-ChildItem $folderPath | Where-Object { $_.LastWriteTime -lt (Get-Date).AddMinutes(-$maxAgeInMinutes) }
    
    # Check if any files are older than the threshold
    if($files.Count -gt 0) {
        Write-Host "The following files are older than $maxAgeInMinutes minutes:"
        foreach($file in $files) {
            Write-Host $file.Name
        }
    }
    
    # Wait for some time before checking the files again
    Start-Sleep -Seconds 60
}
