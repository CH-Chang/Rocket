[System.Windows.Forms.Form]$script:window = $null

[System.Windows.Forms.Button]$script:encryptButton = $null
[System.Windows.Forms.Button]$script:decryptButton = $null

[System.Windows.Forms.ComboBox]$script:typeComboBox = $null
[System.Windows.Forms.ComboBox]$script:algorithmComboBox = $null
[System.Windows.Forms.ComboBox]$script:paddingComboBox = $null
[System.Windows.Forms.TextBox]$script:keyTextBox = $null
[System.Windows.Forms.TextBox]$script:ivTextBox = $null

[System.Windows.Forms.RichTextBox]$script:plaintextRichTextBox = $null
[System.Windows.Forms.RichTextBox]$script:ciphertextRichTextBox = $null

function Init() {
    InitDenp
    InitView
    InitInteraction
}

function InitDenp {
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
}

function InitOperationView([System.Windows.Forms.TableLayoutPanel]$layout) {
    $operationLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $operationLayout.Dock = 'Fill'
    $operationLayout.AutoSize = $true
    $operationLayout.RowCount = 1
    $operationLayout.ColumnCount = 1
    $layout.Controls.Add($operationLayout, 0, 0)

    $typeLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $typeLayout.CellBorderStyle = 'None'
    $typeLayout.RowCount = 1
    $typeLayout.ColumnCount =2
    $typeLayout.AutoSize = $true
    $typeLayout.Dock = 'Fill'
    $typeLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $typeLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 70)))
    $operationLayout.Controls.Add($typeLayout, 0, 0)

    $typeLabel = New-Object System.Windows.Forms.Label
    $typeLabel.Text = '類型'
    $typeLabel.Font = '微軟正黑體,10pt'
    $typeLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $typeLabel.Dock = 'Fill'
    $typeLayout.Controls.Add($typeLabel, 0, 0)

    $typeComboBox = New-Object System.Windows.Forms.ComboBox
    $typeComboBox.Items.Add('文字')
    $typeComboBox.Items.Add('檔案')
    $typeComboBox.SelectedIndex= 0
    $typeComboBox.Font = '微軟正黑體,10pt,style=Bold'
    $typeComboBox.Dock = 'Fill'
    $typeLayout.Controls.Add($typeComboBox, 1, 0)

    $algorithmLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $algorithmLayout.CellBorderStyle = 'None'
    $algorithmLayout.RowCount = 1
    $algorithmLayout.ColumnCount =2
    $algorithmLayout.AutoSize = $true
    $algorithmLayout.Dock = 'Fill'
    $algorithmLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $algorithmLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 70)))
    $operationLayout.Controls.Add($algorithmLayout, 0, 1)

    $algorithmLabel = New-Object System.Windows.Forms.Label
    $algorithmLabel.Text = '演算法'
    $algorithmLabel.Font = '微軟正黑體,10pt'
    $algorithmLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $algorithmLabel.Dock = 'Fill'
    $algorithmLayout.Controls.Add($algorithmLabel, 0, 1)

    $algorithmComboBox = New-Object System.Windows.Forms.ComboBox
    $algorithmComboBox.Items.Add('RSA 1024')
    $algorithmComboBox.Items.Add('RSA 2048')
    $algorithmComboBox.Items.Add('AES 128 ECB')
    $algorithmComboBox.Items.Add('AES 128 CBC')
    $algorithmComboBox.Items.Add('AES 128 CFB')
    $algorithmComboBox.Items.Add('AES 128 OFB')
    $algorithmComboBox.Items.Add('AES 128 CTR')
    $algorithmComboBox.Items.Add('AES 256 ECB')
    $algorithmComboBox.Items.Add('AES 256 CBC')
    $algorithmComboBox.Items.Add('AES 256 CFB')
    $algorithmComboBox.Items.Add('AES 256 OFB')
    $algorithmComboBox.Items.Add('AES 256 CTR')
    $algorithmComboBox.SelectedIndex= 0
    $algorithmComboBox.Font = '微軟正黑體,10pt,style=Bold'
    $algorithmComboBox.Dock = 'Fill'
    $algorithmLayout.Controls.Add($algorithmComboBox, 1, 1)

    $paddingLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $paddingLayout.CellBorderStyle = 'None'
    $paddingLayout.RowCount = 1
    $paddingLayout.ColumnCount =2
    $paddingLayout.AutoSize = $true
    $paddingLayout.Dock = 'Fill'
    $paddingLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $paddingLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 70)))
    $operationLayout.Controls.Add($paddingLayout, 0, 2)

    $paddingLabel = New-Object System.Windows.Forms.Label
    $paddingLabel.Text = '填充'
    $paddingLabel.Font = '微軟正黑體,10pt'
    $paddingLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $paddingLabel.Dock = 'Fill'
    $paddingLayout.Controls.Add($paddingLabel, 0, 2)

    $paddingComboBox = New-Object System.Windows.Forms.ComboBox
    $paddingComboBox.Items.Add('No Padding')
    $paddingComboBox.Items.Add('Zero Padding')
    $paddingComboBox.Items.Add('PKCS#7 Padding')
    $paddingComboBox.SelectedIndex= 0
    $paddingComboBox.Font = '微軟正黑體,10pt,style=Bold'
    $paddingComboBox.Dock = 'Fill'
    $paddingLayout.Controls.Add($paddingComboBox, 1, 2)

    $keyLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $keyLayout.CellBorderStyle = 'None'
    $keyLayout.RowCount = 1
    $keyLayout.ColumnCount =2
    $keyLayout.AutoSize = $true
    $keyLayout.Dock = 'Fill'
    $keyLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $keyLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 70)))
    $operationLayout.Controls.Add($keyLayout, 0, 3)

    $keyLabel = New-Object System.Windows.Forms.Label
    $keyLabel.Text = '金鑰'
    $keyLabel.Font = '微軟正黑體,10pt'
    $keyLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $keyLabel.Dock = 'Fill'
    $keyLayout.Controls.Add($keyLabel, 0, 0)

    $keyTextBox = New-Object System.Windows.Forms.TextBox
    $keyTextBox.Dock = 'Fill'
    $keyTextBox.Font = '微軟正黑體,10pt'
    $keyTextBox.Multiline = $false
    $keyLayout.Controls.Add($keyTextBox, 1, 0)

    $ivLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $ivLayout.CellBorderStyle = 'None'
    $ivLayout.RowCount = 1
    $ivLayout.ColumnCount =2
    $ivLayout.AutoSize = $true
    $ivLayout.Dock = 'Fill'
    $ivLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $ivLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 70)))
    $operationLayout.Controls.Add($ivLayout, 0, 4)

    $ivLabel = New-Object System.Windows.Forms.Label
    $ivLabel.Text = '偏移'
    $ivLabel.Font = '微軟正黑體,10pt'
    $ivLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $ivLabel.Dock = 'Fill'
    $ivLayout.Controls.Add($ivLabel, 0, 4)

    $ivTextBox = New-Object System.Windows.Forms.TextBox
    $ivTextBox.Dock = 'Fill'
    $ivTextBox.Font = '微軟正黑體,10pt'
    $ivTextBox.Enabled = $false
    $ivTextBox.Multiline = $false
    $ivLayout.Controls.Add($ivTextBox, 1, 4)

    $doLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $doLayout.CellBorderStyle = 'None'
    $doLayout.RowCount = 1
    $doLayout.ColumnCount = 2
    $doLayout.AutoSize = $true
    $doLayout.Dock = 'Fill'
    $doLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $doLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $operationLayout.Controls.Add($doLayout, 0, 5)

    $encryptButton = New-Object System.Windows.Forms.Button
    $encryptButton.Text = '加密'
    $encryptButton.Font = '微軟正黑體,10pt'
    $encryptButton.Dock = 'Fill'
    $doLayout.Controls.Add($encryptButton, 0, 0)

    $decryptButton = New-Object System.Windows.Forms.Button
    $decryptButton.Text = '解密'
    $decryptButton.Font = '微軟正黑體,10pt'
    $decryptButton.Dock = 'Fill'
    $doLayout.Controls.Add($decryptButton, 1, 0)

    $script:encryptButton = $encryptButton
    $script:decryptButton = $decryptButton
    $script:typeComboBox = $typeComboBox
    $script:algorithmComboBox = $algorithmComboBox
    $script:paddingComboBox = $paddingComboBox
    $script:keyTextBox = $keyTextBox
    $script:ivTextBox = $ivTextBox
}

