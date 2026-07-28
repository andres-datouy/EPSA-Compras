$basePath = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages\1ed94661679c4bbd9aa7\visuals"
$schema = "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.10.0/schema.json"

function New-CardVisual($name, $x, $y, $z, $entity, $property, $nativeRef) {
    $obj = [ordered]@{
        '$schema' = $schema
        name = $name
        position = [ordered]@{ x = $x; y = $y; z = $z; height = 200; width = 660; tabOrder = $z }
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
$json = New-CardVisual "c1d2e3f4a5b600030001" 20 10 0 "Medidas_Compras" "Compras Totales USD YTD" "Compras YTD USD"
Set-Content "$basePath\c1d2e3f4a5b600030001\visual.json" $json -Encoding UTF8
Write-Output "Card 1 done"

# Card 2: Variacion Compras %
$json = New-CardVisual "c1d2e3f4a5b600030002" 700 10 1 "Medidas_Compras" "Variacion Compras %" "Variacion %"
Set-Content "$basePath\c1d2e3f4a5b600030002\visual.json" $json -Encoding UTF8
Write-Output "Card 2 done"

# Card 3: Proveedor Concentracion %
$json = New-CardVisual "c1d2e3f4a5b600030003" 1380 10 2 "Medidas_Compras" "Proveedor Concentracion %" "Concentracion %"
Set-Content "$basePath\c1d2e3f4a5b600030003\visual.json" $json -Encoding UTF8
Write-Output "Card 3 done"

# Card 4: On Time Delivery %
$json = New-CardVisual "c1d2e3f4a5b600030004" 2060 10 3 "Medidas_Compras" "On Time Delivery %" "On Time %"
Set-Content "$basePath\c1d2e3f4a5b600030004\visual.json" $json -Encoding UTF8
Write-Output "Card 4 done"

# Card 5: Ticket Promedio USD
$json = New-CardVisual "c1d2e3f4a5b600030005" 2740 10 4 "Medidas_Compras" "Ticket Promedio USD" "Ticket Promedio"
Set-Content "$basePath\c1d2e3f4a5b600030005\visual.json" $json -Encoding UTF8
Write-Output "Card 5 done"

Write-Output "All cards created"
