# Parameters (update with your actual values)
$instrumentationKey = "93187c56-b4e9-4aa5-a494-148fb5d5dc64"
$uri = "https://dc.services.visualstudio.com/v2/track" # Application Insights ingestion endpoint

# Directories to check
$directories = @("D:\local\Temp", "D:\local\AppData", "D:\local\ProgramData")

# Initialize variables
$totalSizeKB = 0
$dirSizes = @{}

foreach ($dir in $directories) {
    if (Test-Path $dir) {
        $size = (Get-ChildItem -Path $dir -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer } | Measure-Object -Property Length -Sum).Sum / 1KB
        $dirSizes[$dir] = [math]::Round($size, 2)
        $totalSizeKB += $size
    } else {
        $dirSizes[$dir] = "NotFound"
    }
}

# Prepare the payload (custom event telemetry)
$payload = @{
    "name" = "Microsoft.ApplicationInsights.Event"
    "time" = (Get-Date).ToString("o")  # ISO 8601 time format
    "iKey" = $instrumentationKey
    "data" = @{
        "baseType" = "EventData"
        "baseData" = @{
            "name" = "CustomEvent"
            "properties" = @{
                "TempUsageKB"     = [math]::Round($totalSizeKB, 2)
                "TempDirectoryKB" = $dirSizes["D:\local\Temp"]
                "AppDataKB"       = $dirSizes["D:\local\AppData"]
                "ProgramDataKB"   = $dirSizes["D:\local\ProgramData"]
                "Status"          = "OK"
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
    $response = Invoke-RestMethod -Method Post -Uri $uri -Body $jsonPayload -Headers $headers -ErrorAction Stop
    Write-Output "Successfully sent event data to Application Insights."
    Write-Output "Response: $($response | ConvertTo-Json)"
} catch {
    Write-Error "Failed to send event data to Application Insights. Error: $_"
}
