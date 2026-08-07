# Omarchy configuration backup

Private, portable snapshot of this laptop's user-maintained Omarchy, desktop, shell, editor, audio, application, theme, launcher, and custom-agent configuration.

## Included

- User configuration under `home/.config/` for Omarchy, Hyprland, Waybar, Walker, terminals, editors, audio tools, REAPER settings, and other reproducible applications.
- Custom Omarchy themes and backgrounds, without their nested Git metadata.
- Shell configuration, custom scripts, desktop launchers, Codex rules/configuration, and custom skills.
- Package, Flatpak, VS Code extension, Omarchy version/channel/theme, and font manifests.

## Deliberately excluded

This repository is not a password vault. It excludes browser profiles, cookies, login sessions, messaging databases, password-manager data, SSH/GPG keys, GitHub credentials, API-key environment files, VPN state, histories, caches, databases, Codex authentication/session databases, and the REAPER license file.

Omarchy's managed source under `~/.local/share/omarchy/` is also excluded because it is restored by installing/updating Omarchy; only user-owned configuration is backed up.

## Restore

Review the files first, then copy them into a new home directory:

```bash
rsync -a home/ ~/
```

Reinstall packages from `manifests/pacman-explicit.txt`, AUR packages from `manifests/aur-packages.txt`, Flatpaks from `manifests/flatpak-apps.txt`, and VS Code extensions from `manifests/vscode-extensions.txt` as needed.

Snapshot created: 2026-08-08.
