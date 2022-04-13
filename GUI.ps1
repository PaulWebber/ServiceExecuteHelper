# https://theitbros.com/powershell-gui-for-scripts/
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Execute Service Starter'
$main_form.Width = 300
$main_form.Height = 600
$main_form.AutoSize = $true
#load things
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Services"
$Label.Location  = New-Object System.Drawing.Point(0,10)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)
#laod combo
$ComboBox = New-Object System.Windows.Forms.ComboBox
$ComboBox.Width = 300
#add contents
#$Exeservices = Get-Service | Where {$_.Name -like "Afe*" -or $_.Name -like "Aucerna*"}
$Exeservices = (Get-cimInstance win32_service -filter "name like '%AFE%' or name like 'Aucerna%'").name
Foreach ($Exeservice in $Exeservices)
{
    $cleaned = $Execservice.substring(6,10);
    $ComboBox.Items.Add($Exeservice)
}

$ComboBox.Location  = New-Object System.Drawing.Point(60,10)
$main_form.Controls.Add($ComboBox)

$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "Status:"
$Label2.Location  = New-Object System.Drawing.Point(0,40)
$Label2.AutoSize = $true
$main_form.Controls.Add($Label2)
$Label3 = New-Object System.Windows.Forms.Label
$Label3.Text = "Select a Service"
$Label3.Location  = New-Object System.Drawing.Point(110,40)
$Label3.AutoSize = $true
$main_form.Controls.Add($Label3)
$Label4 = New-Object System.Windows.Forms.Label
$Label4.Text = "Installed at"
$Label4.Location  = New-Object System.Drawing.Point(0,60)
$Label4.AutoSize = $true
$main_form.Controls.Add($Label4)
$Label5 = New-Object System.Windows.Forms.Label
$Label5.Text = "Select a Service"
$Label5.Location  = New-Object System.Drawing.Point(110,60)
$Label5.AutoSize = $true
$main_form.Controls.Add($Label5)

$Label9 = New-Object System.Windows.Forms.Label
$Label9.Text = "Log will show here"
$Label9.Location  = New-Object System.Drawing.Point(0,150)
$Label9.AutoSize = $true
$main_form.Controls.Add($Label9)

$Label8 = New-Object System.Windows.Forms.Label
$Label8.Text = "Start"
$Label8.Location  = New-Object System.Drawing.Point(0,80)
$Label8.AutoSize = $true
$main_form.Controls.Add($Label8)

$Checkbox1 = New-Object System.Windows.Forms.CheckBox
$Checkbox1.Location  = New-Object System.Drawing.Point(50,80)
$Checkbox1.AutoSize = $true
$Checkbox1.Enabled = $false
$main_form.Controls.Add($Checkbox1)


$Label6 = New-Object System.Windows.Forms.Label
$Label6.Text = "Stop"
$Label6.Location  = New-Object System.Drawing.Point(0,100)
$Label6.AutoSize = $true
$main_form.Controls.Add($Label6)

$Checkbox2 = New-Object System.Windows.Forms.CheckBox
$Checkbox2.Location  = New-Object System.Drawing.Point(50,100)
$Checkbox2.AutoSize = $true
$Checkbox2.Enabled = $false
$main_form.Controls.Add($Checkbox2)

$Label7 = New-Object System.Windows.Forms.Label
$Label7.Text = "Restart"
$Label7.Location  = New-Object System.Drawing.Point(0,120)
$Label7.AutoSize = $true
$main_form.Controls.Add($Label7)

$Checkbox3 = New-Object System.Windows.Forms.CheckBox
$Checkbox3.Location  = New-Object System.Drawing.Point(50,120)
$Checkbox3.AutoSize = $true
$Checkbox3.Enabled = $false
$main_form.Controls.Add($Checkbox3)

$ComboBox.add_SelectedIndexChanged(
    {
        $selectedService = $ComboBox.SelectedItem
        $AFEServName = "*"+$selectedService.substring($selectedService.IndexOf('[')+1,$selectedService.IndexOf(']') - $selectedService.IndexOf('[')-1)+"*"
        $installLocation = (Get-cimInstance win32_service -filter "name = 'AFE Navigator Service [AFE2017]'").pathname
        $serviceDeets = Get-Service | Where {$_.DisplayName -like $AFEServName}
        $Label3.Text = $serviceDeets.Status
        $Label5.Text = split-path $installLocation -parent
        $Checkbox1.Checked = $false
        $Checkbox2.Checked = $false
        $Checkbox3.Checked = $false
        if ($Label3.Text -eq "Running"){
            $Checkbox1.Enabled = $false
            $Checkbox2.Enabled = $true
            $Checkbox3.Enabled = $true
        }
        if ($Label3.Text -eq "Stopped"){
            $Checkbox1.Enabled = $true
            $Checkbox2.Enabled = $false
            $Checkbox3.Enabled = $false
        }
    }
)

#button
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(110,120)
$Button.Size = New-Object System.Drawing.Size(80,23)
$Button.Text = "Action"
#button event
$Button.Add_Click({
        $AFEorEx = $ComboBox.SelectedItem
        $afeLog = $Label5.Text + "\AfeNavigatorServer.log"
        $executeLog = $Label5.Text + "\AucernaExecuteServer.log"
        if ($AFEorEx -like "AFE*")
            {
                $Label9.Text = $afeLog
            }
        if ($AFEorEx -like "Aucerna*")
            {
                $Label9.Text = $executelog
            }
        if ($Checkbox1.Checked -eq $true)
            {
                Start-Service -DisplayName $AFEorEx
            }
        if ($Checkbox2.Checked -eq $true)
            {
                Stop-Service -Name $AFEorEx 
            }
        if ($Checkbox3.Checked -eq $true)
            {
                Restart-Service -DisplayName $AFEorEx
            }


 # Get-Service -DisplayName $AFEorEx | Stop-Service
 # Start-Service -DisplayName $AFEorEx
 # Restart-Service -DisplayName $AFEorEx
    }
)

#button
$Button1 = New-Object System.Windows.Forms.Button
$Button1.Location = New-Object System.Drawing.Size(110,80)
$Button1.Size = New-Object System.Drawing.Size(80,23)
$Button1.Text = "View Log"
#button event
$Button1.Add_Click({
        write-host "hello"
    }
)
$main_form.Controls.Add($Button1)

#button
$Button2 = New-Object System.Windows.Forms.Button
$Button2.Location = New-Object System.Drawing.Size(110,100)
$Button2.Size = New-Object System.Drawing.Size(80,23)
$Button2.Text = "Clear Log"
#button event
$Button2.Add_Click({

    }
)
$main_form.Controls.Add($Button2)

$Checkbox2.Add_CheckStateChanged(
    {
        if ($Checkbox2.Checked -eq $true)
            {
                $Checkbox3.Checked = $false
                $Checkbox3.Enabled = $false
            }
        if ($Checkbox2.Checked -eq $false)
            {
                $Checkbox3.Enabled = $true
            }
    }
)

$Checkbox3.Add_CheckStateChanged(
    {
        if ($Checkbox3.Checked -eq $true)
            {
                $Checkbox2.Checked = $false
                $Checkbox2.Enabled = $false
            }
        if ($Checkbox3.Checked -eq $false)
            {
                $Checkbox2.Enabled = $true
            }
    }
)




$main_form.Controls.Add($Button)
#show everything
$main_form.ShowDialog()
# load things now
