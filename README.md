# NVIM Config
Current setings to quickly deploy my nvim environment accross multiple workspace.

## Prerequisite
The following dependcies need to be installed:
- git
- xclip
- gcc or clang (C compiler for tree-sitter)

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
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
```

2. Extract the binaries into your .local using:
```bash
tar -xf nvim-linux-x86_64.tar.gz -C ~/.local/
mv ~/local/nvim-linux-x86_64 ~/.local/nvim
```

3. Create symlink to the binary (to launch from nvim in shell)
```bash
ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/
```

### Update Neovim

To update your neovim version, remove your existing install and reperform the install steps above.

```bash
rm -rf ~/.local/nvim
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
ln -sf ~/.local/LLVM-23.1.3-Linux-X64/bin/lldb-dap ~/.local/bin/
```


### Install Rust
1. Install rust from the rustup provider
```bash
sudo apt install rustup
rustup default stable
rustup component add rust-analyzer
cargo install --locked tree-sitter-cli
cargo install --locked fd-find
```

2. add "export PATH="$HOME/.cargo/bin:$PATH"

3. configure clang as the rustc linker
In ~/.cargo/config.toml write:
```
[target.x86_64-unknown-linux-gnu]
linker = "clang"

[env]
CC = "clang"
CXX = "clang++"
```

### Install the formatters
The current formatting.lua supports a variety of file types, so support them all, run:
```bash
cargo install --locked stylua taplo-cli
pip install black
pip install isort
sudo apt install shfmt
npm install -g prettier @fsouza/prettierd
```

### First Launch
Run ":Lazy restore" to restore the lazy-lock.json inside Neovim.

### Verify Setup
Open nvim and perform a ":checkhealth rustaceanvim"
