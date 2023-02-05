function Request(
    [string]$method,
    [string]$url,
    [string]$contentType,
    [System.Collections.Generic.Dictionary[[string],[string]]]$headers,
    [System.Collections.Generic.Dictionary[[string],[object]]]$body) {
    Write-Host 'Request'
}

Export-ModuleMember -Function Request
