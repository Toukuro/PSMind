using module PSLogger
using module PSModel

class PSMindModel : PSModel {
    [Version] $Version

    PSMindModel() : base() {
        $this.Version = [Version]::new(0,1)
    }

    ReadMap() {
        $this.Logger.WriteDebug("PSMindModel.ReadMap: occured.")
    }

    WriteMap() {
        $this.Logger.WriteDebug("PSMindModel.WriteMap: occured.")
    }
}