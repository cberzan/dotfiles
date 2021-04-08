My config files for bash, vim, etc.

## How to set up on a new machine:

```console
git clone https://github.com/cberzan/dotfiles.git
cd dotfiles
./deploy.py
# then there are some manual steps at the bottom of deploy.py
```

## To set up with push access:

Add the machine's ssh key to github config, then clone from
`git@github.com:cberzan/dotfiles.git` instead of the HTTPS URL.
Alternatively, edit the URL in `.git/config`.


## How to add a neovim package

```console
cd nvim-packages
git submodule add https://github.com/kana/vim-arpeggio.git
```
