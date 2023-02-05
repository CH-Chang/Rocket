Import-Module '.\Utils\Requester.psm1'

[System.Windows.Forms.Form]$script:window = $null

[System.Windows.Forms.Button]$script:importButton = $null
[System.Windows.Forms.Button]$script:exportButton = $null
[System.Windows.Forms.Button]$script:removeButton = $null
[System.Windows.Forms.Button]$script:addButton = $null
[System.Windows.Forms.ListBox]$script:dataListBox = $null

[System.Windows.Forms.ComboBox]$script:methodComboBox = $null
[System.Windows.Forms.TextBox]$script:urlTextBox = $null
[System.Windows.Forms.Button]$script:sendButton = $null

[System.Windows.Forms.TabControl]$script:requestTabControl = $null
[System.Windows.Forms.TabPage]$script:requestHeaderTabPage = $null
[System.Windows.Forms.TabPage]$script:requestBodyTabPage = $null

[System.Windows.Forms.DataGridView]$script:requestHeaderDataGridView = $null
[System.Windows.Forms.RadioButton]$script:requestBodyContentTypeNone = $null
[System.Windows.Forms.RadioButton]$script:requestBodyContentTypeJson = $null
[System.Windows.Forms.RadioButton]$script:requestBodyContentTypeXml = $null
[System.Windows.Forms.RadioButton]$script:requestBodyContentTypeFormData = $null
[System.Windows.Forms.TableLayoutPanel]$script:requestBodyLayout = $null
[System.Windows.Forms.TextBox]$script:requestBodyJsonTextBox = $null
[System.Windows.Forms.TextBox]$script:requestBodyXmlTextBox = $null
[System.Windows.Forms.DataGridView]$script:requestBodyFormDataDataGridView = $null


[System.Windows.Forms.Label]$script:responseStatusLabel = $null
[System.Windows.Forms.DataGridView]$script:responseHeaderDataGridView = $null
[System.Windows.Forms.TextBox]$script:responseBodyTextBox = $null

[System.Windows.Forms.Button]$script:cryptoButton = $null
[System.Windows.Forms.Button]$script:hashButton = $null
[System.Windows.Forms.Button]$script:aboutButton = $null
[System.Windows.Forms.Button]$script:settingButton = $null

function Init() {
    InitDenp
    InitView
    InitInteraction
}

function InitDenp {
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
}

function InitLeftView ([System.Windows.Forms.TableLayoutPanel]$mainLayout) {
    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.CellBorderStyle = 'None'
    $layout.RowCount = 3
    $layout.ColumnCount = 2
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))

    $importButton = New-Object System.Windows.Forms.Button
    $importButton.Text = '導入資料'
    $importButton.Dock = 'Fill'
    $importButton.Font = '微軟正黑體,10pt'
    $layout.Controls.Add($importButton, 0, 0)

    $exportButton = New-Object System.Windows.Forms.Button
    $exportButton.Text = '導出資料'
    $exportButton.Dock = 'Fill'
    $exportButton.Font = '微軟正黑體,10pt'
    $layout.Controls.Add($exportButton, 1, 0)

    $removeButton = New-Object System.Windows.Forms.Button
    $removeButton.Text = '刪除所選'
    $removeButton.Dock = 'Fill'
    $removeButton.Font = '微軟正黑體,10pt'
    $layout.Controls.Add($removeButton, 0, 1)

    $addButton = New-Object System.Windows.Forms.Button
    $addButton.Text = '新增當前'
    $addButton.Dock = 'Fill'
    $addButton.Font = '微軟正黑體,10pt'
    $layout.Controls.Add($addButton, 1, 1)

    $dataListBox = New-Object System.Windows.Forms.ListBox
    $dataListBox.Dock = 'Fill'
    $layout.Controls.Add($dataListBox, 0, 2)
    $layout.SetColumnSpan($dataListBox, 2)

    $mainLayout.Controls.Add($layout, 0, 0)

    $script:importButton = $importButton
    $script:exportButton = $exportButton
    $script:removeButton = $removeButton
    $script:addButton = $addButton
    $script:dataListBox = $dataListBox
}

