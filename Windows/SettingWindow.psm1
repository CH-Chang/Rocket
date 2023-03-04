Import-Module '.\Utils\Settings.psm1'

[System.Windows.Forms.Form]$script:window = $null

[System.Windows.Forms.Button]$script:saveButton = $null
[System.Windows.Forms.Button]$script:cancelButton = $null

[System.Windows.Forms.RadioButton]$script:disableSSLRadioButtonEnable = $null
[System.Windows.Forms.RadioButton]$script:disableSSLRadioButtonDisable = $null

[System.Windows.Forms.RadioButton]$script:verifyJsonRadioButtonEnable = $null
[System.Windows.Forms.RadioButton]$script:verifyJsonRadioButtonDisable = $null

[System.Windows.Forms.RadioButton]$script:verifyXmlRadioButtonEnable = $null
[System.Windows.Forms.RadioButton]$script:verifyXmlRadioButtonDisable = $null

[System.Windows.Forms.RadioButton]$script:autoSaveRadioButtonEnable = $null
[System.Windows.Forms.RadioButton]$script:autoSaveRadioButtonDisable = $null

[System.Windows.Forms.TextBox]$script:autoSavePrefixTextBox = $null

function Init() {
    InitDenp
    InitView
    InitInteraction
}

function InitDenp {
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
}

