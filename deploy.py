#!/usr/bin/env python

"""
Install dotfiles into $HOME.

Run this from the dir where dotfiles.git was cloned.
"""

import os
import shutil


# filename in dotfiles -> filename in $HOME
src2dest = {
    'bashrc': '.bashrc',
    'vimrc': '.vimrc',
    'vim': '.vim',
}

if __name__ == "__main__":
    dotfiles_dir = os.getcwd()
    home_dir = os.path.expanduser('~')
    os.chdir(home_dir)
    for src, dest in src2dest.iteritems():
        src_path = os.path.join(dotfiles_dir, src)
        if not os.path.exists(src_path):
            raise RuntimeError("Could not find dotfile {}.".format(src_path))
        dest_path = os.path.join(home_dir, dest)
        if os.path.exists(dest_path):
            dest_path_old = dest_path + '.old'
            shutil.move(dest_path, dest_path_old)
            print " -> moved {} to {}".format(dest_path, dest_path_old)
        # TODO: figure out a way to use relpaths, not abspaths for these links.
        os.symlink(src_path, dest)
        print " -> linked {} as {}".format(src_path, dest_path)

    print "Done."
