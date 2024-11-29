using namespace System.ComponentModel
using namespace System.Windows.Forms
using module PSLogger
using module PSModel

enum EventType {
    <#
    .SYNOPSIS
        コンポーネントのイベントタイプを識別する
    #>
    Click
}

class PSForm {
    <#
    .SYNOPSIS
        フォームモジュール作成のベースとなるフォームクラス
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
            フォームに表示するコンポーネントの生成など初期化を行うメソッド
            派生クラスで独自の初期化を行う。
        #>
        $this.Logger.WriteDebug("PSForm.InitializeComponent: called.")
	}

	AddEventHandler([Component] $component, [EventType] $eventType, [String] $handlerName) {
        <#
        .SYNOPSIS
            コンポーネントにイベントハンドラを追加するための共通メソッド
            今後必要に応じて対応イベントの種類を拡張する
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
            コンポーネントにClickイベントのハンドラを追加する
        #>
		$this.AddEventHandler($component, [EventType]::Click, $handlerName)
	}
}