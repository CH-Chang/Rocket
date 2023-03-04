$script:data = $null

function ReadAllData([string]$filepath) {
    $data = $null
    try {
        $data = (Get-Content -Path $filepath | ConvertFrom-Json)
    } catch {
        [System.Windows.Forms.MessageBox]::Show(
            "讀取並解析JSON檔案錯誤",
            '錯誤',
            [System.Windows.Forms.MessageBoxButtons]::Error,
            [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        return
    }

    $invalid = $false
    if (-not $data -is [array]) {
        $invalid = $true
    }

    if (-not $invalid) {
        foreach ($record in $data) {
            $properties = Get-Member -InputObject $record -MemberType Properties -Name 'name'
            if ($null -eq $properties) {
                $invalid = $true
                break
            }

            if (-not ($record.name -is [string])) {
                $invalid = $true
                break
            }

            $properties = Get-Member -InputObject $record -MemberType Properties -Name 'url'
            if ($null -eq $properties) {
                $invalid = $true
                break
            }

            if (-not ($record.url -is [string])) {
                $invalid = $true
                break
            }

            $properties = Get-Member -InputObject $record -MemberType Properties -Name 'method'
            if ($null -eq $properties) {
                $invalid = $true
                break
            }

            if (-not ($record.method -is [string])) {
                $invalid = $true
                break
            }

            $properties = Get-Member -InputObject $record -MemberType Properties -Name 'headers'
            if ($null -ne $properties) {
                if (-not ($record.headers -is [System.Management.Automation.PSCustomObject])) {
                    $invalid = $true
                    break
                }
            }

            $properties = Get-Member -InputObject $record -MemberType Properties -Name 'body'
            if ($null -ne $properties) {
                if (-not ($record.body -is [System.Management.Automation.PSCustomObject])) {
                    $invalid = $true
                    break
                }

                $properties = Get-Member -InputObject $record.body -MemberType Properties -Name 'type'
                if ($null -eq $properties) {
                    $invalid = $true
                    break
                }

                if (-not ($record.body.type -is [string])) {
                    $invalid = $true
                    break
                }

                $properties = Get-Member -InputObject $record.body -MemberType Properties -Name 'content'
                if ($null -eq $properties) {
                    $invalid = $true
                    break
                }

                if ((-not ($record.body.content -is [string])) -and
                    (-not ($record.body.content -is [array]))) {
                    $invalid = $true
                    break
                }

                if ($record.body.content -is [array]) {
                    foreach ($iData in $record.body.content) {
                        $properties = Get-Member -InputObject $iData -MemberType Properties -Name 'name'
                        if ($null -eq $properties) {
                            $invalid = $true
                            break
                        }

                        if (-not ($iData.name -is [string])) {
                            $invalid = $true
                            break
                        }

                        $properties = Get-Member -InputObject $iData -MemberType Properties -Name 'type'
                        if ($null -eq $properties) {
                            $invalid = $true
                            break
                        }

                        if (-not ($iData.type -is [string])) {
                            $invalid = $true
                            break
                        }

                        $properties = Get-Member -InputObject $iData -MemberType Properties -Name 'text'
                        if ($null -eq $properties) {
                            $invalid = $true
                            break
                        }

                        if (-not ($iData.text -is [string])) {
                            $invalid = $true
                            break
                        }
                    }

                    if ($invalid) {
                        break
                    }
                }
            }
        }
    }

    if ($invalid) {
        [System.Windows.Forms.MessageBox]::Show(
            "請確認記錄檔格式，非法記錄檔",
            '錯誤',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
        return
    }

    $script:data = $data
}

function WriteAllData([string]$filepath) {
    $object = $script:data | Select-Object -Property *

    $content = $null
    if ($object -is [System.Management.Automation.PSCustomObject]) {
        $content =  ConvertTo-Json -InputObject @($object)
    } else {
        $content = $object | ConvertTo-Json
    }


    $content | Out-File -FilePath $filepath -Encoding utf8 -Force
}

function GetAllData() {
    return $script:data
}

function RemoveTargetData([string]$target) {
    $script:data = $script:data | Where-Object { $_.name -ne $target }
}

function SaveTargetData(
    [string]$name,
    [string]$method,
    [string]$url,
    [System.Collections.Generic.Dictionary[[string],[string]]]$headers,
    [string]$contentType,
    $body) {

    if ($null -eq $script:data) {
        $script:data = @()
    }

    $targetData = [PSCustomObject]@{
        name = $name
        method = $method
        url = $url
        headers = [hashtable]$headers
        body = @{
            type = $contentType
            content = [hashtable]$body
        }
    }

    $script:data = $script:data + @($targetData)
}

function LoadTargetData([string]$target) {
    for ($i=0; $i -lt $script:data.Length; $i++) {
        $data = $script:data[$i]

        $name = $data.name
        if ($target -ne $name) {
            continue
        }

        $method = $data.method
        $url = $data.url

        $headers = $null
        if ($null -ne $data.headers) {
            $headers = New-Object System.Collections.Generic.Dictionary'[String,String]'
            $keys = ($data.headers | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name)
            for ($j=0; $j -lt $keys.Length; $j++) {
                $key = $keys[$j]
                $value = $data.headers[$key]
                $headers.Add($key, $value)
            }
        }

        $contentType = $null
        $body = $null
        if ($null -ne $data.body) {
            $contentType = $data.body.type

            if ($data.body.content -is [string]) {
                $body = $data.body.content
            } elseif ($data.body.content -is [array]) {
                $body = New-Object System.Collections.Generic.List[object]
                foreach ($contentItem in $data.body.content) {
                    $row = New-Object System.Collections.Generic.Dictionary'[String,String]'
                    $row.Add('type', $contentItem.type)
                    $row.Add('name', $contentItem.name)
                    $row.Add('text', $contentItem.text)
                    $body.Add($row)
                }
            }
        }

        return @($true, $method, $url, $headers, $contentType, $body)
    }

    return @($false, $null, $null, $null, $null, $null)
}
