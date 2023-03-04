﻿function Init() {
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
    $window.Text = '雜湊火箭'
    $window.Width = 600
    $window.Height = 700
    $window.AutoSize = $true
    $window.TopMost = $true

    $layout = New-Object System.Windows.Forms.TableLayoutPanel
    $layout.Dock = 'Fill'
    $layout.AutoSize = $true
    $window.Controls.Add($layout)

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
