#!/usr/bin/env python3

"""
Install dotfiles into $HOME.

Run this from the dir where dotfiles.git was cloned.
"""

import errno
import os
import shutil
import subprocess


def mkdir_p(path):
    """
    Like mkdir -p.

    From http://stackoverflow.com/a/600612/744071.
    """
    try:
        os.makedirs(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise


# filename in dotfiles -> filename in $HOME
src2dest = {
    'bashrc': '.bashrc',
    'gitconfig': '.gitconfig',
    'gitignore': '.gitignore',
    'inputrc': '.inputrc',
    'less': '.less',
    'lesskey': '.lesskey',
    'init.vim': '.config/nvim/init.vim',
    'nvim-packages': '.local/share/nvim/site/pack/cberzan/start',
    # TODO: Re-enable this if useful.
    # 'ipython_config.py': '.config/ipython/profile_default/ipython_config.py',
}

if __name__ == "__main__":
    # Fetch submodules.
    subprocess.call(["git", "submodule", "init"])
    subprocess.call(["git", "submodule", "update"])

    # Install dotfiles. (Assumes cwd is the dotfiles dir.)
    dotfiles_dir = os.getcwd()
    home_dir = os.path.expanduser('~')
    os.chdir(home_dir)
    for src, dest in src2dest.items():
        src_path = os.path.join(dotfiles_dir, src)
        if not os.path.exists(src_path):
            raise RuntimeError("Could not find dotfile {}.".format(src_path))
        dest_path = os.path.join(home_dir, dest)
        if os.path.lexists(dest_path):
            dest_path_old = dest_path + '.old'
            shutil.move(dest_path, dest_path_old)
            print(" -> moved {} to {}".format(dest_path, dest_path_old))

        # Create parent directory.
        head = os.path.split(dest)[0]
        if head:
            mkdir_p(head)

        # Symlink dotfile.
        # TODO: figure out a way to use relpaths, not abspaths for these links.
        os.symlink(src_path, dest)
        print(" -> linked {} as {}".format(src_path, dest_path))

    # TODO: automate the steps below.
    #
    # These need to be run from within nvim:
    #   :helptags ~/.local/share/nvim/site/pack/cberzan/start/vim-arpeggio/doc
    #   :helptags ~/.local/share/nvim/site/pack/cberzan/start/command-t/doc
    #
    # These need to be run from a shell:
    #   sudo apt install build-essential ruby ruby-dev
    #   sudo gem install neovim
    #   cd ~/.local/share/nvim/site/pack/cberzan/start/command-t/ruby/command-t/ext/command-t
    #   ruby extconf.rb
    #   make
    #
    # LEFT TODO: check if bashrc needs updating w.r.t. latest mint defaults

    print("Done.")
