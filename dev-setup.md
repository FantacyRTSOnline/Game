# Self Building

For now just run the install script:

```ps1
iex ((New-Object System.Net.WebClient).DownloadString('https://bit.ly/win-install-rts'))
```

Then to run the game from the command line in the root of the project:

```
./scripts/run-game.ps1
```

Currently, development is done on windows first. The game will support linux second and mac third. But all build tooling is around windows until further notice.