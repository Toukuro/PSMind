using namespace System.Windows.Forms
using module PSLogger
using module ".\PSForm.psm1"

# �e�X�g�̎��s���@�F
#  Invoke-Pester -Path .\PSFormTest.ps1
# VSCode�ł͎��O�Ɉȉ��̃R�}���h�����s����K�v����
#�@Add-Type -AssemblyName System.Windows.Forms
Describe "PSForm�̃e�X�g" {
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

    Context "�{�^����1�����̃t�H�[�����J���āA���삷���OK" {
        $testForm = [TestForm]::new()
        $testForm.Form.ShowDialog()
    }
}