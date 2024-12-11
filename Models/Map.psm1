using module ".\NodeBase.psm1"
using module ".\Node.psm1"

class Map {
    [Node] $TopNode

    Map() {
        $this.TopNode = [Node]::new("新規マインドマップ")
    }

    Accept([NodeVisitor] $visitor) {
        $visitor.Visit($this)
    }
}