$file = "d:\Andres\Dev\EPSA-Compras\model\database_staging_fixed.json"
$content = [System.IO.File]::ReadAllText($file)

$find = @"
            "lineageTag": "f1a2b3c4-d5e6-7890-abcd-ef0123456718"
          }
        ]
      }
    ],
    "relationships": [
"@

$replace = @"
            "lineageTag": "f1a2b3c4-d5e6-7890-abcd-ef0123456718"
          },
          {
            "name": "Gasto Promedio Mensual USD",
            "expression": "\nAVERAGEX(\n    VALUES(Calendario[Fiscal Month]),\n    [Gasto Recepciones USD]\n)\n",
            "formatString": "`$#,0.00",
            "description": "Promedio de gasto mensual en USD sobre los meses fiscales presentes en los datos.",
            "lineageTag": "f1a2b3c4-d5e6-7890-abcd-ef0123456719"
          },
          {
            "name": "Costo Unitario Promedio USD",
            "expression": "\nDIVIDE(\n    [Gasto Recepciones USD],\n    SUM(factRecepcionesHistoria[RecepcionCantidad])\n)\n",
            "formatString": "`$#,0.0000",
            "description": "Costo unitario promedio ponderado en USD. Gasto total / cantidad total recibida.",
            "lineageTag": "f1a2b3c4-d5e6-7890-abcd-ef012345671a"
          },
          {
            "name": "Gasto Proyectado Mes",
            "expression": "\nVAR PromedioMensual = [Gasto Promedio Mensual USD]\nVAR Tendencia =\n    VAR UltimoMes = [Gasto Recepciones USD]\n    RETURN IF(NOT ISBLANK(UltimoMes), DIVIDE(UltimoMes - PromedioMensual, PromedioMensual), 0)\nRETURN\nPromedioMensual * (1 + Tendencia * 0.5)\n",
            "formatString": "`$#,0.00",
            "description": "Proyeccion de gasto para el proximo mes basada en promedio + tendencia suavizada.",
            "lineageTag": "f1a2b3c4-d5e6-7890-abcd-ef012345671b"
          },
          {
            "name": "Recepcion Cantidad Total",
            "expression": "\nSUM(factRecepcionesHistoria[RecepcionCantidad])\n",
            "formatString": "#,0.00",
            "description": "Cantidad total recibida en recepciones. Base para calculo de costo unitario.",
            "lineageTag": "f1a2b3c4-d5e6-7890-abcd-ef012345671c"
          },
          {
            "name": "Ticket Promedio USD",
            "expression": "\nDIVIDE([Gasto Recepciones USD], [Cantidad Recepciones])\n",
            "formatString": "`$#,0.00",
            "description": "Valor promedio por recepcion en USD. Indicador de eficiencia de compras.",
            "lineageTag": "f1a2b3c4-d5e6-7890-abcd-ef012345671d"
          }
        ]
      }
    ],
    "relationships": [
"@

if ($content.Contains("Gasto Promedio Mensual USD")) {
    Write-Output "ALREADY EXISTS"
} elseif ($content.Contains("f1a2b3c4-d5e6-7890-abcd-ef0123456718")) {
    $newContent = $content.Replace($find, $replace)
    if ($newContent -eq $content) {
        Write-Output "REPLACE FAILED - pattern not matched"
        # Try to show what's around that tag
        $idx = $content.IndexOf("f1a2b3c4-d5e6-7890-abcd-ef0123456718")
        Write-Output "Context around tag:"
        Write-Output $content.Substring([Math]::Max(0, $idx - 100), 300)
    } else {
        [System.IO.File]::WriteAllText($file, $newContent, [System.Text.Encoding]::UTF8)
        Write-Output "SUCCESS - Phase 6 measures added to _fixed.json"
    }
} else {
    Write-Output "TAG NOT FOUND"
}
