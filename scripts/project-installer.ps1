# A utility script for bootstrapping this project on your local machine.
# By: ThatGuyJamal
# Date: 12/10/2023

# ? Run the windows installer
# ---------------------------------------------------------- #
function Invoke-Win-Installer {
    try {
        $userInput = Read-Host "Please enter your current Windows version (10 or 11):"

        if ($userInput -eq 10) {
            Write-Host "Installing Windows 10 build tools..."
            # Windows 10 SDK
            # winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.22200"
            Start-Process -FilePath "winget" -ArgumentList "install Microsoft.VisualStudio.2022.BuildTools --force --override '--wait --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.22200'" -Wait -NoNewWindow -ErrorAction Stop
            Write-Host "Windows 10 build tools installed successfully."
        }
        elseif ($userInput -eq 11) {
            Write-Host "Installing Windows 11 build tools..."
            # Windows 11 SDK
            # winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22621"
            Start-Process -FilePath "winget" -ArgumentList "install Microsoft.VisualStudio.2022.BuildTools --force --override '--wait --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22621'" -Wait -NoNewWindow -ErrorAction Stop
            Write-Host "Windows 11 build tools installed successfully."
        }
        else {
            Write-Host "Invalid input, please try again. You can only enter the numbers (10 or 11) nothing else!"
            Invoke-Win-Installer
        }
    }
    catch {
        Write-Host "Windows build tools failed to install."
        Write-Host "Exiting due to an error: $_"
        Exit 1
    }
}

# ? Clone the git repository
# ---------------------------------------------------------- #
function Invoke-Git-Clone {
    try {
        if (!(Get-Command git -ErrorAction SilentlyContinue)) {
            Start-Process "winget" -ArgumentList "install Git.Git" -Wait -NoNewWindow -ErrorAction Stop
            Write-Host "Git has been installed, continuing..."
        }
        else {
            Write-Host "Git is already installed, continuing..."
        }

        Start-Process "git" -ArgumentList "clone https://github.com/FantacyRTSOnline/Game RTSFantacyOnline" -Wait -NoNewWindow -ErrorAction Stop

        if ($LASTEXITCODE -eq 0) {
            Write-Host "Git clone successful."
            Set-Location "RTSFantacyOnline"
        }
        else {
            Write-Host "Git clone failed."
            Write-Host "Exiting..."
            Exit 1
        }
    }
    catch {
        Write-Host "An error occurred during Git installation or clone: $_"
        Exit 1
    }
}

# ? Install rustup
# ---------------------------------------------------------- #
function Invoke-Rustup-Installer {
    try {
        if (!(Get-Command rustup -ErrorAction SilentlyContinue)) {
            Start-Process "winget" -ArgumentList "install Rust.rustup" -Wait -NoNewWindow -ErrorAction Stop
            # Refresh the environment variables in the current session
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
            Write-Host "Rustup has been installed, continuing..."
            Start-Process "cargo" -ArgumentList "install cargo-binutils" -Wait -NoNewWindow -ErrorAction Stop
            Start-Process "cargo" -ArgumentList "install cargo-watch" -Wait -NoNewWindow -ErrorAction Stop
            Start-Process "rustup" -ArgumentList "component add llvm-tools-x86_64-pc-windows-msvc" -Wait -NoNewWindow -ErrorAction Stop
            Write-Host "Rustup has been installed, continuing..."
        }
        else {
            Write-Host "Rustup is already installed, continuing..."
        }
    }
    catch {
        Write-Host "An error occurred during Rustup installation: $_"
        Exit 1
    }
}

# ? Start the script
# ---------------------------------------------------------- #
function Invoke-Installer {
    try {
        Write-Host "Starting project the installer..."

        Invoke-Git-Clone
        Invoke-Rustup-Installer
        Invoke-Win-Installer

        Write-Host "Project installation complete."
    }
    catch {
        Write-Host "An unexpected error occurred: $_"
        Exit 1
    }
}

# Run the installer
Invoke-Installer