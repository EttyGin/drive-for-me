# Install Xming
Write-Host "Make sure Xming is installed and running."

# Validate and Set the DISPLAY Environment Variable
Write-Host "Checking if DISPLAY environment variable is set..."
$DISPLAY = [System.Environment]::GetEnvironmentVariable("DISPLAY", [System.EnvironmentVariableTarget]::User)

if (-not $DISPLAY) {
    Write-Host "DISPLAY variable is not set. Setting it now..."
    [System.Environment]::SetEnvironmentVariable("DISPLAY", "localhost:0.0", [System.EnvironmentVariableTarget]::User)
    $DISPLAY = [System.Environment]::GetEnvironmentVariable("DISPLAY", [System.EnvironmentVariableTarget]::User)
    Write-Host "DISPLAY variable set to $DISPLAY"
} else {
    Write-Host "DISPLAY variable is already set to $DISPLAY"
}

# Validate Xming is Running
Write-Host "Checking if Xming process is running..."
$XmingProcess = Get-Process -Name Xming -ErrorAction SilentlyContinue

if ($XmingProcess) {
    Write-Host "Xming is running."
} else {
    Write-Host "Xming is NOT running. Please start Xming."
}

# Ensure port 6000 is listening
Write-Host "Checking if port 6000 is listening..."
$PortListening = netstat -aon | findstr 6000

if ($PortListening) {
    Write-Host "Port 6000 is listening."
} else {
    Write-Host "Port 6000 is NOT listening. Please make sure Xming is configured correctly."
}

# Final Check
if ($DISPLAY -and $XmingProcess -and $PortListening) {
    Write-Host "OK! Everything is set up correctly."
} else {
    Write-Host "Something is not set up correctly. Please check the output above."
}
