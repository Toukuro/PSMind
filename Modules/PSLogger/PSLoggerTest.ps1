using module ".\PSLogger.psm1"

# テストの実行方法：
#  Invoke-Pester -Path .\PSLoggerTest.ps1
Describe "PSLoggerのテスト" {
    function WriteLogTest() {
        $logger = [PSLogger]::GetLogger()
        $logger.WriteDebug("デバッグログ出力")
        $logger.WriteDetail("詳細ログ出力")
        $logger.WriteInfo("情報ログ出力")
        $logger.WriteWarn("警告ログ出力")
        $logger.WriteError("エラーログ出力")
    }

    Context "デフォルトの出力モードはINFO（INFO～ERRORの出力があること）" {
        WriteLogTest
    }

    Context "LogLevelがAllの場合はすべて（DEBUG～ERRORの出力があること）" {
        [PSLogger]::LogLevel = [PSLogLevel]::All
        WriteLogTest
    }
    Context "LogLevelがDebugの場合は、DEBUG～ERRORの出力があること" {
        [PSLogger]::LogLevel = [PSLogLevel]::Debug
        WriteLogTest
    }
    Context "LogLevelがDetailの場合は、DETAIL～ERRORの出力があること" {
        [PSLogger]::LogLevel = [PSLogLevel]::Detail
        WriteLogTest
    }
    Context "LogLevelがInfoの場合は、INFO～ERRORの出力があること" {
        [PSLogger]::LogLevel = [PSLogLevel]::Info
        WriteLogTest
    }
    Context "LogLevelがWarningの場合は、WARN～ERRORの出力があること" {
        [PSLogger]::LogLevel = [PSLogLevel]::Warning
        WriteLogTest
    }
    Context "LogLevelがErrorの場合は、ERRORのみ出力があること" {
        [PSLogger]::LogLevel = [PSLogLevel]::Error
        WriteLogTest
    }
    Context "LogLevelがNoneの場合は、ログの出力がないこと" {
        [PSLogger]::LogLevel = [PSLogLevel]::None
        WriteLogTest
    }
}