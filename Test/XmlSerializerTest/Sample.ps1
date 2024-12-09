Describe "API validation" {
    BeforeAll {
        # this calls REST API and takes roughly 1 second
        #$response = Get-Pokemon -Name Pikachu
        $response = @{"Name"="Pikachu"; "Type"="Electric"}
    }

    It "response has Name = 'Pikachu'" {
        Write-Host "response= $response"
        $response.Name | Should -Be 'Pikachu'
    }

    It "response has Type = 'electric'" {
        $response.Type | Should -Be 'electric'
    }
}