using namespace System.Windows.Forms
using module PSLogger
<#
using module ".\PSForm.psm1"

class TestForm : PSForm {
    TestForm() : base($null) {
    }

    InitializeComponent() {
        [PSLogger]::LogLevel = [PSLogLevel]::Debug

        $this.Form.Width = 400
        $this.Form.Height = 400
        $this.Form.Text = "Test Form"

        $button = [Button]::new()
        $button.Text = "Test"
        $button.Width = 200
        $button.Height = 100
        $button.Left = ($this.Form.Width - $button.Width) / 2
        $button.Top = ($this.Form.Height - $button.Height) / 2
        $this.AddClick($button, "Button_Click")

        $this.Form.Controls.Add($button)
    }

    Button_Click([Object] $sender, [EventHandler] $e) {
        [MessageBox]::Show("Button Clicked!")
    }
}

$testForm = [TestForm]::new()
$testForm.Form.ShowDialog()
#>
$logger = [PSLogger]::GetLogger()
$logger.WriteInfo("FormTest!")