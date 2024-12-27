using module PSLogger
using module PSModel
using module ".\Map.psm1"
using module ".\XmlWriteVisitor.psm1"

class PSMindModel : PSModel {
    [Version] $Version
    [Map] $Map

    PSMindModel() : base() {
        $this.Version = [Version]::new(0,1)
        $this.Map = [Map]::new()
    }

    ReadMap() {
        $this.Logger.WriteDebug("PSMindModel.ReadMap: occured.")
    }

    WriteMap() {
        $this.Logger.WriteDebug("PSMindModel.WriteMap: occured.")
        $visitor = [XmlWriteVisitor]::new("PSMind.mm", $this.Version.ToString())
        $this.Map.Accept($visitor)
        $visitor.Close()
    }
}