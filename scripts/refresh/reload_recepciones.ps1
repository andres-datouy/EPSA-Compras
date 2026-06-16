# Update SP to use '1900-01-01' for full load (gets ALL history), then execute
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    
    $connStr = "Server=localhost,1435;Database=staging_compras;Integrated Security=True;Connect Timeout=10"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()
    $output += "Connected with Windows auth"
    
    # Step 1: Alter SP to use '1900-01-01' in FULL mode instead of '2020-01-01'
    $output += "`nStep 1: Updating SP to load ALL history..."
    $alterCmd = $conn.CreateCommand()
    $alterCmd.CommandText = @"
CREATE OR ALTER PROC dbo.sp_refresh_factRecepcionesHistoria 
    @mode NVARCHAR(20) = 'INCREMENTAL'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;
    DECLARE @maxDate DATE = ISNULL(
        (SELECT MAX(RecepcionFecha) FROM dbo.stg_factRecepcionesHistoria), 
        '2020-01-01');

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_factRecepcionesHistoria', @mode, @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        IF @mode = 'FULL'
        BEGIN
            TRUNCATE TABLE dbo.stg_factRecepcionesHistoria;
            SET @maxDate = '1900-01-01';
        END
        ELSE
        BEGIN
            -- Delete rows from the last known date to re-process partial days
            DELETE FROM dbo.stg_factRecepcionesHistoria 
            WHERE RecepcionFecha >= @maxDate;
        END

        INSERT INTO dbo.stg_factRecepcionesHistoria
        SELECT * FROM [192.168.2.7].[EPSA_BI].[dbo].[vw_ComprasBI_HistoriaRecepciones]
        WHERE RecepcionFecha >= @maxDate;

        SET @rowCount = @@ROWCOUNT;
        UPDATE dbo.stg_refresh_log SET end_time = SYSUTCDATETIME(), 
            rows_affected = @rowCount, status = 'SUCCESS' WHERE log_id = @logId;
        PRINT 'factRecepcionesHistoria: ' + CAST(@rowCount AS VARCHAR) + ' rows (' + @mode + ')';
    END TRY
    BEGIN CATCH
        UPDATE dbo.stg_refresh_log SET end_time = SYSUTCDATETIME(), 
            status = 'ERROR', error_message = ERROR_MESSAGE() WHERE log_id = @logId;
        THROW;
    END CATCH
END
"@
    $alterCmd.CommandTimeout = 30
    try {
        $alterCmd.ExecuteNonQuery()
        $output += "  SP updated successfully"
    } catch {
        $output += "  SP update FAILED: $($_.Exception.Message.Substring(0, [Math]::Min(120, $_.Exception.Message.Length)))"
        $conn.Close()
        return $output
    }
    
    # Step 2: Execute FULL reload
    $output += "`nStep 2: Executing FULL reload (expecting ~50K rows)..."
    $execCmd = $conn.CreateCommand()
    $execCmd.CommandText = "EXEC dbo.sp_refresh_factRecepcionesHistoria @mode = 'FULL'"
    $execCmd.CommandTimeout = 600
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $execCmd.ExecuteNonQuery()
        $sw.Stop()
        $output += "  SP completed in $($sw.Elapsed.TotalSeconds.ToString('F1')) seconds"
    } catch {
        $sw.Stop()
        $output += "  SP EXECUTION FAILED: $($_.Exception.Message)"
        $conn.Close()
        return $output
    }
    
    # Step 3: Verify
    $verifyCmd = $conn.CreateCommand()
    $verifyCmd.CommandText = "SELECT COUNT(*), MIN(RecepcionFecha), MAX(RecepcionFecha) FROM dbo.stg_factRecepcionesHistoria"
    $r = $verifyCmd.ExecuteReader()
    if ($r.Read()) {
        $output += "`n=== VERIFICATION ==="
        $output += "  Rows: $($r[0])"
        $output += "  Min date: $($r[1])"
        $output += "  Max date: $($r[2])"
        
        if ($r[0] -ge 49000) {
            $output += "`n  FULL RELOAD SUCCESSFUL - all history loaded!"
        } else {
            $output += "`n  WARNING: Expected ~49,779 rows but got $($r[0])"
        }
    }
    $r.Close()
    
    # Check log
    $logCmd = $conn.CreateCommand()
    $logCmd.CommandText = "SELECT TOP 3 status, rows_affected FROM stg_refresh_log WHERE table_name='stg_factRecepcionesHistoria' ORDER BY log_id DESC"
    $r2 = $logCmd.ExecuteReader()
    $output += "`n=== REFRESH LOG ==="
    while ($r2.Read()) {
        $output += "  Status=$($r2[0]), Rows=$($r2[1])"
    }
    $r2.Close()
    
    $conn.Close()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
