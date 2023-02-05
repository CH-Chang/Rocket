$script:data = $null

function ReadData([string]$filepath) {
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
                    (-not ($record.body.content -is [System.Management.Automation.PSCustomObject]))) {
                    $invalid = $true
                    break
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

function WriteData() {

}

function SaveData() {

}

function GetData() {
    return $script:data
}

function LoadData([string]$name) {

}
