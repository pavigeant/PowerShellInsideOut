function WhenExpectingAMandatoryParameter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $Value
    )

    # Do nothing
    [void] $Value
}

Describe "Parameter Mandatory" -Tag Unit {
    Context "When passing value as a parameter" {
        It "Should work properly using non null value" -TestCases @(
            @{ Value = "" }
            @{ Value = @{ } }
            @{ Value = @() }
        ) {
            param($Value)

            { WhenExpectingAMandatoryParameter -Value $Value } | Should -Not -Throw
        }

        It "Should fail using a null value" -TestCases @(
            @{ Value = $null }
        ) {
            param($Value)

            { WhenExpectingAMandatoryParameter -Value $Value } | Should -Throw
        }
    }

    Context "When passing value from the pipe" {
        It "Should work correctly even when using a non-null value" -TestCases @(
            @{ Value = "" }
            @{ Value = @{ } }
            @{ Value = @() }
        ) {
            param($Value)

            { $Value | WhenExpectingAMandatoryParameter } | Should -Not -Throw
        }

        It "Should work correctly even when using a null value, but an exception is written" -TestCases @(
            @{ Value = $null }
            @{ Value = "", @{ }, @(), $null }
        ) {
            param($Value)

            { $Value | WhenExpectingAMandatoryParameter } | Should -Not -Throw
        }
    }
}