function GenerateForm {

[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null

$form1 = New-Object System.Windows.Forms.Form
$quitBTn = New-Object System.Windows.Forms.Button
$checkLabel = New-Object System.Windows.Forms.Label
$addBtn = New-Object System.Windows.Forms.Button
$removeBtn = New-Object System.Windows.Forms.Button
$label2 = New-Object System.Windows.Forms.Label
$groupTextbox = New-Object System.Windows.Forms.TextBox
$checkBtn = New-Object System.Windows.Forms.Button
$groupBox1 = New-Object System.Windows.Forms.GroupBox
$checkBox4 = New-Object System.Windows.Forms.CheckBox
$checkBox3 = New-Object System.Windows.Forms.CheckBox
$checkBox2 = New-Object System.Windows.Forms.CheckBox
$checkBox1 = New-Object System.Windows.Forms.CheckBox
$browseBtn = New-Object System.Windows.Forms.Button
$label1 = New-Object System.Windows.Forms.Label
$browseTextbox = New-Object System.Windows.Forms.TextBox
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

$addBtn_OnClick= {
    if($checkBox1.Checked -eq $true){
        $acl = Get-ACL $browseTextbox.Text
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($groupTextbox.Text,"FullControl","ContainerInherit,ObjectInherit","None","Allow")
        $acl.SetAccessRule($AccessRule)
        $acl.SetAccessRuleProtection($false,$true)
        $acl | Set-Acl $browseTextbox.Text
    } elseif ($checkBox2.Checked -eq $true){
        $acl = Get-ACL $browseTextbox.Text
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($groupTextbox.Text,"Modify","ContainerInherit,ObjectInherit","None","Allow")
        $acl.SetAccessRule($AccessRule)
        $acl.SetAccessRuleProtection($false,$true)
        $acl | Set-Acl $browseTextbox.Text
    } elseif ($checkBox3.Checked -eq $true){
        $acl = Get-ACL $browseTextbox.Text
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($groupTextbox.Text,"Write,ReadandExecute","ContainerInherit,ObjectInherit","None","Allow")
        $acl.SetAccessRule($AccessRule)
        $acl.SetAccessRuleProtection($false,$true)
        $acl | Set-Acl $browseTextbox.Text
    } elseif($checkBox4.Checked -eq $true){
        $acl = Get-ACL $browseTextbox.Text
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($groupTextbox.Text,"ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow")
        $acl.SetAccessRule($AccessRule)
        $acl.SetAccessRuleProtection($false,$true)
        $acl | Set-Acl $browseTextbox.Text
    }
}

$checkBtn_OnClick= {
    $groups = $groupTextbox.Text
    foreach($group in $groups.split(";")){
        
    }
}

$browseBtn_OnClick= 
{
    Function Select-FolderDialog
    {
        param([string]$Description="Select Folder",[string]$RootFolder="Desktop")
    
     [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
         Out-Null     
    
       $objForm = New-Object System.Windows.Forms.FolderBrowserDialog
            $objForm.Rootfolder = $RootFolder
            $objForm.Description = $Description
            $Show = $objForm.ShowDialog()
            If ($Show -eq "OK")
            {
                Return $objForm.SelectedPath
            }
            Else
            {
                Write-Error "Operation cancelled by user."
            }
        }
    $folder = Select-FolderDialog
    $browseTextbox.Text = $folder
}

$quitBTn_OnClick={
    $form1.Close()
}

$removeBtn_OnClick= {
    $acl=get-acl $browseTextbox.Text
    $accessrule = New-Object system.security.AccessControl.FileSystemAccessRule($groupTextbox.Text,"Read",,,"Allow")
    $acl.RemoveAccessRuleAll($accessrule)
    Set-Acl -Path $browseTextbox.Text -AclObject $acl
}

$handler_label1_Click= {


}

$handler_checkBox3_CheckedChanged= {


}

$OnLoadForm_StateCorrection={
	$form1.WindowState = $InitialFormWindowState
}

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 215
$System_Drawing_Size.Width = 481
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.Name = "form1"
$form1.Text = "Group Permission Editor"


$quitBTn.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 394
$System_Drawing_Point.Y = 180
$quitBTn.Location = $System_Drawing_Point
$quitBTn.Name = "quitBTn"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$quitBTn.Size = $System_Drawing_Size
$quitBTn.TabIndex = 9
$quitBTn.Text = "Quit"
$quitBTn.UseVisualStyleBackColor = $True
$quitBTn.add_Click($quitBTn_OnClick)

$form1.Controls.Add($quitBTn)

$checkLabel.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 92
$checkLabel.Location = $System_Drawing_Point
$checkLabel.Name = "checkLabel"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 14
$System_Drawing_Size.Width = 243
$checkLabel.Size = $System_Drawing_Size
$checkLabel.TabIndex = 7

$form1.Controls.Add($checkLabel)


$addBtn.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 180
$addBtn.Location = $System_Drawing_Point
$addBtn.Name = "addBtn"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$addBtn.Size = $System_Drawing_Size
$addBtn.TabIndex = 8
$addBtn.Text = "Add"
$addBtn.UseVisualStyleBackColor = $True
$addBtn.add_Click($addBtn_OnClick)

$form1.Controls.Add($addBtn)


$removeBtn.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 108
$System_Drawing_Point.Y = 180
$removeBtn.Location = $System_Drawing_Point
$removeBtn.Name = "removeBtn"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$removeBtn.Size = $System_Drawing_Size
$removeBtn.TabIndex = 10
$removeBtn.Text = "Remove"
$removeBtn.UseVisualStyleBackColor = $True
$removeBtn.add_Click($removeBtn_OnClick)

$form1.Controls.Add($removeBtn)

$label2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 50
$label2.Location = $System_Drawing_Point
$label2.Name = "label2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 16
$System_Drawing_Size.Width = 343
$label2.Size = $System_Drawing_Size
$label2.TabIndex = 6
$label2.Text = "Enter the name of the groups you want to add to the folder:"
$label2.add_Click($handler_label2_Click)

$form1.Controls.Add($label2)

$groupTextbox.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 69
$groupTextbox.Location = $System_Drawing_Point
$groupTextbox.Name = "groupTextbox"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 367
$groupTextbox.Size = $System_Drawing_Size
$groupTextbox.TabIndex = 5

$form1.Controls.Add($groupTextbox)


$checkBtn.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 398
$System_Drawing_Point.Y = 67
$checkBtn.Location = $System_Drawing_Point
$checkBtn.Name = "checkBtn"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$checkBtn.Size = $System_Drawing_Size
$checkBtn.TabIndex = 4
$checkBtn.Text = "Check"
$checkBtn.UseVisualStyleBackColor = $True
$checkBtn.add_Click($checkBtn_OnClick)

$form1.Controls.Add($checkBtn)


$groupBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 119
$groupBox1.Location = $System_Drawing_Point
$groupBox1.Name = "groupBox1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 55
$System_Drawing_Size.Width = 444
$groupBox1.Size = $System_Drawing_Size
$groupBox1.TabIndex = 3
$groupBox1.TabStop = $False
$groupBox1.Text = "Permission Types:"

$form1.Controls.Add($groupBox1)

$checkBox4.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 334
$System_Drawing_Point.Y = 19
$checkBox4.Location = $System_Drawing_Point
$checkBox4.Name = "checkBox4"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$checkBox4.Size = $System_Drawing_Size
$checkBox4.TabIndex = 3
$checkBox4.Text = "Read Only"
$checkBox4.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($checkBox4)


$checkBox3.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 221
$System_Drawing_Point.Y = 19
$checkBox3.Location = $System_Drawing_Point
$checkBox3.Name = "checkBox3"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 100
$checkBox3.Size = $System_Drawing_Size
$checkBox3.TabIndex = 2
$checkBox3.Text = "Read && Write"
$checkBox3.UseVisualStyleBackColor = $True
$checkBox3.add_CheckedChanged($handler_checkBox3_CheckedChanged)

$groupBox1.Controls.Add($checkBox3)


$checkBox2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 116
$System_Drawing_Point.Y = 19
$checkBox2.Location = $System_Drawing_Point
$checkBox2.Name = "checkBox2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 57
$checkBox2.Size = $System_Drawing_Size
$checkBox2.TabIndex = 1
$checkBox2.Text = "Modify"
$checkBox2.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($checkBox2)


$checkBox1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 19
$checkBox1.Location = $System_Drawing_Point
$checkBox1.Name = "checkBox1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 104
$checkBox1.Size = $System_Drawing_Size
$checkBox1.TabIndex = 0
$checkBox1.Text = "Full Control"
$checkBox1.UseVisualStyleBackColor = $True

$groupBox1.Controls.Add($checkBox1)



$browseBtn.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 398
$System_Drawing_Point.Y = 24
$browseBtn.Location = $System_Drawing_Point
$browseBtn.Name = "browseBtn"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$browseBtn.Size = $System_Drawing_Size
$browseBtn.TabIndex = 2
$browseBtn.Text = "Browse"
$browseBtn.UseVisualStyleBackColor = $True
$browseBtn.add_Click($browseBtn_OnClick)

$form1.Controls.Add($browseBtn)

$label1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 9
$label1.Location = $System_Drawing_Point
$label1.Name = "label1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 14
$System_Drawing_Size.Width = 269
$label1.Size = $System_Drawing_Size
$label1.TabIndex = 1
$label1.Text = "Enter the folder you want to change the permissions on:"
$label1.add_Click($handler_label1_Click)

$form1.Controls.Add($label1)

$browseTextbox.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 26
$browseTextbox.Location = $System_Drawing_Point
$browseTextbox.Name = "browseTextbox"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 367
$browseTextbox.Size = $System_Drawing_Size
$browseTextbox.TabIndex = 0

$form1.Controls.Add($browseTextbox)

$InitialFormWindowState = $form1.WindowState
$form1.add_Load($OnLoadForm_StateCorrection)
$form1.ShowDialog()| Out-Null

}
GenerateForm