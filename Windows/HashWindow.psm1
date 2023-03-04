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
    $algorithmComboBox.Items.Add('MD5')
    $algorithmComboBox.Items.Add('SHA256')
    $algorithmComboBox.Items.Add('HMAC SHA256')
    $algorithmComboBox.SelectedIndex= 0
    $algorithmComboBox.Font = '微軟正黑體,10pt,style=Bold'
    $algorithmComboBox.Dock = 'Fill'
    $algorithmLayout.Controls.Add($algorithmComboBox, 1, 1)

    $keyLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $keyLayout.CellBorderStyle = 'None'
    $keyLayout.RowCount = 1
    $keyLayout.ColumnCount =2
    $keyLayout.AutoSize = $true
    $keyLayout.Dock = 'Fill'
    $keyLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $keyLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 70)))
    $operationLayout.Controls.Add($keyLayout, 0, 2)

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

    $doLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $doLayout.CellBorderStyle = 'None'
    $doLayout.RowCount = 1
    $doLayout.ColumnCount = 1
    $doLayout.AutoSize = $true
    $doLayout.Dock = 'Fill'
    $doLayout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $operationLayout.Controls.Add($doLayout, 0, 3)

    $hashButton = New-Object System.Windows.Forms.Button
    $hashButton.Text = '雜湊'
    $hashButton.Font = '微軟正黑體,10pt'
    $hashButton.Dock = 'Fill'
    $doLayout.Controls.Add($hashButton, 0, 0)
}

function InitPlaintextView([System.Windows.Forms.TableLayoutPanel]$layout) {
    $plaintextLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $plaintextLayout.Dock = 'Fill'
    $plaintextLayout.AutoSize = $true
    $plaintextLayout.RowCount = 2
    $plaintextLayout.ColumnCount = 1
    $layout.Controls.Add($plaintextLayout, 0, 1)

    $plaintextLabel = New-Object System.Windows.Forms.Label
    $plaintextLabel.Text = '雜湊前內容'
    $plaintextLabel.Font = '微軟正黑體,10pt'
    $plaintextLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $plaintextLabel.Dock = 'Fill'
    $plaintextLayout.Controls.Add($plaintextLabel, 0, 0)

    $plaintextRichTextBox = New-Object System.Windows.Forms.RichTextBox
    $plaintextRichTextBox.Dock = 'Fill'
    $plaintextRichTextBox.Multiline = $true
    $plaintextRichTextBox.Font = '微軟正黑體,10pt'
    $plaintextLayout.Controls.Add($plaintextRichTextBox, 0, 1)
}

function InitCiphertextView([System.Windows.Forms.TableLayoutPanel]$layout) {
    $ciphertextLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $ciphertextLayout.Dock = 'Fill'
    $ciphertextLayout.AutoSize = $true
    $ciphertextLayout.RowCount = 2
    $ciphertextLayout.ColumnCount = 1
    $layout.Controls.Add($ciphertextLayout, 0, 2)

    $ciphertextLabel = New-Object System.Windows.Forms.Label
    $ciphertextLabel.Text = '雜湊後內容'
    $ciphertextLabel.Font = '微軟正黑體,10pt'
    $ciphertextLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $ciphertextLabel.Dock = 'Fill'
    $ciphertextLayout.Controls.Add($ciphertextLabel, 0, 0)

    $ciphertextRichTextBox = New-Object System.Windows.Forms.RichTextBox
    $ciphertextRichTextBox.Dock = 'Fill'
    $ciphertextRichTextBox.Multiline = $true
    $ciphertextRichTextBox.Font = '微軟正黑體,10pt'
    $ciphertextLayout.Controls.Add($ciphertextRichTextBox, 0, 1)
}

function InitView() {
    $window = New-Object System.Windows.Forms.Form
    $window.Text = '加密火箭'
    $window.Width = 600
    $window.Height = 500
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
}

function RunUI() {
    $script:window.ShowDialog()
}

function RunHash() {
    Init
    RunUI
}

Export-ModuleMember -Function RunHash
