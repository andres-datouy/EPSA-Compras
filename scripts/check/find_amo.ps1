# Find AMO DLL and get schema
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    
    # Search for AMO DLL
    $found = Get-ChildItem "C:\Program Files\Microsoft SQL Server" -Recurse -Filter "Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    foreach ($f in $found) { $output += "Found: $($f.FullName) ($($f.Length) bytes)" }
    
    if ($found.Count -eq 0) {
        # Also check other locations
        $paths = @(
            "C:\Program Files (x86)\Microsoft SQL Server",
            "C:\Program Files\Microsoft Analysis Services",
            "C:\ProgramData\chocolatey\lib"
        )
        foreach ($p in $paths) {
            if (Test-Path $p) {
                $f2 = Get-ChildItem $p -Recurse -Filter "Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
                foreach ($f in $f2) { $output += "Found: $($f.FullName)" }
            }
        }
    }
    
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