function InitPlaintextView([System.Windows.Forms.TableLayoutPanel]$layout) {
    $plaintextLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $plaintextLayout.Dock = 'Fill'
    $plaintextLayout.AutoSize = $true
    $plaintextLayout.RowCount = 2
    $plaintextLayout.ColumnCount = 1
    $layout.Controls.Add($plaintextLayout, 0, 1)

    $plaintextLabel = New-Object System.Windows.Forms.Label
    $plaintextLabel.Text = '明文內容'
    $plaintextLabel.Font = '微軟正黑體,10pt'
    $plaintextLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $plaintextLabel.Dock = 'Fill'
    $plaintextLayout.Controls.Add($plaintextLabel, 0, 0)

    $plaintextRichTextBox = New-Object System.Windows.Forms.RichTextBox
    $plaintextRichTextBox.Dock = 'Fill'
    $plaintextRichTextBox.Multiline = $true
    $plaintextRichTextBox.Font = '微軟正黑體,10pt'
    $plaintextLayout.Controls.Add($plaintextRichTextBox, 0, 1)

    $script:plaintextRichTextBox = $plaintextRichTextBox
}

function InitCiphertextView([System.Windows.Forms.TableLayoutPanel]$layout) {
    $ciphertextLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $ciphertextLayout.Dock = 'Fill'
    $ciphertextLayout.AutoSize = $true
    $ciphertextLayout.RowCount = 2
    $ciphertextLayout.ColumnCount = 1
    $layout.Controls.Add($ciphertextLayout, 0, 2)

    $ciphertextLabel = New-Object System.Windows.Forms.Label
    $ciphertextLabel.Text = '密文內容'
    $ciphertextLabel.Font = '微軟正黑體,10pt'
    $ciphertextLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $ciphertextLabel.Dock = 'Fill'
    $ciphertextLayout.Controls.Add($ciphertextLabel, 0, 0)

    $ciphertextRichTextBox = New-Object System.Windows.Forms.RichTextBox
    $ciphertextRichTextBox.Dock = 'Fill'
    $ciphertextRichTextBox.Multiline = $true
    $ciphertextRichTextBox.Font = '微軟正黑體,10pt'
    $ciphertextLayout.Controls.Add($ciphertextRichTextBox, 0, 1)

    $script:ciphertextRichTextBox = $ciphertextRichTextBox
}

