using module PSLogger

class PSModel {
    <#
    .SYNOPSIS
        すべてのモデルのベースとなるモデルクラス
        今のところ、ここで実装するメソッドは存在しない
    #>
    [PSLogger] $Logger

    PSModel() {
        $this.Logger = [PSLogger]::GetLogger()
    }
}