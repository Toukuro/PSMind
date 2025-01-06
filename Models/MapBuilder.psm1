using module PSLogger
using module ".\Node.psm1"
using module ".\Map.psm1"
using module ".\MapNodeException.psm1"

class MapBuilder {
    [Map] $Map = $null
    [Node] $CurrentNode = $null
    [PSLogger] $Logger

    MapBuilder() {
        $this.Logger = [PSLogger]::new()
        $this.Logger.LogLevel = [PSLogLevel]::Debug
    }

    [void] CreateMap([String] $version) {
        $this.Logger.WriteDebug("CreateMap: occured")
        $this.Map = [Map]::new()
        $this.Map.TopNode = $null
    }

    [void] CreateNode([String] $text) {
        $this.Logger.WriteDebug("CreateNode: occured")

        if ($null -eq $this.Map) {
            throw [MapNodeException]::new("Map is NUL")
        }
        if ($null -eq $this.CurrentNode) {
            $this.Logger.WriteDebug("CreateNode: 1st Node Created.")
            $newNode = [Node]::new($text)
        }
        else {
            $this.Logger.WriteDebug("CreateNode: Node Created.")
            $newNode = [Node]::new($text, $this.CurrentNode.Parent)
            if ($null -eq $this.CurrentNode.Parent) {
                throw [MapNodeException]::new("Parent Node is NUL")
            }
            $this.CurrentNode.Parent.Children.Add($newNode)
        }
        $this.CurrentNode = $newNode
        if ($null -eq $this.Map.TopNode) {
            $this.Logger.WriteDebug("CreateNode: Set TopNode")
            $this.Map.TopNode = $this.CurrentNode
        }
    }

    [void]CreateChildNode([String] $text) {
        $this.Logger.WriteDebug("CreateChildNode: occured")

        if ($null -eq $this.Map) {
            throw [MapNodeException]::new("Map is NUL")
        }
        if ($null -eq $this.CurrentNode) {
            $this.Logger.WriteDebug("CreateChildNode: CurrentNode is NUL")
            return
        }
        $newNode = [Node]::new($text, $this.CurrentNode)
        $this.CurrentNode.Children.Add($newNode)
        $this.CurrentNode = $newNode
    }

    [void]MoveParent() {
        $this.Logger.WriteDebug("MoveParent: occured")
        if ($null -ne $this.CurrentNode.Parent) {
            $this.Logger.WriteDebug("MoveParent: Move to Parent")
            $this.CurrentNode = $this.CurrentNode.Parent
        }
    }
}