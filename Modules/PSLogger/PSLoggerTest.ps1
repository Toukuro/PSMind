using module ".\PSLogger.psm1"

# �e�X�g�̎��s���@�F
#  Invoke-Pester -Path .\PSLoggerTest.ps1
Describe "PSLogger�̃e�X�g" {
    function WriteLogTest($msg) {
        Write-Host "---- $msg"
        $logger = [PSLogger]::GetLogger()
        $logger.WriteDebug("�f�o�b�O���O�o��")
        $logger.WriteDetail("�ڍ׃��O�o��")
        $logger.WriteInfo("��񃍃O�o��")
        $logger.WriteWarn("�x�����O�o��")
        $logger.WriteError("�G���[���O�o��")
    }

    Context "�f�t�H���g�̏o�̓��[�h��INFO�iINFO�`ERROR�̏o�͂����邱�Ɓj" {
        WriteLogTest("�f�t�H���g")
    }
    Context "LogLevel��All�̏ꍇ�͂��ׂāiDEBUG�`ERROR�̏o�͂����邱�Ɓj" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::All
        WriteLogTest("All")
    }
    Context "LogLevel��Debug�̏ꍇ�́ADEBUG�`ERROR�̏o�͂����邱��" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Debug
        WriteLogTest("Debug")
    }
    Context "LogLevel��Detail�̏ꍇ�́ADETAIL�`ERROR�̏o�͂����邱��" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Detail
        WriteLogTest("Detail")
    }
    Context "LogLevel��Info�̏ꍇ�́AINFO�`ERROR�̏o�͂����邱��" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Info
        WriteLogTest("Info")
    }
    Context "LogLevel��Warning�̏ꍇ�́AWARN�`ERROR�̏o�͂����邱��" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Warning
        WriteLogTest("Warning")
    }
    Context "LogLevel��Error�̏ꍇ�́AERROR�̂ݏo�͂����邱��" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Error
        WriteLogTest("Error")
    }
    Context "LogLevel��None�̏ꍇ�́A���O�̏o�͂��Ȃ�����" {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::None
        WriteLogTest("None")
    }
}