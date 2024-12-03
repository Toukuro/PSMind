using namespace System.Collections.Generic

class Node {
    [Node] $Parent
    [List[Node]] $Children
    [String] $Text

    Node([String] $text, [Node] $parent) {
        $this.Text = $text
        $this.Parent = $parent
        $this.Children = [List[Node]]::new()
    }

    Node([String] $text) {
        $this.Text = $text
        $this.Parent = $null
        $this.Children = [List[Node]]::new()
    }
}