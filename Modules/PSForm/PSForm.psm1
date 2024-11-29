using namespace System.ComponentModel
using namespace System.Windows.Forms
using module PSLogger
using module PSModel

enum EventType {
    <#
    .SYNOPSIS
        �R���|�[�l���g�̃C�x���g�^�C�v�����ʂ���
    #>
    Click
}

class PSForm {
    <#
    .SYNOPSIS
        �t�H�[�����W���[���쐬�̃x�[�X�ƂȂ�t�H�[���N���X
    #>
    [PSModel] $Model
	[Form] $Form
    [PSLogger] $Logger

    PSForm([PSModel] $model) {
        $this.Logger = [PSLogger]::GetLogger()
        $this.Model = $model
		$this.Form = [Form]::new()
		$this.InitializeComponent()
    }

    [void] Dispose() {
        Remove-Module PSLogger
    }

	InitializeComponent() {
        <#
        .SYNOPSIS
            �t�H�[���ɕ\������R���|�[�l���g�̐����ȂǏ��������s�����\�b�h
            �h���N���X�œƎ��̏��������s���B
        #>
        $this.Logger.WriteDebug("PSForm.InitializeComponent: called.")
	}

	AddEventHandler([Component] $component, [EventType] $eventType, [String] $handlerName) {
        <#
        .SYNOPSIS
            �R���|�[�l���g�ɃC�x���g�n���h����ǉ����邽�߂̋��ʃ��\�b�h
            ����K�v�ɉ����đΉ��C�x���g�̎�ނ��g������
        #>
		switch ($eventType) {
			([EventType]::Click) {
				$component.Add_Click([Delegate]::CreateDelegate([EventHandler], $this, $handlerName))
			}
		}
	}

	AddClick([Component] $component, [String] $handlerName) {
        <#
        .SYNOPSIS
            �R���|�[�l���g��Click�C�x���g�̃n���h����ǉ�����
        #>
		$this.AddEventHandler($component, [EventType]::Click, $handlerName)
	}
}