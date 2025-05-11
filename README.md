# declaro - a simple declarative wrapper for any package manager

## 🚀 Why This Project Exists

- **🚧 The Problem:** Desktop Linux systems accumulate unnecessary packages over time — apps installed briefly, forgotten, and left to clutter your system. This is a nightmare for small disks and system hygiene (run `pacman -Qq | wc -l` to see how many packages you have installed).

- **🤔 Why Current Solutions Fall Short:** Tools like NixOS are powerful but overly complex for users who don’t need complete reproducibility - just a clutter-free system.

- **💡 Our Solution:** A powerful declarative package manager wrapper that:
    - ✅ Lets you define a clean "reset state" for your system
    - 🔄 Provides tools to manage and reset your system back to that declarative state
    - 📝 Forces you to explicitly define what you want to keep, rather than what you want to remove

## Usage

### Define Your Clean System State

First, start by generating the packages list from the current list of explicitly installed packages:

```bash
sudo declaro generate
```

This will create the `packages.list` file in `/etc/declaro/packages.list` (you can change this location in the config file). Then, you may edit this file either manually:

```bash
sudo nano /etc/declaro/packages.list
```

Or by running:

```bash
declaro edit
```

Here, you can add packages you want to keep permanently, or delete packages you no longer require. The `packages.list` file format is one package per line, with optional comments:

```bash
# Creative Software
gimp
audacity # This one is for audio
blender

# Programming
bash
gcc
neovim # My favorite text editor
```

### Main Commands

- **`declaro clean`**: Removes all stray packages (installed packages not declared in `packages.list`) and installs all missing packages (packages declared in `packages.list` but not installed)
- **`declaro diff`**: Shows the difference between your current system and your `packages.list`
- **`declaro list`**: Lists all packages in your `packages.list`
- **`declaro edit`**: Opens `packages.list` in your default editor (defined by `$EDITOR`)
- **`declaro declare <pkg1> <pkg2> ...`**: Declares packages by appending them to `packages.list`
- **`declaro status <pkg1> <pkg2> ...`**: Shows the status of packages

## Install

### Automatic Installation

- For **Arch Linux**, you can download `declaro` from the AUR:
```bash
git clone https://aur.archlinux.org/declaro-git.git && cd declaro-git && makepkg -si
```

### Manual Installation

- For **Arch Linux (pacman)**:
```bash
sudo pacman -S bash diffutils sed findutils make sudo coreutils && \
git clone https://github.com/mantinhas/declaro.git && cd declaro && make install && \
sudo install -Dm644 /usr/local/share/declaro/config/pacman-config.sh /etc/declaro/config.sh
```

- For **Arch Linux (pacman and yay)**:
```bash
sudo pacman -S bash diffutils sed findutils make sudo coreutils && \
git clone https://github.com/mantinhas/declaro.git && cd declaro && make install && \
sudo install -Dm644 /usr/local/share/declaro/config/pacman-yay-config.sh /etc/declaro/config.sh
```

- For **Ubuntu**:
```bash
sudo apt install bash diffutils sed findutils make sudo coreutils && \
git clone https://github.com/mantinhas/declaro.git && cd declaro && make install && \
sudo install -Dm644 /usr/local/share/declaro/config/apt-config.sh /etc/declaro/config.sh
```

- For non-supported package managers:
    1. Download and install the corresponding dependencies and declaro repo
    2. Copy the template config file:
        ```bash
        sudo install -Dm644 /usr/local/share/declaro/config/template-config.sh /etc/declaro/config.sh
        ```
    3. Edit the config file to match your package manager's commands. The config file is well-commented, so you should be able to figure it out easily.
