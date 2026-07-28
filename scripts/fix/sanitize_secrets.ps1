# Sanitiza contrasenas hardcodeadas en scripts .ps1 y model JSONs.
# Reemplaza literales por lecturas de .env.local (gitignored).
# El secreto se lee de .env.local para que este script no lo contenga.
$ErrorActionPreference = "Stop"
$root = "d:\Andres\Dev\EPSA-Compras"
$envFile = Join-Path $root ".env.local"

$secret = Get-Content $envFile | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $secret) { throw "SSAS_PASSWORD no encontrado en .env.local" }
$sqlSecret = Get-Content $envFile | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if ($sqlSecret -ne $secret) { Write-Warning "SQL_PASSWORD difiere de SSAS_PASSWORD: revisar mapeo de cuentas" }

$envReadSsas = '$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }'
$envReadSql  = '$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }'

# --- 1. Scripts .ps1 ---
$files = git -C $root grep -l --untracked -F $secret -- "*.ps1"
$modified = 0
foreach ($rel in $files) {
    $f = Join-Path $root ($rel -replace '/', '\')
    $c = [System.IO.File]::ReadAllText($f)
    $orig = $c

    # Fallbacks hardcodeados -> error explicito
    $c = $c.Replace(('if (-not $pass) { $pass = "' + $secret + '" }'), 'if (-not $pass) { throw "SSAS_PASSWORD no encontrado en .env.local" }')
    # Variante SecureString
    $c = $c.Replace(('$pass = ConvertTo-SecureString "' + $secret + '" -AsPlainText -Force'), ($envReadSsas + "`n" + '$pass = ConvertTo-SecureString $pass -AsPlainText -Force'))
    # Asignaciones simples
    $c = $c.Replace(('$pass = "' + $secret + '"'), $envReadSsas)
    $c = $c.Replace(('$ssasPass = "' + $secret + '"'), $envReadSsas.Replace('$pass =', '$ssasPass ='))
    # Credencial de datasource AMO (contexto remoto)
    $c = $c.Replace(('$ds.Credential.Password = "' + $secret + '"'), '$ds.Credential.Password = $using:sqlPass')
    # SQLCMD -P (contexto remoto)
    $c = $c.Replace(('-P "' + $secret + '"'), '-P "$using:sqlPass"')
    # JSON embebido en scripts de build -> placeholder
    $c = $c.Replace(('"password": "' + $secret + '"'), '"password": "__SQL_PASSWORD__"')
    $c = $c.Replace(('Password=' + $secret + ';Persist Security Info=false'), 'Password=__SQL_PASSWORD__;Persist Security Info=false')

    # Connection strings restantes: localhost = contexto remoto ($using:), IP = local
    if ($c.Contains($secret)) {
        $lines = $c -split "(`r`n|`n)"
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i].Contains("Password=" + $secret)) {
                if ($lines[$i] -match "localhost") {
                    $lines[$i] = $lines[$i].Replace("Password=" + $secret, 'Password=$using:sqlPass')
                } else {
                    $lines[$i] = $lines[$i].Replace("Password=" + $secret, 'Password=$sqlPass')
                }
            }
        }
        $c = $lines -join ""
    }

    # Si el script ahora usa $sqlPass pero no lo define, agregar lectura al inicio
    if (($c.Contains('$sqlPass') -or $c.Contains('$using:sqlPass')) -and -not $c.Contains('$sqlPass = Get-Content')) {
        $c = $envReadSql + "`n" + $c
    }

    if ($c.Contains($secret)) { Write-Warning "QUEDA SECRETO en: $rel" }
    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($f, $c, [System.Text.UTF8Encoding]::new($false))
        $modified++
    }
}
Write-Host "Scripts modificados: $modified de $($files.Count)"

# --- 2. Model JSONs: placeholder ---
foreach ($j in @("model\database_staging.json", "model\database_staging_fixed.json")) {
    $f = Join-Path $root $j
    $bytes = [System.IO.File]::ReadAllBytes($f)
    $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
    $c = [System.IO.File]::ReadAllText($f)
    $c2 = $c.Replace(('"password": "' + $secret + '"'), '"password": "__SQL_PASSWORD__"')
    if ($c2 -ne $c) {
        [System.IO.File]::WriteAllText($f, $c2, [System.Text.UTF8Encoding]::new($hasBom))
        Write-Host "Placeholder aplicado: $j"
    }
}

# --- 3. Verificacion final ---
$remaining = git -C $root grep -l --untracked -F $secret
if ($remaining) {
    Write-Warning "ARCHIVOS CON SECRETO RESTANTE:"
    $remaining | ForEach-Object { Write-Warning "  $_" }
} else {
    Write-Host "OK: sin secretos en archivos versionables" -ForegroundColor Green
}