function InitRightView ([System.Windows.Forms.TableLayoutPanel]$mainLayout) {
    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.CellBorderStyle = 'None'
    $layout.RowCount = 4
    $layout.ColumnCount = 1
    $layout.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 5)))
    $layout.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 45)))
    $layout.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 45)))
    $layout.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 5)))

    InitRightTopView($layout)
    InitRightRequestView($layout)
    InitRightResponseView($layout)
    InitRightBottomView($layout)

    $mainLayout.Controls.Add($layout, 1, 0)
}

function InitRightTopView ([System.Windows.Forms.TableLayoutPanel]$rightLayout) {
    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.CellBorderStyle = 'None'
    $layout.RowCount = 1
    $layout.ColumnCount = 3
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 10)))
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 80)))
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 10)))

    $methodComboBox = New-Object System.Windows.Forms.ComboBox
    $methodComboBox.Items.Add('GET')
    $methodComboBox.Items.Add('POST')
    $methodComboBox.Items.Add('PUT')
    $methodComboBox.Items.Add('DELETE')
    $methodComboBox.SelectedIndex= 0
    $methodComboBox.Font = '微軟正黑體,10pt,style=Bold'
    $layout.Controls.Add($methodComboBox, 0, 0)

    $urlTextBox = New-Object System.Windows.Forms.TextBox
    $urlTextBox.Dock = 'Fill'
    $urlTextBox.Font = '微軟正黑體,10pt'
    $urlTextBox.Multiline = $false
    $layout.Controls.Add($urlTextBox, 1, 0)

    $sendButton = New-Object System.Windows.Forms.Button
    $sendButton.Text = '執行請求'
    $sendButton.Dock = 'Fill'
    $sendButton.Font = '微軟正黑體,10pt'
    $layout.Controls.Add($sendButton, 2, 0)

    $rightLayout.Controls.Add($layout)

    $script:methodComboBox = $methodComboBox
    $script:urlTextBox = $urlTextBox
    $script:sendButton = $sendButton
}

