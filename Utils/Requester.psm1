Import-Module '.\Utils\Settings.psm1'
Import-Module '.\Utils\Writer.psm1'

function DisableSSL() {
    add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}

function ForceTls12() {
    [System.Net.ServicePointManager]::SecurityProtocol = "tls12, tls11"
}

function Request(
    [string]$requestMethod,
    [string]$requestUrl,
    [string]$requestContentType,
    [System.Collections.Generic.Dictionary[[string],[string]]]$requestHeaders,
    $requestBody) {
    $disableSSL = GetDisableSSL
    if ($disableSSL) {
        DisableSSL
    }

    $forceTls12 = GetForceTls12
    if ($forceTls12) {
        ForceTls12
    }

    $autoSave = GetAutoSave

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

        if ($autoSave) {
            WriteRecord $requestMethod $requestUrl $requestContentType $requestHeaders $requestBody $responseStatusCode $responseHeaders $responseBody
        }

        return @($true, '請求成功', $responseStatusCode, $responseHeaders, $responseBody)
    } catch [System.Net.WebException] {

        [System.Net.WebExceptionStatus]$responseStatus = $_.Exception.Status
        if ($responseStatus -ne [System.Net.WebExceptionStatus]::ProtocolError) {
            if ($autoSave) {
                WriteRecord $requestMethod $requestUrl $requestContentType $requestHeaders $requestBody $null $null $null
            }

            return @($false, "發生異常: $($_.Exception.Message)", $null, $null, $null)
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

        if ($autoSave) {
            WriteRecord $requestMethod $requestUrl $requestContentType $requestHeaders $requestBody $responseStatusCode $responseHeaders $responseBody
        }

        return @($true, '請求失敗', $responseStatusCode, $responseHeaders, $responseBody)
    } catch [System.Exception] {
        if ($autoSave) {
            WriteRecord $requestMethod $requestUrl $requestContentType $requestHeaders $requestBody $null $null $null
        }

        return @($false, "發生未知異常: $($_.Exception.Message)", $null, $null, $null)
    }
}

Export-ModuleMember -Function Request
