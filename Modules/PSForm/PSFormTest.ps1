using namespace System.Windows.Forms
using module PSLogger
using module ".\PSForm.psm1"

# テストの実行方法：
#  Invoke-Pester -Path .\PSFormTest.ps1
# VSCodeでは事前に以下のコマンドを実行する必要あり
#　Add-Type -AssemblyName System.Windows.Forms
Describe "PSFormのテスト" {
    class TestForm : PSForm {
        TestForm() : base($null) {
        }

        InitializeComponent() {
            $this.Logger.LogLevel = [PSLogLevel]::Debug

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

    Context "ボタンが1つだけのフォームが開いて、動作すればOK" {
        $testForm = [TestForm]::new()
        $testForm.Form.ShowDialog()
    }
}