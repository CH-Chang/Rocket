Import-Module '.\Utils\Requester.psm1'
Import-Module '.\Utils\Settings.psm1'
Import-Module '.\Utils\Data.psm1'
Import-Module '.\Windows\SettingWindow.psm1'
Import-Module '.\Windows\AddDialogWindow.psm1'

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
[System.Windows.Forms.RadioButton]$script:requestBodyContentTypeOther = $null
[System.Windows.Forms.TableLayoutPanel]$script:requestBodyLayout = $null
[System.Windows.Forms.RichTextBox]$script:requestBodyRichJsonTextBox = $null
[System.Windows.Forms.RichTextBox]$script:requestBodyXmlRichTextBox = $null
[System.Windows.Forms.RichTextBox]$script:requestBodyOtherRichTextBox = $null
[System.Windows.Forms.DataGridView]$script:requestBodyFormDataDataGridView = $null

[System.Windows.Forms.DataGridViewComboBoxColumn]$script:requestBodyFormDataTypeDataGridViewComboBoxColumn = $null
[System.Windows.Forms.DataGridViewButtonColumn]$script:requestBodyFormDataSelectFileDataGridViewButtonColumn = $null
[System.Windows.Forms.DataGridViewTextBoxColumn]$script:requestBodyFormDataTextDataGridViewTextBoxColumn = $null

