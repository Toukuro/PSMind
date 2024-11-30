using namespace System.Windows.Forms
using namespace System.Drawing

using module PSForm

class PSMindForm : PSForm {
    PSMindForm($model) : base($model) {
    }

    InitializeComponent() {
        [Screen] $screen = [Screen]::PrimaryScreen
        $this.Form.Left = 0
        $this.Form.Top = 0
        $this.Form.Width = $screen.WorkingArea.Width
        $this.Form.Height = $screen.WorkingArea.Height

        $this.Form.Text = "PSMind"

        $this.Form.Activate()
    }
}