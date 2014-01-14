#!/usr/bin/env python

"""
Install dotfiles into $HOME.

Run this from the dir where dotfiles.git was cloned.
"""

import os
import shutil
import subprocess


# filename in dotfiles -> filename in $HOME
src2dest = {
    'bashrc': '.bashrc',
    'gitconfig': '.gitconfig',
    'gitignore': '.gitignore',
    'inputrc': '.inputrc',
    'less': '.less',
    'lesskey': '.lesskey',
    'vim': '.vim',
    'vimrc': '.vimrc',
}

if __name__ == "__main__":
    # Update submodules.
    subprocess.call(["git", "submodule", "update", "--init"])

    # Install dotfiles.
    dotfiles_dir = os.getcwd()
    home_dir = os.path.expanduser('~')
    os.chdir(home_dir)
    for src, dest in src2dest.iteritems():
        src_path = os.path.join(dotfiles_dir, src)
        if not os.path.exists(src_path):
            raise RuntimeError("Could not find dotfile {}.".format(src_path))
        dest_path = os.path.join(home_dir, dest)
        if os.path.lexists(dest_path):
            dest_path_old = dest_path + '.old'
            shutil.move(dest_path, dest_path_old)
            print " -> moved {} to {}".format(dest_path, dest_path_old)
        # TODO: figure out a way to use relpaths, not abspaths for these links.
        os.symlink(src_path, dest)
        print " -> linked {} as {}".format(src_path, dest_path)

    # TODO: Automate the following post steps for Command-T:
    #   cd ~/.vim/bundle/command-t/ruby/command-t
    #   ruby extconf.rb
    #   make

    print "Done."
