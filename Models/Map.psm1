using module ".\Node.psm1"

class Map {
    [Node] $TopNode

    Map() {
        $this.TopNode = [Node]::new("新規マインドマップ")
    }
}