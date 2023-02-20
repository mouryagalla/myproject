# Define the paths to the text files
$file1 = "C:\path\to\file1.txt"
$file2 = "C:\path\to\file2.txt"
$file3 = "C:\path\to\file3.txt"

# Read the contents of the text files
$content1 = Get-Content $file1
$content2 = Get-Content $file2
$content3 = Get-Content $file3

# Output the contents of the text files in three lines
Write-Host $content1
Write-Host $content2
Write-Host $content3
