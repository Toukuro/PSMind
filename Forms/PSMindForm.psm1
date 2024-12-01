using namespace System.ComponentModel
using namespace System.Windows.Forms
using namespace System.Drawing

using module PSForm

class PSMindForm : PSForm {
    [MenuItem] $FileMenuOpen
    [MenuItem] $FileMenuSave
    [MenuItem] $FileMenuExit

    PSMindForm($model) : base($model) {
    }

    InitializeComponent() {
        [Screen] $screen = [Screen]::PrimaryScreen
        $this.Form.Left = 0
        $this.Form.Top = 0
        $this.Form.Width = $screen.WorkingArea.Width
        $this.Form.Height = $screen.WorkingArea.Height
        $this.Form.Text = "PSMind"

        # ファイルメニュー
        $fileMenu = [MenuItem]::new('ファイル')

        $this.FileMenuOpen = [MenuItem]::new('開く')
        $this.AddClick($this.FileMenuOpen, "FileMenuOpen_Click")
        $fileMenu.MenuItems.Add($this.FileMenuOpen)

        $this.FileMenuSave = [MenuItem]::new('保存')
        $this.AddClick($this.FileMenuSave, "FileMenuSave_Click")
        $fileMenu.MenuItems.Add($this.FileMenuSave)
        
        $this.FileMenuExit = [MenuItem]::new('終了')
        $this.AddClick($this.FileMenuExit, "FileMenuExit_Click")
        $fileMenu.MenuItems.Add($this.FileMenuExit)
        
        $menu = [MainMenu]::new()
        $menu.MenuItems.Add($fileMenu)
        $this.Form.Menu = $menu
        
        $this.Form.Activate()
    }

    FileMenuOpen_Click([Object] $sender, [EventArgs] $e) {
        $this.Logger.WriteDebug("PSMindForm.FileMenuOpen_Click: occured.")
    }

    FileMenuSave_Click([Object] $sender, [EventArgs] $e) {
        $this.Logger.WriteDebug("PSMindForm.FileMenuSave_Click: occured.")
    }

    FileMenuExit_Click([Object] $sender, [EventArgs] $e) {
        $this.Logger.WriteDebug("PSMindForm.FileMenuExit_Click: occured.")
    }
}