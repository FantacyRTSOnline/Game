# A utility script for running the game and passing common cli args to it durring dev.
# By: ThatGuyJamal
# Date: 12/10/2023

Write-Host "Running game in dev mode..."

cargo watch -x 'run --features bevy/dynamic_linking'