using module ".\Node.psm1"

class Map {
    [Node] $TopNode

    Map() {
        $this.TopNode = [Node]::new("�V�K�}�C���h�}�b�v")
    }
}