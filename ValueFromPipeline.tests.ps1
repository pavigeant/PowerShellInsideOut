function BeginHitCount {
    [void] 0
}

function ProcessHitCount {
    [void] 0
}

function EndHitCount {
    [void] 0
}

function FunctionWithoutAnArray {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]$Value
    )

    begin {
        BeginHitCount
    }

    process {
        ProcessHitCount
    }

    end {
        EndHitCount
    }
}

function FunctionWithAnArray {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string[]]$Values
    )

    begin {
        BeginHitCount
    }

    process {
        foreach ($value in $Values) {
            ProcessHitCount   
        }
    }

    end {
        EndHitCount
    }
}

function GivenHitCounter {
    Mock BeginHitCount { }
    Mock ProcessHitCount { }
    Mock EndHitCount { }
}

function WhenPipingARegularArrayToAFunctionWithoutAnArray {
    "hello", "world", "how", "are", "you" | FunctionWithoutAnArray
}

function WhenPipingAJaggedArrayToAFunctionWithoutAnArray {
    "hello", "world", "how", @("are", "you") | FunctionWithoutAnArray
}

function WhenPipingARegularArrayToAFunctionWithAnArray {
    "hello", "world", "how", "are", "you" | FunctionWithAnArray
}

function WhenPipingAJaggedArrayToAFunctionWithAnArray {
    "hello", "world", "how", @("are", "you") | FunctionWithAnArray
}

function ThenAllExpectedItemsWereProcessed {
    Assert-MockCalled BeginHitCount -Times 1 -Scope It
    Assert-MockCalled ProcessHitCount -Times 5 -Scope It
    Assert-MockCalled EndHitCount -Times 1 -Scope It
}

Describe "ValueFromPipeline" -Tag Unit {
    $ErrorActionPreference = "Stop"
    GivenHitCounter

    Context "When using a function that doesn't support an array" {

        It "Should work when a simple array is provided" {

            { WhenPipingARegularArrayToAFunctionWithoutAnArray } | Should -Not -Throw
            ThenAllExpectedItemsWereProcessed
        }

        It "Should fail when a jagged array is provided" {
            { WhenPipingAJaggedArrayToAFunctionWithoutAnArray } | Should -Throw
        }        
    }

    Context "When using a function that supports an array" {

        It "Should work when a simple array is provided" {
            { WhenPipingARegularArrayToAFunctionWithAnArray } | Should -Not -Throw
            ThenAllExpectedItemsWereProcessed
        }

        It "Should work when a jagged array is provided" {
            { WhenPipingAJaggedArrayToAFunctionWithAnArray } | Should -Not -Throw
            ThenAllExpectedItemsWereProcessed
        }        
    }
}