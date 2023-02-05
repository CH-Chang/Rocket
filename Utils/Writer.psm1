Import-Module '.\Utils\Settings.psm1'

$script:saveDirectory = "$(Get-Location)\Records"

function WriteRecord(
    [string]$requestMethod,
    [string]$requestUrl,
    [string]$requestContentType,
    [System.Collections.Generic.Dictionary[[string],[string]]]$requestHeaders,
    $requestBody,
    [int]$responseStatusCode,
    [System.Collections.Generic.Dictionary[[string],[string]]]$responseHeaders,
    [string]$responseBody
) {
    $prefix = GetAutoSavePrefix

    $content = ''
    $content += "請求方法: $requestMethod`n"
    $content += "請求路徑: $requestUrl`n"

    if ($null -ne $requestContentType) {
        $content += "請求類型: $requestContentType`n"
    }

    if ($null -ne $requestHeaders) {
        $content += "請求標頭:`n"
        foreach ($name in $requestHeaders.Keys) {
            $value = $requestHeaders[$name]
            $content += "$name=$value`n"
        }
    }

    if ($null -ne $requestBody) {
        $content += "請求身體:`n"

        if ($requestBody -is [string]) {
            $conetnt += "$requestBody`n"
        }

        if ($requestBody -is [System.Collections.Generic.Dictionary[[string],[object]]]) {
            foreach ($name in $requestBody.Keys) {
                $value = $requestBody[$name]

                if ($value -is [string]) {
                    $content += "$name=$value`n"
                } else {
                    $content += "$name=[省略紀錄]`n"
                }
            }
        }
    }

    if ($null -ne $responseStatusCode) {
        $content += "`n回應狀態: $responseStatusCode`n"
    }

    if ($null -ne $responseHeaders) {
        $content += "回應標頭:`n"
        foreach ($name in $responseHeaders.Keys) {
            $value = $responseHeaders[$name]
            $content += "$name=$value`n"
        }
    }

    if ($null -ne $responseBody) {
        $content += "回應內容:`n$responseBody`n"
    }

    $filename = ''
    if ($prefix -ne '') {
        $filename += "$prefix_"
    }
    $filename += "$(Get-Date -Format FileDateTime)_$(Get-Random -Minimum 10000 -Maximum 99999).txt"

    $filepath = "$saveDirectory\$filename"

    New-Item -Path $saveDirectory -ItemType Directory -Force | Out-Null
    $content | Out-File $filepath -Encoding utf8 | Out-Null
}