function InitView() {
    $window = New-Object System.Windows.Forms.Form
    $window.Text = '加密火箭'
    $window.Width = 600
    $window.Height = 700
    $window.AutoSize = $true
    $window.TopMost = $true

    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.AutoSize = $true
    $layout.RowCount = 3
    $layout.ColumnCount = 1
    $layout.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 33)))
    $layout.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 33)))
    $layout.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 33)))
    $window.Controls.Add($layout)

    InitOperationView $layout
    InitPlaintextView $layout
    InitCiphertextView $layout

    $script:window = $window
}

function InitInteraction() {
    $script:encryptButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        OnEncryptButtonClick $object $e
    })

    $script:decryptButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        OnDecryptButtonClick $object $e
    })

    $script:typeComboBox.add_SelectedIndexChanged({
        param([System.Windows.Forms.ComboBox]$object, [System.EventArgs]$e)
        OnTypeComboBoxChange $object $e
    })

    $script:algorithmComboBox.add_SelectedIndexChanged({
        param([System.Windows.Forms.ComboBox]$object, [System.EventArgs]$e)
        OnAlgorithmComboBoxChange $object $e
    })
}

function OnEncryptButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e
) {

}

function OnDecryptButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e
) {
}

function OnTypeComboBoxChange(
    [System.Windows.Forms.ComboBox]$object,
    [System.EventArgs]$e) {
    $type = $script:typeComboBox.SelectedItem

    if ($type -eq '檔案') {
        $script:plaintextRichTextBox.Enabled = $false
        $script:ciphertextRichTextBox.Enabled = $false
    } else {
        $script:plaintextRichTextBox.Enabled = $true
        $script:ciphertextRichTextBox.Enabled = $true
    }
}

function OnAlgorithmComboBoxChange(
    [System.Windows.Forms.ComboBox]$object,
    [System.EventArgs]$e) {
}

function RunUI() {
    $script:window.ShowDialog()
}

function RunCrypto() {
    Init
    RunUI
}

Export-ModuleMember -Function RunCrypto
