function Request(
    [string]$method,
    [string]$url,
    [string]$contentType,
    [System.Collections.Generic.Dictionary[[string],[string]]]$body) {
    Write-Host 'Request'
}

Export-ModuleMember -Function Request