function InitRightRequestView ([System.Windows.Forms.TableLayoutPanel]$rightLayout) {
    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.CellBorderStyle = 'None'
    $layout.RowCount = 1
    $layout.ColumnCount = 1

    $requestTabControl = New-Object System.Windows.Forms.TabControl
    $requestTabControl.Dock = 'Fill'
    $layout.Controls.Add($requestTabControl, 2, 1)
    $layout.SetColumnSpan($requestTabControl, 4)
    $layout.SetRowSpan($requestTabControl, 2)

    $requestHeaderTabPage = New-Object System.Windows.Forms.TabPage
    $requestHeaderTabPage.Name = 'requestHeader'
    $requestHeaderTabPage.TabIndex = 1
    $requestHeaderTabPage.Text = '請求標頭'
    $requestHeaderTabPage.Font = '微軟正黑體,10pt'
    $requestTabControl.Controls.Add($requestHeaderTabPage)

    $requestHeaderLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $requestHeaderLayout.Dock = 'Fill'
    $requestHeaderLayout.CellBorderStyle = 'None'
    $requestHeaderLayout.RowCount = 1
    $requestHeaderLayout.ColumnCount = 1
    $requestHeaderTabPage.Controls.Add($requestHeaderLayout)

    $requestHeaderDataGridView = New-Object System.Windows.Forms.DataGridView
    $requestHeaderDataGridView.Dock = 'Fill'
    $requestHeaderDataGridView.ColumnHeadersVisible = $true
    $requestHeaderDataGridView.ColumnCount = 2
    $requestHeaderDataGridView.Columns[0].AutoSizeMode = [System.Windows.Forms.DataGridViewAutoSizeColumnMode]::DisplayedCells
    $requestHeaderDataGridView.Columns[1].AutoSizeMode = [System.Windows.Forms.DataGridViewAutoSizeColumnMode]::Fill
    $requestHeaderDataGridView.Columns[0].Name = '標頭'
    $requestHeaderDataGridView.Columns[1].Name = '數值'
    $requestHeaderLayout.Controls.Add($requestHeaderDataGridView, 0, 0)

    $requestBodyTabPage = New-Object System.Windows.Forms.TabPage
    $requestBodyTabPage.Name = 'requestBody'
    $requestBodyTabPage.TabIndex = 2
    $requestBodyTabPage.Text = '請求內容'
    $requestBodyTabPage.Font = '微軟正黑體,10pt,style=Bold'

    $requestBodyLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $requestBodyLayout.Dock = 'Fill'
    $requestBodyLayout.CellBorderStyle = 'None'
    $requestBodyLayout.RowCount = 1
    $requestBodyLayout.ColumnCount = 2
    $requestBodyTabPage.Controls.Add($requestBodyLayout)

    $requestBodyContentTypeGroupPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $requestBodyContentTypeGroupPanel.Dock = 'Fill'
    $requestBodyContentTypeGroupPanel.CellBorderStyle = 'None'
    $requestBodyContentTypeGroupPanel.RowCount = 4
    $requestBodyContentTypeGroupPanel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 25)))
    $requestBodyContentTypeGroupPanel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 25)))
    $requestBodyContentTypeGroupPanel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 25)))
    $requestBodyContentTypeGroupPanel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 25)))
    $requestBodyLayout.Controls.Add($requestBodyContentTypeGroupPanel, 0, 0)

    $requestBodyContentTypeNone = New-Object System.Windows.Forms.RadioButton
    $requestBodyContentTypeNone.Dock = 'Fill'
    $requestBodyContentTypeNone.Font = '微軟正黑體,10pt'
    $requestBodyContentTypeNone.Text = 'None'
    $requestBodyContentTypeNone.Checked = $true
    $requestBodyContentTypeGroupPanel.Controls.Add($requestBodyContentTypeNone)

    $requestBodyContentTypeJson = New-Object System.Windows.Forms.RadioButton
    $requestBodyContentTypeJson.Dock = 'Fill'
    $requestBodyContentTypeJson.Font = '微軟正黑體,10pt'
    $requestBodyContentTypeJson.Text = 'application/json'
    $requestBodyContentTypeGroupPanel.Controls.Add($requestBodyContentTypeJson)

    $requestBodyContentTypeXml = New-Object System.Windows.Forms.RadioButton
    $requestBodyContentTypeXml.Dock = 'Fill'
    $requestBodyContentTypeXml.Font = '微軟正黑體,10pt'
    $requestBodyContentTypeXml.Text = 'application/xml'
    $requestBodyContentTypeGroupPanel.Controls.Add($requestBodyContentTypeXml)

    $requestBodyContentTypeFormData = New-Object System.Windows.Forms.RadioButton
    $requestBodyContentTypeFormData.Dock = 'Fill'
    $requestBodyContentTypeFormData.Font = '微軟正黑體,10pt'
    $requestBodyContentTypeFormData.Text = 'application/form-data'
    $requestBodyContentTypeGroupPanel.Controls.Add($requestBodyContentTypeFormData)

    $requestBodyJsonTextBox = New-Object System.Windows.Forms.TextBox
    $requestBodyJsonTextBox.Dock = 'Fill'
    $requestBodyJsonTextBox.Multiline = $true
    $requestBodyJsonTextBox.Font = '微軟正黑體,10pt'

    $requestBodyXmlTextBox = New-Object System.Windows.Forms.TextBox
    $requestBodyXmlTextBox.Dock = 'Fill'
    $requestBodyXmlTextBox.Multiline = $true
    $requestBodyXmlTextBox.Font = '微軟正黑體,10pt'

    $requestBodyFormDataDataGridView = New-Object System.Windows.Forms.DataGridView
    $requestBodyFormDataDataGridView.Dock = 'Fill'
    $requestBodyFormDataDataGridView.ColumnHeadersVisible = $true

    $requestBodyFormDataKeyDataGridViewTextBoxColumn = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $requestBodyFormDataKeyDataGridViewTextBoxColumn.HeaderText = '名稱'
    $requestBodyFormDataDataGridView.Columns.Add($requestBodyFormDataKeyDataGridViewTextBoxColumn)

    $requestBodyFormDataTypeDataGridViewComboBoxColumn = New-Object System.Windows.Forms.DataGridViewComboBoxColumn
    $requestBodyFormDataTypeDataGridViewComboBoxColumn.HeaderText = '類型'
    $requestBodyFormDataTypeDataGridViewComboBoxColumn.Items.Add('檔案')
    $requestBodyFormDataTypeDataGridViewComboBoxColumn.Items.Add('文字')
    $requestBodyFormDataDataGridView.Columns.Add($requestBodyFormDataTypeDataGridViewComboBoxColumn)

    $requestBodyFormDataTextDataGridViewTextBoxColumn = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $requestBodyFormDataTextDataGridViewTextBoxColumn.HeaderText = '文字'
    $requestBodyFormDataDataGridView.Columns.Add($requestBodyFormDataTextDataGridViewTextBoxColumn)

    $requestBodyFormDataSelectFileDataGridViewButtonColumn = New-Object System.Windows.Forms.DataGridViewButtonColumn
    $requestBodyFormDataSelectFileDataGridViewButtonColumn.HeaderText = '檔案'
    $requestBodyFormDataSelectFileDataGridViewButtonColumn.Text = '選擇檔案'
    $requestBodyFormDataSelectFileDataGridViewButtonColumn.UseColumnTextForButtonValue = $true
    $requestBodyFormDataDataGridView.Columns.Add($requestBodyFormDataSelectFileDataGridViewButtonColumn)

    $rightLayout.Controls.Add($layout)

    $script:requestTabControl = $requestTabControl
    $script:requestHeaderTabPage = $requestHeaderTabPage
    $script:requestBodyTabPage = $requestBodyTabPage

    $script:requestHeaderDataGridView = $requestHeaderDataGridView
    $script:requestBodyLayout = $requestBodyLayout
    $script:requestBodyJsonTextBox = $requestBodyJsonTextBox
    $script:requestBodyXmlTextBox = $requestBodyXmlTextBox
    $script:requestBodyFormDataDataGridView = $requestBodyFormDataDataGridView
    $script:requestBodyContentTypeNone = $requestBodyContentTypeNone
    $script:requestBodyContentTypeJson = $requestBodyContentTypeJson
    $script:requestBodyContentTypeXml = $requestBodyContentTypeXml
    $script:requestBodyContentTypeFormData = $requestBodyContentTypeFormData
}

