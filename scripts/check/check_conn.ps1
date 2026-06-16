# Test SQL connection as SSAS service account + check column sizes
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    # Test 1: Can SSAS service account connect to SQL?
    Write-Output "=== Test 1: SQL Connection as current user (schaaf_ssas) ==="
    try {
        $conn = New-Object System.Data.SqlClient.SqlConnection
        $conn.ConnectionString = "Data Source=localhost,1435;Initial Catalog=staging_compras;Integrated Security=SSPI;TrustServerCertificate=True"
        $conn.Open()
        Write-Output "OK - Connected as: $($conn.DataSource)"
        
        # Check max length of nom_articulo
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = "SELECT MAX(LEN(nom_articulo)) as max_len, MAX(DATALENGTH(nom_articulo)) as max_bytes FROM [dbo].[stg_dimArticulo]"
        $reader = $cmd.ExecuteReader()
        while ($reader.Read()) {
            Write-Output "nom_articulo: max_len=$($reader['max_len']), max_bytes=$($reader['max_bytes'])"
        }
        $reader.Close()
        
        # Check column definitions
        $cmd2 = $conn.CreateCommand()
        $cmd2.CommandText = "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'stg_dimArticulo' AND COLUMN_NAME = 'nom_articulo'"
        $reader2 = $cmd2.ExecuteReader()
        while ($reader2.Read()) {
            Write-Output "Column def: $($reader2['COLUMN_NAME']) type=$($reader2['DATA_TYPE']) maxlen=$($reader2['CHARACTER_MAXIMUM_LENGTH'])"
        }
        $reader2.Close()
        $conn.Close()
    } catch {
        Write-Output "FAIL: $_"
    }
    
    # Test 2: Check if NT Service\MSOLAP$SSAS has access
    Write-Output ""
    Write-Output "=== Test 2: Check SSAS service account login ==="
    try {
        $conn2 = New-Object System.Data.SqlClient.SqlConnection
        $conn2.ConnectionString = "Data Source=localhost,1435;Initial Catalog=master;User Id=sa;Password=Saas 244050@;TrustServerCertificate=True"
        $conn2.Open()
        $cmd3 = $conn2.CreateCommand()
        $cmd3.CommandText = "SELECT name, type_desc FROM sys.server_principals WHERE name LIKE '%MSOLAP%' OR name LIKE '%SSAS%'"
        $reader3 = $cmd3.ExecuteReader()
        while ($reader3.Read()) {
            Write-Output "  Login: $($reader3['name']) ($($reader3['type_desc']))"
        }
        $reader3.Close()
        
        # Check db_datareader membership
        $cmd4 = $conn2.CreateCommand()
        $cmd4.CommandText = "USE staging_compras; SELECT dp.name, r.name as role_name FROM sys.database_role_members drm JOIN sys.database_principals dp ON dp.principal_id = drm.member_principal_id JOIN sys.database_principals r ON r.principal_id = drm.role_principal_id WHERE dp.name LIKE '%MSOLAP%'"
        $reader4 = $cmd4.ExecuteReader()
        while ($reader4.Read()) {
            Write-Output "  DB Role: $($reader4['name']) -> $($reader4['role_name'])"
        }
        $reader4.Close()
        $conn2.Close()
    } catch {
        Write-Output "FAIL: $_"
    }
}

$result | ForEach-Object { Write-Host $_ }
