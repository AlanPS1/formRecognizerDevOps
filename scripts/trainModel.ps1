#
# Notice: Any links, references, or attachments that contain sample scripts, code, or commands comes with the following notification.
#
# This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
#
# We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code,
# provided that You agree:
#
# (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded;
# (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and
# (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits,
# including attorneys’ fees, that arise or result from the use or distribution of the Sample Code.
#
# Please note: None of the conditions outlined in the disclaimer above will superseded the terms and conditions contained within the Premier Customer Services Description.
#
# DEMO POC - "AS IS"
#

param(    
    [Parameter(Mandatory = $true)]
    [Security.SecureString]$functionEndpoint,
    [Parameter(Mandatory = $true)]
    [int]$runnumber
)

$header = @{      
    "Content-Type"="application/json"
  } 

try {
    
    $decryptedEndpoint = ConvertFrom-SecureString $functionEndpoint -AsPlainText
    # $decryptedEndpoint = $functionEndpoint # aw testing - it works locally as no need to decrypt a secret

    # original
    # $modelId = New-Guid

    # first mess abbout
    # $stringDate = Get-Date -Format "dd-MM-yy"
    # $modelId = "cv-$stringDate-v0.$($($(New-Guid) -split "-", 3)[1])"

    # 2nd - plain date and time string to show new version of sorts
    # $modelId = Get-Date -Format "dd-MM-yy-HH-mm-ss"

    # 3rd 
    $modelId = "dev-train-action-$runnumber"

    $description = "Train Model #$($runnumber): Triggered from Github Action"

    $body = @{
        "modelId"="$modelId"
        "description"="$description"        
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri $decryptedEndpoint -Method 'Post' -Headers $header -Body $body
    
    if ($response.StatusCode -ne 200) {
        throw "Error, statusCode: $response.StatusCode"
    }

    return $modelId
}
catch {
    Write-Host "An Error Occured: $($_.Exception.Message)"; Write-Host "An Error Occured 2: $($_.Exception)"
}