[System.Windows.Forms.Label]$script:responseStatusLabel = $null
[System.Windows.Forms.DataGridView]$script:responseHeaderDataGridView = $null
[System.Windows.Forms.RichTextBox]$script:responseBodyRichTextBox = $null

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
    $urlTextBox.Text = 'http://localhost:3000'
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
    $requestBodyContentTypeGroupPanel.RowCount = 5
    $requestBodyContentTypeGroupPanel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 20)))
    $requestBodyContentTypeGroupPanel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 20)))
    $requestBodyContentTypeGroupPanel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 20)))
    $requestBodyContentTypeGroupPanel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 20)))
    $requestBodyContentTypeGroupPanel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 20)))
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

    $requestBodyContentTypeOther = New-Object System.Windows.Forms.RadioButton
    $requestBodyContentTypeOther.Dock = 'Fill'
    $requestBodyContentTypeOther.Font = '微軟正黑體,10pt'
    $requestBodyContentTypeOther.Text = 'other'
    $requestBodyContentTypeGroupPanel.Controls.Add($requestBodyContentTypeOther)

    $requestBodyRichJsonTextBox = New-Object System.Windows.Forms.RichTextBox
    $requestBodyRichJsonTextBox.Dock = 'Fill'
    $requestBodyRichJsonTextBox.Multiline = $true
    $requestBodyRichJsonTextBox.Font = '微軟正黑體,10pt'

    $requestBodyXmlRichTextBox = New-Object System.Windows.Forms.RichTextBox
    $requestBodyXmlRichTextBox.Dock = 'Fill'
    $requestBodyXmlRichTextBox.Multiline = $true
    $requestBodyXmlRichTextBox.Font = '微軟正黑體,10pt'

    $requestBodyOtherRichTextBox = New-Object System.Windows.Forms.RichTextBox
    $requestBodyOtherRichTextBox.Dock = 'Fill'
    $requestBodyOtherRichTextBox.Multiline = $true
    $requestBodyOtherRichTextBox.Font = '微軟正黑體,10pt'

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

    $requestBodyFormDataSelectFileDataGridViewButtonColumn = New-Object System.Windows.Forms.DataGridViewButtonColumn
    $requestBodyFormDataSelectFileDataGridViewButtonColumn.HeaderText = '檔案'
    $requestBodyFormDataSelectFileDataGridViewButtonColumn.Text = '選擇檔案'
    $requestBodyFormDataSelectFileDataGridViewButtonColumn.UseColumnTextForButtonValue = $true
    $requestBodyFormDataDataGridView.Columns.Add($requestBodyFormDataSelectFileDataGridViewButtonColumn)

    $requestBodyFormDataTextDataGridViewTextBoxColumn = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $requestBodyFormDataTextDataGridViewTextBoxColumn.HeaderText = '內容'
    $requestBodyFormDataDataGridView.Columns.Add($requestBodyFormDataTextDataGridViewTextBoxColumn)

    $requestBodyFormDataDataGridView.Columns[0].AutoSizeMode = [System.Windows.Forms.DataGridViewAutoSizeColumnMode]::DisplayedCells
    $requestBodyFormDataDataGridView.Columns[1].AutoSizeMode = [System.Windows.Forms.DataGridViewAutoSizeColumnMode]::DisplayedCells
    $requestBodyFormDataDataGridView.Columns[3].AutoSizeMode = [System.Windows.Forms.DataGridViewAutoSizeColumnMode]::Fill

    $rightLayout.Controls.Add($layout)

    $script:requestTabControl = $requestTabControl
    $script:requestHeaderTabPage = $requestHeaderTabPage
    $script:requestBodyTabPage = $requestBodyTabPage

    $script:requestHeaderDataGridView = $requestHeaderDataGridView
    $script:requestBodyLayout = $requestBodyLayout
    $script:requestBodyRichJsonTextBox = $requestBodyRichJsonTextBox
    $script:requestBodyXmlRichTextBox = $requestBodyXmlRichTextBox
    $script:requestBodyOtherRichTextBox = $requestBodyOtherRichTextBox
    $script:requestBodyFormDataDataGridView = $requestBodyFormDataDataGridView
    $script:requestBodyContentTypeNone = $requestBodyContentTypeNone
    $script:requestBodyContentTypeJson = $requestBodyContentTypeJson
    $script:requestBodyContentTypeXml = $requestBodyContentTypeXml
    $script:requestBodyContentTypeFormData = $requestBodyContentTypeFormData
    $script:requestBodyContentTypeOther = $requestBodyContentTypeOther

    $script:requestBodyFormDataTypeDataGridViewComboBoxColumn = $requestBodyFormDataTypeDataGridViewComboBoxColumn
    $script:requestBodyFormDataSelectFileDataGridViewButtonColumn = $requestBodyFormDataSelectFileDataGridViewButtonColumn
    $script:requestBodyFormDataTextDataGridViewTextBoxColumn = $requestBodyFormDataTextDataGridViewTextBoxColumn
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

    $responseBodyRichTextBox = New-Object System.Windows.Forms.RichTextBox
    $responseBodyRichTextBox.Dock = 'Fill'
    $responseBodyRichTextBox.Multiline = $true
    $responseBodyRichTextBox.Font = '微軟正黑體,10pt'
    $responseBodyLayout.Controls.Add($responseBodyRichTextBox, 0, 0)

    $rightLayout.Controls.Add($layout)

    $script:responseStatusLabel = $responseStatusLabel
    $script:responseHeaderDataGridView = $responseHeaderDataGridView
    $script:responseBodyRichTextBox = $responseBodyRichTextBox
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
    $script:importButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        onImportButtonClick $object $e
    })
    $script:exportButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        onExportButtonClick $object $e
    })
    $script:removeButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        onRemoveButtonClick $object $e
    })
    $script:addButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        onAddButtonClick $object $e
    })
    $script:dataListBox.add_mouseDoubleClick({
        param([System.Windows.Forms.ListBox]$object, [System.Windows.Forms.MouseEventArgs]$e)
        onDataListBoxMouseDoubleClick $object $e
    })

    $script:methodComboBox.add_SelectedIndexChanged({
        param([System.Windows.Forms.ComboBox]$object, [System.EventArgs]$e)
        onMethodComboBoxChange
    })
    $script:sendButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        onSendButtonClick $object $e
    })

    $script:requestBodyContentTypeNone.add_CheckedChanged({
        param([System.Windows.Forms.RadioButton]$object, [System.EventArgs]$e)
        onRequestBodyContentTypeNoneCheck $object $e
    })
    $script:requestBodyContentTypeJson.add_CheckedChanged({
        param([System.Windows.Forms.RadioButton]$object, [System.EventArgs]$e)
        onRequestBodyContentTypeJsonCheck $object $e
    })
    $script:requestBodyContentTypeXml.add_CheckedChanged({
        param([System.Windows.Forms.RadioButton]$object, [System.EventArgs]$e)
        onRequestBodyContentTypeXmlCheck $object $e
    })
    $script:requestBodyContentTypeFormData.add_CheckedChanged({
        param([System.Windows.Forms.RadioButton]$object, [System.EventArgs]$e)
        onRequestBodyContentTypeFormDataCheck $object $e
    })
    $script:requestBodyContentTypeOther.add_CheckedChanged({
        param([System.Windows.Forms.RadioButton]$object, [System.EventArgs]$e)
        onRequestBodyContentTypeOtherCheck $object $e
    })

    $script:cryptoButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        onCryptoButtonClick $object $e
    })
    $script:hashButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        onHashButtonClick $object $e
    })
    $script:aboutButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        onAboutButtonClick $object $e
    })
    $script:settingButton.add_click({
        param([System.Windows.Forms.Button]$object, [System.EventArgs]$e)
        onSettingButtonClick $object $e
    })

    $script:requestBodyFormDataDataGridView.add_CellValueChanged({
        param([System.Windows.Forms.DataGridView]$object, [System.Windows.Forms.DataGridViewCellEventArgs]$e)
        onRequestBodyFormDataDataGridViewCellValueChange $object $e
    })

    $script:requestBodyFormDataDataGridView.add_CellContentClick({
        param([System.Windows.Forms.DataGridView]$object, [System.Windows.Forms.DataGridViewCellEventArgs]$e)
        onRequestBodyFormDataDataGridViewCellContentClick $object $e
    })
}

function onImportButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e) {

    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Title = '請選擇檔案'
    $dialog.Filter = 'JSON檔案 (*.json)| *.json'

    $result = $dialog.ShowDialog()
    if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
        return
    }

    $filepath = $dialog.FileName
    ReadAllData $filepath
    LoadData
}

function onExportButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e) {

    $dialog = New-Object System.Windows.Forms.SaveFileDialog
    $dialog.filter = "JSON檔案 (*.json)| *.json"
    $result = $dialog.ShowDialog()

    if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
        return
    }

    $filepath = $dialog.FileName
    WriteAllData $filepath
}

function onRemoveButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e) {

    $name = $script:dataListBox.SelectedItem
    RemoveTargetData $name
    $script:dataListBox.Items.Remove($name)
}

function onAddButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e) {

    $methodValue = GenerateRequestMethod
    $methodSuccess = $methodValue[0]
    $method = $methodValue[1]
    if ($methodSuccess -ne $true) {
        return
    }

    $urlValue = GenerateRequestUrl
    $urlSuccess = $urlValue[0]
    $url = $urlValue[1]
    if ($urlSuccess -ne $true) {
        return
    }

    $headerValue = GenerateRequestHeader
    $headerSuccess = $headerValue[0]
    $header = $headerValue[1]
    $contentType = $headerValue[2]
    if ($headerSuccess -ne $true) {
        return
    }

    $body = $null
    if ($reqMethod -eq 'POST' -or $reqMethod -eq 'PUT') {
        $bodyValue = GenerateRequestBody
        $bodySuccess = $bodyValue[0]
        $body = $bodyValue[1]
        if ($bodySuccess -ne $true) {
            return
        }
    }

    $result = RunAddDialog
    if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
        return
    }

    $name = GetAddName

    SaveTargetData $name $method $url $header $contentType $body

    $allData = GetAllData

    $script:dataListBox.BeginUpdate()
    $script:dataListBox.Items.Clear()
    foreach ($data in $allData) {
        $name = $data.name
        $script:dataListBox.Items.Add($name)
    }
    $script:dataListBox.EndUpdate()
}

function onSendButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e) {
    $requestMethodValue = GenerateRequestMethod
    $requestMethodSuccess = $requestMethodValue[0]
    $reqMethod = $requestMethodValue[1]
    if ($requestMethodSuccess -ne $true) {
        return
    }

    $requestUrlValue = GenerateRequestUrl
    $requestUrlSuccess = $requestUrlValue[0]
    $requestUrl = $requestUrlValue[1]
    if ($requestUrlSuccess -ne $true) {
        return
    }

    $requestHeadersValue = GenerateRequestHeader
    $requestHeadersSuccess = $requestHeadersValue[0]
    $requestHeaders = $requestHeadersValue[1]
    $requestContentType = $requestHeadersValue[2]
    if ($requestHeadersSuccess -ne $true) {
        return
    }

    $requestBody = $null
    if ($reqMethod -eq 'POST' -or $reqMethod -eq 'PUT') {
        $requestBodyValue = GenerateRequestBody
        $requestBodySuccess = $requestBodyValue[0]
        $requestBody = $requestBodyValue[1]
        if ($requestBodySuccess -ne $true) {
            return
        }
    }


    $script:responseStatusLabel.Text = '回應狀態: 請求中'
    $script:responseBodyRichTextBox.Text = ''
    for ($i = 0; $i -lt $script:responseHeaderDataGridView.Rows.Count - 1; $i++) {
        $script:responseHeaderDataGridView.Rows.RemoveAt(0)
    }


    $responseValue = (Request $reqMethod $requestUrl $requestContentType $requestHeaders $requestBody)
    [bool]$responseSuccess = $responseValue[0]
    [string]$responseMessage = $responseValue[1]
    [int]$responseStatusCode = $responseValue[2]
    [System.Collections.Generic.Dictionary[[string],[string]]]$responseHeaders = $responseValue[3]
    [string]$responseBody = $responseValue[4]

    if ($responseSuccess -ne $true) {
        $script:responseStatusLabel.Text = '回應狀態: 請求失敗'
        [System.Windows.Forms.MessageBox]::Show(
            $responseMessage,
            '錯誤',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
        return
    }


    [System.Windows.Forms.MessageBox]::Show(
        "$responseMessage($responseStatusCode)",
        '提示',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null

    $script:responseBodyRichTextBox.Text = $responseBody
    $script:responseStatusLabel.Text = "回應狀態: $responseStatusCode"
    foreach ($key in $responseHeaders.Keys) {
        $script:responseHeaderDataGridView.Rows.Add($key, $responseHeaders[$key])
    }
}

function onMethodComboBoxChange(
    [System.Windows.Forms.ComboBox]$object,
    [System.EventArgs]$e) {
    $method = $script:methodComboBox.SelectedItem

    $script:requestTabControl.Controls.Clear()
    $script:requestTabControl.Controls.Add($script:requestHeaderTabPage)

    if ($method -eq 'POST' -or $method -eq 'PUT') {
        $script:requestTabControl.Controls.Add($script:requestBodyTabPage)
    }
}

function onRequestBodyContentTypeNoneCheck(
    [System.Windows.Forms.RadioButton]$object,
    [System.EventArgs]$e) {
    $group = $script:requestBodyLayout.Controls[0]
    $script:requestBodyLayout.Controls.Clear()
    $script:requestBodyLayout.Controls.Add($group, 0, 0)

    $index = (FindIndexInDataGridView $script:requestHeaderDataGridView 'content-type' 0)

    if ($index -eq -1) {
        return
    }

    $script:requestHeaderDataGridView.Rows.RemoveAt($index)
}

function onRequestBodyContentTypeJsonCheck(
    [System.Windows.Forms.RadioButton]$object,
    [System.EventArgs]$e) {
    $group = $script:requestBodyLayout.Controls[0]
    $script:requestBodyLayout.Controls.Clear()
    $script:requestBodyLayout.Controls.Add($group, 0, 0)

    $script:requestBodyLayout.Controls.Add($script:requestBodyRichJsonTextBox, 1, 0)

    $index = (FindIndexInDataGridView $script:requestHeaderDataGridView 'content-type' 0)

    if ($index -ne -1) {
        $script:requestHeaderDataGridView.Rows[$index].Cells[1].Value = 'application/json'
        return
    }

    $script:requestHeaderDataGridView.Rows.Add('Content-Type', 'application/json')
}

function onRequestBodyContentTypeXmlCheck(
    [System.Windows.Forms.RadioButton]$object,
    [System.EventArgs]$e) {
    $group = $script:requestBodyLayout.Controls[0]
    $script:requestBodyLayout.Controls.Clear()
    $script:requestBodyLayout.Controls.Add($group, 0, 0)

    $script:requestBodyLayout.Controls.Add($script:requestBodyXmlRichTextBox, 1, 0)

    $index = (FindIndexInDataGridView $script:requestHeaderDataGridView 'content-type' 0)

    if ($index -ne -1) {
        $script:requestHeaderDataGridView.Rows[$index].Cells[1].Value = 'application/xml'
        return
    }

    $script:requestHeaderDataGridView.Rows.Add('Content-Type', 'application/xml')
}

function onRequestBodyContentTypeFormDataCheck(
    [System.Windows.Forms.RadioButton]$object,
    [System.EventArgs]$e) {
    $group = $script:requestBodyLayout.Controls[0]
    $script:requestBodyLayout.Controls.Clear()
    $script:requestBodyLayout.Controls.Add($group, 0, 0)

    $script:requestBodyLayout.Controls.Add($script:requestBodyFormDataDataGridView, 1, 0)

    $index = (FindIndexInDataGridView $script:requestHeaderDataGridView 'content-type' 0)

    if ($index -ne -1) {
        $script:requestHeaderDataGridView.Rows[$index].Cells[1].Value = 'multipart/form-data'
        return
    }

    $script:requestHeaderDataGridView.Rows.Add('Content-Type', 'multipart/form-data')
}

function onRequestBodyContentTypeOtherCheck(
    [System.Windows.Forms.RadioButton]$object,
    [System.EventArgs]$e) {
    $group = $script:requestBodyLayout.Controls[0]
    $script:requestBodyLayout.Controls.Clear()
    $script:requestBodyLayout.Controls.Add($group, 0, 0)

    $script:requestBodyLayout.Controls.Add($script:requestBodyOtherRichTextBox, 1, 0)

    $index = (FindIndexInDataGridView $script:requestHeaderDataGridView 'content-type' 0)

    if ($index -ne -1) {
        $script:requestHeaderDataGridView.Rows[$index].Cells[1].Value = ''
        return
    }

    $script:requestHeaderDataGridView.Rows.Add('Content-Type', '')
}

function onCryptoButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e) {

    [System.Windows.Forms.MessageBox]::Show(
        '敬請期待',
        '提示',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
}

function onHashButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e) {

    [System.Windows.Forms.MessageBox]::Show(
        '敬請期待',
        '提示',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
}

function onAboutButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e) {
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

function onSettingButtonClick(
    [System.Windows.Forms.Button]$object,
    [System.EventArgs]$e) {
    RunSetting
}

function onRequestBodyFormDataDataGridViewCellValueChange(
    [System.Windows.Forms.DataGridView]$object,
    [System.Windows.Forms.DataGridViewCellEventArgs]$e) {

    $rowIndex = $e.RowIndex
    $columnIndex = $e.ColumnIndex

    $row = $object.Rows[$rowIndex]

    [System.Windows.Forms.DataGridViewComboBoxCell]$typeCell = $row.Cells[1]
    if ($null -eq $typeCell.Value) {
        $typeCell.Value = $object.Columns[1].Items[0]
    }

    if ($columnIndex -eq 3) {
        $typeCell.Value = $object.Columns[1].Items[1]
    }
}

function onRequestBodyFormDataDataGridViewCellContentClick(
    [System.Windows.Forms.DataGridView]$object,
    [System.Windows.Forms.DataGridViewCellEventArgs]$e) {

    $rowIndex = $e.RowIndex
    $columnIndex = $e.ColumnIndex

    $row = $object.Rows[$rowIndex]

    [System.Windows.Forms.DataGridViewComboBoxCell]$typeCell = $row.Cells[1]
    [System.Windows.Forms.DataGridViewTextBoxCell]$textCell = $row.Cells[3]

    if ($columnIndex -eq 2) {
        $dialog = New-Object System.Windows.Forms.OpenFileDialog
        $dialog.Title = '請選擇檔案'
        $dialog.Filter = '檔案 (*.*)| *.*'

        $result = $dialog.ShowDialog()
        if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
            return
        }

        $textCell.Value = $dialog.FileName
        $typeCell.Value = $object.Columns[1].Items[0]
    }
}

function onDataListBoxMouseDoubleClick(
    [System.Windows.Forms.ListBox]$object,
    [System.Windows.Forms.MouseEventArgs]$e) {

    $result = [System.Windows.Forms.MessageBox]::Show(
        '請確認載入選擇的資料',
        '提示',
        [System.Windows.Forms.MessageBoxButtons]::OKCancel,
        [System.Windows.Forms.MessageBoxIcon]::Information)

    if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
        return
    }

    $index = $object.IndexFromPoint($e.Location)
    $item = $object.Items[$index]

    $data = (LoadTargetData $item)

    $success = $data[0]
    if (-not $success) {
        return
    }

    [string]$method = $data[1]
    [string]$url = $data[2]
    [System.Collections.Generic.Dictionary[[string],[string]]]$headers = $data[3]
    [string]$contentType = $data[4]
    $body = $data[5]

    $script:methodComboBox.SelectedItem = $method
    $script:urlTextBox.Text = $url;

    $script:requestHeaderDataGridView.Rows.Clear()
    if ($null -ne $headers) {
        foreach ($key in $headers.Keys) {
            $value = $headers[$key]
            $script:requestHeaderDataGridView.Rows.Add($key, $value)
        }
    }

    if ($null -ne $contentType) {
        $index = (FindIndexInDataGridView $script:requestHeaderDataGridView 'content-type' 0)
        if ($index -ne -1) {
            $script:requestHeaderDataGridView.Rows[$index].Cells[1].Value = $contentType
        } else {
            $script:requestHeaderDataGridView.Rows.Add('Content-Type', $contentType)
        }
    }


    $script:requestBodyContentTypeNone.Checked = $true
    $script:requestBodyContentTypeXml.Checked = $false
    $script:requestBodyContentTypeJson.Checked = $false
    $script:requestBodyContentTypeFormData.Checked = $false
    $script:requestBodyContentTypeOther.Checked = $false

    if ($null -ne $body) {

        if ($body -is [string] -and $contentType -eq 'application/json') {
            $script:requestBodyContentTypeJson.Checked = $true
            $script:requestBodyRichJsonTextBox.Text = $body
        } elseif ($body -is [string] -and $contentType -eq 'application/xml') {
            $script:requestBodyContentTypeXml.Checked = $true
            $script:requestBodyXmlRichTextBox.Text = $body
        } elseif ($body -is [System.Collections.Generic.List[object]] -and $contentType -eq 'multipart/form-data') {
            $script:requestBodyContentTypeFormData.Checked = $true
            $script:requestBodyFormDataDataGridView.Rows.Clear()
            foreach ($item in $body) {
                if ($item.type -ne 'text' -and $item.type -ne 'file') {
                    continue
                }

                $requestBodyFormDataDataGridView.Rows.Add()
                $index = $requestBodyFormDataDataGridView.Rows.RowCount - 2
                $requestBodyFormDataDataGridView.Rows[$index].Cells[0].Value = $item.name
                $requestBodyFormDataDataGridView.Rows[$index].Cells[1].Value = $item.text
                $requestBodyFormDataDataGridView.Rows[$index].Cells[2].Value = '選擇檔案'
                $requestBodyFormDataDataGridView.Rows[$index].Cells[3].Value = $item.type

            }

        } elseif ($body -is [string]) {
            $script:requestBodyContentTypeOther.Checked = $true
            $script:requestBodyOtherRichTextBox.Text = $body
        }
    }
}

