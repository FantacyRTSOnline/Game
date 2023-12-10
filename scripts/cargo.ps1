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

# Prompt user for command input
$enteredCommand = Read-Host -Prompt 'Enter a command (crate/test)'

RunCargoCommand -command $enteredCommand