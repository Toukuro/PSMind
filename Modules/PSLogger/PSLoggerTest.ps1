using module ".\PSLogger.psm1"

# �e�X�g�̎��s���@�F
#  Invoke-Pester -Path .\PSLoggerTest.ps1
Describe "PSLogger�̃e�X�g" {
    function WriteLogTest() {
        $logger = [PSLogger]::GetLogger()
        $logger.WriteDebug("�f�o�b�O���O�o��")
        $logger.WriteDetail("�ڍ׃��O�o��")
        $logger.WriteInfo("��񃍃O�o��")
        $logger.WriteWarn("�x�����O�o��")
        $logger.WriteError("�G���[���O�o��")
    }

    Context "�f�t�H���g�̏o�̓��[�h��INFO�iINFO�`ERROR�̏o�͂����邱�Ɓj" {
        WriteLogTest
    }

    Context "LogLevel��All�̏ꍇ�͂��ׂāiDEBUG�`ERROR�̏o�͂����邱�Ɓj" {
        [PSLogger]::LogLevel = [PSLogLevel]::All
        WriteLogTest
    }
    Context "LogLevel��Debug�̏ꍇ�́ADEBUG�`ERROR�̏o�͂����邱��" {
        [PSLogger]::LogLevel = [PSLogLevel]::Debug
        WriteLogTest
    }
    Context "LogLevel��Detail�̏ꍇ�́ADETAIL�`ERROR�̏o�͂����邱��" {
        [PSLogger]::LogLevel = [PSLogLevel]::Detail
        WriteLogTest
    }
    Context "LogLevel��Info�̏ꍇ�́AINFO�`ERROR�̏o�͂����邱��" {
        [PSLogger]::LogLevel = [PSLogLevel]::Info
        WriteLogTest
    }
    Context "LogLevel��Warning�̏ꍇ�́AWARN�`ERROR�̏o�͂����邱��" {
        [PSLogger]::LogLevel = [PSLogLevel]::Warning
        WriteLogTest
    }
    Context "LogLevel��Error�̏ꍇ�́AERROR�̂ݏo�͂����邱��" {
        [PSLogger]::LogLevel = [PSLogLevel]::Error
        WriteLogTest
    }
    Context "LogLevel��None�̏ꍇ�́A���O�̏o�͂��Ȃ�����" {
        [PSLogger]::LogLevel = [PSLogLevel]::None
        WriteLogTest
    }
}