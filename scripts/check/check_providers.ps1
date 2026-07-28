# Quick check for SQL OLE DB providers
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    # Check specific provider DLLs
    $paths = @(
        "C:\Program Files\Microsoft SQL Server\*\MSOLEDBSQL\msolsql*.dll",
        "C:\Windows\System32\sqlncli11.dll",
        "C:\Windows\System32\sqloledb.dll",
        "C:\Program Files\Microsoft SQL Server\*\Shared\msolsql*.dll"
    )
    foreach ($p in $paths) {
        $found = Get-ChildItem -Path $p -ErrorAction SilentlyContinue
        if ($found) { foreach ($f in $found) { Write-Output "Found: $($f.FullName)" } }
    }
    
    # Try a simple OLE DB connection with each provider
    foreach ($provider in @("SQLOLEDB", "SQLNCLI11", "MSOLEDBSQL")) {
        try {
            $conn = New-Object -ComObject "ADODB.Connection"
            $connStr = "Provider=$provider;Data Source=localhost,1435;Initial Catalog=staging_compras;Integrated Security=SSPI"
            $conn.Open($connStr)
            Write-Output "OK: $provider works"
            $conn.Close()
        } catch {
            Write-Output "FAIL: $provider - $($_.Exception.Message.Substring(0, [Math]::Min(100, $_.Exception.Message.Length)))"
        }
    }
}

$result | ForEach-Object { Write-Host $_ }
