# Dotfiles

## Usage

1. Clone this repository.

   ```shell
   git clone https://github.com/genskyff/dotfiles.git && cd dotfiles
   ```

2. Run the `setup` script to install necessary packages and configure settings.

   - Windows

     ```shell
     .\setup.ps1
     ```

   - macOS / Arch / Debian

     ```shell
     ./setup.sh
     ```

## Non-interactive

The `setup` script asks before changing the default shell and before applying
config files. Set the matching variable to `1` or `0` to answer in advance; any
other value falls back to asking.

- `DF_CONFIG` — apply config files
- `DF_FISH` — change the default shell to fish (Linux only)

Windows has no default shell prompt, so it only reads `DF_CONFIG`.

- Windows

  ```shell
  $env:DF_CONFIG=1; .\setup.ps1
  ```

- macOS / Arch / Debian

  ```shell
  DF_CONFIG=1 DF_FISH=1 ./setup.sh
  ```

## Re-apply

After making changes to the dotfiles, re-apply them using the following commands:

```shell
mise bootstrap dotfiles apply
mise bootstrap dotfiles status
```
