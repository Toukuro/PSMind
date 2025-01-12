using module "..\..\Models\MapBuilder.psm1"
using module "..\..\Models\MapNodeException.psm1"

Describe "MapBuilder‚ÌƒeƒXƒg" {
    AfterAll {
        Remove-Module MapBuilder
    }

    Context "³íŒn‚ÌƒeƒXƒg" {
        BeforeAll {
            $mapBuilder = [MapBuilder]::new()
        }
        AfterAll {
            $mapBuilder = $null
        }
        It "Map‚ğì¬" {
            $mapBuilder.CreateMap("0.1")

            $mapBuilder.Map | Should -Not -Be $null
            $mapBuilder.Map.TopNode | Should -Be $null
        }
        It "TopNode‚Ìì¬" {
            $mapBuilder.CreateNode("Å‰‚Ìƒm[ƒh")

            $mapBuilder.Map.TopNode | Should -Not -Be $null
            $mapBuilder.Map.TopNode.Text | Should -Be "Å‰‚Ìƒm[ƒh"
            $mapBuilder.Map.TopNode.Children.Count | Should -Be 0
            ($mapBuilder.CurrentNode -eq $mapBuilder.Map.TopNode) | Should -Be $true
        }
        It "1ŠK‘w–Ú‚ÌqNode‚ğì¬" {
            $mapBuilder.CreateChildNode("1ŠK‘w–Ú‚Ì1")

            $mapBuilder.Map.TopNode.Children.Count | Should -Be 1
            $mapBuilder.Map.TopNode.Children[0].Text | Should -Be "1ŠK‘w–Ú‚Ì1"
            ($mapBuilder.CurrentNode -eq $mapBuilder.Map.TopNode.Children[0]) | Should -Be $true
        }
        It "2ŠK‘w–Ú‚ÌqNode‚ğì¬" {
            $mapBuilder.CreateChildNode("2ŠK‘w–Ú‚Ì1")
            $mapBuilder.Map.TopNode.Children[0].Children.Count | Should -Be 1
            $mapBuilder.Map.TopNode.Children[0].Children[0].Text | Should -Be "2ŠK‘w–Ú‚Ì1"
            ($mapBuilder.CurrentNode -eq $mapBuilder.Map.TopNode.Children[0].Children[0]) | Should -Be $true
        }
        It "eNode‚ÉˆÚ“®" {
            $mapBuilder.MoveParent()
            ($mapBuilder.CurrentNode -eq $mapBuilder.Map.TopNode.Children[0]) | Should -Be $true
        }
        It "1ŠK‘w–Ú‚Ì2”Ô–Ú‚ÌqNode‚ğì¬" {
            $mapBuilder.CreateNode("1ŠK‘w–Ú‚Ì2")
            $mapBuilder.Map.TopNode.Children.Count | Should -Be 2
            $mapBuilder.Map.TopNode.Children[1].Text | Should -Be "1ŠK‘w–Ú‚Ì2"
            ($mapBuilder.CurrentNode -eq $mapBuilder.Map.TopNode.Children[1]) | Should -Be $true
        }
    }
    Context "ˆÙíŒn‚ÌƒeƒXƒg" {
        BeforeAll {
            $mapBuilder = [MapBuilder]::new()
        }
        AfterAll {
            $mapBuilder = $null
        }
        It "Map‚ª–³‚¢ó‘Ô‚Å‚ÌNodeì¬‚ÍƒGƒ‰[" {
            { $mapBuilder.CreateNode("Å‰‚Ìƒm[ƒh") } | Should -Throw "Map is NUL"
        }
        It "Map‚ª–³‚¢ó‘Ô‚Å‚ÌChildNodeì¬‚ÍƒGƒ‰[" {
            { $mapBuilder.CreateChildNode("1ŠK‘w–Ú‚Ì1") } | Should -Throw "Map is NUL"
        }
        It "TopNode‚Æ“¯ƒŒƒxƒ‹‚ÌNodeì¬‚ÍƒGƒ‰[" {
            $mapBuilder.CreateMap("0.1")
            $mapBuilder.CreateNode("Å‰‚Ìƒm[ƒh")
            { $mapBuilder.CreateNode("2”Ô–Ú‚Ìƒm[ƒh") } | Should -Throw "CurrentNode.Parent is NUL"
        }
    }
}