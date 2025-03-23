# declaro - a simple yet powerful declarative wrapper for any linux distro

## 🚀 Why This Project Exists

- **🚧 The Problem:** Desktop Linux systems accumulate unnecessary packages over time — apps installed briefly, forgotten, and left to clutter your system. This is a nightmare for small disks and system hygiene (run `pacman -Qq | wc -l` to see how many packages you have installed).

- **🤔 Why Current Solutions Fall Short:** Tools like NixOS are powerful but overly complex for users who don’t need complete reproducibility - just a clean clutter-free system.

- **💡 Our Solution:** A powerful declarative package manager wrapper that:
    - ✅ Lets you define a clean "reset state" for your system
    - 🔄 Provides tools to manage and reset your system back to that declarative state
    - 📝 Forces you to explicitly define what you want to keep

## Usage

### Define Your System State

`declaro` will generate a `packages.list` file in `~/.config/declaro/packages.list` with the packages you currently have installed. Start by editing this file directly, or by running `declaro edit`. The format is one package per line, with optional comments:

```bash
# Creative Software
gimp
audacity # This one is for Audio
blender

# Programming
bash
gcc
neovim # My favorite text editor
```

### Main Commands

- **`declaro clean`**: Removes all stray packages (installed packages not declared in `packages.list`) and installs all missing packages (packages declared in `packages.list` but not installed).
- **`declaro diff`**: Shows the difference between your current system and your `packages.list`
- **`declaro list`**: Lists all packages in your `packages.list`
- **`declaro edit`**: Opens `packages.list` in your default editor (defined by `$EDITOR`)
- **`declaro declare <pkg1> <pkg2> ...`**: Declares packages by appending them to `packages.list`
- **`declaro status <pkg1> <pkg2> ...`**: Shows the status of packages

## Install

### Manual Installation

1. **Download dependencies: (i.e. Arch Linux)**
    ```bash
    sudo pacman -S bash pacman diffutils sed xargs make sudo coreutils
    ```

2. **Clone and install:**
    ```bash
    git clone https://github.com/mantinhas/declaro.git && cd declaro && make install
    ```
