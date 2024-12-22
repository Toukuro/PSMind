using namespace System.Collections.Generic
using module PSLogger

class NodeBase {
    <#
    .SYNOPSIS
        ノードの基底クラス
    #>
    [NodeBase] $Parent
    [List[NodeBase]] $Children
    [PSLogger] $Logger

    NodeBase() {
        $this.Logger = [PSLogger]::GetLogger()
        $this.Parent = $null
        $this.Children = [List[NodeBase]]::new()
    }

    Accept([NodeVisitor] $visitor) {
        $this.Logger.WriteDebug("NodeBase.Accept: occured.")
        $visitor.Visit($this)
    }
}

class NodeVisitor {
    <#
    .SYNOPSIS
        ノードの訪問者クラス
    #>
    Visit([NodeBase] $node) {
        $this.Logger.WriteDebug("NodeVisitor.Visit: occured.")
    }
}