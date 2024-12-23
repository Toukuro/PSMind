using namespace System.Collections.Generic
using module "..\..\Models\NodeBase.psm1"
using module "..\..\Models\Node.psm1"
using module "..\..\Models\Map.psm1"

Describe "NodeVisitorのテスト" {
    BeforeAll {
        [Node] $topNode = [Node]::new('ノード0')
        $topNode.Children.Add([Node]::new('ノード1'))
        $topNode.Children.Add([Node]::new('ノード2'))
    }
    Context "訪問回数とText収集を行うテスト用Visitorでの確認" {
        class TestVisitor : NodeVisitor {
            [List[String]] $Texts = [List[String]]::new()
            [int] $VisitCount = 0

            Visit([Node] $node) {
                $this.Texts.Add($node.Text)
                $this.VisitCount++
                foreach ($child in $node.Children) {
                    $child.Accept($this)
                }
            }
        }
        BeforeAll {
            [TestVisitor] $visitor = [TestVisitor]::new()
            $topNode.Accept($visitor)
        }
        It "訪問回数は3回である" {
            $visitor.VisitCount | Should -Be 3
        }
        It "訪問したノードのTextは'ノード0', 'ノード1', 'ノード2'である" {
            $visitor.Texts | Should -Be @('ノード0', 'ノード1', 'ノード2')
        }
    }
    AfterAll {
        Remove-Module Node
        Remove-Module NodeBase
    }
}