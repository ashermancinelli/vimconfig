# vimconfig

Lots and lots of different configurations for various programs all wrapped up into one repo. Under heavy development so tread with some caution :)

## How to use

The top directory has a script to deal with installation - you should pretty much only interact with the repo through that script.
The help message is quite descriptive:

```bash
$ ./configure.sh --help

  Usage:

  -p|--prefix         Sets install prefix. Default: /Users/manc568/.local
  -s|--shell-rc-path  Path to RC file for given shell. Default: /Users/manc568/.bashrc
  -d|--default        Installs ctags, vim, and bash
  --show              Show installation script for pacakge
  -i|--install        One or more of the following list, separated by commas with no spaces:

       zsh
       bash
       ctags
       vim
       tmux
       emacs
       profiles
       modules
       rice
       rice.sh
       fresh
```

## Examples

For example, to just install my vim configuration, you'd do:

```bash
$ ./configure.sh --install vim
```

Or to install configs for multiple programs:

```bash
$ ./configure.sh --install vim,ctags,tmux,emacs,bash
```
