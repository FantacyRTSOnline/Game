# A utility script for bootstrapping this project on your local machine.
# By: ThatGuyJamal
# Date: 12/10/2023

# ? Run the windows installer
# ---------------------------------------------------------- #
function Invoke-Win-Installer {
    try {
        Start-Process -FilePath "winget" -ArgumentList "install Microsoft.VisualStudio.2022.BuildTools --force --override '--wait --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000'" -Wait -NoNewWindow -ErrorAction Stop
        Write-Host "Windows build tools installed successfully."
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
        Invoke-Win-Installer
        Invoke-Rustup-Installer

        Write-Host "Project installation complete."
    }
    catch {
        Write-Host "An unexpected error occurred: $_"
        Exit 1
    }
}

# Run the installer
Invoke-Installer