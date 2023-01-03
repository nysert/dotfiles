- [Install oh-my-sh](https://ohmyz.sh/)
- [Install Powerline Fonts](https://github.com/powerline/fonts)

# pure
[manual install](https://github.com/sindresorhus/pure#manually)
```bash
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
```

# Neovim symlink
```bash
  mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
  ln -s ~/.vim $XDG_CONFIG_HOME/nvim
  ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
```
