function Request(
    [string]$method,
    [string]$url,
    [string]$contentType,
    $body) {
    Write-Host 'Request'
}

Export-ModuleMember -Function Request
