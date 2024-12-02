using module PSLogger
using module PSModel

class PSMindModel : PSModel {
    [Version] $Version
    [PSLogger] $Logger

    PSMindModel() : base() {
        $this.Version = [Version]::new(0,1)
        $this.Logger = [PSLogger]::GetLogger()
    }

    ReadMap() {
        $this.Logger.WriteDebug("PSMindModel.ReadMap: occured.")
    }

    WriteMap() {
        $this.Logger.WriteDebug("PSMindModel.WriteMap: occured.")
    }
}