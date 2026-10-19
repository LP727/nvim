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

### Install Neovim
1. Download the latest Neovim version from: https://github.com/neovim/neovim/releases

```bash
cd ~/Downloads/
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
```

2. Extract the binaries into your .local using:
```bash
tar -xf nvim-linux-x86_64.tar.gz -C ~/.local/
mv ~/.local/nvim-linux-x86_64 ~/.local/nvim
```

3. Create symlink to the binary (to launch from nvim in shell)
```bash
ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/
```

### Update Neovim

To update your neovim version, remove your existing install and reperform the install steps above.

```bash
rm -rf ~/.local/nvim
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz | tar -xz -C ~/.local
mv ~/.local/nvim-linux-x86_64 ~/.local/nvim
```

### Install LLVM (clang, clang-format)
1. Download the latest release of LLVM:
```bash
curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.3/LLVM-23.1.3-Linux-X64.tar.xz
```
2. Extract under "~/.local"
```bash
tar -xf LLVM-23.1.3-Linux-X64.tar.xz -C ~/.local/
```
3.  Create symlink between the binary and PATH
```bash
ln -sf ~/.local/LLVM-23.1.3-Linux-X64/bin/clang-format ~/.local/bin/
ln -sf ~/.local/LLVM-23.1.3-Linux-X64/bin/clangd ~/.local/bin/
ln -sf ~/.local/LLVM-23.1.3-Linux-X64/bin/clang ~/.local/bin/
ln -sf ~/.local/LLVM-23.1.3-Linux-X64/bin/clang++ ~/.local/bin/
```

### Update LLVM 
```bash
curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-NEW/LLVM-NEW-Linux-X64.tar.xz
tar -xf LLVM-NEW-Linux-X64.tar.xz -C ~/.local/
for t in clang clang++ clang-format clangd; do ln -sf ~/.local/LLVM-NEW-Linux-X64/bin/$t ~/.local/bin/; done
rm -rf ~/.local/LLVM-OLD-Linux-X64
```

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
