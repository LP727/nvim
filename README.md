# NVIM Config
Current setings to quickly deploy my nvim environment accross multiple workspace.

## Prerequisite
The following dependcies need to be installed:
- git
- xclip
- gcc or clang (C compiler for tree-sitter)
- unzip
- npm 
- python3-venv

## Support
This setup is designed to use nvim for the following programing languages:
- Rust

## Steps
To get nvim working the the following steps to get Neovim running with the support

### Clone this repo:
Clone the repo in "~/.config/nvim"
```bash
cd ~/.config
git clone git@github.com:LP727/nvim.git
```

### Install the apt packages
The following dependencies can be installed from an apt install command: 
```bash
sudo apt install git xclip unzip npm python3-venv
```

### Install Neovim
1. Download the latest Neovim version from: https://github.com/neovim/neovim/releases

```bash
cd ~/Downloads/
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
```

2. Extract the binaries into your .local using:
```bash
rm -rf ~/.local/nvim && mkdir -p ~/.local/nvim
tar -xf nvim-linux-x86_64.tar.gz -C ~/.local/nvim --strip-components=1
```

3. Create symlink to the binary (to launch from nvim in shell)
```bash
ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/
```

### Update Neovim

To update your neovim version, run the [Install Neovim](#install-neovim) steps.

### Install LLVM 
Installs: clang, clang++, clang-format and clangd
1. Download the latest release of LLVM:
```bash
# figure out the latest version
ver=$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/llvm/llvm-project/releases/latest | sed 's|.*/llvmorg-||')
echo "$ver"   # sanity check, should print something like 23.1.3
curl -LO "https://github.com/llvm/llvm-project/releases/download/llvmorg-$ver/LLVM-$ver-Linux-X64.tar.xz"
```
2. Extract under "~/.local"
```bash
rm -rf ~/.local/llvm && mkdir -p ~/.local/llvm
tar -xf "LLVM-$ver-Linux-X64.tar.xz" -C ~/.local/llvm --strip-components=1
```
3.  Create symlink between the binary and PATH
```bash
for t in clang clang++ clang-format clangd; do ln -sf ~/.local/llvm/bin/$t ~/.local/bin/; done
```

### Update LLVM

To update LLVM, run the [Install LLVM](#install-llvm) steps.

### Install Rust
1. Install rust from the rustup provider
```bash
sudo apt install rustup
rustup default stable
rustup component add rust-analyzer
```

2. Configure clang as the rustc linker
In ~/.cargo/config.toml write:
```
[target.x86_64-unknown-linux-gnu]
linker = "clang"

[env]
CC = "clang"
CXX = "clang++"
```

3. Install tree-sitter-cli and fd-find
```bash
cargo install --locked tree-sitter-cli
cargo install --locked fd-find
```

4. Add "export PATH="$HOME/.cargo/bin:$PATH" in ~/.bashrc

### Update Rust
To update Rust, simply run:
```bash
rustup update
```

### Install Nerdfont "Plemo1JP Console NF"
Nerfont allows DAP ui to have proper icons, plus this specific one has kanji support

1. Install latest Nerfont for PlemolJP (copying Takuya Matsuyama)
```bash
ver=$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/yuru7/PlemolJP/releases/latest | sed 's|.*/||')
echo $ver # sanity check, expect v3.1.0 or higher
rm -rf ~/.local/share/fonts/plemoljp && mkdir -p ~/.local/share/fonts/plemoljp
curl -fL -o /tmp/plemoljp_nf.zip \
  "https://github.com/yuru7/PlemolJP/releases/download/$ver/PlemolJP_NF_$ver.zip"
unzip -j -o /tmp/plemoljp_nf.zip "*.ttf" -d ~/.local/share/fonts/plemoljp
rm /tmp/plemoljp_nf.zip
fc-cache -f
fc-list | grep "PlemolJP Console NF"
```

2. Install programing symbols
```bash
set -e
tmp=$(mktemp -d)
curl -fL -o "$tmp/symbols.tar.xz" \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.tar.xz
rm -rf ~/.local/share/fonts/nerdsymbols && mkdir -p ~/.local/share/fonts/nerdsymbols
tar -xJf "$tmp/symbols.tar.xz" -C ~/.local/share/fonts/nerdsymbols
rm -rf "$tmp"
fc-cache -f
fc-list | grep "Symbols Nerd Font Mono"
```

3. Updating
Update can be performed by following the install scripts from step 1 & 2

### First Launch
- Run ":Lazy restore" to restore the lazy-lock.json inside Neovim.
- Wait for install of lazy, mason and tree-sitter, then restart Neovim.

### Verify Setup
Open nvim and perform checks with
- ":checkhealth rustaceanvim"
- ":checkhealth mason"
- ":checkhealth nvim-treesitter"
- ":checkhealth vim.lsp"

Or a broad: ":checkhealth"

### Updating Neovim setup
Inside Neovim
```bash
:Lazy update
:MasonToolsUpdate
:TSUpdate
```
Commit "lazy-lock.json" after performing ":Lazy update"

### Debug configs per project (Rust)

To enable a debug config in a rust project, create a `.nvim.lua` in the project root (next to `Cargo.toml`):

```lua
local dap = require("dap")
dap.configurations.rust = dap.configurations.rust or {}
table.insert(dap.configurations.rust, {
	name = "Debug (my project)",
	type = "codelldb",
	request = "launch",
	program = require("utils.cargo_dap").program, -- see lua/utils/cargo_dap.lua, included in lua/pluggins/dap.lua
	cwd = "${workspaceFolder}",
	terminal = "external", -- see dap.lua for config
	env = { RUST_LOG = "debug" },
})
```
