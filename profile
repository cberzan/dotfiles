# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Hack to make trash work (somewhat) with btrfs subvolumes.
if [ -d "/opt/glib-2.80" ]; then
    if [ "$(dpkg-query --showformat='${Version}' --show libglib2.0-bin)" = "2.80.0-6ubuntu3.4" ]; then
        export PATH=/opt/glib-2.80/bin:$PATH
        export LD_LIBRARY_PATH=/opt/glib-2.80/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
        export PKG_CONFIG_PATH=/opt/glib-2.80/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
        export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules
    else
        # In this case we may need to re-patch and rebuild a different version of glib.
        echo "WARNING: Installed version of glib has changed; skipping the trash workaround."
    fi
fi

_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
