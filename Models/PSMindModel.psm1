using module PSModel

class PSMindModel : PSModel {
    [Version] $Version

    PSMindModel() : base() {
        $this.Version = [Version]::new(0,1)
    }
}