function InitRightResponseView ([System.Windows.Forms.TableLayoutPanel]$rightLayout) {
    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.CellBorderStyle = 'None'
    $layout.RowCount = 1
    $layout.ColumnCount = 1

    $responseTabControl = New-Object System.Windows.Forms.TabControl
    $responseTabControl.Dock = 'Fill'
    $layout.Controls.Add($responseTabControl, 2, 3)
    $layout.SetColumnSpan($responseTabControl, 4)
    $layout.SetRowSpan($responseTabControl, 2)

    $responseHeaderTabPage = New-Object System.Windows.Forms.TabPage
    $responseHeaderTabPage.Name = 'responseHeader'
    $responseHeaderTabPage.TabIndex = 1
    $responseHeaderTabPage.Text = '回應標頭'
    $responseHeaderTabPage.Font = '微軟正黑體,10pt,style=Bold'
    $responseTabControl.Controls.Add($responseHeaderTabPage)

    $responseHeaderLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $responseHeaderLayout.Dock = 'Fill'
    $responseHeaderLayout.CellBorderStyle = 'None'
    $responseHeaderLayout.RowCount = 2
    $responseHeaderLayout.ColumnCount = 1
    $responseHeaderTabPage.Controls.Add($responseHeaderLayout)

    $responseStatusLabel = New-Object System.Windows.Forms.Label
    $responseStatusLabel.Dock = 'Fill'
    $responseStatusLabel.Font = '微軟正黑體,10pt'
    $responseStatusLabel.Text = '回應狀態: 無回應紀錄'
    $responseStatusLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
    $responseHeaderLayout.Controls.Add($responseStatusLabel, 0, 0)

    $responseHeaderDataGridView = New-Object System.Windows.Forms.DataGridView
    $responseHeaderDataGridView.Dock = 'Fill'
    $responseHeaderDataGridView.ColumnHeadersVisible = $true
    $responseHeaderDataGridView.ColumnCount = 2
    $responseHeaderDataGridView.Columns[0].AutoSizeMode = [System.Windows.Forms.DataGridViewAutoSizeColumnMode]::DisplayedCells
    $responseHeaderDataGridView.Columns[1].AutoSizeMode = [System.Windows.Forms.DataGridViewAutoSizeColumnMode]::Fill
    $responseHeaderDataGridView.Columns[0].Name = '標頭'
    $responseHeaderDataGridView.Columns[1].Name = '數值'
    $responseHeaderLayout.Controls.Add($responseHeaderDataGridView, 0, 1)

    $responseBodyTabPage = New-Object System.Windows.Forms.TabPage
    $responseBodyTabPage.Name = 'responseBody'
    $responseBodyTabPage.TabIndex = 2
    $responseBodyTabPage.Text = '回應內容'
    $responseBodyTabPage.Font = '微軟正黑體,10pt,style=Bold'
    $responseTabControl.Controls.Add($responseBodyTabPage)

    $responseBodyLayout = New-Object System.Windows.Forms.TableLayoutPanel
    $responseBodyLayout.Dock = 'Fill'
    $responseBodyLayout.CellBorderStyle = 'None'
    $responseBodyLayout.RowCount = 1
    $responseBodyLayout.ColumnCount = 1
    $responseBodyTabPage.Controls.Add($responseBodyLayout)

    $responseBodyTextBox = New-Object System.Windows.Forms.TextBox
    $responseBodyTextBox.Dock = 'Fill'
    $responseBodyTextBox.Multiline = $true
    $responseBodyTextBox.Font = '微軟正黑體,10pt'
    $responseBodyLayout.Controls.Add($responseBodyTextBox, 0, 0)

    $rightLayout.Controls.Add($layout)

    $script:responseStatusLabel = $responseStatusLabel
    $script:responseHeaderDataGridView = $responseHeaderDataGridView
    $script:responseBodyTextBox = $responseBodyTextBox
}