function InitView() {
    $window = New-Object System.Windows.Forms.Form
    $window.Text = '設定火箭'
    $window.Width = 300
    $window.Height = 200
    $window.AutoSize = $true
    $window.TopMost = $true

    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.AutoSize = $true
    $window.Controls.Add($layout)

    $disableSSLLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $disableSSLLayout.CellBorderStyle = 'None'
    $disableSSLLayout.RowCount = 1
    $disableSSLLayout.ColumnCount = 3
    $disableSSLLayout.AutoSize = $true
    $disableSSLLayout.Dock = 'Fill'
    $disableSSLLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 40)))
    $disableSSLLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $disableSSLLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $layout.Controls.Add($disableSSLLayout, 0, 0)

    $disableSSLLabel = New-Object System.Windows.Forms.Label
    $disableSSLLabel.Text = '忽略 SSL 驗證'
    $disableSSLLabel.Font = '微軟正黑體,10pt'
    $disableSSLLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $disableSSLLabel.Dock = 'Fill'
    $disableSSLLayout.Controls.Add($disableSSLLabel, 0, 0)

    $disableSSLRadioButtonEnable = New-Object System.Windows.Forms.RadioButton
    $disableSSLRadioButtonEnable.Text = '啟用'
    $disableSSLRadioButtonEnable.Font = '微軟正黑體,10pt'
    $disableSSLRadioButtonEnable.Checked = GetDisableSSL
    $disableSSLLayout.Controls.Add($disableSSLRadioButtonEnable, 1, 0)

    $disableSSLRadioButtonDisable = New-Object System.Windows.Forms.RadioButton
    $disableSSLRadioButtonDisable.Text = '禁用'
    $disableSSLRadioButtonDisable.Checked = -not (GetDisableSSL)
    $disableSSLRadioButtonDisable.Font = '微軟正黑體,10pt'
    $disableSSLLayout.Controls.Add($disableSSLRadioButtonDisable, 2, 0)


    $forceTls12Layout = New-Object System.Windows.Forms.TableLayoutPanel
    $forceTls12Layout.CellBorderStyle = 'None'
    $forceTls12Layout.RowCount = 1
    $forceTls12Layout.ColumnCount = 3
    $forceTls12Layout.AutoSize = $true
    $forceTls12Layout.Dock = 'Fill'
    $forceTls12Layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 40)))
    $forceTls12Layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $forceTls12Layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $layout.Controls.Add($forceTls12Layout, 0, 1)

    $forceTls12Label = New-Object System.Windows.Forms.Label
    $forceTls12Label.Text = '關閉 TLS 1.1'
    $forceTls12Label.Font = '微軟正黑體,10pt'
    $forceTls12Label.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $forceTls12Label.Dock = 'Fill'
    $forceTls12Layout.Controls.Add($forceTls12Label, 0, 0)

    $forceTls12RadioButtonEnable = New-Object System.Windows.Forms.RadioButton
    $forceTls12RadioButtonEnable.Text = '啟用'
    $forceTls12RadioButtonEnable.Font = '微軟正黑體,10pt'
    $forceTls12RadioButtonEnable.Checked = GetDisableSSL
    $forceTls12Layout.Controls.Add($forceTls12RadioButtonEnable, 1, 0)

    $forceTls12ButtonDisable = New-Object System.Windows.Forms.RadioButton
    $forceTls12ButtonDisable.Text = '禁用'
    $forceTls12ButtonDisable.Checked = -not (GetDisableSSL)
    $forceTls12ButtonDisable.Font = '微軟正黑體,10pt'
    $forceTls12Layout.Controls.Add($forceTls12ButtonDisable, 2, 0)

    $verifyJsonLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $verifyJsonLayout.CellBorderStyle = 'None'
    $verifyJsonLayout.RowCount = 1
    $verifyJsonLayout.ColumnCount = 3
    $verifyJsonLayout.AutoSize = $true
    $verifyJsonLayout.Dock = 'Fill'
    $verifyJsonLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 40)))
    $verifyJsonLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $verifyJsonLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $layout.Controls.Add($verifyJsonLayout, 0, 2)

    $verifyJsonLabel = New-Object System.Windows.Forms.Label
    $verifyJsonLabel.Text = '執行 JSON 字串驗證'
    $verifyJsonLabel.Font = '微軟正黑體,10pt'
    $verifyJsonLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $verifyJsonLabel.Dock = 'Fill'
    $verifyJsonLayout.Controls.Add($verifyJsonLabel, 0, 0)

    $verifyJsonRadioButtonEnable = New-Object System.Windows.Forms.RadioButton
    $verifyJsonRadioButtonEnable.Text = '啟用'
    $verifyJsonRadioButtonEnable.Checked = GetVerifyJson
    $verifyJsonRadioButtonEnable.Font = '微軟正黑體,10pt'
    $verifyJsonLayout.Controls.Add($verifyJsonRadioButtonEnable, 1, 0)

    $verifyJsonRadioButtonDisable = New-Object System.Windows.Forms.RadioButton
    $verifyJsonRadioButtonDisable.Text = '禁用'
    $verifyJsonRadioButtonDisable.Checked = -not (GetVerifyJson)
    $verifyJsonRadioButtonDisable.Font = '微軟正黑體,10pt'
    $verifyJsonLayout.Controls.Add($verifyJsonRadioButtonDisable, 2, 0)

    $verifyXmlLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $verifyXmlLayout.CellBorderStyle = 'None'
    $verifyXmlLayout.RowCount = 1
    $verifyXmlLayout.ColumnCount = 3
    $verifyXmlLayout.AutoSize = $true
    $verifyXmlLayout.Dock = 'Fill'
    $verifyXmlLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 40)))
    $verifyXmlLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $verifyXmlLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $layout.Controls.Add($verifyXmlLayout, 0, 3)

    $verifyXmlLabel = New-Object System.Windows.Forms.Label
    $verifyXmlLabel.Text = '執行 XML 字串驗證'
    $verifyXmlLabel.Font = '微軟正黑體,10pt'
    $verifyXmlLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $verifyXmlLabel.Dock = 'Fill'
    $verifyXmlLayout.Controls.Add($verifyXmlLabel, 0, 0)

    $verifyXmlRadioButtonEnable = New-Object System.Windows.Forms.RadioButton
    $verifyXmlRadioButtonEnable.Text = '啟用'
    $verifyXmlRadioButtonEnable.Font = '微軟正黑體,10pt'
    $verifyXmlRadioButtonEnable.Checked = GetVerifyXml
    $verifyXmlLayout.Controls.Add($verifyXmlRadioButtonEnable, 1, 0)

    $verifyXmlRadioButtonDisable = New-Object System.Windows.Forms.RadioButton
    $verifyXmlRadioButtonDisable.Text = '禁用'
    $verifyXmlRadioButtonDisable.Checked = -not (GetVerifyXml)
    $verifyXmlRadioButtonDisable.Font = '微軟正黑體,10pt'
    $verifyXmlLayout.Controls.Add($verifyXmlRadioButtonDisable, 2, 0)

    $autoSaveLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $autoSaveLayout.CellBorderStyle = 'None'
    $autoSaveLayout.RowCount = 1
    $autoSaveLayout.ColumnCount = 3
    $autoSaveLayout.AutoSize = $true
    $autoSaveLayout.Dock = 'Fill'
    $autoSaveLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 40)))
    $autoSaveLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $autoSaveLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $layout.Controls.Add($autoSaveLayout, 0, 4)

    $autoSaveLabel = New-Object System.Windows.Forms.Label
    $autoSaveLabel.Text = '自動儲存請求回應'
    $autoSaveLabel.Font = '微軟正黑體,10pt'
    $autoSaveLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $autoSaveLabel.Dock = 'Fill'
    $autoSaveLayout.Controls.Add($autoSaveLabel, 0, 0)

    $autoSaveRadioButtonEnable = New-Object System.Windows.Forms.RadioButton
    $autoSaveRadioButtonEnable.Text = '啟用'
    $autoSaveRadioButtonEnable.Font = '微軟正黑體,10pt'
    $autoSaveRadioButtonEnable.Checked = GetAutoSave
    $autoSaveLayout.Controls.Add($autoSaveRadioButtonEnable, 1, 0)

    $autoSaveRadioButtonDisable = New-Object System.Windows.Forms.RadioButton
    $autoSaveRadioButtonDisable.Text = '禁用'
    $autoSaveRadioButtonDisable.Checked = -not (GetAutoSave)
    $autoSaveRadioButtonDisable.Font = '微軟正黑體,10pt'
    $autoSaveLayout.Controls.Add($autoSaveRadioButtonDisable, 2, 0)

    $autoSavePrefixLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $autoSavePrefixLayout.CellBorderStyle = 'None'
    $autoSavePrefixLayout.RowCount = 1
    $autoSavePrefixLayout.ColumnCount = 2
    $autoSavePrefixLayout.AutoSize = $true
    $autoSavePrefixLayout.Dock = 'Fill'
    $autoSavePrefixLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 40)))
    $autoSavePrefixLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 60)))
    $layout.Controls.Add($autoSavePrefixLayout, 0, 5)

    $autoSavePrefixLabel = New-Object System.Windows.Forms.Label
    $autoSavePrefixLabel.Text = '自動儲存請求回應前墜'
    $autoSavePrefixLabel.Font = '微軟正黑體,10pt'
    $autoSavePrefixLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $autoSavePrefixLabel.Dock = 'Fill'
    $autoSavePrefixLayout.Controls.Add($autoSavePrefixLabel, 0, 0)

    $autoSavePrefixTextBox = New-Object System.Windows.Forms.TextBox
    $autoSavePrefixTextBox.Font = '微軟正黑體,10pt'
    $autoSavePrefixTextBox.Dock = 'Fill'
    $autoSavePrefixTextBox.Text = GetAutoSavePrefix
    $autoSavePrefixLayout.Controls.Add($autoSavePrefixTextBox, 1, 0)

    $operationLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $operationLayout.CellBorderStyle = 'None'
    $operationLayout.RowCount = 1
    $operationLayout.ColumnCount = 2
    $operationLayout.AutoSize = $true
    $operationLayout.Dock = 'Fill'
    $operationLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $operationLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $layout.Controls.Add($operationLayout, 0, 6)

    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Text = '儲存'
    $saveButton.Font = '微軟正黑體,10pt'
    $saveButton.Dock = 'Fill'
    $operationLayout.Controls.Add($saveButton, 0, 0)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = '取消'
    $cancelButton.Font = '微軟正黑體,10pt'
    $cancelButton.Dock = 'Fill'
    $operationLayout.Controls.Add($cancelButton, 1, 0)

    $script:window = $window
    $script:saveButton = $saveButton
    $script:cancelButton = $cancelButton
    $script:disableSSLRadioButtonEnable = $disableSSLRadioButtonEnable
    $script:disableSSLRadioButtonDisable = $disableSSLRadioButtonDisable
    $script:verifyJsonRadioButtonEnable = $verifyJsonRadioButtonEnable
    $script:verifyJsonRadioButtonDisable = $verifyJsonRadioButtonDisable
    $script:verifyXmlRadioButtonEnable = $verifyXmlRadioButtonEnable
    $script:verifyXmlRadioButtonDisable = $verifyXmlRadioButtonDisable
    $script:autoSaveRadioButtonEnable = $autoSaveRadioButtonEnable
    $script:autoSaveRadioButtonDisable = $autoSaveRadioButtonDisable
    $script:autoSavePrefixTextBox = $autoSavePrefixTextBox
}

function InitInteraction() {
    $script:saveButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        OnSaveButtonClick $object $e
    })

    $script:cancelButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        OnCancelButtonClick $object $e
    })
}

function OnSaveButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e
) {
    SetDisableSSL $script:disableSSLRadioButtonEnable.Checked
    SetVerifyJson $script:verifyJsonRadioButtonEnable.Checked
    SetVerifyXml $script:verifyXmlRadioButtonEnable.Checked
    SetAutoSave $script:autoSaveRadioButtonEnable.Checked
    SetAutoSavePrefix $script:autoSavePrefixTextBox.Text
    $script:window.Close()
}

function OnCancelButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e
) {
    $script:window.Close()
}

function RunUI() {
    $script:window.ShowDialog()

}

function RunSetting() {
    Init
    RunUI
}

Export-ModuleMember -Function RunSetting
