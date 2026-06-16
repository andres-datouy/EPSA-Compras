Get-ChildItem "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report" -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Replace("d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report", "")
    Write-Host "$rel  ($($_.Length) bytes)"
}
