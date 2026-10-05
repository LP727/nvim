# NVIM Config
Current setings to quickly deploy my nvim environment accross multiple workspace.

## Support
This setup is designed to use nvim for the following programing languages:
- Rust

## Steps
To get nvim working the the following steps to get Neovim running with the support

### Install Neovim
1. Download the latest Neovim version from: https://github.com/neovim/neovim/releases
2. Extract the binaries into your .local using:
```bash
tar -xf nvim-linux-x86_64.tar.gz -C ~/.local/nvim/
```
3. Create symlink to the binary (to launch from nvim in shell)
```bash
ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/
```

### Update Neovim
To update your neovim version, download and extract the new version and overide the previous install.

### Install Rust
1. Install rust from the rustup provider
```bash
sudo apt install rustup
rustup default stable
rustup component add rust-analyzer
```
