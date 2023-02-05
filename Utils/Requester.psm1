function Request(
    [string]$requestMethod,
    [string]$requestUrl,
    [string]$requestContentType,
    [System.Collections.Generic.Dictionary[[string],[string]]]$requestHeaders,
    $requestBody) {
    try {
        $response = $null
        if ($null -ne $requestContentType -and
            $null -ne $requestHeaders -and
            $null -ne $requestBody) {
            $response = (Invoke-WebRequest -Method $requestMethod -Uri $requestUrl)
        } elseif (
            $null -ne $requestHeaders -and
            $null -ne $requestBody) {
            $response = (Invoke-WebRequest -Method $requestMethod -Uri $requestUrl -ContentType $requestContentType)
        } elseif ($null -ne $requestBody) {
            $response = (Invoke-WebRequest -Method $requestMethod -Uri $requestUrl -ContentType $requestContentType -Headers $requestHeaders)
        } else {
            $response = (Invoke-WebRequest -Method $requestMethod -Uri $requestUrl -ContentType $requestContentType -Headers $requestHeaders -Body $requestBody)
        }

        $responseStatusCode = $response.StatusCode
        $responseHeaders = $response.Headers
        $responseBody = $response.Content

        return @($true, '請求成功', $responseStatusCode, $responseHeaders, $responseBody)
    } catch [System.Net.WebException] {

        [System.Net.WebExceptionStatus]$responseStatus = $_.Exception.Status
        if ($responseStatus -ne [System.Net.WebExceptionStatus]::ProtocolError) {
            return @($false, "發生異常: {$_.Exception.Message}", $null, $null, $null)
        }

        [System.Net.WebResponse]$response = $_.Exception.Response

        [int]$responseStatusCode = $response.StatusCode

        $responseBodyStream = $response.GetResponseStream()
        $responseBodyStream.Position = 0 | Out-Null
        $responseBodyStream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null

        $streamReader = New-Object System.IO.StreamReader $responseBodyStream
        $responseBody = $streamReader.ReadToEnd()
        $streamReader.Close() | Out-Null

        $responseRawHeaders = $response.Headers
        $responseHeaders = New-Object System.Collections.Generic.Dictionary'[String,String]'
        for ($i = 0; $i -lt $responseRawHeaders.Count; $i++) {
            $name = $responseRawHeaders.GetKey($i)
            $value = $responseRawHeaders.GetValues($i)[0]
            $responseHeaders.Add($name, $value)
        }

        return @($true, '請求失敗', $responseStatusCode, $responseHeaders, $responseBody)
    } catch [System.Exception] {
        return @($false, "發生未知異常: {$_.Exception.Message}", $null, $null, $null)
    }
}

Export-ModuleMember -Function Request
