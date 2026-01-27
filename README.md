### First Time Run

`sudo nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin/master#darwin-rebuild -- switch --flake .#ooj`

Give Nix full disk access

### Subsequent Regeneration

`sudo darwin-rebuild switch --flake .#ooj`

### Needed to Fix Perms on Mac

sudo chown -R username:staff ~/.local
sudo chown $USER ~/Library/Caches/com.vscodium.ShipIt/\*
sudo xattr -dr com.apple.quarantine /Applications/Nix\ Apps/VSCodium.app
