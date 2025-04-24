Here is the formatted PowerShell code with comments explaining each section:

```powershell
# Parameters (update with your actual values)
# Set the Application Insights Instrumentation Key and ingestion endpoint URI
$instrumentationKey = "<ApplicationInsightInstrumentationKey>"
$uri = "https://dc.services.visualstudio.com/v2/track" # Application Insights ingestion endpoint

# Prepare the payload to send custom event data to Application Insights
$payload = @{
    "name" = "Microsoft.ApplicationInsights.Event" # Event type
    "time" = (Get-Date).ToString("o")  # Current timestamp in ISO 8601 format
    "iKey" = $instrumentationKey # Instrumentation key for Application Insights
    "data" = @{
        "baseType" = "EventData" # Base type of the telemetry data
        "baseData" = @{
            "name" = "CustomEvent" # Name of the custom event
            "properties" = @{ # Additional properties for the event
                "TempUsageKB" = 2048 # Example data: Temporary usage in KB
                "Directory" = "D:\\local\\Temp" # Example data: Directory being monitored
                "Status" = "OK" # Example status of the monitored directory
            }
        }
    }
}

# Convert the payload to JSON format for transmission
$jsonPayload = $payload | ConvertTo-Json -Depth 10

# Prepare headers for the HTTP request
$headers = @{
    "Content-Type" = "application/json" # Specify the content type as JSON
}

# Try to send the request to Application Insights
try {
    # Send the HTTP POST request to the Application Insights ingestion endpoint
    $response = Invoke-RestMethod -Method Post -Uri $uri -Body $jsonPayload -Headers $headers -ContentType "application/json" -ErrorAction Stop

    # If the request is successful, output a success message and the response for debugging
    Write-Output "Successfully sent event data to Application Insights."
    Write-Output "Response: $($response | ConvertTo-Json)"
} catch {
    # If an error occurs, output an error message with details
    Write-Error "Failed to send event data to Application Insights. Error: $_"
}
```

This code sends custom telemetry data to Azure Application Insights. Adjust the parameters (`$instrumentationKey`, etc.) to align with your actual setup.
