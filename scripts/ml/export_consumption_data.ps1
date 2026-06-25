# Export consumption data from staging for ML prototype
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    $connStr = "Server=localhost,1435;Database=staging_compras;Integrated Security=True;Connect Timeout=30"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()

    $cmd = $conn.CreateCommand()
    $cmd.CommandText = @"
    SELECT 
        cod_articulo as ArticuloCodigo,
        fec_doc as Fecha,
        ABS(cantidad) as Cantidad,
        formulario as Documento
    FROM dbo.stg_factConsumo
    WHERE formulario <> 'recstktr'
        AND fec_doc >= DATEADD(YEAR, -5, GETDATE())
        AND cantidad <> 0
"@
    $cmd.CommandTimeout = 300
    
    $adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
    $dt = New-Object System.Data.DataTable
    $rows = $adapter.Fill($dt)
    
    Write-Output "Exported $rows rows"
    
    # Export to CSV
    $csvPath = "C:\temp\consumo_historia_ml.csv"
    if (-not (Test-Path "C:\temp")) { New-Item -ItemType Directory -Path "C:\temp" -Force | Out-Null }
    $dt | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
    Write-Output "Saved to $csvPath"
    
    $conn.Close()
}

# Copy file back to local machine
$outputDir = "d:\Andres\Dev\EPSA-Compras\docs\ml_output"
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

$session = New-PSSession -ComputerName 192.168.2.47 -Credential $cred
Copy-Item -FromSession $session -Path "C:\temp\consumo_historia_ml.csv" -Destination "$outputDir\consumo_historia_ml.csv" -Force
Remove-PSSession $session

$size = (Get-Item "$outputDir\consumo_historia_ml.csv").Length / 1MB
Write-Output "File copied: $([math]::Round($size,1)) MB"
