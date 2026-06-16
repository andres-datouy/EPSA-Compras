$udpClient = New-Object System.Net.Sockets.UdpClient
$udpClient.Client.ReceiveTimeout = 5000
$udpClient.Connect('192.168.2.47', 1434)

# Send instance name request for "SSAS"
$instanceName = "SSAS"
$request = [byte[]]@(4) + [System.Text.Encoding]::ASCII.GetBytes($instanceName) + [byte[]]@(0)
$udpClient.Send($request, $request.Length) | Out-Null

$ep = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
try {
    $response = $udpClient.Receive([ref]$ep)
    $text = [System.Text.Encoding]::ASCII.GetString($response)
    Write-Host "SQL Browser response:" -ForegroundColor Green
    Write-Host $text
} catch {
    Write-Host "No response from SQL Browser (UDP 1434 blocked or instance not found): $_" -ForegroundColor Red
    
    # Try all instances (byte 3)
    Write-Host "`nTrying to list all instances..." -ForegroundColor Yellow
    $udpClient2 = New-Object System.Net.Sockets.UdpClient
    $udpClient2.Client.ReceiveTimeout = 5000
    $udpClient2.Connect('192.168.2.47', 1434)
    $req2 = [byte[]]@(3)
    $udpClient2.Send($req2, 1) | Out-Null
    try {
        $resp2 = $udpClient2.Receive([ref]$ep)
        $text2 = [System.Text.Encoding]::ASCII.GetString($resp2)
        Write-Host "All instances:" -ForegroundColor Green
        Write-Host $text2
    } catch {
        Write-Host "UDP 1434 completely blocked: $_" -ForegroundColor Red
    }
    $udpClient2.Close()
}
$udpClient.Close()
