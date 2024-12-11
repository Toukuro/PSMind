using namespace System.Collections.Generic
using module PSLogger

class NodeBase {
    [NodeBase] $Parent
    [List[NodeBase]] $Children
    [PSLogger] $logger

    NodeBase() {
        $this.logger = [PSLogger]::GetLogger()
        $this.Parent = $null
        $this.Children = [List[NodeBase]]::new()
    }

    Accept([NodeVisitor] $visitor) {
        $this.logger.WriteDebug("NodeBase.Accept: occured.")
        $visitor.Visit($this)
    }
}

class NodeVisitor {
    Visit([NodeBase] $node) {
        $this.logger.WriteDebug("NodeVisitor.Visit: occured.")
    }
}