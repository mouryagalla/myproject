import requests

# Set up the API endpoint and parameters
endpoint = "https://example.com/api/records"
params = {"page": 1}

# Make the initial API call to get the total number of records and the number of pages
response = requests.get(endpoint, params=params)
data = response.json()
total_records = data["total_records"]
num_pages = data["num_pages"]

# Loop through all the pages and retrieve the records
for page in range(1, num_pages + 1):
    # Set the "page" parameter to the current page
    params["page"] = page
    
    # Make the API call to retrieve the records for the current page
    response = requests.get(endpoint, params=params)
    data = response.json()
    records = data["records"]
    
    # Process the records for the current page
    for record in records:
        # Do something with the record data
        print(record)
