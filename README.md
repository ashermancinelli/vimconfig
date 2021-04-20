# vimconfig

Lots and lots of different configurations for various programs all wrapped up into one repo. Under heavy development so tread with some caution :)

## How to use

The top directory has a script to deal with installation - you should pretty much only interact with the repo through that script.
The help message is quite descriptive:

```bash
$ ./configure --h

  Usage:

  -p <path>           Sets install prefix. Default: /people/manc568/.local
  -r <path>           Path to RC file for given shell. Default: /qfs/people/manc568/.bashrc
  -d                  Default installation. Installs ctags, vim, and bash
  -s <pkg>            Show installation script for pacakge
  -i                  One or more of the following list, separated by commas with no spaces:

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
$ ./configure -i vim
```

Or to install configs for multiple programs:

```bash
$ ./configure -i vim,ctags,tmux,emacs,bash
```
