using namespace System.ComponentModel
using namespace System.Windows.Forms
using namespace System.Drawing

using module PSForm
using module "..\Models\PSMindModel.psm1"

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

        # �t�@�C�����j���[

        $menu = [MainMenu]::new()
        $this._AddFileMenu($menu)
        $this.Form.Menu = $menu

        $this.Form.Activate()
    }

    _AddFileMenu([MainMenu] $mainMenu) {
        $fileMenu = [MenuItem]::new('�t�@�C��')

        $this.FileMenuOpen = [MenuItem]::new('�J��')
        $this._AddMenuItem($fileMenu, $this.FileMenuOpen, "FileMenuOpen_Click")

        $this.FileMenuSave = [MenuItem]::new('�ۑ�')
        $this._AddMenuItem($fileMenu, $this.FileMenuSave, "FileMenuSave_Click")

        $this.FileMenuExit = [MenuItem]::new('�I��')
        $this._AddMenuItem($fileMenu, $this.FileMenuExit, "FileMenuExit_Click")

        $mainMenu.MenuItems.Add($fileMenu)
    }

    _AddMenuItem([MenuItem] $parentMenuItem, [MenuItem] $menuItem, [String] $handlerName) {
        $this.AddClick($menuItem, $handlerName)
        $parentMenuItem.MenuItems.Add($menuItem)
    }

    [PSMindModel] _GetModel() {
        # �_�E���L���X�g���g�p�FPowerShell�P�̂ł̓W�F�l���b�N�^���`�ł��Ȃ�����
        return $this.Model
    }

    FileMenuOpen_Click([Object] $sender, [EventArgs] $e) {
        $this.Logger.WriteDebug("PSMindForm.FileMenuOpen_Click: occured.")
        $model = $this._GetModel()
        if ( $null -eq $model ) { return }
        $model.ReadMap()
    }

    FileMenuSave_Click([Object] $sender, [EventArgs] $e) {
        $this.Logger.WriteDebug("PSMindForm.FileMenuSave_Click: occured.")
        $model = $this._GetModel()
        if ( $null -eq $model ) { return }
        $model.WriteMap()
    }

    FileMenuExit_Click([Object] $sender, [EventArgs] $e) {
        $this.Logger.WriteDebug("PSMindForm.FileMenuExit_Click: occured.")
        $this.Form.Close()
    }
}