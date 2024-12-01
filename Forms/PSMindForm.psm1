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
        
        $menu = [MainMenu]::new()
        $this._AddFileMenu($menu)
        $this.Form.Menu = $menu
        
        $this.Form.Activate()
    }

    _AddFileMenu([MainMenu] $mainMenu) {
        $fileMenu = [MenuItem]::new('ファイル')

        $this.FileMenuOpen = [MenuItem]::new('開く')
        $this._AddMenuItem($fileMenu, $this.FileMenuOpen, "FileMenuOpen_Click")

        $this.FileMenuSave = [MenuItem]::new('保存')
        $this._AddMenuItem($fileMenu, $this.FileMenuSave, "FileMenuSave_Click")
        
        $this.FileMenuExit = [MenuItem]::new('終了')
        $this._AddMenuItem($fileMenu, $this.FileMenuExit, "FileMenuExit_Click")

        $mainMenu.MenuItems.Add($fileMenu)
    }

    _AddMenuItem([MenuItem] $parentMenuItem, [MenuItem] $menuItem, [String] $handlerName) {
        $this.AddClick($menuItem, $handlerName)
        $parentMenuItem.Add($menuItem)
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