function LoadData() {
    $allData = GetAllData

    $script:dataListBox.BeginUpdate()
    $script:dataListBox.Items.Clear()
    foreach ($data in $allData) {
        $name = $data.name
        $script:dataListBox.Items.Add($name)
    }
    $script:dataListBox.EndUpdate()
}

function GenerateRequestMethod() {
    $method = $script:methodComboBox.SelectedItem
    return @($true, $method)
}

function GenerateRequestUrl() {
    $url = $script:urlTextBox.Text
    if ($url -eq '') {
        [System.Windows.Forms.MessageBox]::Show(
        '請填寫請求網址',
        '提示',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        return @($false, $null)
    }

    if (-not $url.ToLower().StartsWith('http:') -and
        -not $url.ToLower().StartsWith('https:')) {
        [System.Windows.Forms.MessageBox]::Show(
        '請確認請求網址是否為HTTP/HTTPS請求',
        '錯誤',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
        return @($false, $null)
    }

    return @($true, $url)
}

function GenerateRequestHeader() {
    $headerCount = $script:requestHeaderDataGridView.Rows.Count
    if ($headerCount -le 0) {
        return @($true, $null, $null)
    }

    $headers = New-Object System.Collections.Generic.Dictionary'[String,String]'
    $contentType = $null

    for ($i = 0; $i -lt $headerCount; $i++) {
        $row = $script:requestHeaderDataGridView.Rows[$i]

        $header = $row.Cells[0]
        if ($null -eq $header) {
            continue
        }

        $value = $row.Cells[1]
        if ($null -eq $value) {
            continue
        }

        $headerValue = $header.Value
        if ($null -eq $headerValue) {
            continue
        }

        if ($headerValue -eq '') {
            [System.Windows.Forms.MessageBox]::Show(
            '請確認請求標頭內容填寫完整，發現未填寫的標頭鍵值',
            '提示',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
            return @($false, $null, $null)
        }

        $valueValue = $value.Value
        if ($null -eq $valueValue) {
            continue
        }

        if ($valueValue -eq '') {
            [System.Windows.Forms.MessageBox]::Show(
            '請確認請求標頭內容填寫完整，發現未填寫的標頭值',
            '提示',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
            return @($false, $null, $null)
        }

        if ($headers.ContainsKey($headerValue) -or
            ($null -ne $contentType -and $headerValue.ToLower() -eq 'content-type')) {
            [System.Windows.Forms.MessageBox]::Show(
            '請確認請求標頭內容，包含重複請求標頭鍵值',
            '錯誤',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
            return @($false, $null, $null)
        }

        if ($headerValue.ToLower() -eq 'content-type') {
            $contentType = $valueValue
            continue
        }

        $headers.Add($headerValue, $valueValue)
    }

    return @($true, $headers, $contentType)
}

function GenerateRequestBody () {
    if ($script:requestBodyContentTypeJson.Checked) {
        return GenerateRequestJsonBody
    }

    if ($script:requestBodyContentTypeXml.Checked) {
        return GenerateRequestXmlBody
    }

    if ($script:requestBodyContentTypeFormData.Checked) {
        return GenerateRequestFormDataBody
    }

    if ($script:requestBodyContentTypeOther.Checked) {
        return GenerateRequestOtherBody
    }

    return ($true, $null)
}

function GenerateRequestJsonBody() {
    $body = $script:requestBodyRichJsonTextBox.Text
    if ($body -eq '') {
        [System.Windows.Forms.MessageBox]::Show(
        '請輸入請求體 JSON 字串內容',
        '提示',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        return @($false, $null)
    }

    $verifyJson = GetVerifyJson

    if ($verifyJson) {
        try {
            ConvertFrom-Json $body
        } catch {
            [System.Windows.Forms.MessageBox]::Show(
            '請確認請求體 JSON 字串內容格式正確',
            '錯誤',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error)  | Out-Null
            return @($false, $null)
        }
    }

    return @($true, $body)
}

function GenerateRequestXmlBody() {
    $body = $script:requestBodyXmlRichTextBox.Text
    if ($body -eq '') {
        [System.Windows.Forms.MessageBox]::Show(
        '請輸入請求體 XML 字串內容',
        '提示',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        return @($false, $null)
    }

    $verifyXml = GetVerifyXml

    if ($verifyXml) {
        try {
            [xml]$body
        } catch {
            [System.Windows.Forms.MessageBox]::Show(
            '請確認請求體 XML 字串內容格式正確',
            '錯誤',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
            return @($false, $null)
        }
    }

    return @($true, $body)
}

function GenerateRequestFormDataBody() {
    $body = New-Object System.Collections.Generic.Dictionary'[String,object]'

    $dataGridView = $script:requestBodyFormDataDataGridView
    $rows = $dataGridView.Rows
    $rowCount = $rows.Count
    for ($i = 0; $i -lt $rowCount; $i++) {
        $row = $rows[$i]

        $nameCell = $row.Cells[0]
        if ($null -eq $nameCell) {
            continue
        }
        $nameValue = $nameCell.Value

        $typeCell = $row.Cells[1]
        if ($null -eq $typeCell) {
            continue
        }
        $typeValue = $typeCell.Value

        $textCell = $row.Cells[3]
        if ($null -eq $textCell) {
            continue
        }
        $textValue = $textCell.Value

        if (($nameValue -eq '' -or $null -eq $nameValue) -and
            ($typeValue -eq '' -or $null -eq $typeValue) -and
            ($textValue -eq '' -or $null -eq $textValue)) {
            continue
        }

        if ($nameValue -eq '' -or
            $typeValue -eq '' -or
            $textValue -eq '' -or
            $null -eq $nameValue -or
            $null -eq $typeValue -or
            $null -eq $textValue) {
            [System.Windows.Forms.MessageBox]::Show(
                '請輸入確認請求體內容填寫完整，發現表單中發現空值',
                '提示',
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
            return @($false, $null)
        }

        if ($typeValue -eq $dataGridView.Columns[1].Items[0] -and
            -not (Test-Path -Path $textValue)) {
            [System.Windows.Forms.MessageBox]::Show(
                '請輸入確認所有指定檔案皆存在',
                '錯誤',
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
            return @($false, $null)
        }

        if ($body.ContainsKey($nameValue)) {
            [System.Windows.Forms.MessageBox]::Show(
                '請確認請求體內容填寫正確，發現重複鍵值',
                '錯誤',
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
            return @($false, $null)
        }

        if ($typeValue -eq $dataGridView.Columns[1].Items[0]) {
            $body.Add($nameValue, [IO.File]::ReadAllText($textValue))
        } else {
            $body.Add($nameValue, $textValue)
        }
    }

    return @($true, $body)
}

function GenerateRequestOtherBody() {
    $body = $script:requestBodyOtherRichTextBox.Text
    if ($body -eq '') {
        [System.Windows.Forms.MessageBox]::Show(
        '請輸入請求體字串內容',
        '提示',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        return @($false, $null)
    }
    return @($true, $body)
}

function FindIndexInDataGridView (
    [System.Windows.Forms.DataGridView]$dataGridView,
    [string]$value,
    [int]$columnIndex) {
    $index = -1
    $rowCount = $dataGridView.Rows.Count
    for ($i = 0; $i -lt $rowCount; $i++) {
        $row = $dataGridView.Rows[$i]

        $column = $row.Cells[$columnIndex]
        if ($null -eq $column) {
            continue
        }

        $cellValue = $column.Value
        if ($null -eq $cellValue) {
            continue
        }

        if ($cellValue.ToLower() -eq $value) {
            $index = $i
            break
        }
    }
    return $index
}

function RunUI() {
    $script:window.ShowDialog()
}

function Run() {
    Init
    RunUI
}

Export-ModuleMember -Function Run
