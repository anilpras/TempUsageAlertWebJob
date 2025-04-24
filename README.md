# TempUsageAlertWebJob

This repository contains the code and instructions for creating a Timer Trigger WebJob to monitor temporary usage alerts for Azure App Services.
Refer - https://github.com/projectkudu/kudu/wiki/Understanding-the-Azure-App-Service-file-system

---

## Overview

This project will help you:
1. Create a **Timer Trigger WebJob** with a PowerShell script.
2. Set up a **Custom Log Search-based Alert** in Azure Monitor to track temporary usage.

---

## Steps to Set Up

### 1. Create a Timer Trigger WebJob
- Use the PowerShell script **`WebjobTempUsage.ps1`** to create a Timer Trigger WebJob.
  refer - https://github.com/anilpras/TempUsageAlertWebJob/blob/main/WebjobTempUsage.ps1 

### 2. Create a Custom Log Search-Based Alert
- Follow the steps discussed in the [Azure Monitor Alerts Tutorial](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/tutorial-log-alert).
- Use the query below or modify it as per your requirements:

#### Log Search Query Example
```kusto
customEvents
| where name == "CustomEvent"
| extend TempUsageKB = todouble(tostring(parse_json(tostring(customDimensions))["TempUsageKB"]))
| project timestamp, TempUsageKB
| where TempUsageKB > 1024
| summarize count() by bin(timestamp, 1m)
| where count_ > 0
```

**Note:**  
- Adjust the condition as per your SKU size and its limit, as discussed in the [Understanding the Azure App Service File System](https://github.com/projectkudu/kudu/wiki/Understanding-the-Azure-App-Service-file-system).  
- For example, the condition `(TempUsageKB > 1024)` is used here as an example.

---

## Prerequisites

- An Azure subscription.
- Basic knowledge of Azure Monitor and Azure WebJobs.
- Access to Azure App Service.

---

## References

- [Azure Monitor Alerts Tutorial](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/tutorial-log-alert)
- [Understanding the Azure App Service File System](https://github.com/projectkudu/kudu/wiki/Understanding-the-Azure-App-Service-file-system)

---

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any suggestions or improvements.

---

