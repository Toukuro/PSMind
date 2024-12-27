using module "..\..\Models\Node.psm1"
using module "..\..\Models\Map.psm1"
using module "..\..\Models\XmlWriteVisitor.psm1"

Describe "Mapデータ出力テスト" {
    BeforeAll {
        $map = [Map]::new()
        $map.TopNode.Children.Add([Node]::new("1階層目の1"))
        $map.TopNode.Children.Add([Node]::new("1階層目の2"))
        $map.TopNode.Children[0].Children.Add([Node]::new("2階層目の1"))
        $map.TopNode.Children[0].Children.Add([Node]::new("2階層目の2"))

        $outputPath = ( $PSCommandPath | Split-Path -Parent )
    }
    AfterAll {
        Remove-Module XmlWriteVisitor
        Remove-Module Map
        Remove-Module Node
    }

    Context "出力結果の確認" {
        BeforeAll {
            $fileName = Join-Path $outputPath "Actual.mm"
            if (Test-Path $fileName) {
                Remove-Item $fileName
            }
            $appVersion = "0.1"
            $visitor = [XmlWriteVisitor]::new($fileName, $appVersion)
            $map.Accept($visitor)
            $visitor.Close()
        }
        It "ファイルが作成されていること" {
            $fileName | Should -Exist
        }
        It "ファイルの内容が正しいこと" {
            $content = Get-Content $fileName
            $expected = Get-Content ( Join-Path $outputPath "Expected.mm" )
            $content | Should -Be $expected
        }
    }
}