function InitRightBottomView ([System.Windows.Forms.TableLayoutPanel]$rightLayout) {
    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.CellBorderStyle = 'None'
    $layout.RowCount = 1
    $layout.ColumnCount = 4
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 25)))
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 25)))
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 25)))
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 25)))

    $cryptoButton = New-Object System.Windows.Forms.Button
    $cryptoButton.Text = '加密工具'
    $cryptoButton.Dock = 'Fill'
    $cryptoButton.Font = '微軟正黑體,10pt'
    $layout.Controls.Add($cryptoButton, 0, 0)

    $hashButton = New-Object System.Windows.Forms.Button
    $hashButton.Text = '雜湊工具'
    $hashButton.Dock = 'Fill'
    $hashButton.Font = '微軟正黑體,10pt'
    $layout.Controls.Add($hashButton, 1, 0)


    $settingButton = New-Object System.Windows.Forms.Button
    $settingButton.Text = '程式設定'
    $settingButton.Dock = 'Fill'
    $settingButton.Font = '微軟正黑體,10pt'
    $layout.Controls.Add($settingButton, 2, 0)

    $aboutButton = New-Object System.Windows.Forms.Button
    $aboutButton.Text = '關於程式'
    $aboutButton.Dock = 'Fill'
    $aboutButton.Font = '微軟正黑體,10pt'
    $layout.Controls.Add($aboutButton, 3, 0)

    $rightLayout.Controls.Add($layout)

    $script:cryptoButton = $cryptoButton
    $script:hashButton = $hashButton
    $script:settingButton = $settingButton
    $script:aboutButton = $aboutButton
}

