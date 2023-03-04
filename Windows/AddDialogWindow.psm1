[System.Windows.Forms.Form]$script:dialog = $null
[System.Windows.Forms.Button]$script:saveButton = $null
[System.Windows.Forms.Button]$script:cancelButton = $null
[System.Windows.Forms.TextBox]$script:nameTextBox = $null
[string]$script:name= $null

function Init() {
    InitDenp
    InitView
    InitInteraction
}

function InitDenp() {
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
}

function InitView() {
    $dialog = New-Object System.Windows.Forms.Form
    $dialog.Text = '儲存所選'
    $dialog.Width = 300
    $dialog.Height = 100
    $dialog.AutoSize = $true
    $dialog.TopMost = $true

    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.AutoSize = $true
    $layout.RowCount = 3
    $layout.ColumnCount = 2
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $dialog.Controls.Add($layout)

    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Text = '請輸入名稱：'
    $nameLabel.Font = '微軟正黑體,10pt'
    $nameLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $nameLabel.Dock = 'Fill'
    $layout.Controls.Add($nameLabel, 0, 0)
    $layout.SetColumnSpan($nameLabel, 2)

    $nameTextBox = New-Object System.Windows.Forms.TextBox
    $nameTextBox.Font = '微軟正黑體,10pt'
    $nameTextBox.Dock = 'Fill'
    $layout.Controls.Add($nameTextBox, 0, 1)
    $layout.SetColumnSpan($nameTextBox, 2)

    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Text = '儲存'
    $saveButton.Font = '微軟正黑體,10pt'
    $saveButton.Dock = 'Fill'
    $layout.Controls.Add($saveButton, 0, 2)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = '取消'
    $cancelButton.Font = '微軟正黑體,10pt'
    $cancelButton.Dock = 'Fill'
    $layout.Controls.Add($cancelButton, 1, 2)

    $script:dialog = $dialog
    $script:nameTextBox = $nameTextBox
    $script:saveButton = $saveButton
    $script:cancelButton = $cancelButton
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
    $script:name = $script:nameTextBox.Text
    $script:dialog.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $script:dialog.Close()
}

function OnCancelButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e
) {
    $script:dialog.Close()
}

function GetAddName {
    return $script:name
}

function RunUI() {
    $script:dialog.ShowDialog()
}

function RunAddDialog() {
    Init
    RunUI
}

Export-ModuleMember -Function RunAddDialog, GetAddName
