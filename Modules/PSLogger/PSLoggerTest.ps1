using module ".\PSLogger.psm1"

# テストの実行方法：
#  Invoke-Pester -Path .\PSLoggerTest.ps1
Describe "PSLoggerのテスト" {
    function WriteLogTest($msg) {
        Write-Host "---- $msg"
        $logger = [PSLogger]::GetLogger()
        $logger.WriteDebug("デバッグログ出力")
        $logger.WriteDetail("詳細ログ出力")
        $logger.WriteInfo("情報ログ出力")
        $logger.WriteWarn("警告ログ出力")
        $logger.WriteError("エラーログ出力")
    }

    Context "デフォルトの出力モードはINFO（INFO～ERRORの出力があること）" {
        WriteLogTest("デフォルト")
    }
    Context "LogLevelがAllの場合はすべて（DEBUG～ERRORの出力があること）" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::All
        WriteLogTest("All")
    }
    Context "LogLevelがDebugの場合は、DEBUG～ERRORの出力があること" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Debug
        WriteLogTest("Debug")
    }
    Context "LogLevelがDetailの場合は、DETAIL～ERRORの出力があること" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Detail
        WriteLogTest("Detail")
    }
    Context "LogLevelがInfoの場合は、INFO～ERRORの出力があること" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Info
        WriteLogTest("Info")
    }
    Context "LogLevelがWarningの場合は、WARN～ERRORの出力があること" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Warning
        WriteLogTest("Warning")
    }
    Context "LogLevelがErrorの場合は、ERRORのみ出力があること" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Error
        WriteLogTest("Error")
    }
    Context "LogLevelがNoneの場合は、ログの出力がないこと" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::None
        WriteLogTest("None")
    }
}