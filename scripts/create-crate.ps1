# Ask for the crate name
$crateName = Read-Host -Prompt 'Input your crate name'

cd crates

# Run the cargo new --lib command with the crate name
Invoke-Expression "cargo new --lib $crateName --vcs none"