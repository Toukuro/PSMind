using namespace System.Windows.Forms

using module PSLogger
using module ".\PSForm.psm1"

class TestForm : PSForm {
    <#
    UnitTest Frameworkを介さない方式のテストプログラム。
    実行前に以下のコマンド実行する必要がある。
    Add-Type -AssemblyName System.Windows.Forms
    #>
    TestForm() : base($null) {
    }

    InitializeComponent() {
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

    Button_Click([Object] $sender, [EventArgs] $e) {
        [MessageBox]::Show("Button Clicked!")
    }
}
$logger = [PSLogger]::GetLogger()
$logger.LogLevel = [PSLogLevel]::Debug

$logger.WriteInfo("FormTest Start!")

$testForm = [TestForm]::new()
$testForm.Form.ShowDialog()

$logger.WriteInfo("FormTest End.")