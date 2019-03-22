# TODO Prevent making symlink in .vim directory

import subprocess
import logging as log
import sys
import os
import argparse

files = ['bash/.bash_aliases', 'bash/.bashrc',
         'bash/.bash_completion.d/task.sh',
         '.dircolors', '.gitignore', '.pylintrc',
         '.taskrc', '.tmux.conf', '.vim', '.vimrc', '.xinitrc']
home_dir = os.path.expanduser('~') + '/'
dotfiles_dir = home_dir + 'git/dotfiles/'

def make_links():
    num_success = 0
    num_failed = 0
    
    for filename in files:
        target = dotfiles_dir + filename
        link = home_dir + filename
        process = subprocess.run(['ln', '-s', target, link],
                                 stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if process.returncode == 0:
            num_success += 1
            log.info("Made link from '{}' to '{}'.".format(link, target))
        else:
            num_failed += 1
            log.info("Could not make link from '{}' to '{}'."
                     .format(link, target))

    return num_success, num_failed


def main(argv):
    """Create links in ~/ to dotfiles."""
    parser = argparse.ArgumentParser(
        description="""Create links in ~/ to dotfiles."""
    )
    parser.add_argument(
        '-v', '--verbose', help="verbose mode", action='store_true'
    )
    args = parser.parse_args(argv)

    if args.verbose:
        log.basicConfig(format="%(levelname)s: %(message)s", level=log.INFO)
        log.info("Verbose output.")
    else:
        log.basicConfig(format="%(levelname)s: %(message)s")

    num_success, num_failed = make_links()
    print('Done. Made {} new links.'.format(num_success))

if __name__ == "__main__":
    try:
        main(sys.argv[1:])
    except KeyboardInterrupt:
        print('Interrupted by user.')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0) # pylint: disable=protected-access
