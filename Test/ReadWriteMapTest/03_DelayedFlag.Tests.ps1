using module "..\..\Models\DelayedFlag.psm1"

Describe "DelayedFlagのテスト" {
    AfterAll {
        Remove-Module DelayedFlag
    }

    Context "深さが１なら通常のフラグとして動作する" {
        BeforeAll {
            $delayedFlag = [DelayedFlag]::new(1, $false)
        }
        AfterAll {
            $delayedFlag = $null
        }
        It "初期値はfalse" {
            $delayedFlag.Get() | Should -Be $false
        }
        It "trueに設定するとtrue" {
            $delayedFlag.Set($true)
            $delayedFlag.Get() | Should -Be $true
        }
    }

    Context "深さが2なら1回分遅延して動作する" {
        BeforeAll {
            $delayedFlag = [DelayedFlag]::new(2, $true)
        }
        AfterAll {
            $delayedFlag = $null
        }
        It "初期値はtrue" {
            $delayedFlag.Get() | Should -Be $true
        }
        It "1回目、falseを設定するが、取得値はtrue" {
            $delayedFlag.Set($false)
            $delayedFlag.Get() | Should -Be $true
        }
        It "2回目、trueを設定。取得値は1回目のfalse" {
            $delayedFlag.Set($true)
            $delayedFlag.Get() | Should -Be $false
        }
        It "値を設定しなければ、前回と同じfalse" {
            $delayedFlag.Get() | Should -Be $false
        }
    }
}