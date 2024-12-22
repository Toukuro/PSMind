using namespace System.Collections.Generic
using module ".\NodeBase.psm1"

class Node : NodeBase {
    <#
    .SYNOPSIS
        MindMap‚ÌNodeƒNƒ‰ƒX
    #>
    [String] $Text

    Node([String] $text, [Node] $parent) : base() {
        $this.Text = $text
        $this.Parent = $parent
    }

    Node([String] $text) : base() {
        $this.Text = $text
    }
}