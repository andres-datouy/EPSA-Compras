$basePath = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages\c1319fc1107143b197f1\visuals"
$schema = "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.10.0/schema.json"

function New-CardVisual($name, $x, $y, $z, $entity, $property, $nativeRef) {
    $obj = [ordered]@{
        '$schema' = $schema
        name = $name
        position = [ordered]@{ x = $x; y = $y; z = $z; height = 200; width = 1100; tabOrder = $z }
        visual = [ordered]@{
            visualType = "card"
            query = [ordered]@{
                queryState = [ordered]@{
                    Values = [ordered]@{
                        projections = @(
                            [ordered]@{
                                field = [ordered]@{
                                    Measure = [ordered]@{
                                        Expression = [ordered]@{
                                            SourceRef = [ordered]@{ Entity = $entity }
                                        }
                                        Property = $property
                                    }
                                }
                                queryRef = "$entity.$property"
                                nativeQueryRef = $nativeRef
                            }
                        )
                    }
                }
            }
            objects = [ordered]@{
                categoryLabels = @(
                    [ordered]@{
                        properties = [ordered]@{
                            show = [ordered]@{
                                expr = [ordered]@{
                                    Literal = [ordered]@{ Value = "true" }
                                }
                            }
                        }
                    }
                )
            }
            drillFilterOtherVisuals = $true
        }
    }
    return $obj | ConvertTo-Json -Depth 20
}

# Card 1: Compras Totales USD YTD
$json = New-CardVisual "d1e2f3a4b5c600040001" 20 10 0 "Medidas_Compras" "Compras Totales USD YTD" "Gasto YTD USD"
Set-Content "$basePath\d1e2f3a4b5c600040001\visual.json" $json -Encoding UTF8
Write-Output "Card 1 done"

# Card 2: Gasto Promedio Mensual USD
$json = New-CardVisual "d1e2f3a4b5c600040002" 1140 10 1 "Medidas_Compras" "Gasto Promedio Mensual USD" "Promedio Mensual USD"
Set-Content "$basePath\d1e2f3a4b5c600040002\visual.json" $json -Encoding UTF8
Write-Output "Card 2 done"

# Card 3: Gasto Proyectado Mes
$json = New-CardVisual "d1e2f3a4b5c600040003" 2260 10 2 "Medidas_Compras" "Gasto Proyectado Mes" "Proyeccion Proximo Mes"
Set-Content "$basePath\d1e2f3a4b5c600040003\visual.json" $json -Encoding UTF8
Write-Output "Card 3 done"

Write-Output "All cards created"
