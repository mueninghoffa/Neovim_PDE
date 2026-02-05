# Installation

Steps to get the environment fully set up.

## Requirements

These programs and tools are required.

### Node.js & npm

#### Windows

```bash
# Download and install Chocolatey:
powershell -c "irm https://community.chocolatey.org/install.ps1|iex"

# Download and install Node.js:
choco install nodejs --version="24.13.0"

# Verify the Node.js version:
node -v # Should print "v24.13.0".

# Verify npm version:
npm -v # Should print "11.6.2".
```

#### Linux

```bash
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 24

# Verify the Node.js version:
node -v # Should print "v24.13.0".

# Verify npm version:
npm -v # Should print "11.6.2".
```

### Conda

Install the environment manager anaconda or miniconda. You can download the installers for these from anaconda.com/download/success or install them with commands below.

#### Windows

Install with chocolatey.

```bash
choco install miniconda3
```

#### Linux

Download the installer and run it.

```bash
# Download installer
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# Run the installation bash script
bash Miniconda3-latest-Linux-x86_64.sh

# Follow the on-screen prompts

# Refresh terminal
source ~/.bashrc

# Verify installation
conda --version
```

### Neovim

Install Neovim itself.

#### Windows

Install with chocolatey.

```bash
choco install neovim
```

#### Linux

Download and install pre-built binaries.

```bash
# Download from github
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

# Remove current install, if it exists
sudo rm -rf /opt/nvim-linux-x86_64

# Unpack the binaries
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# Delete compressed file
rm ./nvim-linux-x86_64.tar.gz
```

Then, add neovim to your shell configuration.

```bash
# Add this to your ~/.bashrc or similar
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

### Other tools

The rest of the tools can be installed with just chocolatey or apt.

```bash
# Windows: in powershell with admin privileges
choco install mingw ripgrep fd git

# Restart your shell after installing mingw to ensure gcc is found.

# Linux:
sudo apt install build-essential ripgrep fd-find xclip git

# CRITICAL: fix "fd" name for Neovim & Telescope (plugin) by creating a symlink
mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd
```
If you are using Windows Subsystem for Linux (WSL2), skip `xclip`. Instead, install `win32yank` on windows using chocolatey (install in Powershell, not WSL). Neovim should automatically detect it.

### Nerd font

You will need to install a nerd font for the extended set of symbols used by dap and other plugins. Any nerd font can be chosen, `bitstreamverasansmono`/`BitstromWera` is just an example.

#### Windows

Install with chocolatey

```bash
choco install nerd-fonts-bitstreamverasansmono
```

#### Linux

Download from the github and unzip into the appropriate directory.

```bash
# Make fonts directory if it doesn't exist
mkdir -p ~/.local/share/fonts

# Go to the fonts directory
cd ~/.local/share/fonts

# Download the nerd font
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/BitstreamVeraSansMono.tar.xz

# Unpack font
tar -xvJf BitstromWera.tar.xz

# Delete the compressed file
rm ./BitstromWera.tar.xz

# Refresh the font cache
fc-cache -fv
```

#### Configure terminal

Configure your terminal to use the new font.

For windows terminals (powershell, command prompt, WSL Ubuntu), the font is set in the "Appearance" settings for each profile.

## Neovim config

Clone this repository into the appropriate nvim directory.

```bash
# Windows
git clone https://github.com/mueninghoffa/Neovim_PDE $env:LOCALAPPDATA\nvim

# Linux
git clone https://github.com/mueninghoffa/Neovim_PDE ~/.config/nvim
```
## Conda environment

Create the conda environment to be used by the neovim backend.

```bash
# Windows
conda env create --file $env:LOCALAPPDATA\nvim\neovim_env.yml

# Linux
conda env create --file ~/.config/nvim/neovim_env.yml
```

## Run Neovim

Open neovim with the command `nvim`. The first time Neovim is opened, it should automatically install the package managers Lazyvim and Mason, which will themselves install many packages. The full list of installed plugins is in `lazy-lock.json`.

### Manually install treesitter languages
For reasons I do not know, treesitter refuses to automatically install the languages listed in its config function. Manually install a language with the command `:TSInstall <language>`.
