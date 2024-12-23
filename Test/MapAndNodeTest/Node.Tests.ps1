using namespace System.Collections.Generic
using module PSLogger
using module "..\..\Models\NodeBase.psm1"
using module "..\..\Models\Node.psm1"
using module "..\..\Models\Map.psm1"

Describe "Nodeのテスト" {
    BeforeAll {
        [PSLogger]::GetLogger().LogLevel = [PSLogLevel]::Debug
        [Node] $topNode = [Node]::new('最初のノード')
    }

    Context "初期状態" {
        It "Parentはnullである" {
            $topNode.Parent | Should -Be $null
        }
        It "Childrenは、要素数が0である" {
            $topNode.Children.Count | Should -Be 0
        }
        It "Textは'最初のノード'である" {
            $topNode.Text | Should -Be '最初のノード'
        }
    }

    AfterAll {
        Remove-Module Node
        Remove-Module NodeBase
    }
}