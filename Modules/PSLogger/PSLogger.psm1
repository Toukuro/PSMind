enum PSLogLevel {
    <#
    .SYNOPSIS
        ���O�o�̓��x��
    #>
    All     <# �S�Ẵ��O�o�� #>
    Debug   <# �f�o�b�O #>
    Detail  <# �ڍ� #>
    Info    <# ��� #>
    Warning <# �x�� #>
    Error   <# �G���[ #>
    None    <# ���O�o�͖��� #>
}

class PSLogger {
    <#
    .SYNOPSIS
        ���O�o�̓N���X
    #>
    static [PSLogLevel] $LogLevel = [PSLogLevel]
    static [PSLogger] $Logger

    static [PSLogger] GetLogger() {
        <#
        .SYNOPSIS
            ���O�o�̓I�u�W�F�N�g�̎擾
        #>
        if ( $null -eq [PSLogger]::Logger ) {
            [PSLogger]::Logger = [PSLogger]::new()
        }
        return [PSLogger]::Logger
    }

    PSLogger() {
        [PSLogger]::LogLevel = [PSLogLevel]::Info
    }

    WriteMessage([String] $level, [String] $message) {
        <#
        .SYNOPSIS
            ���ʂ̃��O�o�̓��\�b�h
        #>
        $timestamp = [DateTime]::Now.ToString("yyyy/MM/dd ")
        Write-Host "$timestamp [$level] $message"
    }

    WriteDebug([String] $message) {
        <#
        .SYNOPSIS
            �f�o�b�O���O�̏o�͂��s��
        #>
        if ( [PSLogger]::LogLevel -gt [PSLogLevel]::Debug ) { return }
        $this.WriteMessage("DEBUG", $message)
    }

    WriteDetail([String] $message) {
        <#
        .SYNOPSIS
            �ڍ׃��O�̏o�͂��s��
        #>
        if ( [PSLogger]::LogLevel -gt [PSLogLevel]::Detail ) { return }
        $this.WriteMessage("DETAIL", $message)
    }

    WriteInfo([String] $message) {
        <#
        .SYNOPSIS
            ��񃍃O�̏o�͂��s��
        #>
        if ( [PSLogger]::LogLevel -gt [PSLogLevel]::Info ) { return }
        $this.WriteMessage("INFO", $message)
    }

    WriteWarn([String] $message) {
        <#
        .SYNOPSIS
            �x�����O�̏o�͂��s��
        #>
        if ( [PSLogger]::LogLevel -gt [PSLogLevel]::Warning) { return }
        $this.WriteMessage("WARN", $message)
    }

    WriteError([String] $message) {
        <#
        .SYNOPSIS
            �G���[���O�̏o�͂��s��
        #>
        if ( [PSLogger]::LogLevel -gt [PSLogLevel]::Error ) { return }
        $this.WriteMessage("ERROR", $message)
    }
}