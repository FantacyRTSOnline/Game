# A utility script to run cargo commands in the project
# By: ThatGuyJamal
# Date: 12/10/2023

# ? Run Cargo Command
# ---------------------------------------------------------- #
function RunCargoCommand {
    param (
        [string]$command
    )

    switch ($command) {
        "crate" {
            GenerateCrate
            break
        }
        "test" {
            Invoke-CargoTest
            break
        }
        "rm" {
            Invoke-CargoRemove
            break
        }
        "add" {
            Invoke-CargoAdd
            break
        }
        default {
            Write-Host "Invalid command. Please enter 'crate' or 'test'."
        }
    }
}

# ? Create Generation Command
# ---------------------------------------------------------- #
function GenerateCrate {
    $crateName = Read-Host -Prompt 'Input your crate name'

    Set-Location crates

    Invoke-Expression "cargo new --lib $crateName --vcs none"

    Set-Location ..
}

# ? Cargo Test Command
# ---------------------------------------------------------- #
function Invoke-CargoTest {
    # Run the cargo test command
    # Add your logic here to execute cargo test
    Write-Host "Running cargo test command..."
    # Invoke-Expression "cargo test" or your logic to run cargo test
    Invoke-Expression "cargo test"
}

# ? Cargo Remove package
# ---------------------------------------------------------- #
function Invoke-CargoRemove {
    $packagePath = Read-Host -Prompt 'Input the crate dir you wish to modify'
    $crate = Read-Host -Prompt 'Input the package you wish to remove'

    cargo remove $crate --package $packagePath    
}

# ? Cargo Add package
# ---------------------------------------------------------- #
function Invoke-CargoAdd {
    $packagePath = Read-Host -Prompt 'Input the crate dir you wish to modify'
    $crate = Read-Host -Prompt 'Input the package you wish to add'

    cargo add $crate --package $packagePath    
}

# Prompt user for command input
$enteredCommand = Read-Host -Prompt 'Enter a command (crate/test)'

RunCargoCommand -command $enteredCommand