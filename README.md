### First Time Run
`sudo nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin/master#darwin-rebuild -- switch --flake .#ooj`

Give Nix full disk access

### Subsequent Regeneration
`sudo darwin-rebuild switch --flake .#ooj`