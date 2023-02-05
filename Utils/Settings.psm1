[bool]$script:disableSSL = $false
[bool]$script:autoSave = $false
[bool]$script:verifyJson = $true
[bool]$script:verifyXml = $true
[bool]$script:forceTls12 = $false
[string]$script:autoSavePrefix = ''

function SetDisableSSL([bool]$disableSSL) {
    $script:disableSSL = $disableSSL
}

function GetDisableSSL() {
    return $script:disableSSL
}

function SetAutoSave([bool] $autoSave) {
    $script:autoSave = $autoSave
}

function GetAutoSave() {
    return $script:autoSave
}

function SetVerifyJson([bool]$verifyJson) {
    $script:verifyJson = $verifyJson
}

function GetVerifyJson() {
    return $script:verifyJson
}

function SetVerifyXml([bool]$verifyXml) {
    $script:verifyXml = $verifyXml
}

function GetVerifyXml() {
    return $script:verifyXml
}

function SetAutoSavePrefix([string]$autoSavePrefix) {
    $script:autoSavePrefix = $autoSavePrefix
}

function GetAutoSavePrefix () {
    return $script:autoSavePrefix
}

function SetForceTls12([bool]$forceTls12) {
    $script:forceTls12 = $forceTls12
}

function GetForceTls12() {
    return $script:forceTls12
}

Export-ModuleMember -Function SetDisableSSL, GetDisableSSL, SetAutoSave, GetAutoSave, SetVerifyJson, GetVerifyJson, SetVerifyXml, GetVerifyXml, SetAutoSavePrefix, GetAutoSavePrefix, SetForceTls12, GetForceTls12