function InitView() {
    $window = New-Object System.Windows.Forms.Form
    $window.Text = '火箭'
    $window.Width = 1280
    $window.Height = 720
    $window.AutoSize = $true
    $window.TopMost = $true

    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.CellBorderStyle = 'None'
    $layout.RowCount = 1
    $layout.ColumnCount = 2
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 30)))
    $layout.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 70)))
    $window.Controls.Add($layout)

    InitLeftView($layout)
    InitRightView($layout)

    $script:window = $window
}

function InitInteraction() {
    $script:importButton.add_click({ onImportButtonClick })
    $script:exportButton.add_click({ onExportButtonClick })
    $script:removeButton.add_click({ onRemoveButtonClick })
    $script:addButton.add_click({ onAddButtonClick })

    $script:methodComboBox.add_SelectedIndexChanged({ onMethodComboBoxChange })
    $script:sendButton.add_click({ onSendButtonClick })

    $script:requestBodyContentTypeNone.add_click({ onRequestBodyContentTypeNoneClick })
    $script:requestBodyContentTypeJson.add_click({ onRequestBodyContentTypeJsonClick })
    $script:requestBodyContentTypeXml.add_click({ onRequestBodyContentTypeXmlClick })
    $script:requestBodyContentTypeFormData.add_click({ onRequestBodyContentTypeFormDataClick })

    $script:cryptoButton.add_click({ onCryptoButtonClick })
    $script:hashButton.add_click({ onHashButtonClick })
    $script:aboutButton.add_click({ onAboutButtonClick })
    $script:settingButton.add_click({ onSettingButtonClick })
}

function onImportButtonClick() {
}

function onExportButtonClick() {
}

function onRemoveButtonClick() {
}

function onAddButtonClick() {
}

function onSendButtonClick() {
}

function onMethodComboBoxChange() {
    $method = $script:methodComboBox.SelectedItem

    $script:requestTabControl.Controls.Clear()
    $script:requestTabControl.Controls.Add($script:requestHeaderTabPage)

    if ($method -eq 'POST' -or $method -eq 'PUT') {
        $script:requestTabControl.Controls.Add($script:requestBodyTabPage)
    }
}

function onRequestBodyContentTypeNoneClick() {
    $group = $script:requestBodyLayout.Controls[0]
    $script:requestBodyLayout.Controls.Clear()
    $script:requestBodyLayout.Controls.Add($group, 0, 0)
}

function onRequestBodyContentTypeJsonClick() {
    $group = $script:requestBodyLayout.Controls[0]
    $script:requestBodyLayout.Controls.Clear()
    $script:requestBodyLayout.Controls.Add($group, 0, 0)

    $script:requestBodyLayout.Controls.Add($script:requestBodyJsonTextBox, 1, 0)
}

function onRequestBodyContentTypeXmlClick() {
    $group = $script:requestBodyLayout.Controls[0]
    $script:requestBodyLayout.Controls.Clear()
    $script:requestBodyLayout.Controls.Add($group, 0, 0)

    $script:requestBodyLayout.Controls.Add($script:requestBodyXmlTextBox, 1, 0)
}

function onRequestBodyContentTypeFormDataClick() {
    $group = $script:requestBodyLayout.Controls[0]
    $script:requestBodyLayout.Controls.Clear()
    $script:requestBodyLayout.Controls.Add($group, 0, 0)

    $script:requestBodyLayout.Controls.Add($script:requestBodyFormDataDataGridView, 1, 0)
}

function onCryptoButtonClick() {
}

function onHashButtonClick() {
}

function onAboutButtonClick() {
    $return = [System.Windows.Forms.MessageBox]::Show(
        "版權所有© 2023 CHIH HSIANG CHANG",
        '關於程式',
        [System.Windows.Forms.MessageBoxButtons]::OKCancel,
        [System.Windows.Forms.MessageBoxIcon]::Information)

    if ($return -ne [System.Windows.Forms.DialogResult]::OK) {
        return
    }

    Start-Process 'https://github.com/CH-Chang/Rocket'
}

function onSettingButtonClick() {
}

function RunUI() {
    $script:window.ShowDialog()
}

function Run() {
    Init
    RunUI
}

Export-ModuleMember -Function Run
