enum PSLogLevel {
    <#
    .SYNOPSIS
        ログ出力レベル
    #>
    All     <# 全てのログ出力 #>
    Debug   <# デバッグ #>
    Detail  <# 詳細 #>
    Info    <# 情報 #>
    Warning <# 警告 #>
    Error   <# エラー #>
    None    <# ログ出力無し #>
}

class PSLogger {
    <#
    .SYNOPSIS
        ログ出力クラス
    #>
    static [PSLogger] $Logger
    [PSLogLevel] $LogLevel

    static [PSLogger] GetLogger() {
        <#
        .SYNOPSIS
            ログ出力オブジェクトの取得
        #>
        if ( $null -eq [PSLogger]::Logger ) {
            [PSLogger]::Logger = [PSLogger]::new()
        }
        return [PSLogger]::Logger
    }

    PSLogger() {
        $this.LogLevel = [PSLogLevel]::Info
    }

    WriteMessage([String] $level, [String] $message) {
        <#
        .SYNOPSIS
            共通のログ出力メソッド
        #>
        $timestamp = [DateTime]::Now.ToString("yyyy/MM/dd ")
        Write-Host "$timestamp [$level] $message"
    }

    WriteDebug([String] $message) {
        <#
        .SYNOPSIS
            デバッグログの出力を行う
        #>
        if ( $this.LogLevel -gt [PSLogLevel]::Debug ) { return }
        $this.WriteMessage("DEBUG", $message)
    }

    WriteDetail([String] $message) {
        <#
        .SYNOPSIS
            詳細ログの出力を行う
        #>
        if ( $this.LogLevel -gt [PSLogLevel]::Detail ) { return }
        $this.WriteMessage("DETAIL", $message)
    }

    WriteInfo([String] $message) {
        <#
        .SYNOPSIS
            情報ログの出力を行う
        #>
        if ( $this.LogLevel -gt [PSLogLevel]::Info ) { return }
        $this.WriteMessage("INFO", $message)
    }

    WriteWarn([String] $message) {
        <#
        .SYNOPSIS
            警告ログの出力を行う
        #>
        if ( $this.LogLevel -gt [PSLogLevel]::Warning) { return }
        $this.WriteMessage("WARN", $message)
    }

    WriteError([String] $message) {
        <#
        .SYNOPSIS
            エラーログの出力を行う
        #>
        if ( $this.LogLevel -gt [PSLogLevel]::Error ) { return }
        $this.WriteMessage("ERROR", $message)
    }
}