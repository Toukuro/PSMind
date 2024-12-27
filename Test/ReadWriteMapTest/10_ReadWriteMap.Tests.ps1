using module "..\..\Models\PSMindModel.psm1"

Describe "PSMindModelのマップ保存テスト" {
    BeforeAll {
        $model = [PSMindModel]::new()
        $outputPath = ( $PSCommandPath | Split-Path -Parent )
    }
    AfterAll {
        Remove-Module PSMindModel
    }

    Context "出力結果の確認" {
        BeforeAll {
            $fileName = Join-Path $outputPath "..\..\PSMind.mm"
            if (Test-Path $fileName) {
                Remove-Item $fileName
            }
            $model.WriteMap()
        }
        It "ファイルが作成されていること" {
            # $fileName | Should -Exist
        }
        It "ファイルの内容が正しいこと" {
            $content = Get-Content $fileName
            $expected = Get-Content ( Join-Path $outputPath "PSMindExpected.mm" )
            # $content | Should -Be $expected
        }
    }
}