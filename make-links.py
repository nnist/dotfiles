# TODO Print created links by default
# TODO Prevent making symlink in .vim directory
# TODO Create directories if they don't exist
# TODO Store sources and targets in dict?

import subprocess
import logging as log
import sys
import os
import argparse

HOME_DIR = os.path.expanduser('~') + '/'
SOURCES = ['.bash_aliases', '.bashrc',
           '.bash_completion.d/task.sh',
           '.dircolors', '.gitignore', '.pylintrc',
           '.tmux.conf', '.vim', '.vimrc', '.xinitrc',
           'termux.properties', '.config/i3', '.config/rofi',
           '.config/alacritty/alacritty.yml']
TARGETS = ['bash/.bash_aliases', 'bash/.bashrc',
           'bash/.bash_completion.d/task.sh',
           'bash/.dircolors', '.gitignore', 'pylint/.pylintrc',
           'tmux/.tmux.conf', 'vim/.vim', 'vim/.vimrc',
           'xorg/.xinitrc', 'termux/termux.properties', 'i3',
           'rofi', 'alacritty/alacritty.yml']
DOTFILES_DIR = HOME_DIR + 'git/dotfiles/'


def make_links(force=False):
    """Create symlinks."""
    num_success = 0
    num_failed = 0

    for source in enumerate(SOURCES):
        target = DOTFILES_DIR + TARGETS[source[0]]
        link = HOME_DIR + source[1]
        options = ''
        if force:
            options += 'f'

        process = subprocess.run(['ln', '-s' + options, target, link],
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE)
        if process.returncode == 0:
            num_success += 1
            log.info("Made link from '%s' to '%s'.", link, target)
        else:
            num_failed += 1
            log.info("Could not make link from '%s' to '%s'.", link, target)

    return num_success, num_failed


def main(argv):
    """Create links in ~/ to dotfiles."""
    parser = argparse.ArgumentParser(
        description="""Create links in ~/ to dotfiles."""
    )
    parser.add_argument(
        '-v', '--verbose', help="verbose mode", action='store_true'
    )
    parser.add_argument(
        '-f', '--force', help="force overwriting links", action='store_true'
    )
    args = parser.parse_args(argv)

    if args.verbose:
        log.basicConfig(format="%(levelname)s: %(message)s", level=log.INFO)
        log.info("Verbose output.")
    else:
        log.basicConfig(format="%(levelname)s: %(message)s")

    if args.force:
        log.info('Force overwriting links.')

    num_success, num_failed = make_links(args.force)
    print('Done. Created {}/{} links.'.format(num_success, num_failed))


if __name__ == "__main__":
    try:
        main(sys.argv[1:])
    except KeyboardInterrupt:
        print('Interrupted by user.')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)  # pylint: disable=protected-access
