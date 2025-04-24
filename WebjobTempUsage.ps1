# Parameters (update with your actual values)
$instrumentationKey = "<ApplicationInsightInstrumentationKey>"
$uri = "https://dc.services.visualstudio.com/v2/track" # Application Insights ingestion endpoint


# Prepare the payload (custom event telemetry)
$payload = @{
    "name" = "Microsoft.ApplicationInsights.Event"
    "time" = (Get-Date).ToString("o")  # Time of the event in ISO 8601 format
    "iKey" = $instrumentationKey
    "data" = @{
        "baseType" = "EventData"
        "baseData" = @{
            "name" = "CustomEvent"
            "properties" = @{
                "TempUsageKB" = 2048
                "Directory" = "D:\\local\\Temp"
                "Status" = "OK"
            }
        }
    }
}

# Convert the payload to JSON
$jsonPayload = $payload | ConvertTo-Json -Depth 10

# Prepare headers
$headers = @{
    "Content-Type" = "application/json"
}

# Try to send the request to Application Insights
try {
    # Send the request to the Application Insights ingestion endpoint
    $response = Invoke-RestMethod -Method Post -Uri $uri -Body $jsonPayload -Headers $headers -ContentType "application/json" -ErrorAction Stop

    # If successful, output the response for debugging
    Write-Output "Successfully sent event data to Application Insights."
    Write-Output "Response: $($response | ConvertTo-Json)"
} catch {
    # Error handling
    Write-Error "Failed to send event data to Application Insights. Error: $_"
}
